#!/usr/bin/env bash
screen_shot_result=$(flameshot gui 2>&1 >/dev/null | grep -o 'aborted')

if [ "$screen_shot_result" = "aborted" ]; then
echo 'error screenshot stopped'
else
ls_result=$(ls -t ~/Pictures/Screenshots/ | head -1)
cat ~/Pictures/Screenshots/$ls_result | wl-copy
fi

exit 0

