require 'cgi'

module EvidenceGatherer
  module TagHelper
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
end
