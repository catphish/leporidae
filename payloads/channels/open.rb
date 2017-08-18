module Payloads
  module Channels
    class Open < Payloads::Method
      def encode
        io = StringIO.new
        io.write_short_uint 20
        io.write_short_uint 10
        io.write_short_short_uint(0)
        io.string
      end
    end
  end
end
