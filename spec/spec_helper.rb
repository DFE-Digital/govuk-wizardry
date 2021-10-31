require 'pry'
require 'pry-byebug'
Dir[File.join('./spec', 'support', '**', '*.rb')].sort.each { |file| require file }

require File.expand_path('dummy/config/environment', __dir__)

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
