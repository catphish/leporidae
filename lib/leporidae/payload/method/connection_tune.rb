module Leporidae
  module Payload
    class Method
      class ConnectionTune

        def initialize(string)
          if string
            io = StringIO.new(string)
            @channel_max = io.read_short_uint
            @frame_max = io.read_long_uint
            @heartbeat = io.read_short_uint
          end
        end

        def execute(connection, channel)
          response = Frame.new
          response.channel = channel
          response.payload = Method.new
          response.payload.arguments = Method::ConnectionTuneOK.new
          response.payload.arguments.channel_max = @channel_max
          response.payload.arguments.frame_max = @frame_max
          response.payload.arguments.heartbeat = @heartbeat
          connection.enqueue(response)

          response = Frame.new
          response.channel = channel
          response.payload = Method.new
          response.payload.arguments = Method::ConnectionOpen.new
          response.payload.arguments.vhost = '/'
          connection.enqueue(response)
        end

      end
    end
  end
end
