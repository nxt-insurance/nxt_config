module NxtConfig
  class Struct
    def initialize(hash)
      @hash = hash.transform_keys(&:to_sym)
      define_key_accessor_methods
      hash.freeze
    end

    def fetch(*keys, &block)
      if keys.length == 0
        raise ArgumentError, "Provide at least one key"
      elsif keys.length == 1
        hash.fetch(keys.first.to_sym, &block)
      else
        hash.fetch(keys.first.to_sym, &block).fetch(*keys[1..-1], &block)
      end
    end

    private

    attr_reader :hash

    def define_key_accessor_methods
      hash.transform_values! do |value|
        transform_hash_value(value)
      end
    end

    def transform_hash_value(value)
      if value.is_a?(Hash)
        Struct.new(value.transform_keys(&:to_sym))
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
