module EvidenceGatherer
  class Runner
    %w( build server gather ).each do |method|
      class_eval %{
        def self.#{method}(config = Config.new)  # def self.build(config = Config.new)
          yield config if block_given?           #   yield config if block_given?
          new(config).#{method}                  #   new(config).build
        end                                      # end
      }
    end
    
    attr_reader :config
    
    def initialize(config)
      @config = config
    end
    
    def build
      SuiteBuilder.new(config.root, output_dir) do |builder|
        builder.template = config.template
        builder.build
      end
    end
    
    def server(&block)
      build
      Server.new(output_dir, :Port => config.port).start(&block)
    end
    
    def gather
      server { run_tests }
    end
    
    protected
      def run_tests
        config.agents.each do |name|
          UserAgent[name].visit(tests_url)
        end
      end
      
      def tests_url
        "http://localhost:#{config.port}/index.html"
      end
      
      def output_dir
        File.join(config.root, "output")
      end
  end
end
