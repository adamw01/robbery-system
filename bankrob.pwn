#include <a_samp>
#include <zcmd>
#include <streamer>

// COLOR DEFINES //
#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_RED 0xFF0000FF
#define COLOR_BLUE 0x008CBAFF

// ROBBERY SYSTEM DEFINES //

#define ROB_BANK_TIMER_TIME 20000 // 20000 milliseconds (20 seconds). Amount of time it takes for a bank robbery.
#define ROB_WAIT_TIMER_TIME 180000 // 180000 milliseconds (3 minutes). Amount of time a player has to wait to rob a bank again.

#define BANK_ROB_MINIMUM_CASH 10000 // $10,000. The robbery's minimum cash the player receives if the robbery was successful.
#define BANK_ROB_MAXIMUM_CASH 200000 // $200,000. The robbery's maximum cash the player receives if the robbery was successful.

// FORWARDS //
forward robbanktimer(playerid);
forward robwaittimer();

// CHECKPOINTS //
new CP_EnterBank, CP_ExitBank, CP_RobBank;

// 3D TEXT LABELS //
new Text3D:Text_LSBank, Text3D:Text_LSBankTeller, Text3D:Text_LSBankExit;

// VARIABLES //
new robpossible; // Robbing possibility variable.

public OnFilterScriptInit()
{
    CP_EnterBank = CreateDynamicCP(1571.3135, -1336.6825, 16.4844, 1, -1, -1, -1, 200); // Creating a checkpoint to players can enter the bank.
    CP_ExitBank = CreateDynamicCP(2304.6804, -16.0492, 26.7422, 1, -1, -1, -1, 200); // Creating a checkpoint inside so players can leave the bank.
    CP_RobBank = CreateDynamicCP(2316.6201, -7.3241, 26.7422, 1, -1, -1, -1, 200); // Creating a checkpoint inside the bank.
    
    Text_LSBank = CreateDynamic3DTextLabel("Los Santos Bank", COLOR_WHITE, 1571.3135, -1336.6825, 16.4844, 150, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 200); // Creating a 3D Text Label.
    Text_LSBankExit = CreateDynamic3DTextLabel("Exit", COLOR_WHITE, 2304.6804, -16.0492, 26.7422, 150, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 200); // Creating a 3D Text Label.
    Text_LSBankTeller = CreateDynamic3DTextLabel("Bank Teller", COLOR_WHITE, 2316.6201, -7.3241, 26.7422, 150, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 200); // Creating a 3D Text Label.

	robpossible = 1; // Making players rob banks after the script loads.
	return 1;
}

public OnFilterScriptExit()
{
    DestroyDynamicCP(CP_EnterBank); // Destroying the checkpoint.
    DestroyDynamicCP(CP_ExitBank); // Destroying the checkpoint.
    DestroyDynamicCP(CP_RobBank); // Destroying the checkpoint.
    
    DestroyDynamic3DTextLabel(Text_LSBank); // Destroying the 3D Text Label.
    DestroyDynamic3DTextLabel(Text_LSBankExit); // Destroying the 3D Text Label.
    DestroyDynamic3DTextLabel(Text_LSBankTeller); // Destroying the 3D Text Label.
}

public OnPlayerSpawn(playerid)
{
    SetPlayerMapIcon(playerid, 1, 1571.3135, -1336.6825, 16.4844, 52, 0, MAPICON_GLOBAL); // Setting a map icon at the bank.
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if(checkpointid == CP_EnterBank) // Enter bank checkpoint. (Teleports inside bank)
	{
		SetPlayerPos(playerid, 2307.6389, -16.2159, 26.7496); // Setting the players position.
		SetPlayerFacingAngle(playerid, 270);
		RemovePlayerMapIcon(playerid, 1); // Removing map icon.
	}
    if(checkpointid == CP_ExitBank) // Exit bank checkpoint. (Teleports bank outside)
	{
		SetPlayerPos(playerid, 1576.3721, -1330.9656, 16.4844); // Setting players position.
		SetPlayerFacingAngle(playerid, 315.01);
		SetPlayerMapIcon(playerid, 1, 1571.3135, -1336.6825, 16.4844, 52, 0, MAPICON_GLOBAL); // Setting players map icon.
	}
	if(checkpointid == CP_RobBank) // Rob checkpoint.
	{
		SendClientMessage(playerid, COLOR_WHITE, "* Type {FFA500}/robbank {FFFFFF}to begin a Bank Robbery."); // Sending a message.
	}
	return 1;
}

//Command(s)
CMD:robbank(playerid, params[])
{
    new robchance = random(2); // 50 / 50% chance of a successful robbery. (Change to your liking!)
    
	if(robpossible == 1) // If the bank can be robbed.
	{
		if(robchance == 0)
		{
        	if(IsPlayerInDynamicCP(playerid, CP_RobBank)) // Player is in the checkpoint.
			{
		    	robpossible = 0;
		    	SetTimer("robwaittimer", ROB_WAIT_TIMER_TIME, false); // Running a timer so bank can not be robbed again until timer is up.

		    	SetTimer("robbanktimer", ROB_BANK_TIMER_TIME, false); // Running the main timer which gives the money and messages.
		    	
		    	ApplyAnimation(playerid, "SHOP", "ROB_Loop", 4.1, 0, 0, 0, 5000, 0); // Applying an animation.
		    	
		    	SetPlayerAttachedObject(playerid, 0, 1550, 1, 0.0840, -0.3049, 0.0369, 40.5000, 88.7000, -4.3999, 1.0000, 1.0000, 1.0000, 0, 0); // Setting an attached object.
                
		    	SendClientMessage(playerid, COLOR_BLUE, "* You have started a robbery."); // Sending a message.
            	SendClientMessage(playerid, COLOR_BLUE, "* You must stay in the checkpoint for 25 seconds or else the robbery will fail."); // Sending a message.
            	
            	new name[MAX_PLAYER_NAME], string[128];
				GetPlayerName(playerid, name, MAX_PLAYER_NAME);// Getting players name.

				format(string,sizeof(string),"* %s has started a bank robbery at the Los Santos Bank.", name);
				SendClientMessageToAll(COLOR_BLUE, string); // Sending the message to all players.
			}
	 		else // Player isn't in the checkpoint.
			{
	    		SendClientMessage(playerid, COLOR_RED, "You have to be in the checkpoint to begin a robbery!"); // Sending a message.
			}
		}
		else if(robchance == 1)
		{
			SendClientMessage(playerid, COLOR_RED, "* Your bank robbery attempt has failed. You must wait another 5 minutes to rob a bank again!"); // Sending a message.

            new name[MAX_PLAYER_NAME], string[128];
			GetPlayerName(playerid, name, MAX_PLAYER_NAME);// Getting players name.

			format(string,sizeof(string),"* %s has failed to rob the Los Santos Bank.", name);
			SendClientMessageToAll(COLOR_BLUE, string); // Sending the message to all players.
				
			robpossible = 0;
			SetTimer("robwaittimer", ROB_WAIT_TIMER_TIME, false); // Running a timer so bank can not be robbed again until timer is up.
		}
	}
	return 1;
}

// FUNCTIONS //

public robbanktimer(playerid)
{
	new string[128];
    new cash = RandomEx(BANK_ROB_MINIMUM_CASH, BANK_ROB_MAXIMUM_CASH);
	GivePlayerMoney(playerid, cash); // Give the player a random amount of $10,000 - $200,000. Change these settings on the top of the script!
	
	ClearAnimations(playerid); // Stopping the animation.
	
	for(new i=0; i<MAX_PLAYER_ATTACHED_OBJECTS; i++) // Loop.
 	{
  		if(IsPlayerAttachedObjectSlotUsed(playerid, i)) RemovePlayerAttachedObject(playerid, i); // Removing attached objects.
 	}

	format(string, sizeof(string), "* You have successfully robbed {33AA33}$%d {FFFFFF}from the bank!", cash);
	SendClientMessage(playerid, COLOR_WHITE, string); // Sending a message as a string.
}

public robwaittimer()
{
	robpossible = 1; // Robbing is now possible.
}

RandomEx(min, max)
{
    return random(max - min) + min;
}
