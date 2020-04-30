local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")

-- Timeouts
naughty.config.defaults.timeout = 8
naughty.config.presets.low.timeout = 5
naughty.config.presets.critical.timeout = 12

-- Apply theme variables
naughty.config.padding = beautiful.notification_padding
naughty.config.spacing = beautiful.notification_spacing
naughty.config.defaults.margin = beautiful.notification_margin
naughty.config.defaults.border_width = beautiful.notification_border_width

naughty.config.presets.normal = {
  font = beautiful.notification_font,
  fg = beautiful.notification_fg,
  border_width = beautiful.notification_border_width,
  margin = beautiful.notification_margin,
  position = beautiful.notification_position
}

naughty.config.presets.low = {
  font = beautiful.notification_font,
  fg = beautiful.notification_fg,
  border_width = beautiful.notification_border_width,
  margin = beautiful.notification_margin,
  position = beautiful.notification_position
}

naughty.config.presets.critical = {
  font = beautiful.notification_font,
  bg = beautiful.notification_crit_bg,
  fg = beautiful.notification_crit_fg,
  border_width = beautiful.notification_border_width,
  margin = beautiful.notification_margin,
  position = beautiful.notification_position
}

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors
  })
end
naughty.config.presets.ok = naughty.config.presets.low
naughty.config.presets.info = naughty.config.presets.low
naughty.config.presets.warn = naughty.config.presets.critical


-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err)
    })

    in_error = false
  end)
end

local battery_notification = require("notifications.battery")
