local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local active_color = beautiful.ram_bar_active_color or "#5AA3CC"
local background_color = beautiful.ram_bar_background_color or "#222222"

local ram_bar = wibox.widget {
  max_value = 100,
  value = 50,
  forced_height = dpi(10),
  margins = {
    top = dpi(8),
    bottom = dpi(8),
  },
  forced_width = dpi(200),
  shape = gears.shape.rounded_bar,
  bar_shape = gears.shape.rounded_bar,
  color = active_color,
  background_color = background_color,
  border_width = 0,
  border_color = beautiful.border_color,
  widget = wibox.widget.progressbar,
}


awesome.connect_signal("emitter::ram", function(used, total)
  local text = math.floor(used / total * 100 + 0.5)
  ram_bar.value = text
end)

return ram_bar
