module NxtConfig
  class Struct
    def initialize(hash)
      @hash = hash.with_indifferent_access
      define_key_accessor_methods
      hash.freeze
    end

    delegate :[], to: :hash

    private

    attr_reader :hash

    def define_key_accessor_methods
      hash.transform_values! do |value|
        transform_hash_value(value)
      end
    end

    def transform_hash_value(value)
      if value.is_a?(ActiveSupport::HashWithIndifferentAccess)
        Struct.new(value)
      elsif value.is_a?(Array)
        value.map { |item| transform_hash_value(item) }
      else
        value
      end
    end

    def method_missing(name, *args)
      # Use #has_key? because even when the key exists, the value can be nil
      if hash.has_key?(name)
        hash.fetch(name)
      else
        super(name, *args)
      end
    end
  end
end
