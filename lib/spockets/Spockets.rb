require 'spockets/Exceptions'
require 'spockets/Watcher'

module Spockets

    class Spockets

        # :pool:: ActionPool if you would like to consolidate
        # :clean:: Clean string. Set to true for default or 
        #          provide a block to clean strings
        # creates a new holder
        def initialize(args={})
            @sockets = {}
            @watcher = Watcher.new(:sockets => @sockets, :clean => args[:clean], :pool => args[:pool])
        end

        # socket:: socket to listen to
        # block:: block to execute when activity is received
        # Adds a socket to the list to listen to. When a string
        # is received on the socket, it will send it to the block
        # for processing
        def add(socket, &block)
            raise DuplicateSocket.new(socket) if @sockets.has_key?(socket)
            @sockets[socket] = [block]
            begin
                @watcher.sync
            rescue NotRunning
                start
            end
        end

        # socket:: socket in list
        # block:: additional block to execute
        # This will add additional blocks to the associated
        # socket to be executed when a new string is received
        def extra(socket, &block)
            raise UnknownSocket.new(socket) unless @sockets.has_key?(socket)
            @sockets[socket] << block
        end

        # socket:: socket to remove
        # Removes socket from list
        def remove(socket)
            raise UnknownSocket.new(socket) unless @sockets.has_key?(socket)
            @sockets.delete(socket)
            begin
                @watcher.sync
            rescue NotRunning
                start
            end
        end
        
        # remove all sockets
        def clear
            @sockets.clear
            stop
        end

        # start spockets
        def start
            raise AlreadyRunning.new if @watcher.running?
            @watcher.start
        end

        # stop spockets
        def stop
            raise NotRunning.new unless @watcher.running?
            @watcher.stop
        end

        # currently watching sockets
        def running?
            !@watcher.nil? && @watcher.running?
        end
        
        # socket:: a socket
        # check if the given socket is being watched
        def include?(socket)
            @sockets.has_key?(socket)
        end
        
        alias :delete :remove
        
    end

end