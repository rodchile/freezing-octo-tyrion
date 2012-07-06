require 'sinatra/base'
require 'json'

module Accounts
  class Accounts < Sinatra::Base
    include OAuthUtilities, RequestsHelpers
    
    ['/users/me','/accounts/*/transactions'].each do |path|
      get(path) {
        user = api_user
        success_request
        prepare_json_response 'ok', user.username ,__method__.to_s()
      }
    end
  end
end