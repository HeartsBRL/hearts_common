# Installation Guide:

```
cd ~
wget https://raw.githubusercontent.com/HeartsBRL/hearts_common/master/hearts_setup/install/install.sh
chmod +x ~/install.sh
./install.sh
```

## Optional extras: 

### Install Aliases:
```
cat ~/workspaces/hearts_erl/src/hearts_common/hearts_setup/install/aliases.sh >> ~/.bashrc
```

### Install OpenCV3 with contribs:
### @NOTE: This currently isn't solving the dependency issue. So you'll have a nice install of opencv3 but the code won't compile.
```
./workspaces/hearts_erl/src/hearts_common/hearts_setup/install_opencv3.sh
```
