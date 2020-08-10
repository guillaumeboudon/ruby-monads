print "\n\"Result\" monad test suite"

setup do
  [Success.new(42), Failure.new(StandardError.new("Wrong!"))]
end

test "Result::new" do
  assert_raise NoMethodError do Result.new(42) end

  assert_raise TypeError do Success.new(StandardError.new) end
  assert Success.new(42).is_a?(Success)

  assert_raise TypeError do Failure.new(42) end
  assert Failure.new(StandardError.new).is_a?(Failure)
end

test "Result::unit" do |success, failure|
  assert success.is_a?(Result)
  assert success.is_a?(Success)
  assert !success.is_a?(Failure)

  assert failure.is_a?(Result)
  assert !failure.is_a?(Success)
  assert failure.is_a?(Failure)

  assert Result.unit(success).is_a?(Success)
  assert Result.unit(failure).is_a?(Failure)
end

test "Result#bind" do |success, failure|
  assert success.bind { |v| Result.unit(v / 2) }.is_a?(Success)
  assert success.bind { |v| Result.unit(v / 0) }.is_a?(Failure)
  assert success.bind { |v| v / 0 }.is_a?(Failure)

  assert failure.bind { |v| Result.unit(42) }.is_a?(Failure)
  assert failure.bind { |v| Result.unit(StandardError.new) }.is_a?(Failure)
  assert failure.bind { |v| v / 2 }.is_a?(Failure)
end

test "Result#fmap" do |success, failure|
  assert success.fmap(&:even?).is_a?(Success)
  assert success.fmap { |v| v / 0 }.is_a?(Failure)

  assert failure.fmap(&:even?).is_a?(Failure)
  assert failure.fmap { |v| v / 0 }.is_a?(Failure)
end

test "Result#join" do |success, failure|
  assert_equal Result.unit(success).join.unwrap("default"), 42
  assert_equal Result.unit(failure).join.unwrap("default"), "default"
end

test "Result#unwrap" do |success, failure|
  assert_equal success.unwrap("default"), 42
  assert_equal success.unwrap(nil), 42
  assert_equal failure.unwrap("default"), "default"
  assert_equal failure.unwrap(nil), nil
end

test "Result accepts methods chaining" do |success, failure|
  assert_equal success.next.div(13).to_f.unwrap(1.0), 3.0
  assert_equal failure.next.div(13).to_f.unwrap(1.0), 1.0
end
