require 'helper'

class TestVerifier < MiniTest::Unit::TestCase

  def test_tree_partial_tree
    tree    = LiabilityProof::Tree.new accounts
    verifier = LiabilityProof::Verifier.new(
      root: root_json_path,
      file: partial_tree_json_path
    )

    assert_equal true, verifier.match?
  end

end
