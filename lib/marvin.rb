require 'yaml'
require 'active_support/buffered_logger'
require 'pathname'

module Marvin

  autoload :Bot, 'marvin/bot'
  autoload :Memory, 'marvin/memory'

  def self.configure
    config = YAML.load_file(root.join('config.yml'))
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

  def self.root
    @@root ||= Pathname.new(File.dirname(__FILE__)+'/..').expand_path
  end
end
