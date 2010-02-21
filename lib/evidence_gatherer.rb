require 'fileutils'
require 'pathname'

module EvidenceGatherer
  autoload :SuiteBuilder, 'evidence_gatherer/suite_builder'
  autoload :TestBuilder, 'evidence_gatherer/test_builder'
  autoload :TestView, 'evidence_gatherer/test_view'
end
