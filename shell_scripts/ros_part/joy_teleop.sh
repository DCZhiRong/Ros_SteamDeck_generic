#!/bin/bash
ROS_DISTRO=$(ls /opt/ros)
source /opt/ros/${ROS_DISTRO}/setup.bash

## Launching teleoperation nodes with custom config for steam deck axes mapping
CONFIG_FILE=@@REPO_PATH@@/configs/steamdeck_config.yaml
ros2 launch leo_teleop joy_teleop.launch.xml joy_config_file:=${CONFIG_FILE} &
LAUNCH_BACK_PID=$!

## Running image view in rqt
rqt -s image_view &
RQT_BACK_PID=$!

## Waiting for RQT close
wait $RQT_BACK_PID
echo "RQT closed"

## Killing the node responsible for joy controll
echo "Killing launch nodes"
kill $LAUNCH_BACK_PID

## Without the kill command on PID we need to kill the nodes manually
#rosnode kill /joy_node
#rosnode kill /joy_teleop_node