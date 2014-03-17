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

    private

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
    def index_leaves(node, path=[])
      if node.is_a?(LeafNode)
        [[node.user, path]]
      else
        index_leaves(node.left, path+[:left]) + index_leaves(node.right, path+[:right])
      end
    end

  end
end
