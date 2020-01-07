---
title: "Airflow 使用 Celery 时，如何添加 Celery 配置"
layout: post
category: [tool]
tags: [tool]
excerpt: "Airflow 使用 Celery 时，如何添加 Celery 配置"
---
## 背景
前段时间我选用了 `Airflow` 对 `wms` 进行数据归档，在运行一段时间后，经常发现会报以下错误：
```log
[2020-01-07 14:41:34,465: WARNING/ForkPoolWorker-5] Failed operation _store_result.  Retrying 2 more times.
Traceback (most recent call last):
  File "/usr/local/python38/lib/python3.8/site-packages/sqlalchemy/engine/base.py", line 1245, in _execute_context
    self.dialect.do_execute(
  File "/usr/local/python38/lib/python3.8/site-packages/sqlalchemy/engine/default.py", line 581, in do_execute
    cursor.execute(statement, parameters)
  File "/usr/local/python38/lib/python3.8/site-packages/MySQLdb/cursors.py", line 255, in execute
    self.errorhandler(self, exc, value)
  File "/usr/local/python38/lib/python3.8/site-packages/MySQLdb/connections.py", line 50, in defaulterrorhandler
    raise errorvalue
  File "/usr/local/python38/lib/python3.8/site-packages/MySQLdb/cursors.py", line 252, in execute
    res = self._query(query)
  File "/usr/local/python38/lib/python3.8/site-packages/MySQLdb/cursors.py", line 378, in _query
    db.query(q)
  File "/usr/local/python38/lib/python3.8/site-packages/MySQLdb/connections.py", line 280, in query
    _mysql.connection.query(self, query)
_mysql_exceptions.OperationalError: (2006, 'MySQL server has gone away')

The above exception was the direct cause of the following exception:

Traceback (most recent call last):
  File "/usr/local/python38/lib/python3.8/site-packages/celery/backends/database/__init__.py", line 53, in _inner
    return fun(*args, **kwargs)
  File "/usr/local/python38/lib/python3.8/site-packages/celery/backends/database/__init__.py", line 107, in _store_result
    task = list(session.query(Task).filter(Task.task_id == task_id))
  File "/usr/local/python38/lib/python3.8/site-packages/sqlalchemy/orm/query.py", line 3367, in __iter__
    return self._execute_and_instances(context)
  File "/usr/local/python38/lib/python3.8/site-packages/sqlalchemy/orm/query.py", line 3392, in _execute_and_instances
    result = conn.execute(querycontext.statement, self._params)
  File "/usr/local/python38/lib/python3.8/site-packages/sqlalchemy/engine/base.py", line 982, in execute
    return meth(self, multiparams, params)
  File "/usr/local/python38/lib/python3.8/site-packages/sqlalchemy/sql/elements.py", line 287, in _execute_on_connection
    return connection._execute_clauseelement(self, multiparams, params)
  File "/usr/local/python38/lib/python3.8/site-packages/sqlalchemy/engine/base.py", line 1095, in _execute_clauseelement
    ret = self._execute_context(
  File "/usr/local/python38/lib/python3.8/site-packages/sqlalchemy/engine/base.py", line 1249, in _execute_context
    self._handle_dbapi_exception(
  File "/usr/local/python38/lib/python3.8/site-packages/sqlalchemy/engine/base.py", line 1476, in _handle_dbapi_exception
    util.raise_from_cause(sqlalchemy_exception, exc_info)
  File "/usr/local/python38/lib/python3.8/site-packages/sqlalchemy/util/compat.py", line 398, in raise_from_cause
    reraise(type(exception), exception, tb=exc_tb, cause=cause)
  File "/usr/local/python38/lib/python3.8/site-packages/sqlalchemy/util/compat.py", line 152, in reraise
    raise value.with_traceback(tb)
  File "/usr/local/python38/lib/python3.8/site-packages/sqlalchemy/engine/base.py", line 1245, in _execute_context
    self.dialect.do_execute(
  File "/usr/local/python38/lib/python3.8/site-packages/sqlalchemy/engine/default.py", line 581, in do_execute
    cursor.execute(statement, parameters)
  File "/usr/local/python38/lib/python3.8/site-packages/MySQLdb/cursors.py", line 255, in execute
    self.errorhandler(self, exc, value)
  File "/usr/local/python38/lib/python3.8/site-packages/MySQLdb/connections.py", line 50, in defaulterrorhandler
    raise errorvalue
  File "/usr/local/python38/lib/python3.8/site-packages/MySQLdb/cursors.py", line 252, in execute
    res = self._query(query)
  File "/usr/local/python38/lib/python3.8/site-packages/MySQLdb/cursors.py", line 378, in _query
    db.query(q)
  File "/usr/local/python38/lib/python3.8/site-packages/MySQLdb/connections.py", line 280, in query
    _mysql.connection.query(self, query)
sqlalchemy.exc.OperationalError: (_mysql_exceptions.OperationalError) (2006, 'MySQL server has gone away')
[SQL: SELECT celery_taskmeta.id AS celery_taskmeta_id, celery_taskmeta.task_id AS celery_taskmeta_task_id, celery_taskmeta.status AS celery_taskmeta_status, celery_tas
kmeta.result AS celery_taskmeta_result, celery_taskmeta.date_done AS celery_taskmeta_date_done, celery_taskmeta.traceback AS celery_taskmeta_traceback 
FROM celery_taskmeta 
WHERE celery_taskmeta.task_id = %s]
[parameters: ('e909b916-4284-47c4-bc5b-321bc32eb9f9',)]
(Background on this error at: http://sqlalche.me/e/e3q8)
```
### 解决过程

查了下资料一般情况下数据库服务器断开连接后，被连接池未收回将会导致以下错误：
```
MySQL server has gone away
```
所以看了下 `sqlalchemy` 的配置：
```
sql_alchemy_pool_enabled = True

# The SqlAlchemy pool size is the maximum number of database connections
# in the pool. 0 indicates no limit.
sql_alchemy_pool_size = 5

# The maximum overflow size of the pool.
# When the number of checked-out connections reaches the size set in pool_size,
# additional connections will be returned up to this limit.
# When those additional connections are returned to the pool, they are disconnected and discarded.
# It follows then that the total number of simultaneous connections the pool will allow is pool_size + max_overflow,
# and the total number of "sleeping" connections the pool will allow is pool_size.
# max_overflow can be set to -1 to indicate no overflow limit;
# no limit will be placed on the total number of concurrent connections. Defaults to 10.
sql_alchemy_max_overflow = 10

# The SqlAlchemy pool recycle is the number of seconds a connection
# can be idle in the pool before it is invalidated. This config does
# not apply to sqlite. If the number of DB connections is ever exceeded,
# a lower config value will allow the system to recover faster.
sql_alchemy_pool_recycle = 1800

# Check connection at the start of each connection pool checkout.
# Typically, this is a simple statement like “SELECT 1”.
# More information here: https://docs.sqlalchemy.org/en/13/core/pooling.html#disconnect-handling-pessimistic
sql_alchemy_pool_pre_ping = True

sql_alchemy_pool_size = 5

# The maximum overflow size of the pool.
# When the number of checked-out connections reaches the size set in pool_size,
# additional connections will be returned up to this limit.
# When those additional connections are returned to the pool, they are disconnected and discarded.
# It follows then that the total number of simultaneous connections the pool will allow is pool_size + max_overflow,
# and the total number of "sleeping" connections the pool will allow is pool_size.
# max_overflow can be set to -1 to indicate no overflow limit;
# no limit will be placed on the total number of concurrent connections. Defaults to 10.
sql_alchemy_max_overflow = 10

# The SqlAlchemy pool recycle is the number of seconds a connection
# can be idle in the pool before it is invalidated. This config does
# not apply to sqlite. If the number of DB connections is ever exceeded,
# a lower config value will allow the system to recover faster.
sql_alchemy_pool_recycle = 1800

# Check connection at the start of each connection pool checkout.
# Typically, this is a simple statement like “SELECT 1”.
# More information here: https://docs.sqlalchemy.org/en/13/core/pooling.html#disconnect-handling-pessimistic
sql_alchemy_pool_pre_ping = True
```
该配的都配置上了，因为我们的任务是一天跑一次，查了下数据库变量 `waits_timeout` 是 `28800` ，所以直接改成25个小时。

到了第二天发现还是报这个错，很奇怪该配的都配上了，到底是哪里的问题？

仔细翻下报错日志：
```
File "/usr/local/python38/lib/python3.8/site-packages/celery/backends/database/__init__.py", line 107, in _store_result
    task = list(session.query(Task).filter(Task.task_id == task_id))
```
难道 `Airflow` 的 `sqlalchemy` 配置对 `celery` 不生效？

翻阅下源码发现果然 `Airflow` 配置的 `sqlalchemy` 只对 `Airflow` 生效
```
app = Celery(
    conf.get('celery', 'CELERY_APP_NAME'),
    config_source=celery_configuration)
```
在继续翻阅 `Celery` 文档看有没有办法配置

> database_short_lived_sessions
> Default: Disabled by default.
> 
> Short lived sessions are disabled by default. If enabled they can drastically reduce performance, especially on systems processing lots of tasks. This option is useful on low-traffic workers that experience errors as a result of cached database connections going stale through inactivity. For example, intermittent errors like (OperationalError) (2006, ‘MySQL server has gone away’) can be fixed by enabling short lived sessions. This option only affects the database backend.

文档告知通过`database_short_lived_sessions ` 参数就可以避免这个问题，但是新的问题又来了，如何在 `Airflow` 中配置额外的 `Celery` 配置呢？

### 解决方案
找到以下文件拷贝到 `DAGS` 目录下，重新命名为 `my_celery_config` 随便起
```
Python/Python37/site-packages/airflow/config_templates/default_celery.py
```
修改 `Airflow.cfg` 配置
找到 `celery_config_options` 将配置改为
刚才起的名字
```
celery_config_options = my_celery_config.DEFAULT_CELERY_CONFIG
```
在 `my_celery_config` 文件中的 `DEFAULT_CELERY_CONFIG` dict 中就可以随便加自己需要的 `Celery` 配置
