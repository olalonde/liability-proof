module LiabilityProof
  class Tree

    module Node

      def as_json
        { 'sum' => sum_string, 'hash' => hash }
      end

      def sum_string
        sum.to_s('F')
      end

    end

  end
end
