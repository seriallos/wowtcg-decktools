Pile = require('./pile').Pile

describe 'pile', ->
  deck = null
  cards = ['first','second','third','fourth','last']

  beforeEach () ->
    # create a new deck every time
    deck = new Pile

  it 'starts empty', ->
    (expect deck.size()).toEqual 0

  it 'can add and draw cards', ->
    deck.addTop cards[0]
    (expect deck.size()).toEqual 1
    drawn = deck.draw()
    (expect drawn).toEqual cards[0]

    # populate all cards
    deck.addTop card for card in cards
    (expect deck.size()).toEqual cards.length
    # draw one, make sure total of 1 is gone
    deck.draw()
    (expect deck.size()).toEqual cards.length - 1
    # draw two, make sure total of 1 is gone
    deck.draw()
    (expect deck.size()).toEqual cards.length - 2

  it 'has inspection methods', ->
    deck.addTop card for card in cards
    # check top card methods
    (expect deck.topCard()).toEqual cards[ cards.length - 1 ]
    (expect deck.topCards()).toEqual cards[ cards.length - 1 .. ]
    (expect deck.topCards(2)).toEqual cards[ cards.length - 2 .. ]
    # check bottomCard(s) methods
    (expect deck.bottomCard()).toEqual cards[ 0 ]
    (expect deck.bottomCards()).toEqual [ cards[ 0 ] ]
    (expect deck.bottomCards(3)).toEqual cards[ ... 3 ]

    # make sure top N and bottom N work as expected
    (expect deck.topCards( deck.size() )).toEqual deck.bottomCards( deck.size() )

    #nth card
    (expect deck.nthCard(1)).toEqual cards[ cards.length - 1 ]
    (expect deck.nthCard(1)).toEqual deck.topCard()

  it 'shuffles with correct stats', ->
    lastCardIsTopCount = 0
    lastCard = cards[ cards.length - 1 ]

    runs = i = 1000
    while i -= 1
      deck = new Pile

      # populate the deck
      deck.addTop card for card in cards

      # shuffle and check the top card many times
      deck.shuffle()
      if lastCard == deck.topCard()
        lastCardIsTopCount++
    # this is probably not statistically valid but what the hell!
    (expect 0.15 < lastCardIsTopCount / runs < 0.25).toBe(true)



