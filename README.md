# rack_xrk_log
rack log for logstash

目前只适合公司的ruby项目使用


1. 增加 Gem

~~~
gem 'rack_xrk_log',  :git => 'git@github.com:louis813/rack_xrk_log.git'
~~~

2. 在 config.ru 增加

~~~
require 'rack/xrk/log'
use Rack::Xrk::Log::CommonJsonLogger, Rails.logger
~~~
