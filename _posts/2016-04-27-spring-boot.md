---
title: "spring boot使用"
layout: post
category: [program]
tags: [java]
excerpt: "spring团队为了方便使用spring，开发出了springBoot将spring的配置都简单化了"
---

## 前言

spring团队为了方便使用spring，开发出了springBoot将spring的配置都简单化了。SpringBoot也是在微服务架构中使用比较频繁的一个框架。


## 介绍

SpringBoot把创建一个独立的网站变得更加的简单。启动一个SpringBoot的应用你只需要简单的run一下就可以。基本上SpringBoot的应用只需要很少的配置就可以。

你可以使用SpringBoot去创建一个java应用，可以通过命令`java -jar`或者启动'war'包，而且他们提供了'spring scripts'可以更方便的启动应用。

__SpringBoot 目标__

* 为所有Spring开发一种完全更快普及入门体验。
* 自以为是开箱即用，但得到的出路尽快开始要求从默认发散。
* 提供一系列的非功能性特征是常见的大课的项目（例如嵌入式服务器，安全，指标，健康检查，外部配置）。
* 绝对没有生成代码,没有要求配置XML。

__系统要求__

* 默认使用SpringBoot 1.3.5.release
* Java 7
* Spring Frameework 4.2.6RELEASE 以上


当然SpringBoot内嵌了许多应用服务器

|   Name |  Servlet version  |   Java Version |
|--------|-------------------|----------------|
| Tomcat8|      3.1          |   Java 7+      |
| Tomcat7|      3.0          |   Java 6+      |
| jetty9 |      3.1          |   Java 7+      |
| jetty8 |      3.0          |   Java 6+      |
|Undertow1.1  |      3.0     |   Java 6+      |

