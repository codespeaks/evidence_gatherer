module EvidenceGatherer
  class SuiteBuilder
    TEMPLATES_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'templates')).freeze
    ASSETS_DIR = File.join(File.dirname(__FILE__), '..', '..', 'assets').freeze
    DEFAULT_TEMPLATE = :html401
    DEFAULT_FILE_PATTERN = '**/*_test.js'.freeze
    DEFAULT_INDEX_PAGE = File.join(ASSETS_DIR, 'index.html').freeze
    
    attr_reader :input_dir, :output_dir
    
    def initialize(input_dir, output_dir)
      @input_dir = pathname(input_dir)
      @output_dir = pathname(output_dir)
      yield self if block_given?
    end
    
    def build
      delete_output_dir
      create_output_dir_structure
      copy_evidence
      copy_index_page
      files = build_test_pages
      create_manifest(files)
    end
    
    def fixtures_dir
      self.fixtures_dir = input_dir.join("fixtures") if @fixtures_dir.nil?
      @fixtures_dir
    end
    
    def fixtures_dir=(fixtures_dir)
      @fixtures_dir = pathname(fixtures_dir)
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
    
    def index_page
      self.index_page = DEFAULT_INDEX_PAGE if @index_page.nil?
      @index_page
    end
    
    def index_page=(index_page)
      @index_page = index_page
    end
    
    def template_content
      File.read(template_path)
    end
    
    def test_pages_output_dir
      output_dir.join("test_pages")
    end
    
    def assets_output_dir
      output_dir.join("assets")
    end
    
    protected
      def pathname(path)
        Pathname.new(File.expand_path(path))
      end
      
      def delete_output_dir
        FileUtils.rm_rf(output_dir)
      end
      
      def create_output_dir_structure
        FileUtils.mkdir_p(test_pages_output_dir)
        FileUtils.mkdir_p(assets_output_dir)
      end
      
      def copy_evidence
        # FileUtils.cp(File.join(ASSETS_DIR, 'evidence.js'), assets_output_dir)
      end
      
      def copy_index_page
        FileUtils.cp(index_page, output_dir)
      end
      
      def build_test_pages
        test_files.collect do |file|
          TestPageBuilder.build(file, self)
        end
      end
      
      def create_manifest(files)
        File.open(manifest_path, 'w') do |f|
          f << files.join("\n")
        end
      end
      
      def manifest_path
        test_pages_output_dir.join('Manifest')
      end
      
      def template_filename
        "#{template}.mustache"
      end
      
      def template_path
        if template.is_a?(Symbol)
          File.join(TEMPLATES_DIR, template_filename)
        else
          template_filename
        end
      end
  end
end
