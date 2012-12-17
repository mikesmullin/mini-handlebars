# Why MiniHandleBars?

 * [82% Faster](http://jsperf.com/handlebars-vs-mini-handlebars/4) than the official library compiling from markup to html
 * 93% smaller file with just [73 lines](https://github.com/mikesmullin/mini-handlebars/blob/production/js/mini-handlebars.js) or [1.22KB minified (669 bytes gzipped)](https://raw.github.com/mikesmullin/mini-handlebars/production/js/mini-handlebars.min.js)
 * a TON more flexible; blocks are just javascript functions that take any number of arguments, and like express/sinatra we make no assumptions about which ones you want.
 * NO [dependencies](https://github.com/mikesmullin/mini-handlebars/blob/production/package.json)

Inspired by [coffeecup](https://github.com/gradus/coffeecup),
 [async2](https://github.com/mikesmullin/async2),
 [handlebars](http://handlebarsjs.com/), and
 [stylus](http://learnboost.github.com/stylus/) libraries.


## Quick Example

```coffeescript
# this line is how you do it in node
MiniHandlebars = require 'mini-handlebars'
# but isn't required in the browser
handlebars = new MiniHandlebars
  locals:
    santa_laugh: 'Ho, ho, ho!'
    # note that you define all your own blocks;
    # they are just functions that take any number of arguments
    # but the first two arguments are always the same and required.
    each: (template, data, enumerable, key, value) ->
      out = ''
      for k of data[enumerable]
        unless {}.hasOwnProperty data[enumerable], k # optional
          _data = MiniHandlebars._extend data[enumerable][k] # optional
          _data['this'] = _data['this'] || data[enumerable][k] # optional
          typeof key is 'undefined' or _data[key] = k # optional
          typeof value is 'undefined' or _data[value] = data[enumerable][k] # optional, you know what you need!
          out += handlebars.render template, _data
      out

# note that blocks and variables can be written
# the same; the additional pound (#) is optional.
# this is how i cache the templates in js:
handlebars.templates['test'] = '<!doctype html><html><head></head><body><p>Hello, {{name}}!</p><p>Here are your Christmas lists ({{santa_laugh}}):</p><table><thead><tr>{{each children, name}}<th>{{name}}</th>{{/each}}</tr></thead><tbody><tr>{{each children, name}}<td>{{each list}}<ul><li>{{this}}</li></ul>{{/each}}</td>{{/each}}</tr></tbody></table></body></html>'

# this will compile html output.
# there is no in-between-js-function render stage, and there may never be
# both-stages-in-one are already faster than the original lib
# and i found the time acceptable for my purposes.
console.log handlebars.render handlebars.templates['test'],
  name: 'Mike and Elise Smullin (Santa)'
  children:
    Landon:
      list: ['ninja turtles mask', 'mario kart legos', 'airplane']
    Bella:
      list: ['something sweet']
```

As usual, for the latest examples, review the easy-to-follow [./test/test.coffee](https://github.com/mikesmullin/mini-handlebars/blob/production/test/test.coffee).

Or try it immediately in your browser with [codepen](http://codepen.io/mikesmullin/pen/mdGtj).


TODO
----

* add support for triple-stach/escaping utils? i just haven't needed it, yet. its all unescaped by default.
