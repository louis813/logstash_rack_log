require 'spec_helper'
require 'pry'

describe Rack::XrkLog::Dispose do 

  let(:app_name){  "CRM" }
  let(:port){ '3000' }
  let(:begin_at){ DateTime.now.strftime("%Q").to_i }


  before(:each) do 
    @dispose = Rack::XrkLog::Dispose.new(Mock::App.new, app_name, {port: port, exclude_path: ['/cms_static']})
    @dispose.begin_at = begin_at
    @logger_file = @dispose.logger.instance_variable_get(:@logdev).dev
  end

  it "logger object test" do 
    expect(@dispose.logger).not_to be_nil
    expect(@dispose.logger.level).to eq(0)
    expect(File.basename(@logger_file)).to eq("#{app_name}_quality_access.log")
  end

  it "formatter return result" do 
    expect(@dispose.formatter(Mock::Request.new, Mock::Response.new)).not_to be_nil
  end

  it "formatter return nil" do 
    request = Mock::Request.new
    request.path_info = "/assets/app.js"
    request.path = "/assets/app.js"
    expect(@dispose.formatter(request, Mock::Response.new)).to be_nil
  end

  it "logger write" do
    old_count = IO.readlines(@logger_file).count
    @dispose.write(Mock::Request.new, Mock::Response.new)
    expect(IO.readlines(@logger_file).count).to eq(old_count+1)
  end


  it "logger static file not write" do 
    old_count = IO.readlines(@logger_file).count
    request = Mock::Request.new
    request.path_info = "/assets/app.js"
    request.path = "/assets/app.js"
    @dispose.write(request, Mock::Response.new)
    expect(IO.readlines(@logger_file).count).to eq(old_count)
  end

  it "logger favicon.ico file not write" do  
    old_count = IO.readlines(@logger_file).count
    request = Mock::Request.new
    request.path_info = "/favicon.ico"
    request.path = "/favicon.ico"
    @dispose.write(request, Mock::Response.new)
    expect(IO.readlines(@logger_file).count).to eq(old_count)
  end

  it "logger exclude_path file not write" do  
    old_count = IO.readlines(@logger_file).count
    request = Mock::Request.new
    request.path_info = "/cms_static/jquery.js"
    request.path = "/cms_static/jquery.js"
    @dispose.write(request, Mock::Response.new)
    expect(IO.readlines(@logger_file).count).to eq(old_count)
  end
end