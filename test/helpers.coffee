class global.Debugger
  @started: new Date()
  @log: (s) ->
    if console?
      current = new Date()
      s.unshift "[#{(current - @started) / 1000}s]"
      console.log s
