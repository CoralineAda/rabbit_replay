require 'mongoid'

module RabbitReplay

  class Message

    include Mongoid::Document
    include Mongoid::Timestamps

    field :properties,        :type => Hash
    field :headers,           :type => Hash
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

    def has_payload_or_headers?
      self.payload.present? || self.headers.present?
    end

    def can_be_replayed?
      has_payload_or_headers? && ! self.replay_successful
    end

    def last_replay_date
      self.last_replay_at ? self.last_replay_at.to_s(:short_date_time) : "Never"
    end

    def replay
      return unless can_be_replayed?
      replay!
    end

    def replay!
      self.replay_successful = true
      begin
        RabbitReplay::Notifier.publish(self.payload, self.properties, self.headers)
      rescue
        self.replay_successful = false
      ensure
        self.last_replay_at = DateTime.now
        self.save
      end
    end

  end

end
