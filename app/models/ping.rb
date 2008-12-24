class Ping < ActiveRecord::Base
  
  # This accessor is for use with forms.  It is only useful for inputting data from forms.
  # The form entry should be of the form :geo => { :lat => 12.34, :long => 56.78 }
  # This will be converted into a Geometric point, and you should use the #geom method
  # To access that
  # 
  # By default if no :geo params are passed into the object, the pings owning sites, providers
  # default_location will be used instead.  
  attr_accessor :geo
  
  validates_presence_of :site
  validate :validate_urls
  
  belongs_to :site
  
  before_create :set_values_from_site
  
  private
  def validate_urls
    validate_fields_as_urls :url, :feed_url, :changes_url
  end # validate_urls
  
  def set_values_from_site
    self.name       = site.name
    self.url        = site.url
    self.feed_url   ||= site.feed_url
    self.geom       ||= geom_from_geo || site.provider.default_location
    true
  end
  
  def geom_from_geo
    return nil if geo.blank?
    GeoRuby::SimpleFeatures::Point.from_coordinates([geo[:long], geo[:lat]],4326)
  end
end