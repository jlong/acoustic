require 'rubygems'
gem 'rake'
gem 'rspec'
require 'rake'
require 'rake/rdoctask'
require 'spec/rake/spectask'

task :default => :spec

Spec::Rake::SpecTask.new do |t|
  t.warning = false
  t.rcov = false
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['--options', 'spec/spec.opts']
end

Rake::RDocTask.new(:docs) do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rrdoc", "lib/**/*.rb")
  rd.options << "--all"
end