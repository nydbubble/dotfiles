#! /bin/bash

# toggle touchpad status

device="ELAN1200:00 04F3:3066 Touchpad"
enabled=$(xinput --list-props "$device" | grep "Device Enabled" | awk '{print $NF}')

if [[ "$enabled" == "1" ]]; then
	xinput --disable "$device"
else
	xinput --enable "$device"
fi
