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
Wrap your publish call following this example:

    def notify_with_replay(payload, properties={}, headers={})
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


