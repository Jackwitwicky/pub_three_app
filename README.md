# README

## SETUP INSTRUCTIONS

* have a google pub sub emulator installed and running locally: Instructions to do this can be found here: 

```
# Download and configure the gcloud CLI by going to https://cloud.google.com/sdk/docs/install
gcloud components install pubsub-emulator
gcloud components update

# Start the emulator in a dedicated terminal
gcloud beta emulators pubsub start
```

* run bundle install

## Create Topic and Subscription

The next step is to create a user and user-sub topic which the listener
will be listening to once the server is up and running. To do this, open 
the rails console and run the following commands

```
> require 'google/cloud/pubsub'

> pubsub = Google::Cloud::Pubsub.new(project_id: "some-project", emulator_host: 'localhost:8085')

> topic = pubsub.create_topic("users")

> topic.subscribe("users-sub")
```
Leave the console running as we will use it to publish messages to Google Pub/Sub later

## Start the Server
In a different terminal, run ``foreman start`` to launch the server. Look out for the message ``Google Pub Sub Listener has been activated``.
This is will let you know that we are now ready and listening for any messages coming to the `users-sub` subscription

## Send your first Message
On the previous terminal, run the following to publish a message
```
> topic.publish("John Doe")
```

## Confirm that everything went as expected
Open a new terminal and confirm that a new user was created with the name you provided
above

```
> rails console

> User.last

#<User:0x000000010a190b58 id: 11, name: "John Doe" ....
```
