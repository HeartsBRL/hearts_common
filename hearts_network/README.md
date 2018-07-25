# Installation Guide:

## Network:

SSID: HeartsBRL

Pass: See Docs / YMH

## Tiago:

Note: You'll need to edit the file system on Tiago, which requires some code: (Page 69 of the Handbook 1.5.0).
(Here's what it says)

In order to work with the filesystem as read-write do the following:
```
root@tiago-0c:~# rw
Remounting as rw...
Mounting /ro as read-write
Mounting /opt as read-write
Mounting /var/lib/dpkg as read-write
Binding system files...
root@tiago-0c:~# chroot /ro
```

In order to return to the previous state do the following:
```
root@tiago-0c:~# exit
root@tiago-0c:~# ro
Remount /ro as read only
Remount /var/lib/dpkg as read only
Remount /opt as read only
Unbinding system files
```

### Setting the network:

#### bash.rc file:
```
export ROS_MASTER_URI=http://localhost:11311
export ROS_IP=ipaddress
```

#### /etc/hosts file:
Add the following:

```
192.168.0.114   control tiago-25c
```

## On Loacal Machine:

On every machine you want to connect:

#### bash.rc file:
```
export ROS_MASTER_URI=http://localhost:11311
export ROS_IP=ipaddress
```

#### /etc/hosts file:

Add the following:
```
192.168.0.114   control tiago-25c
```
