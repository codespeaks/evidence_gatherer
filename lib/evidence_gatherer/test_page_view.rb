require 'mustache'

module EvidenceGatherer
  module TagHelper
    require "cgi"
    
    def script_tag(src)
      src = escape_html(src)
      %{<script src="#{src}" type="text/javascript" charset="utf-8"></script>}
    end
    
    def link_tag(href)
      href = escape_html(href)
      %{<link rel="stylesheet" href="#{href}" type="text/css" charset="utf-8" />}
    end
    
    def escape_html(str)
      CGI.escapeHTML(str.to_s)
    end
  end
  
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
