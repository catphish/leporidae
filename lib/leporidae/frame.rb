require 'leporidae/payload/method'
require 'leporidae/payload/content_header'
require 'leporidae/payload/content_body'
require 'leporidae/payload/heartbeat'

module Leporidae
  class Frame
    EOF_BYTE = [0xCE].pack('C')
    attr_accessor :type, :channel, :payload

    def initialize(string=nil)
      if string
        raise "Invalid EOF byte" unless string[-1] == EOF_BYTE
        header = string.slice!(0,7)
        @type, @channel = header.unpack('Cn')

        klass = case type
        when 1
          Payload::Method
        when 2
          Payload::ContentHeader
        when 3
          Payload::ContentBody
        when 8
          Payload::Heartbeat
        else
          raise "Not Implemented"
        end
        @payload = klass.new(string)
      end
    end

    def encode
      @type = @payload.class::FRAME_TYPE
      encoded_payload = @payload.encode
      [@type, @channel, encoded_payload.bytesize].pack('CnN') + encoded_payload + EOF_BYTE
    end

  end
end
