# Evoke Client

The Evoke client is a simple HTTParty utility for allowing your application to converse with an [Evoke service](http://github.com/thumblemonks/evoke).

Soon, there will be a global Evoke app that your app can talk to. For now, you should run your own server.

### Usage

Essentially, the Evoke client acts like an `ActiveRecord` model. The basic methods are:

* Evoke::Callback.find(guid)
* Evoke::Callback.create\_or\_update(attributes\_hash)
* Evoke::Callback#update\_attributes(hash\_to\_merge)
* Evoke::Callback#save
* Evoke::Callback#destroy

Typically, you would simply need to call `create_or_update` from wherever you are calling out to Evoke. Most of the apps we use Evoke client with make calls similar to the following:

    class SomeObject
      def some_method
        ...
        Evoke::Callback.create_or_update(
          "guid" => "some-kind-of-unique-string",
          "url" => "http://example.com/users/unsubscribe",
          "callback_at" => Time.now + 3600)
        ...
      end
    end

The Evoke client will raise an `Evoke::RecordInvalid` exception if the callback could not be created or updated for some reason. This is the same for an explicit call to save. The reason for the failure will be returned in the exception as the message.

If you wanted to explicitly do what `create_or_update` is doing for you in your code, you would likely write your code like so:

    ...
    callback = Evoke::Callback.find("some-kind-of-unique-string")
    if callback
      callback.update_attributes("callback_at" => Time.now + 3600)
    else
      callback = Evoke::Callback.new(
        "guid" => "some-kind-of-unique-string",
        "url" => "http://example.com/users/unsubscribe",
        "callback_at" => Time.now + 3600)
    end
    callback.save
    ...

If you no longer need a callback, you can destroy it. Simply find the callback and then call its destroy method.

    callback = Evoke::Callback.find("some-kind-of-unique-string")
    callback.destroy

### Configuration

To modify host and port, just set the following somewhere after you have required in (see following sections) the Evoke client:

    Evoke.configure "http://example.com:4567"

If you're using a newer version Rails, you could set it in an initializer. However, you may not want to be adding callbacks to your production instance of Evoke when doing local development. It's probably better to explicitly configure Evoke in your `development.rb` and `production.rb` files.

Then, if you're using Rails, put this is your `development.rb` and `production.rb` files:

    config.gem 'evoke_client', :src => "http://gemcutter.org"

Otherwise, do the standard:

    require 'evoke_client'

#### Testing

If using Rails, put this is your `config/environment/test.rb`:

    config.gem 'evoke_client', :lib => 'evoke_client/mock', :src => "http://gemcutter.org"

If not using Rails, put this in your `test_helper.rb` or whatever you call it:

    require 'evoke_client/mock'

You need to make sure you have required in `evoke_client/mock` **AFTER** you have required `evoke_client`. Otherwise ... bad stuff.

Don't worry about calling `Evoke.configure` if you're requiring in the mock library. It's irrelevant. What is relevant, however, is mocking out the calls Evoke client will send to HTTParty. Evoke client has a solution, but I need to document it here and I'm not ready yet. Sorry.

    DOCUMENTATION NEEDED FOR HTTMockParty

### Installation

If you haven't done so yet, you should add the GemCutter source to your list of gem sources:

    gem sources -a http://gemcutter.org

Then installing the Evoke client is as simple as:

    gem install evoke_client

#### Dependencies

These should be automatically installed when you install evoke_client

* [httparty](http://github.com/jnunemaker/httparty/)

## License

MIT, baby! (see file named MIT-LICENSE)
