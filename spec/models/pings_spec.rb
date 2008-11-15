require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Ping do
  before(:each) do
    @ping = Ping.make
  end
  
  # t.string      :name
  # t.string      :url
  # t.string      :changes_url
  # t.string      :feed_url
  # t.integer     :site_id
  # t.column      :geom, :point, :null => false, :srid => 4326
  # t.datetime    :created_at
  
  it "should have a site name" do
    @ping.name.should_not be_blank
  end
  
  it "should have a site" do
    @ping.site.should be_a_kind_of(Site)
  end
  
  it "should raise an error if there is no site" do
    ping = Ping.make_unsaved(:site => nil)
    ping.save
    ping.should be_new_record
    ping.errors.on(:site).should_not be_blank
  end
  
  it "should not raise an error if there is no site name passed in" do
    ping = Ping.make_unsaved(:name => nil)
    ping.save
    ping.errors.on(:name).should be_blank
  end
  
  it "should have the ping name the same as the site name" do
    @ping.name.should == @ping.site.name
  end
  
  it "should have a changes_url" do
    @ping.changes_url.should_not be_blank
  end
  
  it "should not raise an error if there is no changes_url" do
    ping = Ping.make(:changes_url => nil)
    ping.errors.on(:changes_url).should be_blank
  end
  
  it "should have a feed_url" do
    @ping.feed_url.should_not be_nil
  end
  
  it "should not raise an error if there is no feed_url passed in on create" do
    ping = Ping.make(:feed_url => nil)
    ping.errors.on(:feed_url).should be_blank
  end
  
  it "should not use the site feed_url if one is provided" do
    @ping.feed_url.should_not == @ping.site.feed_url
  end
  
  it "should use the feed url from the site" do
    ping = Ping.make(:feed_url => nil)
    ping.feed_url.should == ping.site.feed_url
  end

  it "should not raise an error if there is no url passed in" do
    ping = Ping.make(:url => nil)
    ping.errors.on(:url).should be_nil
  end
  
  it "should use the url of the site when saving the ping" do
    @ping.url.should == @ping.site.url
  end
  
  it "should use save the :geo {:lat => xxx, :long => xxx} into geom" do
    ping = Ping.make(:geom => nil, :geo => {:lat => 1.23, :long => 2.34})
    ping.geom.should be_a_kind_of(GeoRuby::SimpleFeatures::Point)
  end
  
  it "should not use the default location from the provider if the geo is provided" do
    ping = Ping.make(:geom => nil, :geo => {:lat => Sham.lat, :long => Sham.long})
    ping.geom.should_not == ping.site.provider.default_location
  end
  
  it "should use the provider default location if there is no geometric data set" do
    ping = Ping.make(:geom => nil)
    ping.geom.should == ping.site.provider.default_location
  end
  
end

