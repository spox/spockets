require 'actionpool'
require 'actionpool/Exceptions'
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
            @stop = false
            @runner = Thread.new{watch(@sockets.keys)} if @runner.nil?
        end

        # stop the watcher
        def stop
            @stop = true
            @runner.join(0.1)
            @runner.kill unless @runner.alive?
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
                for sock in resultset[0]
                    string = sock.gets
                    if(sock.closed? || string.nil?)
                        @sockets.delete(sock)
                        @pool.process{ stop;start}
                    else
                        string = clean? ? untaint(string) : string
                        @sockets[sock].each{|b| @pool.process{ b.call(string)}}
                    end
                end
            end
        end
        
        def untaint(s)
            @ic.iconv(s + ' ')[0..-2]
        end
    end
end