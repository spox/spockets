require 'test/unit'
require 'spockets'

class WatcherTests < Test::Unit::TestCase
  def setup
    @spk = Spockets::Watcher.new(:sockets => {})
  end
  def teardown
  end

  def test_create
    assert_raise(ArgumentError) do
      Spockets::Watcher.new
    end
    assert_raise(ArgumentError) do
      Spockets::Watcher.new {}
    end
    assert_raise(ArgumentError) do
      Spockets::Watcher.new :sockets => []
    end
    assert_kind_of(Spockets::Watcher, Spockets::Watcher.new(:sockets => {}))
  end

  def test_start
    assert(!@spk.running?)
    @spk.start
    assert(@spk.running?)
  end

  def test_stop
    assert(!@spk.running?)
    @spk.start
    assert(@spk.running?)
    @spk.stop
    assert(!@spk.running?)
  end
end