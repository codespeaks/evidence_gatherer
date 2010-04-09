module EvidenceGatherer
  class UserAgent
    def self.[](name)
      new(name, Config.command_for_agent(name))
    end
    
    attr_reader :name, :command

    def initialize(name, command)
      @name = name
      @command = command
    end

    def visit(url)
      system("#{command} #{url} &")
    end
  end
end
