require 'actionpool'

module Spockets
    class Watcher

        # sockets:: socket list
        # Creates a new watcher for sockets
        def initialize(sockets=nil, pool=nil)
            @runner = nil
            @sockets = sockets
            @stop = true
            @pool = pool.nil? ? ActionPool::Pool.new : pool
        end

        # start the watcher
        def start
            populate_sockets
            @stop = false
            @runner = Thread.new{ watch(@sockets.keys) } if @runner.nil?
        end

        # stop the watcher
        def stop
            @stop = true
            @runner.join
            @runner = nil
        end

        # is the watcher running?
        def running?
            !@stop
        end
        
        private
        
        def watch(sockets)
            until(@stop)
                resultset = Kernel.select(sockets, nil, nil, nil)
                resultset[0].each do |socket|
                    string = clean? ? untaint(sock.gets) : sock.gets
                    @sockets[sock].each{|b| @pool.process{ b.call(string)}}
                end
            end
        end
    end
end