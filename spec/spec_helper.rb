# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require 'simplecov'
SimpleCov.start


require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rspec/rails"


ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = "test.com"

Rails.backtrace_cleaner.remove_silencers!

## Configure capybara for integration testing
#require "capybara/rails"
#Capybara.default_driver   = :rack_test
#Capybara.default_selector = :css

# Run any available migration
ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # config.before(:all) do
  #   seed_file = File.join(Rails.root, 'db', 'seeds.rb')
  #   load(seed_file)
  # end
end

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
