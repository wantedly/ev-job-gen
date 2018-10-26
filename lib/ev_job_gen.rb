require 'dotenv/load'

require 'ev_job_gen/cli'
require 'ev_job_gen/config'
require 'ev_job_gen/job'
require 'ev_job_gen/manifest_gen'
require 'ev_job_gen/renderer'

module EvJobGen
  class << self
    def root
      File.expand_path(File.join('..', '..'), __FILE__)
    end

    def tmpl_dir
      File.expand_path(File.join('kubernetes', 'tmpl'), self.root)
    end
  end
end
