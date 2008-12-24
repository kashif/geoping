module GeoPing
  module SpecHelpers
    
    def valid_ping(format = :xml, opts = {})
      opts = opts.dup
      opts[:method] ||= "weblogUpdates.ping"
      opts[:name]   ||= "Someblog"
      opts[:url]    ||= "http://spaces.msn.com/someblog"
      self.send(:"valid_#{format}_ping", opts)
    end # valid_ping
    
    def valid_extended_ping(format = :xml,  opts = {})
      opts = opts.dup
      opts[:method]        ||= "weblogUpdates.extendedPing"
      opts[:name]          ||= "Someblog"
      opts[:url]           ||= "http://spaces.msn.com/someblog"
      opts[:changes_url]   ||= "http://spaces.msn.com/someblog/PersonalSpace.aspx?something"
      opts[:feed_url]      ||= "http://spaces.msn.com/someblog/feed.rss"
      self.send(:"valid_#{format}_extended_ping", opts)
    end # valid_extended_ping
    
    def valid_geo_ping(format = :xml, opts = {})
      opts = opts.dup
      opts[:method] ||= "weblogUpdates.geoPing"
      opts[:name]   ||= "Someblog"
      opts[:url]    ||= "http://spaces.msn.com/someblog"
      opts[:geo]    ||= {:lat => 1.2343, :long => 2.344}
      self.send(:"valid_#{format}_geo_ping", opts)
    end
    
    def valid_extended_geo_ping(format = :xml,  opts = {})
      opts = opts.dup
      opts[:method]        ||= "weblogUpdates.extendedGeoPing"
      opts[:name]          ||= "Someblog"
      opts[:url]           ||= "http://spaces.msn.com/someblog"
      opts[:changes_url]   ||= "http://spaces.msn.com/someblog/PersonalSpace.aspx?something"
      opts[:feed_url]      ||= "http://spaces.msn.com/someblog/feed.rss"
      opts[:geo]           ||= {:lat => 1.2343, :long => 2.344}
      self.send(:"valid_#{format}_extended_geo_ping", opts)
    end # valid_extended_ping
    
    def rpc_valid_response(format)
      self.send(:"rpc_valid_response_#{format}")
    end
    
    def rpc_invalid_response(format, type = "RPC")
      self.send(:"rpc_invalid_response_#{format}", type)
    end
    
    def general_rpc_request(format, opts = {})
      self.send(:"general_rpc_request_#{format}", opts)
    end
    
    def compare_result(format, result, expected)
      self.send(:"compare_result_#{format}", result, expected)
    end
    
    def invalid_request(format)
      self.send(:"invalid_request_#{format}")
    end
    
    private
    
    def invalid_request_xml
      "<some>request</some>"
    end
    
    def invalid_request_json
      "{\"some\": \"request\"}"
    end
    
    def compare_result_xml(result, expected)
      Nokogiri::XML(result).to_s.should == Nokogiri::XML(expected).to_s
    end
    
    def compare_result_json(result, expected)
      JSON.parse(result).to_s.should == JSON.parse(expected).to_s
    end
    
    
    def general_rpc_request_xml(opts)
      raw = "<methodCall>"
      raw << "<methodName>#{opts[:method_name]}</methodName>" if opts[:method_name]
      unless opts[:params].blank?
        raw << "<params>"
        opts[:params].each do |v|
          raw << "<param><value>#{v}</value></param>"
        end
        raw << "</params>"
      end
      raw << "</methodCall>"
    end
    
    def general_rpc_request_json(opts)
      JSON.generate(opts)
    end    
    
    def rpc_valid_response_xml
      raw =<<-XML
<?xml version="1.0"?>
<methodResponse>
  <params>
    <param>
      <value>
        <struct>
          <member>
            <name>flerror</name>
            <value>
              <boolean>0</boolean>
            </value>
          </member>
          <member>
            <name>message</name>
            <value>Thanks for the ping.</value>
          </member>
          <member>
            <name>legal</name>
            <value>You agree that use of the GeoPing.com ping service is governed by the Terms of Use found at www.geoping.com.</value>
          </member>
        </struct>
      </value>
    </param>
  </params>
</methodResponse>
XML
    end
    
    def rpc_valid_response_json
      raw = {
        :flerror  => 0, 
        :message  => "Thanks for the ping", 
        :legal    => "You agree that use of the GeoPing.com ping service is governed by the Terms of Use found at www.geoping.com."
      }
      JSON.generate(raw)
    end
    
    def rpc_invalid_response_xml(type)
      raw =<<-XML
<?xml version="1.0"?>
<methodResponse>
  <params>
    <param>
      <value>
        <struct>
          <member>
            <name>version</name>
            <value>
              <boolean>#{GeoPing::VERSION}</boolean>
            </value>
          </member>
          <member>
            <name>error</name>
            <struct>
              <member>
                <name>name</name>
                <value>XML#{type}Error</value>
              </member>
              <member>
                <name>code</name>
                <value>0</value>
              </member>
              <member>
                <name>message</name>
                <value>Do not recognize as a ping</value>
              </member>
            </struct>
          </member>
        </struct>
      </value>
    </param>
  </params>
</methodResponse>
XML
            
    end
    
    def rpc_invalid_response_json(type)
      raw = {
        "version" => GeoPing::VERSION,
        "error" => {
          "name" => "JSON#{type}Error",
          "code" => "0",
          "message" => "Do not recognize as a ping"
        }
      }
      JSON.generate(raw)
    end
    
    # Provide a valid xml minimal ping
    def valid_xml_ping(opts)
      raw = <<-XML
<?xml version="1.0"?>
<methodCall>
  <methodName>#{opts[:method]}</methodName>
  <params>
    <param>
      <value>#{opts[:name]}</value>
    </param>
    <param>
      <value>#{opts[:url]}</value>
    </param>
  </params>
</methodCall>
      XML
    end # valid_xml_ping
    
    def valid_json_ping(opts)
      raw = {
        :method_name  => opts[:method],
        :params       => [
          opts[:name], 
          opts[:url]
        ]
      }
      JSON.generate(raw)
    end
    
    def valid_xml_extended_ping(opts)
      out = <<-XML
<?xml version="1.0"?>
<methodCall>
  <methodName>weblogUpdates.extendedPing</methodName>
  <params>
    <param>
      <value>#{opts[:name]}</value>
    </param>
    <param>
      <value>#{opts[:url]}</value>
    </param>
    <param>
      <value>#{opts[:changes_url]}</value>
    </param>
    <param>
      <value>#{opts[:feed_url]}</value>
    </param>
  XML
  if opts[:tag]
    out += <<-XML
    <param>
      <value>#{opts[:tag]}</value>
    </param>
    XML
  end
out += <<-XML
  </params>
</methodCall>
      XML
    end
    
    def valid_json_extended_ping(opts)
      the_params = [opts[:name], opts[:url], opts[:changes_url], opts[:feed_url]]
      the_params << opts[:tag] if opts[:tag]
      
      
      raw = {
        :method_name  => "weblogUpdates.extendedPing",
        :params       => the_params
      }
      JSON.generate(raw)
    end # valid_json_extended_ping

    def valid_xml_geo_ping(opts)
      raw = <<-XML
<?xml version="1.0"?>
<methodCall>
  <methodName>#{opts[:method]}</methodName>
  <params>
    <param>
      <value>#{opts[:name]}</value>
    </param>
    <param>
      <value>#{opts[:url]}</value>
    </param>
    <param>
      <value>
        <lat>#{opts[:geo][:lat]}</lat>
        <long>#{opts[:geo][:long]}</long>
      </value
    </param>
  </params>
</methodCall>
      XML
    end # valid_xml_geo_ping
    
    def valid_json_geo_ping(opts)
      raw = {
        :method_name  => opts[:method],
        :params       => [
          opts[:name], 
          opts[:url],
          opts[:geo]
        ]
      }
      JSON.generate(raw)
    end
    
    def valid_xml_extended_geo_ping(opts)
      out = <<-XML
    <?xml version="1.0"?>
    <methodCall>
      <methodName>weblogUpdates.extendedGeoPing</methodName>
      <params>
        <param>
          <value>#{opts[:name]}</value>
        </param>
        <param>
          <value>#{opts[:url]}</value>
        </param>
        <param>
          <value>#{opts[:changes_url]}</value>
        </param>
        <param>
          <value>#{opts[:feed_url]}</value>
        </param>
        <param>
          <value>
            <lat>#{opts[:geo][:lat]}</lat>
            <long>#{opts[:geo][:long]}</long>
          </value
        </param>
      XML
      if opts[:tag]
        out += <<-XML
        <param>
          <value>#{opts[:tag]}</value>
        </param>
        XML
      end
    out += <<-XML
      </params>
    </methodCall>
          XML
    end
    
    def valid_json_extended_geo_ping(opts)
      the_params = [opts[:name], opts[:url], opts[:changes_url], opts[:feed_url], opts[:geo]]
      the_params << opts[:tag] if opts[:tag]
      
      
      raw = {
        :method_name  => "weblogUpdates.extendedGeoPing",
        :params       => the_params
      }
      JSON.generate(raw)
    end # valid_json_extended_ping
    
  end # SpecHelpers
end # GeoPing