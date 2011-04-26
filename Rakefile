require 'rake'
require 'echoe'
require 'rake/rdoctask'

task :default => :gem

Echoe.new("epublishing-rails-plugin-installer") do |s|
  s.author = "David McCullars"
  s.project = "epublishing-rails-plugin-installer"
  s.email = "dmccullars@ePublishing.com"
  s.url = "http://github.com/ePublishing/epublishing-rails-plugin-installer"
  s.docs_host = "http://rdoc.info/github/ePublishing/epublishing-rails-plugin-installer/master/frames"
  s.rdoc_pattern = /README|TODO|LICENSE|CHANGELOG|BENCH|COMPAT|exceptions|behaviors|epub-plugin.rb/
  s.clean_pattern += ["ext/lib", "ext/include", "ext/share", "ext/libepublishing-rails-plugin-installer-?.??", "ext/bin", "ext/conftest.dSYM"]
  s.summary = 'An extension of standard rails plugin script to provide support for local file system and tgz files'
end

desc 'generate API documentation to doc/rdocs/index.html'
Rake::RDocTask.new do |rd|
  rd.rdoc_dir = 'doc/rdocs'
  rd.main = 'README.rdoc'
  rd.rdoc_files.include 'README.rdoc', 'CHANGELOG', 'lib/**/*.rb'
  rd.rdoc_files.exclude '**/string_ext.rb', '**/net_https_hack.rb'
  rd.options << '--inline-source'
  rd.options << '--line-numbers'
  rd.options << '--all'
  rd.options << '--fileboxes'
end
