module Vaulty
  class CLIApp
    extend GLI::App

    program_desc 'Describe your application here'

    version Vaulty::VERSION

    subcommand_option_handling :normal
    arguments :strict

    accept(Array) do |value|
      Hash[*value.split(':')]
    end

    desc 'Describe some switch here'
    switch %i[s switch]

    desc 'Describe some flag here'
    default_value 'the default'
    arg_name 'The name of the argument'
    flag %i[f flagname]

    desc 'Add a new key/value to the given `PATH`, multiple `key:value` can be provided'
    arg(:path)
    command :add do |c|
      c.flag %i[secret s], desc: 'Key/Values to save', type: Array, multiple: true,
                           required: true, arg_name: 'key:secret'

      c.action do |_global_options, options, _args|
        data = options[:secret].reduce({}, :merge)
        catacomb = options[:catacomb]
        Vaulty::CLI::Add.call(catacomb: catacomb, data: data)
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

    desc 'Describe backup here'
    arg_name 'Describe arguments to backup here'
    command :backup do |c|
      c.action do |_global_options, _options, _args|
        puts 'backup command ran'
      end
    end

    desc 'Describe convert here'
    arg_name 'Describe arguments to convert here'
    command :convert do |c|
      c.action do |_global_options, _options, _args|
        puts 'convert command ran'
      end
    end

    desc 'Describe diff here'
    arg_name 'Describe arguments to diff here'
    command :diff do |c|
      c.action do |_global_options, _options, _args|
        puts 'diff command ran'
      end
    end

    desc 'Describe generate here'
    arg_name 'Describe arguments to generate here'
    command :generate do |c|
      c.action do |_global_options, _options, _args|
        puts 'generate command ran'
      end
    end

    desc 'Describe provision here'
    arg_name 'Describe arguments to provision here'
    command :provision do |c|
      c.action do |_global_options, _options, _args|
        puts 'provision command ran'
      end
    end

    desc 'Describe remove here'
    arg_name 'Describe arguments to remove here'
    command :remove do |c|
      c.action do |_global_options, _options, _args|
        puts 'remove command ran'
      end
    end

    desc 'Describe restore here'
    arg_name 'Describe arguments to restore here'
    command :restore do |c|
      c.action do |_global_options, _options, _args|
        puts 'restore command ran'
      end
    end

    desc 'Describe write here'
    arg_name 'Describe arguments to write here'
    command :write do |c|
      c.action do |_global_options, _options, _args|
        puts 'write command ran'
      end
    end

    pre do |_global, _command, options, args|
      path = args.first
      exit_now!('path must be provided') if path.nil? || path.empty?
      options[:catacomb] = Vaulty::Catacomb.new(path)
    end

    post do |global, command, options, args|
      # Post logic here
      # Use skips_post before a command to skip this
      # block on that command only
    end

    on_error do |_exception|
      # Error logic here
      # return false to skip default error handling
      true
    end
  end
end
