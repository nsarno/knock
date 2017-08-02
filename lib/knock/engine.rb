require 'rails/engine'

module Knock
  class Engine < ::Rails::Engine
    isolate_namespace Knock
  end
end
