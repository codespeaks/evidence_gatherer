require File.dirname(__FILE__) + '/../test_helper'

class TestPageBuilderTest < Test::Unit::TestCase
  def setup
    @project_tests_root = File.join(FIXTURES_ROOT, "fixture_project", "test")
    @output_directory = File.join(OUTPUT_ROOT, "fixture_project_tests")
    @test_files_output_directory = File.join(@output_directory, "tests")
    @test_pages_output_directory = File.join(@output_directory, "test_pages")
    @suite_builder = EvidenceGatherer::SuiteBuilder.new(@project_tests_root, @output_directory)
    FileUtils.rm_rf(@output_directory)
  end
  
  def test_should_copy_test_file
    build_page_for("foo")
    assert_equal File.read(File.join(@project_tests_root, "foo_test.js")), File.read(File.join(@test_files_output_directory, "foo_test.js"))
    build_page_for("bar")
    assert_equal File.read(File.join(@project_tests_root, "bar", "bar_test.js")), File.read(File.join(@test_files_output_directory, "bar", "bar_test.js"))
  end
  
  def test_should_render_test_page
    mocked_view = mock
    mocked_view.expects(:render).twice.returns("mocked output")
    mocked_view.expects(:template=).twice.with(@suite_builder.template_content)
    
    EvidenceGatherer::TestPageView.expects(:new).with(
      :stylesheets => nil,
      :javascripts => ['../fixtures/foo.js', '../tests/foo_test.js'],
      :html => nil,
      :title => "foo").returns(mocked_view)
    
    build_page_for("foo")
    file = File.join(@test_pages_output_directory, "foo.html")
    assert File.exist?(file)
    assert_equal "mocked output", File.read(file)
    
    EvidenceGatherer::TestPageView.expects(:new).with(
      :stylesheets => '../../fixtures/bar/bar.css',
      :javascripts => [nil, '../../tests/bar/bar_test.js'],
      :html => "This is bar/bar.html fixture file\n",
      :title => "bar").returns(mocked_view)
    
    build_page_for("bar")
    file = File.join(@test_pages_output_directory, "bar", "bar.html")
    assert File.exist?(file)
    assert_equal "mocked output", File.read(file)
  end
  
  def test_should_return_relative_path_for_manifest
    assert_equal "foo.html", build_page_for("foo").to_s
    assert_equal "bar/bar.html", build_page_for("bar").to_s
  end
  
  protected
    def build_page_for(name)
      test_file = @suite_builder.test_files.find { |f| f.to_s.include?(name) }
      EvidenceGatherer::TestPageBuilder.build(test_file, @suite_builder)
    end
end
