local userdir = os.getenv('HOME')
wallpaper_dir = userdir .. '/.config/wallpapers/'
local wallpaper_selected_file = wallpaper_dir .. 'selected'

local default_group = 1
local default_index = 2

local wallpapers = {
    {  'oneshot/main.png', 'oneshot/MemoryOfaDistantPlace.gif', 'oneshot/library.png', 'oneshot/factory.png' },
    { 'autumn.png' },
    { '#000000', '#303030' }
}
local custom_scaling_wallpapers = {}
custom_scaling_wallpapers['oneshot/MemoryOfaDistantPlace.gif'] = 'Nearest'

local hour_wallpapers = true
local hour_wallpapers_array = {
    { hour_start = 6, hour_end = 21, wallpaper = 'oneshot/MemoryOfaDistantPlace.gif' },
    { hour_start = 21, hour_end = 6, wallpaper = 'oneshot/main.png' },
}

local wallpaper_name_map = {}
for group=1, #wallpapers, 1 do
    for index=1, #wallpapers[group], 1 do
        wallpaper_name_map[wallpapers[group][index]] = { group=group, index=index }
    end
end

-- Function to retrieve console output
function os.capture(cmd)
    local handle = assert(io.popen(cmd, "r"))
    local output = assert(handle:read("*a"))
    handle:close()
    return output
end

local in_group
local in_index
local mode
local isx11

if arg then
    mode = arg[1]
    if mode == 'inc' or mode == 'set' then
        in_group = tonumber(arg[2])
        in_index = tonumber(arg[3])
    elseif mode == 'wayland-gui' then
        mode = 'gui'
        isx11 = false
    elseif mode == 'x11-gui' then
        mode = 'gui'
        isx11 = true
    elseif mode == 'x11-hour_check' then
        mode = 'hour_check'
        isx11 = true
    elseif mode == 'wayland-hour_check' then
        mode = 'hour_check'
        isx11 = false
    end
end
if not mode then
    isx11 = true
    mode = 'gui'
end
if ext_init and ext_init == 1 then
    isx11 = true
    mode = 'inc'
    in_group = 0
    in_index = 0
end
print('mode: ' .. mode)


local group = tonumber(default_group)
local index = tonumber(default_index)

local file = io.open(wallpaper_selected_file, "r")

local read_wallpaper
if file then
    read_wallpaper = file:read()
    file:close()
    if mode == 'inc' then
        local tuple = wallpaper_name_map[read_wallpaper]
        group = tuple.group
        index = tuple.index
    end
end

if mode == 'inc' then
   group = group + in_group
   if group > #wallpapers then group = 1
   elseif 0 >= group      then group = #wallpapers end

   index = index + in_index
   if index > #wallpapers[group] then index = 1
   elseif 0 >= index             then index = #wallpapers[group] end

elseif mode == 'set' then
    group = in_group
    index = in_index

elseif mode == 'hour_check' then
    if not hour_wallpapers then return end
    local time = os.date("*t")
    for i=1, #hour_wallpapers_array, 1 do
        local tuple = hour_wallpapers_array[i]

        if tuple.hour_start < tuple.hour_end and (time.hour >= tuple.hour_start and time.hour <= tuple.hour_end) or (time.hour >= tuple.hour_start or time.hour <= tuple.hour_end) then
            local tuple1 = wallpaper_name_map[tuple.wallpaper]
            group = tuple1.group
            index = tuple1.index
            print('matched: ' .. tuple.hour_start .. '-' .. tuple.hour_end .. ' ' .. tuple.wallpaper)
        end
    end
end


local current_wallpaper
if mode == 'gui' and not isx11 then
   local cmd1 = ''
   for k, _ in pairs(wallpaper_name_map) do
       cmd1 = cmd1 .. k .. '\n'
   end

    current_wallpaper = os.capture("cd $HOME/.config/wallpapers; find . -type f -iname '*.png' -o -iname '*.gif' | awk '{print substr($1, 3)}' | xargs printf \'" .. cmd1 .. "\' | fuzzel -d --log-level=none | head -c -1")
elseif mode == 'gui' and isx11 then
   local cmd1 = ''
   for k, _ in pairs(wallpaper_name_map) do
       cmd1 = cmd1 .. k .. '\n'
   end

    current_wallpaper = os.capture("cd $HOME/.config/wallpapers; find . -type f -iname '*.png' -o -iname '*.gif' | awk '{print substr($1, 3)}' | xargs printf \'" .. cmd1 .. "\' | rofi -dmenu | head -c -1")
else
    current_wallpaper = wallpapers[group][index]
end
print(current_wallpaper)

file = io.open(wallpaper_selected_file, "w")
if file then
    file:write(current_wallpaper .. '\n')
    file:close()
end

if not isx11 then
    function set_wallpaper(wallpaper)
        if wallpaper:find('^#') then
            os.execute('swww clear "' .. wallpaper .. '"')
        else
            local scaling_method = custom_scaling_wallpapers[wallpaper]
            if scaling_method then
                scaling_method = '--filter ' .. scaling_method .. ' '
            end
            os.execute('swww img --sync ' .. scaling_method .. wallpaper_dir .. wallpaper)
        end
    end

    local out = os.capture("swww query | awk '{print $8}' | tail -c +2 | head --lines 1 | head -c -2")
    if out ~= '' then
        read_wallpaper = os.capture("cd $HOME/.config/wallpapers; find . -type f -iname '" .. out .. "' | awk '{print substr($1, 3)}' | head --lines 1 | head -c -1")
    end
end

if current_wallpaper == read_wallpaper then
    print("wallpaper the same, not changing")
end

if isx11 or current_wallpaper ~= read_wallpaper then
    set_wallpaper(current_wallpaper, not ext_noti)
end
