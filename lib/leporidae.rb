require 'stringio'
require 'leporidae/io_helpers'
require 'leporidae/frame'
require 'leporidae/connection'

module Leporidae
end

# s = TCPSocket.new('127.0.0.1', 5672)
# frame = Frame.decode_from_wire(s)
# puts frame.inspect

# frame = Frame.new
# frame.type = 1
# frame.channel = 0
# frame.payload = Payloads::Connection::StartOK.new
# frame.payload.client_properties = {}
# frame.payload.mechanism = 'PLAIN'
# frame.payload.response = "\0guest\0guest"
# frame.payload.locale = 'en_US'
# s.write(frame.encode)

# frame = Frame.decode_from_wire(s)
# puts frame.inspect

# frame = Frame.new
# frame.type = 1
# frame.channel = 0
# frame.payload = Payloads::Connection::TuneOK.new
# frame.payload.channel_max = 0
# frame.payload.frame_max = 131072
# frame.payload.heartbeat = 60
# s.write(frame.encode)

# frame = Frame.new
# frame.type = 1
# frame.channel = 0
# frame.payload = Payloads::Connection::Open.new
# frame.payload.vhost = '/'
# s.write(frame.encode)

# frame = Frame.decode_from_wire(s)
# puts frame.inspect

# frame = Frame.new
# frame.type = 1
# frame.channel = 1
# frame.payload = Payloads::Channels::Open.new
# s.write(frame.encode)

# frame = Frame.decode_from_wire(s)
# puts frame.inspect

# frame = Frame.decode_from_wire(s)
# puts frame.inspect
