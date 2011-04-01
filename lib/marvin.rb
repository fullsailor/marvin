require 'yaml'
require 'marvin/bot'
require 'active_support/buffered_logger'

module Marvin

  def self.configure
    config = YAML.load_file('./config.yml')
    @@token = config['token']
    @@subdomain = config['subdomain']
  end

  def self.token
    @@token
  end

  def self.subdomain
    @@subdomain
  end

  def self.lives!
    mb = Marvin::Bot.new
    mb.run
  end

  def self.logger
    @@logger ||= ActiveSupport::BufferedLogger.new('log/marvin.log')
  end
end
