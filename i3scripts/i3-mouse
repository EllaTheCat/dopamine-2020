#!/bin/bash
#
# i3-mouse

#
# Set how fast or slow the mouse moves, enable or disable it.
#
movement ()
{
    # This fancy method works on 20.04.02 LTS, but I believe that the
    # id can be hardcoded to a value.
    # xinput --list --short
    # PixArt Microsoft USB Optical Mouse id=11
    id=$(xinput list | grep Mouse | cut -d= -f 2 | cut -f 1)

    # The fast|slow changed for 20.04.02 LTS, the property is a
    # homogeneous scaling matrix for [x,y,w], so adjust x,y gains on
    # the leading diagonal, positions [0]/[0][0] and [4]/[1,1], as
    # floats.

    case "$1" in
        (disable)
            xinput --set-prop "${id}" "Device Enabled" "0"
            ;;
        (enable)
            xinput --set-prop "${id}" "Device Enabled" "1"
            ;;
        (fast)
            xset m 2 0
            # I have dual 16:9 monitors side by side so xgain was set
            # 32/9 faster than ygain, but I prefer 16/9 (3.2:1.8).
            xinput set-prop "${id}" "Coordinate Transformation Matrix" \
                   3.2 0.0 0.0 0.0 1.8 0.0 0 0 1
            ;;
        (slow)
            xset m 1 0
            # KISS for fine control, xgain equal to ygain..
            xinput set-prop "${id}" "Coordinate Transformation Matrix" \
                   0.4 0.0 0.0 0.0 0.4 0.0 0 0 1
            ;;
        (toggle)
            # I bind this to button3 when the mouse is inside the i3bar.
            # The test is quick-and-dirty, the RHS is matrix[0][0].
            xgain=$(xinput --list-props "${id}" | \
                        grep "Coordinate" | awk '{print $5}')
            if [ "_${xgain:0:3}" = "_3.2" ]; then
                movement slow
            else
                movement fast
            fi
    esac
}

#
# Start here.
#

"$1" "${@:2}"

#
# Done.
#
