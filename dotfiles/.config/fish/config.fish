if status is-interactive
    if test -z "$AT_LOGIN_SOURCED" 
        exec bash -c "source ~/.config/at_login.sh; exec fish"
    end

    set fish_greeting

    source /usr/share/autojump/autojump.fish

    atuin init fish | source
    
    function lsp
        ls -d "$PWD/$argv" | head -c -1
    end

    if test -n "$WAYLAND_DISPLAY"
        alias pwdc='pwd | head -c -1 | wl-copy'
        alias pwdv='cd "$(wl-paste)"'

        function lspc 
            lsp "$argv" | wl-copy
        end
        
        function lsc
            ls "$argv" | head -c -1 | wl-copy
        end

    else
        alias pwdc='pwd | xsel -ib'
        alias pwdv='cd "$(xsel -ob)"'
        
        function lspc 
            lsp "$argv" | xsel -ib
        end

        function lsc
            ls "$argv" | head -c -1 | xsel -ib
        end
    end
    

    function last_history_item
        echo $history[1]
    end
    abbr -a !! --position anywhere --function last_history_item

    source ~/.config/aliases.sh

    alias topcmds='history | awk "{print \$1}" | sort | uniq -c | sort -nr | head -20'
end
