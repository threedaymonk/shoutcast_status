require "open-uri"
require "johnson"

class ShoutcastStatus
  DEFAULT_ENDPOINT  = "http://%s/cast/"
  DEFAULT_INFO_PATH = "js.php/%s/streaminfo"

  DUMMY_CALLBACK = <<-END
    function cc_streaminfo_get_callback(details){
      return details;
    }
  END

  # Create a ShoutcastStatus instance for a given station.
  # If one parameter is given, it is taken as the url to the now playing JSONP
  # callback or the playlist. If two parameters are given, they are interpreted
  # as the station host and station name; the information URL will be inferred
  # from this.
  #
  def initialize(url_or_host, station=nil)
    if station
      @info_url = (DEFAULT_ENDPOINT % url_or_host) + (DEFAULT_INFO_PATH % station)
    elsif m = url_or_host.match(%r{^(.*?/)tunein.php/([^/]+)/playlist.pls$})
      @info_url = m[1] + (DEFAULT_INFO_PATH % m[2])
    else
      @info_url = url_or_host
    end
  end

  # Return a StreamInfo object containing the current state of the stream.
  #
  def stream_info
    open @info_url do |f|
      js = f.read
      return StreamInfo.new(Johnson.evaluate(DUMMY_CALLBACK + js))
    end
  end

  class StreamInfo
    def initialize(object)
      @object = object
    end

    def artist
      artist_and_title.first
    end

    def title
      artist_and_title.last
    end

    def listeners
      @object["listeners"]
    end

    def max_listeners
      @object["maxlisteners"]
    end

    def station
      @object["title"]
    end

    def bitrate
      @object["bitrate"]
    end

    def url
      @object["url"]
    end

  private
    def artist_and_title
      @object["song"].split(/ - /, 2)
    end
  end
end
