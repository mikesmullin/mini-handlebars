not ((context, definition) ->
  if 'function' is typeof require and
     typeof exports is typeof module
    return module.exports = definition
  return context.MiniHandlebars = definition
)(this, (->
  # constructor
  h = (@options={}, @templates={})->

  # main render function
  h.prototype.render = (t, d) ->
    lvl = 1; toks = []; tok_map = {}; d = h._extend @options.locals, d
    t.replace `/\{\{(\/\w+|\w+)( [\w, ]+)?\}\}\s*/g`, ->
      close_func = arguments[1][0] is '/'
      tok =
        match: arguments[0]
        name: name = if close_func then arguments[1].slice(1) else arguments[1]
        block: block = typeof arguments[2] is 'string' # a block must take arguments
        args: (block and arguments[2].replace(/(^ +| +$)/, '').split(/, */)) or []
        variable: block is close_func # when both are false; can never both be true
        level: level = (block is close_func and lvl) or (block and lvl++) or (close_func and --lvl)
        key: level+'.'+name
        position: arguments[3]
      return arguments[0] if level isnt 1
      if close_func
        toks[tok_map[tok.key]].mate = tok
      if tok.variable or tok.block
        tok_map[tok.key] = toks.push(tok)-1
      return arguments[0]

    xshift = 0
    for k of toks when toks[k].level is 1
      ssplice=(l,r)->
        t=t.substr(0,toks[k].position+xshift)+r+t.substr(toks[k].position+l+xshift)
        xshift+=r.length-l
        return
      if toks[k].variable
        ssplice toks[k].match.length, d[toks[k].name]
      else if toks[k].block
        ssplice toks[k].mate.position + (toks[k].mate.match.length - toks[k].position),
          d[toks[k].name].apply (->), [t.substr(toks[k].position + toks[k].match.length + xshift,
            toks[k].mate.position - (toks[k].position + toks[k].match.length)), d].concat toks[k].args

    return t

  # private helper method
  h._extend = ->
    o = {}; a = arguments
    for v of a
      for k of a[v]
        if {}.hasOwnProperty.call a[v], k
          o[k] = a[v][k]
    return o

  return h
)())
