require 'ev_job_gen'

describe EvJobGen do
  let(:jobfile) { "/tmp/ev_job_gen/ml-project-1.yml" }
  let(:configfile) { "/tmp/ev_job_gen/ml-project-1-config.yml" }

  before do
    prepare_jobfile(jobfile)
    prepare_configfile(configfile)
  end

  after do
    FileUtils.rm(jobfile)
    FileUtils.rm(configfile)
  end

  it "should generate manifest file" do
    # Test cronjob
    result = EvJobGen::ManifestGen.gen(jobfile: jobfile, target: "cronjob", configfile: configfile)
    expect(result).to eq File.read(cron_job_manifest_path)

    # Test oneshot job
    allow_any_instance_of(EvJobGen::Job).to receive(:suffix).and_return('xxxxx')
    result = EvJobGen::ManifestGen.gen(jobfile: jobfile, target: "job", configfile: configfile)
    expect(result).to eq File.read(oneshot_job_manifest_path)
  end

  def prepare_jobfile(outfile)
    FileUtils.mkdir_p(File.dirname(outfile))
    jobbody = <<~EOF
      namespace: ml-project-1
      image: some-docker-registory/ml-project-1:latest
      command:
      - script/evaluate | tee /tmp/out.txt
      - cat /tmp/out.txt > /tmp/metrics.json
      out: /tmp/out.txt
      metrics: /tmp/metrics.json
      commithash: ${COMMITHASH}
      setup_wget: apt install -y wget
    EOF
    File.write(outfile, jobbody)
  end

  def prepare_configfile(outfile)
    FileUtils.mkdir_p(File.dirname(outfile))
    configbody = <<~EOF
      imagePullSecrets:
      - name: wantedlybotkey
      containers.envFrom:
      - secretRef:
        name: dotenv
    EOF
    File.write(outfile, configbody)
  end

  def cron_job_manifest_path
    File.expand_path(File.join('..', 'data', 'cron_job_manifest.yml'), __FILE__)
  end

  def oneshot_job_manifest_path
    File.expand_path(File.join('..', 'data', 'oneshot_job_manifest.yml'), __FILE__)
  end
end
