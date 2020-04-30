local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")

local helpers = {}

-- Create rounded rectangle shape (in one line)
helpers.rrect = function (radius)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, radius)
  end
end

helpers.prrect = function(radius, tl, tr, br, bl)
  return function(cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
  end
end

function helpers.colorize_text(txt, fg)
  return "<span foreground='" .. fg .. "'>" .. txt .. "</span>"
end

function helpers.pad(size)
  local str = ""
  for i = 1, size do
    str = str .. " "
  end
  local pad = wibox.widget.textbox(str)
  return pad
end

helpers.vertical_pad = function(height)
  return wibox.widget {
    forced_height = height,
    layout = wibox.layout.fixed.vertical
  }
end

return helpers
