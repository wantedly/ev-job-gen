require 'erb'

module EvJobGen
  class Renderer
    class SpecRenderer
      class << self
        def spec_template_path
          File.expand_path(
            File.join('kubernetes', 'tmpl', 'spec_template.yml.erb'),
            EvJobGen.root,
          )
        end
      end

      def initialize(job:, config:)
        @job        = job
        @config     = config
        @renderer   = ERB.new(File.read(SpecRenderer.spec_template_path))
      end
      attr_reader :job, :config

      def render
        @renderer.result(binding)  # Only use `job` and `config`
      end
    end
  end
end
