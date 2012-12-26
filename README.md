# PortCatcher

Catch your free port

## Installation

Add this line to your application's Gemfile:

    gem 'port_catcher'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install port_catcher

## Usage

``` ruby
require "port_catcher"

catcher = PortCatcher.new(30000..40000)
catcher.grab # => 30884
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
