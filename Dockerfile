FROM maven:alpine
MAINTAINER Swire Chen <idoop@msn.cn>

ENV PORTAL_PORT=8070 \
    ADMIN_DEV_PORT=8090 \
    ADMIN_FAT_PORT=8091 \
    ADMIN_UAT_PORT=8092 \
    ADMIN_PRO_PORT=8093 \
    CONFIG_DEV_PORT=8080 \
    CONFIG_FAT_PORT=8081 \
    CONFIG_UAT_PORT=8082 \
    CONFIG_PRO_PORT=8083

ARG VERSION=1.0.0
ARG APOLLO_URL=https://github.com/ctripcorp/apollo/archive/v${VERSION}.tar.gz

RUN wget ${APOLLO_URL} -O apollo.tar.gz && tar -zxf apollo.tar.gz && \
    rm apollo.tar.gz && test -e apollo-${VERSION} && \
    sed -i "s/db_password=/db_password=toor/g" apollo-${VERSION}/scripts/build.sh && \
    sed -i "s/^dev_meta.*/dev_meta=http:\/\/localhost:${CONFIG_DEV_PORT}/" apollo-${VERSION}/scripts/build.sh && \
    sed -i "s/^fat_meta.*/fat_meta=http:\/\/localhost:${CONFIG_FAT_PORT}/" apollo-${VERSION}/scripts/build.sh && \
    sed -i "s/^uat_meta.*/uat_meta=http:\/\/localhost:${CONFIG_UAT_PORT}/" apollo-${VERSION}/scripts/build.sh && \
    sed -i "s/^pro_meta.*/pro_meta=http:\/\/localhost:${CONFIG_PRO_PORT}/" apollo-${VERSION}/scripts/build.sh && \
    bash apollo-${VERSION}/scripts/build.sh && rm -rf /root/.m2 && \
    mkdir /apollo-admin/dev /apollo-admin/fat /apollo-admin/uat /apollo-admin/pro /apollo-config/dev /apollo-config/fat /apollo-config/uat /apollo-config/pro /apollo-portal -p && \
    unzip apollo-${VERSION}/apollo-portal/target/apollo-portal-${VERSION}-github.zip -d /apollo-portal && \
    sed -i -e "s/^SERVER_PORT=.*$/SERVER_PORT=$PORTAL_PORT/" /apollo-portal/scripts/startup.sh && \
    unzip apollo-${VERSION}/apollo-adminservice/target/apollo-adminservice-${VERSION}-github.zip -d /apollo-admin/dev && \
    unzip apollo-${VERSION}/apollo-adminservice/target/apollo-adminservice-${VERSION}-github.zip -d /apollo-admin/fat && \
    unzip apollo-${VERSION}/apollo-adminservice/target/apollo-adminservice-${VERSION}-github.zip -d /apollo-admin/uat && \
    unzip apollo-${VERSION}/apollo-adminservice/target/apollo-adminservice-${VERSION}-github.zip -d /apollo-admin/pro && \
    sed -i -e "s/^SERVER_PORT=.*$/SERVER_PORT=${ADMIN_DEV_PORT}/" /apollo-admin/dev/scripts/startup.sh && \
    sed -i -e "s/^SERVER_PORT=.*$/SERVER_PORT=${ADMIN_FAT_PORT}/" /apollo-admin/fat/scripts/startup.sh && \
    sed -i -e "s/^SERVER_PORT=.*$/SERVER_PORT=${ADMIN_UAT_PORT}/" /apollo-admin/uat/scripts/startup.sh && \
    sed -i -e "s/^SERVER_PORT=.*$/SERVER_PORT=${ADMIN_PRO_PORT}/" /apollo-admin/pro/scripts/startup.sh && \
    unzip apollo-${VERSION}/apollo-configservice/target/apollo-configservice-${VERSION}-github.zip -d /apollo-config/dev && \
    unzip apollo-${VERSION}/apollo-configservice/target/apollo-configservice-${VERSION}-github.zip -d /apollo-config/fat && \
    unzip apollo-${VERSION}/apollo-configservice/target/apollo-configservice-${VERSION}-github.zip -d /apollo-config/uat && \
    unzip apollo-${VERSION}/apollo-configservice/target/apollo-configservice-${VERSION}-github.zip -d /apollo-config/pro && \
    sed -i -e "s/^SERVER_PORT=.*$/SERVER_PORT=${CONFIG_DEV_PORT}/" /apollo-config/dev/scripts/startup.sh && \
    sed -i -e "s/^SERVER_PORT=.*$/SERVER_PORT=${CONFIG_FAT_PORT}/" /apollo-config/fat/scripts/startup.sh && \
    sed -i -e "s/^SERVER_PORT=.*$/SERVER_PORT=${CONFIG_UAT_PORT}/" /apollo-config/uat/scripts/startup.sh && \
    sed -i -e "s/^SERVER_PORT=.*$/SERVER_PORT=${CONFIG_PRO_PORT}/" /apollo-config/pro/scripts/startup.sh && \
    rm -rf apollo-${VERSION}

COPY docker-entrypoint /usr/local/bin/docker-entrypoint
RUN chmod +x           /usr/local/bin/docker-entrypoint

# EXPOSE 8070 8080 8081 8082 8083 8090 8091 8092 8093
EXPOSE 80-60000

ENTRYPOINT ["docker-entrypoint"]
