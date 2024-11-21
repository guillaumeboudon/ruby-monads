module Monads
  class Maybe
    include Monads::Monad

    # wrap :: a -> M a
    def self.wrap(value)
      (value.nil? || value.is_a?(Nothing)) ? Nothing.new : Just.new(value)
    end

    # bind :: (a -> M b) -> M a -> M b
    def bind(&block)
      ensure_monadic_result(&block).call
    end

    # unwrap :: a -> M a -> a
    def unwrap(default_value)
      @value || default_value
    end

    private

    def monad_type
      Maybe
    end
  end

  class Just < Maybe
    public_class_method :new

    def self.new(value)
      raise TypeError, "value should not be of #{value.class}" if value.nil?
      super
    end
  end

  class Nothing < Maybe
    public_class_method :new

    def initialize
    end

    # bind :: (a -> M b) -> M a -> M b
    def bind(&block)
      self
    end
  end
end
