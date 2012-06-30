fs = require 'fs'
{exec} = require 'child_process'

describe 'deckotron CLI', ->

  script = __dirname + '/deckotron '
  testDeck = __dirname + '/../data/decks/famasin.deck'

  execFinished = false
  execError = null
  execStdout = null
  execStderr = null

  beforeEach ->
    execFinished = false
    execError = null
    execStdout = null
    execStderr = null

  getResponse = ( error, stdout, stderr ) ->
    execError = error
    execStdout = stdout.trim()
    execStderr = stderr.trim()
    execFinished = true

  ###*******************************
  #  Errors and warnings
  *******************************###

  it 'responds with a help message when no params given', ->
    exec script, getResponse
    waitsFor ->
      return execFinished
    runs ->
      (expect execStdout).toMatch(/Usage:/)

  it 'responds with a help message when using -h flag', ->
    exec script + '-h', getResponse
    waitsFor ->
      return execFinished
    runs ->
      (expect execStdout).toMatch(/Usage:/)

  it 'responds with a help message when using --help flag', ->
    exec script + '--help', getResponse
    waitsFor ->
      return execFinished
    runs ->
      (expect execStdout).toMatch(/Usage:/)

  it 'responds with an error on a bad command on stderr', ->
    exec script + 'badcommand', getResponse
    waitsFor ->
      return execFinished
    runs ->
      (expect execStderr).toMatch(/[ERROR]/)

  it 'responds with an error on a bad flag', ->
    exec script + '-z', getResponse
    waitsFor ->
      return execFinished
    runs ->
      (expect execStderr).toMatch(/error: unknown option/)

  it 'responds with an error with "count" but a bad file', ->
    exec script + ' count /BAD/BAD/BAD/BAD', getResponse
    waitsFor ->
      return execFinished
    runs ->
      (expect execStderr).toMatch(/Unable to load/)

  it 'distinct with no deck file returns an error', ->
    exec script + ' distinct ', getResponse
    waitsFor ->
      return execFinished
    runs ->
      (expect execStderr).toMatch(/ERROR.*card attribute/)

  it 'distinct with type but no deck returns an error about needing the deck', ->
    exec script + ' distinct NOTAKEY', getResponse
    waitsFor ->
      return execFinished
    runs ->
      (expect execStderr).toMatch(/ERROR.*deck file/)

  it 'distinct with type and bad deck returns an error', ->
    exec script + ' distinct NOTAKEY /BAD/BAD/BAD/BAD', getResponse
    waitsFor ->
      return execFinished
    runs ->
      (expect execStderr).toMatch(/ERROR.*Unable to load/)

  ###*******************************
  #  Valid runs
  *******************************###

  # count

  it 'responds with the proper count with a real deck file', ->
    exec script + ' count '+testDeck, getResponse
    waitsFor ->
      return execFinished
    runs ->
      (expect execStdout).toMatch '61'
      (expect execStderr).toEqual ''

  it 'count a deck with a filter', ->
    exec script + ' count '+testDeck+' \'{"cost": 0}\'', getResponse
    waitsFor ->
      return execFinished
    runs ->
      (expect execStdout).toEqual '12'
      (expect execStderr).toEqual ''

  it 'full count with error message when a bad filter is sent', ->
    exec script + ' count '+testDeck+' \'{cost: 0}\'', getResponse
    waitsFor ->
      return execFinished
    runs ->
      (expect execStdout).toEqual '61'
      (expect execStderr).toMatch(/WARNING.*Invalid JSON/)

  # distinct

  it 'responds with proper info on a good distinct call', ->
    exec script + ' distinct cost '+testDeck, getResponse
    waitsFor ->
      return execFinished
    runs ->
      (expect execStdout).toMatch(/0: 12/)
      (expect execStdout).toMatch(/1: 4/)
      (expect execStdout).toMatch(/2: 13/)
      (expect execStdout).toMatch(/3: 12/)
      (expect execStdout).toMatch(/4: 10/)
      (expect execStdout).toMatch(/5: 4/)
      (expect execStdout).toMatch(/6: 6/)
      (expect execStderr).toEqual ''

  it 'responds with proper info with a filter on a good distinct call', ->
    exec script + ' distinct cost '+testDeck+' \'{"type":"Ally"}\'', getResponse
    waitsFor ->
      return execFinished
    runs ->
      (expect execStdout).toMatch(/1: 3/)
      (expect execStdout).toMatch(/2: 4/)
      (expect execStdout).toMatch(/3: 8/)
      (expect execStdout).toMatch(/4: 6/)
      (expect execStdout).toMatch(/5: 2/)
      (expect execStdout).toMatch(/6: 5/)
      (expect execStderr).toEqual ''

  it 'responds with proper info on a good distinct call with type key', ->
    exec script + ' distinct type '+testDeck, getResponse
    waitsFor ->
      return execFinished
    runs ->
      (expect execStdout).toMatch(/Equipment: 2/)
      (expect execStdout).toMatch(/Quest: 12/)
      (expect execStdout).toMatch(/Ability: 19/)
      (expect execStdout).toMatch(/Ally: 28/)
      (expect execStderr).toEqual ''

  it 'responds with proper info with a filter on a good distinct call with type key', ->
    exec script + ' distinct type '+testDeck+' \'{"cost":2}\'', getResponse
    waitsFor ->
      return execFinished
    runs ->
      (expect execStdout).toMatch(/Ability: 9/)
      (expect execStdout).toMatch(/Ally: 4/)
      (expect execStderr).toEqual ''

  it 'responds with empty output on a distinct call with a type that does not exist', ->
    exec script + ' distinct foobar '+testDeck, getResponse
    waitsFor ->
      return execFinished
    runs ->
      (expect execStdout).toEqual ''
      (expect execStderr).toEqual ''
