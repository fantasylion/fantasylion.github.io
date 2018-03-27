---
title: "zookeeper 应用指南中文版"
layout: post
category: [zookeeper]
tags: [zookeeper]
excerpt: "使用ZooKeeper开始分布式应用"
---

[TOC]

# 目录

## 介绍
本文档适合于希望利用ZooKeeper创建协调服务分布式应用程序的开发人员。本文包含了概念和实例。

文档的前四部分对各种ZooKeeper概念进行了深入的讨论。它可以让你更深入的了解ZooKeeper是怎么运行的和怎么去使用它。这里不包含ZooKeeper的源码，但是这里详细描述了分布式计算相关的问题。这四部分分别为：
    
* ZooKeeper 数据模型
* ZooKeeper 会话
* ZooKeeper 观察者（订阅者）
* 一致性保证  
    
以下为后四部分描述了编程设计的信息：
    
* 构建模块：ZooKeeper 操作指南
* 绑定
* 程序结构和一些简单的案例
* 陷阱：常见的问题和故障排除 
    
本文后提供一份附件包含了一些其他关于 ZooKeeper 的信息。
    
本文中大部分信息都是作为独立参考资料编写的。在你开始写第一个ZooKeeper应用之前，你最好先阅读下这两部分文章，`ZooKeeper 数据模型`和 `ZooKeeper 基础操作`。当然`简单示例`对你理解 ZooKeeper 客户端应用也有很大帮助。


## ZooKeeper 数据模型
ZooKeeper 使用分级命名规则，看起来就像一个分布式文件系统。它们唯一的区别是 ZooKeeper 命名空间中的每个节点都可以拥有相关数据和子节点。就像是一个文件系统它允许一个文件可以当做目录来用。节点的路径可以用 canonical、绝对路径、斜线路径表示；这里不可以使用相对路径。任何unicode字符都可以在路径中被使用但是需要遵从一下规则：
* `null` 字符(`\u0000`)不能被用在路径名上。（这是因为使用 C 编译导致的）
* 以下几个字符不允许使用：`\ud800 -uF8FFF`, `\uFFF0 - uFFFF`。
* `“.”` 字符可以被用在路径名上，但是 `“.”` 和 `“..”` 不能用于单独指示一个节点，因为ZooKeeper不能使用相对路径。后面这几个路径被认为是无效的：`"/a/b/./c"` or `"/a/b/../c"`。
* zookeeper 是系统保留字符，不允许被使用。

### ZNodes
ZooKeeper 树中的任何一个节点都依赖于 `ZNode`。`ZNode` 维护一个统计结构，这个结构包含了修改数据和修改ACL的版本号。当然这个统计结构也有一个时间戳。这个版本号和时间戳一起使用可以用来 ZooKeeper 去验证缓存和定位更新。每当有一个znode的数据被修改，这个版本号就会增加一个值。比如：当客户端检索数据的时候它也会收到这个数据的版本号。当一个客户端执行修改和删除的时候，它必须提供一个修改后的节点数据的版本号。如果这个版本号跟实际的数据版本号不匹配，本次的更新将会失败。（这个行为可以被覆盖。详情请看......）

Note |
:--- |
在分布式应用引擎上，节点可以是指一台主机、一个服务、集群中的某个成员、一个客户端进程等等。在 ZooKeeper 文档中，`ZNodes` 指一个数据节点。`Servers` 指启动ZooKeeper服务的服务器；`quorum peers` 指服务集群； 客户端指任何一台主机或者使用 ZooKeeper 服务的进程|

`znode` 是 ZooKeeper 的主要概念程序员需要认真了解。Znodes有几个特性值得在此提及：
#### ZooKeepr 监控
客户端可以在 `znodes` 上设置监控。如果被监控节点有修改，`znode` 将触发监控然后再清除这个监控。当监控被触发后，ZooKeeper 将会发送通知到客户端。更多关于监控可以在 `ZooKeeper 监控` 部分找到。
#### 数据访问
在一个命名空间下每个 `Znode` 数据存储的读写都是原子化的。读取操作将获取到所有这个 `znode` 相关的字节数据，写入操作将会替换所有数据。每个节点都会有一个访问控制列表(ACL)用于限制谁可以做什么。

ZooKeeper 并不是设计用来当做数据库或者大量的数据存储。相反，它管理协调数据。这个数据可以通过一个 form 表单配置、状态信息、集合点等形式出现。各种形式的协调数据的共同特点是它们相对较小：以千字节为单位。ZooKeeper的客户端还有服务实例都要检查并确保每个 Znode 的数据要小于1M，并且每个数据都必须小于平均值。
操作相对较大的数据会比其他数据时间要长，并且由于需要花费额外多的时间在网络传输上和存入存储媒介中会导致操作延时。如果真的需要比较大的数据存储，通常采用大容量的存储系统去处理这些数据，类似 NFS、HDFS ，然后将存储指针指向 ZooKeeper 的存储位置。

#### 临时节点
ZooKeeper 当然也临时节点的概念。这些 Znodes 生命周期同   保持一致，当 session 创建的时候 Znodes 将被激活。当 session 结束 这个 Znode 也同时将被删除。正是由于这个行为临时节点不允许有子节点。

#### 序列节点--唯一命名
在创建一个Znode的时候你也可以要求 ZooKeeper 在路径的后面追加一个递增的计数器。这个计数器相对于 Znode 是唯一的。这个计数器格式为 %010d -- 这是一个10位数，用0占位（计数器用这个格式排序），“举例：<path>000000000001”。点击[Queue Recipe](https://zookeeper.apache.org/doc/r3.4.11/recipes.html#sc_recipes_Queues)查看使用这个功能的例子。注意：用于存储下一个序列号的计数器是由父节点维护的带符号整型（4字节），计数器在增加到2147483647之后会溢出（导致名称为“<path> -2147483647”）。


### ZooKeeper 时间
ZooKeeper 有很多方法去追踪这个时间

* **xid**<br>
ZooKeeper 状态有任何修改都将会收到一个 zxid(ZooKeeper Transaction Id) 的标记。这个暴露了 ZooKeeper 所有的修改排序。每次修改都将会有一个唯一的   zxid，如果 zxid1 小于 zxid2 那么就可以认为 zxid1 是发生在 zxid2 之前。
* **Version numbers**<br>
所有对节点的修改都将造成这个节点的版本号增加。这三个版本数字就是version（znode数据修改的数量），cversion（znode子节点修改的数量），aversion（znode  修改的数量）。
* **Ticks**<br>
当使用多服务的 ZooKeeper，服务将使用 ticks 去定义事件时间，像（上传状态，会话超时，管道连接超时等等）。Tick 只会间接的暴露最小会话时间（两倍的 Tick time）；如果一个客户端的请求超时时间小于这个会话时间，服务器将告知客户端这个超时时间以最小的超时时间为准。
* **Real time**<br>
ZooKeeper 不使用真实的时间或锁定时间，除了将时间戳放到 znode 的创建和修改的统计结构中。

### ZooKeeper 统计结构
ZooKeeper 每个节点的统计结构由以下几个字段组成：
* __czxid__<br>
表示造成这次 znode 创建的时间。
* __mzxid__<br>
znode 最后的修改时间。
* __pzxid__<br>
znode 子节点最后的修改时间。
* __ctime__<br>
znode 创建时间（以毫秒为单位）。
* __mtime__<br>
znode 最后的修改时间（以毫秒为单位）。
* __version__<br>
znode 数据的修改次数。
* __cversion__<br>
znode 子节点的修改次数
* __aversion__<br>
znode 的修改次数
* __ephemeralOwner__<br>
如果是暂时节点，表示这个 znode 的主人的 session id 。如果不是，这个值为0.
* __dataLength__<br>
znode 数据字段的长度。
* __numChildren__<br>
znode 有多少子节点


## ZooKeeper 会话
ZooKeeper 客户端通过语言绑定于服务创建握手来建立与 ZooKeeper 服务的会话。一旦创建，句柄就会以CONNECTING状态开始，并且客户端库尝试连接到组成ZooKeeper服务的服务器之一，此时它将切换到CONNECTED状态。在正常的操作时候将会是这两者状态之一。如果发生一个不可逆转的错误事件，像 session 过期或者认证失败，再或者应用直接关闭了句柄，这个句柄将切换到 closed 状态。下面的图表展示了 ZooKeeper 客户端事物的处理状态：
![结构图](http://fantasylion.github.io/images/state_dia.jpg)<br>
要创建客户端会话，应用程序代码必须提供一个连接字符串，其中包含以逗号分隔的host：port对列表，每个对应于一个ZooKeeper服务器（举例："127.0.0.1:4545" 或者 "127.0.0.1:3000,127.0.0.1:3001,127.0.0.1:3002"）。ZooKeeper 客户端库将随机挑选一台服务器然后尝试去链接它。如果链接失败或者由于某些原因服务端到客户端断开链接，客户端都会自动尝试链接列表中的下一个服务，知道链接重新建立。

**3.2.0 版本添加**<br>
可选后缀 “chroot” 可以追加到连接字符串后面。这会运行客户端命令以相对ROOT路径的形式（类似unix系统的chroot命令）。如果要举例的话看起来就像："127.0.0.1:4545/app/a" 或 "127.0.0.1:3000,127.0.0.1:3001,127.0.0.1:3002/app/a" 这样客户端就会以 "app/a" 为根目录，所有的路径都会相对于这个根目录。比如 "/foo/bar" 返回的结果将是运行 "/app/a/foo/bar" 得到（从服务器的角度来看）。这个功能在多租户环境真的很有用，每个 ZooKeeper 服务的用户可以有不同的根目录。这使得复用变得简单，用户可以将他的应用程序根目录编码成 “/” ，但是实际的位置可以在发布的时候在去决定。

当客户端获取到连接 ZooKeeper 服务的句柄，ZooKeeper 将创建一个以64位的数字表示的 ZooKeeper session，派送到客户端。如果客户端连接到一个不同的 ZooKeeper 服务，它将会发送一个 session id 作为连接握手的一个部分。为了保证安全，服务端会给 session id 创建一个秘密，任何的 ZooKeeper 服务都可以去验证。这个密码将会在客户端建立会话的时候和 session id 一起发送到客户端。客户端随时都可以发送这个密码和 session id 跟一个新的服务重新建立会话。

ZooKeeper 客户端库用来创建 ZooKeeper session超时的参数是用毫秒表示。客户端发送一个超时请求，服务端将响应一个超时给到客户端。现在的实例要求超时至少是两倍 tickTime （这个可以在服务端配置）或者大于20倍的tickTime。ZooKeeper 客户端API允许访问协商超时时间。

如果客户端是 ZooKeeper 服务集群中的分区，它将会开始搜索在 session 创建期间指定的服务器列表。实际上，当客户端和最后一个服务器之间重新建立起连接， session 将会切换到 "connected" 状态（如果重连在超时时间范围内）或者切换到 "expired" 状态（如果重连时间已经超出超时时间）。为断开链接创建一个新的 session 对象这是一个不明智的决定（一个新的 ZooKeeper类 或 zookeeper 对象在 C 绑定中处理 ）。ZooKeeper 客户端库将会帮你自动重新连接。特别是，我们在客户端库中内置了启发式技术，以处理诸如“群效应”等等...... 当你被通知到 session 过期（强制性）的时候，只能创建一个新的 session。

session 过期通过 ZooKeeper 集群自己管理，不是通过客户端。当 ZooKeeper 客户端建立一个集群 session 它将提供一个详细的 timeout 值。这个值是集群用来确定客户端的 session 何时过期。当集群没有收到来自客户端指定的过期时间（比如：没有心跳）将会直接过期。在 session 过期时集群将会删除任何/所有这个  session 所拥有的临时节点并且立刻通知所有连接的客户端这个事情（任何监控这些节点的客户端）。在这个时候会话过期的时间点于集群是一直保持断开状态，session 过期不会被通知到直到它可以重新连接到集群。客户端将会一直保持断开状态一直到重新 TCP 连接到集群，在这个时间点上如果 session 过期，监控者将收到 session 过期的通过。

举一个会话过期监控者看到的会话过期状态转换的例子：

1. 'connected' : session is established and client is communicating with cluster (client/server communication is operating properly)

2. .... client is partitioned from the cluster

3. 'disconnected' : client has lost connectivity with the cluster

4. .... time elapses, after 'timeout' period the cluster expires the session, nothing is seen by client as it is disconnected from cluster

5. .... time elapses, the client regains network level connectivity with the cluster

6. 'expired' : eventually the client reconnects to the cluster, it is then notified of the expiration

ZooKeeper 调用会话建立的另外一个参数是默认的 watchers。当客户端任何一个改变状态的事件发生 watchers 都是收到通知。举个例子：如果客户端丢失了跟服务器端的连接客户端将收到通知，或者如果客户端的 session 过期等等...... 这个 watcher 应该考虑到初始化状态为断开状态。（比如：在客户端库把状态变化的事件发送到 watcher 之前）。在新的连接案例中，第一个发送到 watcher 的事件一般是 session 连接事件。

ZooKeeper 通过客户端发送请求保持 session 不过期。如果让 session 保持一段时间的空闲将使得 session 过期，所以客户端会一直发送一个 ping 请求保证 session 一直存活。这个 ping 请求不仅仅只是让 ZooKeeper 服务知道这个客户端还活着，还可以让客户端验证它连接的 ZooKeeper 服务是否一直活着。这个 ping 请求的时间安排的足够合理保证有充足的时间去检测断开的连接和重新去连接一个新的服务。

Once a connection to the server is successfully established (connected) there are basically two cases where the client lib generates connectionloss (the result code in c binding, exception in Java -- see the API documentation for binding specific details) when either a synchronous or asynchronous operation is performed and one of the following holds:

The application calls an operation on a session that is no longer alive/valid

The ZooKeeper client disconnects from a server when there are pending operations to that server, i.e., there is a pending asynchronous call.

## ZooKeeper 监控
### 监控语义
### 如何保障 ZooKeeper 订阅者
### 关于订阅者的事项


## ZooKeeper 权限控制 (ACL)
### ACL权限
#### ACL内建方案
#### ZooKeeper C 客户端 API


## 插件式的 ZooKeeper 认证


## 一致性保证


## 绑定
### Java 绑定
### C 绑定
#### 安装
#### 构建属于你的 C 客户端


## 构建模块：ZooKeeper 操作指南
### 解决错误
### 连接 ZooKeeper
### 读取操作
### 写入操作
### 处理订阅者
### 混杂 ZooKeeper 操作


## 程序结构（简单案例）


## 陷阱：常见问题和故障排除
