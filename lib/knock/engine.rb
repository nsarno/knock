module Knock
  class Engine < ::Rails::Engine
    paths.add "lib", eager_load: true
    isolate_namespace Knock
  end
end
