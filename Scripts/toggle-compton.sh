#!/bin/sh
if [ `pidof compton` ]; then
    # Comment the line below to disable notifications
    notify-send -t 400 'Disabled compton' --icon=video-display
    # Kill compton
    killall compton
else
    # Comment the line below to disable notifications
    notify-send -t 400 'Enabled compton' --icon=video-display
    # Start compton as a daemon
    compton --config ~/.config/compton/compton.conf -b
fi
exit
