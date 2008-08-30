class Resource < ActiveRecord::Base
  validates_length_of :name, :maximum => 1024
  validates_length_of :url, :maximum  => 255
  validates_length_of :changesURL, :maximum => 255
  
  def check_spam_form_json(params)
    Resource.create(params) unless
     Resource.find_by_url(params[:url]).updated_at - (Time.now - 1800) <= 0
  end     
    
end


