PROJECT_ROOT = ENV['PROJECT_ROOT'] || File.expand_path(File.dirname(__FILE__))
require "#{PROJECT_ROOT}/lib/acoustic/initializer"
Acoustic::Initializer.run(PROJECT_ROOT)