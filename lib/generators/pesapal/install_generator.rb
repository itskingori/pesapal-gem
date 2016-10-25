# Since generators are not specific to this project, it's preferable you refer
# to the official documentation on the Rails site here;
# http://guides.rubyonrails.org/generators.html
module Pesapal
  module Generators
    # Install pesapal generator
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)
      desc 'Creates a Pesapal config file to your application.'

      def copy_config
        copy_file 'pesapal.yml', 'config/pesapal.yml'
      end

      def show_readme
        readme 'README.md' if behavior == :invoke
      end
    end
  end
end
