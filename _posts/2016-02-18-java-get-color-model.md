---
title: "java 获取图片属性"
layout: post
category: [program]
tags: [java]
excerpt: "在使用AE渲染视频时，由于AE不支持某种颜色模式导致不能导入使用这个颜色模式的图片(时间有点久了忘了是那种颜色模式了-_-|||)，所以需要获取到图片使用的颜色模式，并将图片进行转码"
---

#前言

在使用AE渲染视频时，由于AE不支持某种颜色模式导致不能导入使用这个颜色模式的图片(时间有点久了忘了是那种颜色模式了-_-|||)，所以需要获取到图片使用的颜色模式，并将图片进行转码

#代码

```java
BufferdImage bfi = ImageIO.read( new File("d:/file/img.jpg") );

//获取图片位深度
Int imgBit = bfi.getColorModel().getPixelSize();

//获取图片颜色模式 RGB CMYK等模式
bfi.getColorModel().getColorSpace().getType();
```
 
[__详情请点击>>>__](http://kickjava.com/src/imageinfo/ImageInfo.java.htm)