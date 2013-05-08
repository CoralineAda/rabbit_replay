rabbit_replay
=============
Logging and replay capabilities for Rabbit messages.

Configuration
-------------
Configure RabbitReplay with your app's notifier instance:

    RabbitReplay.configure do |config|
      config.notifier = MY_RABBIT_NOTIFIER
    end

Wiring
------
Wrap your publish call similar to this example:

    def publish_with_replay(payload, properties={}, headers={})
      begin
        MY_EXCHANGE.publish(payload, :properties => properties.merge(:headers => headers))
      ensure
        RabbitReplay::Message.record!(
          payload: payload,
          properties: properties,
          headers: headers,
          error: "#{$!}"
        )
      end
    end

Replaying Errors
----------------
Simply:

    RabbitReplay::Message.errors.each{|message| message.replay}

You can replay a message unless and until it is successfully sent. Last replay attempt and status is stored on the message:

    message = RabbitReplay::Message.last
    message.last_replay_at
    message.replay_successful?

You can also force a message replay, ignoring replay success:

    message = RabbitReplay::Message.last
    message.replay!

