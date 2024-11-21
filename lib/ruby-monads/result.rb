module Monads
  class Result
    include Monads::Monad

    FAILURE_TRIGGER = StandardError

    # wrap :: a -> M a
    def self.wrap(value)
      if value.is_a?(FAILURE_TRIGGER) || value.is_a?(Failure)
        Failure.new(value)
      else
        Success.new(value)
      end
    rescue => error
      Failure.new(error)
    end

    # bind :: (a -> M b) -> M a -> M b
    def bind(&block)
      return self if is_a?(Failure)

      begin
        ensure_monadic_result(&block).call
      rescue FAILURE_TRIGGER => error
        Failure.new(error)
      end
    end

    # unwrap :: a -> M a -> a
    def unwrap(default_value = @value)
      is_a?(Failure) ? default_value : @value
    end

    private

    def monad_type
      Result
    end
  end

  class Success < Result
    public_class_method :new

    def self.new(value)
      raise TypeError, "value should not be of #{value.class}" if value.is_a?(FAILURE_TRIGGER)
      super
    end
  end

  class Failure < Result
    public_class_method :new

    def self.new(value)
      raise TypeError, "value should not be of #{value.class}" unless value.is_a?(FAILURE_TRIGGER)
      super
    end
  end
end
