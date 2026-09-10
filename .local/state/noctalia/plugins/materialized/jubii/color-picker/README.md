# Color Picker

Adds a bar widget for color picking. Supports multiple color formats (HEX, RGB, HSL, HSV, CMYK).

Depends on hyprpicker.

## Usage

Add the `color picker` widget to a noctalia bar.
Clicking on the widget launches hyprpicker - picking a color on the screen 
will copy it to the clipboard on the chosen format in the widget's settings

## Settings

| Setting | Type | Default | Description |
| --- | --- | --- | --- |
| `Notify` | `bool` | `true` | Send a notification when a color is picked or the selection is cancelled |
| `Color format` | `select` | `HEX` | The color format copied to the clipboard. Available formats: `HEX, RGB, HSL, HSV, CMYK` |
| `Output format` | `select` | `CSS` | The output's formatting - RGB on CSS, per example, will be copied as `rgb(rrr, ggg, bbb)`. In Raw and Raw normalized settings, it will output comma-separated values. Available options: `CSS, Raw, Raw_normalized` |
