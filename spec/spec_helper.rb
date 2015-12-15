require 'rspec'
require 'rspec/core'
require 'rspec/mocks'
require File.expand_path('../../lib/rack/xrk/log/commonlogger', __FILE__)

RSpec.configure do |config|
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end


module Mock

  class App 

  end

  class Request
    attr_accessor :request_method, :ip, :scheme, :content_length
    attr_accessor :path_info, :query_string, :path, :env

    def initialize
      @ip = "192.168.1.168"
      @scheme = "http"
      @request_method = "get"
      @content_length = 0 
      @path_info = "/users/1"
      @path = "/users/1"
      @env = {}
    end

  end

  class Response
    attr_accessor :status, :content_length, :body

    def initialize
      @status = 0
      @content_length = 0
      @body = "{\"name\":\"zhangsan\",\"age\":19}"
    end
  end
end
