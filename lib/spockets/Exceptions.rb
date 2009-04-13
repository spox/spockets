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

    class AlreadyRunning < Exception
    end
    
    class NotRunning < Exception
    end

    class Resync < Exception
    end

    class MissingArgument < Exception
        attr_reader :argument
        def initialize(a)
            @argument = a
        end

        def to_s
            "Missing required argument: #{@argument}"
        end
    end
    
end