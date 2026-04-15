#!/bin/bash
HEX_COLOR=$(cat /tmp/brave_hex)


echo "{\"BrowserThemeColor\": \"$HEX_COLOR\", \"BrowserColorScheme\": \"light\"}" | tee "/etc/brave/policies/managed/color.json" >/dev/null
brave --refresh-platform-policy --no-startup-window &>/dev/null