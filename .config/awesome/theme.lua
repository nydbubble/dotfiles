---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears = require("gears")
local awful = require("awful")

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local thp = string.format("%s/.config/awesome/themes/", os.getenv("HOME"))

local theme = {}

theme.font          = "sans 10"
theme.nerd_font     = "SFMono Nerd Font 10"
theme.bar_font      = "monospace 8"

-- Get colors from .Xresources and set fallback colors
theme.background = "#fafafa"
theme.foreground = "#1d1f28"
theme.color0 = "#434758"
theme.color1 = "#E53935" 
theme.color2 = "#91B859"
theme.color3 = "#FFB62C"
theme.color4 = "#6182B8"
theme.color5 = "#7C4DFF"
theme.color6 = "#39ADB5"
theme.color7 = "#8796B0"
theme.color8 = "#CCD7DA"
theme.color9 = "#E53935"
theme.color10 = "#91B859"
theme.color11 = "#FFB62C"
theme.color12 = "#8796B0"
theme.color13 = "#6182B8"
theme.color14 = "#7C4DFF"
theme.color15 = "#39ADB5"
theme.color16 = "#d65d0e"

local urgent_color = theme.color9
local accent_color = theme.color15
local focused_color = theme.color15
local unfocused_color = theme.color8
local backdrop_color = theme.color16

theme.bg_dark       = theme.background
theme.bg_normal     = theme.background
theme.bg_focus      = theme.background
theme.bg_urgent     = theme.background
theme.bg_minimize   = theme.color8
theme.bg_systray    = bg_dark

theme.fg_normal     = theme.color7
theme.fg_focus      = focused_color
theme.fg_urgent     = urgent_color
theme.fg_minimize   = theme.color8.."88"

-- Tag names
local symb = "  "
--theme.tagnames = { symb, symb, symb, symb, symb, symb, symb }
theme.tagnames = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

-- Widget separator
theme.separator_text = "  "
theme.separator_fg = theme.color8

-- Gaps
theme.useless_gap   = dpi(8)
theme.screen_margin = dpi(5)

-- Borders
theme.border_width  = dpi(0)
theme.border_normal = theme.color0
theme.border_focus  = theme.color0
theme.border_radius = dpi(0)

-- Edge snap
theme.snap_bg = theme.bg_focus
if theme.border_width == 0 then
    theme.snap_border_width = dpi(0)
else
    theme.snap_border_width = theme.border_width * 2
end

-- Titlebars
theme.titlebars_enabled = true
theme.titlebar_size = dpi(8)
theme.titlebar_title_enabled = false
theme.titlebar_font = "sans-serif 10" 
-- Window title alignment: left, right, center
theme.titlebar_title_align = "center"
-- Titlebar position: top, left, bottom, right
theme.titlebar_position = "top"
-- Use 4 titlebars around the window to imitate borders
theme.titlebars_imitate_borders = false
theme.titlebar_bg = theme.background
theme.titlebar_fg_focus = theme.color15
theme.titlebar_fg_normal = theme.color7

-- Systray
theme.bg_systray = theme.background

-- Wibar
theme.wibar_position = "bottom"
theme.wibar_bg = theme.background .. "EE"
theme.wibar_fg = theme.foreground
theme.wibar_height = dpi(30)
theme.wibar_width = dpi(1200)
theme.wibar_border_color = theme.color0
theme.wibar_border_width = 0

-- Sidebar
theme.sidebar_bg = theme.background .. "EE"
theme.sidebar_fg = theme.foreground
theme.sidebar_container_bg = theme.background .. "33"
theme.sidebar_opacity = 1
theme.sidebar_width = dpi(300)
theme.sidebar_height = awful.screen.focused().geometry.height

-- Widgets
theme.disk_icon_color = theme.color10

theme.battery_bar_background_color = theme.color4 .. "33"
theme.battery_bar_active_color = theme.color4
theme.battery_bar_icon_color = theme.color4

theme.volume_bar_background_color = theme.color6 .. "33"
theme.volume_bar_active_color = theme.color6
theme.volume_bar_icon_color = theme.color6

theme.brightness_bar_background_color = theme.color2 .. "33"
theme.brightness_bar_active_color = theme.color2
theme.brightness_bar_icon_color = theme.color2

theme.ram_bar_background_color = theme.color1 .. "33"
theme.ram_bar_active_color = theme.color1
theme.ram_bar_icon_color = theme.color1

theme.cpu_bar_background_color = theme.color3 .. "33"
theme.cpu_bar_active_color = theme.color3
theme.cpu_bar_icon_color = theme.color3

theme.temp_bar_background_color = theme.color7 .. "33"
theme.temp_bar_active_color = theme.color7
theme.temp_bar_icon_color = theme.color7

-- Tasklist
theme.tasklist_plain_task_name = true
theme.tasklist_align = "center"
theme.tasklist_disable_icon = true
theme.tasklist_bg_focus = theme.color0
theme.tasklist_fg_focus = focused_color
theme.tasklist_bg_normal = theme.color0
theme.tasklist_fg_normal = unfocused_color
theme.tasklist_bg_minimize = theme.color0
theme.tasklist_fg_minimize = theme.fg_minimize
theme.tasklist_bg_urgent = theme.color0
theme.tasklist_fg_urgent = urgent_color
theme.tasklist_spacing = 5
theme.tasklist_shape = gears.shape.rectangle
theme.tasklist_shape_border_width = 1
theme.tasklist_shape_border_color = theme.tasklist_fg_normal

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Taglist
local ntags = 5
theme.taglist_font = "sans 20"
--theme.taglist_bg_focus = theme.color0 .. "00"
--theme.taglist_bg_occupied = theme.color0 .. "00"
--theme.taglist_bg_empty = theme.color0 .. "00"
--theme.taglist_bg_urgent = theme.color0 .. "00"
theme.taglist_disable_icon = false
theme.taglist_spacing = dpi(0)
theme.taglist_item_roundness = theme.border_radius

theme.taglist_text_occupied = {"","","","","","","","","",""}
theme.taglist_text_focused = {"","","","","","","","","",""}
theme.taglist_text_empty = {"","","","","","","","","",""}
theme.taglist_text_urgent   = {"","","","","","","","","",""}

theme.taglist_text_color_empty = { theme.color8, theme.color8, theme.color8, theme.color8, theme.color8, theme.color8, theme.color8, theme.color8, theme.color8, theme.color8 }
theme.taglist_text_color_occupied = { theme.color1, theme.color2, theme.color3, theme.color4, theme.color5, theme.color6, theme.color1, theme.color2, theme.color3, theme.color4 }
theme.taglist_text_color_focused = { theme.color1, theme.color2, theme.color3, theme.color4, theme.color5, theme.color6, theme.color1, theme.color2, theme.color3, theme.color4 }
theme.taglist_text_color_urgent = { theme.color9, theme.color9, theme.color9, theme.color9, theme.color9, theme.color9, theme.color9, theme.color9, theme.color9 }


-- Generate taglist squares:
--local taglist_square_size = dpi(0)
--theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
--    taglist_square_size, theme.fg_focus
--)
--theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
--    taglist_square_size, theme.fg_normal
--)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Notification
theme.notification_bg = theme.background
theme.notification_fg = theme.foreground
theme.notification_crit_bg = theme.background
theme.notification_crit_fg = theme.color2
theme.notification_margin = dpi(15) 
theme.notification_padding = theme.screen_margin
theme.notification_spacing = theme.screen_margin * 2
theme.notification_width = dpi(350)
theme.notification_icon_size = dpi(48)
theme.notification_border_color = theme.foreground
theme.notification_border_width = 0
theme.notification_shape = gears.shape.rectangle
theme.notification_position = "top_right"
theme.notification_font = "sans 12"

-- Exit screen
theme.exit_screen_bg = "#000000" .. "66"
theme.exit_screen_fg = "#FFFFFF" 
theme.exit_screen_font = "sans 20"
theme.exit_screen_icon_size = dpi(140)

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
local recolor = gears.color.recolor_image
local circle_png = thp.."icons/titlebar_circle.svg"

theme.titlebar_close_button_normal = recolor(circle_png, theme.color8)
theme.titlebar_close_button_focus  = recolor(circle_png, theme.color1)
theme.titlebar_close_button_focus_hover = recolor(circle_png, theme.color9)

theme.titlebar_minimize_button_normal = recolor(circle_png, theme.color8)
theme.titlebar_minimize_button_focus  = recolor(circle_png, theme.color3)
theme.titlebar_minimize_button_focus_hover = recolor(circle_png, theme.color11)

theme.titlebar_maximized_button_normal_inactive = recolor(circle_png, theme.color8)
theme.titlebar_maximized_button_focus_inactive  = recolor(circle_png, theme.color2)
theme.titlebar_maximized_button_focus_inactive_hover = recolor(circle_png, theme.color10)
theme.titlebar_maximized_button_normal_active = recolor(circle_png, theme.color8)
theme.titlebar_maximized_button_focus_active  = recolor(circle_png, theme.color2)
theme.titlebar_maximized_button_focus_active_hover = recolor(circle_png, theme.color10)

theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"

theme.wallpaper = thp.."/wallpaper.jpg"

-- You can use your own layout icons like this:
theme.layout_fairh = thp.."/layouts/fairhw.png"
theme.layout_fairv = thp.."/layouts/fairv.png"
theme.layout_floating  = thp.."/layouts/floating.png"
theme.layout_magnifier = thp.."/layouts/magnifier.png"
theme.layout_max = thp.."/layouts/max.png"
theme.layout_fullscreen = thp.."/layouts/fullscreen.png"
theme.layout_tilebottom = thp.."/layouts/tilebottom.png"
theme.layout_tileleft   = thp.."/layouts/tileleft.png"
theme.layout_tile = thp.."/layouts/tile.png"
theme.layout_tiletop = thp.."/layouts/tiletop.png"
theme.layout_spiral  = thp.."/layouts/spiral.png"
theme.layout_dwindle = thp.."/layouts/dwindle.png"
theme.layout_cornernw = thp.."/layouts/cornernw.png"
theme.layout_cornerne = thp.."/layouts/cornerne.png"
theme.layout_cornersw = thp.."/layouts/cornersw.png"
theme.layout_cornerse = thp.."/layouts/cornerse.png"

-- Minimal tasklist widget variables
theme.minimal_tasklist_visible_clients_color = focused_color
theme.minimal_tasklist_visible_clients_text = "  "
theme.minimal_tasklist_hidden_clients_color = theme.color8
theme.minimal_tasklist_hidden_clients_text = "  "

-- Exit screen icons
theme.poweroff = thp.."icons/power.svg"
theme.exit = thp.."icons/logout.svg"
theme.reboot = thp.."icons/restart.svg"
theme.suspend = thp.."icons/power-sleep.svg"
theme.lock = thp.."icons/lock.svg"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
