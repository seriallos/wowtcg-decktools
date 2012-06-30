Pile = require('./pile').Pile
cl   = require('../card/cardloader').CardLoader
fs   = require('fs')
path = require('path')
csv  = require('csv')

class DeckLoader

  constructor: () ->
    @loaded = false
    @deck = new Pile()
    @loadedCallback = null

  loadFromDeckFile: (file, loadedCallback ) ->
    @loaded = false
    @loadedCallback = loadedCallback
    if not @cardsLoaded
      throw new Error "No sets loaded, need to run CardLoader.LoadSet( SET )"
    # create a new pile
    @deck = new Pile()
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
          card = cl.getCard card_name
          if card?
            @deck.addTop card
          else
            throw new Error "Unable to load card with name '#{card_name}'"
    @handleLoadedData()

  loadFromCsvFile: (file, loadedCallback) ->
    @loaded = false
    @loadedCallback = loadedCallback
    if not @cardsLoaded
      throw new Error "No sets loaded, need to run CardLoader.LoadSet( SET )"
    if not path.existsSync( file )
      throw new Error "Unable to load CSV deck file #{file}, does not exist"
    @deck = new Pile()
    csv()
      .fromPath( file, { columns: ['name', 'num', 'set', 'type', 'block'] } )
      .on 'error', (error) ->
        throw error
      # this seems annoying and bad?
      # have to use the fat arrow to be able to call handleCsvData to be able to
      # access this.loadedCallback and this.loaded
      .on 'data', (data, index) =>
        @handleCsvData( data, index )
      .on 'end', () =>
        @handleLoadedData()
    true

  handleLoadedData: () ->
    @loaded = true
    if @loadedCallback
      @loadedCallback( @deck )

  handleCsvData: ( data, index ) ->
    if data.name and data.num and data.type != 'Hero'
      for i in [0...data.num]
        card = cl.getCard data.name
        if card?
          @deck.addTop card
        else
          throw new Error "Unable to load card with name '#{data.name}'"

  cardsLoaded: () ->
    return cl.loadedFiles.length > 0

  readFileIntoArray: (file) ->
    if path.existsSync( file )
      return fs.readFileSync(file).toString().split("\n")
    else
      throw new Error "Unable to read file #{file}, doesn't exist or no permissions"

exports.DeckLoader = DeckLoader
