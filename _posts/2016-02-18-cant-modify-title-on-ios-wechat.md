---
title: "ios微信上不能更换标题解决办法"
layout: post
category: [program]
tags: [JavaScript]
excerpt: "用Iphone手机的微信浏览网页的时候，在切换页面时无法更新页面的title。于是从网上找了一个传说中的黑魔法解决此问题。"
---

#背景

用Iphone手机的微信浏览网页的时候，在切换页面时无法更新页面的title。于是从网上找了一个传说中的黑魔法解决此问题。

#使用jQuery

```
var$body = $('body');

document.title = 'title';

// hack在微信等webview中无法修改document.title的情况

var$iframe = $('<iframe src="/favicon.ico"></iframe>');

$iframe.on('load',function(){

    setTimeout(function(){

        $iframe.off('load').remove();

    }, 0);

}).appendTo($body);
```

#原生javaScript

```
var body = document.getElementsByTagName('body')[0];

document.title = "标题被我改了";

var iframe = document.createElement("iframe");

iframe.setAttribute("src", "loading.png");

iframe.addEventListener('load', function(){

setTimeout(function(){

  iframe.removeEventListener('load');

    document.body.removeChild(iframe);

  }, 0);

});

document.body.appendChild(iframe);
```
