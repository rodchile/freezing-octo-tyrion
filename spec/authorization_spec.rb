require_relative 'helper_spec'

describe 'Authentication and Autorization Process' do
  include EntitiesHelpers
  
  before(:each) do
    @user = create_valid_user
    @user.save
  end

  after(:each) do
    @user.destroy
  end
  
  #Describes the Device Register

  it "should register the device with a valid user" do
    params = {:clientId => 'my-client-id',:clientSecret => 'my-client-secret',:username => 'my_testing_user',:password => '1212',:deviceId => 'my-foo-device',:deviceName => 'my-device-name'}
		post '/devices/register', params
		last_response.body.should == File.open("json/rod/security/devices_register/ok.json") { |f| f.read }
	end
	
	it "shouldn't register the device with a not valid user" do
    params = {:clientId => 'my-client-id',:clientSecret => 'my-client-secret',:username => 'foo',:password => 'boo',:deviceId => 'my-foo-device',:deviceName => 'my-device-name'}
	  post '/devices/register', params
		last_response.body.should == File.open("json/rod/security/devices_register/nok.json") { |f| f.read }
	end
	
	it "should be an invalid register request" do
    params = {}
	  post '/devices/register', params
	  last_response.status.should == 401
	end
	
	#Describes the access_token request
	
	it "should return a valid access token" do
    params = {:client_id => 'my-client-id',:client_secret => 'my-client-secret',:code => '1212',:redirect_uri => 'http://foo.bar'}
	  post '/oauth/authorize', params
	  json_answer  = JSON.parse(last_response.body)
	  json_answer_file = JSON.parse(File.open("json/rod/security/oauth_authorize/ok.json") { |f| f.read })
	  json_answer["access_token"].should == json_answer_file["access_token"]
  end
  
  it "shouldn't return an access token with a non valid authorization code" do
    params = {:client_id => 'my-client-id',:client_secret => 'my-client-secret',:code => 'non-valid-code',:redirect_uri => 'http://foo.bar'}
	  post '/oauth/authorize', params
		last_response.body.should == File.open("json/rod/security/oauth_authorize/nok.json") { |f| f.read }
  end
  
  it "should be an invalid authorization request" do
    params = {}
	  post '/oauth/authorize', params
	  last_response.status.should == 401
  end
  
  #Describes the Device Activation
  
  it "should activate a register device" do
    put '/devices/foo-device/activate', '', "HTTP_AUTHORIZATION" => 'OAuth2 6549bc75-74d0-4566-876e-f397d60f9f1d'
    last_response.body.should == File.open("json/rod/security/devices_activate/ok.json") { |f| f.read }
  end
  
  it "shouldn't accept the request without access_token" do
    params = {}
    put '/devices/foo-device/activate', params
    last_response.status.should == 401
  end
  
  it "shouldn't accept the request with a non valid access token" do
    put '/devices/foo-device/activate', '', "HTTP_AUTHORIZATION" => 'OAuth2 foo' 
    last_response.status.should == 401
  end
  
  
end

