# monads.rb

These are some Ruby implementations of some common monads.

## Monads

### Maybe

The maybe monad returns one of the following classes, wether it wraps a value or not:

- `Maybe.unit(42)` returns an instance of `Just` wrapping the `42` value
- `Maybe.unit(nil)` returns an instance of `Nothing` wrapping no value

#### Examples

```ruby
require "monads"                   # => true

m = Maybe.unit("Hello, World!")    # => #<Monads::Just @value="Hello, World!">
m.upcase                           # => #<Monads::Just @value="HELLO, WORLD!">
m.upcase.split.unwrap([])          # => ["HELLO,", "WORLD!"]
m.and_then { |v| Maybe.unit(nil) } # => #<Monads::Nothing>
m.within { |v| v.gsub(/\w/, "*") } # => #<Monads::Just @value="*****, *****!">

m = Maybe.unit(nil)                # => #<Monads::Nothing>
m.upcase                           # => #<Monads::Nothing>
m.upcase.split.unwrap([])          # => []
m.and_then { |v| Maybe.unit(42) }  # => #<Monads::Nothing>
m.within { |v| v.gsub(/\w/, "*") } # => #<Monads::Nothing>


Maybe.unit(42).is_a?(Maybe)        # => true
Maybe.unit(42).is_a?(Just)         # => true
Maybe.unit(42).is_a?(Nothing)      # => false
Maybe.unit(nil).is_a?(Maybe)       # => true
Maybe.unit(nil).is_a?(Just)        # => false
Maybe.unit(nil).is_a?(Nothing)     # => true
```

## Inspirations

This gem is heavily inspired by the following monads implementations:

- [Monadic](https://github.com/pzol/monadic)
- [Monads](https://github.com/tomstuart/monads)
