CardLoader = require('./cardloader').CardLoader
fs         = require('fs')

describe 'cardloader', ->

  beforeEach () ->
    writeTestFiles()

  afterEach () ->
    deleteTestFiles()

  it 'can load cards from a .json file', ->

    # check starting conditions
    (expect CardLoader.GetCard('Gnash')).toBe(null)
    (expect CardLoader.IsFileLoaded( testCardsFile )).toBe(false)

    # load it
    CardLoader.LoadCardsFromFile( testCardsFile )
    (expect CardLoader.IsFileLoaded(testCardsFile)).toBe(true)

    # we know the test file contains 40 cards
    (expect CardLoader.LoadedCards()).toEqual 40

    # running LoadCardsFromFile again shouldn't change anything
    CardLoader.LoadCardsFromFile( testCardsFile )
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

  # keep all test data in this file as well as methods to write/delete

  randSeed = Math.floor( Math.random() * 999999999 )
  testCardsFile = __dirname + '/.test.'+randSeed+'.cards'

  writeTestFiles = () ->
    fs.writeFileSync( testCardsFile, testCardsData )

  deleteTestFiles = () ->
    fs.unlinkSync( testCardsFile )

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
