require_relative 'tree/node'
require_relative 'tree/leaf_node'
require_relative 'tree/interior_node'

module LiabilityProof
  class Verifier

    attr :user_node

    def initialize(root_json, partial_tree_json)
      @expect_root = root_json['root']
      @partial_tree = partial_tree_json['partial_tree']
    end

    def match?
      reduce(@partial_tree).as_json == @expect_root
    rescue
      false
    end

    private

    def reduce(node)
      if node['data']
        leaf = Tree::LeafNode.new node['data']
        @user_node = leaf if leaf.user
        leaf
      else
        left  = reduce node['left']
        right = reduce node['right']
        Tree::InteriorNode.new(left, right)
      end
    end

  end
end
