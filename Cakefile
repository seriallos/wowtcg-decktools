fs = require 'fs'

{print} = require 'util'
{spawn} = require 'child_process'

build = (callback) ->
  coffee = spawn 'coffee', ['-c', '-o', 'lib', 'src']
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()
  coffee.on 'exit', (code) ->
    callback?() if code is 0

task 'build', 'Build coffee files in src into JS files in lib/', ->
  build()

task 'watch', 'Watch lib/ for changes', ->
  coffee = spawn 'coffee', ['-w', '-c', '-l', '-o', 'lib', 'src' ]
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()

task 'watch-lint', 'Continous linting of src/', ->
  coffee = spawn 'coffee', ['-w', '-l', '-o', 'lib', 'src' ]
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()
