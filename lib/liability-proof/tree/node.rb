module LiabilityProof
  class Tree

    module Node

      def as_json(use_float=false)
        { 'value' => formatted_value(use_float), 'hash' => hash }
      end

      def value_string
        value.to_s('F')
      end

      def formatted_value(use_float)
        use_float ? value.to_f : value_string
      end

    end

  end
end
