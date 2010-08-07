require 'fileutils'
require 'pathname'

module EvidenceGatherer
  VERSION = '0.1.0'.freeze
  
  autoload :CLI, 'evidence_gatherer/cli'
  autoload :Config, 'evidence_gatherer/config'
  autoload :Runner, 'evidence_gatherer/runner'
  autoload :SuiteBuilder, 'evidence_gatherer/suite_builder'
  autoload :TestPageBuilder, 'evidence_gatherer/test_page_builder'
  autoload :TagHelper, 'evidence_gatherer/tag_helper'
  autoload :TestPageView, 'evidence_gatherer/test_page_view'
  autoload :Server, 'evidence_gatherer/server'
  autoload :UserAgent, 'evidence_gatherer/user_agent'
  autoload :ResultsCollector, 'evidence_gatherer/results_collector'
end
