module Payloads
  module Connection
    class Tune < Payloads::Method
      def read_arguments_from_io(io)
        @channel_max = io.read_short_uint
        @frame_max = io.read_long_uint
        @heartbeat = io.read_short_uint
      end
    end
  end
end
