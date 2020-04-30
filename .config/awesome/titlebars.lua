local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = gears.table.join(
  awful.button({ }, 1, function()
    c:emit_signal("request::activate", "titlebar", {raise = true})
    awful.mouse.client.move(c)
  end),
  awful.button({ }, 3, function()
    c:emit_signal("request::activate", "titlebar", {raise = true})
    awful.mouse.client.resize(c)
  end)
)

-- Create button
button_color_unfocused = "#E7EAEC"
function gen_button(c, color, hover_color, cmd)
  local ret = wibox.widget {
    {
      widget = wibox.container.background
    },
    forced_height = dpi(8),
    forced_width = dpi(35),
    shape = gears.shape.rectangle,
    bg = button_color_unfocused,
    widget = wibox.container.background
  }

  local button_widget = wibox.widget {
    ret,
--    right = dpi(5),
    widget = wibox.container.margin(),
  }
  button_widget:buttons(gears.table.join(
    awful.button({ }, 1, function ()
      cmd(c)
    end)
  ))

  -- Hover "animation"
  button_widget:connect_signal("mouse::enter", function ()
    ret.bg = hover_color
  end)
  button_widget:connect_signal("mouse::leave", function ()
    if c == client.focus then
      ret.bg = color
    else
      ret.bg = button_color_unfocused
    end
  end)

  c:connect_signal("focus", function ()
    ret.bg = color
  end)
  c:connect_signal("unfocus", function ()
    ret.bg = button_color_unfocused
  end)

  return button_widget
end

-- Functions for generated buttons
local window_close = function (c)
  c:kill()
end
local window_maximize = function (c)
  c.maximized = not c.maximized
  c:raise()
end
local window_minimize = function (c)
  c.minimized = true
end

local titlebar = awful.titlebar(c, {
  position = beautiful.titlebar_position,
  size = beautiful.titlebar_size
})

titlebar : setup {
  nil,
  { -- Middle
    buttons = buttons,
    layout  = wibox.layout.flex.horizontal
  },
  { -- Right
    {
      gen_button(c, "#CCEAE7", beautiful.color12, window_minimize),
      gen_button(c, "#80CBC4", beautiful.color12, window_maximize),
      gen_button(c, "#39ADB5", beautiful.color12, window_close),
      --awful.titlebar.widget.minimizebutton(c),
      -- awful.titlebar.widget.maximizedbutton(c),
      --awful.titlebar.widget.closebutton    (c),
      layout = wibox.layout.fixed.horizontal()
    },
    --right = 5,
    --top = 8,
    --bottom = 8,
    widget = wibox.container.margin,
  },
  layout = wibox.layout.align.horizontal
}
end)


