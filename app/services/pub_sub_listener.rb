require "google/cloud/pubsub"

class PubSubListener

  def self.pubsub
    @pubsub ||= Google::Cloud::Pubsub.new(project_id: "some-project", emulator_host: 'localhost:8085')
  end

  def self.pubsub_topic
    @pubsub_topic ||= "users"
  end

  def self.pubsub_subscription
    @pubsub_subscription ||= "users-sub"
  end

  def self.listen
    puts "Google Pub Sub Listener has been activated"

    topic        = pubsub.topic pubsub_topic
    subscription = topic&.subscription pubsub_subscription

    subscriber = subscription&.listen do |message|
      puts "User request (#{message.message.data})"
      user = User.new(name: message.message.data)
      user.save
      message.acknowledge!
    end

    # Start background threads that will call block passed to listen.
    subscriber&.start

    # Fade into a deep sleep as worker will run indefinitely
    sleep
  end
end
