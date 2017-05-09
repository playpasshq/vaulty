require 'vaulty/catacomb'
require 'active_support/core_ext/hash'

class CatacombMock < Vaulty::Catacomb
  class << self
    def mock_with(data)
      @data = data
    end

    def read(path)
      structure = path.split('/').map(&:to_sym)
      mocked_data.dig(*structure + %i(_data)) || {}
    end

    def write(path, data)
      structure = path.split('/').map(&:to_sym)
      if @data.dig(*structure)
        @data.dig(*structure)[:_data] = data
      else
        nested_data = structure.reverse.inject(_data: data) { |a, n| { n => a } }
        @data = (@data || {}).deep_merge(nested_data)
      end
    end

    def list(path)
      structure = path.split('/').map(&:to_sym)
      folder = mocked_data.dig(*structure) || {}
      folder.keys - %i(_data)
    end

    def delete(path)
      structure = path.split('/').map(&:to_sym)
      folder = mocked_data.dig(*structure) || {}
      folder.delete
    end

    def mocked_data
      @data || {}
    end
  end
end

RSpec.configure do |config|
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end
end
