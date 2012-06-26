wowtcg  = require('./lib/wowtcg')
program = require('commander')

# write to stderr
stderr = ( msg ) ->
  process.stderr.write msg + "\n"

# utility function to load a deck file
loadDeck = ( deckFile ) ->
  deck = wowtcg.DeckLoader.loadFromDeckFile deckFile

program
  .version('0.1')

program
  .command('costs [deck]')
  .description('Report cost statistics for a .deck file')
  .action( ( deckFile ) ->
    deck = loadDeck deckFile
    if null == deck
     stderr "Unable to load #{ deckFile }"
    # deckalyzer.analyzeCosts deck
  )

program.parse( process.argv )

stderr('')
