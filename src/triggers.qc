/*  Copyright (C) 1996-2022 id Software LLC

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    See file, 'COPYING', for details.
*/


// entity stemp, otemp, s, old;
// Yoder Sept 24 2021 Horde merge
float COUNTER_LOOPS = 2; // so counters can loop back to the start again
float MONSTER_ONLY = 8; // for trigger_hurt


void() trigger_reactivate =
{
	self.solid = SOLID_TRIGGER;
};

//=============================================================================

float	SPAWNFLAG_NOMESSAGE = 1;
float	SPAWNFLAG_NOTOUCH = 1;

// the wait time has passed, so set back up for another activation
void() multi_wait =
{
	if (self.max_health)
	{
		self.health = self.max_health;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
	}
};


// The trigger was just touched/killed/used
// self.enemy should be set to the activator so it can be held through a delay
// so wait for the delay time before firing
void() multi_trigger =
{
	if (self.nextthink > time) return; // Already been triggered

	if (self.classname == "trigger_secret")
	{
		if (self.enemy.classname != "player") return;
		
		found_secrets += 1;
		WriteByte (MSG_ALL, SVC_FOUNDSECRET);	
		msg_entity = self.enemy;
	}

	if (self.enemy.classname == "player" && world.model == "maps/hip3m1.bsp" && self.message == "YOU'RE NOT SUPPOSE TO BE HERE!") msg_entity = self.enemy;
	if (self.noise) sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

	// Don't trigger again until reset
	self.takedamage = DAMAGE_NO;
	activator = self.enemy;
	SUB_UseTargets ();

	if (self.wait > 0)
	{
		self.think = multi_wait;
		self.nextthink = time + self.wait;
	}
	else
	{	// We can't just remove (self) here, because this is a touch function
		// called wheil C code is looping through area links...
		self.touch = SUB_Null;
		self.nextthink = time + 0.1;
		self.think = SUB_Remove;
	}
	// MED 12/01/96 added cnt stuff
	if (self.cnt > 0)
	{
		self.cnt -= 1;
		if (self.cnt == 0)
		{
			self.touch = SUB_Null;
			self.nextthink = time + 0.1;
			self.think = SUB_Remove;
		}
	}
};

void() multi_killed =
{
	self.enemy = damage_attacker;
	multi_trigger ();
};

void() multi_use =
{
	self.enemy = activator;
	multi_trigger ();
};

void() multi_touch =
{
	if (other.classname != "player") return;

	// If the trigger has an angles field, check player's facing direction
	if (self.movedir != '0 0 0')
	{
		makevectors (other.angles);
		if (v_forward * self.movedir < 0) return; // Not facing the right way
	}

	self.enemy = other;
	multi_trigger ();
};

//MED 12/01/96 added count field
/*QUAKED trigger_multiple (.5 .5 .5) ? notouch
Variable sized repeatable trigger.  Must be targeted at one or more entities.  If "health" is set, the trigger must be killed to activate each time.
If "delay" is set, the trigger waits some time after activating before firing.
"wait" : Seconds between triggerings. (.2 default)
"cnt" how many times it can be triggered (infinite default)
If notouch is set, the trigger is only fired by other entities, not by touching.
NOTOUCH has been obsoleted by trigger_relay!
sounds
1)	secret
2)	beep beep
3)	large switch
4)
set "message" to text string
*/
void() trigger_multiple =
{
	if (self.sounds == 1)
	{
		precache_sound ("misc/secret.wav");
		self.noise = "misc/secret.wav";
	}
	else if (self.sounds == 2)
	{
		precache_sound ("misc/talk.wav");
		self.noise = "misc/talk.wav";
	}
	else if (self.sounds == 3)
	{
		precache_sound ("misc/trigger1.wav");
		self.noise = "misc/trigger1.wav";
	}
	
	// MG1 ------------------------------------------
	self.sounds = 0;
	if (self.spawnflags & SPAWNFLAG_TRIGGER_FIRST)
	{
		self.use = trigger_multiple;
		self.spawnflags &~= SPAWNFLAG_TRIGGER_FIRST;
		return;
	}
	// ----------------------------------------------	

	if (!self.wait) self.wait = 0.2;
	self.use = multi_use;

	InitTrigger ();

	if (self.health)
	{
		if (self.spawnflags & SPAWNFLAG_NOTOUCH) objerror ("health and notouch don't make sense\n");
		
		self.max_health = self.health;
		self.th_die = multi_killed;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
		setorigin (self, self.origin);	// make sure it links into the world
	}
	else
	{
		if (!(self.spawnflags & SPAWNFLAG_NOTOUCH)) self.touch = multi_touch;
	}
	
	//MED 12/01/96 added cnt stuff
	if (self.cnt == 0) self.cnt = -1;		
};


/*QUAKED trigger_once (.5 .5 .5) ? notouch
Variable sized trigger. Triggers once, then removes itself.  You must set the key "target" to the name of another object in the level that has a matching
"targetname".  If "health" is set, the trigger must be killed to activate.
If notouch is set, the trigger is only fired by other entities, not by touching.
if "killtarget" is set, any objects that have a matching "target" will be removed when the trigger is fired.
if "angle" is set, the trigger will only fire when someone is facing the direction of the angle.  Use "360" for an angle of 0.
sounds
1)	secret
2)	beep beep
3)	large switch
4)
set "message" to text string
*/
void() trigger_once =
{
	self.wait = -1;
	trigger_multiple();
};

//=============================================================================

/*QUAKED trigger_relay (.5 .5 .5) (-8 -8 -8) (8 8 8)
This fixed size trigger cannot be touched, it can only be fired by other events.  It can contain killtargets, targets, delays, and messages.
*/
void() trigger_relay =
{
	INHIBIT_COOP						// MG1
	if (RemovedOutsideCoop()) return;
	
	self.use = SUB_UseTargets;
};


//=============================================================================

/*QUAKED trigger_secret (.5 .5 .5) ?
secret counter trigger
sounds
1)	secret
2)	beep beep
3)
4)
set "message" to text string
*/
void() trigger_secret =
{
	INHIBIT_COOP // MG1
	total_secrets += 1;
	self.wait = -1;
		
	if (!self.message) self.message = "You found a secret area!";	
	if (!self.sounds) self.sounds = 1;
	if (self.sounds == 1)
	{
		precache_sound ("misc/secret.wav");
		self.noise = "misc/secret.wav";
	}
	else if (self.sounds == 2)
	{
		precache_sound ("misc/talk.wav");
		self.noise = "misc/talk.wav";
	}	
		
	trigger_multiple ();	
};

//=============================================================================


void() counter_use =
{
	self.count -= 1;
	if (self.count < 0) return;

	if (self.count != 0)
	{
		if (activator.classname == "player" && (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0)
		{
			if (self.count >= 4) id1_centerprint (activator, "There are more to go...");
			else if (self.count == 3) id1_centerprint (activator, "Only 3 more to go...");
			else if (self.count == 2) id1_centerprint (activator, "Only 2 more to go...");
			else id1_centerprint (activator, "Only 1 more to go...");
		}
		return;
	}

	if (activator.classname == "player" && (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0) id1_centerprint (activator, "Sequence completed!");

	self.enemy = activator;
	multi_trigger ();
};

/*QUAKED trigger_counter (.5 .5 .5) ? nomessage
Acts as an intermediary for an action that takes multiple inputs.

If nomessage is not set, t will print "1 more.. " etc when triggered and "sequence complete" when finished.

After the counter has been triggered "count" times (default 2), it will fire all of it's targets and remove itself.
*/
void() trigger_counter =
{
	INHIBIT_COOP						// MG1
	if (RemovedOutsideCoop()) return;
	
	// self.wait = -1;

	if (!self.count) self.count = 2;

	// MG1: Yoder Sept24, 2021 Horde Merge
	// .count is decremented each use and fires its targets on 0
	// .wait stores the original .count and restores to this if COUNTER_LOOPS	
	if (!self.wait) self.wait = self.count;

	self.use = counter_use;
};

void() counter_timed_think = {self.count = self.cnt;};

void() counter_timed_use =
{
	self.count = self.count - 1;
	if (self.count < 0) return;
	
	self.nextthink = time + self.delay;

	if (self.count != 0)
	{
		if (activator.classname == "player" && (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0)
		{
			if (self.count >= 4) centerprint_all (other, "There are more to go...\n", "There are more to go...\n");
			else if (self.count == 3) centerprint_all (other, "Only 3 more to go...\n", "Only 3 more to go...\n");
			else if (self.count == 2) centerprint_all (other, "Only 2 more to go...\n", "Only 2 more to go...\n");
			else centerprint_all (other, "Only 1 more to go...\n", "Only 1 more to go...\n");
		}
		return;
	}
	
	if (activator.classname == "player" && (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0) centerprint_all(other, "Sequence Completed!\n", "Sequence Completed!\n");
	
	self.enemy = activator;
	self.delay = 0;
	self.nextthink = -1;
	self.think = SUB_Null;
	multi_trigger ();
	remove(self);
};

/*QUAKED trigger_counter_timed (.5 .5 .5) ? nomessage message_all
Acts as an intermediary for an action that takes multiple inputs.

If nomessage is not set, t will print "1 more.. " etc when triggered and "sequence complete" when finished.

After the counter has been triggered "count" times (default 2), it will fire all of it's targets and remove itself.
*/
void() trigger_counter_timed =
{
	INHIBIT_COOP
	if (RemovedOutsideCoop()) return;

	self.wait = -1;
	if (!self.count) self.count = 2;

	if (!self.delay) self.delay = 2;
	
	self.cnt = self.count;
	self.use = counter_timed_use;
	self.think = counter_timed_think;
};

/*
==============================================================================

TELEPORT TRIGGERS

==============================================================================
*/

float	PLAYER_ONLY	= 1;
float	SILENT = 2;
float	IGNORE_TARGETNAME = 4;

void() play_teleport =
{
	local string tmpstr;
	local float v = random() * 5;
	
	if (v < 1) tmpstr = "misc/r_tele1.wav";
	else if (v < 2) tmpstr = "misc/r_tele2.wav";
	else if (v < 3) tmpstr = "misc/r_tele3.wav";
	else if (v < 4) tmpstr = "misc/r_tele4.wav";
	else tmpstr = "misc/r_tele5.wav";

	sound (self, CHAN_VOICE, tmpstr, 1, ATTN_NORM);
	remove (self);
};

void(vector org) spawn_tfog =
{
	local entity s = spawn ();
	
	s.origin = org;
	s.nextthink = time + 0.2;
	s.think = play_teleport;

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
};

void(vector org) spawn_tfog_silent =
{
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
};

void() tdeath_touch =
{
	if (other == self.owner) return;

	// Frag anyone who teleports in on top of an invincible player
	if (other.classname == "player")
	{
		if (cvar("player_collision") == FALSE && cvar("coop") && self.owner.classname == "player") return; // Sleeper: Don't when player collision is off.
	
		// QIP Pentagram telefrag fix Zoid/Maddes
		if (self.owner.classname != "player")
		{	
			// Other monsters explode themselves
			T_Damage (self.owner, self, self, 50000);
			return;
		}

		if (other.invincible_finished > time) // QIP Pentagram telefrag fix Zoid/Maddes start
		{	
			// Player on spot has active pentagram
			if (self.owner.invincible_finished > time)
			{	
				// teleported player has active pentagram too can happen often in deathmatch 4 and levels with more than one pentagram
				self.classname = "teledeath3";
				other.invincible_finished = 0;
				T_Damage (other, self, self, 50000);	// Kill player on spot
				sound (self.owner, CHAN_VOICE, "items/protect3.wav", 1, ATTN_NORM);
				/* QIP telefrag player on spot by Maddes */
			}
			else
			{	
				// QIP only telefrag player on spot by Maddes
				// QIP end
				self.classname = "teledeath2";

				// QIP Pentagram telefrag fix
				T_Damage (self.owner, self, self, 50000);
				sound (other, CHAN_VOICE, "items/protect3.wav", 1, ATTN_NORM);
			}
			return;
		}						
	}

	if (other.health) T_Damage (other, self, self, 50000);
};

// Yoder sept24 2021 horde merge
// a faster version of tdeath to minimize telefragging 
void(vector org, entity death_owner) spawn_tdeath_fast =
{
	local entity death = spawn();
	
	death.classname = "teledeath";
	death.movetype = MOVETYPE_NONE;
	death.solid = SOLID_TRIGGER;
	death.angles = '0 0 0';
	setsize (death, death_owner.mins - '1 1 1', death_owner.maxs + '1 1 1');
	setorigin (death, org);
	death.touch = tdeath_touch;
	death.nextthink = time + 0.01;
	death.think = SUB_Remove;
	death.owner = death_owner;	
	force_retouch = 2;		// make sure even still objects get hit
};

void(vector org, entity death_owner) spawn_tdeath =
{
	local entity death = spawn();
	
	death.classname = "teledeath";
	death.movetype = MOVETYPE_NONE;
	death.solid = SOLID_TRIGGER;
	death.angles = '0 0 0';
	setsize (death, death_owner.mins - '1 1 1', death_owner.maxs + '1 1 1');
	setorigin (death, org);
	death.touch = tdeath_touch;
	death.nextthink = time + 0.2;
	death.think = SUB_Remove;
	death.owner = death_owner;
	force_retouch = 2;		// make sure even still objects get hit
};

void() teleport_touch =
{
	local entity t;
	local vector org;

/*
	if (self.targetname)
	{
		if (self.nextthink < time) return; // Not fired yet
	}
*/
	if (self.targetname != string_null && (self.spawnflags & IGNORE_TARGETNAME) == 0) // MG1
	{
		if (self.nextthink < time) return;		// not fired yet
	}

	if (self.spawnflags & PLAYER_ONLY)
	{
		if (other.classname != "player") return;
	}

// only teleport living creatures
	if (other.health <= 0 || other.solid != SOLID_SLIDEBOX) return;

	SUB_UseTargets ();

// put a tfog where the player was
	spawn_tfog (other.origin);

	t = find (world, targetname, self.target);
	if (!t) objerror ("couldn't find target");

// spawn a tfog flash in front of the destination
	makevectors (t.mangle);
	org = t.origin + 32 * v_forward;

	spawn_tfog (org);
	spawn_tdeath(t.origin, other);

// move the player and lock him down for a little while
	if (!other.health)
	{
		other.origin = t.origin;
		other.velocity = (v_forward * other.velocity_x) + (v_forward * other.velocity_y);
		return;
	}

	setorigin (other, t.origin);
	other.angles = t.mangle;
	if (other.classname == "player")
	{
		other.fixangle = 1;		// turn this way immediately
		other.teleport_time = time + 0.7;
		
		if (other.flags & FL_ONGROUND) other.flags -= FL_ONGROUND;
		// Sleeper: Even though trenchbroom shows the teleport destination to access the pentagram secret is pointing down in HIP3M1,
		// it would throw you away from getting the pentagram from that secret area. 
		// This is a quick and dirty fix to keep things aligned with vanilla, because I don't want to break anything else in trenchbroom.
		if (world.model == "maps/hip3m1.bsp") other.velocity = 0;
		else other.velocity = v_forward * 300;
		// MG1 ---------------------------------
		if(!coop && !deathmatch) FogPushSettingsFrom(other, t, 0);
		// -------------------------------------	
	}
	other.flags -= other.flags & (FL_ONGROUND);
};

/*QUAKED info_teleport_destination (.5 .5 .5) (-8 -8 -8) (8 8 32)
This is the destination marker for a teleporter.  It should have a "targetname" field with the same value as a teleporter's "target" field.
*/
void() info_teleport_destination =
{
// this does nothing, just serves as a target spot
	self.netname = "info_teleport_destination"; // for bot nav support.
	self.mangle = self.angles;
	self.angles = '0 0 0';
	self.model = "";
	self.origin += '0 0 27';
	
	if (!self.targetname) objerror ("no targetname");
};

void() teleport_use =
{
	self.nextthink = time + 0.2;
	force_retouch = 2;		// make sure even still objects get hit
	self.think = SUB_Null;
};

/*QUAKED trigger_teleport (.5 .5 .5) ? PLAYER_ONLY SILENT
Any object touching this will be transported to the corresponding info_teleport_destination entity. You must set the "target" field, and create an object with a "targetname" field that matches.

If the trigger_teleport has a targetname, it will only teleport entities when it has been fired.
*/
void() trigger_teleport =
{
	local vector o;

	InitTrigger ();
	self.touch = teleport_touch;
	
	// Find the destination
	if (!self.target) objerror ("no target");
	self.use = teleport_use;

	if (!(self.spawnflags & SILENT))
	{
		precache_sound ("ambience/hum1.wav");
		o = (self.mins + self.maxs) * 0.5;
		ambientsound (o, "ambience/hum1.wav", 0.5, ATTN_STATIC);
	}
};

/*
==============================================================================

trigger_setskill

==============================================================================
*/
.float skill_message_timer;
void() trigger_skill_touch =
{
	if (other.classname != "player") return;
	
	// Sleeper: Use KEX Nightmare! skill as skill 3 instead of Classic Nightmare in the MG1 Game World.
	if (mapname == "mgstart" && self.message == "3")
	{	
		if (cvar("skill") != 5)
		{
			self.message = "4";
			cvar_set ("skill", self.message);
		}	
	}
	else if (mapname == "mgstart" && self.message == "2") cvar_set ("skill", "2");
	else if (mapname == "mgstart" && self.message == "1") cvar_set ("skill", "1");
	else if (mapname == "mgstart" && self.message == "0") cvar_set ("skill", "0");
	else
	{		
		if (cvar("skill") <= 3) cvar_set ("skill", self.message);
	}

	if (cvar("coop") == 1)
	{
		local entity all_players = find (world, classname, "player"); 	
		while (all_players)
		{
			if (all_players != other)
			{		
				if (all_players.skill_message_timer < time)
				{
					if (cvar("skill") == 0) id1_centerprint (all_players, other.netname, " selected Easy Skill.\n");
					if (cvar("skill") == 1) id1_centerprint (all_players, other.netname, " selected Normal Skill.\n");
					if (cvar("skill") == 2) id1_centerprint (all_players, other.netname, " selected Hard Skill.\n");	
					if (cvar("skill") == 3) id1_centerprint (all_players, other.netname, " selected\n Classic Nightmare! Skill.\n");	
					if (cvar("skill") == 4) id1_centerprint (all_players, other.netname, " selected\n KEX Nightmare! Skill.\n");
					if (cvar("skill") == 5) id1_centerprint (all_players, other.netname, " selected\n Sleeper Must Die! Skill.\n");	
					sound (all_players, CHAN_BODY, "misc/talk.wav", 1, ATTN_NORM);		
					all_players.skill_message_timer = time + 2;																								
				}				
			}	
			///////////////////////////////////////////////////////////
			if (cvar("skill") == 0) stuffcmd (all_players, "skill 0\n"); // If a client touches the trigger,
			if (cvar("skill") == 1) stuffcmd (all_players, "skill 1\n"); // the client's skill level will also
			if (cvar("skill") == 2)	stuffcmd (all_players, "skill 2\n"); // change depending on what the server	
			if (cvar("skill") == 3)	stuffcmd (all_players, "skill 3\n"); // skill is setting to. Useful to know	
			if (cvar("skill") == 4)	stuffcmd (all_players, "skill 4\n"); // to check the difficulty on the fly	
			if (cvar("skill") == 5) stuffcmd (all_players, "skill 5\n"); // without having to check the MOTD text.						
			///////////////////////////////////////////////////////////
			all_players = find(all_players, classname, "player");
		}
	}
};

/*QUAKED trigger_setskill (.5 .5 .5) ?
sets skill level to the value of "message".
Only used on start map.
*/
void() trigger_setskill =
{
	InitTrigger ();
	self.touch = trigger_skill_touch;
};


/*
==============================================================================

ONLY REGISTERED TRIGGERS

==============================================================================
*/

void() trigger_onlyregistered_touch =
{
	if (other.classname != "player") return;
	if (self.attack_finished > time) return;

	self.attack_finished = time + 2;
	if (cvar("registered"))
	{
		self.message = "";
		SUB_UseTargets ();
		remove (self);
	}
	else
	{
		if (self.message != "")
		{
			id1_centerprint (other, self.message);
			sound (other, CHAN_BODY, "misc/talk.wav", 1, ATTN_NORM);
		}
	}
};

/*QUAKED trigger_onlyregistered (.5 .5 .5) ?
Only fires if playing the registered version, otherwise prints the message
*/
void() trigger_onlyregistered =
{
	precache_sound ("misc/talk.wav");
	InitTrigger ();
	self.touch = trigger_onlyregistered_touch;
};

//============================================================================

//JIM
void(entity ent, float amount) hurt_setdamage =
{
	ent.dmg = amount;
	
	if (!amount) ent.solid = SOLID_NOT;
	else ent.solid = SOLID_TRIGGER;
	
	ent.nextthink = -1;
};
   
void() hurt_use = {self.state = 1 - self.state;}; // MG1

void() hurt_on =
{
	self.solid = SOLID_TRIGGER;
	self.nextthink = -1;
};

void() hurt_touch =
{
	if (other.takedamage)
	{
		if (gameworld == APOTHEOSIS && other.flags & FL_MONSTER) return;
		
		// MG1: Yoder Sept24 2021 Horde merge
		// allows for monster-only hurt volumes
		if ((self.spawnflags & MONSTER_ONLY) && !(other.flags & FL_MONSTER)) return;
				
		self.solid = SOLID_NOT;
		T_Damage (other, self, self, self.dmg);
		self.think = hurt_on;
		self.nextthink = time + 1;
		//MED 12/01/96 added count stuff
		if (self.cnt > 0)
		{
			self.cnt -= 1;
			if (self.cnt == 0)
			{
				self.touch = SUB_Null;
				self.nextthink = time + 0.1;
				self.think = SUB_Remove;
			}
		}
	}
	
	return;
};

//MED 12/01/96 added count field
/*QUAKED trigger_hurt (.5 .5 .5) ?
Any object touching this will be hurt
set dmg to damage amount
defalt dmg = 5
"cnt" default infinite, how many times to trigger
*/
void() trigger_hurt =
{
	self.netname = "trigger_hurt"; // for bot nav support.
	if (world.model == "maps/end.bsp") return;
	
	InitTrigger ();
	self.touch = hurt_touch;
	if (!self.dmg) self.dmg = 5;
	// HIPNOTIC: MED 12/01/96 added count stuff
	if (self.cnt == 0) self.cnt = -1;
	
	// MG1 --------------------------
	if (!self.wait) self.wait = 1;
	if (self.spawnflags & START_OFF) self.state = 1;
	self.use = hurt_use;
	// ------------------------------	
};

//============================================================================

float PUSH_ONCE = 1;
float ADDITIVE_PUSH = 2; // MG1
float PUSH_START_OFF = 4; // MG1

void() trigger_push_touch =
{
	// MG1 =================================================================
	// yoder Sept 24 2021 horde merge	
	if (horde_ent)
	{
		if (other.spawnflags & PUSH_START_OFF) other.spawnflags -= PUSH_START_OFF; // ignore this spawnflag in horde mode
		
		if ((other.classname != "player"))
		{
			if ((other.classname == "item_artifact_invulnerability") || (other.classname == "item_artifact_super_damage"))
			{
				if (self.spawnflags & ADDITIVE_PUSH) other.velocity += (self.speed * self.movedir * 10 * frametime); 
				else other.velocity = self.speed * self.movedir * 10;
			}
			return;
		}
	}

	if (other.health > 0 || other.classname == "grenade")
	{
		if (other.flags & FL_INSHELTER) return;

		if (self.spawnflags & ADDITIVE_PUSH) other.velocity += self.speed * self.movedir * 10 * frametime; // yoder add, Jan 28 2021
		else other.velocity = self.speed * self.movedir * 10;
		if (other.classname == "player")
		{
			if (other.fly_sound < time)
			{
				other.fly_sound = time + 1.5;
				sound (other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
			}
		}
		if (other.flags & FL_MONSTER) other.flags (-) FL_ONGROUND; // If a monster walks inside a trigger_push, make it fly
	}
	// =======================================================================
	/*
	if (other.classname == "grenade") other.velocity = self.speed * self.movedir * 10;
	else if (other.health > 0)
	{
		other.velocity = self.speed * self.movedir * 10;
		if (other.classname == "player")
		{
			if (other.fly_sound < time)
			{
				other.fly_sound = time + 1.5;
				sound (other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
			}
		}
	}
	*/
	if (self.spawnflags & PUSH_ONCE) remove(self);
};

// MG1 ============================================
void() trigger_push_use =
{
	if(self.solid == SOLID_TRIGGER)
	{
		dprint("trigger_push: switched off\n");
		self.solid = SOLID_NOT;
	}
	else
	{
		dprint("trigger_push: switched on\n");
		self.solid = SOLID_TRIGGER;
		force_retouch = 1;
	}
}
// ==================================================

/*QUAKED trigger_push (.5 .5 .5) ? PUSH_ONCE
Pushes the player
*/
void() trigger_push =
{
	InitTrigger ();
	precache_sound ("ambience/windfly.wav");
	self.touch = trigger_push_touch;
	
	self.use = trigger_push_use; // MG1
	if (self.spawnflags & PUSH_START_OFF) self.solid = SOLID_NOT; // MG1	
	
	if (!self.speed) self.speed = 1000;
};

const float SHELTER_FLIPPED = 1;

void() trigger_shelter_portal_touch =
{
	if (other.health > 0 || other.classname == "grenade")
	{
		local vector offs = other.origin - self.pos1;
		local float dot = offs * self.pos2;
		
		if (dot >= 0) other.flags (+) FL_INSHELTER;
		else other.flags (-) FL_INSHELTER;
	}
}

/*QUAKED trigger_shelter (.5 .5 .5) 
Shelters the player from pushes
*/
void() trigger_shelter_portal =
{
	InitTrigger ();
	self.touch = trigger_shelter_portal_touch;
	self.pos1 = self.mins + (self.size * 0.5);
	
	if (self.size_x < self.size_y)
	{
		if (self.size_x < self.size_z) self.pos2 = '1 0 0';
		else self.pos2 = '0 0 1';
	}
	else
	{
		if (self.size_y < self.size_z) self.pos2 = '0 1 0';
		else self.pos2 = '0 0 1';
	}

	if (self.spawnflags & SHELTER_FLIPPED) self.pos2 *= -1;
};

//============================================================================

void() trigger_monsterjump_touch =
{
	if (other.flags & (FL_MONSTER | FL_FLY | FL_SWIM) != FL_MONSTER) return;
		
	// MG1: yoder add, July 10th 2020
	// making it so trigger_monsterjump's with spawnflag 8 only affect mosnters with spawnflag 8
	if (self.spawnflags & 64)
	{
		if (!(other.spawnflags & 64))
		{
			dprint ("monster didn't have spawnflag 8!\n");
			return;
		}
	}		

	// set XY even if not on ground, so the jump will clear lips
	other.velocity_x = self.movedir_x * self.speed;
	other.velocity_y = self.movedir_y * self.speed;

	if (!(other.flags & FL_ONGROUND)) return;

	other.flags -= FL_ONGROUND;

	other.velocity_z = self.height;
	//MED 12/01/96 added count stuff
	if (self.cnt > 0)
	{
		self.cnt -= 1;
		if (self.cnt == 0)
		{
			self.touch = SUB_Null;
			self.nextthink = time + 0.1;
			self.think = SUB_Remove;
		}
	}
};

//MED 12/01/96 added count field
/*QUAKED trigger_monsterjump (.5 .5 .5) ?
Walking monsters that touch this will jump in the direction of the trigger's angle
"speed" default to 200, the speed thrown forward
"height" default to 200, the speed thrown upwards
"cnt" default infinite, how many times to trigger
*/
void() trigger_monsterjump =
{
	if (!self.speed) self.speed = 200;
	if (!self.height) self.height = 200;
	if (self.angles == '0 0 0') self.angles = '0 360 0';
	// MED 12/01/96 added count stuff
	if (self.cnt == 0) self.cnt = -1;
	
	InitTrigger ();
	self.touch = trigger_monsterjump_touch;
};

// MG1 START ============================================================================
const float NO_DAMAGE = 1;
void() trigger_explosion_activate =
{
	self.delay = 0;
	SUB_UseTargets ();
	
//	if (!(self.spawnflags & NO_DAMAGE)) T_RadiusDamage (self, self.owner, 120, self);
	if (!(self.spawnflags & NO_DAMAGE)) T_RadiusDamage (self, self.owner, 120, self, "");
		
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	
	BecomeExplosion();
}

void() trigger_explosion_use =
{
	if (self.delay > 0)
	{
		self.think = trigger_explosion_activate;
		self.nextthink = time + self.delay;
	}
	else trigger_explosion_activate ();
}

void() trigEx_die;

void() trigger_explosion =
{
	INHIBIT_COOP
	if (RemovedOutsideCoop()) return;

	if (self.targetname != string_null)
	{
		self.use = trigger_explosion_use;
		return;
	}
	// ROGUE ----------------------------------------------------------
	// apparently DoE also has a trigger_explosion. Hopefully this works!
	InitTrigger ();

	if (!self.health) self.health = 20;
	
	self.max_health = self.health;
	self.th_die = trigEx_die;
	self.takedamage = DAMAGE_YES;
	self.solid = SOLID_BBOX;
	setorigin (self, self.origin);	// make sure it links into the world
	// -----------------------------------------------------------------
};

// ======================================================
float REPEATER_ON = 1;
void() repeater_think =
{
	SUB_UseTargets();
	self.nextthink = time + self.wait + (self.pausetime * random());
};

void() repeater_use =
{
	if (self.spawnflags & REPEATER_ON)
	{
		// turn off
		self.spawnflags = self.spawnflags - REPEATER_ON;
		self.nextthink = 0;
		self.think = SUB_Null;
	}
	else
	{
		// turn on
		self.spawnflags = self.spawnflags + REPEATER_ON;
		self.nextthink = time + self.wait + (self.pausetime * random());
		self.think = repeater_think;
	}
};

void() trigger_repeater =
{
	INHIBIT_COOP
	if (RemovedOutsideCoop()) return;

	if (!self.wait) self.wait = 1;
	
	self.use = repeater_use;
	if (self.spawnflags & REPEATER_ON)
	{
		self.nextthink = time + self.wait + (self.pausetime * random());
		self.think = repeater_think;
	}
	else
	{	
		self.nextthink = 0;
		self.think = SUB_Null;
	}
};

// ======================================================
/*QUAKED trigger_multitouch (.5 .5 .5) ?
A trigger that fires its targets on "first touch", "emptied" or both

YODER Feb08, 2022
*/
float IGNORE_FIRST_TOUCH = 16;
float IGNORE_EMPTIED = 32;

void() trigger_multitouch_think =
{
	bprint ("untouched\n"); 
	self.wait = 0;
	
	if (!(self.spawnflags & IGNORE_EMPTIED)) SUB_UseTargets();
};

void() trigger_multitouch_touch =
{
	if (other.classname != "player") return;
	if (other.health <= 0) return;
    
	if (self.wait == 0) // first touch?
	{
		self.wait = 1;
		bprint (" first touch\n");
		if (!(self.spawnflags & IGNORE_FIRST_TOUCH)) SUB_UseTargets();
	}
    
	// think
	self.think = trigger_multitouch_think;
	self.nextthink = time + 0.2;
};

void() trigger_multitouch =
{
	InitTrigger ();
	self.touch = trigger_multitouch_touch;
	self.wait = 0; // 0 is empty, 1 is touched
};

// MG1 END ===============================================================================
