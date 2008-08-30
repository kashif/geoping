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
  def invalid_attributes
    {
      :name       => "",
      :url        => "http:",
      :changesURL => "htt.example.com/changes.xml",
      :rssURL     => "htt.com/feed",
      :tag        => "blog" 
    }
  end

end  

describe Resource do  

  include ResourceSpecHelper

  before(:each) do    
  end
  
  # it "should check url for uniqueness"                            
  #   
  #   it "should remove traling slashes from the url before saving"
    
  describe "#check_for_spam_from_json" do
    it "should create a resource if not there" do
      count_before = Resource.count
      Resource.check_spam_from_json(valid_attributes)
      Resource.count - count_before == 1
    end
    
    it "should update a pinged resource that was last updated > 30min" do
      res = Resource.create(valid_attributes)
      last_updated_at = (Time.now - 1810)      
      
      puts "\nlast updated: #{last_updated_at}" # check last updated at
      
      Resource.record_timestamps = false # don't forget to reset to true

      res.update_attributes(:updated_at => last_updated_at)
      puts "before ping: #{res.updated_at}" # check updated at was correctly set
      
      Resource.record_timestamps = true 
      
      Resource.check_spam_from_json(valid_attributes)    
      res = Resource.find_by_url(valid_attributes[:url])
      res.updated_at > (last_updated_at)
      puts "after ping: #{res.updated_at}"  # check the new time stamp has a diff of atleast 30min 
    end

    it "should not update a pinged resource that was last updated < 30min ago" do
      res = Resource.create(valid_attributes)
      last_updated_at = res.updated_at
      Resource.check_spam_from_json(valid_attributes)
      res = Resource.find_by_url(valid_attributes[:url])
      res.updated_at == (last_updated_at)  
    end
    
  end

end