#!/usr/bin/env bash
set -euo pipefail

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}"
css_chrome="$cache_dir/noctalia/zen-browser/zen-userChrome.css"
css_content="$cache_dir/noctalia/zen-browser/zen-userContent.css"
line_chrome="@import \"$css_chrome\";"
line_content="@import \"$css_content\";"

find "${XDG_CONFIG_HOME:-$HOME/.config}/zen" "$HOME/.zen" -mindepth 2 -maxdepth 2 -type d -name chrome -print0 2>/dev/null |
    while IFS= read -r -d '' dir; do
        user_chrome="$dir/userChrome.css"
        user_content="$dir/userContent.css"
        mkdir -p "$dir"
        touch "$user_chrome" "$user_content"
        sed -i '/zen-browser\/zen-userChrome\.css/d' "$user_chrome"
        sed -i '/zen-browser\/zen-userContent\.css/d' "$user_content"
        if ! grep -Fq "$line_chrome" "$user_chrome"; then
            [ -s "$user_chrome" ] && [ -n "$(tail -c1 "$user_chrome")" ] && echo >>"$user_chrome"
            printf '%s\n' "$line_chrome" >>"$user_chrome"
        fi
        if ! grep -Fq "$line_content" "$user_content"; then
            [ -s "$user_content" ] && [ -n "$(tail -c1 "$user_content")" ] && echo >>"$user_content"
            printf '%s\n' "$line_content" >>"$user_content"
        fi
    done
