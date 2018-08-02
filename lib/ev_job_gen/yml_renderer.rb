require 'erb'
require 'fileutils'

module EvJobGen
  class YmlRenderer
    class << self
      def spec_template_path
        File.expand_path(
          File.join('kubernetes', 'tmpl', 'spec_template.yml.erb'),
          EvJobGen.root,
        )
      end
    end

    def initialize(template:, specoffset:, jobfile:)
      @spec_renderer = ERB.new(File.read(YmlRenderer.spec_template_path))
      @specoffset    = specoffset
      @renderer      = ERB.new(File.read(template))
      @job           = EvJobGen::Job.new(jobfile)
    end

    attr_reader :job

    def render
      spec = render_spec
      @renderer.result(binding)
    end

  private

    def render_spec
      r = @spec_renderer.result(binding)
      offset = @specoffset + 2
      "\n" + r.split("\n").map { |l| "#{' ' * offset}#{l}\n" }.join
    end
  end
end
