require 'sinatra'
require_relative 'security/authentication'
module Jacket
use Security::Authentication
end