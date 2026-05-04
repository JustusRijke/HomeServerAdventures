#!/bin/sh

# PROVIDE: hba_monitor
# REQUIRE: LOGIN
# KEYWORD: shutdown

. /etc/rc.subr

name="hba_monitor"
rcvar="hba_monitor_enable"

# The command to execute
command="/usr/sbin/daemon"

# Arguments for the daemon utility:
# -f: run in the background
# -u: user to run as (optional)
# -o: redirect stdout/stderr to this log file
# -P: location of the pid file for the daemon itself
# -p: location of the pid file for the child process (your script)
logfile="/var/log/${name}.log"
pidfile="/var/run/${name}.pid"
child_pidfile="/var/run/${name}_child.pid"

# Define the actual script to run
command_args="-f -o ${logfile} -P ${pidfile} -p ${child_pidfile} /usr/local/bin/hba_monitor.sh"

load_rc_config $name
run_rc_command "$1"
