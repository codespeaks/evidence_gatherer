require File.dirname(__FILE__) + '/../test_helper'

class TestPageBuilderTest < Test::Unit::TestCase
  def setup
    @project_tests_root = File.join(FIXTURES_ROOT, "fixture_project", "test")
    @output_directory = File.join(OUTPUT_ROOT, "fixture_project_tests")
    @suite_builder = EvidenceGatherer::SuiteBuilder.new(@project_tests_root, @output_directory)
  end
  
  def test_should_copy_test_file
    build_page_for("foo")
    assert_equal File.read(File.join(@project_tests_root, "foo_test.js")), File.read(File.join(@output_directory, "tests", "foo_test.js"))
    build_page_for("bar")
    assert_equal File.read(File.join(@project_tests_root, "bar", "bar_test.js")), File.read(File.join(@output_directory, "tests", "bar", "bar_test.js"))
  end
  
  def test_should_render_test_page
    build_page_for("foo")
    assert File.exist?(File.join(@output_directory, "foo.html"))
    build_page_for("bar")
    assert File.exist?(File.join(@output_directory, "bar", "bar.html"))
  end
  
  def test_should_return_file_name_for_manifest
    assert_equal "foo.html", build_page_for("foo").to_s
    assert_equal "bar/bar.html", build_page_for("bar").to_s
  end
  
  protected
    def build_page_for(name)
      test_file = @suite_builder.test_files.find { |f| f.to_s.include?(name) }
      EvidenceGatherer::TestPageBuilder.build(test_file, @suite_builder)
    end
end
