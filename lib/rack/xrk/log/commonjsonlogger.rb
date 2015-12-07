require 'rack/commonlogger'
require 'json'

module Rack
  module Xrk
    module Log
      class CommonJsonLogger < Rack::CommonLogger

        def initialize(app, logger=nil)
          logger = ::Logger.new(::File.new("log/app.log","a+"))
          super(app, logger)
        end

        def log(env, status, header, began_at)
          logger = @logger || env['rack.errors']

          # blob = {
          #   :length       => header['Content-Length'] || 0,
          #   :code         => status.to_s[0 .. 3],
          #   :version      => env['HTTP_VERSION'],
          #   :method       => env['REQUEST_METHOD'],
          #   :duration     => (Time.now - began_at),
          #   :query        => env["QUERY_STRING"],
          #   :path         => env['PATH_INFO'],
          #   :remote_addr  => env['REMOTE_ADDR'],
          #   :user         => env['REMOTE_USER'],
          #   :user_agent   => env['HTTP_USER_AGENT'],
          #   :timestamp    => Time.now.utc.iso8601
          # }


          app_name = "APP_NAME"
          LOG_TYPE = "ACESS"


          blob = {
            :app_name     => app_name,
            :request_time => began_at.to_i,
            :log_type => LOG_TYPE,
            :CLIENT_IP_AND_PORT => "#{env['REMOTE_ADDR']}",
            :SERVER_IP_AND_PORT => "",
            :ELAPSED_TIME => (Time.now - began_at).to_i,
            :communication_type => "",
            :request_data_length => "",
            :response_data_length => "",
            :dynamic_params => ""
          }

          blob[:forwarded_for] = env['HTTP_X_FORWARDED_FOR'].split(',') if env['HTTP_X_FORWARDED_FOR']

          if logger
            logger.info({:type => 'request', :event => blob}.to_json)
          end
        end
      end
    end
  end
end
