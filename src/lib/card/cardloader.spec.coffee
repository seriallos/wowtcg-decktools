CardLoader = require('./cardloader').CardLoader

describe 'cardloader', ->

  it 'can load a set from a .json file', ->
    # check starting conditions
    (expect CardLoader.GetCard('Gnash')).toBe(null)
    (expect CardLoader.IsSetLoaded('test')).toBe(false)

    # load it
    CardLoader.LoadSet( 'test' )
    (expect CardLoader.IsSetLoaded('test')).toBe(true)
    (expect CardLoader.IsSetLoaded('TEST')).toBe(true)

    # we know the test file contains 40 cards
    (expect CardLoader.LoadedCards()).toEqual 40

    # running LoadSet again shouldn't change anything
    CardLoader.LoadSet( 'test' )
    (expect CardLoader.LoadedCards()).toEqual 40

    # ensure case insensitivity
    (expect CardLoader.GetCard('Gnash')).not.toBe(null)
    (expect CardLoader.GetCard('gnash')).not.toBe(null)
    (expect CardLoader.GetCard('GNASH')).not.toBe(null)

    # check a raw card
    gnash = CardLoader.GetCard 'Gnash'

    (expect gnash.cost).toEqual 6
    (expect gnash.attack).toEqual 4
    (expect gnash.health).toEqual 6
    (expect gnash.type).toEqual 'ally'
    (expect gnash.factions).toEqual ["monster"]

###
  it "returns null when a file can't be read", ->
    testDeck = DeckLoader.loadFromDeckFile( __dirname + '/bad-file' )
    (expect testDeck).toBe(null)
###
