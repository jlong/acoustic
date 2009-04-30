PROJECT_ROOT = ENV['PROJECT_ROOT'] || File.expand_path(File.dirname(__FILE__))
require "#{PROJECT_ROOT}/lib/rango/initializer"
Rango::Initializer.run(PROJECT_ROOT)