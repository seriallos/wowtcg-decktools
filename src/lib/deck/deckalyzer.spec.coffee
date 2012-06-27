Deckalyzer = require('./deckalyzer').Deckalyzer
DeckLoader = require('./deckloader').DeckLoader
CardLoader = require('../card/cardloader').CardLoader
Pile       = require('./pile').Pile

describe 'deckalyzer', ->


  beforeEach () ->
    # ensure we have a loaded deck for every test
    CardLoader.LoadSet 'test'
    @testDeck = DeckLoader.loadFromDeckFile __dirname + '/test.deck'
    (expect @testDeck.size()).toEqual 61

    @deckalyzer = new Deckalyzer @testDeck
    (expect @deckalyzer).not.toBe null
    (expect @deckalyzer.deck.size()).toEqual 61

  # empty argument

  it 'returns full deck size on no argument', ->
    (expect @deckalyzer.count()).toEqual 61

  it 'returns full deck size on empty object', ->
    (expect @deckalyzer.count({})).toEqual 61

  it 'returns full deck size on null argument', ->
    (expect @deckalyzer.count( null )).toEqual 61

  # bad/nonsense arguments

  it 'returns 0 on a filter that is just a string', ->
    (expect @deckalyzer.count("I'm a string, silly")).toEqual 0

  it 'returns 0 on a filter that is a number', ->
    (expect @deckalyzer.count(9001)).toEqual 0

  it 'returns 0 on an array with values', ->
    (expect @deckalyzer.count(["foo"])).toEqual 0

  # more realer queries

  it 'can count a filter of type:quest', ->
    (expect @deckalyzer.count({type:'quest'})).toEqual 12

  it 'can count a filter of type:ally', ->
    (expect @deckalyzer.count({type:'ally'})).toEqual 28

  it 'can count a filter of type:ability', ->
    (expect @deckalyzer.count({type:'ability'})).toEqual 19

  it 'can count cost = 1', -> 
    (expect @deckalyzer.count({cost:1})).toEqual 4

  it 'returns 0 on nonsense queries like cost:"ally"', -> 
    (expect @deckalyzer.count({cost:'ally'})).toEqual 0

  it 'returns 0 on non-present search keys', ->
    (expect @deckalyzer.count({foo:'bar'})).toEqual 0

  it 'handles null value for a key', ->
    (expect @deckalyzer.count({cost:null})).toEqual 0

  it 'handles arrays as a value', ->
    (expect @deckalyzer.count( { factions: ['horde'] } )).toEqual 7

  ###
  it 'handles arrays as a value', ->
    (expect @deckalyzer.count( { cost: { '$gt' : 3 } } )).toEqual 99
  ###









