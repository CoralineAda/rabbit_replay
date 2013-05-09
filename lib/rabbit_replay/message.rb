require 'mongoid'

module RabbitReplay

  class Message

    include Mongoid::Document
    include Mongoid::Timestamps

    field :properties,        :type => Hash, :default => {}
    field :headers,           :type => Hash, :default => {}
    field :payload
    field :error_details
    field :last_replay_at,    :type => DateTime
    field :replay_successful, :type => Boolean, :default => false

    scope :errors,       excludes(:error_details => nil, :error_details => "")
    scope :with_content, lambda{|c| { :where => {:payload => /#{c}/ } } }
    scope :with_header,  lambda{|k,v| { :where => {"headers.#{k.to_s}" => v} } }

    index({:created_at => 1},     {:unique => false})
    index({:error_details => 1},  {:unique => false})

    def self.record!(params)
      Message.create(params.select{|k,v| fields.keys.include?(k.to_s)})
    end

    def can_be_replayed?
      return false if self.replay_successful
      has_payload_or_headers?
    end

    def has_payload_or_headers?
      ! (self.payload.nil? && self.headers.keys.empty?)
    end

    def options
      self.properties.merge(headers: self.headers)
    end

    def replay
      return unless can_be_replayed?
      replay!
    end

    def replay!
      self.replay_successful = true
      begin
        RabbitReplay::Notifier.publish(self.payload, options)
      rescue
        self.replay_successful = false
      ensure
        self.last_replay_at = DateTime.now
        self.save
      end
    end

  end

end
