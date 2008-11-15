class Site < ActiveRecord::Base
  validates_presence_of   :name
  validates_presence_of   :url
  validates_uniqueness_of  :url, :allow_nil => true
  
  belongs_to  :provider
  has_many    :pings
  
  def url
    @url ||= self.domain.to_s + self.base_path
  end
end