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
        css_fixtures = fixtures_dir_for(:css)
        fixtures_public_path(css_fixtures) if css_fixtures.exist?
      end
      
      def js_fixtures_public_path
        js_fixtures = fixtures_dir_for(:js)
        fixtures_public_path(js_fixtures) if js_fixtures.exist?
      end
      
      def html_content
        html_fixtures = fixtures_dir_for(:html)
        File.read(html_fixtures) if html_fixtures.exist?
      end
      
      def fixtures_dir_for(extension)
        name = fixtures_name_for(extension)
        @suite_builder.fixtures_dir.join(relative_dir, name)
      end
      
      def fixtures_name_for(extension)
        "#{canonical_name}.#{extension}"
      end
      
      def test_file_public_path
        path = test_file_output_path.relative_path_from(output_dir)
        normalize_public_path(path)
      end
      
      def test_file_output_path
        @suite_builder.test_files_output_dir.join(relative_path)
      end
      
      def relative_fixtures_output_dir
        @suite_builder.fixtures_output_dir.relative_path_from(output_dir)
      end
      
      def fixtures_public_path(path)
        path = path.relative_path_from(@suite_builder.fixtures_dir)
        path = relative_fixtures_output_dir.join(path)
        normalize_public_path(path)
      end
      
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
      render_test_page
      copy_test_file
      relative_output_path
    end
    
    protected
      def render_test_page
        FileUtils.mkdir_p(output_dir)
        File.open(output_path, 'w') { |f| f << render }
      end
      
      def copy_test_file
        FileUtils.mkdir_p(test_file_output_path.dirname)
        FileUtils.cp(input_path, test_file_output_path)
      end
      
      def render
        render_view(assets.merge(:title => canonical_name))
      end
      
      def render_view(attributes)
        view = TestPageView.new(attributes)
        view.template = @suite_builder.template_content
        view.render
      end
      
      def output_path
        output_dir.join("#{canonical_name}.html")
      end
      
      def output_dir
        @suite_builder.test_pages_output_dir.join(relative_dir)
      end
      
      def relative_output_path
        output_path.relative_path_from(@suite_builder.test_pages_output_dir)
      end
      
      def relative_path
        input_path.relative_path_from(@suite_builder.input_dir)
      end
      
      def relative_dir
        relative_path.dirname
      end
      
      def canonical_name
        input_path.basename(".js").to_s.sub(/_test$/, '')
      end
  end
end