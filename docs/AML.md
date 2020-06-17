# AML Integration

## About

Yoti provides an AML (Anti Money Laundering) check service to allow a deeper KYC process to prevent fraud. This is a chargeable service, so please contact [sdksupport@yoti.com](mailto:sdksupport@yoti.com) for more information.

Yoti will provide a boolean result on the following checks:

* PEP list - Verify against Politically Exposed Persons list
* Fraud list - Verify against  US Social Security Administration Fraud (SSN Fraud) list
* Watch list - Verify against watch lists from the Office of Foreign Assets Control

To use this functionality you must ensure your application is assigned to your Organisation in the Yoti Hub - please see [here](https://developers.yoti.com/yoti-app/web-integration#step-1-creating-an-organisation) for further information.

For the AML check you will need to provide the following:

* Data provided by Yoti
  * Given name(s)
  * Family name
  * Postcode/Zip code (US citizens only) - this can be retrieved from the Structured Postal Address attribute

* Data that must be collected from the user:
  * Country of residence (must be an ISO 3166 3-letter code)
  * Social Security Number (US citizens only)

## Consent

Performing an AML check on a person *requires* their consent.
**You must ensure you have user consent *before* using this service.**

## Performing a Check

Performing an AML check is a straightforward case of providing basic profile data.

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

## Running the example

- See the [AML Example](../examples/aml_check/README.md) folder for instructions on how to run the AML Example project
