FROM maven:alpine
MAINTAINER Swire Chen <idoop@msn.cn>

ENV VERSION=1.0.0 \
    PORTAL_PORT=8070 \
    ADMIN_DEV_PORT=8090 \
    ADMIN_FAT_PORT=8091 \
    ADMIN_UAT_PORT=8092 \
    ADMIN_PRO_PORT=8093 \
    CONFIG_DEV_PORT=8080 \
    CONFIG_FAT_PORT=8081 \
    CONFIG_UAT_PORT=8082 \
    CONFIG_PRO_PORT=8083

ARG APOLLO_URL=https://github.com/ctripcorp/apollo/archive/v${VERSION}.tar.gz

RUN wget ${APOLLO_URL} -O apollo.tar.gz && tar -zxf apollo.tar.gz && \
    rm apollo.tar.gz && test -e apollo-${VERSION} && \
    sed -e "s/db_password=/db_password=toor/g"  \
        -e "s/^dev_meta.*/dev_meta=http:\/\/localhost:${CONFIG_DEV_PORT}/" \
        -e "s/^fat_meta.*/fat_meta=http:\/\/localhost:${CONFIG_FAT_PORT}/" \
        -e "s/^uat_meta.*/uat_meta=http:\/\/localhost:${CONFIG_UAT_PORT}/" \
        -e "s/^pro_meta.*/pro_meta=http:\/\/localhost:${CONFIG_PRO_PORT}/" -i apollo-${VERSION}/scripts/build.sh && \
    bash apollo-${VERSION}/scripts/build.sh && rm -rf /root/.m2 && \
    mkdir /apollo-admin/dev /apollo-admin/fat /apollo-admin/uat /apollo-admin/pro /apollo-config/dev /apollo-config/fat /apollo-config/uat /apollo-config/pro /apollo-portal -p && \
    mv apollo-${VERSION}/apollo-portal/target/apollo-portal-${VERSION}-github.zip  \
       apollo-${VERSION}/apollo-adminservice/target/apollo-adminservice-${VERSION}-github.zip \
       apollo-${VERSION}/apollo-configservice/target/apollo-configservice-${VERSION}-github.zip / && \
    rm -rf apollo-${VERSION}

COPY docker-entrypoint /usr/local/bin/docker-entrypoint
RUN chmod +x           /usr/local/bin/docker-entrypoint

EXPOSE 8070 8080 8081 8082 8083 8090 8091 8092 8093
# EXPOSE 80-60000

ENTRYPOINT ["docker-entrypoint"]
