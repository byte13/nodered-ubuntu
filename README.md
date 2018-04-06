# nodered-alpine
NodeRED on Alpine 

This Docker file adds NodeRED on top of byte13/nodejs-alpine
The build possibly updates the base image and utilities.

To run this image and make it accessible on port 80 :
$ docker run -p 7777:80 -d {image name} 

By default, this image runs NodeRED under nodered account (UID 1234) and nodered group (GID 1234).
To run the container as root and privileged, use the following docker parameters :
$ docker run -p 7777:80 -u root --privileged -d {image name}

To specify another TCP port in the container and map it to port 80 of the host, use the following syntax :
$ docker run -p 5555:80 -e "NRPORT=5555" -d {image name}

To map a host directory into the container, she can use the following syntax :
$ docker run -p 7777:80 -v {host directory}:/vol1 -d {image name} 

setting.js contains a default admin password which is : Gaga-2017
To specify a local settings.js file use the following syntax :
$ docker run -p 7777:80 -v {host directory}:/vol1 -e "LOCALSETTINGS=/vol1/{filename}.js" -d {image name} 
Make sure /vol1/{filename}.js is readable by container's running account.

Please, note that the "npm install" commands return errors.
NodeRED still works but the Dockerfile has to be improved to possibly remove the errors.
Suggestions welcome :-)
