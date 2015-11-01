# Robbery System
Robbery System for SA-MP servers.

##Introduction

This is a robbery script I discovered days ago on my old hard drive. I've modified a lot, including adding things like the chance of starting a robbery. The system is a simple one and you can also add many other banks if you'd like to!

##Requirements

This script requires [streamer](http://forum.sa-mp.com/showthread.php?t=102865) and [zcmd](http://forum.sa-mp.com/showthread.php?t=91354)

##Features

* 50 % chance of a successful robbery. (this can be changed)
* Banks cannot be robbed until a 5 minute timer is up after a successful robbery.
* Receive a random amount of cash if a robbery is successful between $10,000 and $200,000. This can be changed.

##Commands

This system only has one command which is: /robbank

##Defines
```
// ROBBERY SYSTEM DEFINES //

 #define ROB_BANK_TIMER_TIME 20000 // 20000 milliseconds (20 seconds). Amount of time it takes for a bank robbery.
 #define ROB_WAIT_TIMER_TIME 180000 // 180000 milliseconds (3 minutes). Amount of time a player has to wait to rob a bank again.

 #define BANK_ROB_MINIMUM_CASH 10000 // $10,000. The robbery's minimum cash the player receives if the robbery was successful.
 #define BANK_ROB_MAXIMUM_CASH 200000 // $200,000. The robbery's maximum cash the player receives if the robbery was successful.
```

##Bank Location

http://i.imgur.com/670K8zF.jpg

##Pictures

[imgur album](http://imgur.com/a/7FUyb)

##Suggestions

If you have any suggestions please let me know!

Enjoy :)!
