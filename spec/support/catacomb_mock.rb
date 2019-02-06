require 'vaulty/catacomb'
require 'active_support/core_ext/hash'

class CatacombMock < Vaulty::Catacomb
  class << self
    def mock_with(data)
      @mocked_data = data
    end

    def read(path)
      structure = path.split('/').map(&:to_sym)
      mocked_data.dig(*structure + %i(_data)) || {}
    end

    def write(path, data)
      structure = path.split('/').map(&:to_sym)
      if @mocked_data.dig(*structure)
        @mocked_data.dig(*structure)[:_data] = data
      else
        nested_data = structure.reverse.inject(_data: data) { |a, n| { n => a } }
        @mocked_data = (mocked_data || {}).deep_merge(nested_data)
      end
    end

    def list(path)
      structure = path.split('/').map(&:to_sym)
      folder = mocked_data.dig(*structure) || {}
      folder.keys - %i(_data)
    end

    def delete(path)
      structure = path.split('/').map(&:to_sym)
      return unless structure.size > 1

      to_delete = structure.pop
      folder = mocked_data.dig(*structure) || {}
      folder.delete(to_delete)
    end

    def mocked_data
      @mocked_data ||= {}
    end
  end
end
