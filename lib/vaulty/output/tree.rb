module Vaulty
  module Output
    class Tree
      attr_reader :tree, :prompt

      def initialize(tree, prompt:)
        @tree = tree
        @prompt = prompt
      end

      def render
        output_tree = flatten_tree(Array(tree), 0)
        rendered_tree = Hirb::Helpers::Tree.render(output_tree,
          type: :directory,
          multi_line_nodes: true)
        prompt.say(rendered_tree)
      end

      def self.render(*args)
        new(*args).render
      end

      private

      def flatten_tree(subtree, level = 0)
        subtree.map do |folder|
          [
            format_node(folder.name, level),
            format_values(folder.data, level + 1),
            flatten_tree(folder.children, level + 1)
          ]
        end.flatten.compact
      end

      def format_values(values, level)
        Array(values).map do |value|
          key_value = "#{value.key}:#{value.value}"
          { value: ["\u{1F511}", key_value].compact.join('  '), level: level }
        end
      end

      def format_node(value, level)
        { value: ["\u{1F4C2}", value].compact.join('  '), level: level }
      end
    end
  end
end
