# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{evidence_gatherer}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.date = %q{2010-07-16}
  s.default_executable = %q{evidence_gatherer}
  s.executables = ["evidence_gatherer"]
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    ".gitignore",
     "README",
     "assets/index.html",
     "bin/evidence_gatherer",
     "config/agents-mac.yml",
     "example/src/foo.js",
     "example/test/evidence_gatherer.yml",
     "example/test/foo_test.js",
     "lib/evidence_gatherer.rb",
     "lib/evidence_gatherer/CLI.rb",
     "lib/evidence_gatherer/config.rb",
     "lib/evidence_gatherer/results_collecter.rb",
     "lib/evidence_gatherer/runner.rb",
     "lib/evidence_gatherer/server.rb",
     "lib/evidence_gatherer/suite_builder.rb",
     "lib/evidence_gatherer/test_page_builder.rb",
     "lib/evidence_gatherer/test_page_view.rb",
     "lib/evidence_gatherer/user_agent.rb",
     "templates/html401.mustache",
     "templates/html5.mustache",
     "test/fixtures/fixture_project/bar/bar.js",
     "test/fixtures/fixture_project/foo.js",
     "test/fixtures/fixture_project/test/bar/bar_test.js",
     "test/fixtures/fixture_project/test/fixtures/bar/bar.css",
     "test/fixtures/fixture_project/test/fixtures/bar/bar.html",
     "test/fixtures/fixture_project/test/fixtures/foo.js",
     "test/fixtures/fixture_project/test/foo_test.js",
     "test/test_helper.rb",
     "test/unit/suite_builder_test.rb",
     "test/unit/test_page_builder_test.rb"
  ]
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Automation tool for Evidence JavaScript testing framework}
  s.test_files = [
    "test/test_helper.rb",
     "test/unit/suite_builder_test.rb",
     "test/unit/test_page_builder_test.rb",
     "test/unit/test_page_view_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
