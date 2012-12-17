not ((context, definition) ->
  if 'function' is typeof require and
     typeof exports is typeof module
    return module.exports = definition
  return context.MiniHandlebars = definition
)(this, (->
  # constructor
  h = (@o={}, @templates={})-> # options, and templates

  # main render function
  h.prototype.render = (t, d) ->
    lvl = 1; toks = []; tokm = {}; d = h._extend @o.locals, d
    t.replace `/\{\{(\/\w+|#?\w+)( [\w, ]+)?\}\}/g`, ->
      a = arguments; cf = a[1][0] is '/' # closing block/function
      tok =
        s: a[0] # matched string
        b: b = typeof a[2] is 'string' # block/function
        a: (b and a[2].replace(/(^ +| +$)/, '').split(/, */)) or [] # block/function arguments
        v: b is cf # variable
        n: n = if b is cf then a[1] else if a[1][0] is '/' or a[1][0] is '#' then a[1].slice(1) else a[1] # name
        l: l = (b is cf and lvl) or (b and lvl++) or (cf and --lvl) # level
        k: l+'.'+n # key
        x: a[3] # x-coordinate character position
      return !!((l is 1) and
        (cf and toks[tokm[tok.k]].o = tok) or
        ((tok.v or tok.b) and tokm[tok.k] = toks.push(tok)-1) # map token keys to token array indicies
      ) or a[0]

    xs = 0 # x-coordinate shift +/-
    for k of toks when toks[k].l is 1
      ss=(l,r)-> # string splice
        t=t.substr(0,toks[k].x+xs)+r+t.substr(toks[k].x+l+xs)
        xs+=r.length-l
        return
      if toks[k].v
        ss toks[k].s.length, d[toks[k].n] # process variables
      else if toks[k].b
        ss toks[k].o.x + (toks[k].o.s.length - toks[k].x), # process blocks/functions
          d[toks[k].n].apply (->), [t.substr(toks[k].x + toks[k].s.length + xs,
            toks[k].o.x - (toks[k].x + toks[k].s.length)), d].concat toks[k].a

    return t

  # private helper method
  # if we depended on another lib for this we wouldn't need it, but we're stand-alone
  h._extend = ->
    o = {}; a = arguments
    for v of a
      for k of a[v]
        if {}.hasOwnProperty.call a[v], k
          o[k] = a[v][k]
    return o

  return h
)())
