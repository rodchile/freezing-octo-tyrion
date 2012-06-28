module OAuthUtilities
  #Some OAuth Utilities
  
  def invalid_request
    throw :halt, [401,'
    {
      "error": "invalid_token",
      "error_description": "Invalid access token."
    }']
  end
  
  def access_token
    if params[:Authorization].nil?
      invalid_request
    else
      params[:Authorization].delete("OAuth2 ")
    end
  end
  
  def api_user
    secure_user = User.first(:access_token => access_token)
    if secure_user.nil?
      throw :halt, [401,'
      {
        "error": "invalid_token",
        "error_description": "Invalid access token #{access_token}."
      }']
    end
    secure_user
  end
  
end