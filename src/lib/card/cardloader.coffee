fs   = require('fs')
path = require('path')
Card = require('./card').Card
util = require('util')

class CardLoader
  @loadedSets: []
  @cards: {}

  @LoadSet: ( setName ) ->
    setName = setName.toLowerCase()
    # only load a set once
    if not @loadedSets[ setName ]?
      # set files have an exact name pattern: SETNAME.json
      fileName = __dirname + "/data/#{setName}.json"
      contents = fs.readFileSync fileName
      # file is json, just use require to suck it into @sets
      rawSet = JSON.parse( contents )
      for item in rawSet
        if item.name? and item.type?
          # make the lookup key lower case
          @cards[ item.name.toLowerCase() ] = item
      @loadedSets[ setName ] = true

  @IsSetLoaded: ( setName ) ->
    setName = setName.toLowerCase()
    return @loadedSets[ setName ]?

  @GetCard: ( cardName ) ->
    cardName = cardName.toLowerCase()
    return if @cards[ cardName ]? then @cards[ cardName ] else null

  @LoadedCards: () ->
    # fast, builtin way to count number of properties
    return Object.keys( @cards ).length

exports.CardLoader = CardLoader
