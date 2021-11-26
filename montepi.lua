local SDL = require "SDL"

SDL.init { SDL.flags.Video }

local width  = 640
local height = 480

local window, err = SDL.createWindow {
    title  = "TSP",
    width  = 640,
    height = 480,
    flags  = SDL.window.Resizable,
}

local renderer, err = SDL.createRenderer(window, 0, {})

local running = true
while running do
    for e in SDL.pollEvent() do
        if e.type == SDL.event.Quit then
            running = false
        elseif e.type == SDL.event.KeyDown then
            local code = e.keysym.scancode
            if code == SDL.scancode.Escape or code == SDL.scancode.Q then
                running = false
            elseif code == SDL.scancode.Space then
                pause = not pause
            end
        end
    end

    renderer:setDrawColor(0xff222222)
    renderer:clear()
    renderer:present()
end
