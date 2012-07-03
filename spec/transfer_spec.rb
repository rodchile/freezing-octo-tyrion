require_relative 'helper_spec'

shared_examples_for "safe POST REST resource" do
    it "shouldn't accept the request without access_token" do
      params = {}
      post @route , params
      last_response.status.should == 401
    end

    it "shouldn't accept the request with a non valid access token" do
      params ={:Authorization => 'OAuth2 ' + 'foo'}
      post @route , params 
      last_response.status.should == 401
    end    
end

describe 'Internal Transfers service' do
  include EntitiesHelpers
  
  it_should_behave_like "safe POST REST resource"
  
  before(:each) do
    @route = '/transfer/internal'
    @user = create_valid_user
    @user.save
  end

  after(:each) do
    @user.destroy
  end
    
  it "should do an internal transfer for the test user" do
    post @route, '', "HTTP_AUTHORIZATION" => 'OAuth2 6549bc75-74d0-4566-876e-f397d60f9f1d'
    last_response.body.should == File.open("json/rod/transfers/transfer_internal/ok.json") { |f| f.read }
  end
end