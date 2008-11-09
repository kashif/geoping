require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
require 'hpricot'

describe Pings do
  
  before(:each) do
  end
  
  describe "Ping" do
    describe "RPC" do
      [:xml, :json].each do |fmt|
        describe "#{fmt}" do
          it "should recieve an #{fmt} ping" do
            response = request("/api/rpc/#{fmt}", :method => "POST", :input => valid_ping(fmt))
            response.status.should == 200
            compare_result(fmt, response.body.to_s, rpc_valid_response(fmt))
          end
  
          it "should respond with an error for an invalid ping" do
            response = request("/api/rpc/#{fmt}", :method => "POST", :input => invalid_request(fmt))
            response.status.should == 400
            compare_result(fmt, response.body.to_s, rpc_invalid_response(fmt))
          end
  
          it "should respond with an error for an invalid ping if missing the method name" do
            raw = general_rpc_request(fmt, :params => %w(SomeBlog http://example.com))
            response = request("/api/rpc/#{fmt}", :method => "POST", :input => raw)
            response.status.should == 400
            compare_result(fmt, response.body.to_s, rpc_invalid_response(fmt))
          end
  
          it "should respond with an error for an invalid ping if missing the site name" do
            raw = general_rpc_request(fmt, 
                                      :method_name  => "weblogUpdates.ping",
                                      :params       => %w(http://example.com))

            response = request("/api/rpc/#{fmt}", :method => "POST", :input => raw)
            response.status.should == 400
            compare_result(fmt, response.body.to_s, rpc_invalid_response(fmt))
          end
  
          it "should respond with an error for an invalid ping if missing the site url" do
            raw = general_rpc_request(fmt,
                                      :method_name  => "weblogUpdates.ping",
                                      :params       => ["SomeBlog"])
            response = request("/api/rpc/#{fmt}", :method => "POST", :input => raw)
            response.status.should == 400
            compare_result(fmt, response.body.to_s, rpc_invalid_response(fmt))
          end
  
          it "should respond with an error for an invlaid ping if it has an extra parameter" do
            raw = general_rpc_request(fmt,
              :method_name  => "weblogUpdates.ping",
              :params       => ["SomeBlog", "http://example.com", "Some Extra Param"]
            )
            response = request("/api/rpc/#{fmt}", :method => "POST", :input => raw)
            response.status.should == 400
            compare_result(fmt, response.body.to_s, rpc_invalid_response(fmt))
          end
        end # fmt
      end # [:json, :xml].each
    end # RPC
      
    describe "REST" do
      before(:each) do
        @rp = {
          :name => "SomeBlog",
          :url  => "http://example.com"
        }
      end
      [:json, :xml].each do |fmt|
      describe "#{fmt}" do
          it "should recieve a ping" do
            response = request("/pings.#{fmt}", :method => "POST", :params => @rp)
            response.should be_successful
            compare_result(fmt, response.body.to_s, rpc_valid_response(fmt))
          end
        
          it "should respond with an error for an invalid ping if missing the site name" do
            @rp.delete(:name)
            response = request("/pings.#{fmt}", :method => "POST", :params => @rp)
            response.status.should == 400
            compare_result(fmt, response.body.to_s, rpc_invalid_response(fmt, "REST"))
          end
        
          it "should respond with an error for an invalid ping if missing the site url" do
            @rp.delete(:url)
            response = request("/pings.#{fmt}", :method => "POST", :params => @rp)
            response.status.should == 400
            compare_result(fmt, response.body.to_s, rpc_invalid_response(fmt, "REST"))
          end
        end # fmt
      end # [:json, :xml]
    end # REST
      
  end # "ping"
  
  describe "extended PING" do
    describe "RPC" do
      [:json, :xml].each do |fmt|
        describe "#{fmt}" do
          it "should recieve an #{fmt} ping" do
            response = request("/api/rpc/#{fmt}", :method => "POST", :input => valid_extended_ping(fmt))
            response.status.should == 200
            compare_result(fmt, response.body.to_s, rpc_valid_response(fmt))
          end
        
          it "should respond with an error for an invalid ping" do
            response = request("/api/rpc/#{fmt}", :method => "POST", :input => invalid_request(fmt))
            response.status.should == 400
            compare_result(fmt, response.body.to_s, rpc_invalid_response(fmt))
          end
        
          it "should respond with an error for an invalid ping if missing the method name" do
            raw = general_rpc_request(fmt, :params => %w(SomeBlog http://example.com))
            response = request("/api/rpc/#{fmt}", :method => "POST", :input => raw)
            response.status.should == 400
            compare_result(fmt, response.body.to_s, rpc_invalid_response(fmt))
          end
        
          it "should respond with an error for an invalid ping if missing the site name" do
            raw = general_rpc_request(fmt, 
                                      :method_name  => "weblogUpdates.ping",
                                      :params       => ["http://example.com","http://example.com/changes", "http://example.com/changes.feed"])

            response = request("/api/rpc/#{fmt}", :method => "POST", :input => raw)
            response.status.should == 400
            compare_result(fmt, response.body.to_s, rpc_invalid_response(fmt))
          end
        
          it "should respond with an error for an invalid ping if missing the site url" do
            raw = general_rpc_request(fmt, 
                                      :method_name  => "weblogUpdates.ping",
                                      :params       => ["SomeBlog","http://example.com/changes", "http://example.com/changes.feed"])

            response = request("/api/rpc/#{fmt}", :method => "POST", :input => raw)
            response.status.should == 400
            compare_result(fmt, response.body.to_s, rpc_invalid_response(fmt))
          end
        
          it "should respond with an error for an invlaid ping is missing the changes url" do
            raw = general_rpc_request(fmt, 
                                      :method_name  => "weblogUpdates.ping",
                                      :params       => ["SomeBlog","http://example.com", "http://example.com/changes.feed"])

            response = request("/api/rpc/#{fmt}", :method => "POST", :input => raw)
            response.status.should == 400
            compare_result(fmt, response.body.to_s, rpc_invalid_response(fmt))
          end
        
          it "should respond with an error for an invlaid ping is missing the feed url" do
            raw = general_rpc_request(fmt, 
                                      :method_name  => "weblogUpdates.ping",
                                      :params       => ["SomeBlog","http://example.com", "http://example.com/changes"])

            response = request("/api/rpc/#{fmt}", :method => "POST", :input => raw)
            response.status.should == 400
            compare_result(fmt, response.body.to_s, rpc_invalid_response(fmt))
          end
        
          it "should allow for tags to be sent" do
            raw = general_rpc_request(fmt, 
                                      :method_name  => "weblogUpdates.ping",
                                      :params       => ["SomeBlog","http://example.com", 
                                                        "http://example.com/changes",
                                                        "http://example.com/changes.feed",
                                                        "public|private"])

            response = request("/api/rpc/#{fmt}", :method => "POST", :input => raw)
            response.status.should == 400
            compare_result(fmt, response.body.to_s, rpc_invalid_response(fmt))
          end
        
        end # Formats
      end # [:json, :xml]
    end # RPC
    
    describe "REST" do
      [:json, :xml].each do |fmt|
        describe "REST #{fmt}" do
          before(:each) do
            @vp = {
              :name         => "SomeBlog",
              :url          => "http://example.com",
              :changes_url  => "http://example.com/changes",
              :feed_url     => "http://example.com/changes.feed" 
            }
          end
          
          it "should recieve an #{fmt} ping" do
            response = request("/pings.#{fmt}", :method => "POST", :params => @vp)
            response.status.should == 200
            compare_result(fmt, response.body.to_s, rpc_valid_response(fmt))
          end
                    
          it "should respond with an error for an invalid ping if missing the site name" do
            @vp.delete(:name)
            response = request("/pings.#{fmt}", :method => "POST", :params => @vp)
            response.status.should == 400
            compare_result(fmt, response.body.to_s, rpc_invalid_response(fmt, "REST"))
          end
                    
          it "should respond with an error for an invalid ping if missing the site url" do
            @vp.delete(:url)
            response = request("/pings.#{fmt}", :method => "POST", :params => @vp)
            response.status.should == 400
            compare_result(fmt, response.body.to_s, rpc_invalid_response(fmt, "REST"))
          end
          
          it "should respond with an error for an invlaid ping is missing the changes url" do
            @vp.delete(:changes_url)
            response = request("/pings.#{fmt}", :method => "POST", :params => @vp)
            response.status.should == 400
            compare_result(fmt, response.body.to_s, rpc_invalid_response(fmt, "REST"))
          end
          
          it "should respond with an error for an invlaid ping is missing the feed url" do
            @vp.delete(:feed_url)
            response = request("/pings.#{fmt}", :method => "POST", :params => @vp)
            response.status.should == 400
            compare_result(fmt, response.body.to_s, rpc_invalid_response(fmt, "REST"))
          end
          
          it "should allow for tags to be sent" do
            @vp[:tag] = "some tag"
            response = request("/pings.#{fmt}", :method => "POST", :params => @vp)
            response.status.should == 200
            compare_result(fmt, response.body.to_s, rpc_valid_response(fmt))
          end
          
        end # REST fmt
      end # [:json, :xml]
    end # REST
    
  end # extended PING
  
end