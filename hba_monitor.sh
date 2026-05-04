#!/bin/sh

# Define the serial port
PORT="/dev/cuau0"
LAST_TEMP=""

echo "Starting HBA Temperature Monitor..."

while true; do
    CURRENT_TEMP=$(mprutil show adapter | awk '/Temperature:/ {print $2}')

    # Check if we got a valid reading
    if [ -n "$CURRENT_TEMP" ]; then
        
        # Output to Serial Port
        echo "HBA_Temp=$CURRENT_TEMP" > "$PORT"

        # Only output to stdout if the temperature has changed
        if [ "$CURRENT_TEMP" != "$LAST_TEMP" ]; then
            # Output to Console (STDOUT)
            echo "HBA_Temp=$CURRENT_TEMP"

            # Update the last known temperature
            LAST_TEMP="$CURRENT_TEMP"
        fi
    fi

    sleep 5
done
