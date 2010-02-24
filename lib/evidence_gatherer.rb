require 'fileutils'
require 'pathname'
require 'json'

module EvidenceGatherer
  autoload :SuiteBuilder, 'evidence_gatherer/suite_builder'
  autoload :TestPageBuilder, 'evidence_gatherer/test_page_builder'
  autoload :TestPageView, 'evidence_gatherer/test_page_view'
end
