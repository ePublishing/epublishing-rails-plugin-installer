#--
# epub-plugin.rb - class to add functionality to standard rails 'plugin' script
#++
#
# == Overview
#
# The standard rails 'plugin' script lacks support for installing
# from the local file system as well as installing tar.gz files.
# (The latter scenario greatly speeds up installation from http
# as the alternative is downloading each file, one-by-one.)
#
# This class piggy-backs on the standard rails 'plugin' command and
# can be used as a complete replacement if so desired.
#
# == Example
#
#   epub-plugin install /some/location/on/the/disk
#   epub-plugin install http://somewhere.com/foo/a_plugin.tgz
#   epub-plugin install http://somewhere.com/foo/another_plugin.tar.gz
#
# == Contact
#
#   - David McCullars <dmccullars@ePublishing.com>
#

require 'tmpdir'
require 'rubygems'
require 'tgz_extractor'

gem "rails"
rails_plugin = File.expand_path(File.join(Gem.datadir("rails"), "../../lib/commands/plugin.rb"))
eval File.read(rails_plugin).sub(/Commands::Plugin.parse!/, "")

OLD_EXTERNALS_SET_METHOD = RailsEnvironment.instance_method(:externals=)
RailsEnvironment.class_eval do

  # Fix a bug in rails that assumes plugin is svn-based
  def externals=(items)
    OLD_EXTERNALS_SET_METHOD.bind(self).call(items) unless items.empty?
  end

end

OLD_FIND_METHOD = Plugin.method(:find)
OLD_GUESS_NAME_METHOD = Plugin.instance_method(:guess_name)
OLD_INSTALL_METHOD = Plugin.instance_method(:install)
Plugin.class_eval do

  def self.find(name)
    File.exists?(name) ? new(name) : OLD_FIND_METHOD.call(name)
  end

  def guess_name(url)
    OLD_GUESS_NAME_METHOD.bind(self).call(url)
    @name.gsub!(/\.t(ar\.)?gz$/, '') if @name =~ /\.t(ar\.)?gz$/
  end

  def install(method=nil, options = {})
    method = :tgz if @uri =~ /\.t(ar\.)?gz$/
    method = :file if File.exists?(@uri) and File.directory?(@uri)
    OLD_INSTALL_METHOD.bind(self).call(method, options)
  end

  def install_using_tgz(options = {})
    temp_file = nil
    mkdir_p(install_path = "#{rails_env.root}/vendor/plugins/#{name}")
    if @uri =~ /https?:/
      temp_file = File.join(Dir.tmpdir, "#{name}_#{Time.now.to_f.to_s}.tar.gz")
      puts "Downloading #{@uri} to #{temp_file}"
      io = File::open(temp_file, 'wb')
      open(@uri) {|d| io.write d.read }
      io.flush
      io.close
      @uri = temp_file
    else
      @uri = File.expand_path(@uri)
    end
    Dir.chdir(install_path) do
      system(%Q[tar xvzf "#{@uri}"]) or
      TgzExtractor.extract(@uri, install_path, true)
    end
  ensure
    rm temp_file unless temp_file.nil?
  end

  def install_using_file(options = {})
    plugins_dir = "#{rails_env.root}/vendor/plugins"
    mkdir_p(install_path = "#{plugins_dir}/#{name}")
    puts "Copying from #{@uri}" if $verbose
    cp_r(@uri, plugins_dir)
    Dir.chdir install_path do
      rm_rf %w(.git .gitignore README)
    end
  end

end

Commands::Plugin.parse!
