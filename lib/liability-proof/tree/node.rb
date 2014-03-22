module LiabilityProof
  class Tree

    module Node

      def as_json(use_float=false)
        { 'sum' => formatted_sum(use_float), 'hash' => hash }
      end

      def sum_string
        sum.to_s('F')
      end

      def formatted_sum(use_float)
        use_float ? sum.to_f : sum_string
      end

    end

  end
end
