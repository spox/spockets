require 'test/unit'
require 'spockets'
require 'socket'

class SpocketsTests < Test::Unit::TestCase
    def setup
        @spk = Spockets::Spockets.new
        @server = TCPServer.new(4000)
    end
    def teardown
        @server.close
        @server = nil
    end

    def test_add
        socket = TCPSocket.new('localhost', 4000)
        rsocket = @server.accept
        output = []
        @spk.add(rsocket){|s|output << s}
        socket.puts "fubar"
        sleep(0.01)
        assert_equal(1, output.size)
        assert_equal("fubar\n", output.pop)
    end

    def test_add_singlemulti
        socket = TCPSocket.new('localhost', 4000)
        rsocket = @server.accept
        output = []
        @spk.sync = false
        @spk.add(rsocket){|s|output << s.strip}
        @spk.add(rsocket){|s|output << "a#{s}".strip}
        @spk.sync(true)
        socket.puts 'fubar'
        sleep(0.01)
        assert_equal(2, output.size)
        assert(output.include?('fubar'))
        assert(output.include?('afubar'))
    end

    def test_add_multisingle
        asocket = TCPSocket.new('localhost', 4000)
        bsocket = TCPSocket.new('localhost', 4000)
        rsocket = @server.accept
        ssocket = @server.accept
        output = []
        @spk.sync = false
        @spk.add(rsocket){|s|output << s.strip}
        @spk.add(ssocket){|s|output << s.strip}
        @spk.sync(true)
        asocket.puts 'fubar'
        bsocket.puts 'foobar'
        sleep(0.01)
        assert_equal(2, output.size)
        assert(output.include?('fubar'))
        assert(output.include?('foobar'))
    end

    def test_add_multimulti
        asocket = TCPSocket.new('localhost', 4000)
        bsocket = TCPSocket.new('localhost', 4000)
        rsocket = @server.accept
        ssocket = @server.accept
        output = []
        @spk.sync = false
        @spk.add(rsocket){|s|output << s.strip}
        @spk.add(rsocket){|s|output << "1#{s.strip}"}
        @spk.add(ssocket){|s|output << s.strip}
        @spk.add(ssocket){|s|output << "2#{s.strip}"}
        @spk.sync(true)
        asocket.puts 'fubar'
        bsocket.puts 'foobar'
        sleep(0.01)
        assert_equal(4, output.size)
        assert(output.include?('fubar'))
        assert(output.include?('foobar'))
        assert(output.include?('1fubar'))
        assert(output.include?('2foobar'))
    end

    def test_remove
        socket = TCPSocket.new('localhost', 4000)
        rsocket = @server.accept
        output = []
        @spk.add(rsocket){|s|output << s.strip}
        socket.puts "fubar"
        sleep(0.01)
        assert_equal('fubar', output.pop)
        @spk.remove(rsocket)
        assert_raise(Spockets::UnknownSocket) do
            @spk.remove(rsocket)
        end
        socket.puts 'test'
        assert(output.empty?)
    end

    def test_on_close
        socket = TCPSocket.new('localhost', 4000)
        rsocket = @server.accept
        output = []
        @spk.add(rsocket){|s|output << s.strip}
        @spk.on_close(rsocket){|s| output << "closed: #{s}"}
        socket.puts "fubar"
        sleep(0.01)
        assert_equal('fubar', output.pop)
        socket.close
        sleep(0.01)
        assert_equal(1, output.size)
    end

    def test_on_close_multi
        socket = TCPSocket.new('localhost', 4000)
        rsocket = @server.accept
        output = []
        @spk.add(rsocket){|s|output << s.strip}
        @spk.on_close(rsocket){|s| output << "closed: #{s}"}
        @spk.on_close(rsocket){|s| output << "really closed: #{s}"}
        socket.puts "fubar"
        sleep(0.01)
        assert_equal('fubar', output.pop)
        socket.close
        sleep(0.01)
        assert_equal(2, output.size)
    end

    def test_add_with_data
        socket = TCPSocket.new('localhost', 4000)
        rsocket = @server.accept
        output = []
        @spk.add(rsocket, 10){|s, b|output << "#{b}#{s.strip}"}
        socket.puts "fubar"
        sleep(0.01)
        assert_equal('10fubar', output.pop)
    end

    def test_on_close_with_data
        socket = TCPSocket.new('localhost', 4000)
        rsocket = @server.accept
        output = []
        @spk.add(rsocket){|s|output << s.strip}
        @spk.on_close(rsocket, 10){|s, b| output << "#{b}closed"}
        socket.puts "fubar"
        sleep(0.01)
        assert_equal('fubar', output.pop)
        socket.close
        sleep(0.01)
        assert_equal(1, output.size)
        assert_equal('10closed', output.pop)
    end
end