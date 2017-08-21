module Leporidae
  module Payload
    class Method
      class ConnectionTuneOK
        CLASS_ID = 10
        METHOD_ID = 31
        attr_accessor :channel_max, :frame_max, :heartbeat

        def encode
          io = StringIO.new
          io.write_short_uint(channel_max)
          io.write_long_uint(frame_max)
          io.write_short_uint(heartbeat)
          io.string
        end
      end
    end
  end
end
