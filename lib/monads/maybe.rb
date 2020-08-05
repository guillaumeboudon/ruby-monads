module Monads
  class Maybe
    private_class_method :new

    # unit :: a -> M a
    def self.unit(value)
      value.nil? ? Nothing.new : Just.new(value)
    end

    # and_then :: (a -> M b) -> M a -> M b
    def and_then(&block)
      ensure_monadic_result(&block).call
    end

    # within :: (a -> b) -> M a -> M b
    def within(&block)
      and_then do |value|
        self.class.unit(block.call(value))
      end
    end

    # unwrap :: a -> Ma -> a
    def unwrap(default_value)
      @value || default_value
    end

    def method_missing(method, *args, &block)
      within do |value|
        value.public_send(method, *args, &block)
      end
    end

    private

    def monad
      Maybe
    end

    def ensure_monadic_result(&block)
      proc do
        block.call(@value).tap do |result|
          unless result.is_a?(monad)
            raise TypeError, "block must return #{monad.name}"
          end
        end
      end
    end
  end

  class Just < Maybe
    public_class_method :new

    def self.new(value)
      raise TypeError, "value should not be \"nil\"" if value.nil?
      super
    end

    def initialize(value)
      @value = value
    end
  end

  class Nothing < Maybe
    public_class_method :new

    # and_then :: (a -> M b) -> M a -> M b
    def and_then(&block)
      self
    end
  end
end
