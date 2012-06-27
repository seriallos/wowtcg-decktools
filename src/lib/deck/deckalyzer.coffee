Pile = require('./pile').Pile



class Deckalyzer

  constructor: (@deck) ->

  count: ( filter ) ->
    if @_emptyFilter filter
      return @deck.size()
    else if @_invalidFilter( filter )
      return 0
    else
      count = 0
      for card in @deck.getCards()
        found = true
        for key, condition of filter
          if not @_evalCondition card[key], condition
            found = false
        count += 1 if found
      return count

  _evalCondition: ( value, condition ) ->
    if condition instanceof Object and not (condition instanceof Array)
      console.log condition
    else if condition instanceof Array
      return @_arrayEquals value, condition
    else
      return value == condition

  _arrayEquals: ( a, b ) ->
    if a instanceof Array and b instanceof Array
      if a.length == b.length
        equal = true
        for i in [ 0 ... a.length ]
          if a[ i ] != b[ i ]
            equal = false
        return equal
      else
        return false
    else
      return false

  # filter has to be an object with keys
  _invalidFilter: ( filter ) ->
    return not (filter instanceof Object)

  _emptyFilter: ( filter ) ->
    return not filter or ( filter instanceof Object and 0 == Object.keys( filter ).length)

exports.Deckalyzer = Deckalyzer
