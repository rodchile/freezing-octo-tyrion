require_relative 'helper_spec'

shared_examples_for "safe GET REST resource" do
    it "shouldn't accept the request without access_token" do
      get @route
      last_response.status.should == 401
    end

    it "shouldn't accept the request with a non valid access token" do
      get @route, '', "HTTP_AUTHORIZATION" => 'OAuth2 foo'
      last_response.status.should == 401
    end    
end

describe 'ME service' do
  include EntitiesHelpers
  
  it_should_behave_like "safe GET REST resource"
  
  before(:each) do
    @route = '/users/me'
    @user = create_valid_user
    @user.save
  end

  after(:each) do
    @user.destroy
  end
    
  it "should get the ME answer for the test user" do
    get @route, '', "HTTP_AUTHORIZATION" => 'OAuth2 6549bc75-74d0-4566-876e-f397d60f9f1d'
    last_response.body.should == File.open("json/my_testing_user/accounts/users_me/ok.json") { |f| f.read }
  end
end

describe 'Transactions service' do
  include EntitiesHelpers
  it_should_behave_like "safe GET REST resource"
  
  before(:each) do
    @route = '/accounts/foo-1/transactions'
    @user = create_valid_user
    @user.save
  end

  after(:each) do
    @user.destroy
  end
  
  it "should get the transactions for the test user" do
    get @route, '', "HTTP_AUTHORIZATION" => 'OAuth2 6549bc75-74d0-4566-876e-f397d60f9f1d'
    last_response.body.should == File.open("json/my_testing_user/accounts/accounts_transactions/ok.json") { |f| f.read }
  end
end