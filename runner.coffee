Pile = require('./lib/pile').Pile

deck = new Pile

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


