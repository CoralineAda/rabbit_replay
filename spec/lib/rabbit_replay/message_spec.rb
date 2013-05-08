require 'spec_helper'

describe RabbitReplay::Message do

  describe "#has_payload_or_headers?" do

    it "returns true if payload exists" do
      RabbitReplay::Message.new(:payload => 'foo').has_payload_or_headers?.should be_true
    end

    it "returns true if headers exist" do
      RabbitReplay::Message.new(:headers => {:foo => 'bar'}).has_payload_or_headers?.should be_true
    end

    it "returns false if neither payload nor headers exist" do
      RabbitReplay::Message.new.has_payload_or_headers?.should be_false
    end

  end

  describe "#can_be_replayed?" do

    it "returns true if payload or header data is present" do
      message = RabbitReplay::Message.new
      message.stub(:has_payload_or_headers?) { true }
      message.stub(:replay_successful) { false }
      message.can_be_replayed?.should be_true
    end

    it "returns false if no payload or header data" do
      message = RabbitReplay::Message.new
      message.stub(:has_payload_or_headers?) { false }
      message.stub(:replay_successful) { false }
      message.can_be_replayed?.should be_false
    end

    it "returns false if already succesfully replayed" do
      message = RabbitReplay::Message.new
      message.stub(:has_payload_or_headers?) { true }
      message.stub(:replay_successful) { true }
      message.can_be_replayed?.should be_false
    end

  end

end
