require File.dirname(__FILE__) + '/../test_helper'

class SuiteBuilderTest < Test::Unit::TestCase
  def setup
    @project_tests_root = File.join(FIXTURES_ROOT, "fixture_project", "test")
    @output_directory = File.join(OUTPUT_ROOT, "fixture_project_tests")
    @suite_builder = EvidenceGatherer::SuiteBuilder.new(@project_tests_root, @output_directory)
  end
  
  def test_should_not_modify_source_directory
    assert !modifies_dir?(@project_tests_root) { @suite_builder.build }
  end
  
  def test_should_clean_up_output_directory
    dir = File.join(@output_directory, "some_old_dir")
    FileUtils.mkdir_p(dir)
    @suite_builder.build
    assert !File.exist?(dir)
  end
  
  def test_should_copy_fixtures_directory
    @suite_builder.build
    assert_equal compute_dir_checksum(File.join(@project_tests_root, "fixtures")), compute_dir_checksum(File.join(@output_directory, "fixtures"))
  end
  
  def test_should_build_test_pages
    @suite_builder.test_files.each do |test_file|
      EvidenceGatherer::TestPageBuilder.expects(:build).once.with(test_file, @suite_builder)
    end
    @suite_builder.build
  end
  
  def test_should_create_manifest
    manifest = File.join(@output_directory, "Manifest.json")
    assert File.exist?(manifest)
    assert_equal ["bar/bar.html","foo.html"], JSON.parse(File.read(manifest))
  end
  
  protected
    require 'digest/md5'
    
    def modifies_dir?(dir)
      checksum = compute_dir_checksum(dir)
      yield
      checksum != compute_dir_checksum(dir)
    end
    
    def compute_dir_checksum(dir)
      Dir.glob(File.join(dir, "**", "*")).inject("") do |result, file|
        if File.file?(file)
          result << Digest::MD5.hexdigest(File.read(file))
        else
          result
        end
      end
    end
end
