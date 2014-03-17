require 'helper'

class TestVerifier < MiniTest::Unit::TestCase

  def test_tree_partial_tree
    tree    = LiabilityProof::Tree.new accounts
    root    = to_root_json tree.root.as_json
    partial = to_partial_tree_json tree.partial('jan')

    verifier = LiabilityProof::Verifier.new(root, partial)
    assert_equal true, verifier.match?
  end

end
