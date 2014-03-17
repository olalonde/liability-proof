require 'json'
require 'fileutils'

module LiabilityProof
  class Command

    def initialize(options)
      @options = options
    end

    def execute!
      case @options[:action]
      when 'generate'
        generate
      when 'check'
        check @options[:root], @options[:file]
      else
        puts "Error: You must use either -g to generate json for accounts or -c to check certain partial tree is valid."
        exit 1
      end
    end

    private

    def generate
      accounts = JSON.parse File.read(@options[:file])
      tree     = LiabilityProof::Tree.new accounts

      write_root_json(tree)

      dir = 'partial_trees'
      FileUtils.mkdir dir unless File.exists?(dir)
      tree.indices.keys.each {|user| write_partial_tree(dir, tree, user) }
    end

    def write_partial_tree(dir, tree, user)
      json = { partial_tree: tree.partial(user) }

      File.open(File.join(dir, "#{user}.json"), 'w') do |f|
        f.write JSON.dump(json)
      end
    end

    def write_root_json(tree)
      json = {
        root: {
          hash:  tree.root.hash,
          value: tree.root.value.to_s('F')
        }
      }

      File.open('root.json', 'w') do |f|
        f.write JSON.dump(json)
      end
    end

    def check(root_json, partial_tree_json)
      root         = JSON.parse File.read(root_json)
      partial_tree = JSON.parse File.read(partial_tree_json)

      verifier = Verifier.new(root, partial_tree)
      if verifier.match?
        puts "Partial tree verified successfully!\n\n"
        puts "User: #{verifier.user_node.user}"
        puts "Balance: #{verifier.user_node.value_string}"
      else
        puts "INVALID partial tree!"
      end
    end

  end
end
