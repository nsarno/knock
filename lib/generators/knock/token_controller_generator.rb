module Knock
  class TokenControllerGenerator < Rails::Generators::Base
    source_root File.expand_path("../../templates", __FILE__)
    argument :name, type: :string

    desc <<-DESC
      Creates a Knock token controller for the given resource
      and add the corresponding routes.
    DESC

    def copy_controller_file
      template 'resource_token_controller.rb.erb', "app/controllers/#{name.underscore}_token_controller.rb"
    end

    def add_route
      route "post '#{name.underscore}_token' => '#{name.underscore}_token#create"
    end

    private

    def resource_name
      name
    end
  end
end
