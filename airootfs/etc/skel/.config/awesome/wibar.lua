return function(s)
    local mywibar = wibox {
        screen = s,
        y = 4, x = 4,
        ontop = true,
        visible = true,
        bg = beautiful.bg_focus,
        width = s.geometry.width-8,
        height = beautiful.wibar_height,
    }
    mywibar:struts{
        top = beautiful.wibar_height+10, right = 5,
        bottom = beautiful.dock_width+10,
        left = 5
    }

    local mycpuwidget = optional"wibarwidgets/cpuwidget"
    local mymemwidget = optional"wibarwidgets/memwidget"
    local mybrightnesswidget = optional"wibarwidgets/brightnesswidget"
    local myvolwidget = optional"wibarwidgets/volwidget"
    local mybatwidget = optional"wibarwidgets/batwidget"
    local mytimewidget = optional"wibarwidgets/timewidget"

    mywibar:setup {
        {
            require"panel"(s),
            require"taglist"(s),
            {
                {
                    {
                        {
                            mymemwidget,
                            mycpuwidget,
                            mybrightnesswidget,
                            myvolwidget,
                            mybatwidget,
                            widget = wibox.container.margin,
                            top = 8,
                            layout = wibox.layout.flex.horizontal,
                            spacing = 10
                        },
                        bottom = 2,
                        right = 10,
                        widget = wibox.container.margin,
                    },
                    mytimewidget,
                    layout = wibox.layout.fixed.horizontal
                },
                right = 10,
                widget = wibox.container.margin
            },
            layout = wibox.layout.align.horizontal,
            expand = "none"
        },
        widget = wibox.container.background,
        shape = rrect(),
    }

    return mywibar
end

-- vim:set et sw=4 ts=4:
