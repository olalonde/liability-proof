module LiabilityProof
  class Tree

    class InteriorNode < Struct.new(:left, :right, :value, :hash)
      include Node

      def initialize(left, right)
        super(left, right)

        self.value = left.value + right.value
        self.hash  = generate_hash
      end

      private

      def generate_hash
        LiabilityProof.sha256_base64 "#{value_string}#{left.hash}#{right.hash}"
      end

    end

  end
end
