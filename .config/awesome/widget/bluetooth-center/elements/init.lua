local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes.dracula.colors')
local watch = require('awful.widget.watch')

local elements = {}

elements.create = function(name, macAddress, pairStatus, connectStatus)
  local box = {}

  local pairIcon = wibox.widget {
    layout = wibox.layout.align.vertical,
    expand = 'none',
    nil,
    {
      id = 'icon',
      image = icons.chain,
      resize = true,
      widget = wibox.widget.imagebox
    },
    nil
  }

  local pair = wibox.widget {
    {
      {
        {
          pairIcon,
          layout = wibox.layout.fixed.horizontal,
        },
        margins = dpi(9),
        widget = wibox.container.margin
      },
      forced_height = dpi(30),
      forced_width = dpi(30),
      widget = clickable_container
    },
    shape = gears.shape.circle,
    bg = colors.background,
    widget = wibox.container.background
  }

  pair:connect_signal(
    "mouse::enter",
    function()
      pair.bg = colors.comment
    end
  )

  pair:connect_signal(
    "mouse::leave",
    function()
      pair.bg = colors.background
    end
  )

  local unpairIcon = wibox.widget {
    layout = wibox.layout.align.vertical,
    expand = 'none',
    nil,
    {
      id = 'icon',
      image = icons.chain_broken,
      resize = true,
      widget = wibox.widget.imagebox
    },
    nil
  }

  local unpair = wibox.widget {
    {
      {
        {
          pairIcon,
          layout = wibox.layout.fixed.horizontal,
        },
        margins = dpi(9),
        widget = wibox.container.margin
      },
      forced_height = dpi(30),
      forced_width = dpi(30),
      widget = clickable_container
    },
    shape = gears.shape.circle,
    bg = colors.background,
    widget = wibox.container.background
  }

  unpair:connect_signal(
    "mouse::enter",
    function()
      unpair.bg = colors.comment
    end
  )

  unpair:connect_signal(
    "mouse::leave",
    function()
      unpair.bg = colors.background
    end
  )

  local connectIcon = wibox.widget {
    layout = wibox.layout.align.vertical,
    expand = 'none',
    nil,
    {
      id = 'icon',
      image = icons.bluetooth_on,
      resize = true,
      widget = wibox.widget.imagebox
    },
    nil
  }

  local connect = wibox.widget {
    {
      {
        {
          connectIcon,
          layout = wibox.layout.fixed.horizontal,
        },
        margins = dpi(9),
        widget = wibox.container.margin
      },
      forced_height = dpi(30),
      forced_width = dpi(30),
      widget = clickable_container
    },
    shape = gears.shape.circle,
    bg = colors.background,
    widget = wibox.container.background
  }

  connect:connect_signal(
    "mouse::enter",
    function()
      connect.bg = colors.comment
    end
  )

  connect:connect_signal(
    "mouse::leave",
    function()
      connect.bg = colors.background
    end
  )

  local disonnectIcon = wibox.widget {
    layout = wibox.layout.align.vertical,
    expand = 'none',
    nil,
    {
      id = 'icon',
      image = icons.bluetooth_off,
      resize = true,
      widget = wibox.widget.imagebox
    },
    nil
  }
  
  local disconnect = wibox.widget {
    {
      {
        {
          disconnectIcon,
          layout = wibox.layout.fixed.horizontal,
        },
        margins = dpi(9),
        widget = wibox.container.margin
      },
      forced_height = dpi(30),
      forced_width = dpi(30),
      widget = clickable_container
    },
    shape = gears.shape.circle,
    bg = colors.background,
    widget = wibox.container.background
  }

  disconnect:connect_signal(
    "mouse::enter",
    function()
      disconnect.bg = colors.comment
    end
  )

  disconnect:connect_signal(
    "mouse::leave",
    function()
      disconnect.bg = colors.background
    end
  )

  pair:buttons(
    gears.table.join(
      awful.button(
        {},
        1,
        nil,
        function()
          awful.spawn.with_shell("bluetoothctl pair "..macAddress)
        end
      )
    )
  )

  unpair:buttons(
    gears.table.join(
      awful.button(
        {},
        1,
        nil,
        function()
          awful.spawn.with_shell("bluetoothctl remove "..macAddress)
        end
      )
    )
  )

  connect:buttons(
    gears.table.join(
      awful.button(
        {},
        1,
        nil,
        function()
          awful.spawn.with_shell("bluetoothctl connect "..macAddress)
        end
      )
    )
  )

  disconnect:buttons(
    gears.table.join(
      awful.button(
        {},
        1,
        nil,
        function()
          awful.spawn.with_shell("bluetoothctl disconnect "..macAddress)
        end
      )
    )
  )

  local bluetoothIcon = wibox.widget {
    {
      {
        {
          image = icons.bluetooth_on,
          widget = wibox.widget.imagebox,
        },
        margins = dpi(5),
        widget = wibox.container.margin
      },
      shape = gears.shape.rect,
      bg = colors.purple,
      widget = wibox.container.background
    },
    forced_width = 40,
    forced_height = 40,
    widget = clickable_container
  }
  
  local content = wibox.widget {
    {
      {
        {
          text = name,
          font = 'Inter Bold 10',
          widget = wibox.widget.textbox,
        },
        {
          text = macAddress,
          font = 'Inter 8',
          widget = wibox.widget.textbox,
        },
        layout = wibox.layout.align.vertical,
      },
      margins = dpi(10),
      widget = wibox.container.margin
    },
    shape = gears.shape.rect,
    bg = colors.selection,
    widget = wibox.container.background
  }

  local buttons = {}

  if pairStatus and connectStatus then
    buttons = {
      layout = wibox.layout.align.horizontal,
      spacing = dpi(15),
      unpair,
      disconnect,
    }
  elseif pairStatus and connectStatus == false then
    buttons = {
      layout = wibox.layout.align.horizontal,
      spacing = dpi(15),
      unpair,
      connect,
    }
  else
    buttons = {
      layout = wibox.layout.align.horizontal,
      pair,
    }
  end

  
  box = wibox.widget {
    {
      bluetoothIcon,
      content,
      buttons,
      layout = wibox.layout.align.horizontal,
    },
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, dpi(4))
    end,
    fg = colors.white,
    border_width = dpi(1),
    border_color = colors.background,
    widget = wibox.container.background
  }

  return box
end

return elements