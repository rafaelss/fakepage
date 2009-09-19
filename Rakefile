require 'rubygems'
require 'rubygems/specification'
require 'rake'
require 'rake/gempackagetask'
require 'spec/rake/spectask'
 
GEM = "fakepage"
GEM_VERSION = "0.2.0"
SUMMARY = "Agnostic library for test web requests creating fake pages"
DESCRIPTION = "Agnostic library for test web requests creating fake pages. With fakepage you can make tests requests to the web pages, independently of the framework used to do that"
AUTHOR = "Rafael Souza"
EMAIL = "me@rafaelss.com"
HOMEPAGE = "http://rafaelss.com/"

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = SUMMARY
  s.description = DESCRIPTION
  s.require_paths = ['lib']
  s.files = FileList['lib/**/*.rb' '[A-Z]*'].to_a

  s.add_dependency(%q<thin>, [">= 1.2.2"])

  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE

  s.rubyforge_project = GEM # GitHub bug, gem isn't being build when this miss
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Run all the tests"
task :test do
  begin
    require 'bacon'
    require 'curb'
    sh "bacon --automatic --quiet"
  rescue LoadError
    puts "You need to install bacon and curb gem to run tests"
  end
end

desc "Create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

desc "Install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end