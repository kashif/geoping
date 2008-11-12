class Provider < ActiveRecord::Base
  validates_presence_of   :identity_url
  validates_uniqueness_of  :identity_url, :allow_blank => true
  
  has_many :sites
  has_many :pings, :through => :sites
end