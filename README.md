# Botvac

This is an unofficial API client which can help you
to interact with the Neato cloudservices which are
used to control you Neato Connected vaccum robot.

## Disclaimer

As this is an official client to the API which required
to reverse the HTTP Authentication mechanism used by
Neato things are topic to be unstable and maybe unreliable.

Please don't blame me :) Just drink a beer and relax, things
will maybe work out in the future ... and maybe not.

## Usage

Add the gem into your project using `bundler`


    gem 'botvac'

### Creating a new robot

In order to crate a new robot, you'll need to figure out
the correct serial and the associated secret.

Once the gem is installed you should have a binary
named `botvac` which allow you to do so:

    $ botvac robots

    Email: foo@example.com
    Password:

    Robot (BotVacConnected) => Serial: OPSXXXX-XXXXX Secret: XXXXXXXX

Save these somewhere, so you can use them later to create a new robot object!

    mrrobot = Botvac::Robot.new(<serial>, <secret>)

Congratulatins, you can now inteact with your robot!!!

    mrrobot.get_robot_state

Will give you some basic information about the status of
your connected robot.

There's more to discover! Currently there's all this avalivale:

* start_cleaning
* pause_cleaning
* stop_cleaning
* send_to_base
* get_robot_state
* disable_schedule
* enable_schedule
* get_schedule

The method names should give you an idea what the specific action will
cause. Still this is not all, but that's what there for the moment.

## Web Server

Botvac ships with a ultra basic web server which can be used to let
the robot easily interact with differnt systems just with calling
a HTTP endpoint.

    rackup -r 'botvac/web' -b "run Botvac::Web.new"

The environemnt variables `SERIAL` and `SECRET` are
mandatory to set!

    curl http://localhost:9292/get_robot_state

Will make the action start. To trigger other activities, just
change the requested URL to one of the above method names.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/botvac/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
