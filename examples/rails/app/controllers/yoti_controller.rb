class YotiController < ApplicationController
  def index
    @yoti_application_id = ENV['YOTI_APPLICATION_ID']
  end

  def profile
    one_time_use_token = params[:token]
    yoti_activity_details = Yoti::Client.get_activity_details(one_time_use_token)

    if yoti_activity_details.outcome == 'SUCCESS'
      @user_id = yoti_activity_details.user_id

      user_profile = yoti_activity_details.user_profile
      @base64_selfie_uri = yoti_activity_details.base64_selfie_uri
      @age_verified = yoti_activity_details.age_verified

      @full_name = user_profile['full_name']
      @given_names = user_profile['given_names']
      @family_name = user_profile['family_name']
      @mobile_number = user_profile['phone_number']
      @email_address = user_profile['email_address']
      @date_of_birth = user_profile['date_of_birth']
      @address = user_profile['postal_address']
      @gender = user_profile['gender']
      @nationality = user_profile['nationality']

      # Save the selfie file
      File.open(Rails.root.join('public', 'selfie.jpeg'), 'wb') { |file| file.write(user_profile['selfie']) }
    else
      render text: 'Error: Fetching the activity details failed.', status: :error
    end
  end
end
