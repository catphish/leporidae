module Payloads
  module Connection
    class TuneOK < Payloads::Method
      attr_accessor :channel_max, :frame_max, :heartbeat

      def encode
        io = StringIO.new
        io.write_short_uint 10
        io.write_short_uint 31
        io.write_short_uint(channel_max)
        io.write_long_uint(frame_max)
        io.write_short_uint(heartbeat)
        io.string
      end
    end
  end
end
