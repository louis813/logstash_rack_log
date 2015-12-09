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

          return unless header["Content-Type"].present? && (header["Content-Type"].include? "text/html")

          application_name  = @app.class.parent_name
          log_type          = "ACESS"
          client_ip_and_port    = (env['HTTP_X_FORWARDED_FOR'] || env["REMOTE_ADDR"] || "-")
          response_data_length  = env['action_controller.instance'].response_body.to_s.bytesize
          query_string          = (env[QUERY_STRING].empty? ? "" : "?"+env[QUERY_STRING])
          controller            = env['action_dispatch.request.path_parameters'][:controller]
          action                = env['action_dispatch.request.path_parameters'][:action]
          return_content        = env['action_controller.instance'].response_body
          return_content        = (return_content.empty? ? "" : return_content.to_s[0..30])

          data = [
            began_at.to_i,                #REQUEST_TIME
            application_name,             #APP_TIME
            log_type,                     #LOG_TYPE
            client_ip_and_port,           #CLIENT_IP_AND_PORT
            "#{env['HTTP_HOST']}",        #SERVER_IP_AND_PORT
            (Time.now - began_at).to_i,   #ELAPSED_TIME
            "#{env['rack.url_scheme']}",  #COMMUNICATION_TYPE
            "#{env['CONTENT_LENGTH']}",   #REQUEST_DATA_LENGTH
            response_data_length,         #RESPONSE_DATA_LENGTH
          ]

          dynamic_params = [
            "#{env['REQUEST_METHOD']}",   #METHOD
            "#{env['REQUEST_PATH']}",     #URL
            "#{status.to_s[0..3]}",       #STATUS_CODE
            query_string,                 #QUERY_ENTITY
            "#{controller} #{action}",    #CALL_METHOD
            "",                           #BUSSINESS_CODE
            return_content                #RETURN_CONTENT
          ]
          data.concat(dynamic_params)


          # 1. TODO: 自定义日志输出方法
          logger.info(data.to_s) if logger

          # 2. TODO: Rack和Grape验证

        end
      end
    end
  end
end
