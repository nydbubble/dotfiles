-- Provides
-- emitter::battery
-- 	percentage (integer)
-- emitter::charger
-- 	plugged (boolean)
--
local awful = require("awful")

local update_interval = 30

local battery_script = [[
sh -c "
acpi | cut -d, -f 2 | grep -Po [0-9]+ | awk '{print $1}'
"]]

local charger_script = [[
sh -c '
acpi_listen | grep --line-buffered ac_adapter
']]

-- Periodically get battery info
awful.widget.watch(battery_script, update_interval, function (widget,stdout)
  local battery = stdout:gsub("%%", "")
  awesome.emit_signal("emitter::battery", tonumber(battery))
end)

local emit_charger_info = function ()
  awful.spawn.easy_async_with_shell("cat /sys/class/power_supply/*/online", function (out)
    status = tonumber(out)
    if status == 1 then
      awesome.emit_signal("emitter::charger", true)
    else
      awesome.emit_signal("emitter::charger", false)
    end
  end)
end

-- Run once to initialize widgets
emit_charger_info()

-- Kill old acpi_listen process
awful.spawn.easy_async_with_shell("ps x | grep \"acpi_listen\" | grep -v grep | awk '{print $1}' | xargs kill", function ()
  -- Update charger status with each line printed
  awful.spawn.with_line_callback(charger_script, {
    stdout = function(_)
      emit_charger_info()
    end
  })

end)
