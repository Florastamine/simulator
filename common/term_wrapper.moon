term = require "term"

assert term != nil

term.black       = 0
term.blue        = 1
term.green       = 2
term.cyan        = 3
term.red         = 4
term.purple      = 5
term.brown       = 6
term.lightGray   = 7
term.gray        = 8
term.lightBlue   = 9
term.lightGreen  = 10
term.lightCyan   = 11
term.lightRed    = 12
term.magenta     = 13
term.yellow      = 14
term.white       = 15
term.old         = 0

_print = (message, color = term.lightGreen, action = () ->) ->
  term.old = term.getTextColor()
  term.setTextColor(color)
  io.stdout\write(message)
  term.setTextColor(term.old)
  action!

return {
  panic: (message) ->
    _print(string.format("[%s] %s\n", os.date(), message), term.red, os.exit)
  
  info: (message) ->
    _print(string.format("[%s] %s\n", os.date(), message))
}
