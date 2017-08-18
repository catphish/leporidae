module Payloads
  module Connection
    class Open < Payloads::Method
      attr_accessor :vhost

      def encode
        io = StringIO.new
        io.write_short_uint 10
        io.write_short_uint 40
        io.write_short_string(vhost)
        io.write_short_short_uint(0)
        io.write_short_short_uint(0)
        io.string
      end
    end
  end
end
