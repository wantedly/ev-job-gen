require 'yaml'

module EvJobGen
  class Job
    CHARS = [*'a'..'z'] + [*'0'..'9']

    def initialize(yml_file)
      h = YAML.load_file(yml_file)
      validate!(h)
      @namespace  = h["namespace"]
      @image      = h["image"]
      @command    = h["command"]
      @out        = h["out"]
      @metrics    = h["metrics"]
      @commithash = h["commithash"]

      # NOTE: suffix is used only for oneshot job
      @suffix    = 5.times.map { CHARS.sample }.join
    end

    attr_reader :namespace, :image, :command, :out, :metrics, :commithash, :suffix

  private

    def validate!(h)
      validate_column!(h, "namespace")
      validate_column!(h, "image")
      validate_column!(h, "command")
      validate_column!(h, "out")
      validate_column!(h, "metrics")
      validate_column!(h, "commithash")
    end

    def validate_column!(h, column)
      if !h[column]
        raise "#{column} must be specified, but got #{h[column]}"
      end
    end
  end
end
