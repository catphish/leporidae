module Leporidae
  module Payload
    class Method
      class ConnectionOpenOK

        def initialize(string)
        end

        def execute(connection, channel)
          @connection.state = :extablished
        end

      end
    end
  end
end
