module Monads
  module Monad
    def self.included(base)
      base.class_eval do
        private_class_method :new
      end
    end

    def initialize(value)
      @value = value
    end

    # fmap :: (a -> b) -> M a -> M b
    def fmap(&block)
      bind do |value|
        self.class.unit(block.call(value))
      end
    end

    # join :: M (M a) -> M a
    def join
      value = @value.is_a?(monad_type) ? @value.unwrap(nil) : @value
      monad_type.unit(value)
    end

    def method_missing(method, *args, &block)
      fmap do |value|
        value.public_send(method, *args, &block)
      end
    end

    private

    def ensure_monadic_result(&block)
      proc do
        block.call(@value).tap do |result|
          unless result.is_a?(monad_type)
            raise TypeError, "block must return #{monad_type.name}"
          end
        end
      end
    end
  end
end
