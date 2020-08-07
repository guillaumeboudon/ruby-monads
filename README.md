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
just = Maybe.unit("Hello, World!")     # => #<Monads::Just @value="Hello, World!">
nothing = Maybe.unit(nil)              # => #<Monads::Nothing>

just.upcase                            # => #<Monads::Just @value="HELLO, WORLD!">
just.upcase.split.unwrap([])           # => ["HELLO,", "WORLD!"]
just.bind { |v| Maybe.unit(nil) }      # => #<Monads::Nothing>
just.fmap { |v| v.gsub(/\w/, "*") }    # => #<Monads::Just @value="*****, *****!">
Maybe.unit(just).join                  # => #<Monads::Just @value="Hello, World!">

nothing.upcase                         # => #<Monads::Nothing>
nothing.upcase.split.unwrap([])        # => []
nothing.bind { |v| just }              # => #<Monads::Nothing>
nothing.fmap { |v| v.gsub(/\w/, "*") } # => #<Monads::Nothing>
Maybe.unit(nothing).join               # => #<Monads::Nothing>
```

## Why this gem

This gem is heavily inspired by the following monads implementations:

- [Monadic](https://github.com/pzol/monadic)
- [Monads](https://github.com/tomstuart/monads)

These gems, and many others are really great, and it was very instructive to learn about this topic in my beloved language. However, after reading a lot of implementations and articles, I had a clear opinion of how I wanted it:

- _Minimalist:_ as simple an lightweight as possible
- _Respectful of uses:_ respectful of the usual terms ([Monad (functional programming)](https://en.wikipedia.org/wiki/Monad_(functional_programming))), like `Maybe`, `unit`, `bind`, `join`, etc.
- _Vanilla Ruby syntax:_ I love some of the abstractions I discovered (`>=` operator, `Just(value)` syntax). However, I also love vanilla Ruby. So, I wanted to target new methods and abstractions, not new syntaxes comming from other languages.
