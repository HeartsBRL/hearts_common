# Installation Guide:

## Network:

SSID: HeartsBRL

Pass: See Docs / YMH

## Tiago:

Note: You'll need to edit the file system on Tiago, which requires some code: (Page 69 of the Handbook 1.5.0).
(Here's what it says)

In order to work with the filesystem as read-write do the following:
```
ssh root@tiago-25c                        #where "tiago-25c" depends on your tiago machine
root@tiago-25c:~# rw
root@tiago-25c:~# nano /etc/hosts         #Check ###/etc/hosts
```

In order to return to the previous state do the following (Close code editor):
```
root@tiago-0c:~# ro
root@tiago-0c:~# exit
```

### Setting the network:


#### /etc/hosts file:
Add the following:

```
[YOUR_LOCAL_IP]   [your_local_hostname]
```

## On Local Machine:

On every machine you want to connect:

#### bash.rc file:
```
export ROS_MASTER_URI=http://10.68.0.1:11311
export ROS_IP=YOUR_IP
```

#### /etc/hosts file:

Add the following:
```
10.68.0.1   control tiago-25c
```
