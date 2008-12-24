<<<<<<< HEAD:app/controllers/exceptions.rb
class Exceptions < Application
=======
class Exceptions < Merb::Controller
>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:app/controllers/exceptions.rb
  
  # handle NotFound exceptions (404)
  def not_found
    render :format => :html
  end

  # handle NotAcceptable exceptions (406)
  def not_acceptable
    render :format => :html
  end
<<<<<<< HEAD:app/controllers/exceptions.rb
=======
  
  def rpc_argument_error
    only_provides :xml, :json
    @error_type = "#{content_type.to_s.upcase}RPCError"
    render
  end
>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:app/controllers/exceptions.rb

<<<<<<< HEAD:app/controllers/exceptions.rb
=======
  def rest_argument_error
    only_provides :xml, :json
    @error_type = "#{content_type.to_s.upcase}RESTError"
    render :rpc_argument_error
  end
  
>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:app/controllers/exceptions.rb
end