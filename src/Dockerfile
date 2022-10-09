ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION}

LABEL maintainer="vollborn <oliver.vollborn@gmail.com>"
LABEL version="1.0"
LABEL description="A simple ssh server for JetBrains Gateway"

# auto detect any available apt proxy
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y auto-apt-proxy \
    && sed -i 's/ 127\.0\.0\.1 / host.docker.internal 127.0.0.1 /g' /usr/bin/auto-apt-proxy \
    && auto-apt-proxy

# install common packages
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get upgrade -y \
    && apt-get install -y apt-utils aptitude curl git less nala net-tools openssh-server sudo tini vim unzip wget

# install specific packages for this container
ARG PHP_VERSION=8.1
ARG NODE_VERSION=16

RUN export DEBIAN_FRONTEND=noninteractive \
    && curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -y \
            gcc g++ make python3 \
            nginx \
            nodejs \
            php${PHP_VERSION} php${PHP_VERSION}-fpm php${PHP_VERSION}-xdebug \
    && apt-get autoremove --yes --purge \
    && apt-get autoclean

COPY --from=composer/composer /usr/bin/composer /usr/local/bin/composer

RUN npm upgrade -g && npm i -g express-generator-typescript typescript tslint-to-eslint-config

# copy extra files into the container - ie apt proxy cache, etc
ADD add-files.tar.gz /

RUN systemctl enable ssh

EXPOSE 22

ENTRYPOINT ["/usr/bin/tini-static", "-v", "--"]
CMD ["/startup.sh"]
