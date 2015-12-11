require ::File.expand_path("../../adapter/base", __FILE__)

module Rack
  module XrkLog
    class Dispose < Base

      def initialize(app)
        @app_name = app.class.parent_name
        super
      end

      def formatter(env, body, status, header)
        @request = Rack::Request.new(env)

        return if [%r{^/assets/}, %r{favicon.ico}].any?{|path| path.match(@request.path) }

        client_ip_and_port    = "#{@request.host}:#{@request.port}"
        server_ip_and_port    = "#{env['SERVER_NAME']}:#{env['SERVER_PORT']}"
        query_string          = @request.query_string.blank? ? "-" : @request.query_string

        [
          client_ip_and_port,
          server_ip_and_port,
          total_runtime,
          @request.scheme,
          @request.content_length || 0,
          @request.body.size || 0,
          @request.request_method,
          @request.path_info,
          status,
          query_string,
          path_parameters(env),
          "-",
          json_with_nil(body[0]) || "-"
        ].join("|")
      end


      def json_with_nil(value)
        JSON.parse(value).to_json rescue nil
      end


      def path_parameters(env)
        opts = env["action_dispatch.request.path_parameters"]
        return "#{opts[:controller]}/#{opts[:action]}" unless opts.blank?
      end

    end
  end
end