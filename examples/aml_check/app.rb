require 'dotenv/load'
require 'securerandom'
require 'yoti'

Yoti.configure do |config|
  config.client_sdk_id = ENV['YOTI_CLIENT_SDK_ID']
  config.key_file_path = ENV['YOTI_KEY_FILE_PATH']
end

# AML check for outside the USA

first_name = 'Edward Richard George'
last_name = 'Heath'
country_code = 'GBR'

aml_address = Yoti::AmlAddress.new(country_code)
aml_profile = Yoti::AmlProfile.new(first_name, last_name, aml_address)

puts Yoti::Client.aml_check(aml_profile)

# AML check for USA (requires postcode and SSN)

first_name = 'Edward Richard George'
last_name = 'Heath'
country_code = 'USA'
post_code = '012345'
ssn = '123123123'

aml_address = Yoti::AmlAddress.new(country_code, post_code)
aml_profile = Yoti::AmlProfile.new(first_name, last_name, aml_address, ssn)

puts Yoti::Client.aml_check(aml_profile)
