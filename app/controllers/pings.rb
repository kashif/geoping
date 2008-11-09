class Pings < Application
  
  def create
    only_provides :xml, :json
    raise GeoPing::RestArgumentError unless minimum_arguments?
    
    # Code to save the ping goes in here    
    
    render
  end
  
  private
  def minimum_arguments?
    if params.keys.any?{ |k| [:changes_url, :feed_url, :tag].include?(k.to_sym)}  
      params[:name] && params[:url] && params[:changes_url] && params[:feed_url]
    else
      params[:name] && params[:url]
    end
  end
  
end
