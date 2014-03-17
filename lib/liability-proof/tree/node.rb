module LiabilityProof
  class Tree

    module Node

      def as_json
        { 'value' => value_string, 'hash' => hash }
      end

      def value_string
        value.to_s('F')
      end

    end

  end
end
