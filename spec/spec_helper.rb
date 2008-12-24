<<<<<<< HEAD:spec/spec_helper.rb
require 'rubygems'
require 'merb-core'
require 'spec' # Satisfies Autotest and anyone else not using the Rake tasks
=======
require "rubygems"

# Add the local gems dir if found within the app root; any dependencies loaded
# hereafter will try to load from the local gems before loading system gems.
if (local_gem_dir = File.join(File.dirname(__FILE__), '..', 'gems')) && $BUNDLE.nil?
  $BUNDLE = true; Gem.clear_paths; Gem.path.unshift(local_gem_dir)
end

require "merb-core"
require "spec" # Satisfies Autotest and anyone else not using the Rake tasks
require(File.dirname(__FILE__) / "spec_helpers.rb")
dependency "faker", "=0.3.1"
>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:spec/spec_helper.rb

# this loads all plugins required in your init file so don't add them
# here again, Merb will do it for you
Merb.start_environment(:testing => true, :adapter => 'runner', :environment => ENV['MERB_ENV'] || 'test')

<<<<<<< HEAD:spec/spec_helper.rb
=======
require File.expand_path(File.dirname(__FILE__) + "/blueprints")

>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:spec/spec_helper.rb
Spec::Runner.configure do |config|
  config.include(Merb::Test::ViewHelper)
  config.include(Merb::Test::RouteHelper)
  config.include(Merb::Test::ControllerHelper)
<<<<<<< HEAD:spec/spec_helper.rb
=======
  config.include(GeoPing::SpecHelpers)
  config.before(:each) do
    Sham.reset
    Provider.delete_all
    Site.delete_all
    Ping.delete_all
  end
>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:spec/spec_helper.rb
end
<<<<<<< HEAD:spec/spec_helper.rb
=======

>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:spec/spec_helper.rb
