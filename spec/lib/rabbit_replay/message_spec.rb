require 'spec_helper'

describe RabbitReplay::Message do

  describe "::record!" do
    it "creates a message" do
      expect{
        RabbitReplay::Message.record!(notifier: 'model_actions', action: "save", error: "#{$!}")
      }.to change(RabbitReplay::Message, :count).by(1)
    end
  end

  describe "#can_be_replayed?" do
    it "returns true if json data is present" do
      message = RabbitReplay::Message.new(:json => 'foo')
      message.can_be_replayed?.should be_true
    end
    it "returns true if json data is present and failed replay" do
      message = RabbitReplay::Message.new(:json => 'foo', :replay_successful => false)
      message.can_be_replayed?.should be_true
    end
    it "returns false if no json data" do
      message = RabbitReplay::Message.new(:json => nil)
      message.can_be_replayed?.should be_false
    end
    it "returns false if already succesfully replayed" do
      message = RabbitReplay::Message.new(:json => 'foo', :replay_successful => true)
      message.can_be_replayed?.should be_false
    end
  end

end
