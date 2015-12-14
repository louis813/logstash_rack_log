module Rack
  module XrkLog
    class Base
      attr_accessor :app, :logger, :app_name, :begin_at, :log_type

      def initialize(app, app_name)
        @app_name  = app_name || "unknown"
        @app      = app
        @log_type = "ACCESS"
        @logger   = ::Logger.new("log/#{app_name}_quality_access.log")
        @logger.formatter = proc do |severity, datetime, progname, msg|
          "#{begin_at}|#{app_name}|#{log_type}|#{msg}\n"
        end
      end

      def formatter
        raise NotImplementedError.new("You must implemente #{name} formatter method!")
      end

      def total_runtime
        stop_at - begin_at
      end

      def stop_at
        DateTime.now.strftime("%Q").to_i
      end

      def paths_filter?(path)
        prefix = @app.try(:config).try(:assets).try(:prefix)
        paths = [%r[\Afavicon.ico]]
        paths << "%r[\A/{0,2}#{prefix}]" if prefix

        path =~ /\A(#{paths.join('|')})/ ? false : true
      end

      def write(request, response)
        begin
          body = formatter(request, response)
          @logger.info(body) unless body.nil?  
        rescue Exception => e
          
        end
      end

    end
  end
end
