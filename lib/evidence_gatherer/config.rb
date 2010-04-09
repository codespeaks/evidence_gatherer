require 'yaml'

module EvidenceGatherer
  class Config
    USER_DIR = File.join(ENV['HOME'], '.evidence_gatherer').freeze
    AGENTS_FILE = File.join(USER_DIR, 'agents.yml').freeze
    LOCAL = 'evidence_gatherer.yml'.freeze
    AGENTS = File.exist?(AGENTS_FILE) ? YAML.load(File.read(AGENTS_FILE)) : {}
    
    DEFAULT_PORT = 3711
    DEFAULT_TEMPLATE = :html401
    
    def self.local(dir)
      local = File.join(dir, LOCAL)
      config = File.exist?(local) ? load_yaml(local) : new
      config.merge(:root => dir)
    end
    
    def self.load_yaml(filename)
      new(YAML.load_file(filename))
    end
    
    def self.command_for_agent(name)
      AGENTS[name]
    end
    
    attr_accessor :template, :agents, :root, :port
    
    def initialize(options = {})
      self.template = DEFAULT_TEMPLATE
      self.port = DEFAULT_PORT
      self.agents = AGENTS.keys
      merge(options)
    end
    
    def merge(options)
      options.each do |key, value|
        send("#{key}=", value)
      end
      self
    rescue NoMethodError
      raise ArgumentError, "Unknown option: #{key}"
    end
  end
end
