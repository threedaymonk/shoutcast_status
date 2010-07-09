$:.unshift(File.expand_path("../../lib", __FILE__))
require "test/unit"
require "mocha"
require "stringio"
require "shoutcast_status"

class ShoutcastStatusTest < Test::Unit::TestCase

  def test_should_make_url_from_host_and_station_name
    io = StringIO.new("cc_streaminfo_get_callback({});")
    sc = ShoutcastStatus.new("example.com", "punkrock")
    sc.expects(:open).
       with("http://example.com/cast/js.php/punkrock/streaminfo").
       yields(io)
    sc.stream_info
  end

  def test_should_use_url_as_supplied
    io = StringIO.new("cc_streaminfo_get_callback({});")
    sc = ShoutcastStatus.new("http://example.com/some/path")
    sc.expects(:open).
       with("http://example.com/some/path").
       yields(io)
    sc.stream_info
  end

  def test_should_extract_details_from_sample
    sample = <<'END'
var arr952a05ca = { 'title': 'Radio Punk','song': 'Sex Pistols - Anarchy in the UK','bitrate': 128,'server': 'Online','source': 'Online','offline': '','summary': '\x3Ca href=\"http://example.com/cast/tunein.php/punkrock/tunein.pls\"\x3ERadio Punk - Sex Pistols - Anarchy in the UK\x3C/a\x3E','url': 'http://example.com/cast/js.php/punkrock/streaminfo','listeners': 2,'maxlisteners': 25,'reseller': 0 };

  cc_streaminfo_get_callback(arr952a05ca);
END

    io = StringIO.new(sample)
    sc = ShoutcastStatus.new("example.com", "punkrock")
    sc.stubs(:open).yields(io)
    info = sc.stream_info

    assert_equal "Radio Punk",        info.station
    assert_equal "Sex Pistols",       info.artist
    assert_equal "Anarchy in the UK", info.title
    assert_equal 128,                 info.bitrate
    assert_equal 2,                   info.listeners
    assert_equal 25,                  info.max_listeners
  end
end
