#!/bin/bash
class=org.gnome.desktop.peripherals.touchpad #location in gconf settings where the touchpad is en/disabled
name=send-events #name of the actual setting
status=$(gsettings get "$class" "$name")
status=${status,,} # normalize to lower case; this is a modern bash extension

echo Current status is $status
if [[ $status = "'disabled'" ]]; then # needs " ' '" to work
echo it is off
new_status=enabled # ' not required
else
new_status=disabled
fi
echo "Toggling to $new_status"
gsettings set "$class" "$name" "$new_status"
#gsettings set org.gnome.desktop.peripherals-touchpad touchpad-enabled false
#gsettings set org.gnome.desktop.peripherals-touchpad disable-while-typing true
