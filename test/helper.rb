require 'minitest/autorun'
require 'json'
require 'liability-proof'

def accounts
  @accounts ||= JSON.parse File.read(File.expand_path('../fixtures/accounts.json', __FILE__))
end

def to_partial_tree_json(partial_tree)
  JSON.parse(JSON.dump({
    partial_tree: partial_tree
  }))
end

def to_root_json(root)
  JSON.parse(JSON.dump({
    root: root
  }))
end
