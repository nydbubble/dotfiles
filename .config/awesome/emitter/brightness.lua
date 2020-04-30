-- Provides:
-- emitter::brightness
--  percentage (integer)
local awful = require("awful")

local brightness_subscribe_script = [[
  bash -c "
  while (inotifywait -e modify /sys/class/backlight/?**/brightness -qq) do echo 1; done
"]]

local brightness_script = [[
  sh -c "
  light -G
"]]

local function emit_brightness_info()
  awful.spawn.easy_async_with_shell(brightness_script, function(line)
      percentage = math.floor(tonumber(line))
      awesome.emit_signal("emitter::brightness", percentage)
    end
  )
end

emit_brightness_info()

awful.spawn.easy_async_with_shell("ps x | grep \"inotifywait -e modify /sys/class/backlight\" | grep -v grep | awk '{print $1}' | xargs kill", function ()
  awful.spawn.with_line_callback(brightness_subscribe_script, {
    stdout = function(_)
      emit_brightness_info()
    end
  })
end)
