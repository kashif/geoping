<<<<<<< HEAD:config/rack.rb

=======
>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:config/rack.rb
# use PathPrefix Middleware if :path_prefix is set in Merb::Config
if prefix = ::Merb::Config[:path_prefix]
  use Merb::Rack::PathPrefix, prefix
end

# comment this out if you are running merb behind a load balancer
# that serves static files
use Merb::Rack::Static, Merb.dir_for(:public)

# this is our main merb application
run Merb::Rack::Application.new