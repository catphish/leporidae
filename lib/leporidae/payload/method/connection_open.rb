module Leporidae
  module Payload
    class Method
      class ConnectionOpen
        CLASS_ID = 10
        METHOD_ID = 40
        attr_accessor :vhost

        def encode
          io = StringIO.new
          io.write_short_string(vhost)
          io.write_short_short_uint(0)
          io.write_short_short_uint(0)
          io.string
        end

      end
    end
  end
end
