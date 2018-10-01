====================================================================
This file details what needs to be recorded/bagged for each task. 
It also summarises everything from the handbook so it's in one place.
=====================================================================


NAME FORMATTING
===============
{F|T}BM{H|W}{1|2|3}_YYYYMMDDhhmm_{teamname}.bag
e.g., FBMH1_201503041356_myteam.bag, TBMH3_201503041156_myteam.bag, etc.



WHAT DATA MUST BE SAVED?
========================
Please note that some data streams (those with the highest bitrate) must be logged only in the time intervals when they are actually used by the robot to perform the activities required by the benchmark. In this way, system load and data bulk are minimized. For instance, whenever a benchmark includes object recognition activities, video and point cloud data must be logged by the robot only in the time intervals when it is actually performing object recognition.



WHERE AND WHEN MUST THE ROBOT SAVETHE DATA
==========================================
Robots must save the data, as specified in the particular benchmark subsection, on a USB stick provided by ERL. The USB stick is given to the team immediately before the start of the benchmark, and must be returned (with the required data on it) at the end of the benchmark.

NOTE: while the content of the data files saved by the robot is not used for scoring, the existence of such files and their compliance to the specifications does influence the score of the robot. Teams have the responsibility of ensuring that the required data files are saved, and of delivering them to the referee at the end of the benchmark. These aspects will benoted on the score sheet and considered for team ranking.



REQUIRED FOR EVERY TASK (or INTERNAL DATA):
========================

Num |Topic                        |Type                        |Frame Id            |Notes
====|=============================|============================|====================|==============
1   |/erlc/robot_pose             |geometry_msgs/PoseStamped   |/map                |10 Hz
2   |/erlc/marker_pose            |geometry_msgsPoseStamped    |/map                |10 Hz
3   |/erlc/trajectory             |nav_msgs/Path               |/map                |Each (re)plan
4   |/erlc/<device>/image         |sensor_msgs/Image           |/<device>_frame     |-
5   |/erlc/<device>/camera_info   |sensor_msgs/CameraInfo      |-                   |-
6   |/erlc/depth_<id>/pointcloud  |sensor_msgs/PointCloud2     |/depth_<id>_frame   |-
7   |/erlc/scan_<id>              |sensor_msgs/LaserScan       |/laser_<id>_frame   |10-40Hz
8   |tf                           |tf                          |-                   |-

Notes:
#1) The 2D robot pose at the foor level, i.e., z = 0 and only yaw rotation.
#2) The 3D pose of the marker in 6 degrees of freedom
#3) Trajectories planned by the robot, referred to the robot base, including when replanning.
#4) Image processed for object perception; <device> must be any of stereo_left, stereo_right, rgb; if multiple devices of type <device> are available on your robot, you can append "_0", "_1", and so on to the device name: e.g., "rgb_0", "stereo_left_2", and so on.
#5) Calibration info for /erlc/<device>/image
#6) Point cloud processed for object perception; <id> is a counter starting from 0 to take into account the fact that multiple depth camera could be present on the robot: e.g., "depth_0", "depth_1", and so on.
#7) Laser scans, <id> is a counter starting from 0 to take into account the fact that multiple laser range finders could be present on the robot: e.g., "scan_0", "scan_1", and so on.
#8) The tf topic on the robot; the tf tree needs to contain the frames described in this table properly connected through the /base_frame which is the odometric center of the robot.




TBM1 - Getting to know my home
============================================
The output provided by the teams is a set of files that must be saved in a USB stick given to the teams before the test. The USB stick will be formatted with FAT32 file system and all the files should be saved in a folder with the name of the team.
The following files are expected:
• semantic map file
• pictures of changed objects and furniture
• metric map files

See TaskBenchamarks, P3, in the handbook. 
No additional items for the rosbag. 




TBM2 - Welcoming visitors
=======================================
Additional rosbag information described in the following table
NOTE: the images and pointclouds in the Internal Data (i.e. the rosbag data being collected for every task) should contain the sensorial data used to recognize the visitor.

Topic                 |Type
/ERLSCR/command       |std_msgs/String
/ERLSCR/visitor       |std_msgs/String
/ERLSCR/audio         |audio_common_msgs/AudioData
/ERLSCR/notification  |std_msgs/String

NOTES:
Command: The event or command causing the activation of the robot.
Visitor: result of any attempt by the robot to detect and classify a visitor
Audio: The audio signals of the conversation with the visitors.
Notifications: Any notifications from the robot (e.g., alarm if a visitor shows anomalous behavior)





TBM3 Catering for Granny Annie's Comfort
=================================================
Additional rosbag information described in the following table
NOTE: the images and pointclouds in the Internal Data (i.e. the rosbag data being collected for every task) should contain the object to be operated.

Topic           |Type
/erlc/command   |std_msgs/String
/erlc/audio     |audio_common_msgs/AudioData

NOTES:
- Thecommand produced by the natural language analysis process.
- The audio of the conversation between user and the robot. Speech files from all teams and all benchmarks (both Task benchmarks and Functionality benchmarks) will be collected and used to build a public dataset. The audio files in the dataset will therefore include all the defects of real-world audio capture using robot hardware (e.g., electrical and mechanical noise, limited bandwidth, harmonic distortion). Such files will be usable to test speech recognition software, or (possibly) to act as input during the execution of speech recognition benchmarks.





TBM4 Visit my home
=================================================
Only need Internal Data (i.e. the rosbag data being collected for every task)







