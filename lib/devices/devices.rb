require 'sinatra/base'
require 'json'

module Devices
  class Report < Sinatra::Base
    include OAuthUtilities, RequestsHelpers
    
    ['/devices/report'].each do |path|
      post(path) {
        user = api_user
        success_request 
        prepare_json_response 'ok', user.username ,__method__.to_s()
      }
    end
    
  end
end