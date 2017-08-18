class Frame
  EOF_BYTE = [0xCE].pack('C')
  attr_accessor :type, :channel, :payload

  def self.decode_from_wire(io)
    header = io.read(7)
    frame = self.new
    frame.type, frame.channel, size = header.unpack('CnN')
    raw_payload = io.read(size)
    eof_byte = io.read(1)
    raise "Invalid EOF byte" unless eof_byte == EOF_BYTE

    frame.payload = case frame.type
    when 1
      Payloads::Method.decode_from_string(raw_payload)
    when 2
      Payloads::ContentHeader.decode_from_string(raw_payload)
    when 3
      Payloads::ContentBody.decode_from_string(raw_payload)
    when 8
      Payloads::Heartbeat.new
    else
      puts frame.type
      raise "Not Implemented"
    end
    frame
  end

  def encode
    raw_payload = payload.encode
    [@type, @channel, raw_payload.bytesize].pack('CnN') + raw_payload + EOF_BYTE
  end

end
