fs   = require('fs')
path = require('path')
Card = require('./card').Card
util = require('util')

class CardLoader
  @loadedFiles: []
  @cards: {}

  @LoadCardsFromFile: ( cardFile ) ->
    if not @loadedFiles[ cardFile ]?
      contents = fs.readFileSync cardFile
      # file is json, just use require to suck it into @cards
      rawCards = JSON.parse( contents )
      for item in rawCards
        if item.name? and item.type?
          # make the lookup key lower case
          @cards[ item.name.toLowerCase() ] = item
      @loadedFiles.push( cardFile )

  @IsFileLoaded: ( cardFile ) ->
    return cardFile in @loadedFiles

  @GetCard: ( cardName ) ->
    cardName = cardName.toLowerCase()
    return if @cards[ cardName ]? then @cards[ cardName ] else null

  @LoadedCards: () ->
    # fast, builtin way to count number of properties
    return Object.keys( @cards ).length

  @LoadedFiles: () ->
    return @loadedFiles

  @Reset: () ->
    @loadedFiles = []
    @cards = {}

exports.CardLoader = CardLoader
