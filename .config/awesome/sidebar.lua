local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local awful = require("awful")

local helpers = require("helpers")

local margin = beautiful.useless_gap + beautiful.screen_margin
local icon_font = "monospace 18"
local icon_size = dpi(35)
local progress_bar_width = dpi(200)

local function format_progress_bar(bar, icon)
  icon.forced_height = icon_size
  icon.forced_width = icon_size
  icon.font = icon_font
  --icon.markup = "<span font=\"" .. icon_font .. "\">" .. icon .. "</span>"
--  icon.align = "center"
  bar.forced_width = progress_bar_width
  bar.shape = gears.shape.rounded_rect
  bar.bar_shape = gears.shape.rounded_rect

  local w = wibox.widget {
    nil,
    {
      icon,
      bar,
      spacing = dpi(2),
      layout = wibox.layout.fixed.horizontal
    },
    expand = "none",
    layout = wibox.layout.align.horizontal
  }

  return w
end

-- Ram widget
local ram_bar = require("widgets.ram_bar")
local ram_icon = wibox.widget.textbox()
ram_icon.markup = helpers.colorize_text("", beautiful.ram_bar_icon_color)
local ram = format_progress_bar(ram_bar, ram_icon)

-- Ram widget
local brightness_bar = require("widgets.brightness_bar")
local brightness_icon = wibox.widget.textbox()
brightness_icon.markup = helpers.colorize_text("", beautiful.brightness_bar_icon_color)
local brightness = format_progress_bar(brightness_bar, brightness_icon)

-- Volume widget
local volume_bar = require("widgets.volume_bar")
local volume_icon = wibox.widget.textbox()
volume_icon.markup = helpers.colorize_text("墳", beautiful.volume_bar_icon_color)
awesome.connect_signal("emitter::volume", function(_, muted)
  if muted then
    volume_icon.markup = helpers.colorize_text("婢", beautiful.volume_bar_icon_color)
  else
    volume_icon.markup = helpers.colorize_text("墳", beautiful.volume_bar_icon_color)
  end
end)
local volume = format_progress_bar(volume_bar, volume_icon)

-- Battery bar
local battery_bar = require("widgets.battery_bar")
local battery_icon = wibox.widget.textbox()
battery_icon.markup = helpers.colorize_text("", beautiful.battery_bar_icon_color)
awesome.connect_signal("emitter::charger", function(plugged)
  if plugged then
    battery_icon.markup = helpers.colorize_text("", beautiful.battery_bar_icon_color)
  else
    battery_icon.markup = helpers.colorize_text("", beautiful.battery_bar_icon_color)

  end
end)
local battery = format_progress_bar(battery_bar, battery_icon)

-- Cpu bar
local cpu_bar = require("widgets.cpu_bar")
local cpu_icon = wibox.widget.textbox()
cpu_icon.markup = helpers.colorize_text("", beautiful.cpu_bar_icon_color)
local cpu = format_progress_bar(cpu_bar, cpu_icon)

-- Temperature bar
local temp_bar = require("widgets.temperature_bar")
local temp_icon = wibox.widget.textbox()
temp_icon.markup = helpers.colorize_text("﫵", beautiful.temp_bar_icon_color)
local temp = format_progress_bar(temp_bar, temp_icon)

-- Disk widget
local disk_space = require("widgets.disk")
disk_space.font = "sans 14"
local disk_icon = wibox.widget.textbox(helpers.colorize_text("", beautiful.disk_icon_color))
disk_icon.font = icon_font
disk_icon.forced_width = icon_size
disk_icon.forced_height = icon_size
local disk = wibox.widget {
  nil,
  {
    disk_icon,
    disk_space,
    layout = wibox.layout.fixed.horizontal
  },
  nil,
  expand = "none",
  layout = wibox.layout.align.horizontal
}

local sysinfo = wibox.widget {
  volume,
  brightness,
  cpu,
  ram,
  temp,
  battery,
  helpers.vertical_pad(20),
  disk,
  layout = wibox.layout.fixed.vertical
}

-- MPD Song info
local mpd_song = require("widgets.mpd_song")
local mpd_widget_children = mpd_song:get_all_children()
local mpd_title = mpd_widget_children[1]
local mpd_artist = mpd_widget_children[2]
mpd_title.font = "sans medium 14"
mpd_artist.font = "sans 11"

mpd_title.forced_height = dpi(24)
mpd_artist.forced_height = dpi(18)

-- User info area
local user_text = wibox.widget.textbox()
user_text.font = "sans medium 13"
local username = os.getenv("USER")
awful.spawn.easy_async_with_shell("hostname", function (out)
  out = out:gsub('^%s*(.-)$s*$', '%1')
  user_text.markup = username .. "@" .. out
end)

local kernel_text = wibox.widget.textbox()
kernel_text.font = "sans medium 13"
awful.spawn.easy_async_with_shell("uname -r | cut -d '-' -f1", function (out)
  kernel_text.markup = "Kernel: " .. out
end)

local updates_info = require("widgets.pacman_pkg")
updates_info.font = "sans medium 13"

local user_info_area = wibox.layout.align.vertical()
user_info_area:set_top(user_text)
user_info_area:set_middle(wibox.container.constraint(kernel_text, "exact", nil, dpi(26)))
user_info_area:set_bottom(updates_info)

local user_picture = wibox.widget {
  {
    image = gears.surface.load_uncached(os.getenv("HOME").."/.face"),
    widget = wibox.widget.imagebox
  },
  shape = gears.shape.circle,
  forced_height = dpi(100),
  forced_width = dpi(100),
  widget = wibox.container.background
}


local user_area = wibox.widget {
  {
    user_picture,
    left = dpi(14),
    right = dpi(14),
    widget = wibox.container.margin
  },
  user_info_area,
  widget = wibox.layout.fixed.horizontal
}

-- Search icon
local search_icon = wibox.widget.textbox(helpers.colorize_text("", beautiful.color6))
search_icon.font = icon_font
search_icon.forced_width = icon_size
search_icon.forced_height = icon_size

local search_text = wibox.widget.textbox("Search")
search_text.font = "sans 14"

local search = wibox.widget {
  search_icon,
  search_text,
  layout = wibox.layout.fixed.horizontal
}
search:buttons(gears.table.join(
  awful.button({ }, 1, function ()
    awful.spawn.with_shell("~/.config/rofi/launcher.sh")
  end)
))

-- Exit button
local exit_icon = wibox.widget.textbox(helpers.colorize_text("", beautiful.color7))
exit_icon.font = icon_font
exit_icon.forced_width = icon_size
exit_icon.forced_height = icon_size
local exit_text = wibox.widget.textbox("Exit")
exit_text.font = "sans 14"

local exit = wibox.widget {
  exit_icon,
  exit_text,
  layout = wibox.layout.fixed.horizontal
}
exit:buttons(gears.table.join(
  awful.button({ }, 1, function ()
    exit_screen_show()
    sidebar.visible = false
  end)
))

local bottompart = wibox.widget{ 
  nil,
  {
    search,
    exit,
    spacing = dpi(50),
    layout = wibox.layout.fixed.horizontal
  },
  nil,
  expand = "none",
  layout = wibox.layout.align.horizontal
}

-- Create the sidebar
local sidebar_shape = function(cr, width, height)
  gears.shape.partially_rounded_rect(cr, width, height, false, true, true, false, 6)
end

sidebar = wibox({visible = false, ontop = true, type = "dock"})
sidebar.bg = beautiful.sidebar_bg or beautiful.wibar_bg or "#111111"
sidebar.fg = beautiful.sidebar_fg or beautiful.wibar_fg or "#FFFFFF"
sidebar.opacity = beautiful.sidebar_opacity or 1
sidebar.height = beautiful.sidebar_height - beautiful.wibar_height - margin * 2 or awful.screen.focused().geometry.height
sidebar.width = beautiful.sidebar_width or dpi(300)
awful.placement.left(sidebar)
sidebar.y = beautiful.wibar_height + margin
sidebar.shape = sidebar_shape

sidebar:buttons(gears.table.join(
  awful.button({ }, 2, function()
    sidebar.visible = false
  end)
))

sidebar:connect_signal("mouse::leave", function ()
  sidebar.visible = false
end)

local container = function(widget, height)
  return {
    {
      {
        nil,
        widget,
        nil,
        expand = "none",
        layout = wibox.layout.align.vertical
      },
      forced_height = height,
      shape = gears.shape.rectangle,
      shape_border_width = dpi(0),
      shape_border_color = "#000000",
      bg = beautiful.sidebar_container_bg,
      widget = wibox.container.background
    },
    left = margin,
    right = margin,
    top = margin,
    widget = wibox.container.margin,
  }
end

sidebar:setup {
  container(user_area, sidebar.height * 0.18),
  container(mpd_song, sidebar.height * 0.18),
  container(sysinfo, sidebar.height * 0.4),
  container(bottompart, sidebar.height * 0.1),
  layout = wibox.layout.fixed.vertical
}
