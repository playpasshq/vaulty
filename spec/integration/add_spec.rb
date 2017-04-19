RSpec.describe 'Adding Secrets', type: :aruba do
  subject { run_simple("bundle exec vaulty add -s key:value secret/data") }

  it 'allow to add a new secret' do
    subject
    expect(last_command_started.stdout).to include_output_string('Current value "secret/data"')
    expect(last_command_started.stdout).to include_output_string('Writing data to "secret/data"')
  end

  it 'shows the output as a table' do
    subject
    expect(last_command_started.stdout).to include_output_string <<~TXT
      +-------+---------+
      |  Key  |  Value  |
      +-------+---------+
      |  key  |  value  |
      +-------+---------+
    TXT
  end

  context 'when the key already exists' do
    before :each do
      run_simple("bundle exec vaulty add -s key:value secret/data")
    end

    describe 'asks for confirmation' do
      context 'answering yes' do
        it 'will overwrite the secret' do
          run("bundle exec vaulty add -s key:new_value secret/data")
          type('y')
          last_command_started.stop
          expect(last_command_started.stdout).to include_output_string <<~TXT
            +-------+-------------+
            |  Key  |  Value      |
            +-------+-------------+
            |  key  |  new_value  |
            +-------+-------------+
          TXT
        end
      end

      context 'answering no' do
        it 'will not overwrite the secret' do
          run("bundle exec vaulty add -s key:new_value secret/data")
          type('n')
          last_command_started.stop
          expect(last_command_started.stdout).to include_output_string <<~TXT
            +-------+---------+
            |  Key  |  Value  |
            +-------+---------+
            |  key  |  value  |
            +-------+---------+
          TXT
        end
      end
    end
  end

  context 'when other data already exists' do
    before :each do
      run_simple("bundle exec vaulty add -s existing:value secret/data")
    end

    it 'does not overwrite the existing data' do
      subject
      expect(last_command_started.stdout).to include_output_string 'Writing data to "secret/data"'
      expect(last_command_started.stdout).to include_output_string <<~TXT
        +------------+---------+
        |  Key       |  Value  |
        +------------+---------+
        |  existing  |  value  |
        |  key       |  value  |
        +------------+---------+
      TXT
    end
  end
end
