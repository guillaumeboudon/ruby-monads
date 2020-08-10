# ruby-monads

These are some Ruby implementations of some common monads.

## Usage

If you don't already have it installed:

```sh
gem install ruby-monads
```

As these are just some new abstractions, just include it:

```ruby
require "monads"

include Monads
```

## Monads

### Maybe

The maybe monad returns one of the following classes, wether it wraps a value or not:

- `Maybe.unit(42)` returns an instance of `Just` wrapping the `42` value
- `Maybe.unit(nil)` returns an instance of `Nothing` wrapping no value

#### Examples

```ruby
Maybe.unit("Hello, World!")                                # => #<Monads::Just @value="Hello, World!">
Maybe.unit(nil)                                            # => #<Monads::Nothing>

Maybe.unit("Hello, World!").upcase                         # => #<Monads::Just @value="HELLO, WORLD!">
Maybe.unit("Hello, World!").upcase.split.unwrap([])        # => ["HELLO,", "WORLD!"]
Maybe.unit("Hello, World!").bind { |v| Maybe.unit(nil) }   # => #<Monads::Nothing>
Maybe.unit("Hello, World!").fmap { |v| v.gsub(/\w/, "*") } # => #<Monads::Just @value="*****, *****!">
Maybe.unit(Maybe.unit("Hello, World!")).join               # => #<Monads::Just @value="Hello, World!">

Maybe.unit(nil).upcase                                     # => #<Monads::Nothing>
Maybe.unit(nil).upcase.split.unwrap([])                    # => []
Maybe.unit(nil).bind { |v| Maybe.unit("Hello, World!") }   # => #<Monads::Maybe.unit(nil)>
Maybe.unit(nil).fmap { |v| v.gsub(/\w/, "*") }             # => #<Monads::Nothing>
Maybe.unit(Maybe.unit(nil)).join                           # => #<Monads::Nothing>
```

### Result

The result monad returns one of the following classes, wether it wraps an error or not:

- `Result.unit(42)` returns an instance of `Success` wrapping the `42` value
- `Result.unit(StandardError.new)` returns an instance of `Failure` wrapping the given error

#### Examples

```ruby
Result.unit("Hello, World!")             # => #<Monads::Success @value="Hello, World!">
Result.unit(StandardError.new("Wrong!")) # => #<Monads::Failure @value=#<StandardError: Wrong!>>

Result
  .unit("Hello, World!")                 # => #<Monads::Success @value="Hello, World!">
  .upcase                                # => #<Monads::Success @value="HELLO, WORLD!">
  .even                                  # => #<Monads::Failure @value=#<NoMethodError: undefined method `even?' for "HELLO, WORLD!":String>>
  .split                                 # => #<Monads::Failure @value=#<NoMethodError: undefined method `even?' for "HELLO, WORLD!":String>>
  .unwrap("default")                     # "default"
```

## Why this gem

This gem is heavily inspired by the following monads implementations:

- [Monadic](https://github.com/pzol/monadic)
- [Monads](https://github.com/tomstuart/monads)

These gems, and many others are really great, and it was very instructive to learn about this topic in my beloved language. However, after reading a lot of implementations and articles, I had a clear opinion of how I wanted it:

- _Minimalist:_ as simple an lightweight as possible
- _Respectful of uses:_ respectful of the usual terms ([Monad (functional programming)](https://en.wikipedia.org/wiki/Monad_(functional_programming))), like `Maybe`, `unit`, `bind`, `join`, etc.
- _Vanilla Ruby syntax:_ I love some of the abstractions I discovered (`>=` operator, `Just(value)` syntax). However, I also love vanilla Ruby. So, I wanted to target new methods and abstractions, not new syntaxes comming from other languages.

## Tests

Test suite uses [cutest](https://github.com/djanowski/cutest). You can execute it with:

```sh
make
```
