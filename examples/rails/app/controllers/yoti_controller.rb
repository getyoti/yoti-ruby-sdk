class YotiController < ApplicationController
  def index
    @yoti_application_id = ENV['YOTI_APPLICATION_ID']
  end

  def profile
    one_time_use_token = params[:token]
    yoti_activity_details = Yoti::Client.get_activity_details(one_time_use_token)

    if yoti_activity_details.outcome == 'SUCCESS'
      @user_id = yoti_activity_details.user_id
      @base64_selfie_uri = yoti_activity_details.base64_selfie_uri
      @age_verified = yoti_activity_details.age_verified
      @profile = yoti_activity_details.profile

      # Save the selfie file
      if !@profile.selfie.nil?
        File.open(Rails.root.join('public', 'selfie.jpeg'), 'wb') { |file| file.write(@profile.selfie.value) }
      end
    else
      render text: 'Error: Fetching the activity details failed.', status: :error
    end
    render :layout => 'profile'
  end
end