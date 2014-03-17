module LiabilityProof
  class Node < Struct.new(:user, :value, :nonce, :hash)

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
      message = "#{user}|#{value}|#{nonce}"
      digest  = OpenSSL::Digest::SHA256.new.digest message
      digest.unpack('H*').first
    end

  end
end
