def --env get-env [name] { $env | get $name }
def --env set-env [name, value] { load-env { $name: $value } }
def --env unset-env [name] { hide-env $name }

$env.config.show_banner = false
$env.config.use_kitty_protocol = true
$env.config.buffer_editor = "nvim"
$env.config.completions.algorithm = "fuzzy"

$env.config.highlight_resolved_externals = true

$env.config.color_config.shape_external = "rb"
$env.config.color_config.shape_external_resolved = "gb"
$env.config.color_config.shape_externalarg = "default"
$env.config.color_config.shape_signature = "default"

alias garu = paru
alias ls = ls -a
alias py = python
alias untar = tar -zxvf
alias reload = exec nu
alias c = clear
alias clip = wl-copy
alias paste = wl-paste

def greeter []: nothing -> string {
    let trans_blue = {
        fg: "blue",
        attr: "bi"
    }
    let trans_pink = {
        fg: "magenta",
        attr: "bi"
    }
    let trans_white = {
        fg: "reset"
        attr: "bi"
    }
    $"\n  (ansi --escape $trans_blue)H(ansi --escape $trans_pink)e(ansi --escape $trans_white)l(ansi --escape $trans_pink)l(ansi --escape $trans_blue)o(ansi --escape $trans_white)! (ansi cyan):3(ansi rst)\n"}

def ztls [] {
    sudo zerotier-cli listnetworks | str replace -m -r -a '200 listnetworks ' "" | lines | skip 1 | split column ' ' 'id' 'name' 'mac' 'status' 'type' 'dev' 'ip'
}

def df [] {
    ^df -h | lines | skip 1 | split column -r '\s+' filesystem 1K-blocks Used Available Use% "Mounted On"
}

def "nu-complete-zoxide-path" [context: string] {
    let parts = $context | split row " " | skip 1
    {
    options: {
        sort: false,
        completion_algorithm: fuzzy,
        case_sensitive: false,
    },
    completions: (^zoxide query --list --exclude $env.PWD -- ...$parts
    | lines
    | each {
        if ($in | str starts-with $env.PWD) {
            path relative-to $env.PWD
        } else $in | str replace ($env.HOME) '~'
    }),
    }
}

print (greeter)

export-env { load-env {
    VISUAL: "nvim"
    EDITOR: "nvim"
    # SUDO_PROMPT: (^starship prompt --profile=sudo_prompt --terminal-width (term size).columns)
    STARSHIP_LOG: "error"
    NU_EXPERIMENTAL_OPTIONS: "native-clip"
}}


source zoxide-init-nu.nu
source starship-init-nu.nu
# source a.nu

def --env --wrapped z [...rest: string@"nu-complete-zoxide-path"] {
    __zoxide_z ...$rest
}

let fish_completer = {|spans|
    fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
    | update value {|row|
      let value = $row.value
      let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
      if ($need_quote and ($value | path exists)) {
        let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
        $'"($expanded_path | str replace --all "\"" "\\\"")"'
      } else {$value}
    }
}

$env.config.completions.external.enable = true
$env.config.completions.external.completer = $fish_completer

$env.PATH = [...$env.PATH,"/home/julia/.spicetify"]
