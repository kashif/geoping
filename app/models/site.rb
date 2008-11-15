class Site < ActiveRecord::Base
  validates_presence_of     :name
  validates_presence_of     :url
  validates_presence_of     :provider
  validates_uniqueness_of   :url, :allow_nil => true
  
  validate :validate_urls
  
  belongs_to  :provider
  has_many    :pings


  private
  def validate_urls
    validate_fields_as_urls :url, :feed_url
  end # validate_urls
  
end