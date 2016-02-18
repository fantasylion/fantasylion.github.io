---
title: "tomat 欢迎页面设置在WEB-INF目录下时不显示问题"
layout: post
category: [program]
tags: [java]
excerpt: "在某次使用tomcat时，设置默认欢迎页面时一直报404，后来查明原因是路径要使用反斜线，本文用于记录此问题方便以后查找"
---

#前言
在某次使用tomcat时，设置默认欢迎页面时一直报404，后来查明原因是路径要使用反斜线，本文用于记录此问题方便以后查找

#正文

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xmlns="http://java.sun.com/xml/ns/javaee"
  xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd"
   id="WebApp_ID" version="3.0">
<display-name>migu</display-name>
<welcome-file-list>
<welcome-file>WEB-INF/view/index.jsp</welcome-file>
<welcome-file>WEB-INF/view/index.jsp</welcome-file>
<welcome-file>WEB-INF/view/index.html</welcome-file>
</welcome-file-list>
</web-app>
```
windows下 配置为以上后，页面显示404

查明原因为：斜线问题导致

改为

```xml
<welcome-file>WEB-INF\view\index.jsp</welcome-file>
```