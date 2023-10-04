# Client-Server Flat Ride System:
### Overview:
The Client-Server Flat Ride System is an open-source system I created for theme-park-themed ROBLOX games.
This system is used in my own game: Theme Park Project. 

It is a game animation management system tailored for optimizing animations for specific in-game models. It bridges the client-server barrier, offering solid game performance and eliminates animation latency issues.

The system allows the client-side to efficiently handle animations and utilizes multi threading and careful communication with the server to ensure all clients are in sync with each other. Moreover, it allows, with proper configuration the offloading of animations when they are not needed on a per client basis to boost game performance even further.

I wanted to provide it to the Roblox community after I noticed several people expressing the need for a system like this. 
As such I have opened sourced this project.

### System Info:
* This system utilizes multi-threading.
* Animations are handled by the client and not the server.
* Animation timing/monitoring managed by the server.
* Proper client/server practices applied.
* Plug & play: UI, camera, and ride starting/stopping are handled for all your rides automatically. Simply include them in the flatRides directory.

## GitHub Code Links (This Project):
* [Server: FlatRide_System](https://github.com/JMiller7334/Game-Client-Server-Animation-System/blob/main/ServerScriptStorage/FlatRide_System.lua)
* [Client: Client_Flat_Ride](https://github.com/JMiller7334/Game-Client-Server-Animation-System/blob/main/StarterPlayerScripts/Client_Flat_Ride)
* [Module: _Camera](https://github.com/JMiller7334/Game-Client-Server-Animation-System/blob/main/ReplicatedStorage/Modules/_Camera.lua)
* [Module: Tween_Config](https://github.com/JMiller7334/Game-Client-Server-Animation-System/blob/main/ReplicatedStorage/Modules/FlatRide_TweenConfig.lua)
* [Module: Module_Only - Configurable](https://github.com/JMiller7334/Game-Client-Server-Animation-System/blob/main/ModuleTemplates%5BPlace%20into%20Client_Flat_Ride%5D/MODULE_ONLY_TEMPLATE.lua)
* [Module: Ride_Tasks - Configurable](https://github.com/JMiller7334/Game-Client-Server-Animation-System/blob/main/ModuleTemplates%5BPlace%20into%20Client_Flat_Ride%5D/RIDE_TASK_TEMPLATE.lua)

## Related Links & Demos:
+ **Official Website:** [https://themeparkproject.com/pages/opensource](https://themeparkproject.com/pages/opensource.html)
+ **Official Game:** [https://www.roblox.com/games/636542147/Theme-Park-Project-Beta](https://www.roblox.com/games/636542147/Theme-Park-Project-Beta)
+ **Youtube Tutorial:** https://youtu.be/I-so6Pl_LNM

## Installation:
+ 1: Ensure there is a folder named 'FlatRides' that is parented to game.Workspace
+ 2: Ensure that there is a folder in game.ReplicatedStorage called 'Modules' and the scripts '_Camera' and 'FlatRide_TweenConfig' are inside that folder. They should be classed as ModuleScripts.
+ 3: Ensure that 'Client_Flat_Ride' is placed into game.StarterPlayer.StarterPlayerScripts and that it is classed as a LocalScript and that both template module scripts are parented to 'Client_Flat_Ride' and are classed as ModuleScripts.
+ 4: Ensure 'FlatRide_System' is placed into game.ServerScriptService and is classed as a Script.

+ 5: The system is installed: See below for how to configure your rides to work with the system.

## Ride Configuration:
+ 1: Create a new folder in the FlatRides folder in game.Workspace and give it a name. This name should be unique.
+ 2: Place the animation for the ride directly into the folder you created in the previous step.
+ 3: Make sure all parts of your flat ride are housed in a model called "Ride". This needs to be placed directly in the folder you created at step 1 of ride configuration.
+ 4: Ensure that all instances of Seat are placed in the "Ride" model. You can have any number of seats but name them "Seat1", "Seat2", ... count up accordingly.
+ 5: Ensure there is an instance of AnimationController called "AnimationController" inside the "Ride" model
+ 6: Ensure there is an instance of an Animator called "Animator" located directly inside the AnimationController mentioned in the previous step.

+ 7: Your ride is configured! If the system is configured it should run when your avatar sits in it.

## (Optional) Configuration of Tween Animations, Module Only Rides, Ride Tasks:
See the scripts in the Module Templates folder for info on setting each of these features up.
+ Tween Animations: Run tween animations alongside standard animations. Up to 2 tween animations. The first tween animations will automatically be scheduled to run at the beginning of the ride animation and the second will be scheduled to run so it finishes as the ride's standard animation finishes.

+ Module Only Rides: Run a ride without a standard animation using only a module script.

+ Ride Tasks (requires at least 1 Tween animation configured): Run a task parallel to a tween animation. Up to 1 task per tween.

# Server-Side Documentation: [FlatRide_System](https://github.com/JMiller7334/Game-Client-Server-Animation-System/blob/main/ServerScriptStorage/FlatRide_System.lua)
### Configurable Variables:
+ ```local START_TIMER: int```  : sets the delay and countdown time before the ride begins running after a player enters it. This must adjusted in the client-side code as well.
+ ```local MODULE_ONLY: array(string)``` : List here the names of the rides that operate using only module scripts.

### Classes:
+ ```local ClassRides: dictionary[string : object]``` :Holds class instances. See class properties below.
  
  + ```.name: string``` : unique identifier of the ride, same as the rides folder name.
  + ```.animLength: number/float``` : Total time in seconds of the ride's animation length.
  + ```.animPosition: number/float``` : Current time position of the ride's animation.
  + ```.active: boolean``` : Is set according to whether or not the ride is currently running
  + ```.riders: array(string)``` : Lists the names of the current riders that had gotten on the ride before its animation started playing.
  + ```.run(): function``` : The Function that is called that will communicate to clients to start this ride's animation.

### Functions:
+ ```function syncRides(player: object[Player]) -> returns: dictionary[string : number/float]``` : Gathers the current animation times from the server and sends them to the client along with whether the ride is active.
  
  
+ ```function runRide(ride: ClassRides[string])``` : handles updating ride animations times and Ride.riders. This function is called on its own thread.
  
+ ```event_RideStart(rideName: String)``` : Remote event function. Signals the clients to start their ride animations. This function also handles updating the countdown time for the ride. Triggered by client.
  
+ ```event_manageRider(player: object[Player], character: object[Model], rideName: String)``` :Remote event function that Manages who is current on each ride NOTE: This only keeps track of players who got on the ride before its animation started. Triggered by client.

# Client-Side Documentation: [Client_Flat_Ride](https://github.com/JMiller7334/Game-Client-Server-Animation-System/blob/main/StarterPlayerScripts/Client_Flat_Ride)
### Notes:
This script handles the actual animations and tweening of rides. 
It gets the time positions of all running rides and what rides should or shouldn't be running 
directly from the server. The server handles no ride animations or tweening, this does that.

### Configurable Variables:
+ ```local START_TIMER: int``` : Start-timer in seconds, this should match the same variable on the server-side code.
  
+ ```local MODULE_ONLY: array(string)``` : List here the names of rides that run solely using Cframe or any other type of animation that is not a standard animation.
  
+ ```local hidePlayer: array(string)``` : List here the names of rides where the players' entire body should be hidden while they are on it.
  
+ ```local TASK_FIRST_TWEEN: array(string)``` : List the names of rides that have a tween animation that will run at the beginning of its standard animation.
  
+ ```local TASK_FINAL_TWEEN: array(string)``` : List the names of rides that have a tween animation that will run at the end of its standard animation.

### Other Variables:
+ ```local rideThreads: array(coroutine)``` : holds existing coroutine/threads. Do not touch.

### Classes:
+ ```local rideAnimations: dictionary[string : object]``` : Holds class instances: See class properties below.
  
  + ```.animTrack: object[AnimationTrack]``` : the ride's animation after it has been loaded by the animator.

### Functions:
+ ```function onSeated(isSeated: Boolean, seat: object[Seat])``` : Fires when the player sits in a flat ride. This will signal the server to start the ride's animation for this player and all other clients.
  
+ ```function runRideTweens(rideName: String, rideAnimation: object[AnimationTrack], originalHeight: number/float)``` : This function handles scheduling the rides beginning and ending tweens and also any tasks that have been assigned to the ride.
  
+ ```function startRide(rideName: String)``` : This function starts the ride's animation and is called when rides are started normally by the player. Note: This function is not called when resyncing.
  
+ ```function stopRides(rideName: String)``` : Stop rides: Halts a ride from running for this client. Rides will appear as if they haven't been started.

+  ```function syncRides()``` : Synces all rides back with the server so that what this client sees is consistent with what other clients see in the game.
   + **Sync behavior:** Rides with final tween animation already running will be placed in a finished/not started state (no animation run). Rides with tween animations will have their first tween animation skipped and the ride will placed at its tween goal. The final tween will play if applicable. Note: coroutines for rides being synced are created here.

+  ```function createRideThread(rideName: String)``` : This function handles coroutines for each ride when they start.

### Contact:
**If you have questions or issues or want to report a bug please email: ThemeParkProjectGame@Gmail.com**
