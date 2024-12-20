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

// Rogue Grapple Implementation
// Jan'97 by ZOID <zoid@threewave.com>
// Under contract to id software for Rogue Entertainment

// New entity fields
.entity hook; // this is my hook
.float on_hook; // we're on it
.float hook_out; // it's out
.float fire_hook; // Sleeper: For Off-Hand Grappling Hook.
.float offhand_hook_enabled; // Sleeper: A fake pickup.
// .float hook_finished;

// prototypes for WEAPONS.QC functions
float() crandom;
void(vector org, vector vel, float damage) SpawnBlood;

void(entity h, entity player) GrappleTrail =
{
	// Draw a line to the hook
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_BEAM);
	WriteEntity (MSG_BROADCAST, h);
	WriteCoord (MSG_BROADCAST, h.origin_x);
	WriteCoord (MSG_BROADCAST, h.origin_y);
	WriteCoord (MSG_BROADCAST, h.origin_z);
	WriteCoord (MSG_BROADCAST, player.origin_x);
	WriteCoord (MSG_BROADCAST, player.origin_y);
	WriteCoord (MSG_BROADCAST, player.origin_z + 5); // Sleeper: Default is 16.
};

void() OffHand_GrappleReset =
{	
	self.owner.on_hook = FALSE;
	self.owner.hook_out = FALSE;
	self.owner.fire_hook = FALSE;
//	self.owner.weaponframe = 0;
//	self.owner.attack_finished = time + 0.25;	
	remove (self);
};

void() OffHand_GrappleTrack =
{
	local vector spray;
	
	// Sleeper: Don't stick around on the walls for too long.
	if (self.enemy.solid == SOLID_BSP && cvar("offhand_hook_anchor_timeout") == TRUE) 
	{
		self.think = OffHand_GrappleReset;
		self.nextthink = time + offhand_hook_anchor_time; // Sleeper: 5 is default.
		return;
	}	
	
	// Sleeper: Don't spam hook at a teammates.
	if (self.enemy.classname == "player" && self.enemy.steam == self.owner.steam && self.enemy != self.owner)
	{
		OffHand_GrappleReset ();
		return;
	}	
	
	// Release dead targets
	if (self.enemy.classname == "player" && self.enemy.health <= 0) self.owner.on_hook = FALSE;
	
	// Drop the hook if owner is dead or has released the button
	if (!self.owner.on_hook || self.owner.health <= 0) 
	{
		OffHand_GrappleReset ();
		return;
	}

	if (self.enemy.classname == "player")
	{
		if (self.enemy.teleport_time > time)
		{
			OffHand_GrappleReset ();
			return;
		}
		
		// Move the hook along with the player.  It's invisible, but
		// we need this to make the sound come from the right spot
		setorigin (self, self.enemy.origin);
		
//		sound (self, CHAN_WEAPON, "blob/land1.wav", 1, ATTN_NORM);
		sound (self, CHAN_AUTO, "pendulum/hit.wav", 1, ATTN_NORM);
		T_Damage (self.enemy, self, self.owner, offhand_hook_enable_damage); // Sleeper: 5 is default.
		makevectors (self.v_angle);
		spray_x = 100 * crandom();
		spray_y = 100 * crandom();
		spray_z = 100 * crandom() + 50;
		SpawnBlood (self.origin, spray, 20);
	}
	
	if (self.enemy.solid == SOLID_SLIDEBOX) 
	{
		self.velocity = '0 0 0';
		setorigin (self, self.enemy.origin + self.enemy.mins + self.enemy.size * 0.5);
	} 
	else self.velocity = self.enemy.velocity;
	
	self.nextthink = time + 0.1;
};

/*
entity(float head) GrappleMakeLink =
{
	newmis = spawn ();

	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_NOT;
	newmis.owner = self; // SELF is the hook!

	newmis.avelocity = '200 200 200';

	setmodel (newmis, "progs/bit.mdl");
	setorigin (newmis, self.origin);
	setsize (newmis, '0 0 0' , '0 0 0');

	return  newmis;
};
*/

// Removes all chain link entities; this is a separate function because CLIENT 
// also needs to be able to remove the chain. Only one function required to
// remove all links.
/*
void() GrappleRemoveChain =
{
	self.think = SUB_Remove;
	self.nextthink = time;

	if (self.goalentity) 
	{
		self.goalentity.think = SUB_Remove;
		self.goalentity.nextthink = time;
		if (self.goalentity.goalentity) 
		{
			self.goalentity.goalentity.think = SUB_Remove;
			self.goalentity.goalentity.nextthink = time;
		}
	}
};
*/

// Repositions the chain links each frame. This single function maintains the 
// positions of all of the links. Only one link is thinking every frame. 
/*
void() GrappleUpdateChain =
{
	local vector temp;

	if (!self.owner.hook_out) 
	{
		GrappleRemoveChain();
		return;
	}

	temp = (self.owner.hook.origin - self.owner.origin);

	// These numbers are correct assuming 3 links.
	// 4 links would be *20 *40 *60 and *80
	setorigin (self, self.owner.origin + temp * 0.25);
	setorigin (self.goalentity, self.owner.origin + temp * 0.5);
	setorigin (self.goalentity.goalentity, self.owner.origin + temp * 0.75);
	self.nextthink = time + 0.1;
};
*/

//
// Build_Chain - Builds the chain (linked list)
//
/*
void() GrappleBuildChain =
{
	self.goalentity = GrappleMakeLink ();
	self.goalentity.think = GrappleUpdateChain;
	self.goalentity.nextthink = time + 0.1;
	self.goalentity.owner = self.owner;

	self.goalentity.goalentity = GrappleMakeLink();
	self.goalentity.goalentity.goalentity = GrappleMakeLink ();
};
*/

// Tries to anchor the grapple to whatever it touches
void() OffHand_GrappleAnchor =
{
	if (other == self.owner) return; // don't hook the guy that fired it
	
	if (pointcontents(self.origin) == CONTENT_SKY && !cvar("offhand_skyhook")) 
	{
		OffHand_GrappleReset ();
		return;
	}
	
	if (!cvar("offhand_hook_enable_damage") && other.classname == "player") 
	{
		OffHand_GrappleReset ();
		return;
	}	

	if (other.classname == "player" && other.steam == self.owner.steam && other != self.owner) 
	{
		// Glance off of teammates
		OffHand_GrappleReset ();		// PGM - fix drift after teammate hit  01/20/97
		return;
	} 
	else 
	{
		if (self.owner.fire_hook && other.classname != "player") sound (self, CHAN_AUTO, "player/axhit2.wav", 1, ATTN_NORM);

		// One point of damage inflicted upon impact. Subsequent
		// damage will only be done to PLAYERS... this way secret
		// doors and triggers will only be damaged once.
		// Sleeper: The initial damage doesn't work on monsters or players anymore, but should still work on anything else shootable.
		// So that the only damage monsters and players will ever take is the continuous one when the hook is attached to them.
		if (other.takedamage)
		{
			if ((!(other.flags & FL_CLIENT)) && (!(other.flags & FL_MONSTER))) T_Damage (other, self, self.owner, 5);
		}
		self.velocity = '0 0 0';
		self.avelocity = '0 0 0';
	}

//	self.frame = 2; // anchored	

	if (self.owner.fire_hook && other.classname != "player") sound (self.owner, CHAN_AUTO, "weapons/tink1.wav", 1, ATTN_NORM);

	if (!self.owner.fire_hook) 
	{
		OffHand_GrappleReset ();
		return;
	}

	self.owner.on_hook = TRUE;
	if (self.owner.flags & FL_ONGROUND) self.owner.flags -= FL_ONGROUND;

	// CHAIN2 is a looping sample. Use LEFTY as a flag so that client.qc
	// will know to only play the tink sound ONCE to clear the weapons
	// sound channel. (Lefty is a leftover from AI.QC, so I reused it to
	// avoid adding a field)
	self.owner.lefty = TRUE;
	self.enemy = other; // remember this guy!
	self.think = OffHand_GrappleTrack;
	self.nextthink = time;
	self.solid = SOLID_NOT;
	self.touch = SUB_Null;	
};

// void() player_grapple1;
void() OffHand_W_FireGrapple =
{
	if (self.hook_out) return; // reject subsequent calls from player.qc

	self.punchangle_x = -2; // bump him

	// chain out sound (loops)
	sound (self, CHAN_AUTO, "weapons/chain1.wav", 1, ATTN_NORM);

	newmis = spawn ();
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.owner = self; // newmis belongs to me
	self.hook = newmis;  // This is my newmis
	newmis.classname = "hook";

	makevectors (self.v_angle);
	newmis.velocity = v_forward * offhand_hook_speed; // Sleeper: 800 is default, based off Rogue.
//	newmis.avelocity = '0 0 -500';
	newmis.angles = vectoangles (v_forward);

	newmis.touch = OffHand_GrappleAnchor;
//	newmis.think = GrappleReset; // Sleeper: Remove maximum range for an auto release timer.
	
	// Grapple only lives for two seconds, this gives max range on it
//	newmis.nextthink = time + 2;
	newmis.frame = 1; // hook spread

//	setmodel (newmis, "progs/hook.mdl");
	setorigin (newmis, self.origin + v_forward * 16 + '0 0 16');
	setsize (newmis, '0 0 0' , '0 0 0 ');
	self.hook_out = TRUE;
};

// Called each frame by CLIENT.QC if client has hook_out
void() OffHand_GrappleService =
{
	if (!self.on_hook && self.fire_hook) 
	{
		// just draw a line to the hook
		if (vlen(self.hook.origin - self.origin) > 50) GrappleTrail (self.hook, self);
		return;
	}

	// drop the hook if player lets go of button
	if (!self.fire_hook || self.teleport_time > time) 
	{ 	
		// release when we get 'ported
		self = self.hook;
		OffHand_GrappleReset ();
		return;
	}	
	
	makevectors (self.angles);
	
	local vector dist = self.hook.origin - self.origin;
	local vector vel = self.hook.origin - (self.origin + (v_up * 16 * (!self.button2)) + (v_forward * 16));
	local float v = vlen (vel);

	if (v <= 100) vel = normalize (vel) * v * 10;  
	else vel = normalize (vel) * offhand_hook_pullspeed; // Sleeper: 1000 is default, based off Rogue.

	self.velocity = vel;

	if (vlen(dist) <= 50) 
	{	
		if (self.lefty) 
		{ 	
			// cancel chain sound
			// If there is a chain, ditch it now. We're
			// close enough. Having extra entities lying around
			// is never a good idea.
//			if (self.hook.goalentity) 
//			{ 
//				self.hook.goalentity.think = GrappleRemoveChain;
//				self.hook.goalentity.nextthink = time;
//			}

			self.lefty = FALSE; // we've reset the sound channel.
		}
	} 
	else GrappleTrail (self.hook, self);
};

void() GrappleReset =
{
	self.owner.on_hook = FALSE;
	self.owner.hook_out = FALSE;
	self.owner.weaponframe = 0;
	self.owner.attack_finished = time + 0.25;	
	remove (self);
};

void() GrappleTrack =
{
	local vector spray;
	
	if (self.enemy.solid == SOLID_BSP && cvar("grappling_hook_anchor_timeout") == TRUE) 
	{
		self.think = GrappleReset;
		self.nextthink = time + grappling_hook_anchor_time; // Sleeper: 5 is default.
		return;
	}		

	// Release dead targets
	if (self.enemy.classname == "player" && self.enemy.health <= 0) self.owner.on_hook = FALSE;

	// drop the hook if owner is dead or has released the button
	if (!self.owner.on_hook || self.owner.health <= 0) 
	{
		GrappleReset ();
		return;
	}	

	if (self.enemy.classname == "player")
	{
		if (self.enemy.teleport_time > time)
		{
			GrappleReset ();
			return;
		}
		
		// move the hook along with the player.  It's invisible, but
		// we need this to make the sound come from the right spot
		setorigin (self, self.enemy.origin);
		
//		sound (self, CHAN_WEAPON, "blob/land1.wav", 1, ATTN_NORM);
		sound (self, CHAN_WEAPON, "pendulum/hit.wav", 1, ATTN_NORM);
		T_Damage (self.enemy, self, self.owner, grappling_hook_damage); // Sleeper: Default is 5.
		makevectors (self.v_angle);
		spray_x = 100 * crandom();
		spray_y = 100 * crandom();
		spray_z = 100 * crandom() + 50;
		SpawnBlood(self.origin, spray, 20);
	}
	
	if (self.enemy.solid == SOLID_SLIDEBOX) 
	{
		self.velocity = '0 0 0';
		setorigin(self, self.enemy.origin + self.enemy.mins +
			self.enemy.size * 0.5);
	} 
	else self.velocity = self.enemy.velocity;

	self.nextthink = time + 0.1;
};

// Tries to anchor the grapple to whatever it touches
void() GrappleAnchor =
{
	if (other == self.owner) return; // don't hook the guy that fired it

	if (pointcontents(self.origin) == CONTENT_SKY && !cvar("grappling_skyhook")) 
	{
		GrappleReset ();
		return;
	}
	
	if (!cvar("grappling_hook_enable_damage") && other.classname == "player") 
	{
		GrappleReset ();
		return;
	}

	if (other.classname == "player") 
	{
		// glance off of teammates
		if (other.steam == self.owner.steam)
		{
			GrappleReset ();		// PGM - fix drift after teammate hit  01/20/97
			return;
		}

//		sound (self, CHAN_WEAPON, "player/axhit1.wav", 1, ATTN_NORM);
//		T_Damage (other, self, self.owner, 10);
	} 
	else 
	{
		if (other.classname != "player") sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);

		// One point of damage inflicted upon impact. Subsequent
		// damage will only be done to PLAYERS... this way secret
		// doors and triggers will only be damaged once.
		if (other.takedamage)
		{
			if ((!(other.flags & FL_CLIENT)) && (!(other.flags & FL_MONSTER))) T_Damage (other, self, self.owner, 5);
		}

		self.velocity = '0 0 0';
		self.avelocity = '0 0 0';
	}

	self.frame = 2; // anchored

	if (other.classname != "player") sound (self.owner, CHAN_WEAPON, "weapons/tink1.wav", 1, ATTN_NORM);

	if (!self.owner.button0) 
	{
		GrappleReset ();
		return;
	}

	self.owner.on_hook = TRUE;
	if (self.owner.flags & FL_ONGROUND) self.owner.flags -= FL_ONGROUND;

	// CHAIN2 is a looping sample. Use LEFTY as a flag so that client.qc
	// will know to only play the tink sound ONCE to clear the weapons
	// sound channel. (Lefty is a leftover from AI.QC, so I reused it to
	// avoid adding a field)
	self.owner.lefty = TRUE;
	self.enemy = other;// remember this guy!
	self.think = GrappleTrack;
	self.nextthink = time;
	self.solid = SOLID_NOT;
	self.touch = SUB_Null;
};

void() W_FireGrapple =
{
	if (self.hook_out) return; // reject subsequent calls from player.qc

	self.punchangle_x = -2; // bump him

	// chain out sound (loops)
	sound (self, CHAN_WEAPON, "weapons/chain1.wav", 1, ATTN_NORM);

	newmis = spawn();
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.owner = self;		// newmis belongs to me
	self.hook = newmis;			// This is my newmis
	newmis.classname = "hook";

	makevectors (self.v_angle);
	newmis.velocity = v_forward * grappling_hook_speed;
//	newmis.avelocity = '0 0 -500';
	newmis.angles = vectoangles(v_forward);

	newmis.touch = GrappleAnchor;
//	newmis.think = GrappleReset;
	// grapple only lives for two seconds, this gives max range on it
//	newmis.nextthink = time + 2;
	newmis.frame = 1; // hook spread

	setmodel (newmis,"progs/hook.mdl");
	setorigin (newmis, self.origin + v_forward * 16 + '0 0 16');
	setsize(newmis, '0 0 0' , '0 0 0 ');

	self.hook_out = TRUE;
};

// called each frame by CLIENT.QC if client has hook_out
void() GrappleService =
{
	local vector dist, vel;
	local float v;

	if (!self.on_hook) 
	{
		// just draw a line to the hook
		if (vlen(self.hook.origin - self.origin) > 50) GrappleTrail(self.hook, self);
		return;
	}

	// drop the hook if player lets go of button
	if ((!self.button0 && self.weapon == DOE_GRAPPLE) ||  self.teleport_time > time) 
	{ 
		// release when we get 'ported
		self = self.hook;
		GrappleReset();
		return;
	}
	
	makevectors (self.angles);
	dist = self.hook.origin - self.origin;
	vel = self.hook.origin - (self.origin + (v_up * 16 * (!self.button2)) + (v_forward * 16));

	v = vlen (vel);

	if (v <= 100) vel = normalize(vel) * v * 10;  
	else vel = normalize(vel) * grappling_hook_pullspeed;

	self.velocity = vel;

	if (vlen(dist) <= 50) 
	{
		if (self.lefty) 
		{ 	
			// cancel chain sound
			// If there is a chain, ditch it now. We're
			// close enough. Having extra entities lying around
			// is never a good idea.
//			if (self.hook.goalentity) { 
//					self.hook.goalentity.think = GrappleRemoveChain;
//					self.hook.goalentity.nextthink = time;
//			}

			self.lefty = FALSE;// we've reset the sound channel.
		}
	} 
	else GrappleTrail (self.hook, self);
};

// Sleeper: Called in Client.QC, since it was starting to get ridiculous in PlayerPreThink.
void() Use_Grappling_Hooks =
{
	if (cvar("use_grappling_hook") == TRUE) 
	{
		if (!(self.weapons & DOE_GRAPPLE)) 
		{
			self.weapons |= DOE_GRAPPLE; // Sleeper: Give the grappling hook.
			return;
		}
	}
	if (!cvar("use_grappling_hook"))
	{
		if (self.weapons & DOE_GRAPPLE) 
		{
			self.weapons -= DOE_GRAPPLE; // Sleeper: Remove the grappling hook.
			return;
		}
	}
	
	if (cvar("use_offhand_hook") == TRUE) 
	{
		if (!self.offhand_hook_enabled) 
		{
			self.offhand_hook_enabled = TRUE; // Sleeper: Give the offhand hook.
			return;
		}
	}
	if (!cvar("use_offhand_hook"))
	{
		if (self.offhand_hook_enabled) 
		{
			self.offhand_hook_enabled = FALSE; // Sleeper: Remove the offhand hook.
			return;
		}
	}	

	// Track the grapple
	// Sleeper: Can only fire one hook at a time.
	if (self.impulse == 38 && !self.fire_hook) 
	{
		if (!cvar("use_offhand_hook"))
		{
			sprint (self, "Offhand-Hook must be enabled first!\n");
			return;
		}
		else self.fire_hook = TRUE;
	}		
	if (self.impulse == 39 && self.fire_hook) self.fire_hook = FALSE;
		
	if (self.weapon == DOE_GRAPPLE && self.button0)
	{			
		if (self.hook_out) GrappleService (); // Standard Grappling Hook
	}
	else
	{
		if (self.hook_out) OffHand_GrappleService (); // Offhand Grappling Hook	
	}
	if (self.fire_hook) OffHand_W_FireGrapple ();	
};