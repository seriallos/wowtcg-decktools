wowtcg = require('./wowtcg')

describe 'wowtcg', ->

  it 'can work with piles', ->
    pile = new wowtcg.Pile
    (expect pile).not.toBe(null)
    (expect pile instanceof wowtcg.Pile).toBe(true)

  it 'can work with cards', ->
    card = new wowtcg.Card
    (expect card).not.toBe(null)
    (expect card instanceof wowtcg.Card).toBe(true)

  it 'can work with ally cards', ->
    allycard = new wowtcg.AllyCard
    (expect allycard).not.toBe(null)
    (expect allycard instanceof wowtcg.AllyCard).toBe(true)
    (expect allycard instanceof wowtcg.Card).toBe(true)

  it 'can load a deck from a deck file', ->
    wowtcg.CardLoader.LoadSet( 'test' )
    deck = wowtcg.DeckLoader.loadFromDeckFile( __dirname + '/deck/test.deck' )
    (expect deck.size()).toEqual 61
