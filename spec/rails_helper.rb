require 'rails/all'
require 'rspec/expectations'
require 'shoulda-matchers'
require 'rails-controller-testing'
require 'dummy/config/environment'
require 'rspec/rails'

ActiveRecord::Migration.maintain_test_schema!
ActiveRecord::Schema.verbose = false

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

load 'spec/dummy/db/schema.rb'

require 'spec_helper'
