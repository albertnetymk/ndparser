exports = this
esprima = require('esprima')
print = console.log

BYPASS_RECURSION =
  root : true
  comments : true
  tokens : true

  loc : true
  range : true

  parent : true
  next : true
  prev : true

  type : true
  raw : true

  startToken : true
  endToken : true

# line_breaks :: String -> [Node]
line_breaks = (source) ->
  i = 0
  lbs = []
  while true
    i = source.indexOf('\n', i)
    break if i is -1
    lbs.push { range: [i, i+1], type: 'LineBreak', value: '\n'}
    i++
  lbs

# before :: Node -> Node -> Bool
before = (a, b) ->
  return a.range[0] < b.range[0]

# merge :: [Node] -> [Node] -> [Node]
merge = (a, b) ->
  c = []
  i = j = 0
  while i < a.length and j < b.length
    if before a[i], b[j]
      c.push a[i++]
    else
      c.push b[j++]
  while i < a.length
    c.push a[i++]
  while j < b.length
    c.push b[j++]
  return c

# insert_space :: [Node] -> [Node]
omitted_spaces = (nodes) ->
  spaces = []
  for n,i in nodes[..-2]
    diff = nodes[i+1].range[0] - n.range[1]
    if diff isnt 0
      range = [n.range[1], nodes[i+1].range[0]]
      spaces.push { range: range, type: 'WhiteSpace', value: n_space diff }
  return spaces

# n_space :: Int -> String
n_space = (n) ->
  res = (' ' for i in [1..n])
  res.join ''

full_tokens = (source, ast) ->
  tokens = ast.tokens

  comments = ast.comments
  tokens = merge tokens, comments

  lbs = line_breaks source
  tokens = merge tokens, lbs

  spaces = omitted_spaces tokens
  tokens = merge tokens, spaces

# walk :: Node -> (Node -> Void) -> Void
exports.walk = walk = (node, f, parent) ->
  return unless node and node.type
  _walk = (n) -> walk n, f, node
  f node, parent
  for own k,v of node
    continue if not v or typeof v isnt 'object' or BYPASS_RECURSION[k]
    if typeof v.type is 'string'
      _walk v
    else if typeof v.length is 'number'
      _walk n for n in v

exports.moonwalk = (node, f) ->
  nodes = []
  walk node, (n) ->
    if not nodes[n.depth]
      nodes[n.depth] = []
    nodes[n.depth].push n
  for ns in nodes by -1
    for n in ns
      f n

add_parent = (ast) ->
  f = (node, parent) ->
    node.parent = parent
  walk ast, f, null

add_depth = (ast) ->
  walk ast, (node) ->
    if node.parent
      node.depth = node.parent.depth + 1
    else
      node.depth = 0

exports.parse = (source) ->
  opt =
    range: true
    tokens: true
    comment: true
  ast = esprima.parse source, opt
  ast.tokens = full_tokens source, ast

  add_parent ast
  add_depth ast

  ast
