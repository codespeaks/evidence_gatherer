module EvidenceGatherer
  class ResultsCollecter
    EMPTY_RESPONSE = [200, {}, [""]].freeze
    
    def self.call(env)
      new(env).call
    end
    
    def initialize(env)
      @output = env["rack.errors"]
      @params = Rack::Request.new(env).params
    end
    
    def call
      %w( testCount assertionCount failureCount errorCount skipCount ).each do |count|
        log_count(count)
      end
      EMPTY_RESPONSE
    end
    
    protected
      def log_count(count)
        @output.puts("#{count}: #{@params[count]}")
      end
  end
end
