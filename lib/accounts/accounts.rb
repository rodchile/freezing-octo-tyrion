require 'sinatra/base'
require 'json'

module Accounts
  class Accounts < Sinatra::Base
    include OAuthUtilities, RequestsHelpers
    
    get '/users/me' do
      user = api_user
      success_request 
      prepare_json_response 'ok', __method__.to_s()
    end
    
    get '/accounts/*/transactions' do |account_id|
      user = api_user
      success_request 
      prepare_json_response 'ok', __method__.to_s()
    end
  end
end