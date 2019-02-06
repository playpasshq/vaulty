RSpec.describe Vaulty::CLI::Delete do
  let(:instance) { described_class.new(catacomb: catacomb) }
  let(:catacomb) { CatacombMock.new('secret/account') }
  let(:confirmation) { true }
  let(:existing_data) do
    {
      secret: {
        account: {
          _data: { key: 'value' }
        }
      }
    }
  end
  let(:output) { instance.prompt.output.string }

  before do
    allow(Vaulty).to receive(:prompt).and_return(TTY::TestPrompt.new)
    allow(Vaulty).to receive(:catacomb).and_return(CatacombMock)
    allow(Vaulty.prompt).to receive(:no?).and_return(!confirmation)
    CatacombMock.mock_with(existing_data)
  end

  subject { instance.call }

  describe '#call' do
    it 'prints out the banner' do
      subject
      expect(output).to include_output('Current value "secret/account"')
    end

    it 'prints out the tree of the to be deleted data' do
      subject
      expect(output).to include_output <<~TXT
        📂  secret/account
        `-- 🔑  key:value
      TXT
    end

    it 'removes the top directory recursivly' do
      subject
      expect(output).to include_output('Successfully deleted everything in path')
    end

    context 'when the path is empty' do
      let(:catacomb) { CatacombMock.new('secret/unknown') }

      it 'raises an exception' do
        expect { subject }.to raise_exception(Vaulty::EmptyPath)
      end
    end

    context 'when the path contains a directory with secrets' do
      let(:existing_data) do
        {
          secret: {
            account: {
              admin: {
                _data: { user: 'value' }
              },
              _data: { key: 'value' }
            },
            user: {
              _data: { wont: 'delete' }
            }
          }
        }
      end

      it 'recursivly delete' do
        subject
        expect(CatacombMock.mocked_data).to eq(secret: {
          user: { _data: { wont: 'delete' } }
        })
      end
    end

    context 'when answering no' do
      let(:confirmation) { false }

      it 'does not delete anything' do
        subject
        expect(CatacombMock).not_to receive(:delete)
      end
    end
  end
end
