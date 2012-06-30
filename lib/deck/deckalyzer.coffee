Pile = require('./pile').Pile



class Deckalyzer

  constructor: (@deck) ->

  # get distinct keys and their counts
  distinct: ( key, filter ) ->
    filtered = @_filterDeck filter
    results = {}
    for card in filtered.getCards()
      # TODO: properly handle array values
      if card[ key ]?
        if results[ card[ key ] ]
          results[ card[ key ] ] += 1
        else
          results[ card[ key ] ] = 1
    return results

  # get a count based on a filter
  count: ( filter ) ->
    filtered = @_filterDeck filter
    return filtered.size()

  _filterDeck: ( filter ) ->
    filtered = new Pile
    if @_emptyFilter filter
      # copy the deck to a new pile
      for card in @deck.getCards()
        filtered.addTop card
    else if @_invalidFilter( filter )
      donothing = "ok"
    else
      for card in @deck.getCards()
        if @_evalFilter card, filter
          filtered.addTop card

    return filtered

  _evalFilter: ( object, filter ) ->
    found = true
    for key, condition of filter
      if not @_evalCondition object[ key ], condition
        found = false
    return found

  _evalCondition: ( value, condition ) ->
    if condition instanceof Object and not (condition instanceof Array)
      match = true
      for operator, operand of condition
        if not @_complexCompare value, operator, operand
          match = false
          break
      return match
    else if condition instanceof Array
      return @_arrayEquals value, condition
    else
      if value instanceof Array
        return condition in value
      else
        return value == condition

  _arrayEquals: ( a, b ) ->
    if a instanceof Array and b instanceof Array
      if a.length == b.length
        equal = true
        for i in [ 0 ... a.length ]
          if a[ i ] != b[ i ]
            equal = false
            break
        return equal
      else
        return false
    else
      return false

  _complexCompare: ( value, operator, operand ) ->
    return switch operator
      when '$gt' then value > operand
      when '$gte' then value >= operand
      when '$lt' then value < operand
      when '$lte' then value <= operand
      when '$ne' then value != operand
      when '$in' then value in operand
      when '$nin' then not ( value in operand )
      when '$regex' then operand.test value
      when '$exists'
        # $exists: 1
        if operand == 1
          value
        else
          not value
      else
        throw new Error "Unsupported operator " + operator

  # filter has to be an object with keys
  _invalidFilter: ( filter ) ->
    return not (filter instanceof Object)

  _emptyFilter: ( filter ) ->
    return not filter or (filter instanceof Object and 0 == Object.keys( filter ).length)

exports.Deckalyzer = Deckalyzer
