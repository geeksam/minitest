require 'minitest/autorun'
require 'minitest/describe_it'

describe MiniTest::Spec do
  before { MiniTest.obfuscate_expectation_methods }
  after  { MiniTest.elucidate_expectation_methods }

  it "needs to stop infecting Object with expectation methods" do
    assert_raises(NoMethodError) { (2+2).must_equal 4 }
  end
end
