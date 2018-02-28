require 'rspec'
require 'logger'

require 'marqeta'
require 'marqeta/api_caller'
require 'marqeta/api_object'
require 'marqeta/card'
require 'marqeta/gpa_balance'
require 'marqeta/user'

RSpec.configure do |config|
  config.before(:all) do
    Marqeta.configure do |marqeta_config|
      marqeta_config.username = 'foo'
      marqeta_config.password = 'bar'
      marqeta_config.base_url = 'www.foo.com'
      marqeta_config.logger = Logger.new(nil)
    end
  end
end
