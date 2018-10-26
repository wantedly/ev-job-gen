# EvJobGen
Generator of kubernetes manifest file for evaluation job.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ev_job_gen'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ev_job_gen

## Usage

Place a yml file in jobs directory

```yml
# Ex. ml-project-1.yml
namespace: ml-project-1
image: some-docker-registory/ml-project-1:latest
command:
- script/evaluate | tee /tmp/out.txt
out: /tmp/out.txt
metrics: /tmp/metrics.json
commithash: ${COMMITHASH}
setup_wget: apt install -y wget
```

Then execute `ev-job-gen` command.

```console
$ ev-job-gen --jobfile jobs/ml-project-1.yml
```

It generates manifest file for cron job which executes evaluation.

```yml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: ev-job
  namespace: ml-project-1
  labels:
    name: ev-job
    namespace: ml-project-1
    app: ev-job
    role: job
spec:
  backoffLimit: 0
  schedule: "5 17 * * *"
  concurrencyPolicy: "Replace"
  suspend: false
  successfulJobsHistoryLimit: 10
  failedJobsHistoryLimit: 3
  jobTemplate:
    metadata:
      name: ev-job
      labels:
        name: ev-job
        app: ev-job
        role: job
    spec:
      backoffLimit: 1
      template:
        metadata:
          name: ev-job
          labels:
            name: ev-job
            app: ev-job
            role: job
        spec:

          restartPolicy: Never
          containers:
          - name: ev-job
            image: some-docker-registory/ml-project-1:latest
            imagePullPolicy: Always
            command:
              - "/bin/bash"
              - "-c"
              - >
                script/evaluate | tee /tmp/out.txt;

                export AWS_ACCESS_KEY_ID=xxx;
                export AWS_SECRET_ACCESS_KEY=xxx;
                export AWS_REGION=xxx;

                apt install -y wget;
                wget https://github.com/wantedly/ev-cli/releases/download/v1.2.3/ev-v1.2.3-linux-amd64.tar.gz;
                tar xvzf ev-v1.2.3-linux-amd64.tar.gz;
                cp linux-amd64/ev ev;

                ./ev upload --branch master \
                            --commit ${COMMITHASH} \
                            --out /tmp/out.txt \
                            --metrics /tmp/metrics.json \
                            --namespace ml-project-1;
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake true` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/south37/ev-job-gen.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
