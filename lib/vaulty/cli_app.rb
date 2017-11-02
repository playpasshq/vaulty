module Vaulty
  class CLIApp
    extend GLI::App

    program_desc 'Vault CLI on steriods'

    version Vaulty::VERSION

    subcommand_option_handling :normal
    arguments :strict

    accept(Array) do |value|
      Hash[*value.split(':')]
    end

    desc 'Add a new key/value to the given `PATH`, multiple `key:value` can be provided'
    arg(:path)
    command :add do |c|
      c.flag %i(secret s), desc: 'Key/Values to save', type: Array, multiple: true,
                           required: true, arg_name: 'key:secret'

      c.flag %i(file f), desc: 'Key/File to be uploaded', type: Array, multiple: true,
                         arg_name: 'key:/path/file.ext'

      c.action do |_global_options, options, _args|
        data = options[:secret].reduce({}, :merge)
        files = options[:file].reduce({}, :merge)
        catacomb = options[:catacomb]
        Vaulty::CLI::Add.call(catacomb: catacomb, data: data, files: files)
      end
    end

    desc 'Deletes everything under the path recursively'
    arg(:path)
    command :delete do |c|
      c.action do |_global_options, options, _args|
        catacomb = options[:catacomb]
        Vaulty::CLI::Delete.call(catacomb: catacomb)
      end
    end

    desc 'Represents the path as a tree'
    arg(:path)
    command :tree do |c|
      c.action do |_global_options, options, _args|
        catacomb = options[:catacomb]
        Vaulty::CLI::Tree.call(catacomb: catacomb)
      end
    end

    pre do |_global, _command, options, args|
      path = args.first
      exit_now!('path must be provided') if path.nil? || path.empty?
      options[:catacomb] = Vaulty.catacomb.new(path)
    end

    on_error do |_exception|
      # Error logic here
      # return false to skip default error handling
      true
    end
  end
end
