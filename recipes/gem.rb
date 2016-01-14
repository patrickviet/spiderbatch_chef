
# Readability: We use this in 3 places so let's define it only once...
gemfile = "#{Chef::Config[:file_cache_path]}/spiderbatch-#{node.spiderbatch.gem_version}.gem"

remote_file gemfile do
  source "#{node.spiderbatch.baseurl}/spiderbatch-#{node.spiderbatch.gem_version}.gem"
  mode '0644'
  owner 'root'
  group 'root'
end

if node.spiderbatch.embedded_chef_ruby
  chef_gem 'spiderbatch' do
    source gemfile
    version node.spiderbatch.gem_version
  end
else
  gem_package 'spiderbatch' do
    source gemfile
    version node.spiderbatch.gem_version
  end
end
