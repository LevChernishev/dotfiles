#!/usr/bin/env bash

BIN_DIR="$CONFIG_DIR/bin"
read -r CPU RAM < <("$BIN_DIR/get_sysinfo" 2>/dev/null)

[ -z "$CPU" ] && CPU="0"
[ -z "$RAM" ] && RAM="0.0G"

sketchybar --set cpu label="${CPU}%" \
           --set ram label="${RAM}"
