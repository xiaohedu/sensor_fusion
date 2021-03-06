
#!/bin/bash
source /opt/ros/kinetic/setup.bash
source /home/amsl/ros_catkin_ws/devel/setup.bash

source /home/amsl/.bashrc

# Launch SQ Lidar
gnome-terminal -e '/opt/ros/kinetic/bin/roslaunch sq1_extra sensor_fusion_for_joy.launch' --geometry=50x12+0+0 &
sleep 1s

# Launch Zed 
gnome-terminal -e '/home/amsl/ros_catkin_ws/src/sensor_fusion/scripts/zed/opticalflow_zed0.sh' --geometry=50x12+0+250 &
gnome-terminal -e '/home/amsl/ros_catkin_ws/src/sensor_fusion/scripts/zed/opticalflow_zed1.sh' --geometry=50x12+0+500 &
gnome-terminal -e '/home/amsl/ros_catkin_ws/src/sensor_fusion/scripts/zed/opticalflow_zed2.sh' --geometry=50x12+0+750 &
sleep 1s

# Launch Sensor TF
gnome-terminal -e '/opt/ros/kinetic/bin/roslaunch sensor_fusion laser_tf.launch' --geometry=50x12+250+0 &
sleep 1s
gnome-terminal -e '/opt/ros/kinetic/bin/roslaunch sensor_fusion sq2_zed.launch' --geometry=50x12+250+250 &
sleep 1s

# Transform PointCloud from /centerlaser_ to /centerlaser
gnome-terminal -e '/opt/ros/kinetic/bin/roslaunch sensor_fusion laser_transform_pointcloud.launch' --geometry=50x12+250+500 &
sleep 1s

# imu complement
gnome-terminal -e '/opt/ros/kinetic/bin/roslaunch sensor_fusion imu_complement.launch' --geometry=50x12+250+750 &

sleep 4s

# rviz
gnome-terminal -e '/opt/ros/kinetic/bin/rosrun rviz rviz -d /home/amsl/.rviz/depthimage.rviz' --geometry=50x12+1200+750 &
sleep 1s
