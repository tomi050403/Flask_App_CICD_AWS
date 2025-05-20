require 'serverspec'
require 'net/ssh'
require 'net/ssh/proxy/command'

set :backend, :ssh
host = ENV['TARGET_HOST']

instance_ids = {
  'app-sv' => 'APP-INSTANCE-NUMBER',
  'web-sv' => 'WEB-INSTANCE-NUMBER'
}

set :host, instance_ids[host]

set :ssh_options, {
  user: 'ec2-user',
  keys: ['GHA-FLASK-APP.pem'],
  proxy: Net::SSH::Proxy::Command.new(
    "sh -c 'aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters \"portNumber=%p\"'"
  )
}

set :path, '/home/ec2-user/.pyenv/shims:/home/ec2-user/.pyenv/bin:/home/ec2-user/.local/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin'
