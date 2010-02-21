module EvidenceGatherer
  class TestBuilder

    attr_reader :input_pathname
    
    def initialize(input_pathname, suite_builder)
      @input_pathname = input_pathname
      @suite_builder = suite_builder
    end
    
    def build
      puts output_path
      File.open(output_path, "w") do |f|
        f << render
      end
    end
    
    protected
      def render
        view({
          :title => canonical_name#,
          # :css   => css_fixtures,
          # :js    => js_fixtures,
          # :html  => html_fixtures
        }).render
      end
      
      def view(attributes)
        view = TestView.new(attributes)
        view.template = File.read(@suite_builder.template_path)
        view
      end
      
      def output_path
        @suite_builder.output_dir.join(relative_pathname.dirname, "#{canonical_name}.html")
      end
      
      def relative_pathname
        input_pathname.relative_path_from(@suite_builder.input_dir)
      end
      
      def canonical_name
        input_pathname.basename(".js").sub(/_test$/, '')
      end
  end
end