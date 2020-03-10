require "erb"
require "yaml"

require "nxt_config/struct"
require "nxt_config/version"

module NxtConfig
  def load(filename_or_hash)
    if filename_or_hash.respond_to?(:to_h)
      source_hash = filename_or_hash
    else
      source_hash = YAML.safe_load(ERB.new(File.read(filename_or_hash)).result)
    end

    Struct.new(source_hash)
  end

  module_function :load
end
