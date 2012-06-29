fs = require 'fs'

{print} = require 'util'
{spawn} = require 'child_process'

build = (callback) ->
  coffee = spawn 'coffee', ['-c', 'lib']
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()
  coffee.on 'exit', (code) ->
    callback?() if code is 0

task 'build', 'Build JS files in lib/', ->
  build()

task 'watch', 'Watch lib/ for changes', ->
  coffee = spawn 'coffee', ['-w', '-c', '-l', 'lib' ]
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()

task 'watch-lint', 'Continous linting of lib/', ->
  coffee = spawn 'coffee', ['-w', '-l', 'lib' ]
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()
