local SDL = require "SDL"
SDL.ttf = require "SDL.ttf"

function unwrap(ret_err)
    ret, err = ret_err
    if not ret then
        error(err)
    end
    return ret
end

unwrap(SDL.init { SDL.flags.Video })
unwrap(SDL.ttf.init())

local width  = 600
local height = width

local window = unwrap(SDL.createWindow {
    title  = "TSP",
    width  = width,
    height = height,
    -- flags  = SDL.window.Resizable,
})

local renderer = unwrap(SDL.createRenderer(window, 0, {}))

local font = unwrap(SDL.ttf.open("/usr/share/fonts/TTF/FiraMono-Regular.ttf", 28))

local points_in = {}
local points_out = {}

local pi = 3.14

local last_time_pi_string = SDL.getTicks()
local pi_string_draw_interval = 100
local texture = nil

local running = true
while running do
    for e in SDL.pollEvent() do
        if e.type == SDL.event.Quit then
            running = false
        elseif e.type == SDL.event.KeyDown then
            local code = e.keysym.scancode
            if code == SDL.scancode.Escape or code == SDL.scancode.Q then
                running = false
            end
        end
    end
    local point = { x = math.random() - 0.5, y = math.random() - 0.5 }
    if math.sqrt(point.x * point.x + point.y * point.y) < 0.5 then
        table.insert(points_in, point)
    else
        table.insert(points_out, point)
    end
    -- print(#points_in, #points_out)
    -- print(#points_in / #points_out)
    point.x = math.floor(point.x * width + width / 2)
    point.y = math.floor(point.y * height + height / 2)
    -- print(point.x, point.y)

    renderer:setDrawColor(0xff222222)
    renderer:clear()
    renderer:setDrawColor(0xffff00ff)
    renderer:drawPoints(points_in)
    renderer:setDrawColor(0xff00ffff)
    renderer:drawPoints(points_out)

    local current_time = SDL.getTicks()
    if current_time > last_time_pi_string + pi_string_draw_interval then
        local pi_estimate = 4 * (#points_in / (#points_out + #points_in))
        local surface = font:renderUtf8(string.format("%.20f", pi_estimate), "blended", { r = 255, g = 255, b = 255 })
        texture = renderer:createTextureFromSurface(surface)
        last_time_pi_string = current_time
    end
    local rect_w = 270
    local rect_h = 40
    local rect = {
        x = width / 2 - rect_w / 2,
        y = height / 2 - rect_h / 2,
        w = rect_w,
        h = rect_h,
    }
    if texture then
        renderer:copy(texture, nil, rect)
    end

    renderer:present()
    SDL.delay(3)
end

SDL.ttf.quit()
SDL.quit()
