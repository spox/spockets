require 'actionpool'
require 'iconv'

module Spockets
    class Watcher

        # sockets:: socket list
        # clean:: clean UTF8 strings
        # pool:: ActionPool to use
        # Creates a new watcher for sockets
        def initialize(sockets=nil, clean=false, pool=nil)
            @runner = nil
            @clean = clean
            @ic = @clean ? Iconv.new('UTF-8//IGNORE', 'UTF-8') : nil
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
        
        # clean incoming strings
        def clean?
            @clean
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
        
        def untaint(s)
            @ic.iconv(s + ' ')[0..-2]
        end
    end
end