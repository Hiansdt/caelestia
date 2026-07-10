if status is-interactive
    # Starship custom prompt
    command -v starship &> /dev/null && starship init fish | source

    # Direnv + Zoxide
    command -v direnv &> /dev/null && direnv hook fish | source
    command -v zoxide &> /dev/null && zoxide init fish --cmd cd | source

    # Better ls
    command -v eza &> /dev/null && alias ls='eza --icons --group-directories-first -1'

    # Abbrs
    abbr lg 'lazygit'
    abbr gd 'git diff'
    abbr ga 'git add .'
    abbr gc 'git commit -am'
    abbr gl 'git log'
    abbr gs 'git status'
    abbr gst 'git stash'
    abbr gsp 'git stash pop'
    abbr gp 'git push'
    abbr gpl 'git pull'
    abbr gsw 'git switch'
    abbr gsm 'git switch main'
    abbr gb 'git branch'
    abbr gbd 'git branch -d'
    abbr gco 'git checkout'
    abbr gsh 'git show'
    abbr s 'sesh picker'
    abbr prd 'gh pr create --base dev --assignee hiansdt-c3labs --fill'
    abbr prm 'gh pr create --base main --assignee hiansdt-c3labs --fill'
    abbr prmg 'gh pr merge'

    abbr l 'ls'
    abbr ll 'ls -l'
    abbr la 'ls -a'
    abbr lla 'ls -la'

    set -gx CAVEMAN_DEFAULT_MODE ultra

    # Custom colours
    cat ~/.local/state/caelestia/sequences.txt 2> /dev/null

    # For jumping between prompts in foot terminal
    function mark_prompt_start --on-event fish_prompt
        echo -en "\e]133;A\e\\"
    end

    function nzo
        if test (count $argv) -eq 0
            set file (
            fd --type f -I -H -E .git -E .git-crypt -E .cache -E .backup |
            fzf --height=70% --preview='bat -n --color=always --line-range :500 {}'
            )

            if test -n "$file"
                cd (dirname "$file")
                nvim (basename "$file")
            end
        else
            set matches

            for zdir in (zoxide query -l)
                set found (
                fd --type f -I -H \
                    -E .git \
                    -E .git-crypt \
                    -E .cache \
                    -E .backup \
                    -E .vscode \
                    $argv[1] \
                    "$zdir" 2>/dev/null
                )

                if test -n "$found"
                    set matches $matches $found
                end
            end

            if test (count $matches) -eq 0
                echo "No matches found." >&2
                return 1
            end

            if test (count $matches) -eq 1
                set file $matches[1]
            else
                set file (
                printf '%s\n' $matches |
                fzf --query="$argv[1]" \
                    --height=70% \
                    --preview='bat -n --color=always --line-range :500 {}' \
                    --no-sort
                )
            end

            if test -n "$file"
                cd (dirname "$file")
                nvim (basename "$file")
            end
        end
    end

    # Custom fish config
    set -q XDG_CONFIG_HOME && set -l cConf $XDG_CONFIG_HOME/caelestia || set -l cConf $HOME/.config/caelestia
    source $cConf/user-config.fish 2> /dev/null
end
