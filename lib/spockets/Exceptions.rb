module Spockets

    class DuplicateSocket < Exception
        attr_reader :socket
        def initialize(s)
            @socket = s
        end
    end
    
    class UnknownSocket < Exception
        attr_reader :socket
        def initialize(s)
            @socket = s
        end
    end

end