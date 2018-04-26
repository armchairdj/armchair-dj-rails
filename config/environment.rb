# Load the Rails application.
require_relative 'application'

Dir[Rails.root + "lib/monkey_patches/**/*.rb"].each { |file| require file }

# Initialize the Rails application.
Rails.application.initialize!
