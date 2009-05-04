# Evoke Client

evoke-client is a simple rest-client utility for allowing your application to converse with the [Evoke Service](http://evoke.thumblemonks.com). The source code for [Evoke can be found on GitHub](http://github.com/thumblemonks/evoke) along with what Evoke is intended for.

### Usage

    evoke = Evoke.new(:url => 'http://example.com/users/unsubscribe', :callback_at => (Time.now + 86400))
    evoke.save
    
    # What happens if save fails

### Configuration

By default, evoke-client tries to talk to the Evoke service, generously hosted by Thumble Monks :) Because Evoke itself is open source and able to be run by you anywhere you want it to, the only real configuration parameters are for the hostname and port that you want evoke-client to talk to Evoke on. For instance, when we use Evoke in our projects, we may want to test with a local instance while doing development.

To modify host and port, just set the following:

    Evoke.host = "example.com"
    Evoke.port = "4567"
    # Choosing 4567 because Evoke is written for Sinatra

### Installation

    gem install thumblemonks-evoke_client

#### Dependencies

These should be automatically installed when you install evoke_client

* rest-client

## License

MIT, baby! (see file named MIT-LICENSE)
