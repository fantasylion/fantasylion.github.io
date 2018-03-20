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
* `null` 字符(\u0000)不能被用在路径名上。（这是因为使用 C 编译导致的）
* 以下几个字符不允许使用：\ud800 -uF8FFF, \uFFF0 - uFFFF。
* “.” 字符可以被用在路径名上，但是 “.” 和 “..” 不能用于单独指示一个节点，因为ZooKeeper不能使用相对路径。后面这几个路径被认为是无效的："/a/b/./c" or "/a/b/../c"。
* zookeeper 是系统保留字符，不允许被使用。

## ZooKeeper 会话

## ZooKeeper 观察者（订阅者）

## ZooKeeper 权限控制 (ACL)

## 插件式的Keeper认证

## 一致性保证

## 绑定

## 构建模块：ZooKeeper操作指南

## 程序结构（简单案例）

## 陷阱：常见问题和故障排除
