require 'rails/generators'

module Knock
  class TokenControllerGenerator < Rails::Generators::Base
    source_root File.expand_path("../../templates", __FILE__)
    argument :name, type: :string

    desc <<-DESC
      Creates a Knock token controller for the given entity
      and add the corresponding routes.
    DESC

    def copy_controller_file
      template 'entity_token_controller.rb.erb', "app/controllers/#{name.underscore}_token_controller.rb"
    end

    def add_route
      route "post '#{name.underscore}_token' => '#{name.underscore}_token#create'"
    end

    private

    def entity_name
      name
    end
  end
end
