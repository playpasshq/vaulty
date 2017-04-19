module Vaulty
  module CLI
    class Delete < Command
      attr_reader :catacomb
      def initialize(catacomb:)
        @catacomb = catacomb
      end

      def call
        banner("Current value #{catacomb.path.inspect}")
        # Render the tree first so the user knows what we will delete
        Vaulty::CLI::Tree.call(catacomb)
        # Confirmation
        return if prompt.no?('All above data will be ' \
                              'recursively deleted! Are you sure?', color: :red)

        banner(catacomb.path, color: :red)
        # Start deleting
        delete_recursively(vaulty_tree.children, [catacomb.path])
        # Delete the route of the path
        catacomb.delete
        prompt.ok("Successfully deleted everything in path #{catacomb.path}")
      end

      private

      def delete_recursively(tree, path = [])
        Array(tree).each do |folder|
          current_path = path + [folder.name]
          Catacomb.delete(current_path.join('/')) unless folder.data.empty?
          delete_recursively(folder.children, current_path) unless folder.children.empty?
        end
      end
    end
  end
end
