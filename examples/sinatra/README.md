# Profile Example - _Sinatra_

1. Create your application in the [Yoti Hub](https://hub.yoti.com)
1. Set the application domain of your app to `localhost:4567`
1. Set the scenario callback URL to `/profile`
1. Rename the [.env.example](examples/sinatra/.env.example) file to `.env`
1. Fill in the environment variables in this file with the ones specific to your application, generated in the Yoti Hub when you create (and then publish) your application
1. Install the dependencies by running the following commands
    ```ruby
    $ bundle install
    $ gem install foreman # We are doing this as it's not recommended to include foreman in your Gemfile
    ```
1. Start the server `foreman start`

Visiting `https://localhost:4567/` should show a Yoti Connect button
