#!/bin/bash

# Function to get the total tx_bytes for ethernet and wifi devices
get_tx_bytes() {
    local total=0
    for dev in /sys/class/net/eth* /sys/class/net/en* /sys/class/net/wl*; do
        if [ -d "$dev" ] && [ -r "$dev/statistics/tx_bytes" ]; then
            val=$(cat "$dev/statistics/tx_bytes")
            total=$((total + val))
        fi
    done
    echo $total
}

t1=$(get_tx_bytes)
sleep 1
t2=$(get_tx_bytes)

diff=$((t2 - t1))

cat << EOF
HTTP/1.0 200 OK
Content-type: text/plain

${diff}
EOF

