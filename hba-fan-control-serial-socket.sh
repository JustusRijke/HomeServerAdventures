#!/bin/bash

# --- Configuration ---
VM_ID="101"
SOCKET="/var/run/qemu-server/${VM_ID}.serial0" # Direct access to serial0
PWM_CHANNEL="3"
TEMP_MIN=45
TEMP_MAX=80
PWM_MIN=64
PWM_MAX=255

# --- Initialization ---
modprobe nct6775
HWMON_DIR=$(grep -l "nct6799" /sys/class/hwmon/hwmon*/name | xargs dirname)

if [ -z "$HWMON_DIR" ]; then
    echo "Error: NCT6799 chip not found."
    exit 1
fi

PWM_PATH="$HWMON_DIR/pwm${PWM_CHANNEL}"
ENABLE_PATH="$HWMON_DIR/pwm${PWM_CHANNEL}_enable"
echo 1 > "$ENABLE_PATH"

# Track state
LAST_PWM=-1

echo "Controller started. Monitoring VM $VM_ID via serial socket..."

# --- Main Loop ---
# socat connects to the socket and outputs the stream[cite: 1]
socat -u UNIX-CONNECT:"$SOCKET" - | while read -r line; do
    
    # Extract temperature (simple and clean)[cite: 1]
    CUR_TEMP=$(echo "$line" | grep -oP 'HBA_Temp=\K[0-9]+')

    if [ -z "$CUR_TEMP" ]; then
        continue
    fi

    # PWM Calculation
    if [ "$CUR_TEMP" -le "$TEMP_MIN" ]; then
        NEW_PWM=$PWM_MIN
    elif [ "$CUR_TEMP" -ge "$TEMP_MAX" ]; then
        NEW_PWM=$PWM_MAX
    else
        NEW_PWM=$(awk "BEGIN { print int($PWM_MIN + ($CUR_TEMP - $TEMP_MIN) * ($PWM_MAX - $PWM_MIN) / ($TEMP_MAX - $TEMP_MIN)) }")
    fi

    # Write to hardware only if speed changes
    if [ "$NEW_PWM" != "$LAST_PWM" ]; then
        echo "HBA Temp: ${CUR_TEMP}°C -> PWM Speed: ${NEW_PWM}"
        echo "$NEW_PWM" > "$PWM_PATH"
        LAST_PWM=$NEW_PWM
    fi
done
