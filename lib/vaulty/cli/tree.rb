module Vaulty
  module CLI
    class Tree < Command
      class Empty < GLI::CustomExit
        def initialize(path)
          super("Path #{path.inspect} contains nothing", -1)
        end
      end

      attr_reader :catacomb
      # @param [Catacomb] catacomb instance
      def initialize(catacomb:)
        @catacomb = catacomb
      end

      def call
        spinner = TTY::Spinner.new("Loading :spinner", format: :arrow_pulse, clear: true)
        spinner.auto_spin
        vaulty_tree = Vaulty::VaultTree.new(catacomb: catacomb).tree
        spinner.stop

        raise Empty, catacomb.path if vaulty_tree.empty?
        Vaulty::Output::Tree.render(vaulty_tree)
      end
    end
  end
end
