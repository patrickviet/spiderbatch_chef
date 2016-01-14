
file '/etc/spiderbatch.json' do
  mode '0644'
  owner 'root'
  group 'root'
  content JSON.pretty_generate(node.spiderbatch.conf) + "\n"
end

