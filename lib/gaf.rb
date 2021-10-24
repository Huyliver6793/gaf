# frozen_string_literal: true

require_relative "gaf/version"
require "gaf/worksheet/create_worksheet"
require "gaf/worksheet/load_worksheet"
require "gaf/processor"
require "gaf/config"


module Gaf
  class Error < StandardError; end

  def self.configure
    yield(config) if block_given?
  end

  def self.config
    @config ||= Gaf::Config.new
  end
end
