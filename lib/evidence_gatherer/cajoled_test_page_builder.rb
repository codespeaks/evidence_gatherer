module EvidenceGatherer
  class CajoledTestPageBuilder < TestPageBuilder
    include TagHelper
    
    def build
      caja_gadget.build
      caja_gadget.cajole
      super
    end
    
    protected
      def view_attributes
        {
          :javascripts => caja_runtime_javascripts,
          :html => script_tag(cajoled_gadget_public_path)
        }
      end
      
      def cajoled_gadget_public_path
        caja_gadget.cajoled_path.basename
      end
      
      def caja_gadget
        @caja_gadget ||= CajaGadgetBuilder.new(input_path, suite_builder)
      end
      
      def caja_runtime_javascripts
        suite_builder.caja_runtime_assets.map do |f|
          normalize_public_path(f)
        end
      end
  end
end
