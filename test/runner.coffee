"use strict"

Mocha = require('mocha')
should = require 'should'

GLOBAL.ndparser = require('../src/ndparser.coffee');

opts =
  ui : 'bdd'
  reporter : (process.env.REPORTER || 'spec')
  grep : process.env.GREP
  compilers : 'coffee:coffee-script'
  require: 'should'

opts.reporter = 'dot' if process.env.TRAVIS;

m = new Mocha(opts)

m.invert() if process.env.INVERT

m.addFile('test/parse.spec.coffee');
m.addFile('test/perf.spec.coffee');

m.run (err) ->
    exitCode = err? 1 : 0
    process.exit(exitCode)
