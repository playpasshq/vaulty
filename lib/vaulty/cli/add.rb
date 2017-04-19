module Vaulty
  module CLI
    class Add < Command

      attr_reader :catacomb, :data
      # @param [Catacomb] catacomb instance
      # @param [Hash] data
      def initialize(catacomb:, data:)
        @catacomb = catacomb
        @data = data
      end

      def call
        banner("Current value #{catacomb.path.inspect}")
        # Print out the current state
        table(catacomb.read, highlight: { matching: matching_keys, color: :red })
        # If we have matching keys and we don't want to continue, we exit
        return if matching_keys.any? && prompt.no?("Existing secret found, overwrite?")
        # Print we are writing and merge the content
        banner("Writing data to #{catacomb.path.inspect}", color: :red)
        catacomb.merge(data)
        # Print the final state in a table highlight the values we added
        table(catacomb.read, highlight: { matching: data.values, color: :green })
      end

      private

      def matching_keys
        @matching_keys ||= catacomb.matching_keys(data.keys)
      end
    end
  end
end
