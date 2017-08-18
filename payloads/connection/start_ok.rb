module Payloads
  module Connection
    class StartOK < Payloads::Method
      attr_accessor :client_properties, :mechanism, :response, :locale

      def encode
        io = StringIO.new
        io.write_short_uint 10
        io.write_short_uint 11
        io.write_field_table(client_properties)
        io.write_short_string(mechanism)
        io.write_byte_array(response)
        io.write_short_string(locale)
        io.string
      end
    end
  end
end
