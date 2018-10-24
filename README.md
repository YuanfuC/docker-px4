# docker-px4
Build docker image for px4 Firmware build-environment 

## Clone 项目

```bash
cd ~/

git clone https://github.com/YuanfuC/docker-px4.git
```

## 准备工作
### 安装 docker 
[Linux Ubuntu 安装] (https://docs.docker.com/install/linux/docker-ce/ubuntu/)

```bash
#也可以尝试快速安装
sudo apt-get install docker.io
```
[Mac OS](https://docs.docker.com/docker-for-mac/install/)

### 添加 GCC 安装包
[下载地址](https://releases.linaro.org/archive/14.11/components/toolchain/binaries/arm-linux-gnueabihf/) ,依赖包名：

```
gcc-linaro-4.9-2014.11-x86_64_arm-linux-gnueabihf.tar.xz (136.1M)
```

下载完成放入 ```docker-px4/resources``` 目录下

### 添加 Hexagon SDK v3.0

 [下载地址](https://developer.qualcomm.com/download/hexagon/hexagon-sdk-v3-linux.bin)，**注意** 需要注册高通账号。依赖包名：
 
```
qualcomm_hexagon_sdk_lnx_3_0_eval.bin
```
下载完成放入 ```docker-px4/resources``` 目录下

### 添加 qrlSDK

```
qrl_sdk.tar.gz
```

下载完成放入 ```docker-px4/resources``` 目录下

依赖包 MD5 见以下：

```
MD5 (gcc-linaro-4.9-2014.11-x86_64_arm-linux-gnueabihf.tar.xz) = 6cacdc0c896bae5d7c6f074e2e219db9
MD5 (qualcomm_hexagon_sdk_lnx_3_0_eval.bin) = e34b3b169386476dfa14b5b5c9f1a7be
MD5 (qrl_sdk.tar.gz) = 29831315954479ebfbcd6492feab1a07
```

## 创建 docker image 

```bash

cd ~/docker-px4

docker build -t px4 .

```

## 创建 docker 容器

```bash

docker run -it --privileged -v /vagrant:/home/px4/workspace -v /dev/bus/usb:/dev/bus/usb --name=opx4 -p 33789:22 -d px4

```

## 进入 Docker

```
ssh px4@127.0.0.1 -p 33789
```

