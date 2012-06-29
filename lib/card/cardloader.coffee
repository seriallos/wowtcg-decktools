fs   = require('fs')
path = require('path')
Card = require('./card').Card
util = require('util')

class CardLoader
  @loadedFiles: []
  @cards: {}

  @loadCardsFromFile: ( cardFile ) ->
    if not @loadedFiles[ cardFile ]?
      contents = fs.readFileSync cardFile
      # file is json, just use require to suck it into @cards
      rawCards = JSON.parse( contents )
      for item in rawCards
        if item.name? and item.type?
          # make the lookup key lower case
          @cards[ item.name.toLowerCase() ] = item
      @loadedFiles.push( cardFile )

  @isFileLoaded: ( cardFile ) ->
    return cardFile in @loadedFiles

  @getCard: ( cardName ) ->
    cardName = cardName.toLowerCase()
    return if @cards[ cardName ]? then @cards[ cardName ] else null

  @loadedCards: () ->
    # fast, builtin way to count number of properties
    return Object.keys( @cards ).length

  @reset: () ->
    @loadedFiles = []
    @cards = {}

exports.CardLoader = CardLoader
