shoutcast_status
================

Find out what a Shoutcast station is currently playing.

Usage
-----

    sc   = ShoutcastStatus.new("example.com", "punkrock")
    info = sc.stream_info
    info.artist # => "Sex Pistols"
    info.title  # => "Anarchy in the UK"

See the `StreamInfo` object for more fields.

This assumes that the server exposes a callback API at the usual path, namely:

    http://example.com/cast/js.php/punkrock/streaminfo

If this is not the case, an alternative URL can be supplied as the only
parameter when initialising ShoutcastStatus; this can be either the `tunein.php`
URL:

    sc = ShoutcastStatus.new("http://example.com/somewhere/tunein.php/punkrock/playlist.pls")

or an explicit path to the callback API:

    s  = ShoutcastStatus.new("http://example.com/path/to/punkrock/streaminfo")

Dependencies
------------

[therubyracer](https://github.com/cowboyd/therubyracer) is used to interpret
the JavaScript sent by the server.
