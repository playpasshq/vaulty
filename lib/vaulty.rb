require 'vaulty/version.rb'

# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file

require 'gli'
require 'vault'
require 'hirb'
require 'hashdiff'
require 'pastel'
require 'tty-table'
require 'tty-spinner'
require 'tty-prompt'

require 'vaulty/cli_app'
require 'vaulty/catacomb'
require 'vaulty/vault_tree'

require 'vaulty/cli/command'
require 'vaulty/cli/add'
require 'vaulty/cli/delete'
require 'vaulty/cli/remove'
require 'vaulty/cli/tree'

require 'vaulty/output/banner'
require 'vaulty/output/table'
require 'vaulty/output/tree'

module Vaulty
  # This error is raised when we try to show / operate on a path
  # that does not contain anything
  # @see GLI::CustomExit
  #
  class EmptyPath < GLI::CustomExit
    # @param [String] path
    def initialize(path)
      super("Path #{path.inspect} contains nothing", -1)
    end
  end

  class MissingKeys < GLI::CustomExit
    # @param [String] path
    # @param [Array<String>, String] keys
    def initialize(path, keys)
      super("Path #{path.inspect} does not contain #{Array(keys).join(', ')}", -1)
    end
  end

  # Returns the prompt instance so it's always the same instance
  # @return [TTY::Prompt]
  #
  def self.prompt
    @prompt ||= TTY::Prompt.new
  end

  # Returns the Catacomb class
  # @return [Vaulty::Catacomb]
  #
  def self.catacomb
    @catacomb ||= Vaulty::Catacomb
  end
end
