require 'minitest/autorun'
require 'json'
require 'liability-proof'

def accounts
  @accounts ||= JSON.parse File.read(File.expand_path('../fixtures/accounts.json', __FILE__))
end

