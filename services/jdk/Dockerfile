# 以jdk8为基础镜像
ARG JDK_VERSION
FROM bellsoft/liberica-openjdk-alpine:${JDK_VERSION}
# 描述
LABEL description="JDK"

RUN apk --no-cache add make maven

