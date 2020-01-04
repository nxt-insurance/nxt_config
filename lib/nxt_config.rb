require "active_support/all"
require "erb"
require "yaml"

require "nxt_config/struct"
require "nxt_config/version"

module NxtConfig
  class ConstantNameAlreadyTaken < StandardError; end

  def load_and_constantize(source:, constant_name: nil, namespace: nil)
    source_hash = YAML.safe_load(ERB.new(File.read(source)).result)
    struct = Struct.new(source_hash)
    namespace_constant = namespace || Object

    begin
      if namespace_constant.const_get(constant_name)
        raise ConstantNameAlreadyTaken,
              "Cannot define constant #{constant_name} on #{namespace_constant.name} because it already exists."
      end
    rescue NameError
      # If the constant does not exist => fine, let's set it!
    end

    namespace_constant.const_set(constant_name, struct)
  end

  module_function :load_and_constantize
end
