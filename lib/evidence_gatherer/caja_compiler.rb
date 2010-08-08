require 'coffee_machine'

module EvidenceGatherer
  module CajaCompiler
    PLUGIN_CLASS = 'com.google.caja.plugin.PluginCompilerMain'.freeze
    CAJA_DIR = File.join(File.dirname(__FILE__), '..', '..', 'vendor', 'caja').freeze
    
    extend self
    
    def compile(input_path, output_path)
      out, err = CoffeeMachine.run_class(PLUGIN_CLASS,
        {
          '--input' => input_path,
          '--output_js' => output_path,
          '--only_js_emitted' => true
          # '--debug' => true
        },
        :classpath => jars)
      raise err unless $?.success?
    end
    
    def runtime_assets
      Dir.glob(File.join(CAJA_DIR, 'runtime', '*.js'))
    end
    
    protected
      def jars
        Dir.glob(File.join(CAJA_DIR, 'ant-jars', '*.jar'))
      end
  end
end
