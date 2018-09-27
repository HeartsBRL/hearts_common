#!/bin/sh

# changeable variables.

filepath="$(rospack find hearts_bagging)/bags"
category="TBM2"
teamname="HEARTS"
now=$(date +"%Y%m%d%H%M")


#see README for more information on these outputs.
# the '\' makes the file ignore the new line - for better formatting and readability. 
rosbag record \
-O ${filepath}/${category}_${now}_${teamname} \
/erlc/robot_pose \
/erlc/marker_pose \
/erlc/trajectory \
/erlc/DEVICE/image \
/erlc/DEVICE/camera_info \
/erlc/depth_ID/pointcloud \
/erlc/scan_ID \
tf \
/ERLSCR/command \
/ERLSCR/visitor \
/ERLSCR/audio \
/ERLSCR/notification \
__name:=TBM2bagging





