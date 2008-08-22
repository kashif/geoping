module Merb
  module JsonHelper

    def set_json_as_content_type
      headers['Content-Type'] = 'application/json'
    end

    def coerce_response_to_json
      # Wrap our response in a json result container
      @body = json_result(@body) if @_status == 200
      @body = @body.to_json
      headers['Content-Length'] = @body.length.to_s
    end

    def json_error(message, status=500)
      @_status = status
      {
        "version" => "1.1",
        "error" => {
          "name" => "JSONRPCError",
          "code" => "000",
          "message" => message
        }
      }
    end

    def json_result(value)
      {
        "version" => "1.1",
        "result" => value
      }
    end

    # method_signatures is a hash of: method_name => [return_type, params]
    # where params is a hash {:param_name => :param_type}
    def json_system_description(args = {})
      unless ([:name, :id] - args.keys).empty?
        raise "You must supply: #{([:name, :id] - args.keys).join(', ')}"
      end
      
      # We're not requiring procs, so default to an empty set
      args[:procs] ||= []

      { :sdversion => '1.0', :name => args[:name],
        :id => args[:id],
        :procs =>
          args[:procs].collect do |name, meth_params|
            {
              :name => name,
              :return => meth_params.first,
              :params =>
                if meth_params.last.nil?
                  nil
                else
                  meth_params.last.collect do |pname, type|
                    {:name => pname, :type => type}
                end
              end
            }
          end
      }
    end
    
  end
end # Merb