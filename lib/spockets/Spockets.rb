require 'spockets/Exceptions'
require 'spockets/Watcher'

module Spockets

    class Spockets

        # pool:: ActionPool if you would like to consolidate
        # clean:: Clean string
        # creates a new holder
        def initialize(pool=nil, clean=false)
            @sockets = {}
            @watcher = Watcher.new(@sockets, clean, pool)
        end

        # socket:: socket to listen to
        # block:: block to execute when activity is received
        # Adds a socket to the list to listen to. When a string
        # is received on the socket, it will send it to the block
        # for processing
        def add(socket, &block)
            raise DuplicateSocket.new(socket) if @sockets.has_key?(socket)
            begin
                stop
            rescue NotRunning
                # do nothing
            end
            @sockets[socket] = [block]
            start
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
            begin
                stop
            rescue NotRunning
                # do nothing
            end
            @sockets.delete(socket)
            start
        end

        # start spockets
        def start
            raise AlreadyRunning.new if @watcher.running?
            do_start
        end

        # stop spockets
        def stop
            raise NotRunning.new unless @watcher.running?
            do_stop
        end

        # shutdown and clean up
        def shutdown
        end

        # currently watching sockets
        def running?
            !@watcher.nil? && @watcher.running?
        end

        private

        def do_start
            @watcher.start unless @watcher.running?
        end

        def do_stop
            @watcher.stop if @watcher.running?
        end
        
    end

end