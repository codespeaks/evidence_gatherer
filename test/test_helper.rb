TEST_ROOT     = File.expand_path(File.dirname(__FILE__))
FIXTURES_ROOT = TEST_ROOT + '/fixtures'
OUTPUT_ROOT   = TEST_ROOT + '/output'

$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'test/unit'
require 'mocha'

require 'evidence_gatherer'
