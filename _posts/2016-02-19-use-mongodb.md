---
title: "MongoDB笔记1-安装运行MongoDB"
layout: post
category: [database]
tags: [MongoDB]
excerpt: "前段时间在上家公司做的产品后台用的就是Mongodb，由于当时这块根本接触不到，也一直没有时间去学习。趁现在在家呆着没事学习一下Mongodb。"
---
# 前言

前段时间在上家公司做的产品后台用的就是[MongoDB]，由于当时这块根本接触不到，也一直没有时间去学习。趁现在在家呆着没事学习一下[MongoDB]。

# 介绍

[MongoDB]是一个基于分布式文件存储的开源数据库系统，在高负载的情况下，添加更多的节点，可以保证服务器性能。
[MongoDB] 将数据存储为一个文档，数据结构由键值`(key=>value)`对组成。[MongoDB] 文档类似于 [JSON] 对象。字段值可以包含其他文档，数组及文档数组。


# 正文

## 安装[MongoDB]

	
在安装[MongoDB]之前先要到__[官网]__上__[下载]__安装包

![官网](http://7xr0d3.com1.z0.glb.clouddn.com/blog-post-img/mondb1/install.png)

进去官网后选择自己的系统对应的版本下载，我这里用的是`win7 64bit` 所以选择 `Windows 64-bit 2008 R2+`, `Legacy`的版本是被放弃的版本不建议使用。

__MongoDB对各系统平台的支持__

|Platform	|3.2|3.0|2.6|2.4|2.2|
|-----------|---|---|---|---|---|
|Amazon Linux|	✓|	✓|	✓|	✓|	✓|
|Debian 7    |	✓|	✓|	✓|	✓|	✓|
|Fedora 8+   |	 |	 |	✓|	✓|	✓|
|RHEL/CentOS 6.2+|	✓|	✓|	✓|	✓|	✓|
|RHEL/CentOS 7.0+|	✓|	✓|	✓|   |	 | 	 
|SLES 11|	✓|	✓|	✓|	✓|	✓|
|SLES 12|	✓|   |   |   |   |	 	 	 	 
|Solaris 64-bit|	✓|	✓|	✓|	✓|	✓|
|Ubuntu 12.04|	✓|	✓|	✓|	✓|	✓|
|Ubuntu 14.04|	✓|	✓|	✓|   |   |	 	 
|Microsoft Azure|	✓|	✓|	✓|	✓|	✓|
|Windows Vista/Server 2008R2/2012+|	✓|	✓|	✓|	✓|	✓|
|OSX 10.7+|	✓|	✓|	✓|	✓|	 |

__32位的[MongoDB]存在以下几个限制__

* 不支持`WiredTiger` 存储引擎
* 默认日志是禁止的，因为日志会限制[MongoDB]可以存储的最大数据量
* 当运行的[MongoDB]，服务器的总存储大小，包括数据和索引，是2G字节。所以不要生产环境下使用在32位的[MongoDB]。


在下载完成后，`windows`版本直接下一步安装就可以了

安装完成之后[MongoDB]的目录是这样的

![目录](http://7xr0d3.com1.z0.glb.clouddn.com/blog-post-img/mondb1/floder.png)

## 运行[MongoDB]

__安装完成接下来要把[MongoDB]跑起来__

在运行[MongoDB]之前先介绍一些刚安装[MongoDB]目录的`lib`目录下存放的文件作用

![lib](http://7xr0d3.com1.z0.glb.clouddn.com/blog-post-img/mondb1/lib-floder.png)

__各可执行文件对应的作用__

|Component Set|	Binaries|
|-------------|---------|
|Server|	mongod.exe|
|Router|	mongos.exe|
|Client|	mongo.exe|
|MonitoringTools|	mongostat.exe, mongotop.exe|
|ImportExportTools|	mongodump.exe, mongorestore.exe, mongoexport.exe, mongoimport.exe|
|MiscellaneousTools|	bsondump.exe, mongofiles.exe, mongooplog.exe, mongoperf.exe|

首先得把[MongoDB]的`Server`端跑起来

在dos下敲下面的命令

```
//dbpath参数后面的跟的是数据库的路径，MongoDB默认有一个test库，参数可不加则直接使用默认的数据库
mongod.exe --dbpath D:\Tools\Mongodb\test\data
```

&nbsp;&nbsp;&nbsp;&nbsp;这个时候`Server`端就会开启一个默认的端口`27017`，当然这个端口是可以通过参数更换的（加`-h` 就可以了解更多的参数）。
[MongoDB]在启动的时候需要知道数据库存储在哪个位置或者说将数据存储到哪，所以在启动的时候传入一个参数`--dbpath`告诉将要启动的[MongoDB]进程，数据库位置如果不指定的话则默认在`/data/db`位置去找，如果没有找到则将不能启动[MongoDB]。
在执行完上面的命令后，会出现`The waiting for connections`字样，说明服务器这个时候就已经开启了在等待一个客户端连接进来。

## 连接数据库

在数据库已经启动的情况下我们接下来就需要通过`client`去访问操作数据库。 
在确保数据库已经启动成功，直接点击`mongo.exe`即可通过默认的端口连接到本地的数据库。如果你需要连接别的数据库，需要通过命令行传入指定参数进行连接。如：

```
mongo --username <user> --password <pass> --host <host> --port 28015

或者

mongo -u <user> -p <pass> --host <host> --port 28015

```
- `user`：填入你在那台机器上的用户名<br>
- `pass`：填入你的用户密码<br>
- `host`：数据库主机地址<br>
- `port`：数据库开启的端口<br>

当执行完命令后（或者直接点击`mongo.exe`）将会出现下方显示内容：

```
2016-02-20T14:05.849+0800 I CONTROL [main] Hotfix KB271284 or later update is not installed, will zero-out data files
MongoDB shell version: 3.2.1
connection to: test
> 

```

下面执行一些简单的命令：

```
2016-02-20T14:05.849+0800 I CONTROL [main] Hotfix KB271284 or later update is not installed, will zero-out data files
MongoDB shell version: 3.2.1
connection to: test
> db
test
> show dbs
local	0.000GB
test	0.004GB

```
 - `db`: 			显示当前使用的是哪个数据库
 - `show dbs`:	 	显示有几个数据库

[官网]:https://www.mongodb.org
[MongoDB]:https://www.mongodb.org
[下载]:https://www.mongo|||db.org|/||dow||nloads?_ga=1.146306676.1535760226.1455459089#production
[JSON]:https://en.wikipedia.org/wiki/JSON