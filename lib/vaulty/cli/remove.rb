module Vaulty
  module CLI
    class Remove < Command
      attr_reader :catacomb, :keys
      def initialize(catacomb:, keys:)
        @catacomb = catacomb
        @keys = keys
      end

      def call
        found_keys = Array(catacomb.matching_keys(keys))
        raise Vaulty::MissingKeys.new(catacomb.path, keys) if found_keys.empty?

        banner("Found keys #{found_keys.join(', ')} at #{catacomb.path.inspect}")
        table(catacomb.read, highlight: { matching: found_keys, color: :red })
        return if prompt.no?('All above data will be deleted! Are you sure?', color: :red)

        delete_keys(found_keys)
        prompt.ok("Successfully deleted keys #{found_keys.join(', ')} at #{catacomb.path.inspect}")
      end

      private

      def delete_keys(keys)
        current_data = catacomb.read
        new_data = current_data.reject { |k, _v| keys.include?(k.to_s) }
        if new_data.empty?
          catacomb.delete
        else
          catacomb.write(new_data)
        end
      end
    end
  end
end
