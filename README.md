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

Usage
-----

    ➜  wowtcg-decktools git:(master) ✗ ./bin/deckotron costs data/decks/famasin.deck
    Cost 0: 12 cards
    Cost 1: 4 cards
    Cost 2: 13 cards
    Cost 3: 12 cards
    Cost 4: 10 cards
    Cost 5: 4 cards
    Cost 6: 6 cards

    ➜  wowtcg-decktools git:(master) ✗ ./bin/deckotron costs data/decks/famasin.deck '{"type":"Ally"}'
    Cost 1: 3 cards
    Cost 2: 4 cards
    Cost 3: 8 cards
    Cost 4: 6 cards
    Cost 5: 2 cards
    Cost 6: 5 cards

    ➜  wowtcg-decktools git:(master) ✗ ./bin/deckotron count data/decks/famasin.deck '{"type":"Ability"}'
    19

    ➜  wowtcg-decktools git:(master) ./bin/deckotron -h

     Usage: deckotron [options] [command]

     Commands:
    
       costs [deck] [query]
       Report costs for a deck
    
       count [deck] [query]
       Get count of cards in a deck
    
     Options:
     
       -h, --help     output usage information
       -V, --version  output the version number

The query is a MongoDB-like JSON syntax.  Currently must be valid JSON (quoted keys, etc).  Some of the more complex filters don't work on the command line yet.

My Dev Cycle
------------

I like having a few terminal windows open always building and running the code.  My current workflow is to have 3
windows:

- Source editing
- Continuous linting, testing, and compilation
- Continuous execution of a test script to see results and runtime errors

**Continuous compilation, linting, and testing:**

    ./run-o-tron-5000.sh
    
    # this just runs the below:
    # ./pc.sh "cake watch" "jasmine-node --autotest --coffee src"

pc.sh is a simple little bash script to run both commands at the same time and respond to a Ctrl-C to the one pc.sh
command (instead of background shenanigans)

Available cake tasks:

    build       Just build the JS
    watch       Watch src/ for changes, build and lint when changes occur
    watch-lint  Watch src/ for changes, just lint, don't build

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

**Continuous execution:**

    while true; do coffee src/deckotron.coffee costs data/deck/famasin.deck; echo -e "\n\n"; sleep 1; done

I'm using a shell loop because 'watch coffee runner.coffee' makes error output unreadable.
