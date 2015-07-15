module Knock
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../../templates", __FILE__)

    desc "Creates a Knock initializer."

    def copy_initializer
      template 'knock.rb', 'config/initializers/knock.rb'
    end
  end
end
