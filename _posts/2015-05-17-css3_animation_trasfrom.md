---
title: "CSS3(animation, trasfrom)总结"
layout: post
category: [program]
tags: [CSS]
excerpt: "CSS3(animation, trasfrom)总结"
---

# Animation

## 样式写法:

格式: @-浏览器内核-keyframes 样式名 {}

 

### 标准写法(chrome safari不支持

```
@keyframes  [样式名] {

0% {left: 10px ; top : 20px;}

50% {left: 20px ; top : 30px;}

100% {left: 10px ; top : 20px;}

};
```

       

### Firefox

```
@-mz-keyframes  [样式名] {

0% {left: 10px ; top : 20px;}

50% {left: 20px ; top : 30px;}

100% {left: 10px ; top : 20px;}

};
```
 

### Chrome & Safari

```
@-webkit-keyframes  [样式名] {

0% {left: 10px ; top : 20px;}

50% {left: 20px ; top : 30px;}

100% {left: 10px ; top : 20px;}

};
```
 

### Opern
```
@-o-keyframes  [样式名] {

0% {left: 10px ; top : 20px;}

50% {left: 20px ; top : 30px;}

100% {left: 10px ; top : 20px;}

};
```
 

### 其他写法 
```
@keyframes [样式名] {

from {left:0px; top:10px;}

to   {left:20px; top: 50px;}

}
```
 
 
## 样式引用:

        Style=”animation:样式名 时间 播放曲线”

eg:
	
    样式
    	```
        @-webkit-keyframes testRule {

            20%  {left:100px; top:50px;}

            40%  {left:50px; top: 100;}

            60%  {left:50px; top: 50;}

            80%  {left:100px; top: 0;}

            100% {left:0px; top:0px;}
		}
		``` 

    元素
    	```
        <div style=”position:absolute;width:100px; height:100px; -webkit-animation: testRule 5s linear”> </div>
        ```
	说明 
		```
	    0s- 1s  DIV从最开始位置 到 {left:100px; top:50px;}

	    1s -2s  {left:100px; top:50px;} 到 {left:50px; top: 100;}

	    2s -3s  {left:50px; top: 100;} 到 {left:50px; top: 50;}

	    3s - 4s  {left:50px; top: 50;} 到 {left:100px; top: 0;}

	    4s - 5s  {left:100px; top: 0;} 到 {left:0px; top:0px;}
		```
 

## CSS3 Animation 所具有的属性:
|name      |功能        |
|----------|------------|
|@keyframes|所有规定动画|
|Aniamtion |所有规定动画简写属性, 除了animation-play-state 属性|
|Animation-name| 规定@keyframes 动画的名称|
|Animation-duration| 规定动画完成一个周期所花费的秒或毫秒. 默认是 0 |
|Animation-timing-function|规定动画的速度曲线.默认是 0 |
|Aniamtion-delay|  规定动画从什么时候开始  默认是0|
|Aniamtion-iteration-count|  规定动画播放几遍 默认是1|
|Animation-direction| 规定动画是否在下一周期逆向地播放. 默认是 ” normal”|
|Animation-play-state|规定动画的当前状态 “paused” or “running” .默认是 ”running”|
|Animation-fill-mode|规定对象动画时间之外的状态|

 

ps:Animation-play-state : 当在移动端使用时, 如果样式中存在trasfrom 则会不起作用(原因未知)
 

__属性对应__

|CSS3属性      | dom对象属性          |             
|----------|--------------------|
|Aniamtion | Dom.style.webkitAnimation(根据浏览器内核而定)|
|		   | Dom.style.animation|
|Animation-name | Dom.style.webkitAnimationName|
|Animation-duration|Dom.style.webkitAnimationDuration|
|Animation-timing-function|Dom.style.webkitAnimationTimingFunction|
|Aniamtion-delay|Dom.style.webkitAnimationDelay|
|Aniamtion-iteration-count|Dom.style.webkitAnimationIterationCount|
|Animation-direction|Dom.style.webkitAnimationDirection|
|Animation-play-state|Dom.style.webkitAnimationPlayState|
|Animation-fill-mode|Dom.style.webkitAnimationFillMode|


### 样式动态生成动态引入styleSheets

chorome中:

```
document.styleSheets  //获取所有的样式链表文件内容
var sst = document.styleSheets[0]; //获取第0个样式链表
var str = “@keyframes name {0% {left:20px; } 100%{left:60px;}}”;
sst.insertRule(str)；//将样式str 插入到 第0 个位置的样式文件中
sst.cssRules[0];//获取第0 个样式文件中第0个样式对象
```
 

__控制Animation播放时间__

```
Dom.style.webkitAnimationDelay = “-” + time + "s";

dom.display = "none";

dom.offsetHeight = "";

dom.display = "block";
```
 

# transform

<http://www.w3school.com.cn/cssref/pr_transform.asp>

