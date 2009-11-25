require "acoustic/errors"

module Acoustic
  autoload "Configuration", "acoustic/configuration"
  autoload "Controller",    "acoustic/controller"
  autoload "Dispatcher",    "acoustic/dispatcher"
  autoload "Inflector",     "acoustic/inflector"
  autoload "Router",        "acoustic/router"
  autoload "Settings",      "acoustic/settings"
  
  # Utility
  autoload "BlankSlate",    "acoustic/blank_slate"
  autoload "ERB",           "acoustic/erb"
end