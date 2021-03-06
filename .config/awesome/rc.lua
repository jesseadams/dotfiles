-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")

-- Theme handling library
require("beautiful")

-- Notification library
require("naughty")

-- Extras
--require("luarocks.require")
require("vicious")
--require("yaml")
require("weather")

-- Delightful widgets
require('delightful.widgets.battery')
require('delightful.widgets.cpu')
--require('delightful.widgets.datetime')
--require('delightful.widgets.imap')
require('delightful.widgets.memory')
require('delightful.widgets.network')
--require('delightful.widgets.pulseaudio')
--require('delightful.widgets.weather')

-- Load YAML Config
--file = io.open('/home/jadams1/.config/awesome/awesome.yml', 'r')
--config = yaml.load(file:read("*all"))

naughty_width = 600 -- in pixels
naughty.config.presets.low.width = naughty_width
naughty.config.presets.normal.width = naughty_width
naughty.config.presets.critical.width = naughty_width
naughty.config.default_preset.icon = "/home/jadams1/.config/awesome/naughty.png"
naughty.config.default_preset.bg = "#ffff00"
naughty.config.default_preset.fg = "#000000"

--obvious.volume_alsa.setchannel("Master")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init("/usr/share/awesome/themes/test/theme.lua")
beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")
--beautiful.init("/usr/share/awesome/themes/dust-clean/theme.lua")
--beautiful.init("/home/jadams1/.config/awesome/themes/resonance/theme.lua")

--naughty.notify({ title = "Theme Information", text = "Detected Resolution: " .. beautiful.resolution .. "\nScreen Mode: " .. beautiful.screens })

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
  names = { "im", "web", "term" },
  layout = { layouts[1], layouts[2], layouts[3] }
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

myutilmenu = {
   { "Lock", "xscreensaver-command --lock" },
   { "Shutdown", "gksu '/sbin/shutdown -h now'" },
   { "Restart", "gksu /sbin/reboot" }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "session", myutilmenu },
                                    { "open terminal", terminal },
                                    { "file browser", "urxvt -e ranger" }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
-- mytextclock = awful.widget.textclock({ align = "right" })
mytextclock = awful.widget.textclock({ align = "right" }, " %m/%d %I:%M %P", 30)

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Vicious Widgets
    wifiwidget = widget({ type = "textbox" })
    vicious.register(wifiwidget, vicious.widgets.wifi, " | W: ${ssid} ${link}%", 13, 'wlan0') 
    memwidget = widget({ type = "textbox" })
    vicious.register(memwidget, vicious.widgets.mem, " | <span color='yellow'>M: $1%</span>  ", 13) 
    cpuwidget = widget({ type = "textbox" })
    vicious.register(cpuwidget, vicious.widgets.cpu, " | <span color='orange'>C: $1%</span>")
    batwidget = widget({ type = "textbox" })
    vicious.register(batwidget, vicious.widgets.bat, " | <span color='yellow'>$1$2 ($3)</span> ", 13, "BAT0")
    volwidget = widget({ type = "textbox" })
    vicious.register(volwidget, vicious.widgets.volume, " | <span color='orange'>$1 $2</span>", 1, "Master")
    fswidget = widget({ type = "textbox" })
    vicious.register(fswidget, vicious.widgets.fs, " | <span color='green'>${/ used_gb}/${/ size_gb}GB (${/ used_p}%)</span> ", 13, "/dev/sda3")
   
    -- Devour
   -- rssbox = {}
   -- rssbox = widget({ type = "textbox", name = "rss" })
   -- feed = "http://acunote:acunote@acunote.cashnetusa.com/timeline/news_feed?tkn=8957393FA6C464DB4E8773F9F79804F2"
   -- devour.register(rssbox, feed, { name = "Acunote" })

    forecast = widget({ type = "textbox", name = "weather" })
    weather.register(forecast, 60614)

    -- Which widgets to install?
    -- This is the order the widgets appear in the wibox.
    install_delightful = {
        delightful.widgets.network,
    --    delightful.widgets.cpu,
    --    delightful.widgets.memory,
    --    delightful.widgets.weather,
    --    delightful.widgets.imap,
    --    delightful.widgets.battery
    --    delightful.widgets.pulseaudio,
    --    delightful.widgets.datetime
    }

    -- Widget configuration
    delightful_config = {
        [delightful.widgets.cpu] = {
            command = 'gnome-system-monitor',
        },
        [delightful.widgets.memory] = {
            command = 'gnome-system-monitor',
        },
        [delightful.widgets.battery] = {
            battery = 'BAT0'
        },
        [delightful.widgets.network] = {
            excluded_devices = { 'lo', 'vboxnet0', 'wmx0' }
        }
    }

    -- Prepare the container that is used when constructing the wibox
    local delightful_container = { widgets = {}, icons = {} }
    if install_delightful then
        for _, widget in pairs(awful.util.table.reverse(install_delightful)) do
            local config = delightful_config and delightful_config[widget]
            local widgets, icons = widget:load(config)
            if widgets then
                if not icons then
                    icons = {}
                end
                table.insert(delightful_container.widgets, awful.util.table.reverse(widgets))
                table.insert(delightful_container.icons,   awful.util.table.reverse(icons))
            end
        end
    end


    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    local widgets_front = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s]
     }

      local widgets_middle = {}
      for delightful_container_index, delightful_container_data in pairs(delightful_container.widgets) do
          for widget_index, widget_data in pairs(delightful_container_data) do
              table.insert(widgets_middle, widget_data)
              if delightful_container.icons[delightful_container_index] and delightful_container.icons[delightful_container_index][widget_index] then
                  table.insert(widgets_middle, delightful_container.icons[delightful_container_index][widget_index])
              end
          end
      end

     local widgets_end = {
        mytextclock,
        s == 1 and mysystray or nil,
        memwidget,
        cpuwidget,
        fswidget,
        batwidget,
        volwidget,
        forecast,
 --       rssbox,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }

    if s == 1 then
      mywibox[s].widgets = awful.util.table.join(widgets_front, widgets_middle, widgets_end)
    else
      mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
      }
    end
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey }, "Up",    function () awful.util.spawn("amixer set Master 2+") end),
    awful.key({ modkey }, "Down",    function () awful.util.spawn("amixer set Master 2-") end),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    --awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    -- Run or raise applications with dmenu
    awful.key({ modkey }, "r",
    function () 
        local f_reader = io.popen( "dmenu_path | dmenu -b -nb '".. beautiful.bg_normal .."' -nf '".. beautiful.fg_normal .."' -sb '" .. beautiful.bg_focus .. "' -sf '" .. beautiful.fg_focus .. "'")
        local command = assert(f_reader:read('*a'))
        f_reader:close()
        if command == "" then return end 

        -- Check throught the clients if the class match the command
        local lower_command=string.lower(command)
        for k, c in pairs(client.get()) do
            local class=string.lower(c.class)
            if string.match(class, lower_command) then
                for i, v in ipairs(c:tags()) do
                    awful.tag.viewonly(v)
                    c:raise()
                    c.minimized = false
                    return
                end 
            end 
        end 
        awful.util.spawn(command)
    end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { size_hints_honor = false,
                     border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "Pidgin" },
      callback = awful.titlebar.add }, 
    { rule = { class = "Gitruno" },
      callback = awful.titlebar.add },
    { rule = { class = "Mousepad" },
      callback = awful.titlebar.add },
    { rule = { class = "Thunderbird" },
      callback = awful.titlebar.add },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- }}}

-- Startup Commands
--commands = config['startup_commands']
--for key,command in ipairs(commands) do
--  awful.util.spawn_with_shell(command)
--end
--
