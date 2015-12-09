require 'rack/commonlogger'
require 'json'

module Rack
  module Xrk
    module Log
      class CommonLogger < Rack::CommonLogger

        def initialize(app, logger=nil)
          binding.pry
          logger = ::Logger.new(::File.new("log/#{app.class.parent_name.downcase}_quality_access.log","a+"))
          logger.formatter = proc do |severity, datetime, progname, msg|
             "#{msg}\n"
          end
          super(app, logger)
        end

        def log(env, status, header, began_at)
          logger = @logger || env['rack.errors']

          return unless header["Content-Type"].present? && (header["Content-Type"].include? "text/html")

          application_name      = @app.class.parent_name
          log_type              = "ACESS"
          client_ip_and_port    = (env['HTTP_X_FORWARDED_FOR'] || env['REMOTE_ADDR'] || '-')
          response_data_length  = env['action_controller.instance'].response_body.to_s.bytesize
          query_string          = (env['QUERY_STRING'].empty? ? "" : "?"+env['QUERY_STRING'])
          controller            = env['action_dispatch.request.path_parameters'][:controller]
          action                = env['action_dispatch.request.path_parameters'][:action]
          return_content        = env['action_controller.instance'].response_body
          return_content        = (return_content.empty? ? "" : return_content.to_s[0..99])

          data = "#{began_at.to_i}, #{application_name}, #{log_type}, #{client_ip_and_port}, #{env['HTTP_HOST']}, #{(Time.now - began_at).to_i}, #{env['rack.url_scheme']}, #{env['CONTENT_LENGTH']}, #{response_data_length},".gsub("\n", "")

          dynamic_params = "#{env['REQUEST_METHOD']} #{env['REQUEST_PATH']}, #{status.to_s[0..3]}, #{query_string}, #{controller} #{action}, , #{return_content}".gsub("\n", "")

          data.concat(dynamic_params)

          logger.info(data) if logger

          # TODO: Rack和Grape验证
        end
      end
    end
  end
end
