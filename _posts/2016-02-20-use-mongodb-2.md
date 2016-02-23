---
title: "MongoDB笔记2-使用MongoDB"
layout: post
category: [database]
tags: [MongoDB]
excerpt: "如何使用MongoDB去存储数据，对数据进行增删改查等操作。"
---

#使用[MongoDB]

[MongoDB]存储和操作的数据是以类似[JSON]的格式数据，使用[MongoDB]的命令有点类似在页面`console`中写`js`的感觉。
##创建一个数据库
__使用如下命令进行数据库创建__

```
> use mongotestDB
switched to db mongotestDB
```
* use：切换到某个数据库，如果这个数据库不存在则会创建一个数据库对象。这个时候使用`show dbs`是查询不到这个数据库的，只有在`insert`一条数据后才能查到。从这里可以看出`show dbs`命令是从磁盘上去查询的

##插入数据
使用以下命令及可插入一条数据

```
> db.mycollection.insert({x:10})
WriteResult({ "nInserted" : 1 })
```

* db 代表你当前使用的数据库
* mycollection 代表你的数据要插入到哪个集合，如果这个集合不存在或者说没有使用过则会创建一个新的集合并将数据插入到这个集合中。

如果你的集合名需要空格或者一些符号，但是使用的`Mongo shell`又不支持的话可以使用以下方式

```
> db["collection-test"].insert({x:20})
WriteResult({ "nInserted" : 1 })
> db.getCollection("collection-test").insert({x:20})
WriteResult({ "nInserted" : 1 })
```

当然如果觉得数据写的太长也可以这么插入

```
> var doc = {xx:1,ary:["a","b","c"]}
> db.mycollection.insert(doc)
WriteResult({ "nInserted" : 1 })
```

__批量插入__

```
> var doc = [{x:1},{x:2},{x:3},{x:4}]
> db.mycollection.insert(doc)
WriteResult({ 
	"writeErrors" : [],
	"writeConernErroes":[],
	"nInserted" : 4,
	"nUpserted" : 0,
	"nMatched":0,
	"nModified":0,
	"nRemoved":0,
	"upserted":[]
})
```
如果需要批量的插入，首先声明一个数组，这个数组里存放需要插入的数据。如上面所示插入4条数据

##查询数据

[MongoDB]使用`find`函数（我不知道应该说命令还是函数-_-|||）去查询，还有一个是`findOne`函数。

__查询`mycollection`中所有的数据__

```
> db.mycollection.find({})
{"_id":Object(56c870d24d49c30492efa870), "x":1}
```
__条件查询__

```
> db.mycollection.find({x:{$gt:0}})
> db.mycollection.find({x:{$lt:0}})
```

* 大于`(greater than)`使用`$gt`，上面命令第一条命令表示：查询`x`大于0的所有数据
* 小于`(less than)`使用`$lt`，第二条表示：查询`x`小于0的所有数据

__查询显示指定字段__


```
> db.mycollection.find({x:{$gt:0}}, {x:1})
```
* 查询`x`大于0的所有数据，只列出`x`字段

```
> db.mycollection.find({x:{$gt:0}}, {x:0})
```
* 查询`x`大于0的所有数据，不显示x字段

__某个条件内查询__

```
> db.testCollection.find({x:{$in:[10,11]}})
```
* 查询testCollection中`x`在属于10或11中的所有数据
__条件或查询__

```
> db.testCollection.find({$or:[{x:{$gt:12}},{t:3}]})
```
* 查询testCollection中`x`大于12或者`t`小于3的所有数据

__查询嵌入文档__

先插入一个文档doc

```
> db.testCollection.insert({doc:{y:1,t:2,c:3}})
> db.testCollection.insert({doc:{y:2,t:3,c:4}})
> db.testCollection.insert({doc:{y:3,t:4,c:5}})
> db.testCollection.insert({doc:{y:4,t:5,c:6}})
> db.testCollection.insert({doc:{y:5,t:6,c:7}})
> db.testCollection.insert({doc:{y:6,t:7,c:8}})
```
查询`doc={y:1,t:2,c:3}`

```
> db.testCollection.find({doc:{y:6,t:7,c:8}})
```
查询所有`doc`中`y = 6`的数据

```
> db.testCollection.find({"doc.y":6}})
```
查询所有`doc`中`y > 3`的数据

```
> db.testCollection.find({"doc.y":{$gt:3}})
```

__查询数组__<br>

先插入一些数组

```
> db.testCollection.insert({ary:[1,2,3,4,5,6,7]})
> db.testCollection.insert({ary:[3,5,6,7,5,6,3]})
> db.testCollection.insert({ary:[5,5,1,7,5,4,3]})
> db.testCollection.insert({ary:[4,5,6,6,7,6,3]})
> db.testCollection.insert({ary:[2,5,4,7,5,7,3]})
```

查询`ary=[1,2,3,4,5,6,7]`的所有数据

```
> db.testCollection.find({ary:[1,2,3,4,5,6,7]})
```
查询数据第`0`个数等于`2`的数据

```
> db.testCollection.find({"ary.0":2})
```
查询数组中某个元素满足条件

```
> db.testCollection.find({ary:{$elemMatch:{$gt:2, $lt:5}}})
```
* 查询条件`ary`中存在元素满足大于`2`小于`5`的所有数组

[MongoDB]支持查询优化，[详情点击>>>]

##修改数据
[MongoDB]提供`update`函数，`$set`操作符来执行更新操作

```
> db.testCollection.update({x:1},{$set:{x:100}, $currentDate: { lastModified: true }})
```
* 将满足`x`为1的数据`x`值改为100，并通过`$currentDate`添加时间字段lastModified

默认情况下使用`update`函数只更新一条数据，如果需要更新多条数据使用操作字段`multi`

```
> db.testCollection.update({x:1},{$set:{x:100}, $currentDate: { lastModified: true }}, { multi: true })
```
直接替换

```
> db.testCollection.update({x:1},{x:111, y:100 })
```
* 满足`x=1`条件的第一条数据将会被替换成{x:111, y:100}

> 如果加上`upsert`字段并设值为`true`将会修改多条满足条件的数据，如果不存在此条件的数据将会添加一条数据

##删除数据

[MongoDB]使用`remove`函数进行删除操作

__删除集合中所有的数据__

```
> db.testCollection.remove({})
```

__删除满足条件的数据__

```
> db.testCollection.remove({x:1})
```

__删除单个数据，设置参数`1`或者`true`__

```
> db.testCollection.remove({x:1}, 1)
```
[官网]:https://www.mongodb.org
[MongoDB]:https://www.mongodb.org
[下载]:https://www.mongo|||db.org|/||dow||nloads?_ga=1.146306676.1535760226.1455459089#production
[JSON]:https://en.wikipedia.org/wiki/JSON
[详情点击>>>]:https://docs.mongodb.org/manual/core/query-optimization/