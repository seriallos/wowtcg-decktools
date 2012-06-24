Card = require('./card/card')

class Pile
  # cards currently in the pile
  # Top is the end of the array (this is where card are drawn)
  # Bottom is array index 0
  cards: []

  constructor: () ->

  # size of the pile
  size: () -> @cards.length

  # adds to the top of the pile
  addTop: (card) -> @cards.push( card )

  # put a card on the bottom of the pile
  addBottom: (card) -> @cards.unshift( card )

  # draws from the top of the pile
  draw: () -> @cards.pop()

  # shuffle the pile using fisher yates method
  shuffle: () ->
    i = @cards.length
    if i == 0 then return false
    while --i
      j = Math.floor(Math.random() * (i+1))
      [@cards[i],@cards[j]] = [@cards[j],@cards[i]]
    true


exports.Pile = Pile
