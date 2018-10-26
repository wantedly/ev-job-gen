module EvJobGen
  class ManifestGen
    class << self
      def gen(jobfile:, target:, configfile:)
        self.new(jobfile: jobfile, target: target, configfile: configfile).gen
      end
    end

    CRONJOB_TEMPLATE_FILE    = "cron_job_template.yml.erb"
    ONESHOTJOB_TEMPLATE_FILE = "oneshot_job_template.yml.erb"

    def initialize(jobfile:, target:, configfile:)
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
      @renderer = Renderer.new(
        template:   template,
        specoffset: specoffset,
        jobfile:    jobfile,
        configfile: configfile,
      )
    end

    def gen
      @renderer.render
    end
  end
end
