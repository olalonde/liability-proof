require 'json'

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
    end

    def write_root_json(tree)
      File.open('root.json', 'w') do |f|
        json = {
          root: {
            hash:  tree.root.hash,
            value: tree.root.value.to_s('F')
          }
        }
        f.write JSON.dump(json)
      end
    end

  end
end
