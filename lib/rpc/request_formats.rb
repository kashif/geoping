module GeoPing
  module RpcRequestFormats
    # Make a "process_from_#{format} method for each input type"
    
    # Get the mothod name, and the params array from the raw post
    def process_from_xml
      doc = Nokogiri::XML(@raw)
      out = {}
      out[:method_name]   = doc.css("methodCall methodName").text
      out[:params_array]  = doc.css("methodCall params param").map{|n| n.css("value").text}
      out
    end
    
    def process_from_json
      raw = JSON.parse(@raw)
      out = {}
      out[:method_name]   = raw["method_name"]
      out[:params_array] = raw["params"] || []
      out
    end
    
  end # GeoPing
end # RequestFormats