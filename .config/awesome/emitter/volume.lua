-- Provides:
-- emitter::volume
-- 	volume percentage (integer)
-- 	muted (boolean)
-- emitter::microphone
-- 	muted (boolean)

local awful = require("awful")

local function emit_volume_info ()
	-- Get volume info
	awful.spawn.easy_async("pactl list sinks", function (stdout)
		local mute = stdout:match("Mute:%s+(%a+)")
		local volume = stdout:match("%s%sVolume:[%s%a-:%d/]+%s(%d+)%%")
		if mute == "yes" then
			awesome.emit_signal("emitter::volume", tonumber(volume), true)
		else
			awesome.emit_signal("emitter::volume", tonumber(volume), false)
		end
	end
	)
end

local function emit_microphone_info ()
	-- Use tail to grab the last line of the output (which refers to the microphone)
	awful.spawn.easy_async_with_shell("pacmd list-sources | grep muted | tail -1 | awk '{print $2}'", function (stdout)
		-- Remove trailing whitespace
		muted = stdout:gsub('^%s*(.-)%s*$', '%1')
		if muted == "yes" then
			awesome.emit_signal("evil::microphone", true)
		else
			awesome.emit_signal("evil::microphone", false)
		end
	end
	)
end

-- Run once to initialize widgets
emit_volume_info()
emit_microphone_info()

-- Sleeps until pactl detects an event (volume up/town/toggle mute)
local volume_script = [[
	bash -c '
	pactl subscribe 2> /dev/null | grep --line-buffered "sink"
']]

-- Sleeps until pactl detects an event (microphone volume up/down/(un) mute)
local microphone_script = [[
	bash -c '
	pactl subscribe 2> /dev/null | grep --line-buffered "source"
']]

-- Kill old pactl subscribe processes
awful.spawn.easy_async_with_shell("ps x | grep \"pactl subscribe\" | grep -v grep | awk '{print $1}' | xargs kill", function ()
	-- Run emit_volume_info() with each line printed
	awful.spawn.with_line_callback(volume_script, {
		stdout = function (_)
			emit_volume_info()
		end
	})
	-- Run emit_microphone_info() with each line printed
	awful.spawn.with_line_callback(volume_script, {
		stdout = function (_)
			emit_microphone_info()
		end
	})

end)