require 'rack/test'
require_relative '../lib/jacket'

# setup test environment
set :environment, :test

def app
	Sinatra::Application
end

describe 'Authentication and Autorization Process' do
  include Rack::Test::Methods	
  it "tests" do
		post '/devices/register', params = {:username => 'daguilar' , :password => '123'}
		last_response.body.should == File.open("json/rod/security/devices_register_200.json") { |f| f.read }
	end
end

