class Resource < ActiveRecord::Base
  validates_length_of :name, :maximum => 1024
  validates_length_of :url, :maximum  => 255
  validates_length_of :changesURL, :maximum => 255
    
end
