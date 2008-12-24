require File.dirname(__FILE__) + '/../spec_helper'

describe Provider do
    
  it "should be valid at creation" do
    @provider = Provider.make_unsaved
    @provider.save
    @provider.errors.should_not == nil     
  end 
  
  it "requires an identity_url" do
    @provider = Provider.make_unsaved(:identity_url => nil)
    lambda{@provider.save!}.should raise_error
  end

  it "requires a unique identity_url" do
    @provider_1 = Provider.make(:identity_url => "http://provider.id/" )
    @provider_2 = Provider.make_unsaved(:identity_url => "http://provider.id/" )
    lambda{@provider.save!}.should raise_error
  end

  it "complain given an valid url for an identity_url" 
  
  it "can have one or more sites" do
    @provider = Provider.make     
    @provider.sites << [Site.make(:provider => @provider ), Site.make(:provider => @provider )]
    @provider.sites.count.should == 2 
  end

  it "can have one or more pings for any site" do    
    @provider = Provider.make
    @site = Site.make()
  end
end