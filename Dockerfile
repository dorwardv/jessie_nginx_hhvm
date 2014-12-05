from dorwardv/jessie_nginx
MAINTAINER Dorward Villaruz <dorwardv@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

ENV DOCUMENT_ROOT /usr/share/nginx/html

#Install packages
RUN apt-get update 
RUN apt-get -y install wget

#Tell Apt to get libgcypt and libgnutls from debian unstable
COPY libgcrypt11 /etc/apt/preferences.d/libgcrypt11
COPY libgnutls26 /etc/apt/preferences.d/libgnutls26

RUN wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | apt-key add -
RUN echo deb http://dl.hhvm.com/debian jessie main | tee /etc/apt/sources.list.d/hhvm.list
RUN echo deb http://ftp.us.debian.org/debian unstable main contrib non-free | tee /etc/apt/sources.list.d/unstable.list
RUN apt-get update 
RUN apt-get -y install hhvm-nightly

# nginx config
RUN sed -i -e "s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
RUN sed -i -e "s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 10m/" /etc/nginx/nginx.conf
RUN sed -i -e "s|include /etc/nginx/conf.d/\*.conf|include /etc/nginx/sites-enabled/\*|g" /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY default /etc/nginx/sites-available/default
RUN mkdir -p /etc/nginx/sites-enabled
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# configure hhvm
RUN /usr/share/hhvm/install_fastcgi.sh

#update alternatives 
RUN /usr/bin/update-alternatives --install /usr/bin/php php /usr/bin/hhvm 60


# provide standard php info page
COPY info.php ${DOCUMENT_ROOT}/index.php

# change ownership to www-data
RUN chown -R www-data.www-data ${DOCUMENT_ROOT}

EXPOSE 80
EXPOSE 443

CMD service hhvm restart && nginx
