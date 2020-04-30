-- Provides:
-- emitter::mpd
--  artist (string)
--  song (string)
--  paused (boolean)
local awful = require("awful")

local music_directory = "Music"
local script = [[bash -c '
IMG_REG="(front|cover|art)\.(jpg|jpeg|png|gif)$"
DEFAULT_ART="$HOME/.config/awesome/themes/icons/music.png"
file=`mpc current -f %file%`
info=`mpc -f "%artist%@@%title%@"`

art="$HOME/]] .. music_directory .. [[/${file%/*}"
if ]] .. "[[ -d $art ]];" .. [[ then
  cover="$(find "$art/" -maxdepth 1 -type f | egrep -i -m1 "$IMG_REG")"
  fi
  cover="${cover:=$DEFAULT_ART}"
  # convert "$cover" -resize 250x250 "resize.$cover"
  echo $info"##"$cover"##"
']]

local function emit_info()
--  awful.spawn.easy_async({"mpc", "-f", "[[%artist%@@%title%@]]"},
  awful.spawn.easy_async(script,
  function (stdout)
    local artist = stdout:match('(.*)@@')
    local title = stdout:match('@@(.*)@')
    title = string.gsub(title, '^%s*(.-)%s*$', '%1')
    local status = stdout:match('%[(%a+)%]')
    status = string.gsub(status, '^%s*(.-)%s*$', '%1')
    local cover_path = stdout:match('##(.*)##')

    local paused
    if status == "playing" then
      paused = false
    else
      paused = true
    end

    awesome.emit_signal("emitter::mpd", artist, title, cover_path, paused)
  end
  )
end

-- Run once to initialize widgets
emit_info()

local mpd_script = [[
sh -c '
mpc idleloop player
']]

-- Kill old mpc idleloop player process
awful.spawn.easy_async_with_shell("ps x | grep \"mpc idleloop player\" | grep -v grep | awk '{print $1}' | xargs kill", function ()
  -- Emit song info with each line printed
  awful.spawn.with_line_callback(mpd_script, {
    stdout = function(line)
      emit_info()
    end
  })
end)
