RSpec.describe Vaulty::CLI::Add do
  let(:instance) { described_class.new(catacomb: catacomb, data: data, files: files) }
  let(:catacomb) { CatacombMock.new('secret/account') }
  let(:data) { { key: 'value' } }
  let(:files) { {} }
  let(:confirmation) { true }
  let(:existing_data) { {} }
  let(:output) { instance.prompt.output.string }

  before do
    allow(Vaulty).to receive(:prompt).and_return(TTY::TestPrompt.new)
    allow(Vaulty.prompt).to receive(:no?).and_return(!confirmation)
    CatacombMock.mock_with(existing_data)
  end

  subject { instance.call }

  describe '#call' do
    it 'prints out a banner' do
      subject
      expect(output).to include_output('Current value "secret/account"')
    end

    it 'writes the data' do
      expect(catacomb).to receive(:merge).with(key: 'value')
      subject
    end

    it 'prints the resulting table' do
      subject
      expect(output).to include_output('key')
      expect(output).to include_output('value')
    end

    context 'when existing data is present' do
      let(:existing_data) do
        { secret: { account: { _data: { existing: 'value' } } } }
      end

      it 'prints out the current table' do
        subject
        expect(output).to include_output('existing')
        expect(output).to include_output('value')
      end

      context 'when existing data matches the given data' do
        let(:existing_data) do
          { secret: { account: { _data: { key: 'value' } } } }
        end

        it 'prints out the table with higlights' do
          subject
          expect(output).to include_output('key')
          expect(output).to include_output('value')
        end

        context 'when answering no' do
          let(:confirmation) { false }
          let(:existing_data) do
            { secret: { account: { _data: { key: 'value' } } } }
          end

          it 'does not write any data' do
            expect(catacomb).not_to receive(:merge)
            subject
          end
        end

        context 'when answering yes' do
          let(:confirmation) { true }
          let(:existing_data) do
            { secret: { account: { _data: { key: 'other value' } } } }
          end

          it 'overwrites the key and value' do
            expect(catacomb).to receive(:merge).with(key: 'value')
            subject
          end

          it 'prints out the resulting table and higlights the values' do
            subject
            expect(output).to include_output('key')
            expect(output).to include_output('other value')
          end
        end
      end
    end

    context 'when files are provided' do
      let(:files) { { file: [FIXTURE_PATH, 'secret.txt'].join('/') } }

      it 'prints out a banner' do
        subject
        expect(output).to include_output('Current value "secret/account"')
      end

      it 'writes the file contents' do
        expect(catacomb).to receive(:merge).with(key: 'value', file: "secret\n")
        subject
      end

      it 'prints the resulting table' do
        subject
        expect(output).to include_output('file')
        expect(output).to include_output('secret')
      end
    end
  end
end
