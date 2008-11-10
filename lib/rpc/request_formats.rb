module GeoPing
  module Version1_0_0
    module RpcRequestFormats
      # Make a "process_from_#{format} method for each input type"
    
      # Get the mothod name, and the params array from the raw post
      def process_from_xml
        doc = Nokogiri::XML(@raw)
        out = {}
        out[:method_name]   = doc.css("methodCall methodName").text
        out[:params_array]  = doc.css("methodCall params param").map do |n|
          if n.css("value lat").blank?
            n.css("value").text
          else
            # This is a geo attribute
            {"lat" => n.css("value lat").text.to_f, "long" => n.css("value long").text.to_f}
          end
        end
        out
      end
    
      def process_from_json
        raw = JSON.parse(@raw)
        out = {}
        out[:method_name]   = raw["method_name"]
        out[:params_array]  = raw["params"] || []
        out
      end
    
    end # GeoPing
  end #Version1_0_0
  RpcRequestFormats = Version1_0_0::RpcRequestFormats
end # RequestFormats