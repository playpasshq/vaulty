module Vaulty
  class VaultTree
    class Folder
      attr_reader :name, :data, :children
      def initialize(name:, data:, children:)
        @name = name
        @data = data
        @children = children
      end

      def empty?
        data.empty? && children.empty?
      end
    end

    class Value
      attr_reader :key, :value
      def initialize(key:, value:)
        @key = key
        @value = value
      end
    end

    attr_reader :catacomb
    def initialize(catacomb:)
      @catacomb = catacomb
    end

    def tree
      @tree ||= Folder.new(
        name: catacomb.path,
        data: read_values_for(catacomb.path),
        children: find_subtree(catacomb.path)
      )
    end

    def flatten
      flatten_tree(Array(render))
    end

    private

    def flatten_tree(subtree)
      subtree.map do |folder|
        {
          name: folder.name,
          data: folder.data.map(&:to_h),
          children: flatten_tree(folder.children)
        }
      end
    end

    def find_subtree(base_path)
      list = Vaulty.catacomb.list(base_path)
      list.map do |folder|
        file_or_folder = [base_path, folder].join('/')
        values = read_values_for(file_or_folder)
        Folder.new(
          name: folder,
          data: values,
          children: find_subtree(file_or_folder)
        )
      end
    end

    def read_values_for(path)
      Vaulty.catacomb.read(path).map do |key, value|
        Value.new(key: key, value: value)
      end
    end
  end
end
