# Timer

This timer plugin adds a desktop countdown widget with start, pause, reset, 
stopwatch mode, buttons for controlling the timer, and optional progress display.

Depends on `paplay` (libpulse/pipewire-pulse tec) for playing the optional notification sound.

## Usage

Add the `timer` desktop widget from Noctalia's desktop-widget editor.

In timer mode, the widget counts down from the set duration, can
be paused and reset, and sends a notification when the countdown reaches zero.
You can also change the timer duration with + and - buttons in the widget.

**Left-click** the buttons to increase/reduce the duration in 10-second steps.
**Right-click** the buttons to increase/reduce the duration in 1-minute steps.

In stopwatch mode, the widget counts from 0 up and can be paused and reset.

## Settings

| Setting | Type | Default | Description |
| --- | --- | --- | --- |
| `color` | `color` | `primary` | Accent color for the time and progress bar. |
| `show_progress` | `bool` | `true` | Shows or hides the progress bar. |
| `notify` | `bool` | `true` | Sends a notification when the time runs out. |
| `play sound` | `bool` | `true` | Play a notification sound when the time runs out. |

## Notes

This plugin is also a reference implementation for `[[desktop_widget]]` entries
and Noctalia's declarative `ui.*` widget tree.
