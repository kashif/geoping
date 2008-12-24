# Merb::Router is the request routing mapper for the merb framework.
#
# You can route a specific URL to a controller / action pair:
#
<<<<<<< HEAD:config/router.rb
#   r.match("/contact").
=======
#   match("/contact").
>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:config/router.rb
#     to(:controller => "info", :action => "contact")
#
# You can define placeholder parts of the url with the :symbol notation. These
# placeholders will be available in the params hash of your controllers. For example:
#
<<<<<<< HEAD:config/router.rb
#   r.match("/books/:book_id/:action").
=======
#   match("/books/:book_id/:action").
>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:config/router.rb
#     to(:controller => "books")
#   
# Or, use placeholders in the "to" results for more complicated routing, e.g.:
#
<<<<<<< HEAD:config/router.rb
#   r.match("/admin/:module/:controller/:action/:id").
=======
#   match("/admin/:module/:controller/:action/:id").
>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:config/router.rb
#     to(:controller => ":module/:controller")
#
<<<<<<< HEAD:config/router.rb
=======
# You can specify conditions on the placeholder by passing a hash as the second
# argument of "match"
#
#   match("/registration/:course_name", :course_name => /^[a-z]{3,5}-\d{5}$/).
#     to(:controller => "registration")
#
>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:config/router.rb
# You can also use regular expressions, deferred routes, and many other options.
# See merb/specs/merb/router.rb for a fairly complete usage sample.

Merb.logger.info("Compiling routes...")
<<<<<<< HEAD:config/router.rb
Merb::Router.prepare do |r|
  # RESTful routes
  # r.resources :posts
=======
Merb::Router.prepare do
>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:config/router.rb

<<<<<<< HEAD:config/router.rb
  # This is the default route for /:controller/:action/:id
  # This is fine for most cases.  If you're heavily using resource-based
  # routes, you may want to comment/remove this line to prevent
  # clients from calling your create or destroy actions with a GET
  r.default_routes
=======
  # Munge the data from the rpc request
  match("/api/rpc/:format", :method => :post).defer_to do |request, params|
    params[:controller] = "pings"
    params[:action]     = "create"
    request.params[:format] = params[:format]
    params.merge!(GeoPing::Rpc.new(params[:format].to_sym, request.raw_post).params)
    params
  end
  
  # Match the routes for a RESTful ping
  match("/pings(.:format)", :method => :post).to(:controller => "pings", :action => "create")
>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:config/router.rb
  
<<<<<<< HEAD:config/router.rb
  # Change this for your home page to be available at /
  # r.match('/').to(:controller => 'whatever', :action =>'index')
=======
  # Adds the required routes for merb-auth using the password slice
  # slice(:merb_auth_slice_password, :name_prefix => nil, :path => "")
>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:config/router.rb
end