module GeoPing
  
  class FormatNotSupported < Merb::Controller::UnsupportedMediaType; end
  class RpcArgumentError < Merb::Controller::BadRequest; end
  class RestArgumentError < Merb::Controller::BadRequest; end
  
  module Version1_0_0
    class Rpc
      include RpcRequestFormats
          
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
      #
      # ===Using Geographical Information in the Ping
      #
      # To use geographical information in your ping, simply include a hash, json object with two attributes
      # lat, and long corresponding to latetude and longitude.
      #
      # weblogUpdates.geoPing
      #    {:method_name => "weblogUpdates.ping", :params => ["site name", "site url", {"lat" => 1.23, "long" => 2.34}]}
      #
      # weblogUpdaetes.extendedGeoPing
      #    {
      #       :method_name => "weblogUpdaets.extendedPing",
      #       :params      => ["site name", "site url", "changes url", "feed url", {"lat" => 1.23, "long" => 2.34}, <"tags">]
      #    }
      #
      #  The <"tags"> paramter is optional and may be left out of the params array
      # 
      #  ===Example
      #  ====Ping
      #  =====JSON
      #
      #    {method_name: "weblogUpdates.geoPing", params: ["site name", "site url",{lat: 1.23, long: 2.34}]}
      #
      #  =====XML
      #
      #       <?xml version="1.0"?>
      #       <methodCall>
      #         <methodName>weblogUpdates.geoPing</methodName>
      #         <params>
      #           <param>
      #             <value>site name</value>
      #           </param>
      #           <param>
      #             <value>site url</value>
      #           </param>
      #           <param>
      #             <value>
      #               <lat>1.23</lat>
      #               <long>2.34</long>
      #             </value>
      #           </param>
      #         </params>
      #       </methodCall>
      #
      # ====ExtendedPing
      # =====JSON
      #
      #   {
      #       method_name: "weblogUpdaets.extendedGeoPing",
      #       params:      ["site name", "site url", "changes url", "feed url",{lat: 1.23, long: 2.34}, <"tags">]
      #    }
      #
      #  =====XML
      #     <?xml version="1.0"?>
      #     <methodCall>
      #       <methodName>weblogUpdates.extendedGeoPing</methodName>
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
      #           <param>
      #             <value>
      #               <lat>1.23</lat>
      #               <long>2.34</long>
      #             </value>
      #           </param>
      #         <param>
      #           <value>personal|friends</value>
      #         </param>
      #       </params>
      #     </methodCall>
      #
      
    
      attr_reader :raw, 
                  :format, 
                  :params, 
                  :params_array
                
      cattr_reader :formats
      @@formats = [:xml, :json]
      
      VALID_METHODS = ["weblogUpdates.ping", "weblogUpdates.extendedPing", "weblogUpdates.geoPing", "weblogUpdates.extendedGeoPing"]
    
    
      def initialize(format, raw)
        raise FormatNotSupported, "GeoPing::Rpc does not support #{format} format" unless Rpc.formats.include?(format)
        @format = format
        @raw    = raw
        process_raw_input
        self
      end
    
      # Checks to see if a ping is an extended ping or a normal ping.
      def extended_ping?
        @extended_ping ||= !!(method_name.to_s =~ /extendedPing$/)
      end
    
      # Handy Accessors for the parameters
      def site_name;      @params[:name];            end
      def site_url;       @params[:url];             end
      def method_name;    @params[:method_name];     end
      def changes_url;    @params[:changes_url];     end
      def feed_url;       @params[:feed_url];        end
      def tag;            @params[:tag];             end
      def geo;            @params[:geo].to_mash;     end
    
      private 
      # Extracts a ping from the raw input
      def process_raw_input
        result = self.send(:"process_from_#{format}")
        @params_array = result[:params_array]      
        raise RpcArgumentError, "Unknown method #{result[:method_name]}" unless VALID_METHODS.include?(result[:method_name])
        @params       = {
          :method_name => result[:method_name]
        }
        rpc_params = case result[:method_name]
        when /\.ping$/
          minimal_params_from_array(@params_array)
        when /\.extendedPing$/
          extended_params_from_array(@params_array)
        when /\.geoPing$/
          minimal_params_from_array_with_geo(@params_array)
        when /\.extendedGeoPing$/
          extended_params_from_array_with_geo(@params_array)
        end
        
        @params.merge!(rpc_params)
      end
    
      # Extracts the minimal params from the params array
      def minimal_params_from_array(array)
        array_to_params array,  :array_size => (2..2),
                                :arguments  => [:name, :url]
      end
      
      def minimal_params_from_array_with_geo(array)
        array_to_params array,  :array_size   => (3..3),
                                :arguments    => [:name, :url, :geo]
          
      end
    
      # Extracts the extended params from the params array
      def extended_params_from_array(array)
        array_to_params array,  :array_size         => (4..5),  
                                :arguments          => [:name, :url, :changes_url, :feed_url],
                                :optional_arguments => [:tag]
      end
      
      # Extracts the extended params from the params array
      def extended_params_from_array_with_geo(array)
        array_to_params array,  :array_size         => (5..6),  
                                :arguments          => [:name, :url, :changes_url, :feed_url, :geo],
                                :optional_arguments => [:tag]
      end
      
      def array_to_params(array, opts)
        raise RpcArgumentError, "Do not recognize as a ping #{array.inspect}" unless opts[:array_size].include?(array.size) 
        result = {}
        opts[:arguments].each do |v|
          result[v] = array.shift
        end
        if opts[:optional_arguments]
          opts[:optional_arguments].each do |elem|
            result[elem] = array.shift unless array.blank?
          end
        end
        result
      end

    end #Rpc
  end # Version1_0_0
  Rpc = Version1_0_0::Rpc
end # GeoPing