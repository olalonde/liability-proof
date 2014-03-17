module LiabilityProof
  class Tree

    class LeafNode < Struct.new(:user, :value, :nonce, :hash)
      include ::LiabilityProof::Tree::Node

      def initialize(account)
        value = BigDecimal.new(account['value'] || account['balance'])
        super(account['user'], value)

        self.nonce = account['nonce'] || generate_nonce
        self.hash  = account['hash']  || generate_hash

        if account['user'] && account['hash'] && account['nonce']
          raise ArgumentError, "Hash doesn't match" if generate_hash != account['hash']
        end
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
