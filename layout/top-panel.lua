local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local TaskList = require('widget.task-list')
local TagList = require('widget.tag-list')
local gears = require('gears')
local clickable_container = require('widget.material.clickable-container')
local mat_icon_button = require('widget.material.icon-button')
local mat_icon = require('widget.material.icon')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('theme.icons')

-- Titus - Horizontal Tray
local systray = wibox.widget.systray()
  systray:set_horizontal(true)
  systray:set_base_size(20)
  systray.forced_height = 20

  -- Clock / Calendar 24h format
-- local textclock = wibox.widget.textclock('<span font="Roboto Mono bold 9">%d.%m.%Y\n     %H:%M</span>')
-- Clock / Calendar 12AM/PM fornat
local textclock = wibox.widget.textclock('<span font="Roboto Mono 12">%I:%M %p</span>')
-- textclock.forced_height = 36

-- Add a calendar (credits to kylekewley for the original code)
local month_calendar = awful.widget.calendar_popup.month({
  screen = s,
  start_sunday = false,
  week_numbers = true
})
month_calendar:attach(textclock)

local clock_widget = wibox.container.margin(textclock, dpi(13), dpi(13), dpi(9), dpi(8))

local add_button = mat_icon_button(mat_icon(icons.plus, dpi(24)))
add_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn(
          awful.screen.focused().selected_tag.defaultApp,
          {
            tag = _G.mouse.screen.selected_tag,
            placement = awful.placement.bottom_right
          }
        )
      end
    )
  )
)

-- Create an imagebox widget which will contains an icon indicating which layout we're using.
-- We need one layoutbox per screen.
local LayoutBox = function(s)
  local layoutBox = clickable_container(awful.widget.layoutbox(s))
  layoutBox:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          awful.layout.inc(1)
        end
      ),
      awful.button(
        {},
        3,
        function()
          awful.layout.inc(-1)
        end
      ),
      awful.button(
        {},
        4,
        function()
          awful.layout.inc(1)
        end
      ),
      awful.button(
        {},
        5,
        function()
          awful.layout.inc(-1)
        end
      )
    )
  )
  return layoutBox
end

-- Keyboard Layout
local keyboard_layout = require("keyboard_layout")
local kbdcfg = require("configuration.keyboard_layout")
-- Widgets
local lain  = require("lain")
local markup = lain.util.markup
local wfont,wcolor = "Roboto medium 10", "#ffffff"

-- CPU
local cpuicon = wibox.widget{
  wibox.widget{
    widget = wibox.widget.imagebox,
    image  = icons.cpu,
    resize = true,
    forced_height = 20,
    forced_width = 20
  },
  -- top = dpi(5),
  -- bottom = dpi(5),
  -- left = dpi(5),
  -- right = dpi(5),
  margins = dpi(7),
  widget = wibox.container.margin
}
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.fontfg(wfont, wcolor, cpu_now.usage .. "% "))
    end
})

-- Coretemp
-- local tempicon = wibox.widget.imagebox(theme.widget_temp)
local tempicon = wibox.widget{
  wibox.widget{
    widget = wibox.widget.imagebox,
    image  = icons.thermometer,
    resize = true,
    forced_height = 20,
    forced_width = 20
  },
  margins = dpi(7),
  widget = wibox.container.margin
}
local temp = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.fontfg("Roboto medium 10", "#ffffff", coretemp_now .. "°C "))
    end
})

-- MEM
-- local memicon = wibox.widget.imagebox(theme.widget_mem)
local memicon = wibox.widget{
  wibox.widget{
    widget = wibox.widget.imagebox,
    image  = icons.ram,
    resize = true,
    forced_height = 20,
    forced_width = 20
  },
  margins = dpi(7),
  widget = wibox.container.margin
}
local memory = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.fontfg(wfont,wcolor, mem_now.used .. "M "))
    end
})
-- Fan 
-- local fsicon = wibox.widget.imagebox(theme.widget_fs)
local fsicon = wibox.widget{
  wibox.widget{
    widget = wibox.widget.imagebox,
    image  = icons.cpufan,
    resize = true,
    forced_height = 20,
    forced_width = 20
  },
  margins = dpi(7),
  widget = wibox.container.margin
}
local fs = lain.widget.fs({
    notification_preset = { font = wfont, fg = "#aaaaaa" },
    settings  = function()
        widget:set_markup(markup.fontfg(wfont, wcolor, string.format("%.1f", fs_now["/"].used) .. "% "))
    end
})

-- NEt
local netdownicon = wibox.widget{
  wibox.widget{
    widget = wibox.widget.imagebox,
    image  = icons.downarrow,
    resize = true,
    forced_height = 20,
    forced_width = 20
  },
  margins = dpi(7),
  widget = wibox.container.margin
}
local netdowninfo = wibox.widget.textbox()
local netupicon = wibox.widget{
  wibox.widget{
    widget = wibox.widget.imagebox,
    image  = icons.uparrow,
    resize = true,
    forced_height = 20,
    forced_width = 20
  },
  margins = dpi(7),
  widget = wibox.container.margin
}
local netupinfo = lain.widget.net({
    settings = function()
        --[[ uncomment if using the weather widget
        if iface ~= "network off" and
           string.match(theme.weather.widget.text, "N/A")
        then
            theme.weather.update()
        end
        --]]

        widget:set_markup(markup.fontfg(wfont, wcolor, net_now.sent .. " "))
        netdowninfo:set_markup(markup.fontfg(wfont, wcolor, net_now.received .. " "))
    end
})

-- ALSA volume
-- local volicon = wibox.widget{
--   wibox.widget{
--     widget = wibox.widget.imagebox,
--     image  = icons.volume,
--     resize = true,
--     forced_height = 20,
--     forced_width = 20
--   },
--   margins = dpi(7),
--   widget = wibox.container.margin
-- }
-- local volume = lain.widget.alsa({
--     settings = function()
--         if volume_now.status == "off" then
--             volume_now.level = volume_now.level .. "M"
--         end

--         widget:set_markup(markup.fontfg(wfont, wcolor, volume_now.level .. "% "))
--     end
-- })

local TopPanel = function(s)
  
    local panel =
    wibox(
    {
      ontop = true,
      screen = s,
      height = dpi(32),
      width = s.geometry.width,
      x = s.geometry.x,
      y = s.geometry.y,
      stretch = false,
      bg = beautiful.background.hue_800,
      fg = beautiful.fg_normal,
      struts = {
        top = dpi(32)
      }
    }
    )

    panel:struts(
      {
        top = dpi(32)
      }
    )

    panel:setup {
      layout = wibox.layout.align.horizontal,
      {
        layout = wibox.layout.fixed.horizontal,
        -- Create a taglist widget
        TagList(s),
        TaskList(s),
        add_button
      },
      nil,
      {
        layout = wibox.layout.fixed.horizontal,
        netdownicon,
        netdowninfo,
        netupicon,
        netupinfo.widget,
        -- tempicon,
        -- temp,
        -- fsicon,
        -- fs,
        cpuicon,
        cpu.widget,
        memicon,
        memory,
        -- volicon,
        -- volume,
        wibox.container.margin(systray, dpi(3), dpi(3), dpi(6), dpi(3)),
        -- Layout box
        LayoutBox(s),
        -- Keyboard Layout
        kbdcfg.widget,
        -- Clock
        clock_widget,
      }
    }

  return panel
end

return TopPanel
