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

Constant JS compilation and linting:

    while true; do find . -name "*.coffee" -exec coffee -c -l {} \; ; sleep 1; done

Note: I want to use "coffee -w -l -c" but it likes to die with no reason.  In addition, find allows me to recursively
find any coffee files anywhere in the whole project.

Continuous execution:

    while true; do node runner.js; echo -e "\n\n"; sleep 1; done
