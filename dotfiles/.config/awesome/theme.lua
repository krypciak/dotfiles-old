local dpi   = require("beautiful.xresources").apply_dpi
hotkeys_popup = require("awful.hotkeys_popup")
hotkeys_popup.hide_without_description = false


local os = os
local my_table = awful.util.table

theme                                           = {}
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/theme"
theme.font                                      = "Sans 11"
theme.font_bold                                 = "Sans Bold 11"

theme.fg_normal                                 = "#bbbbbb"
theme.fg_focus                                  = "#cccccc"
theme.fg_urgent                                 = "#cccccc"
theme.bg_normal                                 = "#222222"
theme.bg_focus                                  = "#005577"
theme.bg_urgent                                 = "#005577"

theme.blocks_fg                                 = "#eeeeee"

theme.hotkeys_bg                                = "#1d1f21"
theme.hotkeys_fg                                = "#fcfcfc"

theme.notification_fg                           = "#fcfcfc"
theme.notification_icon_size                    = 256

theme.border_width                              = dpi(default_border_size)
theme.border_normal                             = "#000000"
theme.border_focus                              = "#ff0000"
theme.border_marked                             = "#ff0000"

theme.tasklist_bg_focus                         = "#222222"

theme.taglist_fg_urgent                         = theme.bg_urgent
theme.taglist_bg_urgent                         = theme.fg_urgent
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"


theme.menu_height                               = dpi(26)
theme.menu_width                                = dpi(140)
theme.tasklist_plain_task_name                  = false
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = dpi(default_useless_gap)


local function create_widget(icon, seconds, cmd)
    local widget = awful.widget.watch(cmd, seconds,
        function(widget, stdout)
	    widget.markup =
	        '<span color="'..theme.blocks_fg..'" font="'..theme.font..'">  '..icon..stdout..'</span>'
        end)
    return widget
end


-- Separators
local spr     = wibox.widget.textbox(' ')

local blocks = {
    layout = wibox.layout.fixed.horizontal,
    --wibox.widget.systray(),
    create_widget("", 2,  'sh -c "$HOME/.config/dotfiles/scripts/bar/mem.sh"'),
    create_widget("", 2,  'sh -c "$HOME/.config/dotfiles/scripts/bar/cpu.sh"'),
    create_widget("", 1,  'sh -c "$HOME/.config/dotfiles/scripts/bar/cputemp.sh"'),
    create_widget("", 15, 'sh -c "$HOME/.config/dotfiles/scripts/bar/screentemp_redshift.sh"'),
    create_widget("", 1,  'sh -c "$HOME/.config/dotfiles/scripts/bar/network-traffic.sh download"'),
    create_widget("", 1,  'sh -c "$HOME/.config/dotfiles/scripts/bar/network-traffic.sh upload"'),
    create_widget("﬌", 60, 'sh -c "cat $HOME/.cache/update"'),
    create_widget(" ", 60, 'sh -c "$HOME/.config/dotfiles/scripts/bar/uptime.sh"'),
    create_widget(" ", 1, "cat /tmp/keyboard_layout"),
    create_widget("",   1, 'sh -c "$HOME/.config/dotfiles/scripts/bar/date.sh"'),
    spr,
    spr,
    spr,
}

mylayoutbox = require("mylayoutbox")

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    ext_group = 0
    ext_index = 0
    ext_noti = false
    assert(loadfile(userdir .. '/.config/dotfiles/scripts/wallpaper.lua', 't', _ENV))()

    s.mylayoutbox = mylayoutbox.new(s)

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.focused, nil)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = theme.menu_height, bg = theme.bg_normal, fg = theme.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            --spr,
            s.mytaglist,
            spr, spr, spr,
            s.mylayoutbox,
            spr, spr, spr,
        },
        s.mytasklist, -- Middle widget
        blocks,
    }
end

theme.icon_theme = "/usr/share/icons/breeze-dark"

return theme
