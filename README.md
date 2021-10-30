# GAF

This is a Ruby library to read/write files/spreadsheets in Google Drive/Docs.

NOTE: This is NOT a library to create Google Drive App.


* [How to install](#install)
* [How to use](#use)
* [API documentation](http://www.rubydoc.info/gems/google_drive)
* [Authorization](https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md)
* [Github](https://github.com/Huyliver6793/gaf)
* [License](#license)
* [Author](#author)

## <a name="install">How to install</a>

Add this line to your application's Gemfile:

```ruby
gem 'gaf'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install gaf
```

If you need system wide installation, execute below:

```
$ sudo gem install gaf
```

## <a name="use">How to use</a>

### Authorization

Follow one of the options in [Authorization](https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md) to construct a session object. The example code below assumes "On behalf of you" option.

### Configuration
+ First create gaf.rb on config/initializers/gaf.rb
+ Add config as below

```ruby
Gaf.configure do |config|
  # See this document to learn how to create config.json:
  # https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md
  config.google_application_credential = "config.json"
  config.title_worksheet = "Test" # spreadsheet's name
  config.array_main_branchs = ["staging", "master"] # main branch
end
```

+ Then, configure a route to receive the github webhook POST requests.
```ruby
# config/routes.rb
namespace :api do
    namespace :v1, defaults: {format: :json} do
      post "/hook_githubs_test", to: "webhook_githubs#hook_event_github"
    end
  end
```

+ Then create a new controller:
```ruby
# app/v1/controllers/webhook_githubs_controller.rb
class Api::V1::WebhookGithubsController < ApplicationController
  include Gaf::Processor
end
```


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Author
https://github.com/Huyliver6793
