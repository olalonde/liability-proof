module LiabilityProof

  autoload :Command, 'liability-proof/command'
  autoload :Tree, 'liability-proof/tree'
  autoload :Verifier, 'liability-proof/verifier'

  extend self

  def sha256_base64(message)
    Base64.encode64(OpenSSL::Digest::SHA256.new.digest(message)).strip
  end

end
