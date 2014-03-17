$:.push File.expand_path("../lib", __FILE__)

require "liability-proof/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "liability-proof"
  s.version     = LiabilityProof::VERSION
  s.authors     = ["Peatio Opensource"]
  s.email       = ["community@peatio.com"]
  s.homepage    = "https://github.com/peatio/liability-proof"
  s.summary     = "An implementation of Greg Maxwell's Merkle approach to prove Bitcoin liabilities."
  s.description = "Check https://iwilcox.me.uk/2014/proving-bitcoin-reserves for more details."
  s.license     = 'MIT'

  s.executables = ['lproof'] 
  s.files       = Dir["{bin,lib}/**/*"] + ["README.markdown"]
end
