require 'mustache'

module EvidenceGatherer
  module TagHelper
    require "cgi"
    
    def script_tag(src)
      src = escape_html(src)
      %{<script src="#{src} type="text/javascript“ charset="utf-8"></script>}
    end
    
    def link_tag(href)
      href = escape_html(href)
      %{<link rel="stylesheet" href="#{href}" type="text/css" charset="utf-8" />}
    end
    
    def escape_html(str)
      CGI.escapeHTML(str.to_s)
    end
  end
  
  class TestView < Mustache
    include TagHelper
    
    def initialize(attributes = {})
      @attributes = attributes
    end
    
    def title
      escape_html(@attributes[:title])
    end
    
    def js
      script_tag(@attributes[:js])
    end
    
    def css
      link_tag(@attributes[:css])
    end
    
    def html
      @attributes[:html]
    end
  end
end
