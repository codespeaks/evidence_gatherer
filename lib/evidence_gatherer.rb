require 'fileutils'
require 'pathname'
require 'json'
require 'rack'

module EvidenceGatherer
  autoload :SuiteBuilder, 'evidence_gatherer/suite_builder'
  autoload :TestPageBuilder, 'evidence_gatherer/test_page_builder'
  autoload :TestPageView, 'evidence_gatherer/test_page_view'
  autoload :ResultsCollecter, 'evidence_gatherer/results_collecter'
end
