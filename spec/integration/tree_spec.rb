RSpec.describe 'Displaying the Tree', type: :aruba do
  subject { run_simple('bundle exec vaulty tree secret') }

  before :each do
    run_simple('bundle exec vaulty add -s key:value -s key:value_2 secret/first')
    run_simple('bundle exec vaulty add -s key:value -s key:value_2 secret/first/nested')
    run_simple('bundle exec vaulty add -s key:value -s key:value_2 secret/other')
  end

  it 'displays the output as a tree' do
    subject
    expect(last_command_started.stdout).to output_string_eq <<~TXT
      📂  secret
      |-- 📂  first
      |   |-- 🔑  key:value_2
      |   `-- 📂  nested
      |       `-- 🔑  key:value_2
      `-- 📂  other
          `-- 🔑  key:value_2
    TXT
  end

  context 'when the path does not exist' do
    it 'displays an error' do
      run('bundle exec vaulty tree secret/path/not/there')
      last_command_started.stop
      expect(last_command_started).not_to be_successfully_executed
      expect(last_command_started.stderr).to include_output_string <<~TXT
        error: Path "secret/path/not/there" contains nothing
      TXT
    end
  end
end
