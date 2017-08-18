require 'socket'
require 'stringio'
require_relative 'io_helpers'
require_relative 'frame'
require_relative 'payloads/method'
require_relative 'payloads/content_header'
require_relative 'payloads/content_body'
require_relative 'payloads/heartbeat'
require_relative 'payloads/connection/start'
require_relative 'payloads/connection/start_ok'
require_relative 'payloads/connection/tune'
require_relative 'payloads/connection/tune_ok'
require_relative 'payloads/connection/open'
require_relative 'payloads/connection/open_ok'
require_relative 'payloads/channels/open'
require_relative 'payloads/channels/open_ok'

s = TCPSocket.new('127.0.0.1', 5672)
s.write ["AMQP",0,0,9,1].pack("a*CCCC")

frame = Frame.decode_from_wire(s)
puts frame.inspect

frame = Frame.new
frame.type = 1
frame.channel = 0
frame.payload = Payloads::Connection::StartOK.new
frame.payload.client_properties = {}
frame.payload.mechanism = 'PLAIN'
frame.payload.response = "\0guest\0guest"
frame.payload.locale = 'en_US'
s.write(frame.encode)

frame = Frame.decode_from_wire(s)
puts frame.inspect

frame = Frame.new
frame.type = 1
frame.channel = 0
frame.payload = Payloads::Connection::TuneOK.new
frame.payload.channel_max = 0
frame.payload.frame_max = 131072
frame.payload.heartbeat = 60
s.write(frame.encode)

frame = Frame.new
frame.type = 1
frame.channel = 0
frame.payload = Payloads::Connection::Open.new
frame.payload.vhost = '/'
s.write(frame.encode)

frame = Frame.decode_from_wire(s)
puts frame.inspect

frame = Frame.new
frame.type = 1
frame.channel = 1
frame.payload = Payloads::Channels::Open.new
s.write(frame.encode)

frame = Frame.decode_from_wire(s)
puts frame.inspect

frame = Frame.decode_from_wire(s)
puts frame.inspect
