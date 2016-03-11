---
title: "AE 使用"
layout: post
category: [tool]
tags: [AE]
excerpt: "AE全称After Effects，是由世界著名的图形设计、出版和成像软件设计公司Adobe Systems Inc.开发的专业非线性特效合成软件。是一个灵活的基于层的2D和3D后期合成软件，包含了上百种特效及预置动画效果，与同为Adobe公司出品的Premiere，Photoshop，Illustrator等软件可以无缝结合，创建无与伦比的效果"
---

# AE 介绍

AE全称After Effects，是由世界著名的图形设计、出版和成像软件设计公司Adobe Systems Inc.开发的专业非线性特效合成软件。是一个灵活的基于层的2D和3D后期合成软件，包含了上百种特效及预置动画效果，与同为Adobe公司出品的Premiere，Photoshop，Illustrator等软件可以无缝结合，创建无与伦比的效果

# AE简单使用

## 第一步: 创建project
 AE默认自动会创建一个 未命名的project
 手动创建: 点击 File -> New -> New Project(快捷键: Ctrl + Alt + N)
 
## 第二步: 创建Composition(合成)
 影片的所有的素材(视频, 图片, 文字...)都放在Composition中, 相当于一个容器
 点击 菜单栏上的 Composition -> New Composition... (快捷键 Ctrl + N)
 
 出现如图窗口:

 ![Alt text](http://7xr0d3.com1.z0.glb.clouddn.com/blog-post-img/ae-introduce/comp-setting.jpeg "Optional title")

 Composition Name代表合成的名字 : 自己顺便填
 Preset 代表视频格式
 
## 第三步添加素材
  
  在空白处单击右键 import -> file 选择你需要导入的图片或者视频等素材

  ![添加素材](http://7xr0d3.com1.z0.glb.clouddn.com/blog-post-img/ae-introduce/project-view.jpeg "添加素材")
 
## 第四步将素材添加到Composition(合成)中
 方法1:将素材直接拖拽到Composition中
 Eg: 如上图 将fodder文件中的素材直接拖拽到test上 即可添加成功
 方法很多不列举了...
 
## 第五步制作特效
  略
## 第六步导出影片
  
 ![时间线](http://7xr0d3.com1.z0.glb.clouddn.com/blog-post-img/ae-introduce/timeline-panel.jpeg "timeline")

 当素材添加到Composition成功后会出现如上图
 单击左键空白部分 这个区域会显示黄色的线框
 此时单击 File -> Export -> Add to Render Queue
 在Render Queue窗口会有一个对应的render 
 
 ![render queue]( http://7xr0d3.com1.z0.glb.clouddn.com/blog-post-img/ae-introduce/render-queue.jpeg "render queue")

 单击lossless可以修改 影片格式等参数
 单击output to 后的黄色文字可以就改保存路径和文件名
 点击 右边的Render即可渲染导出影片
 
 ![rending](http://7xr0d3.com1.z0.glb.clouddn.com/blog-post-img/ae-introduce/rending.jpeg "rending")