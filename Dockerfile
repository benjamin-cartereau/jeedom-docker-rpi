FROM   balenalib/armv7hf-debian:buster

MAINTAINER info@jeedom.com

WORKDIR /tmp
RUN wget -O install_docker.sh -q https://raw.githubusercontent.com/jeedom/core/V4-stable/install/install.sh && chmod +x /tmp/install_docker.sh
RUN sh /tmp/install.sh

WORKDIR /root
RUN wget -q https://raw.githubusercontent.com/jeedom/core/V4-stable/install/OS_specific/Docker/init.sh && chmod +x /root/init.sh

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["sh", "/root/init.sh"]

## Preinstall dependencies
RUN apt-get update && apt-get -y dist-upgrade && \
# Mysql client & git && dumb-init
    apt-get install --no-install-recommends -y default-mysql-client git dumb-init && \
# Plugin Network : fix ping
    apt-get install --no-install-recommends -y iputils-ping && \
# Plugin Z wave
# RPI : pre-install build dependencies on rpi
    apt-get install --no-install-recommends -y git python-pip python-dev python-pyudev python-setuptools python-louie \
    make build-essential libudev-dev g++ gcc python-lxml unzip libjpeg-dev python-serial python-requests && \
    pip install wheel urwid louie six tornado && \
# end of RPI  
    mkdir -p /tmp/jeedom/openzwave/ && cd /tmp && \
    git clone https://github.com/jeedom/plugin-openzwave.git && cd plugin-openzwave && git checkout master && cd resources && \
    chmod u+x ./install_apt.sh && ./install_apt.sh && cd /tmp && rm -Rf plugin-openzwave && \
# Freebox OS
     apt-get install --no-install-recommends -y  android-tools-adb netcat  && \
# Reduce image size
    apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["sh", "/root/init.sh"]
