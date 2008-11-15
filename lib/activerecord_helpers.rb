module GeoPing
  module ActiveRecordHelpers
    
    # @private
    def validate_fields_as_urls(*fields)
      fields.each do |the_field|
        begin
          URI.parse(self.send(the_field))
        rescue
          errors.add(the_field, "is not a valid URL")
        end
      end
    end
    
  end
  ActiveRecord::Base.class_eval{ include GeoPing::ActiveRecordHelpers }
end