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
require 'epublishing/tgz_extractor'

gem "rails"

rails_plugin = File.expand_path "../../lib/commands/plugin.rb", Gem.datadir("rails")
eval File.read(rails_plugin).sub(/^Commands::Plugin.parse!/, "")

RailsEnvironment.class_eval do

  # Fix a bug in rails that assumes plugin is svn-based
  alias :externals_without_non_svn= :externals=
  def externals_with_non_svn=(items)
    send(:externals_without_non_svn=, items) unless items.nil? or items.empty?
  end
  alias :externals= :externals_with_non_svn=

end

Plugin.class_eval do

  class << self
    alias :find_without_file_existence_check :find
    def find_with_file_existence_check(name)
      File.exists?(name) ? new(name) : find_without_file_existence_check(name)
    end
    alias :find :find_with_file_existence_check
  end

  alias :guess_name_without_tgz_support :guess_name
  def guess_name_with_tgz_support(url)
    guess_name_without_tgz_support(url)
    @name.gsub!(/\.t(ar\.)?gz$/, '')
  end
  alias :guess_name :guess_name_with_tgz_support

  alias :install_without_tgz_and_file_support :install
  def install_with_tgz_and_file_support(method=nil, options = {})
    method = :tgz if @uri =~ /\.t(ar\.)?gz$/
    method = :file if File.exists?(@uri) and File.directory?(@uri)
    install_without_tgz_and_file_support(method, options)
  end
  alias :install :install_with_tgz_and_file_support

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
      Epublishing::TgzExtractor.extract(@uri, install_path, true)
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

# Fix Bug in windows with 1.9.2
require 'active_support'
require 'os'
module Kernel

  def silence_stream(stream)
    old_stream = stream.dup
    stream.reopen(OS.dev_null)
    stream.sync = true
    yield
  ensure
    stream.reopen(old_stream)
  end

end

Commands::Plugin.parse!
