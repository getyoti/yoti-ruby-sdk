# Yoti Ruby SDK

Welcome to the Yoti Ruby SDK. This repository contains the tools you need to quickly integrate your Ruby back-end with Yoti so that your users can share their identity details with your application in a secure and trusted way.

## Table of Contents

1. [An Architectural view](#an-architectural-view) - High level overview of integration
1. [Requirements](#requirements) - Everything you need to get started
1. [Installing the SDK](#installing-the-sdk) - How to install our SDK
1. [Configuration](#configuration) - Configuring the SDK
1. [Profile Retrieval](#profile-retrieval) - How to retrieve a Yoti profile using the one time use token
1. [AML Integration](#aml-integration) - How to integrate with Yoti's AML (Anti Money Laundering) service
1. [Running the Examples](#running-the-examples) - How to run the example projects provided
1. [API Coverage](#api-coverage) - Attributes defined
1. [Support](#support) - Please feel free to reach out

## An Architectural view

To integrate your application with Yoti, your back-end must expose a GET endpoint that Yoti will use to forward tokens.
The endpoint is configured in the [Yoti Dashboard](https://www.yoti.com/dashboard) where you create/update your application. To see an example of how this is configured, see the [Running the Examples](#running-the-examples) section.

The image below shows how your application back-end and Yoti integrate into the context of a Login flow.
Yoti SDK carries out for you steps 6, 7, 8 and the profile decryption in step 9.

![alt text](login_flow.png "Login flow")

Yoti also allows you to enable user details verification from your mobile app by means of the Android (TBA) and iOS (TBA) SDKs. In that scenario, your Yoti-enabled mobile app is playing both the role of the browser and the Yoti app. Your back-end doesn't need to handle these cases in a significantly different way, but you might decide to handle the `User-Agent` header in order to provide different responses for desktop and mobile clients.

## References

* [AES-256 symmetric encryption][]
* [RSA pkcs asymmetric encryption][]
* [Protocol buffers][]
* [Base64 data][]

[AES-256 symmetric encryption]:   https://en.wikipedia.org/wiki/Advanced_Encryption_Standard
[RSA pkcs asymmetric encryption]: https://en.wikipedia.org/wiki/RSA_(cryptosystem)
[Protocol buffers]:               https://en.wikipedia.org/wiki/Protocol_Buffers
[Base64 data]:                    https://en.wikipedia.org/wiki/Base64

## Requirements

The Yoti gem requires at least Ruby `2.4.0`.
If you're using a version of Ruby lower than 2.2.2 you might encounter issues when [Bundler][] tries to install the [Active Support][] gem. This can be avoided by manually requiring activesupport 4.2.

```ruby
gem activesupport '~> 4.2'
```

Versions of [Bundler][] > 1.13 will sort this dependency issue automatically. More info in this [comment][] by André Arko.

[comment]: https://github.com/bundler/bundler-features/issues/120#issuecomment-214514847
[Bundler]: http://bundler.io/
[Active Support]: https://rubygems.org/gems/activesupport/

## Installing the SDK

To import the Yoti SDK inside your project, add this line to your application's Gemfile:

```ruby
gem 'yoti'
```

And then execute:

```shell
bundle install
```

Or simply run the following command from your terminal:

```shell
[sudo] gem install yoti
```

## SDK Project Import

The gem provides a generator for the initialization file:

```shell
rails generate yoti:install
```

The generated initialisation file can be found in `config/initializers/yoti.rb`.

## Configuration

A minimal Yoti client initialisation looks like this:

```ruby
Yoti.configure do |config|
  config.client_sdk_id = ENV['YOTI_CLIENT_SDK_ID']
  config.key_file_path = ENV['YOTI_KEY_FILE_PATH']
end
```

Make sure the following environment variables can be accessed by your app:

`YOTI_CLIENT_SDK_ID` - found on the Key settings page on your application dashboard

`YOTI_KEY_FILE_PATH` - the full path to your security key downloaded from the *Keys* settings page (e.g. /Users/developer/access-security.pem)

The following options are available:

Config               | Required | Default                | Note
---------------------|----------|------------------------|-----
`client_sdk_id`      | Yes      |                        | SDK identifier generated by when you publish your app
`key_file_path`      | Yes      |                        | Path to the pem file generated when you create your app
`api_url`            | No       | `https://api.yoti.com` | Path to Yoti URL used for debugging purposes
`api_port`           | No       | 443                    | Path to Yoti port used for debugging purposes

Keeping your settings and access keys outside your repository is highly recommended. You can use gems like [dotenv][] to manage environment variables more easily.

[dotenv]: https://github.com/bkeepers/dotenv

### Deploying to Heroku / AWS Elastic Beanstalk

Although we recommend using a pem file to store your secret key, and take advantage of the UNIX file permissions, your hosting provider might not allow access to the file system outside the deployment process.

If you're using Heroku or other alternative services, you can store the content of the secret key in an environment variable.

Your configuration should look like this:

```ruby
Yoti.configure do |config|
  config.client_sdk_id = ENV['YOTI_CLIENT_SDK_ID']
  config.key = ENV['YOTI_KEY']
end
```

Where `YOTI_KEY` is an environment variable with the following format: `YOTI_KEY="-----BEGIN RSA PRIVATE KEY-----\nMIIEp..."`

An easier way of setting this on Heroku would be to use the [Heroku Command Line][]

```shell
heroku config:add YOTI_KEY ="$(cat your-access-security.pem)"
```

[Heroku Command Line]: https://devcenter.heroku.com/articles/heroku-command-line

## Profile Retrieval

When your application receives a one time use token via the exposed endpoint (it will be assigned to a query string parameter named `token`), you can easily retrieve the user profile:

```ruby
one_time_use_token = params[:token]
yoti_activity_details = Yoti::Client.get_activity_details(one_time_use_token)
```

Before you inspect the user profile, you might want to check whether the user validation was successful. This is done as follows:

```ruby
if yoti_activity_details.outcome == 'SUCCESS'
  profile = yoti_activity_details.profile
  given_names = profile.given_names.value
  family_name = profile.family_name.value
else
  # handle unhappy path
end
```

The `profile` object provides a set of attributes corresponding to user attributes. Whether the attributes are present or not depends on the settings you have applied to your app on Yoti Dashboard.

### Handling Users

When you retrieve the user profile, you receive a user ID generated by Yoti exclusively for your application.
This means that if the same individual logs into another app, Yoti will assign her/him a different ID.
You can use this ID to verify whether (for your application) the retrieved profile identifies a new or an existing user.
Here is an example of how this works:

```ruby
if yoti_activity_details.outcome == 'SUCCESS'
  user = your_user_search_function(yoti_activity_details.user_id)
  profile = yoti_activity_details.profile

  if user
    # handle login
    email = profile.email_address.value
  else
    # handle registration
    given_names = profile.given_names.value
    family_name = profile.family_name.value
    email = profile.email_address.value
  end
else
  # handle unhappy path
end
```

Where `your_user_search_function` is a piece of logic in your app that is supposed to find a user, given a user_id. Regardless of whether the user is a new or an existing one, Yoti will always provide their profile, so you don't necessarily need to store it.

You can retrieve the sources and verifiers for each attribute as follows:

```ruby
given_names_sources = profile.given_names.sources // list of anchors
given_names_verifiers = profile.given_names.verifiers // list of anchors
```
You can also retrieve further properties from these respective anchors in the following way:

```ruby
// Retrieving properties of the first anchor
value = given_names_sources[0].value // string
sub_type = given_names_sources[0].sub_type // string
time_stamp = given_names_sources[0].signed_time_stamp.time_stamp // DateTime object
origin_server_certs = given_names_sources[0].origin_server_certs // list of X509 certificates
```

In case you want to prove the sources and verifiers of the helper`ActivityDetails.age_verified` on `Age Over 18` set as age derivation, please retrieve it's original attribute from the profile as follow:

```ruby
age_attribute = profile.get_attribute('age_over:18')
sources = age_attribute.sources
verifiers = age_attribute.verifiers
```

## AML Integration

Yoti provides an AML (Anti Money Laundering) check service to allow a deeper KYC process to prevent fraud. This is a chargeable service, so please contact [sdksupport@yoti.com](mailto:sdksupport@yoti.com) for more information.

Yoti will provide a boolean result on the following checks:

* PEP list - Verify against Politically Exposed Persons list
* Fraud list - Verify against  US Social Security Administration Fraud (SSN Fraud) list
* Watch list - Verify against watch lists from the Office of Foreign Assets Control

To use this functionality you must ensure your application is assigned to your organisation in the Yoti Dashboard - please see [here](https://www.yoti.com/developers/documentation/#1-creating-an-organisation) for further information.

For the AML check you will need to provide the following:

* Data provided by Yoti (please ensure you have selected the Given name(s) and Family name attributes from the Data tab in the Yoti Dashboard)
  * Given name(s)
  * Family name
* Data that must be collected from the user:
  * Country of residence (must be an ISO 3166 3-letter code)
  * Social Security Number (US citizens only)
  * Postcode/Zip code (US citizens only)

### Consent

Performing an AML check on a person *requires* their consent.
**You must ensure you have user consent *before* using this service.**

### Code Example

Given a YotiClient initialised with your SDK ID and KeyPair (see [Client Initialisation](#client-initialisation)) performing an AML check is a straightforward case of providing basic profile data.

```ruby
require 'yoti'

Yoti.configure do |config|
  config.client_sdk_id = ENV['YOTI_CLIENT_SDK_ID']
  config.key_file_path = ENV['YOTI_KEY_FILE_PATH']
end

aml_address = Yoti::AmlAddress.new('GBR')
aml_profile = Yoti::AmlProfile.new('Edward Richard George', 'Heath', aml_address)

puts Yoti::Client.aml_check(aml_profile)
```

## Running the Examples

The examples can be found in the [examples folder](examples). 

### Ruby on Rails

1. Create your application in the [Yoti Dashboard](https://www.yoti.com/dashboard/applications)
1. Set the application domain of your app to `localhost:3000`
1. Set the scenario callback URL to `/profile`
1. Rename the [.env.example](examples/rails/.env.example) file to `.env` 
1. Fill in the environment variables in this file with the ones specific to your application (mentioned in the [Configuration](#configuration) section)
1. Install the dependencies by running the following commands
    ```ruby
    $ bundle install
    $ gem install foreman # We are doing this as it's not recommended to include foreman in your Gemfile
    ```
1. Start the server `foreman start`

Visiting `https://localhost:3001/` should show a Yoti Connect button

### Sinatra

1. Create your application in the [Yoti Dashboard](https://www.yoti.com/dashboard/applications)
1. Set the application domain of your app to `localhost:4567`
1. Set the scenario callback URL to `/profile`
1. Rename the [.env.example](examples/sinatra/.env.example) file to `.env`
1. Fill in the environment variables in this file with the ones specific to your application (mentioned in the [Configuration](#configuration) section)
1. Install the dependencies by running the following commands
    ```ruby
    $ bundle install
    $ gem install foreman # We are doing this as it's not recommended to include foreman in your Gemfile
    ```
1. Start the server `foreman start`

Visiting `https://localhost:4567/` should show a Yoti Connect button

### AML Check

* rename the [.env.example](examples/aml_check/.env.example) file to `.env` and fill in the required configuration values
* install the dependencies with `bundle install`
* run the script with `ruby ./app.rb`

## API Coverage

* Activity Details
  * [X] Remember Me ID `remember_me_id`
  * [X] Parent Remember Me ID `parent_remember_me_id`
  * [X] Base64 Selfie URI `base64_selfie_uri`
  * [X] Age verified `age_verified`
  * [X] Profile `profile`
    * [X] Selfie `selfie`
    * [X] Full Name `full_name`
    * [X] Given Names `given_names`
    * [X] Family Name `family_name`
    * [X] Mobile Number `phone_number`
    * [X] Email Address `email_address`
    * [X] Age / Date of Birth `date_of_birth`
    * [X] Address `postal_address`
    * [X] Gender `gender`
    * [X] Nationality `nationality`

## Support

For any questions or support please email [sdksupport@yoti.com](mailto:sdksupport@yoti.com).
Please provide the following to get you up and working as quickly as possible:

* Computer type
* OS version
* Version of Ruby being used
* Screenshot

Once we have answered your question we may contact you again to discuss Yoti products and services. If you’d prefer us not to do this, please let us know when you e-mail.
