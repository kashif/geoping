class Json < Application
  
  # Force everything to be json
  after :set_json_as_content_type
  after :coerce_response_to_json
  
  # name => {return, params}
   METHOD_SIGNATURES = {
    "weblogUpdates.ping" => [:obj, {:name => :str, :url => :str}],
    "weblogUpdates.extendedPing" => [:obj, {:name => :str, :url => :str, :changesURL => :str, :rssURL => :str, :tag => :str}],
    "system.describe" => [:obj, nil]
  }

  # ...and remember, everything returned from an action
  # goes to the client...
  def index
    unless  METHOD_SIGNATURES.keys.include? params['method']
      return json_error("The target procedure does not exist on the server.", 404)
    end
    handle(params['method'], params['params'])
  end
  
  protected
  
  def handle(meth, rpc_params)
    case meth
    when "weblogUpdates.ping"
      {:flerror => 0, :message => "Thanks for the ping.", 
        :legal=> "You agree that use of the geoping.com ping service is governed by the Terms of Use found at www.geoping.com."}
    when "system.describe"
      json_system_description()
    else
      json_error("#{meth} hasn't been implemented yet")
    end
  end
  
end
