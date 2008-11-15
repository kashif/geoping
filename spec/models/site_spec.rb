require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "site" do
  before(:each) do
    @site = Site.make
  end
  
  it "should belong to a provider" do
    @site.provider.should be_a_kind_of(Provider)
  end
  
  it "should be invalid without a provider" do
    site = Site.make_unsaved(:provider => nil)
    site.save
    site.errors.on(:provider).should_not be_blank
  end
  
  it "should have a url" do
    @site.url.should_not be_blank
  end
  
  it "should not have an error on url if the url is valid" do
    site = Site.make_unsaved(:url => "http://foo.com")
    site.save
    site.errors.on(:url).should be_blank
  end
  
  it "should check that a url is valid" do
    site = Site.make_unsaved(:url => "not a url")
    site.save
    site.errors.on(:url).should_not be_blank
  end
  
  it "should not have errors for feed_url if feed_url is a valid url" do
    site = Site.make_unsaved(:feed_url => "http://example.com/foo/bar.feed")
    site.save
    site.errors.on(:feed_url).should be_blank
  end
  
  it "should have errors for feed_url if feed_url is not a url" do
    site = Site.make_unsaved(:feed_url => "not a url")
    site.save
    site.errors.on(:feed_url).should_not be_blank
  end
  
  it "should not allow a duplicate url to be saved" do
    s1 = Site.make_unsaved(:url => "http://example.com/foo")
    s2 = Site.make_unsaved(:url => "http://example.com/foo")
    s1.save
    s2.save
    s1.errors.on(:url).should be_blank
    s2.errors.on(:url).should_not be_blank
  end
  
  describe "finding a registered site" do
  end
end