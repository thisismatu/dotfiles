#!/bin/bash
#
#    This is slightly altered from the original which is found here:
#    http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
#
#    Each line is the color code of one foreground color, out of 8
#    (normal and bright), followed by a test use of that color
#    on all background colors (normal + bright).
#

text="xYz"; # Some test text

echo -e "\n              40m  41m  42m  43m  44m  45m  46m  47m  100m 101m 102m 103m 104m 105m 106m 107m";

# Normal foregrounds
for FG in 30 31 32 33 34 35 36 37; do
    echo -en "  ${FG}m \033[${FG}m  ${text}  ";
    for BG in 40 41 42 43 44 45 46 47 100 101 102 103 104 105 106 107; do
        echo -en "\033[${FG}m\033[${BG}m ${text} \033[0m";
    done
    echo;
done

# Bright foregrounds
for FG in 90 91 92 93 94 95 96 97; do
    echo -en "  ${FG}m \033[${FG}m  ${text}  ";
    for BG in 40 41 42 43 44 45 46 47 100 101 102 103 104 105 106 107; do
        echo -en "\033[${FG}m\033[${BG}m ${text} \033[0m";
    done
    echo;
done

echo;
