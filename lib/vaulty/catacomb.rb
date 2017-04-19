module Vaulty
  class Catacomb
    attr_reader :path
    # @param [String] the path to be used
    def initialize(path)
      @path = path
    end

    # Checks if the key is found in the data
    # @param [String] key
    # @return [Boolean]
    #
    def key?(key)
      read.key?(key.to_sym)
    end

    # Checks if any of the provided keys are found in the data
    # @param [Array<String>] keys
    # @return [Boolean]
    #
    def keys?(keys)
      matching_keys(keys).any?
    end

    # Returns matching keys
    # @param [Array<String>] keys
    # @return [Array<String>] keys that matched
    #
    def matching_keys(keys)
      Array(keys).select { |key| key?(key) }
    end

    # Writes data to Vault with an optional confirm/msg
    # @param [Hash] data
    #
    def write(data)
      self.class.write(path, data)
      reload
    end

    # Merges the data to Vault with an optional confirm/msg
    # @param [Hash] data
    #
    def merge(data)
      current = read
      write(current.merge(data))
    end

    # Reads the data from Vault, always returns an Hash
    # @return [Hash]
    #
    def read
      @read ||= self.class.read(path)
    end

    # Clears the cached result from read and returns the result
    # @return [Hash]
    #
    def reload
      @read = nil
      read
    end

    # Deletes a path (with all values) from Vault
    # @param [Boolean] confirm
    # @param [String] msg
    # @return [True]
    #
    def delete
      self.class.delete(path)
      @read = nil
    end

    class << self
      # Wrapper around Vault logical read, return always a hash
      # @param [String] path
      # @return [Hash]
      #
      def read(path)
        secret = Vault.logical.read(path)
        secret ? secret.data : {}
      end

      # Wrapper around Vault logical write
      # @param [String] path
      # @param [Hash] data
      # @return [Hash] secret
      #
      def write(path, data)
        secret = Vault.logical.write(path, data)
        secret.is_a?(Vault::Secret) ? secret.data : {}
      end

      # Wrapper around Vault logical list
      # @param [String] path
      # @return [Array] secrets
      #
      def list(path)
        list = Vault.logical.list(path)
        cleaned_list = Array(list).map { |folder| folder.gsub(/\//, '') }
        cleaned_list.reject(&:empty?).uniq
      end

      # Wrapper around Vault logical delete
      # @param [String] path
      # @return [Boolean]
      #
      def delete(path)
        Vault.logical.delete(path)
      end
    end
  end
end
