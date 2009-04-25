require 'actionpool'
require 'actionpool/Exceptions'
require 'iconv'

module Spockets
    class Watcher

        # :sockets:: socket list
        # :clean:: clean UTF8 strings or provide block to run on every read string
        # :pool:: ActionPool to use
        # Creates a new watcher for sockets
        def initialize(args)
            raise MissingArgument.new(:sockets) unless args[:sockets]
            @sockets = args[:sockets]
            @runner = nil
            @clean = args[:clean] && (args[:clean].is_a?(Proc) || args[:clean].is_a?(TrueClass)) ? args[:clean] : nil
            @pool = args[:pool] && args[:pool].is_a?(ActionPool::Pool) ? args[:pool] : ActionPool::Pool.new
            @ic = @clean && @clean.is_a?(TrueClass) ? Iconv.new('UTF-8//IGNORE', 'UTF-8') : nil
            @stop = true
        end

        # start the watcher
        def start
            @stop = false
            @runner = Thread.new{watch} if @runner.nil? && @sockets.size > 0
        end

        # stop the watcher
        def stop
            @stop = true
            @runner.join(0.1)
            @runner.raise Resync.new
            @runner.join(0.1)
            @runner.kill unless @runner.nil? || @runner.alive?
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

        # Ensure all sockets are being listened to
        def sync
            raise NotRunning.new if @runner.nil?
            @runner.raise Resync.new
        end
        
        private
        
        def watch
            until(@stop)
                begin
                    resultset = Kernel.select(@sockets.keys, nil, nil, nil)
                    for sock in resultset[0]
                        string = sock.gets
                        if(sock.closed? || string.nil?)
                            @sockets[sock][:closed].call(sock) if @sockets[sock].has_key?(:closed)
                            @sockets.delete(sock)
                        else
                            string = clean? ? do_clean(string) : string
                            @sockets[sock][:procs].each{|b| @pool.process{ b.call(string)}}
                        end
                    end
                rescue Resync
                    # break select and relisten #
                end
            end
            @runner = nil
        end

        def do_clean(string)
            unless(@ic.nil?)
                return untaint(string)
            else
                return @clean.call(string)
            end
        end
        
        def untaint(s)
            @ic.iconv(s + ' ')[0..-2]
        end
    end
end