Pile = require('./pile').Pile
fs   = require('fs')
path = require('path')

class DeckLoader
  @loadFromDeckFile: (file) ->
    # create a new pile
    deck = new Pile
    # open file
    deckLines = @readFileIntoArray( file )
    if deckLines == null then return null
    # only load lines that match the |NUMBER CARDNAME| line pattern
    lineRegex = /^\s*([0-9]+)\s+(.*)$/
    # parse each line and put into the deck
    for line in deckLines
      # skip lines that don't match the pattern
      if lineRegex.test line
        # trim line
        line = line.replace /^\s+|\s+$/g, ""
        # get the matches
        matches = lineRegex.exec line
        [num, card_name] = [ matches[1], matches[2] ]
        # add the card X times
        for i in [0...num]
          deck.addTop card_name
    return deck

  @readFileIntoArray: (file) ->
    if path.existsSync( file )
      return fs.readFileSync(file).toString().split("\n")
    else
      return null

exports.DeckLoader = DeckLoader
