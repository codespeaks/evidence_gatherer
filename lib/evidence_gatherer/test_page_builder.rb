module EvidenceGatherer
  class TestPageBuilder
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
      output_path.relative_path_from(@suite_builder.output_dir)
    end
    
    protected
      def render_test_page
        FileUtils.mkdir_p(output_dir)
        File.open(output_path, "w") do |f|
          f << render
        end
      end
      
      def copy_test_file
        FileUtils.mkdir_p(test_file_output_path.dirname)
        FileUtils.cp(input_path, test_file_output_path)
      end
      
      def render
        view(
          :title => canonical_name,
          :stylesheets => css_fixtures,
          :javascripts => [js_fixtures, js_test_file],
          :html => html_content
        ).render
      end
      
      def view(attributes)
        view = TestPageView.new(attributes)
        view.template = File.read(@suite_builder.template_path)
        view
      end
      
      def output_dir
        @suite_builder.output_dir.join(relative_pathname.dirname)
      end
      
      def output_path
        output_dir.join("#{canonical_name}.html")
      end
      
      def relative_pathname
        input_path.relative_path_from(@suite_builder.input_dir)
      end
      
      def test_file_output_path
        @suite_builder.test_files_output_dir.join(relative_pathname)
      end
      
      def canonical_name
        input_path.basename(".js").sub(/_test$/, '')
      end
      
      def css_fixtures
        css_fixtures = fixtures_path(:css)
        to_server_path(css_fixtures) if css_fixtures.exist?
      end
      
      def js_fixtures
        js_fixtures = fixtures_path(:js)
        to_server_path(js_fixtures) if js_fixtures.exist?
      end
      
      def fixtures_path(extension)
        @suite_builder.fixtures_path.join(relative_pathname).dirname.join("#{canonical_name}.#{extension}")
      end
      
      def html_content
        html_fixtures = fixtures_path(:html)
        File.read(html_fixtures) if html_fixtures.exist?
      end
      
      def js_test_file
        @suite_builder.test_files_output_dir.relative_path_from(output_dir).join(input_path.basename)
      end
      
      def to_server_path(path)
        path.relative_path_from(input_path.dirname).to_s.gsub(File::SEPARATOR, '/')
      end
  end
end