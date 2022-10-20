ARG PHP_VERSION
FROM ${PHP_VERSION}

ARG TZ
ARG PHP_EXTENSIONS
ARG CONTAINER_PACKAGE_URL

ARG LD_LIBRARY_PATH=/usr/local/instantclient_11_2
ARG ORACLE_HOME=/usr/local/instantclient_11_2
ARG TNS_ADMIN=/usr/local/instantclient_11_2
ARG ORACLE_BASE=/usr/local/instantclient_11_2
ARG NLS_LANG="AMERICAN_AMERICA.AL32UTF8"

ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH 
ENV NLS_LANG $NLS_LANG 
ENV ORACLE_HOME $ORACLE_HOME 
ENV TNS_ADMIN $TNS_ADMIN
ENV ORACLE_BASE $ORACLE_BASE

RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi


COPY ./extensions /tmp/extensions
WORKDIR /tmp/extensions

RUN chmod +x install.sh \
    && sh install.sh \
    && rm -rf /tmp/extensions
ADD ./extensions/install-php-extensions  /usr/local/bin/

RUN chmod uga+x /usr/local/bin/install-php-extensions

# RUN apk --no-cache add tzdata \
RUN apk --no-cache add tzdata \
    && cp "/usr/share/zoneinfo/$TZ" /etc/localtime \
    && echo "$TZ" > /etc/timezone


# Fix: https://github.com/docker-library/php/issues/240
RUN apk add --no-cache gnu-libiconv libstdc++  --repository http://${CONTAINER_PACKAGE_URL}/alpine/edge/community/ --allow-untrusted
# RUN apk add gnu-libiconv libstdc++ --no-cache --repository http://${CONTAINER_PACKAGE_URL}/alpine/edge/community/ --allow-untrusted
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php


# Install composer and change it's cache home
RUN curl -o /usr/bin/composer https://mirrors.aliyun.com/composer/composer.phar \
    && chmod +x /usr/bin/composer
ENV COMPOSER_HOME=/tmp/composer

# Install pdo_oci oci8 for oracle11g
COPY ./oracle_instantclient/instantclient_11_2 /usr/local/instantclient_11_2
# RUN  echo "export LD_LIBRARY_PATH=/usr/local/instantclient_11_2" >> /etc/profile && echo "export NLS_LANG='AMERICAN_AMERICA.AL32UTF8'" >> /etc/profile   && source /etc/profile 
RUN  apk add --no-cache libaio-dev libaio libnsl libnsl-dev --no-cache  
RUN ln -s /usr/local/instantclient_11_2/libclntsh.so.11.1 /usr/local/instantclient_11_2/libclntsh.so && \
    ln -s /usr/local/instantclient_11_2/libocci.so.11.1 /usr/local/instantclient_11_2/libocci.so && \
    ln -s /usr/lib/libnsl.so.2 /usr/lib/libnsl.so.1 
# RUN ls -al /usr/local/instantclient_11_2/ && ls -al /usr/lib/ | grep libnsl
# RUN echo "export LD_LIBRARY_PATH=/usr/local/instantclient_11_2" >> /etc/profile && echo "export NLS_LANG='AMERICAN_AMERICA.AL32UTF8'" >> /etc/profile   && source /etc/profile && \
RUN export LD_LIBRARY_PATH=/usr/local/instantclient_11_2 &&export NLS_LANG='AMERICAN_AMERICA.AL32UTF8' \ 
    && docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/usr/local/instantclient_11_2,11.2 &&docker-php-ext-install pdo_oci  \
    && docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/local/instantclient_11_2 && docker-php-ext-install oci8

# install gd and mcrypt  php5.6
# RUN apk add libmcrypt libmcrypt-dev freetype freetype-dev libpng libpng-dev  libvpx libvpx-dev libjpeg libjpeg-turbo libjpeg-turbo-dev libxpm libxpm-dev libxml2 libxml2-dev  --no-cache && \
#     docker-php-ext-install mcrypt  && \
#     docker-php-ext-configure gd --with-gd --with-vpx-dir  --with-jpeg-dir --with-zlib-dir --with-xpm-dir --with-freetype-dir  && docker-php-ext-install gd
# install gd  php7


# php image's www-data user uid & gid are 82, change them to 1000 (primary user)
#RUN apk add shadow && usermod -u 1000 www-data && groupmod -g 1000 www-data
RUN apk --no-cache add shadow && usermod -u 1000 www-data && groupmod -g 1000 www-data

# RUN apk --no-cache add ca-certificates wget && \
#     cp sgerrand.rsa.pub /etc/apk/keys/sgerrand.rsa.pub && \
#     apk add glibc-bin-2.25-r0.apk glibc-i18n-2.25-r0.apk glibc-2.25-r0.apk 


# 加入常用的软件
RUN apk add --no-cache strace tcpdump file binutils busybox-extras vim

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

WORKDIR /www
