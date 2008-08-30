require File.join( File.dirname(__FILE__), '..', "spec_helper" )


module ResourceSpecHelper
  def valid_attributes
    {
      :name       => "myblog",
      :url        => "http://myblog.example.com/",
      :changesURL => "http://myblog.example.com/changes.xml",
      :rssURL     => "http://myblog.example.com/feed",
      :tag        => "blog" 
    }
  end
end  

describe Resource do  

  include ResourceSpecHelper

  before(:each) do    
  end
  
  it "should check url for uniqueness"
  it "should remove traling slashes from the url before saving"
  
  it "should check for spam and not update the resource if last update was < 30min ago" do
    Resource.create(valid_attributes)
    res = Resource.find_by_url(valid_attributes[:url])
    res.update_attributes(:name => "some blog name") 
    time_last_update = res.updated_at
    res.update_attributes(:name => "new blog name") 
    time_last_update.should == res.updated_at
  end  

end