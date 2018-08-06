require 'yaml'

module EvJobGen
  class Config
    def initialize(configfile)
      if configfile
        @yml = YAML.load_file(configfile)
      else
        @yml = nil
      end
    end

    def imagePullSecrets
      v = fetch("imagePullSecrets")
      return nil if !v
      dump({ "imagePullSecrets" => v })
    end

    def containers_envFrom(offset:)
      v = fetch("containers.envFrom")
      return nil if !v

      s = dump({ "envFrom" => v })
      s.split("\n").map { |l| "#{' ' * offset}#{l}\n" }.join
    end

  private

    def fetch(key)
      return nil if !@yml
      @yml[key]
    end

    def dump(h)
      # NOTE: yml has "---" in first line, so trim it.
      YAML.dump(h).gsub(/^---\n/, '').strip
    end
  end
end
