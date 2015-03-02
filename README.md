# Ndparser

This package is the CoffeeScript implementation of
[rocambole](https://github.com/millermedeiros/rocambole), though not 100%
compatible, and contains much less feature.

## API


```coffee
ndparser = require 'ndparser'
print = console.log

string =
  '''
    function hello() {
      console.log(3);
    }
  '''

ast = ndparser.parse string
ndparser.walk ast, (node) ->
  print node.depth, node.type
```


## License

MIT
