ARG NODE_VERSION
FROM ${NODE_VERSION}

ARG TZ
ARG NODE_VERSION
# 描述
LABEL description="node"

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

RUN npm config set registry https://registry.npmmirror.com

WORKDIR /www
