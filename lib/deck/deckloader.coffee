util = require('util')

# storage format for decks
Pile = require('./pile').Pile

# get card data and make sure cards are loaded
cl   = require('../card/cardloader').CardLoader

# we talk to the file system
fs   = require('fs')
path = require('path')

# for parsing CSV deck format
csv  = require('csv')

# for parsing o8d deck format (XML)
xmljs = require('xml2js')

# separate file logic from parsing logic so the class can just accept data

class DeckLoader

  constructor: () ->
    @loaded = false
    @deck = new Pile()
    @loadedCallback = null

  parseData: ( data, loadedCallback, parseCallback ) ->
    @loaded = false
    @loadedCallback = loadedCallback
    @deck = new Pile
    if data != null
      parseCallback data, () =>
        @handleLoadedData()
    else
      @loaded = true
      @handleLoadedData()

  parseDeckData: ( data, loadedCallback ) ->
    @parseData data, loadedCallback, ( data, parsingDoneCallback ) =>
      data = data.split("\n")
      # only load lines that match the |NUMBER CARDNAME| line pattern
      lineRegex = /^\s*([0-9]+)\s+(.*)$/
      @handleRegexLines( data, lineRegex )
      parsingDoneCallback()

  # guess the file format!
  loadFromFile: ( file, loadedCallback ) ->
    suffix = file.substr( file.lastIndexOf( '.' ) + 1 )
    switch suffix.toLowerCase()
      when 'deck' then @loadFromDeckFile file, loadedCallback
      when 'csv' then @loadFromCsvFile file, loadedCallback
      when 'mwdeck' then @loadFromMwDeckFile file, loadedCallback
      when 'o8d' then @loadFromO8dFile file, loadedCallback
      else
        throw new Error "Unsupported file type '.#{suffix}'"

  loadFromDeckFile: (file, loadedCallback ) ->
    @load file, () =>
      # open file
      lines = @readFile( file )
      @parseDeckData lines, loadedCallback

  parseMwDeckData: ( data, loadedCallback ) ->
    @parseData data, loadedCallback, ( data, parsingDoneCallback ) =>
      data = data.split("\n")
      # only load lines that match the normal card regex format
      # NOTE: This skips the hero card which is prefixed by SB:
      lineRegex = /// ^\s*  # leading whitespace
        (\d+) \s+           # match 1, # - series of digits to determine how many of this card in the deck
        \[\d+\] \s+         # match 2, [#] - which block this card is from
        (.*) \s+            # match 3, name of the card
        \{(\d+)\}           # match 4, card block again?
      $ ///
      @handleRegexLines( data, lineRegex )
      parsingDoneCallback()

  loadFromMwDeckFile: ( file, loadedCallback ) ->
    @load file, () =>
      # open file
      lines = @readFile( file )
      @parseMwDeckData lines, loadedCallback

  parseCsvData: ( data, loadedCallback ) ->
    @parseData data, loadedCallback, ( data, parsingDoneCallback ) =>
      csv()
        .from( data, { columns: ['name', 'num', 'set', 'type', 'block'] } )
        .on 'error', (error) ->
          throw error
        .on 'data', (data, index) =>
          @handleCsvData( data, index )
        .on 'end', () =>
          parsingDoneCallback()

  handleCsvData: ( data, index ) ->
    if data.name and data.num and data.type != 'Hero'
      for i in [0...data.num]
        card = cl.getCard data.name
        if card?
          @deck.addTop card
        else
          throw new Error "Unable to load card with name '#{data.name}'"

  loadFromCsvFile: (file, loadedCallback) ->
    @load file, () =>
      lines = @readFile( file )
      @parseCsvData lines, loadedCallback

  parseO8dData: ( data, loadedCallback ) ->
    @parseData data, loadedCallback, ( data, parsingDoneCallback ) =>
      parser = new xmljs.Parser()
      parser.parseString data, (err, result) =>
        # Section 0 == main cards == @name = "Main"
        # Section 1 == hero == @name = "Hero"
        for item in result.section[0].card
          card_name = item['#']
          num = item['@'].qty
          for i in [0...num]
            @deck.addTop cl.getCard card_name
        parsingDoneCallback()

  loadFromO8dFile: ( file, loadedCallback ) ->
    @load file, () =>
      lines = @readFile file
      @parseO8dData lines, loadedCallback

  # same code for .mwDeck and .deck files, just different regexes
  # assumes match 1 is card number and match 2 is card name
  # TODO: map this better instead of relying on position
  handleRegexLines: ( lines, regex ) ->
    # parse each line and put into the deck
    for line in lines
      # skip lines that don't match the pattern
      if regex.test line
        # trim line
        line = line.replace /^\s+|\s+$/g, ""
        # get the matches
        matches = regex.exec line
        [num, card_name] = [ matches[1], matches[2] ]
        # add the card X times
        couldnt_load = []
        for i in [0...num]
          card = cl.getCard card_name
          if card?
            @deck.addTop card
          else
            throw new Error "Unable to load card with name '#{card_name}'"

  # wrap starting code together so each format doesn't have to do any of this
  load: ( file, formatCallback ) ->

    if not @cardsLoaded()
      throw new Error "No sets loaded, need to run CardLoader.LoadSet( SET )"
    if not path.existsSync( file )
      throw new Error "Unable to load file #{file}, does not exist"
    @deck = new Pile

    formatCallback()

  handleLoadedData: () ->
    @loaded = true
    if @loadedCallback
      @loadedCallback( @deck )


  cardsLoaded: () ->
    return cl.loadedFiles.length > 0

  readFile: (file) ->
    if path.existsSync( file )
      return fs.readFileSync(file).toString()
    else
      throw new Error "Unable to read file #{file}, doesn't exist or no permissions"

exports.DeckLoader = DeckLoader
