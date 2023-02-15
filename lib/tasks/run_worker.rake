desc "Run pub sub queue worker"
task run_worker: :environment do
  PubSubListener.listen
end
