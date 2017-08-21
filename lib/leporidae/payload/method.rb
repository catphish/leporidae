Dir[File.dirname(__FILE__) + '/method/*'].each {|file| require file }

module Leporidae
  module Payload
    class Method
      FRAME_TYPE = 1
      attr_accessor :class_id, :method_id, :arguments

      def initialize(string=nil)
        if string
          header = string.slice!(0,4)
          @class_id, @method_id = header.unpack('nn')
          @arguments = case [@class_id, @method_id]
          when [10,10]
            Payload::Method::ConnectionStart.new(string)
          when [10,30]
            Payload::Method::ConnectionTune.new(string)
          when [10,41]
            Payload::Method::ConnectionOpenOK.new(string)
          when [20,11]
            Payload::Method::ChannelOpenOK.new(string)
          else
            raise "Not implemented"
          end
        end
      end

      def encode
        @class_id = @arguments.class::CLASS_ID
        @method_id = @arguments.class::METHOD_ID
        [@class_id, @method_id].pack('nn') + @arguments.encode
      end

      def execute(connection, channel)
        arguments.execute(connection, channel)
      end

    end
  end
end
