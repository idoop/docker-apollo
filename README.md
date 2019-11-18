# docker-apollo

[![Docker Build Status](https://img.shields.io/docker/build/idoop/docker-apollo.svg)](https://hub.docker.com/r/idoop/docker-apollo/)
[![Docker Pulls](https://img.shields.io/docker/pulls/idoop/docker-apollo.svg)](https://hub.docker.com/r/idoop/docker-apollo/)
[![Docker Automated build](https://img.shields.io/docker/automated/idoop/docker-apollo.svg)](https://hub.docker.com/r/idoop/docker-apollo/)
[![ImageLayers Size](https://img.shields.io/imagelayers/image-size/idoop/docker-apollo/latest.svg)](https://hub.docker.com/r/idoop/docker-apollo/)
[![ImageLayers Layers](https://img.shields.io/imagelayers/layers/idoop/docker-apollo/latest.svg)](https://hub.docker.com/r/idoop/docker-apollo/)

[Docker image](https://hub.docker.com/r/idoop/docker-apollo/) for [Ctrip/Apollo](https://github.com/ctripcorp/apollo)(携程Apollo)

**本镜像包含Portal面板,以及Dev/Fat/Uat/Pro环境服务(All in one),皆可独立使用,支持分布式部署和Kubernetes部署.**


## Docker Tags: 

- [`1.5.1`](https://github.com/ctripcorp/apollo/releases/tag/v1.5.1) `latest`
- [`1.5.0`](https://github.com/ctripcorp/apollo/releases/tag/v1.5.0) 
- [`1.4.0`](https://github.com/ctripcorp/apollo/releases/tag/v1.4.0)
- [`1.3.0`](https://github.com/ctripcorp/apollo/releases/tag/v1.3.0)
- [`1.2.0`](https://github.com/ctripcorp/apollo/releases/tag/v1.2.0)
- [`1.1.1`](https://github.com/ctripcorp/apollo/releases/tag/v1.1.1) [`1.1.2`](https://github.com/ctripcorp/apollo/releases/tag/v1.1.2)
- [`1.0.0`](https://github.com/ctripcorp/apollo/releases/tag/v1.0.0)
- [`0.10.2`](https://github.com/ctripcorp/apollo/releases/tag/v0.10.2) [`0.11.0`](https://github.com/ctripcorp/apollo/releases/tag/v0.11.0)

## 使用 Docker Compose 启动
假设想要开启Protal/Dev/Fat,那么建立一个`docker-compose.yaml`文件,内容大致如下所示,只需将mysql数据库地址与库名以及账号密码替换为自己的,并配置好数据库:
``` yaml
version: '2.2'
services:
  apollo:
    image: idoop/docker-apollo:latest
    # portal若出现504错误,则将网络模式改为host. host模式下如果想改端口,参考下方修改端口的环境变量
    # network_mode: "host"
    # volumes:
      # 如果需要查看日志,挂载容器中的/opt路径出来即可.
    #  - ./logs:/opt
      # 如果portal需要开启ldap或ad域验证,须挂载此ldap配置文件
    #  - ./application-ldap.yml:/apollo-portal/config/application-ldap.yml:ro
    environment:
      # 开启Portal,默认端口: 8070
      PORTAL_DB: jdbc:mysql://192.168.1.28:3306/ApolloPortalDB?characterEncoding=utf8
      PORTAL_DB_USER: root
      PORTAL_DB_PWD: toor
      # 如果portal需要开启ldap或ad域验证,须设置该环境变量为TRUE
      #PORTAL_LDAP: "TRUE"
      
      # 开启dev环境, 默认端口: config 8080, admin 8090
      DEV_DB: jdbc:mysql://192.168.1.28:3306/ApolloConfigDBDev?characterEncoding=utf8
      DEV_DB_USER: root
      DEV_DB_PWD: toor
      
      # 开启fat环境, 默认端口: config 8081, admin 8091
      FAT_DB: jdbc:mysql://192.168.1.28:3306/ApolloConfigDBFat?characterEncoding=utf8
      FAT_DB_USER: root
      FAT_DB_PWD: toor
      # 若network_mode为host,则可修改端口,如下:
      #FAT_CONFIG_PORT: 8050
      #FAT_ADMIN_PORT: 8051
           
      # 指定远程uat地址
      #UAT_URL: http://192.168.1.2:8080
      
      # 指定远程pro地址
      #PRO_URL: http://www.example.com:8080
```


**启动前确认对应的数据库已建立,且数据库账号有权操作该库,否则将会启动失败.**[创建数据库指导](https://github.com/ctripcorp/apollo/wiki/%E5%88%86%E5%B8%83%E5%BC%8F%E9%83%A8%E7%BD%B2%E6%8C%87%E5%8D%97#21-%E5%88%9B%E5%BB%BA%E6%95%B0%E6%8D%AE%E5%BA%93)


## 资源消耗

Apollo为Java程序,所以镜像启动慢,且耗内存,因此有多开服务环境需求的请注意小鸡的内存是否够用. 

测试机为4核2.6G的x5650：

> 只启动Portal,用时20s,占内存280M.
>
> Portal+dev(admin+config),用时90s,占内存999M.
>
> Portal+dev+fat,用时154s,占内存1674M.
>
> Protal+dev+fat+uat,自行估算.
>
> Protal+dev+fat+uat+pro,自行估算.

## Environment 参数

若要开启相应服务,只需配置对应环境的env的数据库地址与账号密码,数据库密码不能为空。

> - ONLY_CONFIG: 若是分布式部署或是kubernetes中部署,可配置值为`TRUE`,使得容器中只启动config服务,节省内存资源.详细用法参考wiki.

Portal:
> - PORTAL_DB: portal 的数据库地址, 未设置则代表不开启该服务
> - PORTAL_DB_USER: 数据库用户
> - PORTAL_DB_PWD: 数据库密码
> - PORTAL_PORT: portal服务的端口,默认8070.若网络模式为host,可更改.
> - PORTAL_LDAP: 若要开启LDAP登录验证,设置该值为**TRUE**,并挂载配置文件到`/apollo-portal/config/application-ldap.yml`容器中,详情参考[官方说明](https://github.com/ctripcorp/apollo/wiki/Portal-%E5%AE%9E%E7%8E%B0%E7%94%A8%E6%88%B7%E7%99%BB%E5%BD%95%E5%8A%9F%E8%83%BD).
> - DEV_URL: 远程dev服务,格式为http://**ip:port** 或 **domain:port** 不可与DEV_DB同时指定,数据库中ServerConfig中eureka.service.url的地址与端口需正确.
> - FAT_URL: 远程fat服务,格式为http://**ip:port** 或 **domain:port** 不可与FAT_DB同时指定,数据库中ServerConfig中eureka.service.url的地址与端口需正确.
> - UAT_URL: 远程uat服务,格式为http://**ip:port** 或 **domain:port** 不可与UAT_DB同时指定,数据库中ServerConfig中eureka.service.url的地址与端口需正确.
> - PRO_URL: 远程pro服务,格式为http://**ip:port** 或 **domain:port** 不可与PRO_DB同时指定,数据库中ServerConfig中eureka.service.url的地址与端口需正确.

Dev:
> - DEV_LB: 若使用分布式负载均衡,则输入负载均衡地址,格式为IP或域名.
> - DEV_DB: dev 环境数据库地址, 未设置则代表不开启该服务
> - DEV_DB_USER: 数据库用户
> - DEV_DB_PWD: 数据库密码
> - DEV_ADMIN_PORT: admin服务端口,默认8090,若网络模式为host,可指定更改.
> - DEV_CONFIG_PORT: config服务端口,默认8080,若网络模式为host,可指定更改,需要与本数据库中的ServerConfig中eureka.service.url端口相同.

Fat:
> - FAT_LB: 若使用分布式负载均衡,则输入负载均衡地址,,格式为IP或域名.
> - FAT_DB: fat 环境数据库地址, 未设置则代表不开启该服务
> - FAT_DB_USER: 数据库用户
> - FAT_DB_PWD: 数据库密码
> - FAT_ADMIN_PORT: admin服务端口,默认8091.若网络模式为host,可指定更改.
> - FAT_CONFIG_PORT: config服务端口,默认8081.若网络模式为host,可指定更改,需要与本数据库中的ServerConfig中eureka.service.url端口相同.

Uat:
> - UAT_LB: 若使用分布式负载均衡,则输入负载均衡地址,,格式为IP或域名.
> - UAT_DB: uat 环境数据库地址, 未设置则代表不开启该服务
> - UAT_DB_USER: 数据库用户
> - UAT_DB_PWD: 数据库密码
> - UAT_ADMIN_PORT: admin服务端口,默认8092.若网络模式为host,可指定更改.
> - UAT_CONFIG_PORT: config服务端口,默认8082.若网络模式为host,可指定更改,需要与本数据库中的ServerConfig中eureka.service.url端口相同.

Pro:
> - PRO_LB: 若使用分布式负载均衡,则输入负载均衡地址,,格式为IP或域名.
> - PRO_DB: pro 环境数据库地址, 未设置则代表不开启该服务
> - PRO_DB_USER: 数据库用户
> - PRO_DB_PWD: 数据库密码
> - PRO_ADMIN_PORT: admin服务端口,默认8093.若网络模式为host,可指定更改.
> - PRO_CONFIG_PORT: config服务端口,默认8083.若网络模式为host,可指定更改,需要与本数据库中的ServerConfig中eureka.service.url端口相同.


## 用例

> **详细用例请看[Wiki](https://github.com/idoop/docker-apollo/wiki)**
