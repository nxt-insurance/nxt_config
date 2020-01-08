require "active_support/all"
require "erb"
require "yaml"

require "nxt_config/struct"
require "nxt_config/version"

module NxtConfig
  def load(filename)
    source_hash = YAML.safe_load(ERB.new(File.read(filename)).result)
    Struct.new(source_hash)
  end

  module_function :load
end
