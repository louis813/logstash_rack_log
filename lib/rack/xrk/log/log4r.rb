require 'time'
require 'log4r'
require 'json'

module Rack
  module Xrk
    module Log
      module Log4r
        class Formatter < ::Log4r::Formatter

          def format(event)
            {
              :type => 'log',
              :event => {
                :tracer => event.tracer[0 .. 10],
                :level => ::Log4r::LNAMES[event.level],
                :timestamp => Time.now.utc.iso8601,
                :message => event.data
              }
            }.to_json + "\n"
          end

        end
      end
    end
  end
end
