module OAuthUtilities
  #Some OAuth Utilities
  
  def invalid_request
    throw :halt, [401,'
    {
      "error": "invalid_token",
      "error_description": "Invalid access token."
    }']
  end
  
  def invalid_access_token
     throw :halt, [401,'
      {
        "error": "invalid_token",
        "error_description": "Invalid access token #{access_token}."
      }']
  end
    
  def access_token
    token = (params[:Authorization].nil?)? invalid_request : params[:Authorization].delete("OAuth2 ")
  end
  
  def api_user
    secure_user = User.first(:access_token => access_token)
    invalid_access_token if secure_user.nil?
    secure_user
  end
end