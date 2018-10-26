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

    def initialize(template:, specoffset:, jobfile:, configfile:)
      @spec_renderer = ERB.new(File.read(YmlRenderer.spec_template_path))
      @specoffset    = specoffset
      @renderer      = ERB.new(File.read(template))
      @job           = EvJobGen::Job.new(jobfile)
      @config        = EvJobGen::Config.new(configfile)
    end

    attr_reader :job, :config

    def render
      spec = render_spec
      r = @renderer.result(binding)
      normalize(r)
    end

  private

    def render_spec
      r = @spec_renderer.result(binding)
      offset = @specoffset + 2
      "\n" + r.split("\n").map { |l| "#{' ' * offset}#{l}\n" }.join
    end

    def normalize(text)
      text.split("\n").map { |l| l.rstrip }.map { |l| "#{l}\n" }.join
    end
  end
end
