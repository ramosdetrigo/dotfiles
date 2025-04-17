function fish_prompt --description Hydro
    echo -e -s (date +%H:%M)' ' \
    (set_color --bold blue) $USER' ' (set_color normal) \
    "$_hydro_color_start$hydro_symbol_start" \
    (set_color magenta) (pwd | sed "s|^$HOME|~|") " " \
    (set_color --bold normal) "$$_hydro_git" \
    "$_hydro_color_duration$_hydro_cmd_duration" \
    "$_hydro_color_status$_hydro_status " \
    (set_color yellow) "\n❯ " (set_color normal)
end
