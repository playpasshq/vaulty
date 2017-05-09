RSpec.describe Vaulty::CLI::Tree do
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

  subject { instance.call }
  let(:output) { instance.prompt.output.string }

  before :each do
    allow(Vaulty).to receive(:catacomb).and_return(CatacombMock)
    allow(Vaulty).to receive(:prompt).and_return(TTY::TestPrompt.new)
    CatacombMock.mock_with(data)
  end

  it 'displays the output as a tree' do
    subject
    expect(output).to include <<~TXT
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
    let(:catacomb) { CatacombMock.new('secret/unknown') }
    it 'raises an exception' do
      expect { subject }.to raise_error(Vaulty::EmptyPath,
        /Path "secret\/unknown" contains nothing/)
    end
  end
end
