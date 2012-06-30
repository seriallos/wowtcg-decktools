DeckLoader = require('./deckloader').DeckLoader
CardLoader = require('../card/cardloader').CardLoader
fs         = require('fs')

describe 'deckloader', ->

  beforeEach () ->
    # reset the card loader to make sure we're starting fresh
    CardLoader.reset()
    writeTestFiles()

    # make sure we load the test card set
    CardLoader.loadCardsFromFile( testCardsFile )

  afterEach () ->
    deleteTestFiles()

  it "throws an exception if no card sets have been loaded", ->
    # ensure no cards are in the card loader given that we preload every time
    CardLoader.reset()
    loaderCall = () ->
      dl = new DeckLoader()
      dl.loadFromDeckFile( testDeckFile )
    expect(loaderCall).toThrow()

  it 'can load a known deck from a .deck file', ->
    # we know the test file contains 61 cards
    dl = new DeckLoader()
    dl.loadFromDeckFile( testDeckFile )
    waitsFor ->
      return dl.loaded
    runs ->
      (expect dl.deck.size()).toEqual 61

  it "returns null when a file can't be read", ->
    loaderCall = () ->
      dl = new DeckLoader()
      dl.loadFromDeckFile( __dirname + '/bad-file' )
    expect(loaderCall).toThrow()

  it "throws an exception when the file doesn't exist", ->
    loaderCall = () ->
      dl = new DeckLoader()
      testDeck = dl.loadFromCsvFile( "/ADB/BAD/ASDASD/bad.csv" )
    expect(loaderCall).toThrow()

  it "can load a known CSV deck file", ->
    dl = new DeckLoader()
    dl.loadFromCsvFile( testCsvFile )
    waitsFor ->
      return dl.loaded
    runs ->
      (expect dl.deck.size()).toEqual 61

  randSeed = Math.floor( Math.random() * 99999999 )
  testDeckFile = __dirname + '/.test.'+randSeed+'.deck'
  testCsvFile = __dirname + '/.test.'+randSeed+'.csv'
  testCardsFile = __dirname + '/.test.'+randSeed+'.cards'

  writeTestFiles = () ->
    fs.writeFileSync( testDeckFile, testDeckData )
    fs.writeFileSync( testCsvFile, testCsvData )
    fs.writeFileSync( testCardsFile, testCardsData )

  deleteTestFiles = () ->
    fs.unlinkSync( testDeckFile )
    fs.unlinkSync( testCsvFile )
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

  testCsvData = """
"Fama'sin - Limited League Deck"

"As Hyjal Burns",2,CoH,Quest,6
"Bloodbane's Fall",1,SW,Equipment,5
"Blueleaf Tubers",1,HoA,Quest,5
"Branch of Nordrassil",1,CoH,Equipment,6
"Deathsmasher Mogdar",1,CoH,Ally,6
"Entangling Roots",2,HoA,Ability,6
Entrenched,2,ELE,Quest,5
"Fama'sin the Lifeseer",1,TOT,Hero,6
"Friends in High Places",3,BoG,Ability,6
"Gilblin Plunderer",1,TOT,Ally,6
Gnash,1,TOT,Ally,6
"Gravelord Adams",1,CoH,Ally,6
"Grug the Bonecrusher",1,CoH,Ally,6
"Harpy Matriarch",1,CoH,Ally,6
"If You're Not Against Us...",1,CoH,Quest,6
Innervate,1,HoA,Ability,6
"Jadefire Felsworn",2,CoH,Ally,6
"Jadefire Hellcaller",2,CoH,Ally,6
"Jadefire Satyr",1,CoH,Ally,6
"Jadefire Scout",2,CoH,Ally,6
"Jadefire Trickster",4,CoH,Ally,6
Kalam'ti,1,TOT,Ally,6
"Keeper Balos",1,CoH,Ally,6
"Mark of Elderlimb",1,CoH,Ability,6
"Mark of Goldrinn",2,TOT,Ability,6
"Mark of the Ancients",1,CoH,Ability,6
Moonshard,2,ELE,Ability,5
"Nature's Reach",1,BoG,Ability,6
"Rescue the Earthspeaker!",1,TOT,Quest,6
"Runzik Shrapnelwhiz",1,TOT,Ally,6
"Seeds of Their Demise",1,TOT,Quest,6
"Stalwart Bear Form",2,TOT,Ability,6
"Stonebranch, Ancient of War",3,CoH,Ally,6
"The Last Living Lorekeeper",2,TOT,Quest,6
"The Maw of Iso'rath",1,ToD,Quest,5
"Tor Earthwalker",1,CoH,Ally,6
Trag'ush,1,CoH,Ally,6
"Verdant Boon",4,TOT,Ability,6
"Waking the Beast",1,TOT,Quest,6
"Witch Doctor Ka'booma",2,CoH,Ally,6
Zaza'jun,1,CoH,Ally,6
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
