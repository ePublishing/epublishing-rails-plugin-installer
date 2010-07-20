#--
# tgz_builder.rb - class for building a tgz (or tar.gz) file
#++
#
# == Overview
#
# Yes, yes, in the unixy world we can just `tar czf`, but such
# functionality is not universal.  Instead, we piggy-back on tar
# support built into rubygems (which we assume is installed) and
# utilize the Zlib library (again assumed to be installed as it
# is required by rubygems).
#
# == Example
#
#   TgzBuilder.build('some_src_file.tar.gz', 'some_src_folder')
#   TgzBuilder.build('some_src_file.tar.gz', 'some_src_folder', true) # Prints files as they are built
#
# == Contact
#
#   - David McCullars <dmccullars@ePublishing.com>
#

require 'fileutils'
require 'rubygems'
require 'rubygems/package'

class TgzBuilder

  def self.build(dest, srcdir, verbose=false)
    parent_idx = File.dirname(srcdir).size + 1
    tar_io = StringIO.new
    Gem::Package::TarWriter.new(tar_io) do |tar|
      Dir[File.join srcdir, '**', '**'].each do |file|
        name = file[parent_idx, file.size].sub(/^\.+\//, '')
        mode = File.stat(file).mode
        if File.directory?(file)
          tar.mkdir(name, mode)
        else
          tar.add_file(name, mode) do |out_io|
            File.open(file, 'rb') { |in_io| out_io.write in_io.read }
          end
        end
        puts "+ #{name}" if verbose
      end
    end
    Zlib::GzipWriter.open(dest) do |gz|
      gz.write tar_io.string
    end
  end

end
