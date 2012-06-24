AllyCard = require('./ally').AllyCard

describe 'AllyCard', ->

  it 'starts empty', ->
    c = new AllyCard
    (expect c.type).toEqual 'ally'
    (expect c.cost).toEqual null
    (expect c.attack).toEqual null
    (expect c.health).toEqual null

  it 'suports multiple races and classes', ->
    runzik = new AllyCard
    runzik.name = "Runzik Shrapnelwhiz"
    runzik.cost = 1
    runzik.attack = 1
    runzik.health = 1
    runzik.faction = 'horde'
    runzik.addClass 'hunter'
    runzik.addRace  'goblin'
    runzik.addRace  'test'
    runzik.addRace  'keeper of the grove'
    runzik.expansion = 'throne'
    runzik.id = 167
    runzik.artist = 'Tom McBurnie'
    runzik.text = 'When this ally enters play, he deals 1 ranged damage to target opposing ally.'
    (expect runzik.isClass('hunter')).toBe(true)
    (expect runzik.isClass('rogue')).toBe(false)
    (expect runzik.isRace('goblin')).toBe(true)
    (expect runzik.isRace('goblin test')).toBe(false)
    (expect runzik.isRace('test')).toBe(true)
    (expect runzik.isRace('keeper')).toBe(false)
    (expect runzik.isRace('keeper of the grove')).toBe(true)


