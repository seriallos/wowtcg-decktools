DeckLoader = require('./deckloader').DeckLoader
CardLoader = require('../card/cardloader').CardLoader

describe 'deckloader', ->

  it "throws an exception if no card sets have been loaded", ->
    loaderCall = () ->
      DeckLoader.loadFromDeckFile( __dirname + '/bad-file' )
    expect(loaderCall).toThrow()

  it 'can load a known deck from a .deck file', ->
    # make sure we load the test card set
    CardLoader.LoadSet 'test'

    # we know the test file contains 61 cards
    testDeck = DeckLoader.loadFromDeckFile( __dirname + '/test.deck' )
    (expect testDeck.size()).toEqual 61

  it "returns null when a file can't be read", ->
    # make sure we load the test card set
    CardLoader.LoadSet 'test'

    testDeck = DeckLoader.loadFromDeckFile( __dirname + '/bad-file' )
    (expect testDeck).toBe(null)

