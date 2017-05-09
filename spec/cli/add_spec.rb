RSpec.describe Vaulty::CLI::Add do
  let(:instance) { described_class.new(catacomb: catacomb, data: data) }
  let(:catacomb) { CatacombMock.new('secret/account') }
  let(:data) { { key: 'value' } }
  let(:confirmation) { true }
  let(:existing_data) { {} }

  before :each do
    allow(Vaulty).to receive(:prompt).and_return(TTY::TestPrompt.new)
    allow(Vaulty.prompt).to receive(:no?).and_return(!confirmation)
    CatacombMock.mock_with(existing_data)
  end

  subject { instance.call }
  let(:output) { instance.prompt.output.string }

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
      expect(output).to include_output <<~TXT
        +-------+---------+
        |  Key  |  Value  |
        +-------+---------+
        |  key  |  value  |
        +-------+---------+
      TXT
    end

    context 'when existing data is present' do
      let(:existing_data) {
        { secret: { account: { _data: { existing: 'value' } } } }
      }

      it 'prints out the current table' do
        subject
        expect(output).to include_output <<~TXT
          +------------+---------+
          |  Key       |  Value  |
          +------------+---------+
          |  existing  |  value  |
          +------------+---------+
        TXT
      end

      context 'when existing data matches the given data' do
        let(:existing_data) {
          { secret: { account: { _data: { key: 'value' } } } }
        }

        it 'prints out the table with higlights' do
          subject
          expect(output).to include_output <<~TXT
            +-------+---------+
            |  Key  |  Value  |
            +-------+---------+
            |  key  |  value  |
            +-------+---------+
          TXT
        end

        context 'when answering no' do
          let(:confirmation) { false }
          let(:existing_data) {
            { secret: { account: { _data: { key: 'value' } } } }
          }

          it 'does not write any data' do
            expect(catacomb).not_to receive(:merge)
            subject
          end
        end

        context 'when answering yes' do
          let(:confirmation) { true }
          let(:existing_data) {
            { secret: { account: { _data: { key: 'other value' } } } }
          }

          it 'overwrites the key and value' do
            expect(catacomb).to receive(:merge).with(key: 'value')
            subject
          end

          it 'prints out the resulting table and higlights the values' do
            subject
            expect(output).to include_output <<~TXT
              +-------+---------------+
              |  Key  |  Value        |
              +-------+---------------+
              |  key  |  other value  |
              +-------+---------------+
            TXT
          end
        end
      end
    end
  end
end
