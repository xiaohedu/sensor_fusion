/*

author : Yudai Sadakuni

division sqlidar pointcloud

*/

#include<ros/ros.h>
#include<sensor_msgs/PointCloud2.h>
#include<sensor_msgs/point_cloud_conversion.h>
#include<pcl_ros/point_cloud.h>
#include<pcl/point_cloud.h>
#include<pcl/point_types.h>
#include<omp.h>

#define cell_size 0.3
#define grid_dimentions 140

float MIN_THRESHOLD_Z;
float MAX_THRESHOLD_Z;

ros::Publisher pub_center;
ros::Publisher pub_left;
ros::Publisher pub_right;

void pcCallback(const sensor_msgs::PointCloud2ConstPtr& msg)
{
	pcl::PointCloud<pcl::PointXYZ>::Ptr cloud(new pcl::PointCloud<pcl::PointXYZ>);
    fromROSMsg(*msg, *cloud);

    pcl::PointCloud<pcl::PointXYZ> pcl_center;
    pcl::PointCloud<pcl::PointXYZ> pcl_left;
    pcl::PointCloud<pcl::PointXYZ> pcl_right;

    int size = cloud->size();
    printf("size:%d\n",size);

    for(int i=0;i<size;i++)
    {
        int x = ((grid_dimentions/2)+cloud->points[i].x/cell_size);
        int y = ((grid_dimentions/2)+cloud->points[i].y/cell_size);

        if( 0<=x && x<=grid_dimentions 
				&& 0<=y && y<=grid_dimentions
				&& MIN_THRESHOLD_Z < cloud->points[i].z 
                && cloud->points[i].z < MAX_THRESHOLD_Z){
            if(grid_dimentions/2<=y && sqrt(3)*x+grid_dimentions/2*(1-sqrt(3))<=y) pcl_left.push_back(cloud->points[i]);

            else if(y<=grid_dimentions/2 && y<=(-1)*sqrt(3)*x+(1+sqrt(3))*grid_dimentions/2) pcl_right.push_back(cloud->points[i]);

            else pcl_center.push_back(cloud->points[i]);
            
        }
	}

    sensor_msgs::PointCloud2 pc_center;
    pcl::toROSMsg(pcl_center, pc_center);
    pc_center.header.stamp = ros::Time::now();
    pc_center.header.frame_id = msg->header.frame_id;
    pub_center.publish(pc_center);

    sensor_msgs::PointCloud2 pc_left;
    pcl::toROSMsg(pcl_left, pc_left);
    pc_left.header.stamp = ros::Time::now();
    pc_left.header.frame_id = msg->header.frame_id;
    pub_left.publish(pc_left);

    sensor_msgs::PointCloud2 pc_right;
    pcl::toROSMsg(pcl_right, pc_right);
    pc_right.header.stamp = ros::Time::now();
    pc_right.header.frame_id = msg->header.frame_id;
    pub_right.publish(pc_right);
}

int main(int argc, char** argv)
{
    ros::init(argc, argv, "rm_ground_division");
    ros::NodeHandle n;

    ros::Subscriber pc_callback = n.subscribe("/cloud",10,pcCallback);
    
    n.getParam("rm_ground/threshold_z/min", MIN_THRESHOLD_Z);
    n.getParam("rm_ground/threshold_z/max", MAX_THRESHOLD_Z);

    pub_center = n.advertise<sensor_msgs::PointCloud2>("/cloud/center",10);
    pub_left   = n.advertise<sensor_msgs::PointCloud2>("/cloud/left",10);
    pub_right  = n.advertise<sensor_msgs::PointCloud2>("/cloud/right",10);

	ros::spin();

    return 0;
}
