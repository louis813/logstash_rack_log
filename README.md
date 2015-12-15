# rack_xrk_log
rack log for logstash

目前只适合公司的ruby项目使用


1. 增加 Gem

~~~
gem 'rack_xrk_log'
~~~

2. 在 config.ru 增加

~~~
require 'rack/xrk/log'
use Rack::XrkLog::CommonLogger, app_name, options
~~~

app_name：程序名称

options：配置参数可以选

1.  exclude_path 过滤路径
2.  port 端口
