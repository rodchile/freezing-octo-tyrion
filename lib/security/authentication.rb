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
      response = (!user.nil? && user.password == params[:password])? prepare_json_response('ok') : prepare_json_response('nok')
    end  
    
    post '/oauth/authorize' do
      requested_params = [:clientId,:clientSecret,:auth_code,:uri]
      http_requested_parameters_nil? requested_params
      user = User.first(:auth_code => params[:auth_code])
      success_request
      response = (!user.nil?)? prepare_json_response('ok') : prepare_json_response('nok')
    end
    
    put '/devices/*/activate' do |deviceid|
      user = api_user
      success_request 
      prepare_json_response 'ok', __method__.to_s()
    end
  end
end