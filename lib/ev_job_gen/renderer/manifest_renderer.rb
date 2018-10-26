require 'erb'

module EvJobGen
  class Renderer
    class ManifestRenderer
      def initialize(template:, job:, spec:)
        @renderer = ERB.new(File.read(template))
        @job      = job
        @spec     = spec
      end
      attr_reader :job, :spec

      def render
        @renderer.result(binding)  # Only use `job` and `spec`
      end
    end
  end
end
