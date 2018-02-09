require 'dotenv/load'
require 'yoti'

Yoti.configure do |config|
  config.client_sdk_id = ENV['YOTI_CLIENT_SDK_ID']
  config.key_file_path = ENV['YOTI_KEY_FILE_PATH']
end

aml_address = Yoti::AmlAddress.new('GBR', 'E1 6DB')
aml_profile = Yoti::AmlProfile.new('Edward Richard George', 'Heath', aml_address)

puts Yoti::Client.aml_check(aml_profile)
