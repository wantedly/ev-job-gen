require 'ev_job_gen/cli/option'

module EvJobGen
  class CLI
    class << self
      def run!(argv)
        CLI.new(argv).run!
      end
    end

    def initialize(argv)
      @option = Option.new
      @option.parse!(argv)
    end

    def run!
      yml = ManifestGen.gen(jobfile: @option.jobfile, target: @option.target)
      print yml
    end
  end
end
