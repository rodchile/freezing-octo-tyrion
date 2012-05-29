require 'sinatra/base'
require 'json'
module Jacket
  class Authentication < Sinatra::Base
    def auth_attributes
      @auth_attr ||= {}
    end

    def get_http_variables(attributes)
      attributes.each do |attr|
        auth_attributes[attr] = params[attr]
      end 
    end
        
    post '/devices/register' do
      request_params = [:clientId,:clientSecret,:username,:password,:deviceId,:deviceName]
      get_http_variables request_params
      if (auth_attributes[:username].eql? "daguilar") && (auth_attributes[:password].eql? "123")
        response = File.open("json/rod/security/devices_register_200.json") { |f| f.read }
      else
        #Return 400.X HTTP Code Error
      end
      content_type 'application/json'
      response
    end
  end
end