local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")

local title_color = beautiful.mpd_song_title_color or beautiful.wibar_fg
local artist_color = beautiful.mpd_song_artist_color or beautiful.wibar_fg
local paused_color = beautiful.mpd_song_paused_color or beautiful.normal_fg

local playerctl_button_font = "monospace 16"
local playerctl_button_size = dpi(20)
local album_art_size = dpi(100)

local mpd_title = wibox.widget {
  text = "----------",
  valign = "center",
  font = "sans bold 12",
  widget = wibox.widget.textbox
}

local mpd_artist = wibox.widget {
  text = "----------",
  valign = "center",
  font = "sans 11",
  widget = wibox.widget.textbox
}

--local album_art = wibox.widget.imagebox()
--album_art.resize = true
--album_art.forced_width = album_art_size
--album_art.forced_height = album_art_size
--album_art.clip_shape = gears.shape.rounded_rect

local album_art = wibox.widget {
  {
    id = "cover",
    image = "./config/awesome/themes/icons/music.png",
    resize = true,
--    clip_shape = gears.shape.rounded_rect,
    forced_width = album_art_size,
    widget = wibox.widget.imagebox,
  },
  shape = gears.shape.rounded_rect,
  layout = wibox.container.background
}

-- Music control buttons
local playerctl_toggle_icon = wibox.widget.textbox("")
playerctl_toggle_icon.font = playerctl_button_font
playerctl_toggle_icon.forced_width = playerctl_button_size
playerctl_toggle_icon.forced_height = playerctl_button_size

playerctl_toggle_icon:buttons(gears.table.join(
  awful.button({ }, 1, function ()
    awful.spawn.with_shell("mpc -q toggle")
  end)
))

local playerctl_prev_icon = wibox.widget.textbox("")
playerctl_prev_icon.font = playerctl_button_font
playerctl_prev_icon.forced_width = playerctl_button_size
playerctl_prev_icon.forced_height = playerctl_button_size
playerctl_prev_icon:buttons(gears.table.join(
  awful.button({ }, 1, function ()
    awful.spawn.with_shell("mpc -q prev")
  end)
))

local playerctl_next_icon = wibox.widget.textbox("")
playerctl_next_icon.font = playerctl_button_font
playerctl_next_icon.forced_width = playerctl_button_size
playerctl_next_icon.forced_height = playerctl_button_size
playerctl_next_icon:buttons(gears.table.join(
  awful.button({ }, 1, function ()
    awful.spawn.with_shell("mpc -q next")
  end)
))

local playerctl_buttons = wibox.widget {
  nil,
  {
    playerctl_prev_icon,
    playerctl_toggle_icon,
    playerctl_next_icon,
    spacing = dpi(10),
    layout = wibox.layout.fixed.horizontal
  },
  nil,
  expand = "none",
  layout = wibox.layout.align.horizontal,
}


-- Main widget
local song_info = wibox.widget {
  {
    mpd_title,
    strategy = "exact",
    --width = dpi(100),
    height = dpi(26),
    widget = wibox.container.constraint
  },
  mpd_artist,
  playerctl_buttons,
  forced_width = dpi(130),
  layout = wibox.layout.align.vertical
}
local album_container = wibox.widget {
  album_art,
  left = dpi(14),
  right = dpi(10), 
  widget = wibox.container.margin
}
local mpd_song = wibox.widget {
  album_container,
  {
    song_info,
    --left = dpi(10),
    widget = wibox.container.margin
  },
  forced_height = dpi(100),
  layout = wibox.layout.fixed.horizontal
}

awesome.connect_signal("emitter::mpd", function(artist, title, cover_path, paused)
  title = string.gsub(title, "&", "&amp;")
  artist = string.gsub(artist, "&", "&amp;")
  album_art.cover:set_image(gears.surface.load_uncached(cover_path))

  mpd_title.text = title
  mpd_artist.text = artist
  if paused == true then
    playerctl_toggle_icon.markup = ""
  else
    playerctl_toggle_icon.markup = ""
  end

end)

return mpd_song
