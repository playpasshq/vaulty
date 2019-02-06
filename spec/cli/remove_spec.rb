RSpec.describe Vaulty::CLI::Remove do
  let(:instance) { described_class.new(catacomb: catacomb, keys: keys) }
  let(:catacomb) { CatacombMock.new('secret/account') }
  let(:confirmation) { true }
  let(:existing_data) do
    {
      secret: {
        account: {
          _data: { key: 'value', a: 'b', c: 'd' }
        }
      }
    }
  end
  let(:output) { instance.prompt.output.string }
  let(:keys) { %w(a c unknown) }

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
      expect(output).to include_output('Found keys a, c at "secret/account"')
    end

    it 'prints out the table' do
      subject
      expect(output).to include_output('a')
      expect(output).to include_output('c')
      expect(output).to include_output('key')
    end

    context 'when answering no' do
      let(:confirmation) { false }

      it 'does not write any data' do
        expect(catacomb).not_to receive(:write)
        subject
      end
    end

    context 'when answering yes' do
      let(:confirmation) { true }

      it 'removes the keys' do
        expect(catacomb).to receive(:write).with(key: 'value')
        subject
      end

      it 'shows the ok message' do
        subject
        expect(output).to include_output('Successfully deleted keys a, c at "secret/account"')
      end
    end

    context 'when last key is deleted' do
      let(:keys) { %w(a c unknown key) }

      it 'calls delete on the path' do
        expect(catacomb).to receive(:delete)
        subject
      end

      it 'shows the ok message' do
        subject
        expect(output).to include_output('Successfully deleted keys a, c, key at "secret/account"')
      end
    end
  end
end
