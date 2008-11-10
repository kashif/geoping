require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Geo Ping Reqeusts" do
  
  describe "XML-RPC" do
  
    describe "Minimal Request" do
      before(:each) do
        @raw = valid_ping(:xml)
        @rpc = GeoPing::Rpc.new(:xml, @raw)
      end
      
      it "should provide the method_name" do
        @rpc.method_name.should == "weblogUpdates.ping"
      end
      
      it "should provide the params as a hash" do
        @rpc.params.should == {
              :name         => "Someblog", 
              :url          => "http://spaces.msn.com/someblog", 
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
        end.should raise_error(GeoPing::RpcArgumentError)
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
        end.should raise_error(GeoPing::RpcArgumentError)
      end
      
    end
  
    describe "Extended Request" do
      before(:each) do
        @raw = valid_extended_ping(:xml, :tag => "personal|friends")
        @rpc = GeoPing::Rpc.new(:xml, @raw)
      end
          
      it "should provide the method_name" do
        @rpc.method_name.should == "weblogUpdates.extendedPing"
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
      
      it "should have a tag" do
        @rpc.tag.should == "personal|friends"
      end
      
      it "should povide the params as a hash" do
        @rpc.params.should == {
          :name           => "Someblog", 
          :url            => "http://spaces.msn.com/someblog", 
          :method_name    => "weblogUpdates.extendedPing",
          :changes_url     => "http://spaces.msn.com/someblog/PersonalSpace.aspx?something",
          :feed_url        => "http://spaces.msn.com/someblog/feed.rss",
          :tag  => "personal|friends"
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
        end.should raise_error(GeoPing::RpcArgumentError)
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
        end.should raise_error(GeoPing::RpcArgumentError)
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
        @rpc.tag.should == "personal|friends"
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
        @rpc.tag.should be_nil
      end
    end
  end
  
  describe "JSON Rpc" do
    describe "minimal request" do
      before(:each) do
        @raw = valid_ping(:json)
        @rpc = GeoPing::Rpc.new(:json, @raw)
      end
      
      it "should provide the method_name" do
        @rpc.site_name.should == "Someblog"
      end

      it "should provide the params as a hash" do
        @rpc.params.should == {
          :name         => "Someblog", 
          :url          => "http://spaces.msn.com/someblog", 
          :method_name  => "weblogUpdates.ping"
        }
      end
      
      it "should not be an extended ping" do
        @rpc.should_not be_an_extended_ping
      end
      
      it "should raise an argument error if there are too few arguments" do
        raw = {:method_name => "weblogUpdates.ping", :params => ["Someblog"]}
        lambda do
          GeoPing::Rpc.new(:json, JSON.generate(raw))
        end.should raise_error(GeoPing::RpcArgumentError)
      end
      
      it "should raise an argument error if there are too many arguments" do
        raw = {:method_name => "weblogUpdates.ping", :params => ["Someblog", "http://example.com", "http://example.com"]}
        lambda do
          GeoPing::Rpc.new(:json, JSON.generate(raw))
        end.should raise_error(GeoPing::RpcArgumentError)
      end
      
    end

    describe "extended request" do
      before(:each) do
        @raw = valid_extended_ping(:json, :tag => "personal|friends")
        @rpc = GeoPing::Rpc.new(:json, @raw)
      end
      
      it "should provide the method_name" do
        @rpc.method_name.should == "weblogUpdates.extendedPing"
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
      
      it "should have a tag" do
        @rpc.tag.should == "personal|friends"
      end
      
      it "should povide the params as a hash" do
        @rpc.params.should == {
          :name           => "Someblog", 
          :url            => "http://spaces.msn.com/someblog", 
          :method_name    => "weblogUpdates.extendedPing",
          :changes_url     => "http://spaces.msn.com/someblog/PersonalSpace.aspx?something",
          :feed_url        => "http://spaces.msn.com/someblog/feed.rss",
          :tag  => "personal|friends"
        }
      end
      
      it "should be an extended_ping" do
        @rpc.should be_an_extended_ping
      end
      
      it "should raise an argument error if there are too few arguments" do
        raw = {
          :method_name  => "weblogUpdates.extendedPing",
          :params       => [
            "Someblog", 
            "http://spaces.msn.com/someblog",
            "http://spaces.msn.com/someblog/PersonalSpace.aspx?something"
          ]
        }
        lambda do
          @rpc = GeoPing::Rpc.new(:json, JSON.generate(raw))
        end        
      end
      
      it "should raise an argument if there are too many arguments" do
        raw = {
          :method_name  => "weblogUpdates.extendedPing",
          :params       => [
            "Someblog", 
            "http://spaces.msn.com/someblog",
            "http://spaces.msn.com/someblog/PersonalSpace.aspx?something",
            "http://spaces.msn.com/someblog/feed.rss",
            "personal|friends",
            "some other parameter"
          ]
        }
        lambda do
          @rpc = GeoPing::Rpc.new(:json, JSON.generate(raw))
        end
      end
      
      it "should allow for optional arguments to be present" do
        raw = {
          :method_name  => "weblogUpdates.extendedPing",
          :params       => [
            "Someblog", 
            "http://spaces.msn.com/someblog",
            "http://spaces.msn.com/someblog/PersonalSpace.aspx?something",
            "http://spaces.msn.com/someblog/feed.rss",
            "personal|friends"
          ]
        }
        @rpc = GeoPing::Rpc.new(:json, JSON.generate(raw))
        @rpc.tag.should == "personal|friends"
      end
      
      it "should allow for options arguments to be missing" do
        raw = {
          :method_name  => "weblogUpdates.extendedPing",
          :params       => [
            "Someblog", 
            "http://spaces.msn.com/someblog",
            "http://spaces.msn.com/someblog/PersonalSpace.aspx?something",
            "http://spaces.msn.com/someblog/feed.rss"
          ]
        }
        @rpc = GeoPing::Rpc.new(:json, JSON.generate(raw))
        @rpc.tag.should be_nil
      end
      
    end #  "extended request"
  end # "JSON Rpc" 
  
  describe "geoPing" do
    [:json, :xml].each do |fmt|
      describe "#{fmt}" do
        before(:each) do
          @raw = valid_geo_ping(fmt)
          @rpc = GeoPing::Rpc.new(fmt, @raw)
        end
    
        it "should provide the method_name" do
          @rpc.method_name.should == "weblogUpdates.geoPing"
        end
        
        it "should provide the params as a hash" do
          @rpc.params.should == {
                :name         => "Someblog", 
                :url          => "http://spaces.msn.com/someblog", 
                :method_name  => "weblogUpdates.geoPing",
                :geo          => {"lat" => 1.2343, "long" => 2.344}
          }
        end
        
        it "should not be an extended ping" do
          @rpc.should_not be_an_extended_ping
        end
        
        it "should provide the lat/long" do
          @rpc.geo.should == {"lat" => 1.2343, "long" => 2.344}
        end
      end
    end # [:json, :xml] 
  end # geoPing
  
  describe "extendedGeoPing" do
    [:json, :xml].each do |fmt|
      describe "#{fmt}" do
        before(:each) do
          @raw = valid_extended_geo_ping(fmt, :tag => "personal|friends")
          @rpc = GeoPing::Rpc.new(fmt, @raw)
        end
        
        it "should provide the method_name" do
          @rpc.method_name.should == "weblogUpdates.extendedGeoPing"
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

        it "should have a tag" do
          @rpc.tag.should == "personal|friends"
        end

        it "should have a geo hash" do
          @rpc.geo.should == {"lat" => 1.2343, "long" => 2.344}
        end
          
        it "should povide the params as a hash" do
          @rpc.params.should == {
            :name           => "Someblog", 
            :url            => "http://spaces.msn.com/someblog", 
            :method_name    => "weblogUpdates.extendedGeoPing",
            :changes_url    => "http://spaces.msn.com/someblog/PersonalSpace.aspx?something",
            :feed_url       => "http://spaces.msn.com/someblog/feed.rss",
            :tag            => "personal|friends",
            :geo            => {"lat" => 1.2343, "long" => 2.344}
          }
          
        end
        
      end # fmt
    end # [:json,:xml]
  end
  
end