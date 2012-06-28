require 'sinatra/base'
require 'json'
require 'bcrypt'

module Security
  class Authentication < Sinatra::Base
    include OAuthUtilities
    
    USER_ID = 'rod'
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
     
    
    def resource_name(route)
      resource = ''
      route.split("/").each do |word|
        if resource.empty?
          resource = word
          next
        elsif word.eql?("*")
          next
        end
         resource += "_" + word
      end
      resource
    end

    def prepare_json_response(*args)
      resource = (args.size < 2)? resource_name(request.path) : resource_name(args[1].split(" ").last)
      response = File.open(JSON_FOLDER + USER_ID + "/" + module_name + "/" + resource + "/" + args[0] +".json") { |f| f.read }
    end
             
    post '/devices/register' do
      requested_params = [:clientId,:clientSecret,:username,:password,:deviceId,:deviceName]
      http_requested_parameters_nil? requested_params
      
      user = User.first(:username => params[:username])  
      success_request
      response = (!user.nil? && user.password == params[:password])? prepare_json_response('ok') : prepare_json_response('nok')
    end  
    
    post '/oauth/user/authorize' do
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