# monads.rb

These are some Ruby implementations of some common monads.

## Monads

### Maybe

```ruby
require "monads"
# => true

m = Maybe.unit("Hello, World!")    # => #<Monads::Just @value="Hello, World!">
m.upcase                           # => #<Monads::Just @value="HELLO, WORLD!">
m.upcase.split.unwrap([])          # => ["HELLO,", "WORLD!"]
m.within { |v| v.gsub(/\w/, "*") } # => #<Monads::Just @value="*****, *****!">
m.and_then { |v| Maybe.unit(nil) } # => #<Monads::Nothing>

m = Maybe.unit(nil)                # => #<Monads::Nothing>
m.upcase                           # => #<Monads::Nothing>
m.upcase.split.unwrap([])          # => []
m.within { |v| v.gsub(/\w/, "*") } # => #<Monads::Nothing>
m.and_then { |v| Maybe.unit(nil) } # => #<Monads::Nothing>


Maybe.unit(42).is_a?(Maybe)        # => true
Maybe.unit(42).is_a?(Just)         # => true
Maybe.unit(42).is_a?(Nothing)      # => false
Maybe.unit(nil).is_a?(Maybe)       # => true
Maybe.unit(nil).is_a?(Just)        # => false
Maybe.unit(nil).is_a?(Nothing)     # => true
```

## Inspirations

This gem is heavily inspired by the following monads implementations:

- [Monads](https://github.com/pzol/monadic)
- [Monadic](https://github.com/tomstuart/monads)
