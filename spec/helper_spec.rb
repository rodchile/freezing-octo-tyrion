require 'rack/test'
require_relative '../lib/jacket'

# setup test environment
set :environment, :test

def app
	Sinatra::Application
end

RSpec.configure do |config| 
  config.include(Rack::Test::Methods)
end

describe 'Authentication and Autorization Process' do
  it "should register the device with a valid user" do
    params = {:clientId => 'my-client-id',:clientSecret => 'my-client-secret',:username => 'daguilar',:password => '123',:deviceId => 'my-foo-device',:deviceName => 'my-device-name'}
		post '/devices/register', params
		last_response.body.should == File.open("json/rod/security/devices_register_200.json") { |f| f.read }
	end
	
	it "shouldn't register the device with a not valid user" do
    params = {:clientId => 'my-client-id',:clientSecret => 'my-client-secret',:username => 'foo',:password => 'boo',:deviceId => 'my-foo-device',:deviceName => 'my-device-name'}
	  post '/devices/register', params
	  last_response.status.should == 401
	end
	
	it "should be an invalid request" do
    params = {}
	  post '/devices/register', params
	  last_response.status.should == 400
	end
end

