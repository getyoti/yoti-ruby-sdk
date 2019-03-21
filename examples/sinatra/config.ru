# config.ru
$LOAD_PATH << File.expand_path(__dir__)

require 'app'
run Sinatra::Application
