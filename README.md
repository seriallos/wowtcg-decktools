wowtcg-decktools
================

Tools for WoW TCG deck information, analysis, and optimization

Written in CoffeeScript primarily as a learning exercise.  Probably going to be a little bit of a pain for anyone else
to use.

Mostly hacked together data and scripts for now.  Just want to have a place to keep some of this random stuff together.

Ideas
-----

- Deck composition/stats
- First hand stats

My Dev Cycle
------------

I like having a few terminal windows open always building and running the code.  My current workflow is to have 3
windows:

- Source editing
- Continuous linting and building to JS for build/syntax errors
- Continuous execution of a test script to see results and runtime errors

**Continuous compilation, linting, and testing:**

    cake watch
    jasmine-node --autotest --coffee src

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

    while true; do coffee runner.coffee; echo -e "\n\n"; sleep 1; done

I'm using a shell loop because 'watch coffee runner.coffee' makes error output unreadable.
