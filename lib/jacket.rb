require 'sinatra'
require 'data_mapper'
require 'dm-migrations'

require_relative 'model/user'
require_relative 'helpers/helper_requests'
require_relative 'security/oauth'
require_relative 'security/authentication'
require_relative 'accounts/accounts'
require_relative 'transfers/internal_transfers'
require_relative 'devices/devices.rb'

module Jacket  
  configure :development  do
    ENV['DATABASE_URL'] = "sqlite://#{Dir.pwd}/db/jacket_development.db"
  end
  
  configure :test  do
    ENV['DATABASE_URL'] = "sqlite://#{Dir.pwd}/db/jacket_test.db"
  end
   
  #DB Setup
  DataMapper.setup(:default, ENV['DATABASE_URL'])  
  DataMapper.auto_upgrade!
  DataMapper.finalize
  
  user = User.first(:username => 'rod')
  if user.nil?
    user = User.create(
      :firstname    =>  'Rodrigo',
      :lastname     =>  'Garcia',
      :username     =>  'rod',
      :auth_code    =>  '1234',
      :password     =>  'foo',
      :oauth_token  =>  '1234-abcd-lol-cat'
    )
    user = User.create(
      :firstname    =>  'Rodrigo',
      :lastname     =>  'Pizarro',
      :username     =>  'rpizarro',
      :auth_code    =>  '1234',
      :password     =>  'foo',
      :oauth_token  =>  '1234-abcd-lol-gholie'
    ) 
    user = User.create(
      :firstname    =>  'Arley',
      :lastname     =>  'Duarte',
      :username     =>  'aduarte',
      :auth_code    =>  '1234',
      :password     =>  'foo',
      :oauth_token  =>  '1234-abcd-lol-senorito'
    ) 
  end

  use Security::Authentication
  use Accounts::Accounts
  use Transfers::Internal
  use Devices::Report
end