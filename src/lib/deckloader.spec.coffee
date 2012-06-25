DeckLoader = require('./deckloader').DeckLoader

describe 'deckloader', ->

  it 'can load a known deck from a .deck file', ->
    # we know the test file contains 61 cards
    testDeck = DeckLoader.loadFromDeckFile( __dirname + '/test.deck' )
    (expect testDeck.size()).toEqual 61

  it "returns null when a file can't be read", ->
    testDeck = DeckLoader.loadFromDeckFile( __dirname + '/bad-file' )
    (expect testDeck).toBe(null)
