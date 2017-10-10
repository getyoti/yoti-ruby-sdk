# Contributing

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rake spec` to run the tests. To install this gem onto your local machine, run `bundle exec rake install`.

You can use [Guard][] to automatically run the tests every time a file in the `lib` or `spec` folder changes.


Run Guard through Bundler with:

```shell
$ bundle exec guard
```

[Guard]: https://github.com/guard/guard

## Dependencies

Although this gem supports Ruby 2.0.0, in order to use the latest development dependencies you have to use at least Ruby 2.2.2.

If you wish to compile `.proto` definitions to Ruby, you will need to install [Google's Protocol Buffers](http://code.google.com/p/protobuf).

### OSX

```shell
$ brew install protobuf
```

### Ubuntu
```shell
$ sudo apt-get install -y protobuf
```

This gem relies heavily on the [Ruby Protobuf][] gem. For more information on how Google Protobuf works, please see the [Wiki pages][].

Compiling the common and attribute `.proto` definitions can be done with the following commands:

```shell
$ cd lib/yoti/protobuf/v1
$ protoc -I definitions/attribute-public-api/attrpubapi_v1 --ruby_out ./attribute_public_api definitions/attribute-public-api/attrpubapi_v1/*.proto
$ protoc -I definitions/common-public-api/compubapi_v1/ --ruby_out ./common_public_api definitions/common-public-api/compubapi_v1/*.proto
```

These commands will overwrite the current protobuf Ruby modules, which have been modified. If the protobuf files have to be updated, a good idea would be to change them manually, or generate the files in a new location, and compare the content.

[Ruby Protobuf]: https://github.com/ruby-protobuf/protobuf/
[Wiki Pages]:    https://github.com/ruby-protobuf/protobuf/wiki

## Requirements

### Code coverage

The 100% code coverage requirement must be met before submitting new code.
This can be checked by opening the generated [SimpleCov][] files:

 ```shell
 $ open coverage/index.html
 ```

### Style guide
The Ruby style guide is configured in the [rubocop.yml](rubocop.yml) file and can be checked by running:

```shell
$ bundle exec rake rubocop
```

### Documentation
The documentation uses the [Yard][] format. Please ensure all new classes and methods are fully documented.

There are a few Rake tasks to handle documentation:

```shell
$ bundle exec rake measurement
```

Verifies the documentation with [Yardstick][] and generates the `measurement/report.txt` file, containing tips on how to improve the documentation coverage.

```shell
$ bundle exec rake verify_measurements
```

Verifies that the [Yardstick][] coverage matches the one set in the [Rakefile](Rakefile).

```shell
$ bundle exec rake yard
```
Generates [YARD][] documentation in the doc folder.

### Git

Commit messages should ideally start with one of the following verbs:

* Add
* Merge
* Fix
* Remove
* Improve
* Use

[SimpleCov]:   https://github.com/colszowka/simplecov
[Yard]:        http://yardoc.org/
[Yardstick]:   https://github.com/dkubb/yardstick

## Publishing a new release

* Update the [changelog](CHANGELOG.md) and the [lib/yoti/version.rb](lib/yoti/version.rb) file
* Create a new release on [GitHub](https://github.com/getyoti/yoti-ruby-sdk/releases)
* Build the gem and push it to [RubyGems](https://rubygems.org/gems/yoti)

```shell
rake build
gem push pkg/yoti-[version].gem
```

## Submitting a pull request
1. [Fork the repository.][fork]
2. [Create a topic branch.][branch]
3. Add specs for your unimplemented feature or bug fix.
4. Run `bundle exec rake spec`. If your specs pass, return to step 3.
5. Implement your feature or bug fix.
6. Run `bundle exec rake`. If your specs fail, return to step 5.
7. Run `open coverage/index.html`. If your changes are not completely covered
   by your tests, return to step 3.
8. If Rubocop warns you about styling errors, correct them based on the guidelines and run `bundle exec rake rubocop` to make sure all offences are gone.
9. Add documentation for your feature or bug fix.
10. Commit and push your changes.
11. [Submit a pull request.][pr]

[fork]: http://help.github.com/fork-a-repo/
[branch]: http://learn.github.com/p/branching.html
[pr]: http://help.github.com/send-pull-requests/
