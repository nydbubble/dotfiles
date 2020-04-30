local naughty = require("naughty")
local beautiful = require("beautiful")

local last_notification_id
local function send_notification(title, text, fg)
  notification = naughty.notify({
      title =  title,
      text = text,
      fg = fg,
      timeout = 7,
      --icon = beautiful.battery_icon,
      replaces_id = last_notification_id
  })
  last_notification_id = notification.id
end

local is_charging = false
local low_notify = false
local critical_notify = false
local full_notify = false

awesome.connect_signal("emitter::charger", function (charging)
  is_charging = charging
  if (charging == true) then
    send_notification("Plugged In", "Your battery is now charging.", beautiful.notification_fg)
  end
end)

awesome.connect_signal("emitter::battery", function(percentage)
  if (percentage <= 30 and low_notify == false and is_charging == false) then
    send_notification("Low Battery", "Battery level: " .. percentage .. "%", beautiful.notification_fg)
    low_notify = true
  end

  if (percentage <= 15 and critical_notify == false and is_charging == false) then
    send_notification("Critical Battery", "Battery level: " .. percentage .. "%", beautiful.notification_crit_fg)
    critical_notify = true
  end

  if (percentage == 100 and full_notify == false) then
    send_notification("Battery is full", "Battery has been fully charged", beautiful.notification_fg)
    full_notify = true
  end

  if (percentage > 30) then
    low_notify = false
    critical_notify = false
    if (percentage < 100) then
      full_notify = false
    end
  end


end)
