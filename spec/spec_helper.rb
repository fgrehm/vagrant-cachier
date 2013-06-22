RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.color = true
  config.tty = true
end

require 'tempfile'
require 'vagrant-cachier'
