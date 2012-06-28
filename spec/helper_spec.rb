require 'rack/test'
require 'json'
require_relative '../lib/jacket'

# setup test environment

def app
	Sinatra::Application
end

RSpec.configure do |config| 
  config.include(Rack::Test::Methods)
end

module EntitiesHelpers
  def create_valid_user
    User.create(
      :firstname      => "Test",
      :lastname       => "User",
      :username       => "my_testing_user",
      :auth_code      => "1212",
      :password       => "1212",
      :access_token   => "6549bc75-74d0-4566-876e-f397d60f9f1d"
    )
  end
end


