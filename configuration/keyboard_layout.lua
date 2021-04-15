local awful = require('awful')
local keyboard_layout = require("addons.keyboard_layout")


local kbdcfg = keyboard_layout.kbdcfg({type = "tui"})

kbdcfg.add_primary_layout("English", "US", "us")
kbdcfg.add_primary_layout("Greek", "GR", "el")

kbdcfg.bind()

-- Mouse bindings
kbdcfg.widget:buttons(
 awful.util.table.join(awful.button({ }, 1, function () kbdcfg.switch_next() end),
                       awful.button({ }, 3, function () kbdcfg.menu:toggle() end))
)