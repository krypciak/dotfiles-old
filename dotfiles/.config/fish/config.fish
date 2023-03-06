if status is-interactive
    if test -z "$AT_LOGIN_SOURCED" 
        exec bash -c "source ~/.config/at_login.sh; exec fish"
    end

    set fish_greeting
    alias ls='lsd'
    alias l='lsd -l'
    alias la='lsd -a'
    alias lla='lsd -la'
    alias lt='lsd --tree'
    alias tree='lsd --tree'

    alias reboot='loginctl reboot'
    alias poweroff='loginctl poweroff'
    alias suspend='awesome-client "suspend()"'
    alias hibernate='awesome-client "hibernate()"'
    
    alias f='fdisk -l'

    alias motherboard='cat /sys/devices/virtual/dmi/id/board_{vendor,name,version}'
    alias topcmds='history | awk \'{print $1}\' | sort | uniq -c | sort -nr | head -20'

    source /usr/share/autojump/autojump.fish

    atuin init fish | source
    
    alias cat=bat
    alias diff=difft
    alias du='echo Use dust.'
    alias find='echo Use fd.'
    alias ti='hyperfine'
    alias df='echo Use lfs.'
    alias ps='echo Use procs.'
    
    alias dust='dust --reverse'

    function lsp
        ls -d "$PWD/$argv" | head -c -1
    end

    if test -n "$WAYLAND_DISPLAY"
        alias pwdc='pwd | head -c -1 | wl-copy'
        alias pwdv='cd "$(wl-paste)"'

        function lspc 
            lsp "$argv" | wl-copy
        end
    else
        alias pwdc='pwd | xsel -ib'
        alias pwdv='cd "$(xsel -ob)"'
        
        function lspc 
            lsp "$argv" | xsel -ib
        end
    end

    alias iforgothowtosyncfork='printf "# Sync your fork\ngit fetch upstream\ngit checkout yamainbrammch\ngit merge upstream\n"'
    alias gitignorenowork='printf "#Remember to commit everything you\'ve changed before you do this!\ngit rm -rf --cached .\ngit add .\n"'
    alias iuploadedmycreditcardnumbertogitwhatnow='printf "git filter-repo --invert-paths --path <path to the file or directory>"\n'
    alias mountqcow2='printf "# Mount\ndoas modprobe nbd max_part=8\ndoas qemu-nbd --connect=/dev/nbd0 IMAGE.qcow2\ndoas mount /dev/nbd0 MNT\n\n# Umount\ndoas umount MNT\ndoas qemu-ndp --disconnect /dev/nbd0"'
end
