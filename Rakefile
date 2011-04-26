require 'rake'
require 'rubygems'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
  s.name = %q{epublishing-installer}
  s.version = "6.0.2"
  s.author = "David McCullars"
  s.executables = ["epub-plugin"]
  s.files = FileList["{bin,lib}/**/*"].to_a
  s.require_path = "lib"
  s.summary = <<DONE
'epublishing-installer' is an extension of rails 'plugin' executable
for easier installation of the epublishing plugin.
DONE
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end
