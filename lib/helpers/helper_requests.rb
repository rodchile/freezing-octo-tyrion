module RequestsHelpers
  
  #Some requests helpers
  
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
      invalid_request if params[attr].nil?
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
end