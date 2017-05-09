RSpec.describe Vaulty::CLI::Tree, type: :aruba do
  let(:instance) { described_class.new(catacomb: catacomb) }
  let(:catacomb) { CatacombMock.new('secret') }
  let(:data) do
    {
      secret: {
        first: {
          nested: {
            _data: { key: 'value' },
          },
          _data: { key: 'value' }
        },
        other: {
          _data: { key: 'value' }
        }
      }
    }
  end

  subject { capture(:stdout) { instance.call } }

  before :each do
    stub_const('Vaulty::Catacomb', CatacombMock)
    CatacombMock.mock_with(data)
  end

  it 'displays the output as a tree' do
    expect(subject).to output_string_eq <<~TXT
      📂  secret
      |-- 📂  first
      |   |-- 🔑  key:value
      |   `-- 📂  nested
      |       `-- 🔑  key:value
      `-- 📂  other
          `-- 🔑  key:value
    TXT
  end

  context 'when the path contains nothing' do
    let(:catacomb) { CatacombMock.new('secret/i-do-not-know') }
    it 'raises an exception' do
      expect { subject }.to raise_error(Vaulty::CLI::Tree::Empty, /Path "secret\/i-do-not-know" contains nothing/)
    end
  end
end
