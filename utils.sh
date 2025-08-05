#!/bin/bash

# Color
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Typing effect
typing_effect() {
    text="$1"
    delay=0.02
    for ((i = 0; i < ${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep $delay
    done
    echo ""
}

# Glitch effect
glitch_effect() {
    for i in {1..2}; do
        echo -ne "${RED}▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓▒▓\r${NC}"
        sleep 0.05
        echo -ne "${GREEN}▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\r${NC}"
        sleep 0.05
    done
}

# Box print
print_box() {
    local title=$1
    local color=$2
    local len=${#title}
    local border=$(printf '─%.0s' $(seq 1 $len))

    glitch_effect
    echo -e "${color}┌─${border}─┐${NC}"
    echo -ne "${color}│ ${NC}"
    typing_effect "$title"
    echo -e "${color}└─${border}─┘${NC}"
}

# Loading
loading() {
    echo -ne "${YELLOW}[*] Processing"
    for i in {1..3}; do
        echo -ne "."
        sleep 0.4
    done
    echo ""
    for i in {1..3}; do
        echo -ne "${YELLOW}>>>${NC} "
        sleep 0.2
    done
    echo ""
}

# Progress Bar
progress_bar() {
    local duration=$1
    local steps=20
    local step_time=$(echo "$duration / $steps" | bc -l)
    echo -ne "${YELLOW}["
    for ((i = 0; i < steps; i++)); do
        echo -ne "#"
        sleep $step_time
    done
    echo -e "]${NC}"
}
