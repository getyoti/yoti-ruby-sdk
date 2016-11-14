module Yoti
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      desc 'This generator creates an Yoti initializer file at config/initializers'

      def copy_initializer
        template 'yoti.rb', 'config/initializers/yoti.rb'
      end
    end
  end
end
