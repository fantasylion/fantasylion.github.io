---
title: "使用canvas制作视频图片特效"
layout: post
category: [programme]
tags: [JavaScript]
excerpt: "Canvas是html5上的一个画布标签,功能有点类似java的swing.可以在canvas上画线条 弧线, 文字 就是画布的功能.
具体提供的js函数看<a href="http://www.w3school.com.cn/tags/html_ref_canvas.asp">http://www.w3school.com.cn/tags/html_ref_canvas.asp</a>"
---
Canvas制作视频图片特效

#Canvas介绍

Canvas是html5上的一个画布标签,功能有点类似java的swing.可以在canvas上画线条 弧线, 文字 就是画布的功能.

具体提供的js函数看<a href="http://www.w3school.com.cn/tags/html_ref_canvas.asp">http://www.w3school.com.cn/tags/html_ref_canvas.asp</a>

 

#简单介绍一下使用:

Var canvas = document.documentElementById(“canvasId”);

Var ctx = canvas.getContext(“2d”);//获取维数对象

ctx.drawImage(img);//img为dom图片对象, 还有其他可选参数 剪切坐标  和 放置到canvas上的坐标

 

#给图片添加特效

原理: 图片通过drawImage函数 绘制到 canvas 上之后, 用getImageData函数可以获得

图片的imageData对象, imageData里有一个data数组存放的是 此图片的r g b a (三原色 和透明度). 将取出的data数组修改成对应特效数组, 用putImageData函数 重新数据放回canvas上即可.

小demo 代码(将图片设置成灰白效果 原理: 将r g b 设置成rgb平均数):

```html

<img id=”image1” src=”/img.jpg” />

<canvas id=”can” width=”500” heigth=”300”> </canvas>

<!-- 注意: canvas的宽高只能通过属性设置, 在style中设置没有效果 -->
```
 

```javaScript
Var img = document.documentElementById(“imgage1”);

Var canvas = document.documentElementById(“can”);

Var ctx = canvas.getContext(“2d”);//获取维数对象

ctx.drawImage(img);

Var imgData = ctx.getImageData(0, 0, 500, 300);

For ( var i = 0, len = imgData.data.length, avgRgb; i < len; i += 4) {

avgRgb = (imgData.data[i] + imgData.data[i + 1] + imgData.data[i + 2]) / 3;

imgData.data[i] = avgRgb;

imgData.data[i + 1] = avgRgb;

imgData.data[i + 2 ] = avgRgb;

}

ctx.putImageData(imgData, 0, 0);
```
 

#给视频添加特效

原理: 与图片的原理类似,只是要绘制视频每一帧的画面, 视频每播放一帧,就在canvas上绘制一帧画面

小demo 代码 (将视频画面红色调高 原理: 将r g b 中的r 调高)

```html

<video id=”vid1” src=”/vid1.mp4” autoplay/>

<canvas id=”can” width=”500” heigth=”300”> </canvas>
```
 

```javaScript

Var vid= document.documentElementById(“vid1”);

Var canvas = document.documentElementById(“can”);

Var ctx = canvas.getContext(“2d”);//获取2维对象

function drawVidEffect() {

ctx.drawImage(vid);

Var imgData = ctx.getImageData(0, 0, 500, 300);

For ( var i = 0, len = imgData.data.length, avgRgb; i < len; i += 4) {

imgData.data[i]  +=  50;

}

ctx.putImageData(imgData, 0, 0);

setTimeout( drawVidEffect, 20 );

}
```
 

#注意

如果视频或者图片所在的域名 跟canvas所在域名不一样 或者 不在服务器上运行 会报错:
```javaScript
Uncaught SecurityError: Failed to execute 'getImageData' on 'CanvasRenderingContext2D': The canvas has been tainted by cross-origin data.
```
 

解决办法:将图片或者视频加上属性crossOrigin但是添加后不能更换src地址

详见:

<a href="http://camnpr.com/archives/1117.html">http://camnpr.com/archives/1117.html</a>

<a href="http://camnpr.com/TuiJianTools/html5/canvas-cross-domain-images.html">http://camnpr.com/TuiJianTools/html5/canvas-cross-domain-images.html</a>

 