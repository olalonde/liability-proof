require 'helper'

class TestTree < MiniTest::Unit::TestCase

  def test_leaf_node
    node = LiabilityProof::Tree::LeafNode.new({
      'user' => 'jan',
      'balance' => '12.13'
    })

    assert_equal 'jan', node.user
    assert_equal BigDecimal.new('12.13'), node.value
    assert_equal 32, node.nonce.size
    assert_equal 32, Base64.decode64(node.hash).size
  end

  def test_interior_node
    left = LiabilityProof::Tree::LeafNode.new({
      'user' => 'jan',
      'balance' => '12.13'
    })
    right = LiabilityProof::Tree::LeafNode.new({
      'user' => 'zw',
      'balance' => '20.14'
    })

    node  = LiabilityProof::Tree::InteriorNode.new left, right
    assert_equal left,  node.left
    assert_equal right, node.right

    value = (left.value + right.value).to_s('F')
    hash  = LiabilityProof.sha256_base64 "#{value}#{left.hash}#{right.hash}"
    assert_equal hash, node.hash
  end

  def test_tree_generation
    tree = LiabilityProof::Tree.new accounts
    sum = accounts
      .map {|a| BigDecimal.new a['balance'] }
      .inject(0, &:+)

    assert_equal sum, tree.root.value
  end

  def test_tree_generation_with_empty_accounts
    assert_raises ArgumentError do
      LiabilityProof::Tree.new []
    end
  end

  def test_tree_indices
    tree = LiabilityProof::Tree.new accounts
    assert_equal [:left, :left, :left, :left, :left], tree.indices['jan']
    assert_equal [:right, :right], tree.indices['picasso']
  end

  def test_tree_partial_tree
    tree = LiabilityProof::Tree.new accounts

    partial   = tree.partial('jan')
    leaf_data = partial[:left][:left][:left][:left][:left][:data]

    assert_equal 'jan', leaf_data[:user]
    assert_equal '12.13', leaf_data[:value]
    assert_equal true, leaf_data.has_key?(:hash)
    assert_equal true, leaf_data.has_key?(:nonce)
  end

end
