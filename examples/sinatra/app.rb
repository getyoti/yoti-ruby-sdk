#!/usr/bin/env ruby

# You can either run this example with `ruby app.rb` or
# `./app.rb` make sure it's executable (chmod +x app.rb) or
# `dotenv ./app.rb` if you're using the Dotenv gem
require 'dotenv/load'
require 'sinatra'
require 'yoti'

Yoti.configure do |config|
  config.client_sdk_id = ENV['YOTI_CLIENT_SDK_ID']
  config.key_file_path = ENV['YOTI_KEY_FILE_PATH']
  config.api_url = ENV['YOTI_API_URL'] ||= 'https://api.yoti.com'
  config.api_port = ENV['YOTI_API_PORT'] ||= '443'
end

get '/' do
  erb :index, locals: { yoti_application_id: ENV['YOTI_APPLICATION_ID'] }
end

# /profile is the callback route
get '/profile' do
  one_time_use_token = params[:token]
  yoti_activity_details = Yoti::Client.get_activity_details(one_time_use_token)

  if yoti_activity_details.outcome == 'SUCCESS'
    profile = yoti_activity_details.profile

    # Save the selfie file
    if !profile.selfie.nil?
        File.open(File.join(settings.root, 'public', 'selfie.jpeg'), 'wb') { |file| file.write(profile.selfie.value) }
    end

    erb :profile, locals: {
      profile: profile,
      user_id: yoti_activity_details.user_id,
      age_verified: yoti_activity_details.age_verified,
      base64_selfie_uri: yoti_activity_details.base64_selfie_uri,
    }
  else
    status 500
    'Error: Fetching the activity details failed.'
  end
end
