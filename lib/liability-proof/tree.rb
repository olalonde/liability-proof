require 'base64'
require 'bigdecimal'
require 'openssl'

module LiabilityProof
  class Tree

    autoload :Node, 'liability-proof/tree/node'
    autoload :LeafNode, 'liability-proof/tree/leaf_node'
    autoload :InteriorNode, 'liability-proof/tree/interior_node'

    attr :root, :indices

    def initialize(accounts)
      raise ArgumentError, 'accounts is empty' unless accounts && accounts.size > 0

      @accounts = accounts
      @root     = generate
      @indices  = Hash[index_leaves(@root)]
    end

    def partial(user)
      h = { 'data' => nil }
      _partial user, @root, @indices[user].dup, h
      h
    end

    private

    def _partial(user, node, index, acc)
      if node.is_a?(LeafNode)
        acc['data'] = node.as_json

        if node.user == user
          acc['data'].merge!({
            'user'  => user,
            'nonce' => node.nonce
          })
        end
      else
        follow_direction = index.shift
        other_direction  = follow_direction == :left ? :right : :left
        follow_child     = node.send follow_direction
        other_child      = node.send other_direction

        acc[other_direction.to_s]  = { 'data' => other_child.as_json }
        acc[follow_direction.to_s] = { 'data' => nil }
        _partial user, follow_child, index, acc[follow_direction.to_s]
      end
    end

    def generate
      leaves = @accounts.map {|a| LeafNode.new(a) }
      combine leaves
    end

    def combine(nodes)
      return nodes.first if nodes.size <= 1

      parents = nodes.each_slice(2).map do |(left, right)|
        # if right is not nil, return combined interior node;
        # otherwise keep the left leaf node
        right ? InteriorNode.new(left, right) : left
      end

      combine parents
    end

    # Walk the tree and produce indices, each index include the destination
    # leaf and the path from given node to it.
    #
    # The path is expressed as an array of directions, e.g. :left, :right
    def index_leaves(node, index=[])
      if node.is_a?(LeafNode)
        [[node.user, index]]
      else
        index_leaves(node.left, index+[:left]) + index_leaves(node.right, index+[:right])
      end
    end

  end
end
