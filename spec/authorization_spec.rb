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

  it "should register the device with a valid user" do
    params = {:clientId => 'my-client-id',:clientSecret => 'my-client-secret',:username => 'my_testing_user',:password => '1212',:deviceId => 'my-foo-device',:deviceName => 'my-device-name'}
		post '/devices/register', params
		last_response.body.should == File.open("json/rod/security/_devices_register/200.json") { |f| f.read }
	end
	
	it "shouldn't register the device with a not valid user" do
    params = {:clientId => 'my-client-id',:clientSecret => 'my-client-secret',:username => 'foo',:password => 'boo',:deviceId => 'my-foo-device',:deviceName => 'my-device-name'}
	  post '/devices/register', params
	  last_response.status.should == 401
	end
	
	it "should be an invalid register request" do
    params = {}
	  post '/devices/register', params
	  last_response.status.should == 400
	end
	
	it "should return a valid access token" do
    params = {:clientId => 'my-client-id',:clientSecret => 'my-client-secret',:auth_code => '1212',:uri => 'http://foo.bar'}
	  post '/oauth/user/authorize', params
	  json_answer  = JSON.parse(last_response.body)
	  json_answer_file = JSON.parse(File.open("json/rod/security/_oauth_user_authorize/200.json") { |f| f.read })
	  json_answer["access_token"].should == json_answer_file["access_token"]
  end
  
  it "shouldn't return with a non valid access token" do
    params = {:clientId => 'my-client-id',:clientSecret => 'my-client-secret',:auth_code => 'non-valid-code',:uri => 'http://foo.bar'}
	  post '/oauth/user/authorize', params
    last_response.status.should == 401
  end
  
  it "should be an invalid authorization request" do
    params = {}
	  post '/oauth/user/authorize', params
	  last_response.status.should == 400
  end
  
end

