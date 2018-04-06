# References :
# https://
FROM byte13/nodejs-ubuntu:latest

# Install usefull utilities
RUN apt-get update && \
    apt-get -y dist-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apt-utils curl wget sudo unzip iproute2 iputils-ping dnsutils net-tools nmap build-essential git

#
# Next line as workaround due to some access errors since NodeJS 8
# https://stackoverflow.com/questions/44633419/no-access-permission-error-with-npm-global-install-on-docker-image
# The problem is because while NPM runs globally installed module scripts as 
# the nobody user, which kinds of makes sense, recent versions of NPM started 
# setting the file permissions for node modules to root. As a result module 
# scripts are no longer allowed to create files and directories in their module.
# A simple workaround, which makes sense in a docker environment, is to set 
# the NPM default global user back to root, like so:

RUN npm -g config set user root

RUN npm install -g openid-connect && \
    npm install -g --unsafe-perm node-red node-red-admin && \
    npm install -g node-red/node-red-auth-twitter && \
    npm install -g node-red/node-red-auth-github && \
    npm install -g node-red-dashboard

# Possibly install latest Mosquitto client (for communication over MQTT)
#RUN sudo wget http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key && \
#    sudo apt-key add mosquitto-repo.gpg.key && \
#    cd /etc/apt/sources.list.d/ && \
#    sudo wget http://repo.mosquitto.org/debian/mosquitto-stretch.list && \
#    sudo apt-get update && \
#    sudo apt-get install mosquitto-clients python-mosquitto 


RUN /usr/sbin/groupadd nodered -g 1234 \ 
    && /usr/sbin/useradd -d /home/nodered -m nodered -u 1234 -g nodered \
    && echo "nodered  ALL=(ALL) NOPASSWD: /usr/bin/python" >>/etc/sudoers

RUN if ! [ -d /vol1 ] ; then mkdir /vol1; chown root:nodered /vol1; chmod 770 /vol1; fi
VOLUME /vol1

USER nodered

# Next section to be updated in case image is run as a Swarm service to me monitored
# HEALTCHECK

# Define what to start by defaut when running the container
ENV NRPORT=7777

CMD /usr/local/bin/node-red -s ${LOCALSETTINGS} -p ${NRPORT} 

