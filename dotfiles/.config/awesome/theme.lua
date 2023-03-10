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

theme.hotkeys_bg                                = "#1d1f21"
theme.hotkeys_fg                                = "#fcfcfc"

theme.notification_fg                           = "#fcfcfc"
theme.notification_icon_size                    = 256

theme.border_width                              = dpi(default_border_size)
theme.border_normal                             = "#000000"
theme.border_focus                              = "#ff0000"
theme.border_marked                             = "#ff0000"

theme.tasklist_bg_focus                         = "#222222"
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus

theme.menu_height                               = dpi(26)
theme.menu_width                                = dpi(140)
theme.tasklist_plain_task_name                  = false
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = dpi(default_useless_gap)

theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"

local function create_widget(icon, seconds, cmd)
    local widget = awful.widget.watch(cmd, seconds,
        function(widget, stdout)
	    widget.markup =
	        icon .. '<span color="'..theme.fg_normal..'" font="'..theme.font..'">  '..stdout..'</span>'
        end)
    return widget
end

local blocks = {
    layout = wibox.layout.fixed.horizontal,
    --wibox.widget.systray(),
    create_widget("", 2,  "free -h | awk '/^Mem/ { print $3\"/\"$2 }' | sed s/i//g"),
    --create_widget("", 2,  "printf \"%.0f%%\" \"$(awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else print ($2+$4-u1) * 100 / (t-t1); }' <(grep 'cpu ' /proc/stat) <(sleep 1;grep 'cpu ' /proc/stat))\""),
    --create_widget("", 1,  "echo \"scale = 1; $(cat /sys/class/hwmon/hwmon0/temp1_input) / 1000\" | bc | tr -d '\n'; printf '°C'"),
    --create_widget("", 15, "[ \"$(pgrep redshift)\" == '' ] && echo '0' || redshift -p | grep 'temp' | awk '{print $3}'"),
    --create_widget("", 1,  "$HOME/.config/dotfiles/scripts/network-traffic.sh download"),
    --create_widget("", 1,  "$HOME/.config/dotfiles/scripts/network-traffic.sh upload"),
    --create_widget("﬌", 60, "cat ~/.cache/update"),
    --create_widget("", 60, "uptime --pretty | tail -c +4 | sed -E -e \'s/ (minutes|minute)/m/g\' -e \'s/ (hours|hour)/h/g\' -e \'s/ (day|days)/d/g\'"),
    create_widget("", 1, "cat /tmp/keyboard_layout"),
    --wibox.container.background(s.mylayoutbox, theme.bg_focus),
}

-- Separators
local spr     = wibox.widget.textbox(' ')

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
            spr,
            spr,
            s.mylayoutbox,
            spr,
            spr,
        },
        s.mytasklist, -- Middle widget
        blocks,
    }
end

theme.icon_theme = "/usr/share/icons/breeze-dark"

return theme
