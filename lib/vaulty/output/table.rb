module Vaulty
  module Output
    class HighlightFilter
      attr_reader :matching, :color
      def initialize(matching: [], color: :red)
        @matching = matching
        @color = color
      end

      def call(val, _row, _column)
        matching.include?(val.strip) ? pastel.decorate(val, color) : val
      end

      def pastel
        Pastel::Color.new(enabled: true)
      end
    end

    class Table
      DEFAULT_HEADER = %w[Key Value].freeze
      attr_reader :data, :prompt, :header

      def initialize(data, header: DEFAULT_HEADER, highlight: {})
        @data = data
        @prompt = TTY::Prompt.new
        @filter = HighlightFilter.new(**highlight)
        @header = header
      end

      def render
        table = TTY::Table.new(data, header: header, style: :markdown)
        renderer = table.render(:ascii) do |render|
          render.padding = [0, 2, 0, 2]
          render.filter = @filter
        end
        prompt.say renderer
      end

      def self.render(*args)
        new(*args).render
      end
    end
  end
end
