SDL = require "SDL"
SDL_image = package.loadlib("image", "luaopen_SDL_image")!
SDL_ttf = package.loadlib("ttf", "luaopen_SDL_ttf")!

assert SDL != nil
assert SDL_image != nil
assert SDL_ttf != nil

return {
  "SDL": SDL,
  "SDL_image": SDL_image,
  "SDL_ttf": SDL_ttf
}
