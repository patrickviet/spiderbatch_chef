include_recipe 'spiderbatch::gem'
include_recipe 'runit'

file '/etc/spiderbatch.json' do
  mode '0600'
  owner 'root'
  group 'root'
  content JSON.pretty_generate(node.spiderbatch.conf) + "\n"
  notifies :restart, 'runit_service[spiderbatch_node]'
end

runit_service 'spiderbatch_node'
