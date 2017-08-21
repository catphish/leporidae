module Leporidae
  module Payload
    class Heartbeat
      def initialize(string=nil)
      end

      def encode
        String.new.force_encoding('BINARY')
      end
    end
  end
end
