require 'bundler'

ENV['RACK_ENV'] ||= 'test'
Bundler.require(:default, :test)

require File.expand_path('../../config/environment', __FILE__)
require 'rspec'
require 'capybara/dsl'
require 'simplecov'
SimpleCov.start

Capybara.app = LittleShopApp
DatabaseCleaner.strategy = :truncation

RSpec.configure do |c|
  c.include Capybara::DSL
end
