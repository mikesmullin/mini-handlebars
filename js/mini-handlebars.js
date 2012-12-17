!(function(context, definition) {
  if ('function' === typeof require && typeof exports === typeof module) {
    return module.exports = definition;
  }
  return context.MiniHandlebars = definition;
})(this, (function() {
  var h = function(o, templates) {
    this.o = o != null ? o : {};
    this.templates = templates != null ? templates : {};
  };
  h.prototype.render = function(t, d) {
    var k, lvl = 1, ss, tokm = {}, toks = [], xs;
    d = h._extend(this.o.locals, d);
    t.replace(/\{\{(\/\w+|#?\w+)( [\w, ]+)?\}\}/g, function() {
      var a, b, cf, l, n, tok;
      a = arguments;
      cf = a[1][0] === '/';
      tok = {
        s: a[0],
        b: b = typeof a[2] === 'string',
        a: (b && a[2].replace(/(^ +| +$)/, '').split(/, */)) || [],
        v: b === cf,
        n: n = b === cf ? a[1] : a[1][0] === '/' || a[1][0] === '#' ? a[1].slice(1) : a[1],
        l: l = (b === cf && lvl) || (b && lvl++) || (cf && --lvl),
        k: l + '.' + n,
        x: a[3]
      };
      return !!((l === 1) && (cf && (toks[tokm[tok.k]].o = tok)) || ((tok.v || tok.b) && (tokm[tok.k] = toks.push(tok) - 1))) || a[0];
    });
    xs = 0;
    for (k in toks) {
      if (!(toks[k].l === 1)) {
        continue;
      }
      ss = function(l, r) {
        t = t.substr(0, toks[k].x + xs) + r + t.substr(toks[k].x + l + xs);
        xs += r.length - l;
      };
      if (toks[k].v) {
        ss(toks[k].s.length, d[toks[k].n]);
      } else if (toks[k].b) {
        ss(toks[k].o.x + (toks[k].o.s.length - toks[k].x), d[toks[k].n].apply((function() {}), [t.substr(toks[k].x + toks[k].s.length + xs, toks[k].o.x - (toks[k].x + toks[k].s.length)), d].concat(toks[k].a)));
      }
    }
    return t;
  };
  h._extend = function() {
    var a = arguments, k, o = {}, v;
    for (v in a) {
      for (k in a[v]) {
        if ({}.hasOwnProperty.call(a[v], k)) {
          o[k] = a[v][k];
        }
      }
    }
    return o;
  };
  return h;
})());
