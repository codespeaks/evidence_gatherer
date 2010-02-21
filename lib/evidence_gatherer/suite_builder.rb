module EvidenceGatherer
  class SuiteBuilder
    TEMPLATES_DIRECTORY = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "templates")).freeze
    DEFAULT_TEMPLATE = "html401".freeze
    DEFAULT_FILE_PATTERN = "**/*_test.js".freeze
    
    attr_reader :input_dir, :output_dir
    
    def initialize(input_dir, output_dir)
      @input_dir = pathname(input_dir)
      @output_dir = pathname(output_dir)
      yield self if block_given?
    end
    
    def build
      delete_output_dir
      create_output_directory_structure
      copy_fixtures if fixtures_path.directory?
      copy_test_files
      copy_evidence
      build_test_files
    end
    
    def fixtures_path
      self.fixtures_path = input_dir.join("fixtures") if @fixtures_path.nil?
      @fixtures_path
    end
    
    def fixtures_path=(fixtures_path)
      @fixtures_path = pathname(fixtures_path)
    end
    
    def test_files
      self.test_files = DEFAULT_FILE_PATTERN if @test_files.nil?
      @test_files
    end
    
    def test_files=(test_files)
      test_files = Array(test_files).collect { |f| File.expand_path(f, input_dir) }
      @test_files = Pathname.glob(*test_files)
    end
    
    def template
      @template || self.template = DEFAULT_TEMPLATE
    end
    
    def template=(template)
      @template = template
    end
    
    def template_path
      File.join(TEMPLATES_DIRECTORY, template_filename)
    end
    
    protected
      def pathname(path)
        Pathname.new(File.expand_path(path))
      end
      
      def delete_output_dir
        FileUtils.rm_rf(output_dir)
      end
      
      def create_output_directory_structure
        FileUtils.mkdir_p(output_dir)
        FileUtils.mkdir_p(output_test_files_path)
      end
      
      def copy_fixtures
        FileUtils.cp_r(fixtures_path, output_fixtures_path)
      end
      
      def output_fixtures_path
        output_dir.join(fixtures_path.relative_path_from(input_dir))
      end
      
      def copy_test_files
        test_files.each { |test_files| FileUtils.cp(test_files, output_test_files_path) }
      end
      
      def output_test_files_path
        output_dir.join("tests")
      end
      
      def copy_evidence
      end
      
      def build_test_files
        test_files.each { |test_file| TestBuilder.new(test_file, self).build }
      end
      
      def template_filename
        "#{template}.mustache"
      end
  end
end
