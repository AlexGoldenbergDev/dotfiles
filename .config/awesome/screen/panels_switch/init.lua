local awful         = require("awful")
local gears         = require("gears")
local beautiful     = require("beautiful")
local wibox         = require("wibox")
local dpi           = beautiful.xresources.apply_dpi
local icons         = require("commons.icons")
local shapes         = require("commons.shape")

local active_panel_switch_icon
local active_panel_switch_icon_section

local close_all_sub_panels = function(s)
  s.stats.visible    = false
  s.pacs.visible     = false
  s.docker.visible   = false
  s.repos.visible    = false
  s.user.visible     = false
  if active_panel_switch_icon and active_panel_switch_icon_section then
	active_panel_switch_icon_section.markup = "<span foreground='" .. beautiful.fg_normal .. "'>" .. active_panel_switch_icon .. "</span>"
  end
end


local create_munu_panel_button = function(glyph, text, btn_fn)
  
   local icon = icons.wbic(glyph, 12, beautiful.fg_normal)

   local btn = wibox.widget{
      {
	icon,
	forced_width  = dpi(25),
	forced_heigth = dpi(15),
        bg 	      = beautiful.palette_c7,
        shape         = shapes.circle(dpi(25)),
        widget 	  = wibox.container.background
      },
      margins = dpi(5),
      widget  = wibox.container.margin

  }

  awful.tooltip {
      objects        = { btn },
      timer_function = function()
          return text
      end,
  }

  btn_fn(btn, icon, glyph, text)
  return btn
end

local btn_setup = function(screen, panel)

  local close = function(icon, glyph)
    panel.visible  = false
    show_sub_panel = false
    icon.markup    = "<span foreground='" .. beautiful.fg_normal .. "'>" .. glyph .. "</span>"
  end


  local close_active = function(icon, glyph)
    show_sub_panel = false
    icon.markup  = "<span foreground='" .. beautiful.fg_normal .. "'>" .. glyph .. "</span>"
    close_all_sub_panels(screen)
  end
  

  return function(btn, icon, glyph, mode)
    btn:buttons(gears.table.join(awful.button({ }, 1, function()
      if sub_panel_mode == mode and show_sub_panel then
        close(icon, glyph)
      else
        if not sub_panel_mode ~= mode then
          close_active(icon, glyph)
        end

        sub_panel_mode = mode
        show_sub_panel = true
        panel.visible  = true
        icon.markup    = "<span foreground='" .. beautiful.fg_focus .. "'>" .. glyph .. "</span>"

        active_panel_switch_icon = glyph
        active_panel_switch_icon_section = icon

      end
    end)))
  end
end


return {
  create = function(s)
    return {
      layout = wibox.layout.fixed.horizontal,

      create_munu_panel_button("",  "User",     btn_setup(s, s.user)),
      create_munu_panel_button("", "Packages", btn_setup(s, s.pacs)),
      create_munu_panel_button("",  "Repos",   btn_setup(s, s.repos)),
      create_munu_panel_button("", "Docker",  btn_setup(s, s.docker)),
      create_munu_panel_button("", "Stats",   btn_setup(s, s.stats)),
    }
  end
}
