require 'base64'
require 'bigdecimal'
require 'openssl'

module LiabilityProof
  class Tree

    class LeafNode < Struct.new(:user, :value, :nonce, :hash)

      def initialize(account)
        value = BigDecimal.new account['balance']
        super(account['user'], value)

        self.nonce = generate_nonce
        self.hash  = generate_hash
      end

      private

      # a 16 bytes random string encoded in 32 hex digits
      def generate_nonce
        OpenSSL::Random.random_bytes(16).unpack("H*").first
      end

      # a sha256 hash encoded in 64 hex digits
      def generate_hash
        LiabilityProof.sha256_base64 "#{user}|#{value.to_s('F')}|#{nonce}"
      end

    end

    class InteriorNode < Struct.new(:left, :right, :value, :hash)

      def initialize(left, right)
        super(left, right)

        self.value = left.value + right.value
        self.hash  = generate_hash
      end

      private

      def generate_hash
        LiabilityProof.sha256_base64 "#{value.to_s('F')}#{left.hash}#{right.hash}"
      end

    end


    attr :root, :indices

    def initialize(accounts)
      raise ArgumentError, 'accounts is empty' unless accounts && accounts.size > 0

      @accounts = accounts
      @root     = generate
      @indices  = Hash[index_leaves(@root)]
    end

    def verification_path(user)
      _verification_path @root, @indices[user], []
    end

    private

    def _verification_path(node, index, path)
      if node.is_a?(LeafNode)
        [node, path]
      else
        follow_direction = index.shift
        other_direction  = follow_direction == :left ? :right : :left
        follow_child     = node.send follow_direction
        other_child      = node.send other_direction

        path.unshift [other_direction, other_child]
        _verification_path follow_child, index, path
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
