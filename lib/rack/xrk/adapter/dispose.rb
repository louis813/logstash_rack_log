require ::File.expand_path("../../adapter/base", __FILE__)

module Rack
  module XrkLog
    class Dispose < Base

      def initialize(app, app_name)
        @app_name = app_name
        super
      end

      def formatter(request, response)
        [
          "#{request.ip}:0",
          request.host_with_port,
          total_runtime,
          request.scheme,
          (request.content_length || 0),
          (response.content_length || 0),
          request.request_method,
          request.path_info,
          response.status,
          request.query_string,
          path_parameters(request),
          "-",
          json_with_nil(response.body)
        ].join("|") if paths_filter?(request.path)
      end

      def json_with_nil(body)
        return "-" unless body
        JSON.parse(val).to_json rescue "-"
      end


      def path_parameters(request)
        opts = request.env["action_dispatch.request.path_parameters"]
        return "#{opts[:controller]}/#{opts[:action]}" unless opts.blank?
      end

    end
  end
end
