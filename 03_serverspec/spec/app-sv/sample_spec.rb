require 'spec_helper'

%w{git gcc zlib-devel bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel}.each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe command('pyenv --version') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /pyenv/ }
end

describe command('python -V') do
  its(:stdout) { should match /3\.12\.1/ }
end

describe command('which python') do
  its(:stdout) { should match /pyenv/ }
end

describe command('poetry --version') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /1\.8\.4/ }
end

describe command('ls flask-app ') do
  its(:exit_status) { should eq 0 }
end

describe file('flask-app/flaskr/.env') do
	it { should exist }
  it { should be_file }
  its(:content) { should match /DB_HOST/ }
  its(:content) { should match /DB_USER/ }
  its(:content) { should match /DB_PASSWORD/ }
  its(:content) { should match /DB_NAME/ }
  its(:content) { should match /TABLE_NAME/ }
  its(:content) { should match /ALLOW_FILES/ }
end

describe command('ps aux | grep "gunicorn.*flaskr:app"') do
  its(:stdout) { should match /gunicorn.*--daemon/ }
end

describe port(8000) do
  it { should be_listening }
end

describe command('hostname -I') do
  its(:stdout) { should match /10\.10\.12\./ }
end

describe command('dig +short RDS-ENDPOINT') do
  its(:stdout) { should match /10\.(10|20)\./ }
end
