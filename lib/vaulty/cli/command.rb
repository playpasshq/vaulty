module Vaulty
  module CLI
    class Command
      def banner(msg, color: :green)
        Vaulty::Output::Banner.render(msg, color: color)
      end

      def table(data, highlight: {})
        Vaulty::Output::Table.render(data, highlight: highlight)
      end

      def prompt
        @prompt ||= TTY::Prompt.new
      end

      def self.call(*args)
        new(*args).call
      end
    end
  end
end
