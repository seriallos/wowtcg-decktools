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

  it 'can count monster cards', ->
    (expect @deckalyzer.count( { factions: ['monster'] } )).toEqual 21

  it 'throws an exception on an unsupported operator', ->
    testCall = () ->
      @deckalyzer.count( { cost: { 'LAZOR B33M': 22 } } )
    expect(testCall).toThrow()

  it 'handles $gt operator', ->
    (expect @deckalyzer.count( { cost: { '$gt' : 6 } } )).toEqual 0
    (expect @deckalyzer.count( { cost: { '$gt' : 2 } } )).toEqual 32
    (expect @deckalyzer.count( { cost: { '$gt' : -1 } } )).toEqual 61

  it 'handles $gte operator', ->
    (expect @deckalyzer.count( { cost: { '$gte' : 7 } } )).toEqual 0
    (expect @deckalyzer.count( { cost: { '$gte' : 3 } } )).toEqual 32
    (expect @deckalyzer.count( { cost: { '$gte' : 0 } } )).toEqual 61

  it 'handles $lt operator', ->
    (expect @deckalyzer.count( { cost: { '$lt' : 7 } } )).toEqual 61
    (expect @deckalyzer.count( { cost: { '$lt' : 0 } } )).toEqual 0
    (expect @deckalyzer.count( { cost: { '$lt' : 3 } } )).toEqual 29

  it 'handles $lte operator', ->
    (expect @deckalyzer.count( { cost: { '$lte' : 6 } } )).toEqual 61
    (expect @deckalyzer.count( { cost: { '$lte' : -1 } } )).toEqual 0
    (expect @deckalyzer.count( { cost: { '$lte' : 2 } } )).toEqual 29

  it 'can combine operators', ->
    (expect @deckalyzer.count( { cost: { '$gte' : 1, '$lte': 2 } } )).toEqual 17
    (expect @deckalyzer.count( { cost: { '$gte' : 0, '$lte': 6 } } )).toEqual 61
    (expect @deckalyzer.count( { cost: { '$lte' : 6, '$gte': 0 } } )).toEqual 61

  it 'handles not equals operator, $ne', ->
    (expect @deckalyzer.count( { cost: { '$ne' : 1 } } )).toEqual 57
    (expect @deckalyzer.count( { name: { '$ne' : 'Entangling Roots' } } )).toEqual 59

  it 'handles the $in operator', ->
    (expect @deckalyzer.count( { cost: { '$in' : [1, 2] } } )).toEqual 17
    (expect @deckalyzer.count( { cost: { '$in' : [1, 6] } } )).toEqual 10

  it 'handles the $nin operator', ->
    (expect @deckalyzer.count( { cost: { '$nin' : [0,3,4,5,6] } } )).toEqual 17
    (expect @deckalyzer.count( { cost: { '$nin' : [1, 6] } } )).toEqual 51

  it 'handles the $regex operator', ->
    (expect @deckalyzer.count( { name: { '$regex' : /Jadefire/ } } )).toEqual 11
    (expect @deckalyzer.count( { name: { '$regex' : /gnash/i } } )).toEqual 1

  it 'can find a value in an array', ->
    (expect @deckalyzer.count( { races: 'demon' } )).toEqual 11
    (expect @deckalyzer.count( { races: 'ancient' } )).toEqual 3
    (expect @deckalyzer.count( { factions: 'horde' } )).toEqual 7
    (expect @deckalyzer.count( { classes: 'warrior' } )).toEqual 4

  it 'can use the $exists operator', ->
    (expect @deckalyzer.count( { conspicuous: {$exists: 1} } )).toEqual 2
    (expect @deckalyzer.count( { conspicuous: {$exists: 0} } )).toEqual 59

  # distinct tests
  it 'can get distinct costs', ->
    expected_costs = {
      0: 12,
      1: 4,
      2: 13,
      3: 12,
      4: 10,
      5: 4,
      6: 6
    }
    distinct_costs = @deckalyzer.distinct( 'cost' )
    (expect distinct_costs).toEqual expected_costs

  it 'get distinct for a key and apply a filter', ->
    expected_jadefire_classes = {
      hunter: 2,
      warrior: 1,
      rogue: 4,
      warlock: 4
    }
    result = @deckalyzer.distinct( 'classes', { name: { '$regex' : /jadefire/i } } )
    (expect result).toEqual expected_jadefire_classes

  it 'distinct properly counts array values', ->
    expected = {
      satyr: 11,
      demon: 11
    }
    result = @deckalyzer.distinct( 'races', { name: { '$regex' : /jadefire/i } } )
    # not yet working
    # (expect result).toEqual expected



