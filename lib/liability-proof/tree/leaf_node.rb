module LiabilityProof
  class Tree

    class LeafNode < Struct.new(:user, :value, :nonce, :hash)
      include Node

      def initialize(account)
        value = BigDecimal.new account['balance']
        super(account['user'], value)

        self.nonce = generate_nonce
        self.hash  = generate_hash
      end

      def as_json
        { value: value_string,
          hash:  hash,
          user:  user,
          nonce: nonce }
      end

      private

      # a 16 bytes random string encoded in 32 hex digits
      def generate_nonce
        OpenSSL::Random.random_bytes(16).unpack("H*").first
      end

      # a sha256 hash encoded in 64 hex digits
      def generate_hash
        LiabilityProof.sha256_base64 "#{user}|#{value_string}|#{nonce}"
      end

    end

  end
end
