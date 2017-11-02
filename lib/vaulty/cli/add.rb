module Vaulty
  module CLI
    class Add < Command
      attr_reader :catacomb, :data
      # @param [Catacomb] catacomb instance
      # @param [Hash] data
      # @param [Hash] files
      def initialize(catacomb:, data: {}, files: {})
        @catacomb = catacomb
        files_with_content = read_file_contents!(files)
        @data = data.merge(files_with_content)
      end

      def call
        banner("Current value #{catacomb.path.inspect}")
        # Print out the current state
        table(catacomb.read, highlight: { matching: matching_keys, color: :red })
        # If we have matching keys and we don't want to continue, we exit
        return if matching_keys.any? && prompt.no?('Existing secret found, overwrite?')
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

      def read_file_contents!(files)
        files.each_with_object({}) do |(key, path), memo|
          memo[key] = read_file(path)
        end
      end

      def read_file(path)
        File.read(File.expand_path(path))
      end
    end
  end
end
