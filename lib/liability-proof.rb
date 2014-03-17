module LiabilityProof

  autoload :Tree,      'liability-proof/tree'
  autoload :Generator, 'liability-proof/generator'
  autoload :Verifier,  'liability-proof/verifier'

  module_function

  def sha256_base64(message)
    Base64.encode64(OpenSSL::Digest::SHA256.new.digest(message)).strip
  end

end
