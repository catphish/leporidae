module Leporidae
  module Payload
    class Method
      class ConnectionStart
        def initialize(string)
          if string
            io = StringIO.new(string)
            @version_major = io.read_short_short_uint
            @version_minor = io.read_short_short_uint
            @server_properties = io.read_field_table
            @mechanisms = io.read_long_string.split(' ')
            @locales = io.read_long_string.split(' ')
          end
        end

        def execute(connection, channel)
          response = Frame.new
          response.channel = channel
          response.payload = Method.new
          response.payload.arguments = Method::ConnectionStartOK.new
          response.payload.arguments.client_properties = {}
          response.payload.arguments.mechanism = 'PLAIN'
          response.payload.arguments.response = "\0guest\0guest"
          response.payload.arguments.locale = 'en_US'
          connection.enqueue(response)
        end

      end
    end
  end
end
