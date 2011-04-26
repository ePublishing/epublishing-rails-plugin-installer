#--
# tgz_extractor.rb - class for extracting a tgz (or tar.gz) file
#++
#
# == Overview
#
# Yes, yes, in the unixy world we can just `tar xzf`, but such
# functionality is not universal.  Instead, we piggy-back on tar
# support built into rubygems (which we assume is installed) and
# utilize the Zlib library (again assumed to be installed as it
# is required by rubygems).
#
# == Example
#
#   TgzExtractor.extract('some_src_file.tar.gz', 'some_dest_folder')
#   TgzExtractor.extract('some_src_file.tar.gz', 'some_dest_folder', true) # Prints files as they are extracted
#
# == Contact
#
#   - David McCullars <dmccullars@ePublishing.com>
#

require 'fileutils'
require 'rubygems'
require 'rubygems/package'

module Epublishing
  class TgzExtractor < Gem::Package::TarInput

    def self.extract(src, destdir, verbose=false)
      tarinput = new
      Zlib::GzipReader.open(src) do |gz|
        io = StringIO.new gz.read
        Gem::Package::TarReader.new(io) do |tar|
          tar.each do |entry|
            puts "+ #{entry.full_name}" if verbose
            tarinput.extract_entry(destdir, entry)
          end
        end
      end
    end

    private

    def initialize
      @fileops = Gem::FileOperations.new
    end

  end
end
