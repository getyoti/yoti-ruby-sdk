class YotiController < ApplicationController
  def index
    @yoti_scenario_id = ENV['YOTI_SCENARIO_ID']
    @yoti_client_sdk_id = ENV['YOTI_CLIENT_SDK_ID']
  end

  def dynamic_share
    @yoti_client_sdk_id = ENV['YOTI_CLIENT_SDK_ID']

    scenario = Yoti::DynamicSharingService::DynamicScenario.builder.with_policy(
      Yoti::DynamicSharingService::DynamicPolicy.builder
        .with_full_name
        .with_age_over(18)
        .with_pin_auth
        .build
    ).with_callback_endpoint('/profile').build

    @share = Yoti::DynamicSharingService.create_share_url(scenario)
    puts "!DEBUG! #{@share}"
    @share_url = @share.share_url
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
      File.open(Rails.root.join('public', 'selfie.jpeg'), 'wb') { |file| file.write(@profile.selfie.value) } unless @profile.selfie.nil?
    else
      render text: 'Error: Fetching the activity details failed.', status: :error
    end
    render layout: 'profile'
  end
end
