module EvidenceGatherer
  class TestPageBuilder
    module Assets
      def assets
        {
          :stylesheets => css_fixtures_public_path,
          :javascripts => [js_fixtures_public_path, test_file_public_path],
          :html => html_content
        }
      end
      
      def css_fixtures_public_path
        css_fixtures = fixtures_for(:css)
        fixtures_public_path(css_fixtures) if css_fixtures.exist?
      end
      
      def js_fixtures_public_path
        js_fixtures = fixtures_for(:js)
        fixtures_public_path(js_fixtures) if js_fixtures.exist?
      end
      
      def test_file_public_path
        test_file_output_path.basename
      end
      
      def html_content
        html_fixture = fixtures_for(:html)
        File.read(html_fixture) if html_fixture.exist?
      end
      
      def fixtures_for(extension)
        fixtures_dir.join("#{canonical_name}.#{extension}")
      end
      
      def fixtures_name_for(extension)
        "#{canonical_name}.#{extension}"
      end
      
      def fixtures_public_path(path)
        "fixtures/#{path.basename}"
      end
      
      # TODO: remove if unused
      def normalize_public_path(path)
        path.to_s.gsub(File::SEPARATOR, '/')
      end
    end
    
    include Assets
    
    attr_reader :input_path
    
    def self.build(*args)
      new(*args).build
    end
    
    def initialize(input_path, suite_builder)
      @input_path = input_path
      @suite_builder = suite_builder
    end
    
    def build
      create_output_dir_structure
      render_test_page
      copy_test_file
      copy_fixtures
      relative_output_path
    end
    
    protected
      def create_output_dir_structure
        FileUtils.mkdir_p(output_dir)
        FileUtils.mkdir_p(fixtures_output_dir) if fixtures.any?
      end
      
      def render_test_page
        File.open(output_path, 'w') { |f| f << render }
      end
      
      def copy_test_file
        FileUtils.cp(input_path, test_file_output_path)
      end
      
      def copy_fixtures
        fixtures.each do |fixture|
          FileUtils.cp(fixture, fixtures_output_dir)
        end
      end
      
      def fixtures
        pattern = fixtures_dir.join("#{canonical_name}.{html,js,css}")
        Dir.glob(pattern)
      end
      
      def fixtures_dir
        @suite_builder.fixtures_dir.join(relative_dir)
      end
      
      def fixtures_output_dir
        output_dir.join('fixtures')
      end
      
      def render
        render_view(assets.merge(:title => canonical_name))
      end
      
      def render_view(attributes)
        view = TestPageView.new(attributes)
        view.template = @suite_builder.template_content
        view.render
      end
      
      # test/foo/bar_test.js -> test_pages/foo/bar/index.html
      def output_path
        output_dir.join('index.html')
      end
      
      # test/foo/bar_test.js -> test_pages/foo/bar/test.js
      def test_file_output_path
        output_dir.join('test.js')
      end
      
      # test/foo/bar_test.js -> test_pages/foo/bar/
      def output_dir
        output_root.join(relative_dir).join(canonical_name)
      end
      
      def output_root
        @suite_builder.test_pages_output_dir
      end
      
      def relative_output_path
        output_path.relative_path_from(@suite_builder.test_pages_output_dir)
      end
      
      def relative_path
        input_path.relative_path_from(@suite_builder.input_dir)
      end
      
      # TODO: used?
      def relative_dir
        relative_path.dirname
      end
      
      def canonical_name
        input_path.basename(".js").to_s.sub(/_test$/, '')
      end
  end
end