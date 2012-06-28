require 'sinatra'
require 'data_mapper'
require 'dm-migrations'

require_relative 'model/user'
require_relative 'helpers/helper_requests'
require_relative 'security/oauth'
require_relative 'security/authentication'
require_relative 'accounts/accounts'
require_relative 'transfers/internal_transfers'

module Jacket  
  configure :production do
    ENV['DATABASE_URL'] = "sqlite://#{Dir.pwd}/db/jacket_production.db"
  end
  
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

  use Security::Authentication
  use Accounts::Accounts
  use Transfers::Internal
end