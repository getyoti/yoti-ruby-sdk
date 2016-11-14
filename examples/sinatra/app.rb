#!/usr/bin/env ruby

# You can either run this example with `ruby app.rb` or
# `./app.rb` make sure it's executable (chmod +x app.rb) or
# `dotenv ./app.rb` if you're using the Dotenv gem

require 'sinatra'
require 'yoti'

Yoti.configure do |config|
  config.client_sdk_id = ENV['YOTI_CLIENT_SDK_ID']
  config.key_file_path = ENV['YOTI_KEY_FILE_PATH']
  config.api_url = ENV['YOTI_API_URL'] ||= 'https://api.yoti.com'
  config.api_port = ENV['YOTI_API_PORT'] ||= 443
end

get '/' do
  erb :index, locals: { yoti_application_id: ENV['YOTI_APPLICATION_ID'] }
end

# /profile is the callback route
get '/profile' do
  yoti_activity_details = Yoti::Client.get_activity_details(params[:token])

  if yoti_activity_details.outcome == 'SUCCESS'
    user_profile = yoti_activity_details.user_profile
    erb :profile, locals: {
      user_id: yoti_activity_details.user_id,
      photo: user_profile['selfie'],
      given_names: user_profile['given_names'],
      family_name: user_profile['family_name'],
      mobile_number: user_profile['phone_number'],
      date_of_birth: user_profile['date_of_birth'],
      address: user_profile['post_code'],
      gender: user_profile['gender'],
      nationality: user_profile['nationality']
    }
  else
    status 500
    'Error: Fetching the activity details failed.'
  end
end
