local wibox = require("wibox")
local beautiful = require("beautiful")

local helpers = require("helpers")

-- Configuration
local show_notification = true

-- Widget
local updates = wibox.widget {
  text = 'Update...',
  widget = wibox.widget.textbox
}

awesome.connect_signal("emitter::pacman", function (stdout)
  if stdout == 0 then
    updates.markup = "All sync"
  elseif stdout == -1 then
    updates.markup = "Network error"
  else
    updates.markup = "New " .. helpers.colorize_text(stdout, beautiful.color1) .. " pkg"
  end
end)

return updates
