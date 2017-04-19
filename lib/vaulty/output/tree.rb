module Vaulty
  module Output
    class Tree
      attr_reader :tree, :value_icon, :dir_icon
      def initialize(tree, value_icon: "\u{1F511}", dir_icon: "\u{1F4C2}")
        @tree = tree
        @value_icon = value_icon
        @dir_icon = dir_icon
      end

      def render
        output_tree = flatten_tree(Array(tree), 0)
        puts Hirb::Helpers::Tree.render(output_tree, type: :directory, multi_line_nodes: true)
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
          { value: [value_icon, "#{value.key}:#{value.value}"].compact.join('  '), level: level }
        end
      end

      def format_node(value, level)
        { value: [dir_icon, value].compact.join('  '), level: level }
      end
    end
  end
end
