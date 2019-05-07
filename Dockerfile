FROM maven:alpine
MAINTAINER Swire Chen <idoop@msn.cn>

ENV VERSION=1.4.0 \
    PORTAL_PORT=8070 \
    DEV_ADMIN_PORT=8090 \
    FAT_ADMIN_PORT=8091 \
    UAT_ADMIN_PORT=8092 \
    PRO_ADMIN_PORT=8093 \
    DEV_CONFIG_PORT=8080 \
    FAT_CONFIG_PORT=8081 \
    UAT_CONFIG_PORT=8082 \
    PRO_CONFIG_PORT=8083

ARG APOLLO_URL=https://github.com/ctripcorp/apollo/archive/v${VERSION}.tar.gz

COPY docker-entrypoint /usr/local/bin/docker-entrypoint
COPY healthcheck    /usr/local/bin/healthcheck

RUN wget ${APOLLO_URL} -O apollo.tar.gz && tar -zxf apollo.tar.gz && \
    rm apollo.tar.gz && test -e apollo-${VERSION} && \
    sed -e "s/db_password=/db_password=toor/g"  \
        -e "s/^dev_meta.*/dev_meta=http:\/\/localhost:${DEV_CONFIG_PORT}/" \
        -e "s/^fat_meta.*/fat_meta=http:\/\/localhost:${FAT_CONFIG_PORT}/" \
        -e "s/^uat_meta.*/uat_meta=http:\/\/localhost:${UAT_CONFIG_PORT}/" \
        -e "s/^pro_meta.*/pro_meta=http:\/\/localhost:${PRO_CONFIG_PORT}/" -i apollo-${VERSION}/scripts/build.sh && \
    bash apollo-${VERSION}/scripts/build.sh && rm -rf /root/.m2 && \
    mkdir /apollo-admin/dev /apollo-admin/fat /apollo-admin/uat /apollo-admin/pro /apollo-config/dev /apollo-config/fat /apollo-config/uat /apollo-config/pro /apollo-portal -p && \
    mv apollo-${VERSION}/apollo-portal/target/apollo-portal-${VERSION}-github.zip  \
       apollo-${VERSION}/apollo-adminservice/target/apollo-adminservice-${VERSION}-github.zip \
       apollo-${VERSION}/apollo-configservice/target/apollo-configservice-${VERSION}-github.zip / && \
    rm -rf apollo-${VERSION} && \
    chmod +x /usr/local/bin/docker-entrypoint /usr/local/bin/healthcheck

HEALTHCHECK --interval=5m --timeout=3s CMD bash /usr/local/bin/healthcheck

EXPOSE 8070 8080 8081 8082 8083 8090 8091 8092 8093
# EXPOSE 80-60000

ENTRYPOINT ["docker-entrypoint"]
