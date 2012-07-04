wowtcg     = require(__dirname + '/../../lib/wowtcg' )
fs         = require('fs')

Deckalyzer = wowtcg.Deckalyzer
DeckLoader = wowtcg.DeckLoader
CardLoader = wowtcg.CardLoader
Pile       = wowtcg.Pile

describe 'deckalyzer', ->


  beforeEach () ->
    # ensure we have a loaded deck for every test
    writeTestFiles()

    CardLoader.loadCardsFromFile testCardsFile
    dl = new DeckLoader()
    dl.loadFromDeckFile testDeckFile
    waitsFor ->
      return dl.loaded
    runs ->
      (expect dl.deck.size()).toEqual 61

      @deckalyzer = new Deckalyzer dl.deck
      (expect @deckalyzer).not.toBe null
      (expect @deckalyzer.deck.size()).toEqual 61

  afterEach () ->
    deleteTestFiles()

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
    # not yet working, arrays aren't quite working yet
    # (expect result).toEqual expected


  randSeed = Math.floor( Math.random() * 99999999 )
  testDeckFile = __dirname + '/.test.'+randSeed+'.deck'
  testCardsFile = __dirname + '/.test.'+randSeed+'.cards'

  writeTestFiles = () ->
    fs.writeFileSync( testDeckFile, testDeckData )
    fs.writeFileSync( testCardsFile, testCardsData )

  deleteTestFiles = () ->
    fs.unlinkSync( testDeckFile )
    fs.unlinkSync( testCardsFile )

  testDeckData = """
  # HERO  Fama'sin the Lifeseer
  # Quests
  1 Branch of Nordrassil
  1 Bloodbane's Fall
  2 Entrenched
  2 The Last Living Lorekeeper
  1 Seeds of Their Demise
  2 As Hyjal Burns
  1 If You're Not Against Us...
  1 Rescue the Earthspeaker!
  1 The Maw of Iso'rath
  1 Waking the Beast
  1 Blueleaf Tubers
  # Abilities
  1 Mark of Elderlimb
  1 Mark of the Ancients
  1 Innervate
  1 Nature's Reach
  2 Moonshard
  2 Stalwart Bear Form
  2 Mark of Goldrinn
  4 Verdant Boon
  3 Friends in High Places
  2 Entangling Roots
  # Allies
  1 Runzik Shrapnelwhiz
  2 Jadefire Scout
  1 Jadefire Satyr
  1 Keeper Balos
  2 Witch Doctor Ka'booma
  4 Jadefire Trickster
  2 Jadefire Hellcaller
  1 Harpy Matriarch
  1 Kalam'ti
  3 Stonebranch, Ancient of War
  1 Trag'ush
  1 Tor Earthwalker
  1 Zaza'jun
  1 Gilblin Plunderer
  1 Deathsmasher Mogdar
  1 Gravelord Adams
  2 Jadefire Felsworn
  1 Grug the Bonecrusher
  1 Gnash
  """

  testCardsData = """
  [

    " Quests ------------------------------------",

    {
      "name": "As Hyjal Burns",
      "cost": 0,
      "type": "quest"
    },
    {
      "name": "Blueleaf Tubers",
      "cost": 0,
      "type": "quest"
    },
    {
      "name": "Entrenched",
      "cost": 0,
      "type": "quest"
    },
    {
      "name": "The Maw of Iso'rath",
      "cost": 0,
      "type": "quest"
    },
    {
      "name": "The Last Living Lorekeeper",
      "cost": 0,
      "type": "quest"
    },
    {
      "name": "Rescue the Earthspeaker!",
      "cost": 0,
      "type": "quest"
    },
    {
      "name": "Seeds of Their Demise",
      "cost": 0,
      "type": "quest"
    },
    {
      "name": "Waking the Beast",
      "cost": 0,
      "type": "quest"
    },
    {
      "name": "If You're Not Against Us...",
      "cost": 0,
      "type": "quest"
    },

    "Equipment ------------------------------------",

    {
      "name": "Bloodbane's Fall",
      "type": "equipment",
      "subtype": "armor",
      "slot": "back",
      "cost": 3,
      "defense": 1,
      "special": {
        "buff": {
          "who": "hero",
          "buff": "assault",
          "amount": 1
        }
      }
    },
    {
      "name": "Branch of Nordrassil",
      "type": "equipment",
      "subtype": "weapon",
      "slot": "2h",
      "cost": 6,
      "attack": 1,
      "strikecost": 5,
      "damagetype": "nature",
      "classes": ["druid","mage","priest","shaman","warlock"]
    },

    "Allies ------------------------------------",

    {
      "name": "Gnash",
      "type": "ally",
      "cost": 6,
      "attack": 4,
      "health": 6,
      "factions": ["monster"],
      "races": ["sea giant"],
      "classes": ["warrior"],
      "damagetype": "frost",
      "unique": {
        "name": "Gnash",
        "num":  1
      }
    },
    {
      "name": "Kalam'ti",
      "type": "ally",
      "cost": 3,
      "attack": 3,
      "health": 2,
      "factions": ["horde"],
      "races": ["troll"],
      "classes": ["mage"],
      "damagetype": "fire"
    },
    {
      "name": "Runzik Shrapnelwhiz",
      "type": "ally",
      "cost": 1,
      "attack": 1,
      "health": 1,
      "factions": ["horde"],
      "races": ["goblin"],
      "classes": ["hunter"],
      "damagetype": "melee"
    },
    {
      "name": "Gilblin Plunderer",
      "type": "ally",
      "cost": 5,
      "attack": 3,
      "health": 5,
      "factions": ["monster"],
      "races": ["goblin"],
      "classes": ["warrior"],
      "damagetype": "frost"
    },
    {
      "name": "Jadefire Satyr",
      "type": "ally",
      "cost": 2,
      "attack": 2,
      "health": 3,
      "factions": ["monster"],
      "races": ["demon","satyr"],
      "classes": ["warrior"],
      "damagetype": "shadow"
    },
    {
      "name": "Witch Doctor Ka'booma",
      "type": "ally",
      "cost": 2,
      "attack": 4,
      "health": 1,
      "factions": ["horde"],
      "races": ["troll"],
      "classes": ["warlock"],
      "damagetype": "shadow"
    },
    {
      "name": "Jadefire Scout",
      "type": "ally",
      "cost": 1,
      "attack": 3,
      "health": 2,
      "factions": ["monster"],
      "races": ["satyr","demon"],
      "classes": ["hunter"],
      "damagetype": "shadow"
    },
    {
      "name": "Gravelord Adams",
      "type": "ally",
      "cost": 6,
      "attack": 5,
      "health": 5,
      "factions": ["horde"],
      "races": ["undead"],
      "classes": ["death knight"],
      "damagetype": "shadow"
    },
    {
      "name": "Tor Earthwalker",
      "type": "ally",
      "cost": 4,
      "attack": 2,
      "health": 4,
      "factions": ["horde"],
      "races": ["tauren"],
      "classes": ["druid"],
      "damagetype": "nature"
    },
    {
      "name": "Zaza'jun",
      "type": "ally",
      "cost": 4,
      "attack": 2,
      "health": 2,
      "factions": ["horde"],
      "races": ["troll"],
      "classes": ["druid"],
      "damagetype": "nature"
    },
    {
      "name": "Deathsmasher Mogdar",
      "type": "ally",
      "cost": 5,
      "attack": 6,
      "health": 4,
      "factions": ["monster"],
      "races": ["ogre"],
      "classes": ["death knight"],
      "damagetype": "frost"
    },
    {
      "name": "Grug the Bonecrusher",
      "type": "ally",
      "cost": 6,
      "attack": 7,
      "health": 7,
      "factions": ["monster"],
      "races": ["ogre"],
      "classes": ["warrior"],
      "damagetype": "melee",
      "conspicuous": 1
    },
    {
      "name": "Trag'ush",
      "type": "ally",
      "cost": 4,
      "attack": 6,
      "health": 4,
      "factions": ["monster"],
      "races": ["ogre"],
      "classes": ["warlock"],
      "damagetype": "fire",
      "conspicuous": 1
    },
    {
      "name": "Jadefire Felsworn",
      "type": "ally",
      "cost": 6,
      "attack": 5,
      "health": 5,
      "factions": ["monster"],
      "races": ["demon","satyr"],
      "classes": ["warlock"],
      "damagetype": "shadow"
    },
    {
      "name": "Jadefire Hellcaller",
      "type": "ally",
      "cost": 3,
      "attack": 4,
      "health": 2,
      "factions": ["monster"],
      "races": ["satyr","demon"],
      "classes": ["warlock"],
      "damagetype": "shadow"
    },
    {
      "name": "Jadefire Trickster",
      "type": "ally",
      "cost": 3,
      "attack": 4,
      "health": 4,
      "factions": ["monster"],
      "races": ["satyr","demon"],
      "classes": ["rogue"],
      "damagetype": "shadow"
    },
    {
      "name": "Keeper Balos",
      "type": "ally",
      "cost": 2,
      "attack": 1,
      "health": 4,
      "factions": ["monster"],
      "races": ["keeper of the grove"],
      "classes": ["druid"],
      "damagetype": "nature"
    },
    {
      "name": "Stonebranch, Ancient of War",
      "type": "ally",
      "cost": 4,
      "attack": 2,
      "health": 2,
      "factions": ["monster"],
      "races": ["ancient"],
      "classes": ["druid"],
      "damagetype": "nature"
    },
    {
      "name": "Harpy Matriarch",
      "type": "ally",
      "cost": 3,
      "attack": 2,
      "health": 2,
      "factions": ["monster"],
      "races": ["harpy"],
      "classes": ["mage"],
      "damagetype": "frost"
    },

    "Abilities ------------------------------------",

    {
      "name": "Entangling Roots",
      "cost": 2,
      "type": "ability",
      "subtype": "balance",
      "classes": ["druid"]
    },
    {
      "name": "Friends in High Places",
      "cost": 3,
      "type": "ability",
      "subtype": "balance",
      "classes": ["druid"],
      "instant": 1
    },
    {
      "name": "Innervate",
      "cost": 4,
      "type": "ability",
      "subtype": "restoration",
      "classes": ["druid"],
      "instant": 1
    },
    {
      "name": "Nature's Reach",
      "cost": 4,
      "type": "ability",
      "subtype": "balance",
      "classes": ["druid"],
      "talent": "balance"
    },
    {
      "name": "Moonshard",
      "cost": 2,
      "type": "ability",
      "subtype": "balance",
      "classes": ["druid"]
    },
    {
      "name": "Mark of Goldrinn",
      "cost": 5,
      "type": "ability",
      "subtype": "restoration",
      "classes": ["druid"]
    },
    {
      "name": "Stalwart Bear Form",
      "cost": 4,
      "type": "ability",
      "subtype": "feral",
      "classes": ["druid"],
      "instant": 1,
      "ongoing": 1,
      "form": "bear"
    },
    {
      "name": "Verdant Boon",
      "cost": 2,
      "type": "ability",
      "subtype": "balance",
      "classes": ["druid"]
    },
    {
      "name": "Mark of Elderlimb",
      "cost": 2,
      "type": "ability",
      "subtype": "balance",
      "classes": ["druid"]
    },
    {
      "name": "Mark of the Ancients",
      "cost": 1,
      "type": "ability",
      "subtype": "restoration",
      "classes": ["druid"]
    }
  ]
  """
