wowtcg-decktools
================

Tools for WoW TCG deck information, analysis, and optimization

Written in CoffeeScript primarily as a learning exercise.  Probably going to be a little bit of a pain for anyone else
to use.

Mostly hacked together data and scripts for now.  Just want to have a place to keep some of this random stuff together.

Dependencies
-----------

- Node
- CoffeeScript

*Note:* NPM package isn't quite ready yet.  Manual installation requires node-commander.  More info in the package.json

CLI Usage
---------

    ➜  wowtcg-decktools git:(master) ✗ ./bin/deckotron distinct cost data/decks/famasin.deck
    0: 12 cards
    1: 4 cards
    2: 13 cards
    3: 12 cards
    4: 10 cards
    5: 4 cards
    6: 6 cards

    ➜  wowtcg-decktools git:(master) ✗ ./bin/deckotron distinct cost data/decks/famasin.deck '{"type":"Ally"}'
    1: 3 cards
    2: 4 cards
    3: 8 cards
    4: 6 cards
    5: 2 cards
    6: 5 cards

    ➜  wowtcg-decktools git:(master) ✗ ./bin/deckotron count data/decks/famasin.deck '{"type":"Ability"}'
    19

    ➜  wowtcg-decktools git:(master) ./bin/deckotron -h

     Usage: deckotron [options] [command]

     Commands:
    
       distinct [type] [deck] [query]
       Report costs for a deck
    
       count [deck] [query]
       Get count of cards in a deck
    
     Options:
     
       -h, --help     output usage information
       -V, --version  output the version number

The query is a MongoDB-like JSON syntax.  Currently must be valid JSON (quoted keys, etc).  Some of the more complex filters don't work on the command line yet.

Library Usage
-------------

CoffeeScript example:

    wowtcg = require('wowtcg')
    # most sets available in ./data/cards/
    wowtcg.CardLoader.loadCardsFromFile('./path/to/cards.json')
    # simple deck format:
    # (# cards) (card name)
    dl = new wowtcg.DeckLoader()
    dl.loadFromDeckFile('./path/to/mydeck.deck', ( deck ) ->

      # deck loading happens asynchronously so wrap all work in a callback

      d = new wowtcg.Deckalyzer deck

      # get the size of the deck
      numCards = d.count()

      # get the number of cards with cost 2
      cost2count = d.count( { cost: 2 } )

      # find count of cards with name that matches the regex /jadefire/i
      jadefireCards = d.count( {name: {$regex: /jadefire/i} } )

      # get an object with each card type and count
      typeBreakdown = d.distinct( 'type' )

      # get breakdown of card types with cost between 2 and 4 inclusive
      stuff = d.distinct( 'type', { cost: { $gte: 2, $lte: 4 } } )


My Dev Cycle
------------

I like having a few terminal windows open always building and running the code.  My current workflow is to have 3
windows:

- Source editing
- Continuous linting, testing, and compilation
- Continuous execution of a test script to see results and runtime errors

**Continuous compilation, linting, and testing:**

    ./test-o-tron-5000.sh
    
    # this just runs the below:
    # ./pc.sh "cake watch-lint" "jasmine-node --autotest --coffee ."

pc.sh is a simple little bash script to run both commands at the same time and respond to a Ctrl-C to the one pc.sh
command (instead of background shenanigans)

Available cake tasks:

    build       Just build the JS
    watch       Watch lib/ for changes, build and lint when changes occur
    watch-lint  Watch lib/ for changes, just lint, don't build

I have some Jasmine specs written in CoffeeScript around the codebase.  Running the jasmine-node with autotest
immediately runs the tests when one of the files is modified.  It's super cool.

*Note:* I'm a vim user and it appears that many of these do not always detect changes that vim makes if it is using swap
files.  For the moment, I've disabled vim swap files but made sure that backups are kept.  I also did a bunch of mucking
around with where files go on my MBA to avoid having tons of .swp, .swo, and ~ files around.  Here's the relevant bits
from my .vimrc:

    set noswapfile
    set backup
    set backupcopy=yes
    set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
    set backupskip=/tmp/*,/private/tmp/*
    set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
    set writebackup

