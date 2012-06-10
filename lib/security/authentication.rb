require 'sinatra/base'
require 'json'
module Jacket
  class Authentication < Sinatra::Base
  
    def success_request
      status 200
      content_type 'application/json'
    end
    
    def not_authorized
      throw :halt, [ 401, 'Your credentials are not valid.']
    end
    
    def invalid_request
      throw :halt, [ 400, 'Invalid Request.']
    end
    
    def http_requested_parameters_nil?(attributes)
       attributes.each do |attr|
         if params[attr].nil?
           invalid_request
         end
       end
     end
        
    post '/devices/register' do
      requested_params = [:clientId,:clientSecret,:username,:password,:deviceId,:deviceName]
      http_requested_parameters_nil? requested_params
      if (params[:username].eql? "daguilar") && (params[:password].eql? "123")
        success_request
        response = File.open("json/rod/security/devices_register_200.json") { |f| f.read }
      else
        not_authorized
      end
    end
  end
end