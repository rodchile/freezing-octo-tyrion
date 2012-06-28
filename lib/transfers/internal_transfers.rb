require 'sinatra/base'
require 'json'

module Transfers
  class Internal < Sinatra::Base
    include OAuthUtilities, RequestsHelpers
    
    post '/transfer/internal' do
      user = api_user
      success_request 
      prepare_json_response 'ok', __method__.to_s()
    end
  end
end