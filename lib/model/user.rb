class User
  include DataMapper::Resource
  
  property :id, Serial
  property :firstname, String
  property :lastname, String
  property :username, String, :key => true
  property :auth_code, String
  property :oauth_token, String
  property :password, BCryptHash
end