local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local gears = require("gears")

if beautiful.border_radius ~= 0 then
  client.connect_signal("manage", function (c, startup)
    if not c.fullscreen and not c.maximized then
      c.shape = helpers.rrect(beautiful.border_radius)
    end
end)

-- Fullscreen and maximized clients should not have rounded corners
local function no_rounded_corners (c)
  if c.fullscreen or c.maximized then
    c.shape = gears.shape.rectangle
  else
    c.shape = helpers.rrect(beautiful.border_radius)
  end
end

client.connect_signal("property::fullscreen", no_rounded_corners)
client.connect_signal("property::maximized", no_rounded_corners)

beautiful.snap_shape = helpers.rrect(beautiful.border_radius * 2)
else
  beautiful.snap_shape = gears.shape.rectangle
end

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup
    and not c.size_hints.user_position
    and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

