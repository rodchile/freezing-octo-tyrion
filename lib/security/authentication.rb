require 'sinatra/base'
require 'json'

module Security
  class Authentication < Sinatra::Base
    include OAuthUtilities, RequestsHelpers
    
    get '/' do
      response = 'Hi there! Welcome to Jacket API.'
    end
             
    post '/devices/register' do
      requested_params = [:clientId,:clientSecret,:username,:password,:deviceId,:deviceName]
      http_requested_parameters_nil? requested_params
      
      user = User.first(:username => params[:username])  
      success_request
      response = (!user.nil? && user.password == params[:password])? prepare_json_response('ok','oauth') : prepare_json_response('nok','oauth')
    end  
    
    post '/oauth/authorize' do
      requested_params = [:client_id,:client_secret,:code,:redirect_uri]
      http_requested_parameters_nil? requested_params
      user = User.first(:auth_code => params[:code]) 
      access_key = user.oauth_token.to_s() if !user.nil?
      response = (user.nil?)? prepare_json_response('nok','oauth') : '{
        "access_token": "' + access_key + '",
        "expires_in": 31535999
      }'
      success_request
      response
    end
    
    put '/devices/*/activate' do |deviceid|
      user = api_user
      success_request 
      prepare_json_response 'ok','oauth', __method__.to_s()
    end
    
    post '/users/authenticate' do
      requested_params = [:password]
      http_requested_parameters_nil? requested_params
      user = api_user
      success_request 
      response = (!user.nil? && user.password == params[:password])? prepare_json_response('ok', user.username ,__method__.to_s()) : prepare_json_response('nok', user.username ,__method__.to_s())
    end
  end
end