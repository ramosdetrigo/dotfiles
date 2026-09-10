barWidget.setGlyph("color-picker")

local format_strings = {
  css = {
    rgb = "rgb(%d, %d, %d)",
    hsl = "hsl(%d, %d%%, %d%%)",
    hsv = "hsv(%d, %d%%, %d%%)",
    cmyk = "cmyk(%d%%, %d%%, %d%%, %d%%)",
  },
  raw = {
    rgb = "%d, %d, %d",
    hsl = "%d, %d, %d",
    hsv = "%d, %d, %d",
    cmyk = "%d, %d, %d, %d",
  },
  normal = {
    rgb = "%.3f, %.3f, %.3f",
    hsl = "%.3f, %.3f, %.3f",
    hsv = "%.3f, %.3f, %.3f",
    cmyk = "%.3f, %.3f, %.3f, %.3f",
  }
}

local notify: boolean = barWidget.getConfig("notify")
local color_format: string = barWidget.getConfig("color_format")
local output_format: string = barWidget.getConfig("output_format")

local format_opts: string = `--format={color_format}`
-- we don't handle hex to allow it to show correctly in the preview.
-- also, CMYK specifically has 4 outputs instead of 3.
if color_format == "cmyk" then
  format_opts ..= ' --output-format="{0} {1} {2} {3}"'
elseif color_format == "rgb" then
  format_opts ..= ' --output-format="{0} {1} {2}"'
elseif color_format ~= "hex" then
  -- don't use % in output-format - it messes up the hyprpicker output
  format_opts ..= ' --output-format="{0}° {1} {2}"'
end

-- we take the numbers and format them here instead of letting
-- hyprpicker handle it. allows for better control.
local function handleStream(line: string)
  if line ~= "exit" then
    local components: {number} = {}

    local output: string
    if color_format ~= "hex" then
      -- rgb is 0 - 255, the rest are percentages 0 - 100
      local d = if color_format == "rgb" then 255 else 100
      local i = 1
      for num_str in line:gmatch("%d+") do
        local num = tonumber(num_str) :: number

        -- normalizes the numbers
        if output_format == "normal" then
          -- hsl and hsv's first component is in 0 - 360 range
          if color_format == "hsl" or color_format == "hsv" and i == 1 then
            num /= 360
          else
            num /= d
          end
        end

        table.insert(components, num)
        i += 1
      end

      local fmt = format_strings[output_format][color_format]
      output = fmt:format(unpack(components))
    else
      output = line
    end

    noctalia.copyToClipboard(output, "text/plain;charset=utf-8")
    if notify then
      noctalia.notify("Color Picker", `Color copied to clipboard.\n{output}`)
    end
  elseif notify then
    noctalia.notify("Color Picker", "Color picking cancelled.")
  end
end

function onClick()
  noctalia.runStream(
    `sh -c 'hyprpicker -b {format_opts} || printf "exit\n"'`,
    handleStream
  )
end
