require 'sinatra/base'
require 'json'
module Security
  class Authentication < Sinatra::Base
    
    USER = 'rod'
    JSON_FOLDER = 'json/'
    
    def module_name
      self.class.to_s.split("::").first.downcase
    end
      
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
     
    def resource_name
      resource = ""
      request.path.split("/").each do |word|
        next if word.eql? ""
       resource += "_" + word
      end
      resource
    end
     
    def prepare_json_response
      response = File.open(JSON_FOLDER + USER + "/" + module_name + "/" + resource_name + "/" + status.to_s() +".json") { |f| f.read }
    end
             
    post '/devices/register' do
      requested_params = [:clientId,:clientSecret,:username,:password,:deviceId,:deviceName]
      http_requested_parameters_nil? requested_params
      if (params[:username].eql? "daguilar") && (params[:password].eql? "123")
        success_request
        prepare_json_response
      else
        not_authorized
      end
    end
  end
end