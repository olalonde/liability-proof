require 'json'

module LiabilityProof

  autoload :Tree,          'liability-proof/tree'
  autoload :Generator,     'liability-proof/generator'
  autoload :Verifier,      'liability-proof/verifier'
  autoload :PrettyPrinter, 'liability-proof/pretty_printer'

  module_function

  def sha256_base64(message)
    Base64.encode64(OpenSSL::Digest::SHA256.new.digest(message)).strip
  end

end
