该项目 fork 自 https://github.com/yeszao/dnmp
自己使用过程中添加或修改

# 2023-03-24 新增nginx忽略配置
增加 bad_configs 配置项，防止某些配置错误导致的 nginx 启动失败

# 2023-03-19 加入k8s转换及支持
1. 添加 kompose 脚本，将 docker-compose 配置转为 k8s 的 yaml 配置文件，并使用 kubectl apply 应用每一个service。
2. 

PHP

```
加入 oracle 的 pdo_oci ,oci8 扩展,对于 php5.6 的 gd 库扩展做了补充.
解决 pdo_oci 扩展的中文乱码问题
加入 PHP8, xdebug 2.7 - 3.1.2 的配置
添加配置开发及线上环境的 opcache
开启错误显示 display_errors = On
```

PHP 扩展安装

1. install-php-extensions xdebug
2. export PHP_EXTENSIONS=pcntl  && sh /tmp/extensions/install.sh
3. pecl install xdebug
4. docker-php-source extract  && cd /usr/src/php/ext/pcntl && phpize && ./configure && make && make install
5. docker cp source_dir php:/usr/src/php/ext  然后进入docker容器,编译安装



NGINX

```
加入默认配置,thinkphp 的重定向及 thinkphp 二级目录的配置,gzip配置,跨域配置,加入 gzip压缩配置,修改缓存大小,超时时间
```

JDK

```
加入 openjdk8 的镜像
```

ORACLE

```
加入 oracle11g 的镜像 安装文件需自行下载,只提供安装脚本
```

oracle11g 文档地址 [https://docs.oracle.com/cd/E11882\\\_01/nav/portal\\\_11.htm](https://docs.oracle.com/cd/E11882%5C_01/nav/portal%5C_11.htm)

下载地址  <https://www.oracle.com/cn/database/enterprise-edition/downloads/oracle-db11g-linux.html#license-lightbox>

GO

```
加入 go 1.16 的镜像
```

ELASTICSEARCH

```
修改es配置,开启跨域访问
加入 IK 分词插件(无需在线下载安装,自带插件文件)
```

MYSQL

如果启动失败,请将 data 目录中的 mysql 目录清理后再使用 docker-compose up mysql ,或者检查 data/mysql 目录是否有读写权限

设置允许外部连接


```
mysql>GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
 mysql>flush privileges;
```

修改密码



```bash
   mysql>   GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
   mysql8>  grant all privileges on *.* to 'root'@'%' with grant option; 
   mysql>   flush privileges;

```

修改密码 mysql5.7

```bash
mysql -u root -p
# 登录后使用
SET PASSWORD FOR 'root'@'%' = PASSWORD('caoayu');
ALTER USER 'root'@'%' IDENTIFIED BY 'caoayu'; # mysql8
```


修改密码 mysql8

登录|连接失败处理

> mysql #先使用无密码进入

```bash
update user set host='%' where user='root';
flush privileges;
ALTER user 'root'@'%' IDENTIFIED BY 'caoayu';
flush privileges;
```

OTHER

```
其他,加入 docker-compose 对内/外部容器的链接 external_links

指定版本 PHP 扩展安装 install-php-extensions xdebug-2.9.7
```

---

PHP xdebug2配置

```ini
[XDebug]
zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20131226/xdebug.so
xdebug.remote_enable = 1
xdebug.remote_handler = "dbgp"
; Set to host.docker.internal on Mac and Windows, otherwise, set to host real ip
xdebug.remote_host = 192.168.93.1
xdebug.remote_port = 9001
xdebug.remote_log = /var/log/php/xdebug2.log

xdebug.idekey="PHPSTORM"
xdebug.remote_autostart=1
xdebug.remote_connect_back=0
xdebug.max_nesting_level=256
xdebug.overload_var_dump=1
```

PHP xdebug3配置

```ini
[XDebug]
;开启xdebug支持，不同的mode的不同的用途，详细说明请看官方文档
xdebug.mode = develop,debug,profile,trace ;如果要多个模式一起开启，就用`,`分隔开就行
xdebug.profiler_append = 0
xdebug.profiler_output_name = cachegrind.out.%p
xdebug.start_with_request = yes ;这里与原来不同了，原来如果要开启trace或profile,用的是enable_trace,enable_profile等字段
xdebug.trigger_value=StartProfileForMe ;这里就是原来的profile_trigger_value,trace_trigger_value
; xdebug.client_host = host.docker.internal
xdebug.client_host = host.docker.internal
; xdebug.client_port = 9001
xdebug.log = /var/log/php/xdebug2.log
xdebug.idekey="PHPSTORM"
```

PHP OPcache配置

```ini
[opcache]
opcache.revalidate_freq=0
; opcache.validate_timestamps=0 ;(在开发环境可以把这一行注释掉)
opcache.max_accelerated_files=7963
opcache.memory_consumption=192
opcache.interned_strings_buffer=16
opcache.fast_shutdown=1
```

NINGX SSL证书申请及配置
首先在.env文件中加入 `NGINX_INSTALL_APPS=certbot`

配置说明 : https://www.wolai.com/s33QhUZMK2aH8vjvTT36Z4

NGINX 配置 laravel tp 项目及二级目录通用url重写规则

```conf
#  laravel Tp 通用 框架重写
rewrite ^/(.*)/public/(.*)$ /$1/public/index.php?s=$2 last;
# TP3.2重写
rewrite ^/(.*)/www/(.*)$ /$1/www/index.php?s=$2 last;
```

NGINX 配置反向代理，及反向代理目录下某些静态资源加载失败解决方案（重写静态资源url）

```conf
# 反向代理
location /tp/ {
    proxy_pass http://127.0.0.1/tp6/public/;

    # 携带客户端IP等信息
    proxy_redirect off;
    proxy_set_header Host $host:$server_port;
    proxy_set_header  X-Real-IP  $remote_addr;
    proxy_set_header  X-Forwarded-For  $proxy_add_x_forwarded_for;
 
}
# 配置反向代理后某些静态资源请求路径失败，重写url为项目目录
location ~ /tp/.*\.(gif|jpg|jpeg|bmp|png)$
{
    rewrite '^/tp/(.*)/(.*)\.(png|jpg|gif)$' /tp6/public/$1/$2.$3 last;
}
```

加入 jdk 镜像，支持 jdk8，jdk11 等。并安装 maven ，设置阿里云仓库源。


----

### 原 fork 项目说明

DNMP（Docker + Nginx + MySQL + PHP7/5 + Redis）是一款全功能的**LNMP一键安装程序**。

> 使用前最好提前阅读一遍[目录](#%E7%9B%AE%E5%BD%95)，以便快速上手，遇到问题也能及时排除。交流QQ一群：**572041090（已满）**，二群：**300723526**。

[**\[ENGLISH\]**](README-en.md) -
[**\[GitHub地址\]**](https://github.com/yeszao/dnmp) -
[**\[Gitee地址\]**](https://gitee.com/yeszao/dnmp)

DNMP项目特点：

 1. `100%`开源

 2. `100%`遵循Docker标准

 3. 支持**多版本PHP**共存，可任意切换（PHP5.4、PHP5.6、PHP7.1、PHP7.2、PHP7.3)

 4. 支持绑定**任意多个域名**

 5. 支持**HTTPS和HTTP/2**

 6. **PHP源代码、MySQL数据、配置文件、日志文件**都可在Host中直接修改查看

 7. 内置**完整PHP扩展安装**命令

 8. 默认支持 `pdo_mysql`、`mysqli`、`mbstring`、`gd`、`curl`、`opcache`等常用热门扩展，根据环境灵活配置

 9. 可一键选配常用服务：

    - 多PHP版本：PHP5.4、PHP5.6、PHP7.1-7.3

    - Web服务：Nginx、Openresty

    - 数据库：MySQL5、MySQL8、Redis、memcached、MongoDB、ElasticSearch

    - 消息队列：RabbitMQ

    - 辅助工具：Kibana、Logstash、phpMyAdmin、phpRedisAdmin、AdminMongo

10. 实际项目中应用，确保 `100%`可用

11. 所有镜像源于[Docker官方仓库](https://hub.docker.com)，安全可靠

12. 一次配置，**Windows、Linux、MacOs**皆可用

13. 支持快速安装扩展命令 `install-php-extensions apcu`

# 目录

- [1.目录结构](#1%E7%9B%AE%E5%BD%95%E7%BB%93%E6%9E%84)

- [2.快速使用](#2%E5%BF%AB%E9%80%9F%E4%BD%BF%E7%94%A8)

- [3.PHP和扩展](#3PHP%E5%92%8C%E6%89%A9%E5%B1%95)

  - [3.1 切换Nginx使用的PHP版本](#31-%E5%88%87%E6%8D%A2Nginx%E4%BD%BF%E7%94%A8%E7%9A%84PHP%E7%89%88%E6%9C%AC)

  - [3.2 安装PHP扩展](#32-%E5%AE%89%E8%A3%85PHP%E6%89%A9%E5%B1%95)

  - [3.3 快速安装php扩展](#33-%E5%BF%AB%E9%80%9F%E5%AE%89%E8%A3%85php%E6%89%A9%E5%B1%95)

  - [3.4 Host中使用php命令行（php-cli）](#34-host%E4%B8%AD%E4%BD%BF%E7%94%A8php%E5%91%BD%E4%BB%A4%E8%A1%8Cphp-cli)

  - [3.5 使用composer](#35-%E4%BD%BF%E7%94%A8composer)

- [4.管理命令](#4%E7%AE%A1%E7%90%86%E5%91%BD%E4%BB%A4)

  - [4.1 服务器启动和构建命令](#41-%E6%9C%8D%E5%8A%A1%E5%99%A8%E5%90%AF%E5%8A%A8%E5%92%8C%E6%9E%84%E5%BB%BA%E5%91%BD%E4%BB%A4)

  - [4.2 添加快捷命令](#42-%E6%B7%BB%E5%8A%A0%E5%BF%AB%E6%8D%B7%E5%91%BD%E4%BB%A4)

- [5.使用Log](#5%E4%BD%BF%E7%94%A8log)

  - [5.1 Nginx日志](#51-nginx%E6%97%A5%E5%BF%97)

  - [5.2 PHP-FPM日志](#52-php-fpm%E6%97%A5%E5%BF%97)

  - [5.3 MySQL日志](#53-mysql%E6%97%A5%E5%BF%97)

- [6.数据库管理](#6%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AE%A1%E7%90%86)

  - [6.1 phpMyAdmin](#61-phpmyadmin)

  - [6.2 phpRedisAdmin](#62-phpredisadmin)

- [7.在正式环境中安全使用](#7%E5%9C%A8%E6%AD%A3%E5%BC%8F%E7%8E%AF%E5%A2%83%E4%B8%AD%E5%AE%89%E5%85%A8%E4%BD%BF%E7%94%A8)

- [8.常见问题](#8%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98)

  - [8.1 如何在PHP代码中使用curl？](#81-%E5%A6%82%E4%BD%95%E5%9C%A8php%E4%BB%A3%E7%A0%81%E4%B8%AD%E4%BD%BF%E7%94%A8curl)

  - [8.2 Docker使用cron定时任务](#82-Docker%E4%BD%BF%E7%94%A8cron%E5%AE%9A%E6%97%B6%E4%BB%BB%E5%8A%A1)

  - [8.3 Docker容器时间](#83-Docker%E5%AE%B9%E5%99%A8%E6%97%B6%E9%97%B4)

  - [8.4 如何连接MySQL和Redis服务器](#84-%E5%A6%82%E4%BD%95%E8%BF%9E%E6%8E%A5MySQL%E5%92%8CRedis%E6%9C%8D%E5%8A%A1%E5%99%A8)

## 1.目录结构

```
/
├── data                        数据库数据目录
│   ├── esdata                  ElasticSearch 数据目录
│   ├── mongo                   MongoDB 数据目录
│   ├── mysql                   MySQL8 数据目录
│   └── mysql5                  MySQL5 数据目录
├── services                    服务构建文件和配置文件目录
│   ├── elasticsearch           ElasticSearch 配置文件目录
│   ├── mysql                   MySQL8 配置文件目录
│   ├── mysql5                  MySQL5 配置文件目录
│   ├── nginx                   Nginx 配置文件目录
│   ├── php                     PHP5.6 - PHP7.3 配置目录
│   ├── php54                   PHP5.4 配置目录
│   └── redis                   Redis 配置目录
├── logs                        日志目录
├── docker-compose.sample.yml   Docker 服务配置示例文件
├── env.smaple                  环境配置示例文件
└── www                         PHP 代码目录
```

## 2.快速使用

1. 本地安装

   - `git`

   - `Docker`(系统需为Linux，Windows 10 Build 15063+，或MacOS 10.12+，且必须要 `64`位）

   - `docker-compose 1.7.0+`

2. `clone`项目：

   ```
   $ git clone https://github.com/yeszao/dnmp.git
   ```

3. 如果不是 `root`用户，还需将当前用户加入 `docker`用户组：

   ```
   $ sudo gpasswd -a ${USER} docker
   ```

4. 拷贝并命名配置文件（Windows系统请用 `copy`命令），启动：

   ```
   $ cd dnmp                                           # 进入项目目录
   $ cp env.sample .env                                # 复制环境变量文件
   $ cp docker-compose.sample.yml docker-compose.yml   # 复制 docker-compose 配置文件。默认启动3个服务：
                                                       # Nginx、PHP7和MySQL8。要开启更多其他服务，如Redis、
                                                       # PHP5.6、PHP5.4、MongoDB，ElasticSearch等，请删
                                                       # 除服务块前的注释
   $ docker-compose up                                 # 启动
   ```

5. 在浏览器中访问：`http://localhost`或 `https://localhost`(自签名HTTPS演示)就能看到效果，PHP代码在文件 `./www/localhost/index.php`。

## 3.PHP和扩展

### 3.1 切换Nginx使用的PHP版本

首先，需要启动其他版本的PHP，比如PHP5.4，那就先在 `docker-compose.yml`文件中删除PHP5.4前面的注释，再启动PHP5.4容器。

PHP5.4启动后，打开Nginx 配置，修改 `fastcgi_pass`的主机地址，由 `php`改为 `php54`，如下：

```
    fastcgi_pass   php:9000;
```

为：

```
    fastcgi_pass   php54:9000;
```

其中 `php` 和 `php54` 是 `docker-compose.yml`文件中服务器的名称。

最后，**重启 Nginx** 生效。

```bash
$ docker exec -it nginx nginx -s reload
```

这里两个 `nginx`，第一个是容器名，第二个是容器中的 `nginx`程序。

### 3.2 安装PHP扩展

PHP的很多功能都是通过扩展实现，而安装扩展是一个略费时间的过程，
所以，除PHP内置扩展外，在 `env.sample`文件中我们仅默认安装少量扩展，
如果要安装更多扩展，请打开你的 `.env`文件修改如下的PHP配置，
增加需要的PHP扩展：

```bash
PHP_EXTENSIONS=pdo_mysql,opcache,redis       # PHP 要安装的扩展列表，英文逗号隔开
PHP54_EXTENSIONS=opcache,redis                 # PHP 5.4要安装的扩展列表，英文逗号隔开
```

然后重新build PHP镜像。

```bash
docker-compose build php
```

可用的扩展请看同文件的 `env.sample`注释块说明。

### 3.3 快速安装php扩展

1\.进入容器:

```sh
docker exec -it php /bin/sh

install-php-extensions apcu 
```

2\.支持快速安装扩展列表

<!-- START OF EXTENSIONS TABLE -->

<!-- ########################################################### -->

<!-- #                                                         # -->

<!-- #  DO NOT EDIT THIS TABLE: IT IS GENERATED AUTOMATICALLY  # -->

<!-- #                                                         # -->

<!-- #  EDIT THE data/supported-extensions FILE INSTEAD        # -->

<!-- #                                                         # -->

<!-- ########################################################### -->

|Extension|PHP 5.5|PHP 5.6|PHP 7.0|PHP 7.1|PHP 7.2|PHP 7.3|PHP 7.4|PHP 8.0|
|-|-|-|-|-|-|-|-|-|
|amqp|✓|✓|✓|✓|✓|✓|✓|✓|
|apcu|✓|✓|✓|✓|✓|✓|✓|✓|
|apcu_bc|||✓|✓|✓|✓|✓||
|ast|||✓|✓|✓|✓|✓|✓|
|bcmath|✓|✓|✓|✓|✓|✓|✓|✓|
|bz2|✓|✓|✓|✓|✓|✓|✓|✓|
|calendar|✓|✓|✓|✓|✓|✓|✓|✓|
|cmark|||✓|✓|✓|✓|✓||
|csv||||||✓|✓|✓|
|dba|✓|✓|✓|✓|✓|✓|✓|✓|
|decimal|||✓|✓|✓|✓|✓|✓|
|ds|||✓|✓|✓|✓|✓|✓|
|enchant[\*](#special-requirements-for-enchant)|✓|✓|✓|✓|✓|✓|✓|✓|
|ev|✓|✓|✓|✓|✓|✓|✓|✓|
|excimer||||✓|✓|✓|✓|✓|
|exif|✓|✓|✓|✓|✓|✓|✓|✓|
|ffi|||||||✓|✓|
|gd|✓|✓|✓|✓|✓|✓|✓|✓|
|gearman|✓|✓|✓|✓|✓|✓|✓|✓|
|geoip|✓|✓|✓|✓|✓|✓|✓||
|geospatial|✓|✓|✓|✓|✓|✓|✓|✓|
|gettext|✓|✓|✓|✓|✓|✓|✓|✓|
|gmagick|✓|✓|✓|✓|✓|✓|✓|✓|
|gmp|✓|✓|✓|✓|✓|✓|✓|✓|
|gnupg|✓|✓|✓|✓|✓|✓|✓|✓|
|grpc|✓|✓|✓|✓|✓|✓|✓|✓|
|http|✓|✓|✓|✓|✓|✓|✓|✓|
|igbinary|✓|✓|✓|✓|✓|✓|✓|✓|
|imagick|✓|✓|✓|✓|✓|✓|✓|✓|
|imap|✓|✓|✓|✓|✓|✓|✓|✓|
|inotify|✓|✓|✓|✓|✓|✓|✓|✓|
|interbase|✓|✓|✓|✓|✓|✓|||
|intl|✓|✓|✓|✓|✓|✓|✓|✓|
|ioncube_loader|✓|✓|✓|✓|✓|✓|✓||
|json_post|✓|✓|✓|✓|✓|✓|✓|✓|
|ldap|✓|✓|✓|✓|✓|✓|✓|✓|
|mailparse|✓|✓|✓|✓|✓|✓|✓|✓|
|maxminddb|||||✓|✓|✓|✓|
|mcrypt|✓|✓|✓|✓|✓|✓|✓|✓|
|memcache|✓|✓|✓|✓|✓|✓|✓|✓|
|memcached|✓|✓|✓|✓|✓|✓|✓|✓|
|mongo|✓|✓|||||||
|mongodb|✓|✓|✓|✓|✓|✓|✓|✓|
|mosquitto|✓|✓|✓|✓|✓|✓|✓||
|msgpack|✓|✓|✓|✓|✓|✓|✓|✓|
|mssql|✓|✓|||||||
|mysql|✓|✓|||||||
|mysqli|✓|✓|✓|✓|✓|✓|✓|✓|
|oauth|✓|✓|✓|✓|✓|✓|✓|✓|
|oci8|✓|✓|✓|✓|✓|✓|✓|✓|
|odbc|✓|✓|✓|✓|✓|✓|✓|✓|
|opcache|✓|✓|✓|✓|✓|✓|✓|✓|
|opencensus|||✓|✓|✓|✓|✓||
|parallel[\*](#special-requirements-for-parallel)||||✓|✓|✓|✓||
|pcntl|✓|✓|✓|✓|✓|✓|✓|✓|
|pcov|||✓|✓|✓|✓|✓|✓|
|pdo_dblib|✓|✓|✓|✓|✓|✓|✓|✓|
|pdo_firebird|✓|✓|✓|✓|✓|✓|✓|✓|
|pdo_mysql|✓|✓|✓|✓|✓|✓|✓|✓|
|pdo_oci|||✓|✓|✓|✓|✓|✓|
|pdo_odbc|✓|✓|✓|✓|✓|✓|✓|✓|
|pdo_pgsql|✓|✓|✓|✓|✓|✓|✓|✓|
|pdo_sqlsrv[\*](#special-requirements-for-pdo_sqlsrv)|||✓|✓|✓|✓|✓|✓|
|pgsql|✓|✓|✓|✓|✓|✓|✓|✓|
|propro|✓|✓|✓|✓|✓|✓|✓||
|protobuf|✓|✓|✓|✓|✓|✓|✓|✓|
|pspell|✓|✓|✓|✓|✓|✓|✓|✓|
|pthreads[\*](#special-requirements-for-pthreads)|✓|✓|✓||||||
|raphf|✓|✓|✓|✓|✓|✓|✓|✓|
|rdkafka|✓|✓|✓|✓|✓|✓|✓|✓|
|recode|✓|✓|✓|✓|✓|✓|||
|redis|✓|✓|✓|✓|✓|✓|✓|✓|
|seaslog|✓|✓|✓|✓|✓|✓|✓|✓|
|shmop|✓|✓|✓|✓|✓|✓|✓|✓|
|smbclient|✓|✓|✓|✓|✓|✓|✓|✓|
|snmp|✓|✓|✓|✓|✓|✓|✓|✓|
|snuffleupagus|||✓|✓|✓|✓|✓|✓|
|soap|✓|✓|✓|✓|✓|✓|✓|✓|
|sockets|✓|✓|✓|✓|✓|✓|✓|✓|
|solr|✓|✓|✓|✓|✓|✓|✓|✓|
|sqlsrv[\*](#special-requirements-for-sqlsrv)|||✓|✓|✓|✓|✓|✓|
|ssh2|✓|✓|✓|✓|✓|✓|✓|✓|
|swoole|✓|✓|✓|✓|✓|✓|✓|✓|
|sybase_ct|✓|✓|||||||
|sysvmsg|✓|✓|✓|✓|✓|✓|✓|✓|
|sysvsem|✓|✓|✓|✓|✓|✓|✓|✓|
|sysvshm|✓|✓|✓|✓|✓|✓|✓|✓|
|tensor|||||✓|✓|✓|✓|
|tidy|✓|✓|✓|✓|✓|✓|✓|✓|
|timezonedb|✓|✓|✓|✓|✓|✓|✓|✓|
|uopz|✓|✓|✓|✓|✓|✓|✓||
|uuid|✓|✓|✓|✓|✓|✓|✓|✓|
|vips[\*](#special-requirements-for-vips)|||✓|✓|✓|✓|✓|✓|
|wddx|✓|✓|✓|✓|✓|✓|||
|xdebug|✓|✓|✓|✓|✓|✓|✓|✓|
|xhprof|✓|✓|✓|✓|✓|✓|✓|✓|
|xlswriter|||✓|✓|✓|✓|✓|✓|
|xmlrpc|✓|✓|✓|✓|✓|✓|✓|✓|
|xsl|✓|✓|✓|✓|✓|✓|✓|✓|
|yaml|✓|✓|✓|✓|✓|✓|✓|✓|
|yar|✓|✓|✓|✓|✓|✓|✓|✓|
|zip|✓|✓|✓|✓|✓|✓|✓|✓|
|zookeeper|✓|✓|✓|✓|✓|✓|✓||
|zstd|✓|✓|✓|✓|✓|✓|✓|✓|

此扩展来自<https://github.com/mlocati/docker-php-extension-installer>
参考示例文件

### 3.4 Host中使用php命令行（php-cli）

1. 参考[bash.alias.sample](bash.alias.sample)示例文件，将对应 php cli 函数拷贝到主机的 `~/.bashrc`文件。

2. 让文件起效：

   ```bash
   source ~/.bashrc
   ```

3. 然后就可以在主机中执行php命令了：

   ```bash
   ~ php -v
   PHP 7.2.13 (cli) (built: Dec 21 2018 02:22:47) ( NTS )
   Copyright (c) 1997-2018 The PHP Group
   Zend Engine v3.2.0, Copyright (c) 1998-2018 Zend Technologies
       with Zend OPcache v7.2.13, Copyright (c) 1999-2018, by Zend Technologies
       with Xdebug v2.6.1, Copyright (c) 2002-2018, by Derick Rethans
   ```

   ### 3.5 使用composer

   **方法1：主机中使用composer命令**

4. 确定composer缓存的路径。比如，我的dnmp下载在 `~/dnmp`目录，那composer的缓存路径就是 `~/dnmp/data/composer`。

5. 参考[bash.alias.sample](bash.alias.sample)示例文件，将对应 php composer 函数拷贝到主机的 `~/.bashrc`文件。

   > 这里需要注意的是，示例文件中的 `~/dnmp/data/composer`目录需是第一步确定的目录。

6. 让文件起效：

   ```bash
   source ~/.bashrc
   ```

7. 在主机的任何目录下就能用composer了：

   ```bash
   cd ~/dnmp/www/
   composer create-project yeszao/fastphp project --no-dev
   ```

8. （可选）第一次使用 composer 会在 `~/dnmp/data/composer` 目录下生成一个**config.json**文件，可以在这个文件中指定国内仓库，例如：

   ```json
   {
       "config": {},
       "repositories": {
           "packagist": {
               "type": "composer",
               "url": "https://packagist.laravel-china.org"
           }
       }
   }
   ```

   **方法二：容器内使用composer命令**

还有另外一种方式，就是进入容器，再执行 `composer`命令，以PHP7容器为例：

```bash
docker exec -it php /bin/sh
cd /www/localhost
composer update
```

## 4.管理命令

### 4.1 服务器启动和构建命令

如需管理服务，请在命令后面加上服务器名称，例如：

```bash
$ docker-compose up                         # 创建并且启动所有容器
$ docker-compose up -d                      # 创建并且后台运行方式启动所有容器
$ docker-compose up nginx php mysql         # 创建并且启动nginx、php、mysql的多个容器
$ docker-compose up -d nginx php  mysql     # 创建并且已后台运行的方式启动nginx、php、mysql容器


$ docker-compose start php                  # 启动服务
$ docker-compose stop php                   # 停止服务
$ docker-compose restart php                # 重启服务
$ docker-compose build php                  # 构建或者重新构建服务

$ docker-compose rm php                     # 删除并且停止php容器
$ docker-compose down                       # 停止并删除容器，网络，图像和挂载卷
```

### 4.2 添加快捷命令

在开发的时候，我们可能经常使用 `docker exec -it`进入到容器中，把常用的做成命令别名是个省事的方法。

首先，在主机中查看可用的容器：

```bash
$ docker ps           # 查看所有运行中的容器
$ docker ps -a        # 所有容器
```

输出的 `NAMES`那一列就是容器的名称，如果使用默认配置，那么名称就是 `nginx`、`php`、`php56`、`mysql`等。

然后，打开 `~/.bashrc`或者 `~/.zshrc`文件，加上：

```bash
alias dnginx='docker exec -it nginx /bin/sh'
alias dphp='docker exec -it php /bin/sh'
alias dphp56='docker exec -it php56 /bin/sh'
alias dphp54='docker exec -it php54 /bin/sh'
alias dmysql='docker exec -it mysql /bin/bash'
alias dredis='docker exec -it redis /bin/sh'
```

下次进入容器就非常快捷了，如进入php容器：

```bash
$ dphp
```

### 4.3 查看docker网络

```sh
ifconfig docker0
```

用于填写 `extra_hosts`容器访问宿主机的 `hosts`地址

## 5.使用Log

Log文件生成的位置依赖于conf下各log配置的值。

### 5.1 Nginx日志

Nginx日志是我们用得最多的日志，所以我们单独放在根目录 `log`下。

`log`会目录映射Nginx容器的 `/var/log/nginx`目录，所以在Nginx配置文件中，需要输出log的位置，我们需要配置到 `/var/log/nginx`目录，如：

```
error_log  /var/log/nginx/nginx.localhost.error.log  warn;
```

### 5.2 PHP-FPM日志

大部分情况下，PHP-FPM的日志都会输出到Nginx的日志中，所以不需要额外配置。

另外，建议直接在PHP中打开错误日志：

```php
error_reporting(E_ALL);
ini_set('error_reporting', 'on');
ini_set('display_errors', 'on');
```

如果确实需要，可按一下步骤开启（在容器中）。

1. 进入容器，创建日志文件并修改权限：

   ```bash
   $ docker exec -it php /bin/sh
   $ mkdir /var/log/php
   $ cd /var/log/php
   $ touch php-fpm.error.log
   $ chmod a+w php-fpm.error.log
   ```

2. 主机上打开并修改PHP-FPM的配置文件 `conf/php-fpm.conf`，找到如下一行，删除注释，并改值为：

   ```
   php_admin_value[error_log] = /var/log/php/php-fpm.error.log
   ```

3. 重启PHP-FPM容器。

### 5.3 MySQL日志

因为MySQL容器中的MySQL使用的是 `mysql`用户启动，它无法自行在 `/var/log`下的增加日志文件。所以，我们把MySQL的日志放在与data一样的目录，即项目的 `mysql`目录下，对应容器中的 `/var/lib/mysql/`目录。

```bash
slow-query-log-file     = /var/lib/mysql/mysql.slow.log
log-error               = /var/lib/mysql/mysql.error.log
```

以上是mysql.conf中的日志文件的配置。

## 6.数据库管理

本项目默认在 `docker-compose.yml`中不开启了用于MySQL在线管理的*phpMyAdmin*，以及用于redis在线管理的*phpRedisAdmin*，可以根据需要修改或删除。

### 6.1 phpMyAdmin

phpMyAdmin容器映射到主机的端口地址是：`8080`，所以主机上访问phpMyAdmin的地址是：

```
http://localhost:8080
```

MySQL连接信息：

- host：(本项目的MySQL容器网络)

- port：`3306`

- username：（手动在phpmyadmin界面输入）

- password：（手动在phpmyadmin界面输入）

### 6.2 phpRedisAdmin

phpRedisAdmin容器映射到主机的端口地址是：`8081`，所以主机上访问phpMyAdmin的地址是：

```
http://localhost:8081
```

Redis连接信息如下：

- host: (本项目的Redis容器网络)

- port: `6379`

## 7.在正式环境中安全使用

要在正式环境中使用，请：

1. 在php.ini中关闭XDebug调试

2. 增强MySQL数据库访问的安全策略

3. 增强redis访问的安全策略

## 8 常见问题

### 8.1 如何在PHP代码中使用curl？

参考这个issue：<https://github.com/yeszao/dnmp/issues/91>

### 8.2 Docker使用cron定时任务

[Docker使用cron定时任务](https://www.awaimai.com/2615.html)

### 8.3 Docker容器时间

容器时间在.env文件中配置 `TZ`变量，所有支持的时区请看[时区列表·维基百科](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)或者[PHP所支持的时区列表·PHP官网](https://www.php.net/manual/zh/timezones.php)。

### 8.4 如何连接MySQL和Redis服务器

这要分两种情况，

第一种情况，在**PHP代码中**。

```php
// 连接MySQL
$dbh = new PDO('mysql:host=mysql;dbname=mysql', 'root', '123456');

// 连接Redis
$redis = new Redis();
$redis->connect('redis', 6379);
```

因为容器与容器是 `expose`端口联通的，而且在同一个 `networks`下，所以连接的 `host`参数直接用容器名称，`port`参数就是容器内部的端口。更多请参考[《docker-compose ports和expose的区别》](https://www.awaimai.com/2138.html)。

第二种情况，**在主机中**通过**命令行**或者**Navicat**等工具连接。主机要连接mysql和redis的话，要求容器必须经过 `ports`把端口映射到主机了。以 mysql 为例，`docker-compose.yml`文件中有这样的 `ports`配置：`3306:3306`，就是主机的3306和容器的3306端口形成了映射，所以我们可以这样连接：

```bash
$ mysql -h127.0.0.1 -uroot -p123456 -P3306
$ redis-cli -h127.0.0.1
```

这里 `host`参数不能用localhost是因为它默认是通过sock文件与mysql通信，而容器与主机文件系统已经隔离，所以需要通过TCP方式连接，所以需要指定IP。

### 8.5 容器内的php如何连接宿主机MySQL

1\.宿主机执行 `ifconfig docker0`得到 `inet`就是要连接的 `ip`地址

```sh
$ ifconfig docker0
docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
        ...
```

2\.运行宿主机Mysql命令行

```mysql
 mysql>GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
 mysql>flush privileges;
// 其中各字符的含义：
// *.* 对任意数据库任意表有效
// "root" "123456" 是数据库用户名和密码
// '%' 允许访问数据库的IP地址，%意思是任意IP，也可以指定IP
// flush privileges 刷新权限信息
```

3\.接着直接php容器使用 `172.0.17.1:3306`连接即可

## License

MIT