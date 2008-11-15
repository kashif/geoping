class Ping < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :url
  validates_presence_of :site
  
  belongs_to :site
  
end