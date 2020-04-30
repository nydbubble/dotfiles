local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local keys = require("keys")
local helpers = require("helpers")

-- Textclock widget
local icon_font = "monospace 10"
local time_icon = wibox.widget {
  markup = helpers.colorize_text(" ", beautiful.color9),
  valign = "center",
  font = icon_font,
  widget = wibox.widget.textbox
}
local time_text = wibox.widget.textclock("%H:%M")
time_text.valign = "center"

local clock_widget = wibox.widget {
  time_icon,
  time_text,
  spacing = dpi(6),
  layout = wibox.layout.fixed.horizontal
}

local date_icon = wibox.widget {
  markup = helpers.colorize_text(" ", beautiful.color10),
  valign = "center",
  font = icon_font,
  widget = wibox.widget.textbox
}
local date = wibox.widget.textclock("%d")
local date_day = wibox.widget.textclock("%a")

local date_widget = wibox.widget {
  date_icon,
  date,
  date_day,
  spacing = dpi(6),
  layout = wibox.layout.fixed.horizontal
}

-- Wifi widget
local wifi_icon = wibox.widget {
  text = "  ",
  valign = "center",
  font = icon_font,
  widget = wibox.widget.textbox
}
local wifi = wibox.widget.textbox("N/A")
awesome.connect_signal("emitter::wifi", function (essid)
  wifi.markup = helpers.colorize_text(essid, beautiful.color0)
end)
local wifi_widget = wibox.widget {
  wifi_icon,
  wifi,
  spacing = dpi(3),
  layout = wibox.layout.fixed.horizontal
}

-- Hamburger menu
local menu = wibox.widget {
  text = " ",
  valign = "center",
  font = icon_font,
  widget = wibox.widget.textbox
}
menu:buttons(gears.table.join( awful.button(
  { }, 1, function() sidebar.visible = not sidebar.visible end
)))

-- Item separator
textseparator = wibox.widget.textbox()
textseparator.text = beautiful.separator_text

-- Padding
pad = wibox.widget.textbox(" ")

-- }}}

-- Helper function that updates a taglist item
local update_taglist = function (item, tag, index)
  if tag.selected then
    item.font = "monospace 10"
    item.markup = helpers.colorize_text(beautiful.taglist_text_focused[index], beautiful.taglist_text_color_focused[index])
  elseif tag.urgent then
    item.font = "monospace 10"
    item.markup = helpers.colorize_text(beautiful.taglist_text_urgent[index], beautiful.taglist_text_color_urgent[index])
  elseif #tag:clients() > 0 then
    item.font = "monospace 10"
    item.markup = helpers.colorize_text(beautiful.taglist_text_occupied[index], beautiful.taglist_text_color_occupied[index])
  else
    item.font = "monospace 10"
    item.markup = helpers.colorize_text(beautiful.taglist_text_empty[index], beautiful.taglist_text_color_empty[index])
end
end

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
  awful.button({ }, 1, function () awful.layout.inc( 1) end),
  awful.button({ }, 3, function () awful.layout.inc(-1) end),
  awful.button({ }, 4, function () awful.layout.inc( 1) end),
  awful.button({ }, 5, function () awful.layout.inc(-1) end)))
  -- Create a layoutbox container
  s.layoutboxsection = wibox.widget {
    s.mylayoutbox,
    top = 10,
    bottom = 10,
    --left = 20,
    --right = 20,
    widget = wibox.container.margin,
  }
  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist {
    screen = s,
    filter = awful.widget.taglist.filter.all,
    buttons = keys.taglist_buttons,
    layout = wibox.layout.fixed.horizontal,
    widget_template = {
      widget = wibox.widget.textbox,
      create_callback = function (self, tag, index, _)
        self.align = "center"
        self.valign = "center"
        self.forced_width = dpi(25)
        update_taglist(self, tag, index)
      end,
      update_callback = function (self, tag, index, _)
        update_taglist(self, tag, index)
      end,
    }
  }

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist {
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    buttons = keys.tasklist_buttons,
    style = {
      font = beautiful.bar_font,
    },
    widget_template = {
      {
        {
          {
            id = "text_role",
            widget = wibox.widget.textbox,
          },
          left = 10,
          right = 10,
          widget = wibox.container.margin,
        },
        id = "background_role",
        shape_border_width = 1,
        shape_border_color = beautiful.color8,
        shape = gears.shape.rectangle,
        widget = wibox.container.background,
      },
      margins = 5,
      widget = wibox.container.margin,
    },
  }
  s.mytasklist:set_max_widget_size(dpi(170))


  -- Create the wibox
  s.mywibox = awful.wibar({ontop = false, type = "dock", position = "top", height = beautiful.wibar_height, screen = s })

  -- Add widgets to the wibox
  s.mywibox:setup {
     {
        {
          layout = wibox.layout.fixed.horizontal
        },
        menu,
        clock_widget,
        date_widget,
        spacing = dpi(20),
        layout = wibox.layout.fixed.horizontal
      },
      s.mytaglist,
      {
        wifi_widget,
        s.layoutboxsection,
        {
          layout = wibox.layout.fixed.horizontal
        },
        spacing = dpi(20),
        layout = wibox.layout.fixed.horizontal
      },
      expand = "none",
      layout = wibox.layout.align.horizontal
    }
    -- Place bar and add margins
    --awful.placement.top(s.mywibox, {margins = beautiful.screen_margin * 2})
    -- Also add some screen padding so that clients do not stick to the bar
    --s.padding = { top = s.padding.top + beautiful.screen_margin * 2}
    s.systray = wibox.widget.systray()
    s.traybox = wibox({visible = false, ontop = true, type = "normal"})
    s.traybox.width = dpi(120)
    s.traybox.height = beautiful.wibar_height
    awful.placement.bottom_left(s.traybox, {honor_workarea = true, margins = beautiful.screen_margin * 2})
    s.traybox.bg = "#00000000"
    s.traybox:setup {
      s.systray,
      bg = beautiful.bg_systray,
      shape = gears.shape.rectangle,
      widget = wibox.container.background
    }
    s.traybox:connect_signal("mouse::leave", function ()
      s.traybox.visible = false
    end)


end)

-- Disable wibar ontop on fullscreen clients
local function no_wibar_ontop(c)
  local s = awful.screen.focused()
  if c.fullscreen then
    s.mywibox.ontop = false
  else
    s.mywibox.ontop = true
  end
end

client.connect_signal("focus", no_wibar_ontop)
client.connect_signal("unfocus", no_wibar_ontop)
client.connect_signal("property::fullscreen", no_wibar_ontop)

-- Every bar theme should provide these functions
function toggle_wibars()
  local s = awful.screen.focused()
  s.mywibox.visible = not s.mywibox.visible
end

function toggle_tray()
  local s = awful.screen.focused()
  s.traybox.visible = not s.traybox.visible
end
