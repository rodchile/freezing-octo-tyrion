class User
  include DataMapper::Resource
  
  property :id, Serial
  property :firstname, String
  property :lastname, String
  property :username, String, :key => true
  property :auth_code, String
  property :password, BCryptHash
  property :access_token, String, :key => true 
end