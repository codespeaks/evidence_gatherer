module EvidenceGatherer
  module CLI
    extend self
    
    def run(args)
      @options = {}
      options_parser.parse!(args)
      command, test_dir = args
      validate_command!(command)
      ensure_present!(command)
      ensure_present!(test_dir)
      config = Config.local(test_dir)
      config = config.merge(@options)
      Runner.send(command, config)
    end
    
    def validate_command!(command)
      unless %w( build server gather ).include?(command)
        raise ArgumentError, "Unknown command: #{command}"
      end
    end
    
    def ensure_present!(value)
      if value.to_s.empty?
        puts options_parser.help
        exit 1
      end
    end
    
    def options_parser
      @options_parser ||= OptionParser.new do |opts|
        opts.banner = <<USAGE
Usage: evidence_gatherer <command> [test_dir] [options]

Available commands are:
 * build
 * server
 * gather
USAGE

        opts.separator ''
        opts.separator 'Options for build:'

        opts.on('-t', '--template TEMPLATE', 'Use TEMPLATE as (X)HTML template to build test pages. Default: :html401') do |t|
          @options[:template] = (t = t.strip) =~ /^:/ ? t[1..-1].to_sym : t
          p @options[:template]
        end

        opts.separator ''
        opts.separator 'Options for server:'

        opts.on('-p', '--port', 'Server port.') do |p|
          @options[:port] = Integer(p)
        end
        
        opts.separator ''
        opts.separator 'Options for gather:'

        opts.on('-a', '--agents', 'Comma-separated list of agents to run tests against.') do |a|
          @options[:agents] = a.split(/\s*,\s*/)
        end

        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end

        opts.on_tail('-v', '--version', 'Show version') do
          puts EvidenceGatherer::VERSION
          exit
        end
      end
    end
  end
end
