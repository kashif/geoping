module GeoPing
  class FormatNotSupported < Merb::Controller::UnsupportedMediaType; end
  class Rpc 
    include RpcRequestFormats
    
    attr_reader :raw, 
                :format, 
                :params, 
                :params_array, 
                :method_name,
                :site_name
                
    cattr_reader :formats
    @@formats = [:xml, :json]
    
    
    def initialize(format, raw)
      raise FormatNotSupported, "GeoPing::Rpc does not support #{format} format" unless Rpc.formats.include?(format)
      @format = format
      @raw    = raw
      process_raw_input
      self
    end
    
    def extended_ping?
      @extended_ping ||= !!(method_name.split(".").last == "extendedPing")
    end
    
    def site_name;      @params[:site_name];      end
    def site_url;       @params[:site_url];       end
    def method_name;    @params[:method_name];    end
    def changes_url;    @params[:changes_url];    end
    def category_name;  @params[:category_name];  end
    def feed_url;       @params[:feed_url];       end
    
    
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
      [:site_name, :site_url].each_with_index do |v,i|
        result[v] = array[i]
      end
      result
    end
    
    # Extracts the extended params from the params array
    def extended_params_from_array(array)
      raise ArgumentError, "Do not recognize as an extended ping #{array.inspect}" if array.size < 4 || array.size > 5
      result = {}
      [:site_name, :site_url, :changes_url, :feed_url].each_with_index do |v,i|
        result[v] = array[i]
      end
      result[:category_name] = array.last if array.size == 5
      result
    end

  end #Rpc
end # GeoPing