require 'rack'

module EvidenceGatherer
  class Server
    def initialize(root, options = {})
      @root = root
      @options = options
    end
    
    def start(&block)
      handler.run(rack_app, @options, &block)
    end
    
    protected
      def handler
        %w( thin mongrel webrick ).each do |handler|
          begin
            return Rack::Handler.get(handler)
          rescue LoadError
          end
        end
      end
      
      def rack_app
        root = @root
        Rack::Builder.new do
          use Rack::CommonLogger
          use Rack::ShowExceptions
          
          map "/results" do
            run ResultsCollector
          end
          
          map "/" do
            run Rack::Directory.new(root)
          end
        end
      end
  end
end
