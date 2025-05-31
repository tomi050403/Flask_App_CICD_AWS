require 'spec_helper'

describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/nginx/conf.d/flask-app.conf') do
  it { should be_file }
  its(:content) { should match /proxy_pass http:\/\/app.dev.instance.privatelocal:8000;/ }
end

describe port(80) do
  it { should be_listening }
end

describe host('app.TF-ENVIRONMENT.instance.privatelocal') do
  it { should be_resolvable }
end
  
describe command('curl http://app.TF-ENVIRONMENT.instance.privatelocal:8000 -o /dev/null -w "%{http_code}\n" -s') do
  its(:stdout) { should match /^200$/ }
end

describe command('hostname -I') do
  its(:stdout) { should match /10\.10\.11\./ }
end

