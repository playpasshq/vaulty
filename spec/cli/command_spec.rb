RSpec.describe Vaulty::CLI::Command do
  let(:instance) { described_class.new }

  describe '#call' do
    subject { instance.call }
    it 'raises an error' do
      expect { subject }.to raise_exception(NotImplementedError, /.call is not implemented/)
    end
  end

  describe '#banner' do
    subject { instance.banner('banner', color: :red) }
    it 'delegates to Banner#render' do
      expect(Vaulty::Output::Banner).to receive(:render).with('banner', color: :red, prompt: instance_of(TTY::Prompt))
      subject
    end
  end

  describe '#table' do
    subject { instance.table('table', highlight: { matching: ['data'], color: :red }) }
    it 'delegates to Banner#render' do
      expect(Vaulty::Output::Table).to receive(:render).with('table',
        highlight: { matching: ['data'], color: :red }, prompt: instance_of(TTY::Prompt))
      subject
    end
  end

  describe '.call' do
    subject { described_class.call }
    it 'creates a new instance and calls call' do
      instance = instance_double(described_class, call: true)
      expect(described_class).to receive(:new).and_return(instance)
      expect(instance).to receive(:call)
      subject
    end
  end
end
