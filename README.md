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

**Continuous compilation and linting:**

    cake watch

Available cake tasks:

    build       Just build the JS
    watch       Watch src/ for changes, build and lint when changes occur
    watch-lint  Watch src/ for changes, just lint, don't build

**Continuous execution:**

    while true; do coffee runner.coffee; echo -e "\n\n"; sleep 1; done

I'm using a shell loop because 'watch coffee runner.coffee' makes error output unreadable.
