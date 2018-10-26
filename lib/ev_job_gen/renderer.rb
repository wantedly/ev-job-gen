require 'ev_job_gen/renderer/manifest_renderer'
require 'ev_job_gen/renderer/spec_renderer'

module EvJobGen
  class Renderer
    def initialize(template:, specoffset:, jobfile:, configfile:)
      @template      = template
      @specoffset    = specoffset
      @job           = EvJobGen::Job.new(jobfile)
      @config        = EvJobGen::Config.new(configfile)
    end

    def render
      spec = SpecRenderer.new(
        job:    @job,
        config: @config,
      ).render

      r = ManifestRenderer.new(
        template: @template,
        job:      @job,
        spec:     offset(spec, off: @specoffset + 2)
      ).render

      normalize(r)
    end

  private

    def normalize(text)
      text.split("\n").map { |l| l.rstrip }.map { |l| "#{l}\n" }.join
    end

    def offset(text, off:)
      "\n" + text.split("\n").map { |l| "#{' ' * off}#{l}\n" }.join
    end
  end
end
