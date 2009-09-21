# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fakepage}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rafael Souza"]
  s.date = %q{2009-09-20}
  s.description = %q{Agnostic library for test web requests creating fake pages. With fakepage you can make tests requests to the web pages, independently of the framework used to do that}
  s.email = %q{me@rafaelss.com}
  s.homepage = %q{http://rafaelss.com/}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{fakepage}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Agnostic library for test web requests creating fake pages}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thin>, [">= 1.2.2"])
    else
      s.add_dependency(%q<thin>, [">= 1.2.2"])
    end
  else
    s.add_dependency(%q<thin>, [">= 1.2.2"])
  end
end
