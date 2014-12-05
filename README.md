## Running Facebook's HHVM on Nginx Dockerfile


This repository contains **Dockerfile** for Running Facebook's HHVM on nginx


### Base Docker Image

* Mainline Nginx on Debian (https://registry.hub.docker.com/u/dorwardv/jessie_nginx/)


### Usage

    docker run -d -p 80:80 dorwardv/jessie_nginx_hhvm

After few seconds, open `http://<host>` to see the Hiphop welcome message? :).

###Build from Dockerfile
    docker build -t="dorwardv/jessie_nginx_hhvm" github.com/dorwardv/jessie_nginx_hhvm


###Note 
hhvm's current build has an issue with jessie. ([See Issue #82][1]).  To resolve, I got the packages from unstable by pinning libgcrypt11 and libgtls26.  This will be the case of this build until the issue is resolve.

  [1]: https://github.com/hhvm/packaging/issues/82
