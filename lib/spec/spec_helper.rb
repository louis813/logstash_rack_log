require File.expand_path('../../lib/rack/xrk/adapter/dispose', __FILE__)
require 'rspec'
require 'rspec/core'
require 'rspec/mocks'

RSpec.configure do |config|
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end