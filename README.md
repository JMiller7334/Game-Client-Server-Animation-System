# Client-Server Flat Ride System:
### Overview:
The Client-Server Flat Ride System is an open-source system I created for theme-park themed ROBLOX games.
This system is used in my own game: Theme Park Project.

I wanted to provide it to the Roblox community after I noticed several people expressing the need for a system like this. 
As such I have opened sourced this project.

### Installation:
+ 1: Ensure there is a folder name 'FlatRides' that is parented to Workspace
+ 2: Ensure that there is a folder in ReplicatedStorage called 'Modules' and that the modules '_Camera' and 'FlatRide_TweenConfig' are inside that folder.
+ 3: Ensure that 'Client_Flat_Ride' is placed into StarterPlayer -> StarterPlayerScripts.

+ 4: The system is installed: See below on how to configure your rides to work with the system.

### Ride Configuration:
+ 1: Create a new folder and name it after the ride you wish to install; place it inside the "FlatRides" folder in Workspace that you created during installation.
+ 2: Place the animation for the ride directly into the folder you created at step 1 of ride configuration.
+ 3: Make sure all parts of your flat ride are housed in a model called "Ride". This is case-sensitive This needs to be placed directly in the folder you placed the animation into at step 2.
+ 4: Ensure that all instances of Seat are placed in the "Ride" model, you can have any number of seats but name them "Seat1", "Seat2", ... counting up accordingly.
+ 5: Ensure there is an instance of AnimationController called "AnimationController" inside the "Ride" model
+ 6: Ensure there is an instance of an Animator called "Animator" located directly inside the AnimationController mentioned in the previous step.

+ 7: Your ride is configured! If the system is configured it should run when your character sits in it.
**All rides should have their own folders and unique names for each folder that they are housed in.

### (Optional) Configuration of Tween Animations, Module Only Rides, Ride Tasks:
See the scripts in the Module Templates folder for info on setting each of these features up.
+ Tween Animations: Run tween animations alongside standard animations. Up to 2 tween animations. Tween animations will automatically be scheduled to run at the 1st and the beginning of the ride animation and the second will finish as the ride animation finishes.

+ Module Only Rides: Run a ride without a standard animation using only a module script.

+ Ride Tasks (requires at least 1 Tween animation configured): Run a task parallel to a tween animation. Up to 1 task per tween.

## Related Links & Demos:
+ **Website: ThemeParkProject:** [https://themeparkproject.com/](https://themeparkproject.com/)
+ **Demo: ThemeParkProject Game:** [https://www.roblox.com/games/636542147/Theme-Park-Project-Beta](https://www.roblox.com/games/636542147/Theme-Park-Project-Beta)


# Server-Side Documentation: FlatRide_System
### Configurable Variables:
+ local START_TIMER: int  --sets the delay and countdown time before the ride begins running. This must adjusted in the client-side code as well.
+ local MODULE_ONLY = {}: array(string) --Lists the names of the rides that operate using only module scripts.

### Classes:
+ local ClassRides: dictionary[string : object] --Holds class instances. See class properties below.
  
  + .name: string --unique identifier of the ride, same as the rides folder name.
  + .animLength: number/float --Total time in seconds of the ride's animation length.
  + .animPosition: number/float --Current time position of the ride's animation.
  + .active: boolean --Is set according to whether or not the ride is currently running
  + .riders: array(string) --Lists the names of the current riders that had gotten on the ride before its animation started playing.
  + .run(): function --The Function that is called that will communicate to clients to start this ride's animation.

### Functions:
+ **function syncRides(player: object[Player]) -> returns: dictionary[string : number/float]** --Gathers the current animation times from the server and sends them to the client along with whether the ride is active.
  
  
+ **function runRide(ride: ClassRides[string])** --handles updating ride animations times and Ride.riders. This function is called on its own thread.
  
+ **event_RideStart(rideName: String)** --Remote event function. signals clients to run ride animation this function signals the clients to start their ride animations. This function also handles updating the countdown time for the ride. Triggered by client.
  
+ **event_manageRider(player: object[Player], character: object[Model], rideName: String)** --Remote event function that Manages who is current on each ride NOTE: This only keeps track of players who got on the ride before its animation started. Triggered by client.

# Client-Side Documentation: Client_Flat_Ride
### Notes
This script handles the actual animations and tweening of rides. 
It gets the time positions of all running rides and what rides should or shouldn't be running 
directly from the server. The server handles no ride animations or tweening, this does that.

### Configurable Variables:
+ local START_TIMER: int --Start-timer in seconds, this should match the same variable on the server-side code.
  
+ local MODULE_ONLY: array(string) --List here the names of rides that run solely using Cframe or any other type of animation that is not a standard animation.
  
+ local hidePlayer: array(string) --List here the names of rides where the players' entire body should be hidden while they are on it.
  
+ local TASK_FIRST_TWEEN: array(string) --List the names of rides that have tween animation that will run at the beginning of its standard animation.
  
+ local TASK_FINAL_TWEEN: array (string) --List the names of rides that have tween animation that will run at the end of its standard animation.

### Other Variables
+ local rideThreads: array(coroutine) --holds existing coroutine/threads. Do not touch.

### Classes
+ local rideAnimations: dictionary[string : object] --Holds class instances: See class properties below.
  
  + .animTrack: object[AnimationTrack] --the ride's animation after it has been loaded by the animator.

### Functions
+ **function onSeated(isSeated: Bool, seat: object[Seat])** --Fires when the player sits in a flat ride. This will signal the server to start the ride's animation for this player and all other clients.
  
+ **function runRideTweens(rideName: String, rideAnimation: object[AnimationTrack], originalHeight: number/float)** --This function handles scheduling the rides beginning and ending tweens and also any tasks that have been assigned to the ride.\
  
+ **function startRide(rideName: String)** --This function starts the ride's animation and is called when rides are started normally by the player. Note: This function is not called when resyncing.
  
+ **function stopRides(rideName: String)** --Stop rides: Halts all rides from running for this client. Rides will appear as if they haven't been started.

+  **function syncRides()** --Synces all rides back with the server so that what this client sees is consistent with what other clients see in the game.
  + + BEHAVIOR: Rides with final animation tweens already running will be placed in a finished/not started state (no animation run). All rides first animation tween is skipped and the ride will placed at its goal. The final tween will play if applicable. Note: coroutines for rides being synced are created here.

+  **function createRideThread(rideName: String)** --This function creates coroutines for each ride when they start.

### Contact:
**If you have questions or issues or want to report a bug please email: ThemeParkProjectGame@Gmail.com**
