module EvidenceGatherer
  class CajaGadgetBuilder < TestPageBuilder
    TEMPLATE = File.join(SuiteBuilder::TEMPLATES_DIR, 'caja_gadget.mustache').freeze
    
    def build
      create_output_dir_structure
      render_test_page
    end
    
    def cajole
      CajaCompiler.compile(output_path, cajoled_path)
    end
    
    def cajoled_path
      output_dir.join("#{canonical_name}_cajoled_gadget.js")
    end
    
    protected
      def template
        File.read(TEMPLATE)
      end
      
      def output_path
        output_dir.join("#{canonical_name}_gadget.html")
      end
  end
end
