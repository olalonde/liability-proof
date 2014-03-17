require_relative 'tree/node'
require_relative 'tree/leaf_node'
require_relative 'tree/interior_node'

module LiabilityProof
  class Verifier

    def initialize(root_json, partial_tree_json)
      @expect_root = root_json['root']
      @root = reduce(partial_tree_json['partial_tree']).as_json
    end

    def match?
      @root == @expect_root
    end

    private

    def reduce(node)
      if node['data']
        Tree::LeafNode.new node['data']
      else
        left  = reduce node['left']
        right = reduce node['right']
        Tree::InteriorNode.new(left, right)
      end
    end

  end
end
