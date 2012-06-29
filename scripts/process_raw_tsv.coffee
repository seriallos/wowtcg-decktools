#!/usr/bin/env coffee

###
  1. Get RAR from tcgbrowser.com staff
  2. Unrar
  3. Import XLS into Google Docs
  4. Download as text file (.tsv)
  5. Give to this script
###

csv = require('csv')
cli = require('commander')
fs  = require('fs')

cli.option('-f --file [file]', 'CSV File')
cli.option('-o --outdir [outdir]', 'Output Directory')
  .parse( process.argv )

outData = {}

keyMap = {
  atk: "attack"
}

defaults = {
  cost: 0
}

postProcess = {
  cost: parseInt,
  health: parseInt,
  attack: parseInt,
  block: parseInt,
  original: parseInt,
  released: parseInt,
  cardid: parseInt,
  no: parseInt,
}

if not cli.file or not cli.outdir
  console.log "USAGE: " + process.argv[0] + " -f CSVFILE -o OUTPUT_DIRECTORY"
else
  if '/' != cli.outdir[ cli.outdir.length - 1 ]
    cli.outdir += '/'
  csv()

     # tab delim, header row, no quotes
    .fromPath( cli.file, {
      delimiter: "\t",
      quote: '',
      columns: true
    } )

    # drop null values for size
    .transform (data) ->
      for key, val of data
        if not val
          if defaults[ key ]
            # this key has a defined default, use it
            data[ key ] = defaults[ key ]
          else
            # no default, delete it
            delete data[ key ]
        else
          if keyMap[ key ]
            data[ keyMap[ key ] ] = val
            delete data[ key ]
            # swap key name so we can use for postProcess
            key = keyMap[ key ]
          if postProcess[ key ]
            # post process callback defined, run it
            data[ key ] = postProcess[ key ]( val )

      # special cases
      if data.type == 'Quest'
        data.cost = 0

      return data

    # error reporting
    .on 'error', (error) ->
      console.log "Parse error! " + error.message

    # store records based on their set
    .on 'data', ( data, index ) ->
      set = data.setcode.toLowerCase()
      if not outData[ set ]
        outData[ set ] = {
          setcode: set,
          setname: data.setname,
          block: data.block,
          cards: []
        }
      # assume the shortest setname is the best (gets rid of loot and EA suffixes)
      if data.setname.length < outData[ set ].setname.length
        outData[ set ].setname = data.setname
      outData[ set ].cards.push( data )

    # write all the files out
    .on 'end', ->
      # once done, write out a bunch of files based on the set name
      setMap = {}
      for set, info of outData
        setMap[ set ] = { setname: info.setname, block: info.block }
        outFile = cli.outdir + set + '.json'
        fs.writeFile( outFile, JSON.stringify( info.cards ) )
      # write out a small JSON map of set code => set name
      indexFile = cli.outdir + "setlist.json"
      fs.writeFile( indexFile, JSON.stringify( setMap ) )
