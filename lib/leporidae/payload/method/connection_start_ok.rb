module Leporidae
  module Payload
    class Method
      class ConnectionStartOK
        CLASS_ID = 10
        METHOD_ID = 11
        attr_accessor :client_properties, :mechanism, :response, :locale

        def encode
          io = StringIO.new
          io.write_field_table(client_properties)
          io.write_short_string(mechanism)
          io.write_byte_array(response)
          io.write_short_string(locale)
          io.string
        end
      end
    end
  end
end
