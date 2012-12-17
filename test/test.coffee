MiniHandlebars = require '../js/mini-handlebars'
assert = require('chai').assert

describe 'MiniHandlebars', ->
  handlebars = undefined
  beforeEach ->
    handlebars = new MiniHandlebars
      locals:
        santa_laugh: 'Ho, ho, ho!'
        each: (template, data, enumerable, key, value) ->
          out = ''
          for k of data[enumerable]
            unless {}.hasOwnProperty data[enumerable], k
              _data = MiniHandlebars._extend data[enumerable][k]
              _data['this'] = data[enumerable][k]
              typeof key is 'undefined' or _data[key] = k
              typeof value is 'undefined' or _data[value] = data[enumerable][k]
              out += handlebars.render template, _data
          out

  it 'works simply', ->
    template = '<ul class="people_list">\n{{each people}}\n<li>{{this}}</li>\n{{/each}}\n</ul>'
    data = people: ["Yehuda Katz", "Alan Johnson", "Charles Jolley"]
    out = handlebars.render template, data
    assert.equal out, "<ul class=\"people_list\">\n\n<li>Yehuda Katz</li>\n\n<li>Alan Johnson</li>\n\n<li>Charles Jolley</li>\n\n</ul>"

  it 'works recursively with or without # for blocks', ->
    handlebars.templates['test'] = '<!doctype html><html><head></head><body><p>Hello, {{name}}!</p><p>Here are your Christmas lists ({{santa_laugh}}):</p><table><thead><tr>{{#each children, name}}<th>{{name}}</th>{{/each}}</tr></thead><tbody><tr>{{each children, name}}<td>{{each list}}<ul><li>{{this}}</li></ul>{{/each}}</td>{{/each}}</tr></tbody></table></body></html>'
    out = handlebars.render handlebars.templates['test'],
      name: 'Mike and Elise Smullin (Santa)'
      children:
        Landon:
          list: ['ninja turtles mask', 'mario kart legos', 'airplane']
        Bella:
          list: ['something sweet']
    assert.equal out, "<!doctype html><html><head></head><body><p>Hello, Mike and Elise Smullin (Santa)!</p><p>Here are your Christmas lists (Ho, ho, ho!):</p><table><thead><tr><th>Landon</th><th>Bella</th></tr></thead><tbody><tr><td><ul><li>ninja turtles mask</li></ul><ul><li>mario kart legos</li></ul><ul><li>airplane</li></ul></td><td><ul><li>something sweet</li></ul></td></tr></tbody></table></body></html>"
