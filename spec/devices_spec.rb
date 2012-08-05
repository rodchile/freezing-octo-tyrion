require_relative 'helper_spec'

shared_examples_for "safe POST request" do
    it "shouldn't accept the request without access_token" do
      post @route
      last_response.status.should == 401
    end

    it "shouldn't accept the request with a non valid access token" do
      post @route, '', "HTTP_AUTHORIZATION" => 'OAuth2 foo'
      last_response.status.should == 401
    end    
end

describe 'Device Report service' do
  include EntitiesHelpers
  
  it_should_behave_like "safe POST request"  
  
  before(:each) do
    @route = '/devices/report'
    @user = create_valid_user
    @user.save
  end

  after(:each) do
    @user.destroy
  end
    
  it "should report a device" do
    post @route, 'appClientVersion=1.0.0 (M13-20120723)&deviceOSVersion=5.1&deviceStatus=no jailbreak', "HTTP_AUTHORIZATION" => 'OAuth2 6549bc75-74d0-4566-876e-f397d60f9f1d'
    last_response.body.should == File.open("json/my_testing_user/devices/devices_report/ok.json") { |f| f.read }
  end
end