FROM ubuntu:16.04

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND noninteractive

# Update apt-get
#COPY ./resources/sources.list /etc/apt/sources.list

# Installing packages
RUN apt-get update && apt-get -f -y --no-install-recommends install \
    locales \
    curl \
    git \
    openssh-client \
    pkg-config \
    wget \
    zip \
    unzip \
    openssh-server \
    python-software-properties \
    software-properties-common \
    apt-utils 

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Java
RUN apt-add-repository ppa:openjdk-r/ppa \
    && apt-get update \
    && apt-get install -y openjdk-8-jdk 
# Export JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

RUN apt-get -y install vim zsh
RUN apt-get -y install sudo
RUN apt-get install usbutils
RUN apt-get install python-jinja2

#RUN sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
#agent
RUN useradd -d /home/px4 -m -s /bin/bash px4
RUN echo "px4:px4" | chpasswd && adduser px4 sudo
RUN mkdir -p /home/jenkins/workspace
RUN chown -R px4:px4 /home/px4
#relief --privileged necessity while run container
RUN sed -i 's/\(session[[:blank:]]+required[[:blank:]]+pam_loginuid.so\)/#\1/' /etc/pam.d/sshd
RUN usermod -a -G dialout px4

WORKDIR /home/px4
COPY ./resources/startup.sh /usr/local/bin/startup.sh

USER px4

# Gradle Configs
ENV JAVA_OPTS="-Xms512m -Xmx512m" 

#install Snapdragon toolchain
RUN git clone https://github.com/ATLFlight/cross_toolchain.git
COPY ./resources/qualcomm_hexagon_sdk_lnx_3_0_eval.bin /home/px4/cross_toolchain/downloads
COPY ./resources/gcc-linaro-4.9-2014.11-x86_64_arm-linux-gnueabihf.tar.xz /home/px4/cross_toolchain/downloads
RUN /home/px4/cross_toolchain/installsdk.sh --APQ8074 --arm-gcc 

COPY ./resources/qrl_sdk.tar.gz /home/px4/Qualcomm
RUN tar -xzvf /home/px4/Qualcomm/qrl_sdk.tar.gz
RUN mv ./qrl_sdk/ /home/px4/Qualcomm

COPY ./resources/ubuntu_sim_common_deps.sh /home/px4

RUN echo 'export HEXAGON_SDK_ROOT=/home/px4/Qualcomm/Hexagon_SDK/3.0' >> ~/.bashrc
RUN echo 'export HEXAGON_TOOLS_ROOT=/home/px4/Qualcomm/HEXAGON_Tools/7.2.12/Tools' >> ~/.bashrc
RUN echo 'export HEXAGON_ARM_SYSROOT=/home/px4/Qualcomm/qrl_sdk/sysroots/eagle8074' >> ~/.bashrc
RUN echo 'export ARM_CROSS_GCC_ROOT=/home/px4/Qualcomm/ARM_Tools/gcc-4.9-2014.11' >> ~/.bashrc

USER root

RUN  chmod +x ubuntu_sim_common_deps.sh 
RUN  /home/px4/ubuntu_sim_common_deps.sh

EXPOSE 22

ENTRYPOINT ["/bin/bash","/usr/local/bin/startup.sh" ]
