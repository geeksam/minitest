require 'minitest/autorun'
require 'minitest/describe_it'

describe MiniTest::Spec do
  before { MiniTest.disable_expectations }
  after  { MiniTest.enable_expectations }

  it "needs to stop infecting Object with expectation methods" do
    assert_raises(NoMethodError) { (2+2).must_equal 4 }
  end
end
