class Site < ActiveRecord::Base
  validates_presence_of   :name
  validates_presence_of   :domain
  validates_uniqueness_of  :domain, :allow_blank => true
  
  belongs_to  :provider
  has_many    :pings
end