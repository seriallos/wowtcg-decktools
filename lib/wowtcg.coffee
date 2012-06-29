# Main entry point into all the various classes
# Defines a list of what things are named and where they live, loads and exports them all

modules = [
  { class: 'Pile',       file: './deck/pile' },
  { class: 'DeckLoader', file: './deck/deckloader' },
  { class: 'Card',       file: './card/card' },
  { class: 'CardLoader', file: './card/cardloader' },
]

setup_modules = ( info ) ->
  [name, lib] = [ info.class, info.file ]
  # Pile = require('./pile').Pile
  m = require(lib)[name]
  exports[name] = m

# Can you say "module"?
setup_modules module for module in modules
