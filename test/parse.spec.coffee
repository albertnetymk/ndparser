"use strict"

ndparser = GLOBAL.ndparser
print = console.log

describe 'parse', ->
  str =
    '''
    /* block */
    (function(){
      return 123; // line
    })
    '''
  ast = ndparser.parse str

  it 'should parse string and return AST', ->
    ast.type.should.equal 'Program'
    ast.body[0].type.should.equal 'ExpressionStatement'

  it 'should have parent attribute', ->
    (ast.parent is null).should.be.true
    ast.body[0].parent.should.equal ast

  it 'should have depth attribute', ->
    program             = ast
    expressionStatement = ast.body[0]
    fnExpression        = expressionStatement.expression
    block               = fnExpression.body
    returnStatement     = block.body[0]

    program.depth.should.equal 0
    expressionStatement.depth.should.equal 1
    fnExpression.depth.should.equal 2
    block.depth.should.equal 3
    returnStatement.depth.should.equal 4
