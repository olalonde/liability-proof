require 'minitest/autorun'
require 'json'
require 'liability-proof'

def accounts
  @accounts ||= JSON.parse File.read(File.expand_path('../fixtures/accounts.json', __FILE__))
end

def root_json_path
  File.expand_path '../fixtures/root.json', __FILE__
end

def partial_tree_json_path
  File.expand_path '../fixtures/jan.json', __FILE__
end
