module GeoPing
  class FormatNotSupported < Merb::Controller::UnsupportedMediaType; end
  class Rpc 
    include RpcRequestFormats
    
     METHOD_SIGNATURES = {
      "weblogUpdates.ping" => [:obj, {:name => :str, :url => :str}],
      "weblogUpdates.extendedPing" => [:obj, {:name => :str, :url => :str, :changesURL => :str, :feedURL => :str, :tag => :str}],
      "system.describe" => [:obj, nil]
    }
    #The method signature for an RPC call is:
    #
    # weblogUpdates.ping
    #    {:method_name => "weblogUpdates.ping", :params => ["site name", "site url"]}
    #
    # weblogUpdaetes.extendedPing
    #    {
    #       :method_name => "weblogUpdaets.extendedPing",
    #       :params      => ["site name", "site url", "changes url", "feed url", <"tags">]
    #    }
    #
    #  The <"tags"> paramter is optional and may be left out of the params array
    #
    #  ===Example
    #  ====Ping
    #  =====JSON
    #
    #    {method_name: "weblogUpdates.ping", params: ["site name", "site url"]}
    #
    #  =====XML
    #
    #       <?xml version="1.0"?>
    #       <methodCall>
    #         <methodName>weblogUpdates.ping</methodName>
    #         <params>
    #           <param>
    #             <value>site name</value>
    #           </param>
    #           <param>
    #             <value>site url</value>
    #           </param>
    #         </params>
    #       </methodCall>
    #
    # ====ExtendedPing
    # =====JSON
    #
    #   {
    #       method_name: "weblogUpdaets.extendedPing",
    #       params:      ["site name", "site url", "changes url", "feed url", <"tags">]
    #    }
    #
    #  =====XML
    #     <?xml version="1.0"?>
    #     <methodCall>
    #       <methodName>weblogUpdates.extendedPing</methodName>
    #       <params>
    #         <param>
    #           <value>Someblog</value>
    #         </param>
    #         <param>
    #           <value>http://spaces.msn.com/someblog</value>
    #         </param>
    #         <param>
    #           <value>http://spaces.msn.com/someblog/PersonalSpace.aspx?something</value>
    #         </param>
    #         <param>
    #           <value>http://spaces.msn.com/someblog/feed.rss</value>
    #         </param>
    #         <param>
    #           <value>personal|friends</value>
    #         </param>
    #       </params>
    #     </methodCall>
    
    attr_reader :raw, 
                :format, 
                :params, 
                :params_array
                
    cattr_reader :formats
    @@formats = [:xml, :json]
    
    
    def initialize(format, raw)
      raise FormatNotSupported, "GeoPing::Rpc does not support #{format} format" unless Rpc.formats.include?(format)
      @format = format
      @raw    = raw
      process_raw_input
      self
    end
    
    # Checks to see if a ping is an extended ping or a normal ping.
    def extended_ping?
      @extended_ping ||= !!(method_name.split(".").last == "extendedPing")
    end
    
    # Handy Accessors for the parameters
    def site_name;      @params[:name];           end
    def site_url;       @params[:url];            end
    def method_name;    @params[:method_name];    end
    def changes_url;    @params[:changesURL];     end
    def feed_url;       @params[:feedURL];        end
    def tag;            @params[:tag];            end
    
    
    private 
    # Extracts a ping from the raw input
    def process_raw_input
      result = self.send(:"process_from_#{format}")
      @params_array = result[:params_array]      
      
      @params       = {
        :method_name => result[:method_name]
      }
      
      @params.merge!(extended_ping? ? extended_params_from_array(@params_array) : minimal_params_from_array(@params_array))
    end
    
    # Extracts the minimal params from the params array
    def minimal_params_from_array(array)
      raise ArgumentError, "Do not recognize as a ping #{array.inspect}" unless array.size == 2
      result = {}
      [:name, :url].each_with_index do |v,i|
        result[v] = array[i]
      end
      result
    end
    
    # Extracts the extended params from the params array
    def extended_params_from_array(array)
      raise ArgumentError, "Do not recognize as an extended ping #{array.inspect}" if array.size < 4 || array.size > 5
      result = {}
      [:name, :url, :changesURL, :feedURL].each_with_index do |v,i|
        result[v] = array[i]
      end
      result[:tag] = array.last if array.size == 5
      result
    end

  end #Rpc
end # GeoPing