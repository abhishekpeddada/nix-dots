#!/bin/sh

# Get the primary network interface
IFACE=$(ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//")

# Initial stats
RX_PREV=$(grep "$IFACE:" /proc/net/dev | awk '{print $2}')
TX_PREV=$(grep "$IFACE:" /proc/net/dev | awk '{print $10}')

# Function to format bytes
format_speed() {
    if [ "$1" -lt 1024 ]; then
        echo "${1} B/s"
    elif [ "$1" -lt 1048576 ]; then
        echo "$(echo "scale=1; $1 / 1024" | bc) KB/s"
    else
        echo "$(echo "scale=1; $1 / 1048576" | bc) MB/s"
    fi
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