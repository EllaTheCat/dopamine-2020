#!/bin/bash
#
# i3-status (a wrapper around i3status)

i3status "$@" | while :
do
    read -r line
    compositor=$(pgrep -c -f '(compton|picom)')
    wcam=$(lsof /dev/video0 | awk '{print $1}' | grep -v COMMAND | uniq | sed 's/skypeforl*/skype/g')
    wcam=${wcam:-'idle'}
    amic=$(pactl list sources | grep -A 7 alsa_input.pci-0000_00_1b.0.analog-stereo | grep -c 'Mute: no')
    wmic=$(pactl list sources | grep -A 7 alsa_input.usb-Alcor_Micro__Corp._TeckNet-02.mono-fallback | grep -c 'Mute: no')
    eval "$(xdotool getmouselocation --shell)"
    ccmt='cc offline'
    if [ "$(ping -c 1 -W 1 192.168.1.114 | grep -c "1 received")" -ne 0 ]; then
        ccmt="cc $(ssh cheesecake /opt/vc/bin/vcgencmd measure_temp)"
    fi
    # Use the (truncated) UUID to obtain the device.
    titan=$(df -h | grep f9fd1893)
    mimas=$(df -h | grep 94bd806f)
    titan=$(sudo /usr/sbin/hddtemp "${titan:0:8}" | awk '{print $3}')
    mimas=$(sudo /usr/sbin/hddtemp "${mimas:0:8}" | awk '{print $3}')
    pactl list sink-inputs | grep 'Sink Input'| tail -1 | \
        sed 's/Sink Input \#//g' > /dev/shm/"$USER"/i3/app-pulse-id
    api=$(cat /dev/shm/"$USER"/i3/app-pulse-id)
    echo "| cursor $X $Y | app-pulse-id ${api} | compositor ${compositor} | ${ccmt} | webcam ${wcam} | mic ${wmic} ${amic} | ${mimas} ${titan} | ${line}" || exit 1
done

#
# Done.
#
