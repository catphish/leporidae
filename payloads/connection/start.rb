module Payloads
  module Connection
    class Start < Payloads::Method
      def read_arguments_from_io(io)
        @version_major = io.read_short_short_uint
        @version_minor = io.read_short_short_uint
        @server_properties = io.read_field_table
        @mechanisms = io.read_long_string.split(' ')
        @locales = io.read_long_string.split(' ')
      end
    end
  end
end
