module Payloads
  class Method
    attr_accessor :class_id, :method_id

    def self.decode_from_string(string)
      io = StringIO.new(string)
      class_id  = io.read_short_uint
      method_id = io.read_short_uint
      payload = case [class_id, method_id]
      when [10,10]
        Payloads::Connection::Start.new
      when [10,30]
        Payloads::Connection::Tune.new
      when [10,41]
        Payloads::Connection::OpenOK.new
      when [20,11]
        Payloads::Channels::OpenOK.new
      else
        raise "Not implemented"
      end
      payload.class_id = class_id
      payload.method_id = method_id
      payload.read_arguments_from_io(io)
      payload
    end
  end
end
