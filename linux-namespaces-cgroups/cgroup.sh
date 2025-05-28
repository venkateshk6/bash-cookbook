#!/bin/bash

# Define variables
CGROUP_NAME="my_cgroup"
CGROUP_PATH="/sys/fs/cgroup/cpu/$CGROUP_NAME"
CPU_LIMIT=50000       # 50% CPU usage (quota in microseconds)
CPU_PERIOD=100000     # Period in microseconds (default is 100ms)

# Step 1: Create a new cgroup
echo "Creating cgroup at $CGROUP_PATH..."
mkdir -p $CGROUP_PATH

# Step 2: Set CPU usage limits
echo "Setting CPU limits..."
echo $CPU_LIMIT > $CGROUP_PATH/cpu.cfs_quota_us
echo $CPU_PERIOD > $CGROUP_PATH/cpu.cfs_period_us

# Step 3: Launch a process to test the CPU limit
echo "Starting a CPU-intensive process (infinite loop)..."
# Launch a background CPU-intensive process
bash -c "while :; do :; done" &
PROCESS_PID=$!

echo "Process started with PID $PROCESS_PID"

# Step 4: Add the process to the cgroup
echo "Adding process $PROCESS_PID to cgroup..."
echo $PROCESS_PID > $CGROUP_PATH/cgroup.procs

# Step 5: Monitor CPU usage for the process
echo "Monitoring CPU usage (press Ctrl+C to exit)..."
while true; do
    CPU_USAGE=$(ps -p $PROCESS_PID -o %cpu=)
    echo "CPU Usage of PID $PROCESS_PID: $CPU_USAGE%"
    sleep 2
done
