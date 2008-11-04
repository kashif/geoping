require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Geo Ping Reqeusts" do
  
  describe "XML-RPC" do
  
    describe "Minimal Request" do
      before(:each) do
        @raw = <<-XML
          <?xml version="1.0"?>
          <methodCall>
            <methodName>weblogUpdates.ping</methodName>
            <params>
              <param>
                <value>Someblog</value>
              </param>
              <param>
                <value>http://spaces.msn.com/someblog</value>
              </param>
            </params>
          </methodCall>
        XML
        @rpc = GeoPing::Rpc.new(:xml, @raw)
      end
      
      it "should provide the method_name" do
        @rpc.method_name.should == "weblogUpdates.ping"
      end
      
      it "should provide the params in order" do
        @rpc.params_array.should == ["Someblog", "http://spaces.msn.com/someblog"]
      end
      
      it "should provide the params as a hash" do
        @rpc.params.should == {
              :site_name    => "Someblog", 
              :site_url     => "http://spaces.msn.com/someblog", 
              :method_name  => "weblogUpdates.ping"
        }
      end
      
      it "should not be an extended ping" do
        @rpc.should_not be_an_extended_ping
      end
      
      it "should raise an argument error if there are too few arguments" do
        @raw = <<-XML
          <?xml version="1.0"?>
          <methodCall>
            <methodName>weblogUpdates.ping</methodName>
            <params>
              <param>
                <value>Someblog</value>
              </param>
            </params>
          </methodCall>
        XML
        lambda do
          @rpc = GeoPing::Rpc.new(:xml, @raw)
        end.should raise_error(ArgumentError)
      end
      
      it "should raise an argument error if there are too many arguments" do
        @raw = <<-XML
          <?xml version="1.0"?>
          <methodCall>
            <methodName>weblogUpdates.ping</methodName>
            <params>
              <param>
                <value>Someblog</value>
              </param>
              <param>
                <value>http://spaces.msn.com/someblog</value>
              </param>
              <param>
                <value>http://spaces.msn.com/someblog/feed.rss</value>
              </param>
            </params>
          </methodCall>
        XML
        lambda do
          @rpc = GeoPing::Rpc.new(:xml, @raw)
        end.should raise_error(ArgumentError)
      end
      
    end
  
    describe "Extended Request" do
      before(:each) do
        @raw = <<-XML
        <?xml version="1.0"?>
        <methodCall>
          <methodName>weblogUpdates.extendedPing</methodName>
          <params>
            <param>
              <value>Someblog</value>
            </param>
            <param>
              <value>http://spaces.msn.com/someblog</value>
            </param>
            <param>
              <value>http://spaces.msn.com/someblog/PersonalSpace.aspx?something</value>
            </param>
            <param>
              <value>http://spaces.msn.com/someblog/feed.rss</value>
            </param>
            <param>
              <value>personal|friends</value>
            </param>
          </params>
        </methodCall>
        XML
        @rpc = GeoPing::Rpc.new(:xml, @raw)
      end
      
      
      it "should provide the method_name" do
        @rpc.method_name.should == "weblogUpdates.extendedPing"
      end
      
      it "should provide the params in order" do
        @rpc.params_array.should == [
          "Someblog",
          "http://spaces.msn.com/someblog",
          "http://spaces.msn.com/someblog/PersonalSpace.aspx?something",
          "http://spaces.msn.com/someblog/feed.rss",
          "personal|friends"
        ]
      end
      
      it "should have a site_url" do
        @rpc.site_url.should == "http://spaces.msn.com/someblog"
      end
      
      it "should have a changes_url" do
        @rpc.changes_url.should == "http://spaces.msn.com/someblog/PersonalSpace.aspx?something"
      end
      
      it "should have a feed_url" do
        @rpc.feed_url.should == "http://spaces.msn.com/someblog/feed.rss"
      end
      
      it "should have a category_name" do
        @rpc.category_name.should == "personal|friends"
      end
      
      it "should povide the params as a hash" do
        @rpc.params.should == {
          :site_name      => "Someblog", 
          :site_url       => "http://spaces.msn.com/someblog", 
          :method_name    => "weblogUpdates.extendedPing",
          :changes_url    => "http://spaces.msn.com/someblog/PersonalSpace.aspx?something",
          :feed_url       => "http://spaces.msn.com/someblog/feed.rss",
          :category_name  => "personal|friends"
        }
      end
      
      it "should be an extended_ping" do
        @rpc.should be_an_extended_ping
      end
      
      it "should raise an argument error if there are too few arguments" do
        @raw = <<-XML
        <?xml version="1.0"?>
        <methodCall>
          <methodName>weblogUpdates.extendedPing</methodName>
          <params>
            <param>
              <value>Someblog</value>
            </param>
            <param>
              <value>http://spaces.msn.com/someblog</value>
            </param>
            <param>
              <value>http://spaces.msn.com/someblog/PersonalSpace.aspx?something</value>
            </param>
          </params>
        </methodCall>
        XML
        lambda do
          @rpc = GeoPing::Rpc.new(:xml, @raw)
        end.should raise_error(ArgumentError)
      end
      
      it "should raise an argument if there are too many arguments" do
        @raw = <<-XML
        <?xml version="1.0"?>
        <methodCall>
          <methodName>weblogUpdates.extendedPing</methodName>
          <params>
            <param>
              <value>Someblog</value>
            </param>
            <param>
              <value>http://spaces.msn.com/someblog</value>
            </param>
            <param>
              <value>http://spaces.msn.com/someblog/PersonalSpace.aspx?something</value>
            </param>
            <param>
              <value>http://spaces.msn.com/someblog/feed.rss</value>
            </param>
            <param>
              <value>personal|friends</value>
            </param>
            <param>
              <value>An Extra One</value>
            </param>
          </params>
        </methodCall>
        XML
        lambda do
          @rpc = GeoPing::Rpc.new(:xml, @raw)
        end.should raise_error(ArgumentError)
      end
      
      it "should allow for optional arguments to be present" do
        @raw = <<-XML
        <?xml version="1.0"?>
        <methodCall>
          <methodName>weblogUpdates.extendedPing</methodName>
          <params>
            <param>
              <value>Someblog</value>
            </param>
            <param>
              <value>http://spaces.msn.com/someblog</value>
            </param>
            <param>
              <value>http://spaces.msn.com/someblog/PersonalSpace.aspx?something</value>
            </param>
            <param>
              <value>http://spaces.msn.com/someblog/feed.rss</value>
            </param>
            <param>
              <value>personal|friends</value>
            </param>
          </params>
        </methodCall>
        XML
        @rpc = GeoPing::Rpc.new(:xml, @raw)
        @rpc.category_name.should == "personal|friends"
      end
      
      it "should allow for options arguments to be missing" do
        @raw = <<-XML
        <?xml version="1.0"?>
        <methodCall>
          <methodName>weblogUpdates.extendedPing</methodName>
          <params>
            <param>
              <value>Someblog</value>
            </param>
            <param>
              <value>http://spaces.msn.com/someblog</value>
            </param>
            <param>
              <value>http://spaces.msn.com/someblog/PersonalSpace.aspx?something</value>
            </param>
            <param>
              <value>http://spaces.msn.com/someblog/feed.rss</value>
            </param>
          </params>
        </methodCall>
        XML
        @rpc = GeoPing::Rpc.new(:xml, @raw)
        @rpc.category_name.should be_nil
      end
    end
    
  end
end