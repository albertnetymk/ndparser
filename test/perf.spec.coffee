"use strict"

ndparser = GLOBAL.ndparser
_fs = require('fs')

describe 'performance with jQuery', ->
  # cache the parsed jquery
  _jqueryAST = undefined

  describe 'ndparser.parse', ->
    it 'should not take forever to instrument jQuery', ->
      file = _fs.readFileSync(__dirname + '/files/jquery.js', 'utf-8')
      ast = ndparser.parse(file)
      _jqueryAST = ast
      @timeout 600

  describe 'ndparser.moonwalk', ->
    it 'should not take forever to loop over jQuery nodes', ->
      if not _jqueryAST
        file = _fs.readFileSync(__dirname + '/files/jquery.js', 'utf-8')
        _jqueryAST = ndparser.parse(file)
      count = 0
      ndparser.moonwalk _jqueryAST, (node) ->
        if !node
          throw new Error('node should not be undefined')
        count++
      count.should.be.above 20000
      @timeout 100
