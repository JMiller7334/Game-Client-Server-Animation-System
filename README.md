# Client-Server Flat Ride System:
Overview:
The Client-Server Flat Ride System is an open-source system created by Jacob Miller(me) for theme park-themed ROBLOX games.
This system is used in my own game: Theme Park Project.

I wanted to provide it to the Roblox community after I noticed several people expressing the need for a system like this. As such I have opened sourced this project.

Be sure to check the readme within this repository for step by step instructions on installing this system.
## Related Links & Demos:
+ **Website: ThemeParkProject** [https://themeparkproject.com/](https://themeparkproject.com/)
+ **Demo: ThemeParkProject Game:** [https://www.roblox.com/games/636542147/Theme-Park-Project-Beta](https://www.roblox.com/games/636542147/Theme-Park-Project-Beta)


# Server Side Documentation: FlatRide_System
## Notable Properties:
+ local START_TIMER = 10  --Sets delay to 10 seconds before the ride begins running. This must adjusted in the client-side code as well.
+ local MODULE_ONLY = {} --Array type of String. List in this array the names of the rides that operate using only module scripts.
+ local ClassRides = {} --The array that holds all class instances of ride. Do not touch.

## Functions:
+ **function syncRides(player: Player)** --Gathers the current animation times from the server and sends them to the client along with whether the ride is active.
  
+ **function runRide(Ride: Object)** --handles updating ride animations times. Ride.riders: array value of string: contains player names of those who rode to completion of a ride. This function is called on its own thread.
  
+ **event_RideStart(RideName: String)** --Remote event function. signals clients to run ride animation this function signals the clients to start their ride animations. This function also handles updating the countdown time for the ride. Triggered by client.
  
+ **event_manageRider(player: Player, character: Model, rideName: String)** --Remote event function that Manages who is current on each ride NOTE: This only keeps track of players who got on the ride before its animation started. Triggered by client.

# Client Side Documentation: Client_Flat_Ride
## Notes
handles the actual animations and tweening of rides. 
It gets the time positions of all running rides and what rides are running 
directly from the server. The server handles no ride animations or tweening.

## Notable Properties:
+ local START_TIMER = 10 --Start-timer in secs, this should match the same variable on the server-side code.
+ local MODULE_ONLY = {} --Array of string. List here the names of rides that run solely using Cframe or any other type of animation that is not a standard animation.
+ local hidePlayer = {} --Array of string. List here the names of rides where the players' entire body should be hidden while they are on it.
+ local TASK_FIRST_TWEEN = {} --Array of string. List the names of rides that have tween animation that will run at the beginning of its standard animation.
+ local TASK_FINAL_TWEEN = {} --Array of string. List the names of rides that have tween animation that will run at the end of its standard animation.

+ local rideThreads = {} --Array that holds references to existing coroutine threads. Do not touch.
+ local rideAnimations = {} --Array that holds the animation properties of each ride. This is generated at startup. Do not touch.

## Functions
+ **function onSeated(isSeated: Bool, seat: Seat)** --Fires when the player sits in a flat ride. This will signal the server to start the ride's animation for this player and all other clients.
  
+ **function runRideTweens(rideName: String, rideAnimation: Object, originalHeight: Double/Float)** --This function handles scheduling the rides beginning and ending tweens and also any tasks that have been assigned to the ride.\
  
+ **function startRide(rideName: String)** --This function starts the ride's animation and is called when rides are started normally by the player. Note: This function is not called when resyncing.
  
+ **function stopRides(rideName: String)** --Stop rides: Halts all rides from running for this client. Rides will appear as if they haven't been started.

+  **function syncRides()** --Synces all rides back with the server so that what this client sees is consistent with what other clients see in the game. BEHAVIOR: Rides with final animation tweens already running will be placed in a finished/not started state (no animation run). All rides first animation tween is skipped and the ride will placed at its goal. The final tween will play if applicable. Note: coroutines for rides being synced are created here.

+  **function createRideThread(rideName: String)** --This function creates coroutines for each ride when they start.

# Addtional Info:
See module template scripts(code files) for additional info on setting up Module Only Rides, configuring additional Tween Animations, and setting up start/end ride tasks.





  




