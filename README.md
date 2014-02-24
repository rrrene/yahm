# Yahm

Yahm is a hash to hash translator for ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'yahm'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yahm

## Usage


### Most basic example

```ruby
require "yahm"

class Record
  extend Yahm::HashMapper
  
  define_mapper :from_other_record do
    map "/record/id", to: "/id"
  end
end

Record.new.from_other_record({ ... })
=> { :id => "..." }
```

### More advanced example

```ruby
require "yahm"

class Record
  extend Yahm::HashMapper
  attr_accessor :translated_hash
  
  define_mapper :from_other_record, call_setter: :translated_hash= do
    map "/record/id", to: "/id"
    map "/record/count", to: "/count", processed_by: :to_i
    map "/record/subject[0]", to: "/subjects/most_important_subject"
  end
end

Record.new.from_other_record({ ... })
=> { :id => "...", :count => ..., :subjects => { :most_important_subject => "..."} }

Record.translated_hash
=> { :id => "...", :count => ..., :subjects => { :most_important_subject => "..."} }
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/yahm/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
