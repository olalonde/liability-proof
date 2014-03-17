require 'helper'

class TestNode < Minitest::Test

  def setup
    @node = LiabilityProof::Node.new({
      'user' => 'j@peatio.com',
      'balance' => '12.13'
    })
  end

  def test_user
    assert_equal 'j@peatio.com', @node.user
  end

  def test_value
    assert_equal BigDecimal.new('12.13'), @node.value
  end

  def test_nonce
    assert_equal 32, @node.nonce.size
  end

  def test_hash
    assert_equal 64, @node.hash.size
  end

end
