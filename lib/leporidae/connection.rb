require 'socket'
Thread.abort_on_exception = true

module Leporidae
  class Connection
    def initialize(host)
      @send_queue = []
      @host = host
      # Make a thread to handle all IO on this connection
      Thread.new do
        run
      end
    end

    def run
      # Make a self-pipe to trigger a write
      @self_read, @self_write = IO.pipe
      # Connect the socket
      @socket = TCPSocket.new(@host, 5672)
      @socket.write ["AMQP",0,0,9,1].pack("a*CCCC")
      loop do
        selected = IO.select [@socket, @self_read]
        if selected.first.include?(@self_read)
          while send_item = @send_queue.shift
            @socket.write(send_item.encode)
          end
        end
        if selected.first.include?(@socket)
          frame = read_frame
          case frame.payload
          when Payload::Method
            frame.payload.execute(self, frame.channel)
          when Payload::Heartbeat
            send_heartbeat
          end
        end
      end
    end

    def enqueue(data)
      @send_queue << data
      @self_write.write("\0")
    end

    def direct(name)
    end

    def read_frame
      frame = @socket.read(7)
      _, _, length = frame.unpack('CnN')
      frame << @socket.read(length)
      frame << @socket.read(1)
      Frame.new(frame)
    end

    def handle_r
    end

    def handle_w
    end

  end
end
