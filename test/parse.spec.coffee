"use strict"

ndparser = GLOBAL.ndparser
print = console.log

describe 'parse', ->
  str =
    '''
    /* block */
    (function(){
      return 123;;; // line
    })
    // he
    '''
  ast = ndparser.parse str

  program             = ast
  expressionStatement = ast.body[0]
  fnExpression        = expressionStatement.expression
  block               = fnExpression.body
  returnStatement     = block.body[0]

  it 'should parse string and return AST', ->
    ast.type.should.equal 'Program'
    ast.body[0].type.should.equal 'ExpressionStatement'

  it 'should have prev and next attribute for tokens', ->
    tokens = ast.tokens
    tokens[0].next.should.equal tokens[1]
    tokens[1].prev.should.equal tokens[0]

  it 'should have parent attribute', ->
    (ast.parent is null).should.be.true
    ast.body[0].parent.should.equal ast

  it 'should have depth attribute', ->
    program.depth.should.equal 0
    expressionStatement.depth.should.equal 1
    fnExpression.depth.should.equal 2
    block.depth.should.equal 3
    returnStatement.depth.should.equal 4

  it 'should have start_token and end_token attribute', ->
    program.start_token.value.should.equal '('
    program.end_token.value.should.equal ')'
    expressionStatement.start_token.value.should.equal '('
    expressionStatement.end_token.value.should.equal ')'
    fnExpression.start_token.value.should.equal 'function'
    fnExpression.end_token.value.should.equal '}'
    block.start_token.value.should.equal '{'
    block.end_token.value.should.equal '}'
    returnStatement.start_token.value.should.equal 'return'
    returnStatement.end_token.value.should.equal ';'

  it 'should have toString() method', ->
    ast.toString().should.equal str
    array = str.split('\n')
    exp = array.slice(1, array.length-1).join '\n'
    expressionStatement.toString().should.equal exp

