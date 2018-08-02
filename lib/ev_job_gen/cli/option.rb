require 'optparse'

module EvJobGen
  class CLI
    class Option
      attr_reader :jobfile, :out, :target

      def initialize
        @jobfile = nil
        @target  = "cronjob"
      end

      def parse!(argv)
        opt = OptionParser.new
        opt.on('--jobfile jobfile') { |v| @jobfile = v }
        opt.on('--target [target]') { |v| @target = v }
        opt.parse!(argv)
        validate!
      end

    private

      def validate!
        if !@jobfile
          raise "<jobfile> is required!"
        end

        if !["cronjob", "job"].include?(@target)
          raise '<target> must be "cronjob" or "job"'
        end
      end
    end
  end
end
