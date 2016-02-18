---
title: "Jquery 插件开发"
layout: post
category: [programme]
tags: [JavaScript]
excerpt: "jQuery已经被广泛使用，凭借其简洁的API，对DOM强大的操控性，易扩展性越来越受到web开发人员的喜爱。本文简单介绍一下如何开发jQuery的插件"
---

#前言
[jQuery]已经被广泛使用，凭借其简洁的[API]，对DOM强大的操控性，易扩展性越来越受到web开发人员的喜爱，本文简单介绍一下如何开发[jQuery]的插件

#开发插件的方式有两种

##类级别的开发

类级别的插件开发最直接的理解就是给[jQuery]类添加类方法，可以理解为添加静态方法。典型的例子有`$.AJAX(),$.getJSON()`,将函数定义于[jQuery]的命名空间中.

*  直接给[jQuery]添加一个函数.

```
jQuery.pluginTest = function() {

	alert(“this is a plugin test add by class”);

}

调用方式 :  jQuery.pluginTest();
```


*  通过`jQuery.extend()`添加函数

```
jQuery.extend({

	pluginTest:function() {

		alert(“this is a plugin test add by extends”);

	}

});

调用方式 : jQuery.pluginTest();
```


*  以命名空间的方式添加函数

	优点: 避免某些函数或变量名将于其他[jQuery]插件冲突

```
jQuery.pluginTest = {

	test : function() {

		alert(“this is a plugin test add by namespace”);

　　}

}

调用方式 : jQuery.pluginTest.test();
```

##对象级别的开发

* 第一种对象级别开发方式:

```
jQuery.fn.extend({pluginTest : function() {

　　alert(“this is plugin test add by object1”);

}});

调用 : $(“#id”).pluginTest();
```

* 第二种对象级别开发方式:

```
jQuery.fn.pluginTest = function() {

　　　alert(“this is plugin test add by object2”);

}

调用 : $(“#id”).pluginTest();
```

* 保证私有函数的私有性(闭包):

　优点 : 定义更多的函数而不搅乱命名空间也不暴露实现

```
(function($) {

　$.fn.pluginTest = function() {

　　　test();

　}

　function test() {

　　　alert(“this is a closure test”);
　}

})(jQuery);

调用: $(“#id”).pluginTest();
```

* 通过接收参数options 改变默认的值

```
(function($) {

　　$.fn.pluginTest = function(options) {

　　　　var opt = $.extend({width : 20, height : 20, color : ’ red’ }, options);

　　　　this.width(opt.width);

　　　　this.height(opt.height);

　　　　this.css(“color”, opt.color);

　　}

})(jQuery)

调用 : $(“#id”).pluginTest({width:50,  height:50,  color : ‘yellow’});
```

* 通过暴露属性改变默认值

```
(function () {

　　　$.fn.pluginTest = function() {

　　　　　this.width($.fn.pluginTest.defaults.width);

　　　　　this.height($.fn.pluginTest.defaults.height);

　　　　　this.css(“color”, $.fn.pluginTest.defaults.color);

　　　}

　　　$.fn.pluginTest.defaults = {

　　　　　　Width : 20,

　　　　　　height: 20,

　　　　　　Color :‘red’ 

　　　}

})(jQuery)

调用: 

$(“#id”).pluginTest.defaults = {

　　　　width : 50,

　　　　height: 50,

　　　　Color :‘red’

}

$(“#id”).pluginTest();
```
 

 

#开发插件时需要注意的几点

* 推荐使用插件的命名方法`jQuery.[插件名].js||[插件名].js`

* 所有的对象方法都应当附加到`JQuery.fn`对象上面,而所有的全局函数都应当附加到[JQuery]对象本身上

* 在插件内部,`this`指向的是当前通过选择器获取的[JQuery]对象,而不像一般方法那样,内部的`this`指向的是`DOM`元素

* 可以通过`this.each` 来遍历所有的元素 

* 所有方法或函数插件,都应当以分号结尾,否则压缩的时候可能会出现问题.为了更加保险写,可以在插件头部添加一个分号（;）,以免他们的不规范代码给插件带来 影响.

* 插件应该返回一个[jQuery]对象,以便保证插件的可链式操作. 链式操作：`($("#div1").css("color","red").addClass("Add"))`

 

 

#`jQuery.extend()` 和 `jQuery.fn.extend()`区别

##`jQuery.extend()`函数

　　　　``var tar = jQuery.extend(target, src1, src2...);``

　　　　作用:将target,src1,src2中的属性合并添加到target中并返回

　　　　
		``var tar = jQuery.extend({},target,src1,src2...);``

　　　　作用:将target,src1..中的属性合并,target结构不变

　　　　
		``var tar = jQuery.extend(boolean, target, src1, src2);``

　　　　Boolean 表示是否进行深度拷贝(是否复制嵌套对象)

　　　　
		``jQuery.extend(src);``

　　　　作用:将该src合并到调用extend方法的对象中去,这里就是将src合并到jquery的全局对象中去

 

##`JQuery.fn.extend()`函数

使用方法同上

__`jQuery.fn`是什么__


[jQuery] 源码如下\:


```
jQuery.fn = jQuery.prototype = {

　　　　init: function(){//...

	　　　　//...

　　　　}

}
```

从源码中可以看出`jQuery.fn.extend(src)`就是将`src`添加到[jQuery]原型中由其实例对象调用

[jQuery]:http://jquery.com/
[API]:http://api.jquery.com/