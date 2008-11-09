class Exceptions < Merb::Controller
  
  # handle NotFound exceptions (404)
  def not_found
    render :format => :html
  end

  # handle NotAcceptable exceptions (406)
  def not_acceptable
    render :format => :html
  end
  
  def rpc_argument_error
    only_provides :xml, :json
    @error_type = "#{content_type.to_s.upcase}RPCError"
    render
  end

  def rest_argument_error
    only_provides :xml, :json
    @error_type = "#{content_type.to_s.upcase}RESTError"
    render :rpc_argument_error
  end
  
end