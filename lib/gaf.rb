# frozen_string_literal: true

require "gaf/config"
require "gaf/version"


module Gaf
  autoload :Processor, "gaf/processor"

  class Error < StandardError; end

  def self.configure
    yield(config) if block_given?
  end

  def self.config
    @config ||= Gaf::Config.new
  end
end
