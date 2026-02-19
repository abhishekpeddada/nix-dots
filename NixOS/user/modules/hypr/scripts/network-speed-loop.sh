#!/bin/sh

# Get the primary network interface
IFACE=$(ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//")

# Initial stats
RX_PREV=$(grep "$IFACE:" /proc/net/dev | awk '{print $2}')
TX_PREV=$(grep "$IFACE:" /proc/net/dev | awk '{print $10}')

# Function to format bytes using awk for better formatting and GB/s support
format_speed() {
    awk -v speed="$1" '
    BEGIN {
        if (speed < 1024) {
            printf "%.0f B/s", speed;
        } else if (speed < 1048576) {
            printf "%.1f KB/s", speed / 1024;
        } else if (speed < 1073741824) {
            printf "%.1f MB/s", speed / 1048576;
        } else {
            printf "%.1f GB/s", speed / 1073741824;
        }
    }'
}


while true; do
    sleep 1
    # Get current stats
    RX_CURR=$(grep "$IFACE:" /proc/net/dev | awk '{print $2}')
    TX_CURR=$(grep "$IFACE:" /proc/net/dev | awk '{print $10}')

    # Calculate speed
    RX_SPEED=$((RX_CURR - RX_PREV))
    TX_SPEED=$((TX_CURR - TX_PREV))

    # Update previous stats
    RX_PREV=$RX_CURR
    TX_PREV=$TX_CURR

    # Output for Waybar
    echo " $(format_speed $RX_SPEED)  $(format_speed $TX_SPEED)"
done
