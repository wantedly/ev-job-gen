module EvJobGen
  class ManifestGen
    class << self
      def gen(jobfile:, target:)
        self.new(jobfile: jobfile, target: target).gen
      end
    end

    CRONJOB_TEMPLATE_FILE    = "cron_job_template.yml.erb"
    ONESHOTJOB_TEMPLATE_FILE = "oneshot_job_template.yml.erb"

    def initialize(jobfile:, target:)
      case target
      when "cronjob"
        template   = File.join(EvJobGen.tmpl_dir, CRONJOB_TEMPLATE_FILE)
        specoffset = 8
      when "job"
        template   = File.join(EvJobGen.tmpl_dir, ONESHOTJOB_TEMPLATE_FILE)
        specoffset = 4
      else
        raise "invalid target: #{target}"
      end
      @renderer = YmlRenderer.new(
        template:   template,
        specoffset: specoffset,
        jobfile:    jobfile,
      )
    end

    def gen
      @renderer.render
    end
  end
end
