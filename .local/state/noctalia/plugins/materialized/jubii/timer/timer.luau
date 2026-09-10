--!nonstrict
-- Countdown timer desktop widget — the reference [[desktop_widget]] entry.
--
-- Desktop widgets describe their UI declaratively: build a tree with the ui.*
-- constructors and hand it to desktopWidget.render(). The host diffs the tree
-- against the previous one and updates the retained native controls, so calling
-- render() with an unchanged tree is free.
--
--   desktopWidget.render(tree)            replace the widget's UI tree
--   desktopWidget.setWantsSecondTicks(b)  tick update() on second boundaries
--   desktopWidget.getConfig(key)          settings (seeded from the manifest)
--   button onClick = "name"               calls the plugin global of that name

local duration = desktopWidget.getConfig("default_duration")
local color = desktopWidget.getConfig("color")
local showProgress = desktopWidget.getConfig("show_progress")

noctalia.setUpdateInterval(100)

local counter = duration
local running = false
local timeAnchor = 0 -- os.clock() timestamp when the countdown hits zero

local mode = "timer"

local function formatTime(seconds)
  local m = seconds // 60
  local s = seconds % 60
  if m >= 60 then -- hours
    return `{m // 60}:{string.format("%02d", m % 60)}:{string.format("%02d", s)}`
  end
  return `{m}:{string.format("%02d", s)}`
end

local function render()
  -- timer label
  local rows = {
    ui.row({align="center", justify="center"}, {
      if not running and mode == "timer" then ui.button({
        variant = "ghost",
        glyph = "minus",
        glyphSize = 18,
        color = "on_surface",
        onClick = "minus10",
        onRightClick = "minus60",
      }) else nil,

      ui.label({
        text = formatTime(counter),
        fontSize = 34,
        fontWeight = "bold",
        color = if counter == 0 and mode == "timer" then "error" else color,
      }),

      if not running and mode == "timer" then ui.button({
        variant = "ghost",
        glyph = "plus",
        glyphSize = 18,
        color = "on_surface",
        onClick = "plus10",
        onRightClick = "plus60",
      }) else nil,
    })
  }

  if showProgress and mode == "timer" then
    table.insert(rows, ui.progress({
      progress = duration > 0 and counter / duration or 0,
      fill = color,
      width = 160,
      height = 6,
      radius = 3,
    }))
  end

  table.insert(rows, ui.row({ gap = 8 }, {
    ui.button({
      text = running and "Pause" or "Start",
      variant = "primary",
      onClick = "toggleClock",
    }),
    ui.button({
      glyph = mode == "timer" and "stopwatch" or "hourglass-empty",
      variant = "ghost",
      onClick = "switchMode",
    }),
    ui.button({
      text = "Reset",
      variant = "outline",
      onClick = "resetCounter",
    }),
  }))

  desktopWidget.render(ui.column({ gap = 10, align = "center" }, rows))
end

function update()

  desktopWidget.setWantsSecondTicks(true)
  if running then
    if mode == "timer" then
      counter = math.max(0, timeAnchor - os.clock())
      if counter == 0 then
        running = false
        -- System notification
        if noctalia.getConfig("notify") then
          noctalia.notify("Timer", `Time's up — {formatTime(duration)} elapsed`)
        end
        -- Notification sound
        if noctalia.getConfig("play_sound") then
          local dir = noctalia.pluginDir()
          if dir then
            local file = dir.."/notify.wav"
            noctalia.runAsync(`paplay --property=media.role=event {file}`)
          end
        end
      end
    else
      counter = -(timeAnchor - os.clock())
    end
  end
  render()
end

function toggleClock()
  if mode == "timer" and counter == 0 then
    counter = duration
  end
  running = not running
  if running and mode == "timer" then
    timeAnchor = os.clock() + counter
  else
    timeAnchor = os.clock() - counter
  end

  render()
end

function resetCounter()
  running = false
  counter = if mode == "timer" then duration else 0
  render()
end

function changeCounter(delta)
  duration = math.max(0, duration + delta)
  counter = math.max(0, counter + delta)
end

function minus10()
  changeCounter(-10)
end

function minus60()
  changeCounter(-60)
end

function plus10()
  changeCounter(10)
end

function plus60()
  changeCounter(60)
end

function switchMode()
  if mode == "timer" then
    mode = "stopwatch"
    counter = 0
  else
    mode = "timer"
    counter = duration
  end
  resetCounter()
end
