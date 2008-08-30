class Resource < ActiveRecord::Base
  validates_length_of :name, :maximum => 1024
  validates_length_of :url, :maximum  => 255
  validates_length_of :changesURL, :maximum => 255
  
  def self.check_spam_from_json(params)
    res = Resource.find_by_url(params[:url])
    res.update_attributes(params) if res.updated_at - (Time.now - 1800) <= 0 
  rescue  
    Resource.create(params)  
  end     
    
end


