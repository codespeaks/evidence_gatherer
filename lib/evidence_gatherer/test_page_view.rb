require 'mustache'

module EvidenceGatherer
  class TestPageView < Mustache
    include TagHelper
    
    def initialize(attributes = {})
      @attributes = attributes
    end
    
    def title
      escape_html(@attributes[:title])
    end
    
    def javascripts
      apply(:script_tag, :javascripts)
    end
    
    def stylesheets
      apply(:link_tag, :stylesheets)
    end
    
    def html
      @attributes[:html]
    end
    
    protected
      def apply(method, attribute)
        Array(@attributes[attribute]).compact.collect do |path|
          send(method, path)
        end.join("\n")
      end
  end
end
