-- Provides
--  emitter::pacman
--    upd_pkg (string)
local awful = require("awful")

local update_interval = 7200 -- in seconds

local upd_script = [[ bash -c '
  wget -q --spider http://google.com

  if [ $? == 0 ]; then
    if ! updates_arch=$(checkupdates 2> /dev/null | wc -l ); then
      updates_arch=0
    fi

    if ! updates_aur=$(yay -Qum 2> /dev/null | wc -l); then
      updates_aur=0
    fi

    updates=$(("$updates_arch" + "$updates_aur"))
    echo $updates
  else
    echo "Offline"
  fi
']]

awful.widget.watch(upd_script, update_interval, function(widget, stdout)
  local upd_pkg = stdout:gsub("%s+", "")

  if upd_pkg == "0" then
    upd_pkg = 0 
  elseif upd_pkg == "Offline" then
    upd_pkg = -1 
  else
    upd_pkg = tonumber(upd_pkg)
  end

  awesome.emit_signal("emitter::pacman", upd_pkg)

end)
