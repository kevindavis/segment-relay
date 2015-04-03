# segment-relay
Segment-relay is a micro-service that relays events from [Segment.io](http://segment.io/) into a database where you can do free-form analysis.

## How to use..

1. Deploy this code somewhere 
    
    [![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

    Remember the URL you deployed it to, you'll need it in step 4. If you used the deploy button above it should look something like [yourappname].herokuapp.com.
2. Set up a Postgres DB
    
    A database should be created and set up for you if you use the deploy button above. 

    If not, create a Postgres database, set a DATABASE_URL environment variable to a valid connection string and run ``rake db:create`` to create the events table (see schema below)

4. Start relaying your events from Segment
  
    ![activate webhook](http://i.imgur.com/ZJ9y4x8.png)

    ![configure webhook](http://i.imgur.com/44dBwG4.png)

5. Connect an analysis tool of your choice to your database 

## Schema

segment-relay uses a single 'events' table to store event data. Naming derived from the [Mode playbook](http://about.modeanalytics.com/playbook/)

* user_id, text
* event_name, text
* details, json or jsonb depending on the version of Postgres you're using (jsonb available in 9.4 and above and is considerably faster)
* occurred_at, timestamp
