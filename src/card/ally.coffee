Card = require('./card').Card

class AllyCard extends Card
  constructor: () ->
    # make sure we call Card's constructor to get all the basic data set
    super()
    @type =      'ally'
    @attack =    0
    @health =    0
    @faction =   null   # horde, alliance, monster
    @races =      []   # undead, goblin, naga, etcc
    @allyClasses =     []   # rogue, shaman, etc

  # cards can theoretically be multiple races or classes
  # set up 'add' and 'is' methods
  addClass: (allyClass) -> @allyClasses.push(allyClass)
  addRace: (race) -> @races.push(race)
  isRace: (race) -> race in @races
  isClass: (allyClass) -> allyClass in @allyClasses

exports.AllyCard = AllyCard
