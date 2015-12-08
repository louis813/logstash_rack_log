require 'rack/commonlogger'
require 'json'

module Rack
  module Xrk
    module Log
      class CommonLogger < Rack::CommonLogger

        def initialize(app, logger=nil)
          logger = ::Logger.new(::File.new("log/app.log","a+"))
          super(app, logger)
        end

        def log(env, status, header, began_at)
          logger = @logger || env['rack.errors']

          # 1. 过滤静态资源类请求
          return unless header["Content-Type"].present? && (header["Content-Type"].include? "text/html")

          # 2. TODO: 需要传特定的项目值进来
          application_name = "BXR"
          log_type = "ACESS"

          controller = env['action_dispatch.request.path_parameters'][:controller]
          action = env['action_dispatch.request.path_parameters'][:action]
          response_data_length = env['action_controller.instance'].response_body.to_s.bytesize

          data = [
            began_at.to_i,                                    #REQUEST_TIME
            application_name,                                 #APP_TIME
            log_type,                                         #LOG_TYPE
            "#{env['REMOTE_ADDR']}",                          #CLIENT_IP_AND_PORT
            "#{env['SERVER_NAME']} #{env['SERVER_PORT']}",    #SERVER_IP_AND_PORT
            (Time.now - began_at).to_i,                       #ELAPSED_TIME
            "#{env['rack.url_scheme']}",                      #COMMUNICATION_TYPE
            "REQUEST_DATA_LENGTH",                            #REQUEST_DATA_LENGTH
            "RESPONSE_DATA_LENGTH",                           #RESPONSE_DATA_LENGTH
          ]

          # 3. TODO: 返回类型是String或者JSON，才进行返回 RETURN_CONTENT
          dynamic_params = [
            "#{env['REQUEST_METHOD']}", #METHOD
            "#{env['REQUEST_PATH']}",   #URL
            "#{status}",                #STATUS_CODE
            "QUERY_ENTITY",             #QUERY_ENTITY
            "#{controller} #{action}",  #CALL_METHOD
            "BUSSINESS_CODE",           #BUSSINESS_CODE
            "RETURN_CONTENT"            #RETURN_CONTENT
          ]
          data.concat(dynamic_params)


          # 4. TODO: 自定义日志输出方法
          logger.info(data.to_s) if logger

          # 5. TODO: Rack和Rails，Grape支持

        end
      end
    end
  end
end
