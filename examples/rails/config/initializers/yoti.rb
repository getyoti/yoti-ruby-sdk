Yoti.configure do |config|
  config.client_sdk_id = ENV['YOTI_CLIENT_SDK_ID']
  config.key_file_path = ENV['YOTI_KEY_FILE_PATH']
  config.api_url = ENV['YOTI_API_URL'] ||= 'https://api.yoti.com'
  config.api_port = ENV['YOTI_API_PORT'] ||= '443'
end
