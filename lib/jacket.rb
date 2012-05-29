require 'sinatra'
require_relative 'security/authentication'
module Jacket
use Jacket::Authentication  
end