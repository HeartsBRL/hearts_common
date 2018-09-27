#!/bin/sh

# changeable variables.
filepath="/home/rwakelingg/workspaces/hearts_erl/src/hearts_bagging/bags"
category="TBM1"
teamname="HEARTS"
now=$(date +"%Y%m%d%H%M")


#see README for more information on these outputs.
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
__name:=TBM1bagging


