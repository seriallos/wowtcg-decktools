wowtcg = require('./lib/wowtcg')

deck = new wowtcg.Pile

deck.addTop 'Gnash'
deck.addTop 'Jadefire Satyr'
deck.addTop 'Jadefire Satyr'
deck.addTop 'Stonebranch'
deck.addTop 'Stonebranch'
deck.addTop 'Stonebranch'
deck.addTop "Runzik Shrapnelwhiz"
deck.addTop "Keeper Balos"
deck.addTop "Witch Doctor Ka'Booma"
deck.addTop "Witch Doctor Ka'Booma"

deck.shuffle()
console.log "deck: #{deck.cards}"

runzik = new wowtcg.AllyCard
runzik.name = "Runzik Shrapnelwhiz"
runzik.cost = 1
runzik.attack = 1
runzik.health = 1
runzik.faction = 'horde'
runzik.addClass 'hunter'
runzik.addRace  'goblin'
runzik.expansion = 'throne'
runzik.id = 167
runzik.artist = 'Tom McBurnie'
runzik.text = 'When this ally enters play, he deals 1 ranged damage to target opposing ally.'

console.log runzik
console.log "is runzik a goblin? " + runzik.isRace( 'goblin' )
console.log "is runzik a satyr? " + runzik.isRace( 'satyr' )
console.log "is runzik a hunter? " + runzik.isClass( 'hunter' )
console.log "is runzik a rogue? " + runzik.isClass( 'rogue' )
