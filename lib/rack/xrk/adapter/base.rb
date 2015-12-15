require 'socket'

module Rack
  module XrkLog
    class Base
      attr_accessor :app, :logger, :app_name, :begin_at, :log_type

      DEFAULT_OPTIONS = {exclude_path: ['/assets'], port: '80'}

      def initialize(app, app_name, options = {})
        @app_name  = app_name || "unknown"
        @app      = app
        exclude_path = options.delete(:exclude_path)
        @options = DEFAULT_OPTIONS.merge(options)
        load_exclude_path(exclude_path)
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
        reg = /favicon.ico\z|#{@options[:exclude_path].map{|p| reg_prefix(p) }.join('|')}/ 
        reg =~ path ? false : true
      end

      def reg_prefix(prefix)
        return '\A/{0,2}'+ prefix
      end

      def load_exclude_path(_paths)
        paths = Array(_paths)
        prefix = rails_assets_prefix
        paths << prefix if prefix
        prefix = sinatra_assets_prefix
        paths << prefix if prefix
        @options[:exclude_path] += paths
      end

      def write(request, response)
        begin
          body = formatter(request, response)
          @logger.info(body) unless body.nil?  
        rescue Exception => e
          
        end
      end

      def rails_assets_prefix
        @app.try(:config).try(:assets).try(:prefix) if defined?(Rails)
      end

      def sinatra_assets_prefix
        app.settings.assets_prefix if defined?(Sinatra::Application)
      end

      def convert_clipped(value)
        value || "-"
      end

      def current_ip_with_port
        ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
        ip = ip ? ip.ip_address : "127.0.0.1"
        "#{ip}:#{@options[:port]}"
      end

    end
  end
end
