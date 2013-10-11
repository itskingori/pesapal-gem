module Pesapal
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a Pesapal config file to your application."

      def copy_initializer
        copy_file "pesapal.yml", "config/pesapal.yml"
      end

      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end