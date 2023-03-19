ARG JDK_VERSION

FROM bellsoft/liberica-openjdk-alpine:${JDK_VERSION}
ARG CONTAINER_PACKAGE_URL


RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

RUN apk --no-cache add make maven

