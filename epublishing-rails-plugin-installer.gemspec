# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{epublishing-rails-plugin-installer}
  s.version = "6.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["David McCullars"]
  s.date = %q{2011-05-12}
  s.default_executable = %q{epub-plugin}
  s.description = %q{An extension of standard rails plugin script to provide support for local file system and tgz files}
  s.email = %q{dmccullars@ePublishing.com}
  s.executables = ["epub-plugin"]
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE", "README.rdoc", "lib/commands/epub-plugin.rb"]
  s.files = ["CHANGELOG", "LICENSE", "Manifest", "README.rdoc", "Rakefile", "bin/epub-plugin", "epublishing-rails-plugin-installer.gemspec", "lib/commands/epub-plugin.rb", "lib/epublishing/tgz_builder.rb", "lib/epublishing/tgz_extractor.rb"]
  s.homepage = %q{http://github.com/ePublishing/epublishing-rails-plugin-installer}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Epublishing-rails-plugin-installer", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{epublishing-rails-plugin-installer}
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{An extension of standard rails plugin script to provide support for local file system and tgz files}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<os>, [">= 0.7.4"])
    else
      s.add_dependency(%q<os>, [">= 0.7.4"])
    end
  else
    s.add_dependency(%q<os>, [">= 0.7.4"])
  end
end
