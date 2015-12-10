require 'json'
require ::File.expand_path("../../adapter/dispose", __FILE__)

module Rack
  module XrkLog
    class CommonLogger

      def initialize(app)
        @app = app
        @dispose = Dispose.new(@app)
      end

      def call(env)
        @dispose.begin_at = DateTime.now.strftime("%Q").to_i
        status, header, body = @app.call(env)
        @dispose.write(env, body, status, header)
        [status, header, body]
      end

    end
  end
end
