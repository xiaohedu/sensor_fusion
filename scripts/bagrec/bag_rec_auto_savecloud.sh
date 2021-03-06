#!/bin/bash

hander()
{
    sleep 1
}

trap hander SIGINT

TIME=$(date +%Y-%m-%d-%H-%M-%S)
CLOUD="/cloud/tf"
CLOUD_GLOBAL="/cloud/global"
ODOM="/odom"
IMU="/imu/data"

ZED0="/zed0/left/image_rect_color/compressed /zed0/right/image_rect_color/compressed /zed0/left/camera_info  "
ZED1="/zed1/left/image_rect_color/compressed /zed1/right/image_rect_color/compressed /zed1/left/camera_info  "
ZED2="/zed2/left/image_rect_color/compressed /zed2/right/image_rect_color/compressed /zed2/left/camera_info  "

ZED0_DEPTH="/zed0/depth/depth_registered/compressedDepth"
ZED1_DEPTH="/zed1/depth/depth_registered/compressedDepth"
ZED2_DEPTH="/zed2/depth/depth_registered/compressedDepth"

MOVE="/zed0/move /zed1/move /zed2/move"
FLOW="/zed0/optical_flow/compressed /zed1/optical_flow/compressed /zed2/optical_flow/compressed"
DIFF="/zed0/diff_image/compressed /zed1/diff_image/compressed /zed2/diff_image/compressed"
NODE="/node"
TRANSFORM="/transform"
TF="/tf /tf_static"

echo $TIME &
echo $CLOUD &
echo $CLOUD_GLOBAL &
echo $ODOM &
echo $IMU &

echo $ZED0 &
echo $ZED1 &
echo $ZED2 &

echo $ZED0_DEPTH &
echo $ZED1_DEPTH &
echo $ZED2_DEPTH &

echo $MOVE &
echo $FLOW &
echo $DIFF &
echo $NODE &
echo $TRANSFORM &
echo $TF &

/opt/ros/kinetic/bin/rosbag record $CLOUD $CLOUD_GLOBAL $ODOM $IMU $ZED0 $ZED0_DEPTH $NODE $TRANSFORM -O /home/amsl/$TIME.bag
