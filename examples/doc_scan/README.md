# Doc Scan Example - _Ruby on Rails_

1. Create your application in the [Yoti Hub](https://hub.yoti.com)
1. Set the application domain of your app to `localhost:3002`
1. Rename the [.env.example](.env.example) file to `.env`
1. Fill in the environment variables in this file with the ones specific to your application, generated in the Yoti Hub when you create (and then publish) your application
1. Install the dependencies by running the following commands from this folder
    ```shell
    $ bundle install
    $ gem install foreman # We are doing this as it's not recommended to include foreman in your Gemfile
    ```
1. Start the server
    ```shell
    $ foreman start
    ```
