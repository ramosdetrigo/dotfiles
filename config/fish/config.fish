# Fish colors
set -g fish_color_command --bold green
set -g fish_color_error red
set -g fish_color_quote yellow
set -g fish_color_param white
set -g fish_pager_color_selected_completion blue

source ~/.config/fish/conf.d/hydro.fish

# Some config
set -g fish_greeting (set_color brblue --bold --italic)'
  H'(set_color brmagenta --bold --italic)'e'(set_color normal)(set_color --bold --italic)'l'(set_color brmagenta --bold --italic)'l'(set_color brblue --bold --italic)'o'(set_color normal)(set_color --bold --italic)'!'(set_color cyan)' :)
'

# Git config
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_showupstream informative
set -g __fish_git_prompt_showdirtystate yes
set -g __fish_git_prompt_char_stateseparator ' '
set -g __fish_git_prompt_char_cleanstate '✔'
set -g __fish_git_prompt_char_dirtystate '✚'
set -g __fish_git_prompt_char_invalidstate '✖'
set -g __fish_git_prompt_char_stagedstate '●'
set -g __fish_git_prompt_char_stashstate '⚑'
set -g __fish_git_prompt_char_untrackedfiles '?'
set -g __fish_git_prompt_char_upstream_ahead ''
set -g __fish_git_prompt_char_upstream_behind ''
set -g __fish_git_prompt_char_upstream_diverged 'ﱟ'
set -g __fish_git_prompt_char_upstream_equal ''
set -g __fish_git_prompt_char_upstream_prefix ''''

# User abbreviations
# abbr -a -g h 'history'																								# Show history
# abbr -a -g please 'sudo'																						# Polite way to sudo
# abbr -a -g fucking 'sudo'																						# Rude way to sudo
# abbr -a -g fish_priv 'fish --private'																				# Fish incognito mode
abbr -a -g untar 'tar -zxvf'																					# Untar
# abbr -a -g edit 'micro'
abbr -a -g ls 'ls -A'
abbr -a -g exa 'exa --icons -TlL1'
abbr -a -g garu 'paru'
# abbr -a -g wine-ge ~/.scripts/utils/lutris-ge/bin/wine
abbr -a -g py python

fish_add_path $HOME/.spicetify/
fish_add_path $HOME/.cargo/bin/
fish_add_path $HOME/.local/bin/
fish_add_path /opt/android-sdk/build-tools/33.0.0/
set --export ANDROID_HOME /opt/android-sdk/

#if status is-interactive
#end


set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $HOME/.ghcup/bin $PATH # ghcup-env
