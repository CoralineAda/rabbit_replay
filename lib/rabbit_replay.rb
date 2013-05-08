require 'mongoid'
require 'rabbit_replay/message'

module RabbitReplay

  class << self
    attr_accessor :config
  end

  def self.configure(&block)
    @config = Configuration.new
    yield(config)
  end

  def self.config
    @config || Configuration.new
  end

  class Configuration
    attr_accessor :notifier
  end

end


