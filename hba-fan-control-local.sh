#!/bin/bash

# --- Configuration ---
STORCLI_PATH="/root/storcli64"
PWM_CHANNEL="3"                # Which fan header (e.g., 3 for pwm3)
TEMP_MIN=45                    # Temp (°C) at which fan starts increasing
TEMP_MAX=80                    # Temp (°C) at which fan hits 100%
PWM_MIN=64                     # Minimum PWM (0-255)
PWM_MAX=255                    # Maximum PWM (0-255)
INTERVAL=5                     # Seconds between checks

# --- Initialization ---
# Ensure the driver is loaded
modprobe nct6775

# Find the correct hwmon path for the NCT chip
HWMON_DIR=$(grep -l "nct6799" /sys/class/hwmon/hwmon*/name | xargs dirname)

if [ -z "$HWMON_DIR" ]; then
    echo "Error: NCT6799 chip not found. Check if 'modprobe nct6775' succeeded."
    exit 1
fi

PWM_PATH="$HWMON_DIR/pwm${PWM_CHANNEL}"
ENABLE_PATH="$HWMON_DIR/pwm${PWM_CHANNEL}_enable"

# Ensure the specific PWM paths exist
if [ ! -f "$PWM_PATH" ]; then
    echo "Error: PWM channel ${PWM_CHANNEL} not found at $PWM_PATH"
    exit 1
fi

# Set fan to manual mode
echo 1 > "$ENABLE_PATH"

# Track state to prevent log spam
LAST_PWM=-1

echo "Controller started. Driver: nct6775. Path: $PWM_PATH"

# --- Main Loop ---
while true; do
    # Extract temperature (ROC temperature line)
    CUR_TEMP=$($STORCLI_PATH /c0 show temperature | grep "ROC temperature" | awk '{print $NF}')

    # Validate temp is a number; if not, failsafe to max speed
    if ! [[ "$CUR_TEMP" =~ ^[0-9]+$ ]]; then
        if [ "$LAST_PWM" != "$PWM_MAX" ]; then
            echo "Warning: Invalid temperature read. Failsafe to MAX."
        fi
        NEW_PWM=$PWM_MAX
    else
        if [ "$CUR_TEMP" -le "$TEMP_MIN" ]; then
            NEW_PWM=$PWM_MIN
        elif [ "$CUR_TEMP" -ge "$TEMP_MAX" ]; then
            NEW_PWM=$PWM_MAX
        else
            # Linear interpolation:
            # PWM = PWM_MIN + (CUR_TEMP - TEMP_MIN) * (PWM_MAX - PWM_MIN) / (TEMP_MAX - TEMP_MIN)
            NEW_PWM=$(awk "BEGIN { print int($PWM_MIN + ($CUR_TEMP - $TEMP_MIN) * ($PWM_MAX - $PWM_MIN) / ($TEMP_MAX - $TEMP_MIN)) }")
        fi
    fi

    # Only log if the PWM value has changed
    if [ "$NEW_PWM" != "$LAST_PWM" ]; then
        echo "HBA Temp: ${CUR_TEMP}°C -> PWM Speed: ${NEW_PWM}"
        LAST_PWM=$NEW_PWM
    fi

    # Write the new speed to hardware
    echo "$NEW_PWM" > "$PWM_PATH"

    sleep "$INTERVAL"
done
