Pile = require('./pile').Pile
fs   = require('fs')
path = require('path')
cl   = require('../card/cardloader').CardLoader

class DeckLoader
  @loadFromDeckFile: (file) ->
    if cl.LoadedSets().length == 0
      throw new Error "No sets loaded, need to run CardLoader.LoadSet( SET )"
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
        couldnt_load = []
        for i in [0...num]
          card = cl.GetCard card_name
          if card?
            deck.addTop card
          else
            throw new Error "Unable to load card with name '#{card_name}'"
    return deck

  @readFileIntoArray: (file) ->
    if path.existsSync( file )
      return fs.readFileSync(file).toString().split("\n")
    else
      return null

exports.DeckLoader = DeckLoader
