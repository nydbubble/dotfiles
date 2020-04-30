-- Provides
-- emitter::wifi
-- 	ssid (string)

local awful = require("awful")

local update_interval = 3

local wifi_script = [[
	sh -c "
	iw dev wlp3s0 link
	"]]

-- Periodically get wifi info
awful.widget.watch(wifi_script, update_interval, function (widget,stdout)
	local essid = stdout:match("SSID:%s+(.-)\n")
	if (essid == nil) then
		essid = 'N/A'
	end
	awesome.emit_signal("emitter::wifi", essid)
end)
