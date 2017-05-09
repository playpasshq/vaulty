module Vaulty
  module CLI
    class Command
      # Interface method should be defined by subclasses
      # @raise [NotImplementedError]
      #
      def call
        raise NotImplementedError, "#{inspect}.call is not implemented"
      end

      # Render a banner
      # @see Vaulty::Output::Banner
      # @param [String] msg to be placed in the banner
      # @param [Symbol] color optional color
      #
      def banner(msg, color: :green)
        Vaulty::Output::Banner.render(msg, color: color)
      end

      # Renders a table
      # @param [Array<Array>] data row/columns
      # @param [Hash] highlgiht options passed to (see Vaulty::Output::HighlightFilter)
      # @option highlight [Array] :matching strings to highlight
      # @option highlight [Symbol] :color to be used for highlighting
      #
      def table(data, highlight: {})
        Vaulty::Output::Table.render(data, highlight: highlight)
      end

      # Initializes a new command with the args and calls it
      # @param [Hash] args anything
      #
      def self.call(*args)
        new(*args).call
      end

      # Returns an instance of {TTY::Prompt}
      # @return [TTY::Prompt] instance
      #
      def prompt
        @prompt ||= TTY::Prompt.new
      end
    end
  end
end
