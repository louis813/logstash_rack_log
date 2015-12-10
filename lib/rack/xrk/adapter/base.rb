module Rack
  module XrkLog
    class Base
      attr_accessor :app, :logger, :app_name, :begin_at, :log_type
      
      def initialize(app)
        @app = app
        @log_type = "ACESS"
        @logger = ::Logger.new("log/#{app.class.parent_name.downcase}_quality_access.log")
        @logger.formatter = proc do |severity, datetime, progname, msg|
          "#{begin_at}|#{app_name}|#{log_type}|#{msg}\n"
        end
      end

      def formatter
        raise NotImplementedError.new("You must implemente #{name} formatter method!")
      end

      def total_runtime
        (stop_at - begin_at).round(2)
      end

      def stop_at
        DateTime.now.strftime("%Q").to_i
      end

      def write(env, body, status, header)
        body = formatter(env, body, status, header)
        @logger.info(body) unless body.nil?
      end
      
    end
  end
end