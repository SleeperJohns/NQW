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

// const float STAT_IT = 32;
const float STAT_ITEM2 = 33;
const float STAT_LAVAAMMO = 34;
const float STAT_MULTIAMMO = 35;
const float STAT_PLASMAAMMO = 36;
const float STAT_WEAPONS = 37;
// const float STAT_SERVERFLAGS = 38;
const float STAT_CTF_CAPTURES = 39;
const float STAT_RUNE = 40;
// .float playerrunes;
// .float itemscopy;
// .float expansionitemscopy;

void() send_ssqc_to_csqc =
{
/* 	WriteByte (MSG_MULTICAST, SVC_CGAMEPACKET);
	WriteByte (MSG_MULTICAST, EVENT_HUD_ITEMS); // name it whatever makes sense to you
	WriteFloat (MSG_MULTICAST, self.items);  // byte is smaller but needs to be in the 0-255 range. Use byte or short instead of coord when you can
	WriteFloat (MSG_MULTICAST, self.expansionitems);
	WriteFloat (MSG_MULTICAST, self.weapons);
	WriteFloat (MSG_MULTICAST, serverflags);
	msg_entity = self;
	multicast (self.origin, MULTICAST_ONE_R);
*/
//	clientstat (STAT_IT, EV_FLOAT, items);
	clientstat (STAT_ITEM2, EV_FLOAT, expansionitems); // Sleeper: Replaces .items2 for mission pack stuff.
	clientstat (STAT_LAVAAMMO, EV_FLOAT, ammo_lava_nails); // [ROGUE] Lava Nails Ammo
	clientstat (STAT_MULTIAMMO, EV_FLOAT, ammo_multi_rockets); // [ROGUE] Multi-Rocket Ammo
	clientstat (STAT_PLASMAAMMO, EV_FLOAT, ammo_plasma); // [ROGUE] Plasma Ammo
	clientstat (STAT_WEAPONS, EV_FLOAT, weapons); // Sleeper: Bypasses the bitflag restrictions on .items for weapons.
	clientstat (STAT_CTF_CAPTURES, EV_FLOAT, captures); // Sleeper: Captures Stats for CTF.
	clientstat (STAT_RUNE, EV_FLOAT, rune); // Sleeper: Shows the runes separately for each player and doesn't require serverflags. Mainly for deathmatch.
//	clientstat (STAT_SERVERFLAGS, EV_FLOAT, playerrunes);
};

void() W_SetCurrentAmmo;
/* ALL LIGHTS SHOULD BE 0 1 0 IN COLOR ALL OTHER ITEMS SHOULD
BE .8 .3 .4 IN COLOR */

/*
void(float thiskey) respawn_key =
{
	local entity key;
	
	if (num_players >= 1) return; // Sleeper: Don't respawn any keys until no one is in the server.	
		
	key = find (world, classname, "silver key");
	while (key)
	{	
		if (key.items == IT_KEY1)
		{			
			if (key.coop_key_pickup == TRUE)
			{
				key.coop_key_pickup = FALSE;
				if (world.worldtype == 0) key.model = "progs/w_s_key.mdl";
				if (world.worldtype == 1) key.model = "progs/m_s_key.mdl";
				if (world.worldtype == 2) key.model = "progs/b_s_key.mdl";				
				key.solid = SOLID_TRIGGER;	// Allow it to be touched again	
				sound (key, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);	
				setorigin (key, key.origin);			
			}
		}
		key = find (key, classname, "silver key");
	}
		
	key = find (world, classname, "gold key");
	while (key)
	{	
		if (key.items == IT_KEY2)
		{
			if (key.coop_key_pickup == TRUE)
			{
				key.coop_key_pickup = FALSE;
				if (world.worldtype == 0) key.model = "progs/w_g_key.mdl";
				if (world.worldtype == 1) key.model = "progs/m_g_key.mdl";
				if (world.worldtype == 2) key.model = "progs/b_g_key.mdl";
				key.solid = SOLID_TRIGGER;	// Allow it to be touched again	
				sound (key, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);	
				setorigin (key, key.origin);	
			}
		}
		key = find (key, classname, "gold key");
	}		
};
*/

void() respawn_keys =
{
	if (num_players >= 1) return; // Sleeper: Don't respawn any keys until no one is in the server.	
		
	self.keytaker.nextthink = time + 0.1;
	self.keytaker.think = SUB_regen;	
};

void() SUB_regen =
{
	if (self.ammo_pickedup[other.colormap] == TRUE) self.ammo_pickedup[other.colormap] = FALSE;
	if (self.armor_pickedup[other.colormap] == TRUE) self.armor_pickedup[other.colormap] = FALSE;
	if (self.weapon_pickedup[other.colormap] == TRUE) self.weapon_pickedup[other.colormap] = FALSE;
	if (self.powerup_pickedup[other.colormap] == TRUE) self.powerup_pickedup[other.colormap] = FALSE;
	if (self.health_pickedup[other.colormap] == TRUE) self.health_pickedup[other.colormap] = FALSE;

	self.model = self.mdl;		// Restore original model
	self.solid = SOLID_TRIGGER;	// Allow it to be touched again				
	sound (self, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);		
	setorigin (self, self.origin);
};

/*QUAKED noclass (0 0 0) (-8 -8 -8) (8 8 8)
prints a warning message when spawned
*/
void() noclass =
{
	dprint ("noclass spawned at");
	dprint (vtos(self.origin));
	dprint ("\n");
	remove (self);
};

/*
============
PlaceItem

plants the object on the floor
============
*/
void() PlaceItem =
{
	self.mdl = self.model;		// So it can be restored on respawn
	self.flags = FL_ITEM;		// Make extra wide
	self.solid = SOLID_TRIGGER;
     // self.movetype = MOVETYPE_TOSS;
	// DOMA =================================================================
	if (self.spawnflags & DROPTOFLOOR_DISABLE) self.movetype = MOVETYPE_NONE;
	else self.movetype = MOVETYPE_TOSS;
	// ======================================================================	
	self.velocity = '0 0 0';
	self.origin_z += 6;
	
	local float oldz = self.origin_z;
	
	if (!droptofloor())
	{
		dprint ("Bonus item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove (self);
		return;
	}
};

/*
============
StartItem

Sets the clipping size and plants the object on the floor
============
*/
void() StartItem =
{
	INHIBIT_COOP // DOMA
	if (RemovedOutsideCoop()) return;

	self.nextthink = time + 0.2;	// items start after other solids
	self.think = PlaceItem;
};

// New/Enhanced Rot Systems
void() Item_Rot_Systems =
{
	// Do healthrot stuff
	if (!cvar("deathmatch"))
	{	
		// Sleeper: Should be exactly how ID did for Megahealth rots, just enhanced for Single Player and Cooperative.
		if (self.health <= self.max_health)
		{
		       // Initiate Healthrot after 5 seconds when health is above max_health and the overstack flag gets switched on.
		       if (self.health_overstacked == 0) self.healthtime = time + 5;
		       // Disable overstack flag when rot is over.
		       else if (self.health_overstacked == 1) self.health_overstacked = 0;
		}		
	}
	else
	{
		// Sleeper: Emulate Quake III: Arena's Megahealth Rot System in deathmatch.	
		if (self.health <= self.max_health) self.healthtime = time + 1; // Initiate Healthrot after 1 second when health is above max_health.	
	}
	Enhanced_Item_Megahealth_Rot();
	// Sleeper: Speedrun Game Types use the Vanilla Megahealth Rot System up to Skill 3 before using the Enhanced Megahealth Rot System for Skill 4 and 5.
	
	// Introduce a spawned health overstack flag, also known as Health Deflate.
	if (self.health <= self.max_health && self.health_deflate == 1) 
	{
		self.healthtime = time + 1; // Initiate Healthrot after 5 seconds when health is above max_health.	
		self.health_deflate = 0;    // Disable spawned overstack rot when rot is over.
	}	
	Deflate_Health_Rot();	
					
	// Do armorrot stuff
	if (cvar("skill") == 5 && !cvar("deathmatch")) 
	{
	        // Sleeper: For a higher difficulty.
		if ((self.armorvalue <= self.max_armorvalue / 2) || (self.invincible_finished > time)) self.armorrottime = time + 6.66; // Initiate Armorrot after 6.66 seconds when a player's armorvalue is above max_armorvalue without the pentagram of protection.	
	}
/*	else if (cvar("deathmatch") && !cvar("coop"))
	{
		// Sleeper: This is meant to emulate Quake III: Arena style armor rotting for deathmatch games, which I don't think I'll be putting it in any time soon, unless I invent time to make a Quake III: Arena/Team Arena Rendition.
		if (self.armorvalue <= self.max_armorvalue) self.armorrottime = time + 1;
	}*/
	Item_Armor_Rot();
};

/*
=========================================================================

HEALTH BOX

=========================================================================
*/
//
// T_Heal: add health to an entity, limiting health to max_health
// "ignore" will ignore max_health limit
//
float(entity e, float healamount, float ignore) T_Heal =
{
	if (e.health <= 0 || (!ignore && e.health >= e.max_health)) return FALSE;
		
	// MG1: AY Dec13 2021, horde rune of hunger
	if (cvar("horde") && (serverflags & 2)) e.hunger_time = time + HUNGER_MAX;

	e.health += ceil(healamount);
	if (!ignore && e.health > e.max_health) e.health = e.max_health;

	if (cvar("deathmatch"))
	{
		if (e.health > 200) e.health = 200;
	}
	else 
	{
		if (e.health > 250) e.health = 250;
	}
		
	return TRUE;
};

/*QUAKED item_health (.3 .3 1) (0 0 0) (32 32 32) rotten megahealth
Health box. Normally gives 25 points.
Rotten box heals 5-10 points,
megahealth will add 100 health, then rot you down to your maximum health limit,
one point per second. (Sleeper: Skill 5 is adjusted for 2 points at a time.)
*/
float	H_ROTTEN = 1;
float	H_MEGA   = 2;
.float	healamount, healtype;
void() health_touch;
void() Vanilla_Item_Megahealth_Rot;
void() Enhanced_Item_Megahealth_Rot;

float() health_customizeentityforclient =
{
	if (self.health_pickedup[other.colormap] == TRUE) 
	{
//		self.alpha = 0; // Sleeper: In case if someone decides to play Quake in splitscreen mode (FTE Only), leaving the alpha alone is vital.
		self.dimension_seen = 0;
		return FALSE;
	}
	
	self.alpha = 1;
	self.dimension_seen = 1;
	self.health_pickedup[other.colormap] = FALSE;
	return TRUE;
};

void() bound_other_health =
{
	if (self.healtype == 2 || other.guard == 1) // Bind health for Mega Health
	{
		if (cvar("deathmatch"))
		{
			if (other.health > 200) other.health = 200;	
		}
		else 
		{
			if (other.health > 250) other.health = 250;	
		}
	}
	else if (self.healtype != 2) // Bind health for Rotten and Non-Rotten Health Packs
	{	
		if (cvar("skill") <= 3 && other.health > 100 && !deathmatch || deathmatch && other.health > 100) other.health = 100;
		else if (cvar("skill") == 4 && other.health > 50 && !deathmatch) other.health = 50;
		else if (cvar("skill") == 5 && other.health > 125 && !deathmatch) other.health = 125;	
		else if (other.guard == 1 && other.health > 200) other.health = 200;
	}		
};

void() item_health =		
{					   // Coop Speedrunning	on a public server				     		// Single Player Speedrunning on a public server
	local float DontChangeOnTheFly = ((coop == CLASSIC_COOP && !cvar("horde") && !deathmatch && cvar("sv_public") == 1) || (!coop && !cvar("horde") && !deathmatch && cvar("sv_public") == 1));

	if (cvar("instagib"))
	{
		remove (self);
		return;
	}
	
	self.touch = health_touch;
	if (self.spawnflags & H_ROTTEN)
	{
		precache_model("maps/b_bh10.bsp");	
		precache_sound("items/r_item1.wav");
		setmodel(self, "maps/b_bh10.bsp");
		self.noise = "items/r_item1.wav";
		
		// When speedrunning, prevent Rotten Healthpack's healamount from being changed when changing skills on the fly.
		if (DontChangeOnTheFly)
		{
			if (cvar("skill") <= 4) self.healamount = 15;  // Default amount
			else if (cvar("skill") == 5) self.healamount = 10;  // Sleeper Must Die! amount
		}		
		self.healtype = 0;
	}
	else if (self.spawnflags & H_MEGA)
	{
		precache_model("maps/b_bh100.bsp");
		precache_sound("items/r_item2.wav");
		setmodel(self, "maps/b_bh100.bsp");
		self.noise = "items/r_item2.wav";
		
		// When speedrunning, prevent Mega Health's healamount from being changed when changing skills on the fly.
		if (DontChangeOnTheFly)
		{
			if (cvar("skill") <= 3) self.healamount = 100; 	    // Default amount
			else if (cvar("skill") == 4) self.healamount = 50;  // Copper amount
			else if (cvar("skill") == 5) self.healamount = 75;  // Sleeper Must Die! amount
			other.health_overstacked = 1;  			    // Enable overstack flag		
		}		
		self.healtype = 2;
	}		
	else
	{
		precache_model("maps/b_bh25.bsp");
		precache_sound("items/health1.wav");
		setmodel(self, "maps/b_bh25.bsp");
		self.noise = "items/health1.wav";
		self.healamount = 25;
		self.healtype = 1;
	}
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

void() health_touch =
{			  
	local float prev_health, picked_amount, ChangeOnTheFly = ((coop < 5 && cvar("horde") < 2 && !deathmatch && cvar("sv_public") == 0) || 
								  (coop == REIGNITED_COOP && cvar("horde") < 2 && !deathmatch && cvar("sv_public") == 1) || 
								  (!coop && !cvar("horde") && deathmatch && cvar("sv_public") >= 0) || 
								  (coop == CLASSIC_COOP &&  cvar("horde") && !deathmatch && cvar("sv_public") == 1) ||
								  (coop == ENHANCED_COOP && cvar("horde") < 2 && !deathmatch && cvar("sv_public") == 1));	
	
	if (other.netname == "[overseer]-BOT") return;	
	if (other.classname != "player") return;
	if (initiate_matchtime == FALSE && cvar("deathmatch")) return;	
	
	// When playing Casual Cooperative, let Health Touch handle Megahealth/Rotten Healthpack healamount values so that the healamount values can be changed on fly.
	if (ChangeOnTheFly)
	{
		if (self.healtype == 0)
		{
			if (cvar("skill") <= 4 && !deathmatch || deathmatch) self.healamount = 15; // Default amount
			else if (cvar("skill") == 5 && !deathmatch) self.healamount = 10;  	   // Sleeper Must Die! amount
		}		
		else if (self.healtype == 2)
		{
			if (cvar("skill") <= 3 && !deathmatch || deathmatch) self.healamount = 100; // Default amount
			else if (cvar("skill") == 4 && !deathmatch) self.healamount = 50;  	    // Copper amount
			else if (cvar("skill") == 5 && !deathmatch) self.healamount = 75; 	    // Sleeper Must Die! amount
			if (cvar("coop") < 5 && !cvar("deathmatch"))
			{
				other.health_overstacked = 1; 				 // Enable overstack flag	
				if (other.health_deflate == 1) other.health_deflate = 0; // Replace initial spawned deflate decay with the overstack decay.
			}
		}				
	}						

	if (!self.cnt_trig)
	{
		self.cnt_trig = 1;
		activator = other;
		SUB_UseTargets();
	}
	
	local float shouldstay = (coop == REIGNITED_COOP && !cvar("horde") && !cvar("customcoop") && self.healtype != 2), 
		    shouldstay_enhanced = (coop == ENHANCED_COOP && !cvar("horde") && !cvar("customcoop") && self.healtype != 2), 
		    shouldstay_vanilla = (coop == CLASSIC_COOP && !cvar("horde") && !cvar("customcoop") && self.healtype != 2),
		    shouldstay_customcoop = (coop == REIGNITED_COOP && cvar("customcoop") && !cvar("horde") && !deathmatch),
		    shouldstay_horde_only = (coop == REIGNITED_COOP && cvar("horde") && !cvar("customcoop") && self.healtype == 2);
		
	// Sleeper: Courtesy of Alkaline. This calculates the delta between the amount of health pickups and the player's health.
	prev_health   = other.health;
	other.health += self.healamount;
	bound_other_health ();	     // Sleeper: Bound health in a similiar fashion to ammo.
	picked_amount = other.health - prev_health;
	other.health  = prev_health; // Sleeper: Hack the health, so it doesn't double.
				
	// Megahealth? Ignore max_health...	
	if (self.healtype == 2)
	{	
		if (!deathmatch && other.health >= 250) return;
		if (deathmatch && other.health >= 200) return;
								
		if (shouldstay_horde_only) // Sleeper: Allow Megahealth to be picked up by multiple players in Horde Mode. (FIXME: Should we make Megahealth respawnable instead in Horde Mode?) 
		{	
			self.health_lockout_selective = 1;
			if (self.health_lockout_selective == 1) // Choose when an ammo pack can be locked out from being picked up again from a player during coop.
			{	
				if (self.health_lockout[other.colormap] == -1) return; // Lockout
			}																					
		}
		else if (shouldstay_customcoop && self.cnt_mg1 < num_players) // Sleeper: Usually have a decoy client in the server.
		{
			if (self.health_lockout_selective == 1) // Choose when an ammo pack can be locked out from being picked up again from a player during coop.
			{	
				if (self.enemy == other)
				{
					if (self.health_lockout[other.colormap] == -1) return; // Lockout
				}
			}																										
		}												
		if (!T_Heal(other, self.healamount, 1)) return;	
		other.nqwSpeakItem (other, self);	
		
		if (shouldstay_horde_only) self.alpha = 0.45;		
	}
	else
	{		
		if (shouldstay)
		{
			self.health_lockout_selective = 1;
			if (self.health_lockout_selective == 1) // Choose when an ammo pack can be locked out from being picked up again from a player during coop.
			{	
				if (self.health_lockout[other.colormap] == -1) return; // Lockout
			}																														
		}
		else if (shouldstay_customcoop && self.cnt_mg1 < num_players) // Sleeper: Usually have a decoy client in the server.
		{
			if (self.health_lockout_selective == 1) // Choose when an ammo pack can be locked out from being picked up again from a player during coop.
			{	
				if (self.enemy == other)
				{
					if (self.health_lockout[other.colormap] == -1) return; // Lockout
				}
			}																										
		}						
		if (!T_Heal(other, self.healamount, 0)) return;	
		
		if (shouldstay) self.alpha = 0.45;										
	}
								
	// Health specific player prints
	if (cvar("skill") <= 4 || cvar("deathmatch"))
	{
		if (self.healtype == 0) sprint (other, "You picked up a Rotten Healthpack (+", ftos(picked_amount), " Health)\n");
		else if (self.healtype == 1) sprint (other, "You picked up a Healthpack (+", ftos(picked_amount), " Health)\n");	
		else if (self.healtype == 2) sprint (other, "You picked up Megahealth (+", ftos(picked_amount), " Health)\n");	
	}
	else if (cvar("skill") == 5 && !cvar("deathmatch"))
	{
		if (self.healtype == 0) sprint (other, "You picked up First Aid (+", ftos(picked_amount), " Health)\n");
		else if (self.healtype == 1) sprint (other, "You picked up a Medkit (+", ftos(picked_amount), " Health)\n");	
		else if (self.healtype == 2) sprint (other, "You picked up Megahealth (+", ftos(picked_amount), " Health)\n");
	}		
	
	// Health touch sound
	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);	
	stuffcmd (other, "bf\n");

	// Vanilla Speedrunning
	if (!cvar("coop") || cvar("coop") == CLASSIC_COOP)
	{
		if (!cvar("horde"))
		{
			if (!cvar("deathmatch") && cvar("skill") <= 3 && cvar("sv_public") == 1)
			{
				if (self.healtype == 2)
				{
					self.nextthink = time + 5;
					self.think = Vanilla_Item_Megahealth_Rot;
					self.owner = other;
				}
			}
		}
	}

	if (deathmatch)
	{
		// Duel
		if (deathmatch == DM_DUEL)
		{
			if (self.healtype == 2) self.nextthink = time + 60; // Respawn Megahealth after 1 minute. (FIXME: Do we rather have Quake III: Arena Duel respawn timers for balance? 2 minutes?)
			else self.nextthink = time + 20; // Respawn Healthpacks after 20 seconds.
			self.think = SUB_regen;	
		}
		// Free For All, Team Deathmatch, Capture The Flag, One Flag CTF
		else if (deathmatch >= DM_FFA && deathmatch <= DM_OneFlagCTF)
		{
			if (self.healtype == 2) self.nextthink = time + 30; // Respawn Megahealth after 30 seconds.
			else self.nextthink = time + 20; // Respawn Healthpacks after 20 seconds.
			self.think = SUB_regen;	
		}
	}

	// Sleeper: Modified MG1 code; the original MG1 code was resetting pickup cycles when the player was above their max health. O_o
	if (shouldstay_customcoop)
	{
		self.cnt_mg1++;
		self.health_lockout_selective = 0;		
		if (self.cnt_mg1 < num_players && self.enemy != other) // Not been picked up by all players yet.
		{
			self.alpha = 0.45; // If picked up, change tranparency
			self.enemy = other; // Sleeper: Store this player (They won't be able to pick up the same item twice until the next true respawn cycle of the item).
			self.health_lockout_selective = 1;
		}
		else 
		{
			self.alpha = 1; // If a true respawn, restore opacity
			self.enemy = world;
			self.cnt_mg1 = 0; // Reset cycle
			self.health_lockout_selective = 0;
			if (self.healtype == 2) self.nextthink = time + 60; // Respawn Megahealth after 60 seconds
			else self.nextthink = time + 20; // Respawn Healthpacks after 20 seconds
			self.think = SUB_regen;
		}			
	}	
	else if (shouldstay_vanilla && gameworld == MG1) // Classic Coop and MG1 maps only items respawn.
	{	
		self.cnt_mg1++;
		if (self.cnt_mg1 < num_players && self.enemy != other) // Not been picked up by all players yet.
		{
			self.enemy = other;
			self.nextthink = time + 1; 
			self.think = SUB_regen; // Respawn almost immediately
		}
		else
		{
			self.enemy = world;
			self.cnt_mg1 = 0;
			self.nextthink = time + (6 * 60);
			self.think = SUB_regen; // Respawn after 6 mins in case the players get stuck on something hard.
		}
	}
	else if (shouldstay_enhanced)
	{	
		self.cnt_mg1++;
		if (self.cnt_mg1 < num_players && self.enemy != other) // Not been picked up by all players yet.
		{
			self.enemy = other;
			self.nextthink = time + 1; 
			self.think = SUB_regen; // Respawn almost immediately
		}
		else
		{
			self.enemy = world;
			self.cnt_mg1 = 0;
			self.nextthink = time + (6 * 60);
			self.think = SUB_regen; // Respawn after 6 mins in case the players get stuck on something hard.
		}
	}									

	activator = other;
	SUB_UseTargets(); // Fire all Targets/Killtargets
	
	self.health_pickedup[other.colormap] = 1;
	
	if (!self.health_lockout_selective) 
	{
		self.model = string_null;
		self.solid = SOLID_NOT;
	}
	if (self.health_lockout_selective == 1) self.health_lockout[other.colormap] = -1;
	
	if (self.health_pickedup[other.colormap] == 1 && !deathmatch && coop == REIGNITED_COOP) self.customizeentityforclient = health_customizeentityforclient;
};

// Can only be used in the speedrunning gametypes (coop 0 or coop 2 in a public server)
// Vanilla Megahealth Rot System
void() Vanilla_Item_Megahealth_Rot =
{
	other = self.owner;

	if (other.health > other.max_health)
	{
		other.health -= 1;
		self.nextthink = time + 1;
		return;
	}
};

// Sleeper: Used to separate an overstack from a megahealth from a respawn/fresh spawn.
// Health Deflate System
void() Deflate_Health_Rot =
{
	if (time < self.healthtime) return;			
	if (self.health <= 0) return;	

	// Sleeper: Rot immediately only on spawn if health is over max health and overstack flag is on.
	if (self.health > self.max_health && self.health_deflate == 1)
	{
		// Tick -1 every second until max_health is hit.
		self.health -= 1;
		self.healthtime = time + 1;
		return;
	}
};

// Sleeper: Note the Enhanced Megahealth Rot System is dialed in specifically if a public or private server for compatibility between all Game Types. This is clearly overdoing compatibility, but I say it's needed.
// Enhanced Megahealth Rot System
void() Enhanced_Item_Megahealth_Rot =
{
	if (time < self.healthtime) return;				
	if (self.health <= 0) return;	
		
	// Deathmatch will always rot megahealth off regardless if a flag is present or not. A bit like Quake III: Arena in a way
	if (!cvar("coop") && cvar("deathmatch") >= DM_DUEL)
	{	
		if (self.health > self.max_health)
		{
			// Tick -1 every second until max_health is hit.
			self.health -= 1;
			self.healthtime = time + 1;
			return;
		}
	}
	// Speedrunning (Solo / Cooperative)
	if (!cvar("coop") || cvar("coop") == CLASSIC_COOP)
	{
		if (cvar("skill") >= 4 && !cvar("deathmatch") && cvar("sv_public") == 1) // Only initate on Public Servers
		{
			if (self.health > self.max_health)
			{
				// Don't over shoot max_health.
				if (cvar("skill") == 5 && self.health > 126)
				{
					// For skill 5, tick -2 every second until health is 126, then tick -1 for the last second to round health to 125.
					self.health -= 2;
					self.healthtime = time + 1;
				}
				// Skill 4 and below, and Deathmatch has normal healthrot.
				else 
				{
					// Tick -1 every second until max_health is hit.
					self.health -= 1;
					self.healthtime = time + 1;
				}
				return;
			}
		}
	}	
										
	//  Private            or                 Public	
	if (!cvar("sv_public") || cvar("sv_public") == 1)
	{
		// Reignited Cooperative / Single Player
		if (!cvar("coop") || cvar("coop") == REIGNITED_COOP || cvar("coop") == ENHANCED_COOP)
		{
			if (cvar("skill") <= 5 && !cvar("deathmatch"))
			{
				if (self.health > self.max_health && self.health_overstacked == 1)
				{
					// Don't over shoot max_health.
					if (cvar("skill") == 5 && self.health > 126)
					{
						// For skill 5, tick -2 every second until health is 126, then tick -1 for the last second to round health to 125.
						self.health -= 2;
						self.healthtime = time + 1;
					}
					// Skill 4 and below, and Deathmatch has normal healthrot.
					else 
					{
						// Tick -1 every second until max_health is hit.
						self.health -= 1;
						self.healthtime = time + 1;
					}
					return;
				}	
			}
		}
		// Classic Cooperative on a Private Server only
		else if (cvar("coop") == CLASSIC_COOP && !cvar("sv_public"))
		{
			if (cvar("skill") <= 5 && !cvar("deathmatch"))
			{
				if (self.health > self.max_health && self.health_overstacked == 1)
				{
					// Don't over shoot max_health.
					if (cvar("skill") == 5 && self.health > 126)
					{
						// For skill 5, tick -2 every second until health is 126, then tick -1 for the last second to round health to 125.
						self.health -= 2;
						self.healthtime = time + 1;
					}
					// Skill 4 and below, and Deathmatch has normal healthrot.
					else 
					{
						// Tick -1 every second until max_health is hit.
						self.health -= 1;
						self.healthtime = time + 1;
					}
					return;
				}	
			}
		}				
	}				
};

/*
===============================================================================

ARMOR

===============================================================================
*/

// New Armor Rot System
void() Item_Armor_Rot =
{
	if (time < self.armorrottime) return;      		
	if (self.health <= 0) return;
	if (self.armorvalue <= 0) return;
		
	// Rot -10 armorvalue on skill 5
	if (cvar("skill") == 5 && !cvar("deathmatch")) 
	{
	   	// Protect armor from rotting when Pentagram is acquired (you'll still be able to take armor damage).
		if (self.invincible_finished > time) return;
		
		// Tick down -10 every 6.66 seconds.	
		if (self.armorvalue > self.max_armorvalue / 2)
		{
			self.armorvalue -= 10;
			self.armorrottime = time + 6.66;
			if (self.armorvalue < self.max_armorvalue / 2) self.armorvalue = self.max_armorvalue / 2; // Don't overshoot max armorvalue.
		}
		sound (self, CHAN_ITEM, "items/armorrot.wav", 1, ATTN_STATIC); // Make a Doom 3-style rot sound every 6.66 seconds.
		return;
	}
	/*
	// Rot -1 armorvalue in Deathmatch
	else if (deathmatch)
	{
		if (self.armorvalue > self.max_armorvalue / 2)
		{
			self.armorvalue -= 1;
			self.armorrottime = time + 1;
		}
		return;	
	}
	*/
};

float() armor_customizeentityforclient =
{
	if (self.armor_pickedup[other.colormap] == TRUE) 
	{
//		self.alpha = 0;
		self.dimension_seen = 0;
		return FALSE;
	}
	
	self.alpha = 1;
	self.dimension_seen = 1;
	self.armor_pickedup[other.colormap] = FALSE;
	return TRUE;
};

void() armor_touch;

// Sleeper: Get Index for Armor.
float(entity ent) ArmorIndex =
{
	if (ent.items & IT_ARMOR1) return IT_ARMOR1;
	if (ent.items & IT_ARMOR2) return IT_ARMOR2;
	if (ent.items & IT_ARMOR3) return IT_ARMOR3;
	
	return 0;	
};

.float fake_armortype;
void() armor_touch =
{
	local float type, value, maxvalue, bit;
	
	// Sleeper: Quake 2-style Armor System for Skill 5.
	local float old_armor_index, salvage, salvagecount, newcount, fake_type;
	local float oldinfo_type, oldinfo_bit, oldinfo_maxvalue, oldinfo_fake_type;
		
	if (other.netname == "[overseer]-BOT") return;		
	if (other.health <= 0) return;
	if (other.classname != "player") return;
	if (initiate_matchtime == FALSE && cvar("deathmatch")) return;	
		
	// Fire trigger, even though the item hasn't been picked up.			
	if (!self.cnt_trig)
	{
		self.cnt_trig = 1;
		activator = other;
		SUB_UseTargets();
	}
				    
	if (self.armor_lockout_selective == 1) // Choose when an ammo pack can be locked out from being picked up again from a player during coop.
	{	
		if (coop & REIGNITED_COOP || deathmatch)
		{
			if (self.armor_lockout[other.colormap] == -1) return; // Lockout
		}
	}		
	
	if (self.classname == "item_armor1") // The Green Armor
	{
		bit = IT_ARMOR1;
		if (cvar("skill") == 5)
		{
			fake_type = 0.3;
			maxvalue = 50;
			value = 25;
			type = 0.15;
			self.message = "You got the Jacket Armor";
			self.noise = "items/q2armor1.wav"; // Quake 2 Jacket Armor pickup sound		
		}
		else
		{
			fake_type = 0.3;
			maxvalue = 100;
			value = 100;
			type = 0.3;
			self.message = "You got the Green Armor";
			self.noise = "items/armor1.wav"; // Quake 1 Armor pickup sound	
//			self.items = IT_ARMOR1;		
		}
	}
	else if (self.classname == "item_armor2") // The Yellow Armor
	{
		bit = IT_ARMOR2;
		if (cvar("skill") == 5)
		{
			fake_type = 0.6;
			maxvalue = 100;
			value = 50;
			type = 0.19;
			self.message = "You got the Combat Armor";
			self.noise = "items/q3armor1.wav"; // Quake 3 Armor pickup sound
		}
		else
		{
			fake_type = 0.6;
			maxvalue = 150;
			value = 150;
			type = 0.6;
			self.message = "You got the Yellow Armor";
			self.noise = "items/armor1.wav"; // Quake 1 Armor pickup sound	
//			self.items = IT_ARMOR2;		
		}			
	}
	else if (self.classname == "item_armorInv") // The Red Armor
	{
		bit = IT_ARMOR3;
		if (cvar("skill") == 5)
		{
			fake_type = 0.8;
			maxvalue = 150;
			value = 75;
			type = 0.245;
			self.message = "You got the Heavy Armor";
			self.noise = "items/q4armor1.wav"; // Quake 4 Armor pickup sound
		}
		else 
		{
			fake_type = 0.8;
			maxvalue = 200;
			value = 200;
			type = 0.8;
			self.message = "You got the Red Armor";
			self.noise = "items/armor1.wav"; // Quake 1 Armor pickup sound
//			self.items = IT_ARMOR3;
		}
	}
	
	if (cvar("skill") == 5) // Sleeper: Skill 5 should have a Quake 2-style armor system, however still rots overtime.
	{	
		self.armortype = type;
		self.fake_armortype = fake_type;
		self.armorvalue = value;
		self.max_armorvalue = maxvalue;
	
		// MG1 ================================================================================================================				
		#ifdef COOP_RESPAWN_ITEMS_FOR_PLAYERS
		if (coop && other == self.enemy && self.wait <= 0) return; // In coop, don't allow the same player to pick up all the respawns.
		if ((coop == CLASSIC_COOP && gameworld == MG1) || (coop == REIGNITED_COOP && cvar("customcoop")) || (coop == ENHANCED_COOP)) self.enemy = other;	// Store this player for coop		
		#endif			
		// ====================================================================================================================			
	
		old_armor_index	= ArmorIndex (other);
		
		if (!old_armor_index) // Sleeper: If we don't have any armor, just use it.
		{
			other.armortype = type;
			other.fake_armortype = fake_type;
			other.armorvalue = self.armorvalue;
			other.max_armorvalue = maxvalue;
			self.items = bit;		
		}
		else
		{
			// Sleeper: Save old armor information
			if (old_armor_index == IT_ARMOR1) oldinfo_bit = IT_ARMOR1;
			else if (old_armor_index == IT_ARMOR2) oldinfo_bit = IT_ARMOR2;
			else oldinfo_bit = IT_ARMOR3;
			
			oldinfo_type = other.armortype;
			oldinfo_maxvalue = other.max_armorvalue;
			oldinfo_fake_type = other.fake_armortype;
		
			// Sleeper: Calculate armor stats to salvage.
			if (self.fake_armortype > other.fake_armortype) // Sleeper: If the picked up armor is more superior, upgrade. (Also, had to cheat a bit to make it look convincing that salvaging armor feels like Quake 2, but with less max armor)
			{
				salvage = other.fake_armortype / self.fake_armortype;
				salvagecount = salvage * other.armorvalue;
				newcount = self.armorvalue + salvagecount;
				
				if (newcount > self.max_armorvalue) newcount = self.max_armorvalue;
				
				old_armor_index = 0;				
				other.armortype = self.armortype;
				other.armorvalue = newcount;
				other.max_armorvalue = self.max_armorvalue;
				other.fake_armortype = self.fake_armortype;
				self.items = bit;
			}
			else // Sleeper: If the picked up armor is the same or less superior, keep original stats.
			{
				salvage = self.fake_armortype / other.fake_armortype;
				salvagecount = salvage * self.armorvalue;
				newcount = other.armorvalue + salvagecount;
				
				if (newcount > other.max_armorvalue) newcount = other.max_armorvalue;
				
				if (other.armorvalue >= newcount) return; // Sleeper: We're already overstacked to the max, don't take the new armor.
				
				other.armortype = oldinfo_type;
				other.armorvalue = newcount;
				other.max_armorvalue = oldinfo_maxvalue;
				other.fake_armortype = oldinfo_fake_type;
				self.items = oldinfo_bit;
			}
		}				
		// Armor shards would go next. Coop can allow overstack, but in deathmatch, overstacking for shards is locked to the maximum armor of that particular armor level.											
	}
	else 
	{		
		// General armor maths for Singleplayer/Cooperative and Deathmatch
		if ((other.armortype * other.armorvalue) >= (type * value)) return;
		// MG1 ================================================================================================================				
		#ifdef COOP_RESPAWN_ITEMS_FOR_PLAYERS
		if (coop && other == self.enemy && self.wait <= 0) return; // In coop, don't allow the same player to pick up all the respawns.
		if ((coop == CLASSIC_COOP && gameworld == MG1) || (coop == REIGNITED_COOP && cvar("customcoop")) || (coop == ENHANCED_COOP)) self.enemy = other;	// Store this player for coop			
		#endif	
		// ====================================================================================================================			
		other.armortype = type;
		other.armorvalue = value;
		other.max_armorvalue = maxvalue; // Not needed here, but is good for consistency		
	}
		
	other.items -= other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3);
	other.items |= self.items;
	self.armor_pickedup[other.colormap] = 1;
//	send_ssqc_to_csqc ();	
	
	// MG1 =========================================================================================================
	#ifdef COOP_RESPAWN_ITEMS_FOR_PLAYERS	
	if (coop == CLASSIC_COOP && gameworld == MG1 && self.wait <= 0)
	{
		self.cnt_mg1++;
		if (self.cnt_mg1 < num_players) // Not been picked up by all players yet.
		{
			self.nextthink = time + 1; 
			self.think = SUB_regen; // Respawn almost immediately
		}
		else
		{
			self.enemy = world;
			self.cnt_mg1 = 0;
			self.nextthink = time + (8 * 60);
			self.think = SUB_regen; // Respawn after 8 mins in case the players get stuck on something hard.
		}
	}	
	else if (coop == REIGNITED_COOP && cvar("customcoop") && self.wait <= 0)
	{
		self.cnt_mg1++;		
		if (self.cnt_mg1 < num_players)
		{
			self.alpha =  0.87;
			self.enemy = other;
			self.nextthink = time + 0.0000001;
			self.think = SUB_regen; // Hack to spawn immediately			
		}
		else
		{
			self.alpha =  1;
			self.enemy = world;
			self.cnt_mg1 = 0;
			self.nextthink = time + 20;
			self.think = SUB_regen;
		}
	}
	else if (coop == ENHANCED_COOP && self.wait <= 0)
	{
		self.cnt_mg1++;
		if (self.cnt_mg1 < num_players) // Not been picked up by all players yet.
		{
			self.nextthink = time + 1; 
			self.think = SUB_regen; // Respawn almost immediately
		}
		else
		{
			self.enemy = world;
			self.cnt_mg1 = 0;
			self.nextthink = time + (8 * 60);
			self.think = SUB_regen; // Respawn after 8 mins in case the players get stuck on something hard.
		}
	}	
	else 
	#endif
	// =============================================================================================================				
	if (deathmatch)
	{
		if (deathmatch >= DM_DUEL && deathmatch <= DM_OneFlagCTF)
		{
			self.nextthink = time + 20;
			self.think = SUB_regen;
		}
	}	
	// MG1
	else if (coop == CLASSIC_COOP && gameworld == MG1)
	{
		if (self.wait)
		{
			self.enemy = world;
			self.nextthink = time + self.wait;
			self.think = SUB_regen;
		}
	}
	else if (coop == ENHANCED_COOP)
	{
		if (self.wait)
		{
			self.enemy = world;
			self.nextthink = time + self.wait;
			self.think = SUB_regen;
		}
	}			

	// Armor specific player prints
	sprint (other, self.message, "\n");
	self.message = string_null;
	
	// Armor touch sound
	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	activator = other;
	// Fire all Targets/Killtargets
	SUB_UseTargets();
	
	if (coop & REIGNITED_COOP && !cvar("customcoop")) 
	{
		self.alpha = 0.87;
		self.armor_lockout_selective = 1;
	}				
	if (!self.armor_lockout_selective)
	{ 
		self.model = string_null;
		self.solid = SOLID_NOT;	
	}				
	if (self.armor_lockout_selective == 1) self.armor_lockout[other.colormap] = -1;	
	
	if (self.armor_pickedup[other.colormap] == 1 && !deathmatch && coop == REIGNITED_COOP) self.customizeentityforclient = armor_customizeentityforclient;		
};

/*QUAKED item_armor1 (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() item_armor1 =
{
	if (cvar("instagib"))
	{
		remove (self);
		return;
	}

	self.touch = armor_touch;
	/*
	if (cvar("skill") == 5)
	{
		self.max_armorvalue = 25;
		self.armorvalue = 50;
		self.armortype = 0.15;
	}
	else
	{
		self.max_armorvalue = 100;
		self.armorvalue  = 100;
		self.armortype = 0.3;
	}
	*/
	precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED item_armor2 (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() item_armor2 =
{
	if (cvar("instagib"))
	{
		remove (self);
		return;
	}

	self.touch = armor_touch;
	/*	
	if (cvar("skill") == 5)
	{
		self.max_armorvalue = 50;
		self.armorvalue = 100;
		self.armortype = 0.19;
	}
	else
	{
		self.max_armorvalue = 150;
		self.armorvalue = 150;
		self.armortype = 0.6;
	}
	*/
	precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 1;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED item_armorInv (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() item_armorInv =
{
	if (cvar("instagib"))
	{
		remove (self);
		return;
	}

	self.touch = armor_touch;
	/*
	if (cvar("skill") == 5)
	{
		self.max_armorvalue = 75;
		self.armorvalue = 150;
		self.armortype = 0.245;
	}
	else 
	{
		self.max_armorvalue = 200;
		self.armorvalue = 200;
		self.armortype = 0.8;
	}
	*/		
	precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 2;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*
===============================================================================

WEAPONS

===============================================================================
*/

void() bound_other_ammo =
{
	if (other.ammo_shells1 > 100) other.ammo_shells1 = 100;
	if (other.ammo_nails1 > 200) other.ammo_nails1 = 200;
	if (other.ammo_rockets1 > 100) other.ammo_rockets1 = 100;
	if (other.ammo_cells1 > 100) other.ammo_cells1 = 100;
		
	if (other.ammo_shells > 100) other.ammo_shells = 100;
	if (other.ammo_nails > 200) other.ammo_nails = 200;
	if (other.ammo_rockets > 100) other.ammo_rockets = 100;
	if (other.ammo_cells > 100) other.ammo_cells = 100;		
		
	// PGM addition
	if (other.ammo_lava_nails > 200) other.ammo_lava_nails = 200;
	if (other.ammo_multi_rockets > 100) other.ammo_multi_rockets = 100;
	if (other.ammo_plasma > 100) other.ammo_plasma = 100;		
};

float(entity e, float type) CheckAmmoPickup =
{
	if (type == IT_SHELLS) return e.ammo_shells1 < 100;
	if (type == IT_NAILS) return e.ammo_nails1 < 200;
	if (type == IT_ROCKETS) return e.ammo_rockets1 < 100;
	if (type == IT_CELLS) return e.ammo_cells1 < 100;
		
	if (type == IT_SHELLS) return e.ammo_shells < 100;
	if (type == IT_NAILS) return e.ammo_nails < 200;
	if (type == IT_ROCKETS) return e.ammo_rockets < 100;
	if (type == IT_CELLS) return e.ammo_cells < 100;		
		
	if (type == DOE_LAVA_NAILS) return e.ammo_lava_nails < 200;
	if (type == DOE_MULTI_ROCKETS) return e.ammo_multi_rockets < 100;
	if (type == DOE_PLASMA_AMMO) return e.ammo_plasma < 100;
	
	return TRUE;
};

void(entity e, float type, float amt) AddAmmo =
{
	if (type == IT_SHELLS)
	{
		e.ammo_shells1 += amt;
		e.ammo_shells += amt;
		if (e.ammo_shells1 > 100) e.ammo_shells1 = 100;
		if (e.ammo_shells > 100) e.ammo_shells = 100;
	}
	else if (type == IT_NAILS)
	{
		e.ammo_nails1 += amt;
		e.ammo_nails += amt;		
		if (e.ammo_nails1 > 200) e.ammo_nails1 = 200;
		if (e.ammo_nails > 200) e.ammo_nails = 200;		
	}
	else if (type == IT_ROCKETS)
	{
		e.ammo_rockets1 += amt;
		e.ammo_rockets += amt;
		if (e.ammo_rockets1 > 100) e.ammo_rockets1 = 100;
		if (e.ammo_rockets > 100) e.ammo_rockets = 100;
	}
	else if (type == IT_CELLS)
	{
		e.ammo_cells1 += amt;
		e.ammo_cells += amt;
		if (e.ammo_cells1 > 100) e.ammo_cells1 = 100;
		if (e.ammo_cells > 100) e.ammo_cells = 100;
	}
	else if (type == DOE_LAVA_NAILS)
	{
		e.ammo_lava_nails += amt;
		if (e.ammo_lava_nails > 200) e.ammo_lava_nails = 200;
	}
	else if (type == DOE_MULTI_ROCKETS)
	{
		e.ammo_multi_rockets += amt;
		if (e.ammo_multi_rockets > 100) e.ammo_multi_rockets = 100;
	}
	else if (type == DOE_PLASMA_AMMO)
	{
		e.ammo_plasma += amt;
		if (e.ammo_plasma > 100) e.ammo_plasma = 100;
	}		
};

//MED 01/06/97 added hipnotic weapons into rankings
float(float w) RankForWeapon =
{
	if (w == DOE_PLASMA_GUN) return 1;
	if (w == IT_LIGHTNING) return 2;
	if (w == DOE_MULTI_ROCKET) return 3;		
	if (w == IT_ROCKET_LAUNCHER) return 4;
	if (w == IT_LASER_CANNON) return 5;
	if (w == DOE_LAVA_SUPER_NAILGUN) return 6;		
	if (w == IT_SUPER_NAILGUN) return 7;
	if (w == IT_PROXIMITY_GUN) return 8;
	if (w == DOE_MULTI_GRENADE) return 9;		
	if (w == IT_GRENADE_LAUNCHER) return 10;
	if (w == DOE_LAVA_NAILGUN) return 11;		
	if (w == IT_SUPER_SHOTGUN) return 12;
	if (w == IT_NAILGUN) return 13;
	if (w == IT_MJOLNIR) return 14;
	return 15;
};

/*
=============
Deathmatch_Weapon

Deathmatch weapon change rules for picking up a weapon

 ID1
.float	ammo_shells, ammo_nails, ammo_rockets, ammo_cells;

 DoE
.float  ammo_shells1, ammo_nails1, ammo_rockets1, ammo_cells1, ammo_lava_nails, ammo_multi_rockets, ammo_plasma;
=============
*/
void(float old, float new) Deathmatch_Weapon =
{
	if (self.flags & FL_ISBOT) return; // mal: let bots pick their own weapon.

	// Change self.weapon if desired
	local float or = RankForWeapon (self.weapon);
	local float nr = RankForWeapon (new);
	
	if (nr < or) self.weapon = new;
};

void(entity weap, entity responsible) GiveWeapon =
{
//	local float hadweap = self.items & (weap.weapon);

	if (self.items & HUD_WEAPONS) self.items |= weap.weapon; // Sleeper: .items field always needs the HUD weapons in case of no CSQC HUD. 
	other.weapons |= weap.weapon;
	AddAmmo (self, weap.aflag, weap.cnt);
/*	
	if (!hadweap && self == responsible)
	{
		if (cvar("coop") == 2) self.weapon = weap.weapon;
		if (deathmatch) Deathmatch_Weapon (self.weapon, weap.weapon);
		else if (self.waterlevel <= 1 || weap.weapon != IT_LIGHTNING) self.weapon = weap.weapon;
	}
*/
	W_SetCurrentAmmo();
		
	sprint (other, "You got the ",  weap.netname, "\n");
	sound (self, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	stuffcmd (self, "bf\n");
};

void(entity comboOwner) EnableComboWeapons =
{
	local float newweapon;

	if (comboOwner.netname == "[overseer]-BOT") return;
	if (comboOwner.classname != "player") return;
					
	if (!(comboOwner.weapons & DOE_LAVA_NAILGUN))
	{
		if (comboOwner.ammo_lava_nails > 0 && (comboOwner.weapons & IT_NAILGUN))
		{
			sprint (comboOwner, "Lava Nails Enabled\n");	
			newweapon = DOE_LAVA_NAILGUN;
		}
	}

	if (!(comboOwner.weapons & DOE_LAVA_SUPER_NAILGUN))
	{
		if (comboOwner.ammo_lava_nails > 0 && (comboOwner.weapons & IT_SUPER_NAILGUN))
		{
			sprint (comboOwner, "Super Lava Nails Enabled\n");
			newweapon = DOE_LAVA_SUPER_NAILGUN;	
		}
	}

	if (!(comboOwner.weapons & DOE_MULTI_GRENADE))
	{
		if (comboOwner.ammo_multi_rockets > 0 && comboOwner.weapons & (IT_GRENADE_LAUNCHER | IT_PROXIMITY_GUN))
		{
			sprint (comboOwner, "Multi-Grenades Enabled\n");
			newweapon = DOE_MULTI_GRENADE;		
		}
	}

	if (!(comboOwner.weapons & DOE_MULTI_ROCKET))
	{
		if (comboOwner.ammo_multi_rockets > 0 && (comboOwner.weapons & IT_ROCKET_LAUNCHER))
		{
			sprint (comboOwner, "Multi-Rockets Enabled\n");
			newweapon = DOE_MULTI_ROCKET;	
		}
	}

	if (!(comboOwner.weapons & DOE_PLASMA_GUN))
	{
		if (comboOwner.ammo_plasma > 0 && (comboOwner.weapons & IT_LIGHTNING))
		{
			sprint (comboOwner, "Plasma Rockets Enabled\n");
			newweapon = DOE_PLASMA_GUN;		
		}
	}
	
	comboOwner.weapons |= newweapon;
};

/*
=============
weapon_touch
=============
*/
float() weapon_customizeentityforclient =
{
	if (self.weapon_pickedup[other.colormap] == TRUE) 
	{
//		self.alpha = 0;
		self.dimension_seen = 0;
		return FALSE;
	}
	
	self.alpha = 1;
	self.dimension_seen = 1;
	self.weapon_pickedup[other.colormap] = FALSE;
	return TRUE;
};

float() W_BestWeapon;

void() weapon_touch =
{
	if (other.netname == "[overseer]-BOT") return; // Phantom Server Bot
	if (other.health <= 0 || (!(other.flags & FL_CLIENT))) return;	
	if (initiate_matchtime == FALSE && cvar("deathmatch")) return;	
		
	if (!self.cnt_trig)
	{
		if (mapname == "mgend") 
		{
			if (self.classname == "weapon_lightning" && self.target == "boss_relay") // Sleeper: A hack to keep Chthon from going back into the lava in mg1 when players grab the LG.
			{
				activator = other;
				SUB_UseTargets ();
				self.cnt_trig = 1; // Moved this down to be detected by the trigger.
			}
			else	
			{
				self.cnt_trig = 1;
				activator = other;
				SUB_UseTargets ();	
			}			
		}
		if (mapname != "mgend")
		{
			self.cnt_trig = 1;
			activator = other;
			SUB_UseTargets ();	
		}
	}

	if (self.weapon_lockout_selective == 1) // Choose when an ammo pack can be locked out from being picked up again from a player during coop.
	{	
		if (coop & REIGNITED_COOP || coop & ENHANCED_COOP)
		{
			if (self.weapon_lockout[other.colormap] == -1) return; // Lockout
		}
	}
	
	if (other.weapons & self.weapon)
	{
		if (coop & CLASSIC_COOP) return;
		if (deathmatch >= DM_FFA && deathmatch <= DM_OneFlagCTF) return;
		if (!CheckAmmoPickup(other, self.aflag)) return;
	}
	
	EnableComboWeapons (other);	
		
	if (coop & REIGNITED_COOP || coop & ENHANCED_COOP) self.weapon_lockout_selective = 1;
		
	local entity o = self;	
	self = other;
	GiveWeapon (o, self);
			
	UpdateAmmoCounts (self);	
	
	self = o;
							
	if (deathmatch == DM_DUEL)
	{
		self.nextthink = time + 30;
		self.think = SUB_regen;
	}				

	activator = other;
	SUB_UseTargets(); // Fire all Targets / Killtargets
	
	if (coop & CLASSIC_COOP) return;
	if (deathmatch >= DM_FFA && deathmatch <= DM_OneFlagCTF) return;	
	
	self.weapon_pickedup[other.colormap] = 1;	

	if (!self.weapon_lockout_selective) 
	{
		self.model = string_null;
		self.solid = SOLID_NOT;
	}				
	if (self.weapon_lockout_selective == 1) self.weapon_lockout[other.colormap] = -1; // Lockout weapon		
		
	other.nqwSpeakItem (other, self);	
	
	if (self.weapon_pickedup[other.colormap] == 1 && !deathmatch && coop == REIGNITED_COOP) self.customizeentityforclient = weapon_customizeentityforclient; // Sleeper: Visually despawn the weapon for one player. (other.colormap is the player, self is the weapon)
};

/*QUAKED weapon_supershotgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_supershotgun =
{
	if (cvar("instagib"))
	{
		remove (self);
		return;
	}

	precache_model ("progs/g_shot.mdl");
	setmodel (self, "progs/g_shot.mdl");
	self.weapon = IT_SUPER_SHOTGUN;
	self.aflag = IT_SHELLS;
	self.cnt = 5;
	self.netname = "Double-barrelled Shotgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_nailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_nailgun =
{
	if (cvar("instagib"))
	{
		remove (self);
		return;
	}

	precache_model ("progs/g_nail.mdl");
	setmodel (self, "progs/g_nail.mdl");
	self.weapon = IT_NAILGUN;
	self.aflag = IT_NAILS;
	self.cnt = 30;
	self.netname = "Nailgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_supernailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_supernailgun =
{
	if (cvar("instagib"))
	{
		remove (self);
		return;
	}

	precache_model ("progs/g_nail2.mdl");
	setmodel (self, "progs/g_nail2.mdl");
	self.weapon = IT_SUPER_NAILGUN;
	self.aflag = IT_NAILS;
	self.cnt = 30;
	self.netname = "Super Nailgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_grenadelauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_grenadelauncher =
{
	if (cvar("instagib"))
	{
		remove (self);
		return;
	}

	precache_model ("progs/g_rock.mdl");
	setmodel (self, "progs/g_rock.mdl");
	self.weapon = IT_GRENADE_LAUNCHER;
	self.aflag = IT_ROCKETS;
	self.cnt = 5;
	self.netname = "Grenade Launcher";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_rocketlauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_rocketlauncher =
{
	if (cvar("instagib"))
	{
		remove (self);
		return;
	}

	precache_model ("progs/g_rock2.mdl");
	setmodel (self, "progs/g_rock2.mdl");
	self.weapon = IT_ROCKET_LAUNCHER;
	self.aflag = IT_ROCKETS;
	self.cnt = 5;
	self.netname = "Rocket Launcher";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_lightning (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_lightning =
{	
	if (cvar("instagib"))
	{
		remove (self);
		return;
	}
	
	precache_model ("progs/g_light.mdl");
	setmodel (self, "progs/g_light.mdl");
	self.weapon = IT_LIGHTNING;
	self.aflag = IT_CELLS;
	self.cnt = 15;
	self.netname = "Thunderbolt";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*
===============================================================================

AMMO

===============================================================================
*/

float() ammo_customizeentityforclient =
{
	if (self.ammo_pickedup[other.colormap] == TRUE) 
	{
//		self.alpha = 0;
		self.dimension_seen = 0;
		return FALSE;
	}
	
	self.alpha = 1;
	self.dimension_seen = 1;
	self.ammo_pickedup[other.colormap] = FALSE;
	return TRUE;
};

void() ammo_touch =
{
	local float prev_ammo, picked_amount;

	if (other.health <= 0) return;
	if (other.classname != "player") return;
	if (initiate_matchtime == FALSE && cvar("deathmatch")) return;					
		
	if (!self.cnt_trig)
	{
		self.cnt_trig = 1;
		activator = other;
		SUB_UseTargets();
	}	
	
	if (self.ammo_lockout_selective == 1 && !cvar("customcoop")) // Choose when an ammo pack can be locked out from being picked up again from a player during coop.
	{	
		if (coop & REIGNITED_COOP || deathmatch)
		{
			if (self.ammo_lockout[other.colormap] == -1) return; // Lockout
		}
	}				
		
	if (!CheckAmmoPickup(other, self.aflag)) return;				

	// Sleeper: Needed for MG1. (Moved down to fix a bug where the player gets stored when running over an ammo box even when they're full on that ammo type.
	// DOMA ===================================================
	#ifdef COOP_RESPAWN_ITEMS_FOR_PLAYERS
	if (coop & CLASSIC_COOP && other == self.enemy && self.wait <= 0) return; // In coop, don't allow the same player to pick up all the respawns.
	if (coop & CLASSIC_COOP && gameworld == MG1) self.enemy = other;		// Store this player for coop
	if (coop & ENHANCED_COOP && other == self.enemy && self.wait <= 0) return; // In coop, don't allow the same player to pick up all the respawns.
	if (coop & ENHANCED_COOP) self.enemy = other;		// Store this player for coop				
	if (self.ammo_lockout_selective == 1 && other == self.enemy && self.wait <= 0 && cvar("customcoop")) // Choose when an ammo pack can be locked out from being picked up again from a player during coop.
	{	
		if (coop & REIGNITED_COOP || coop & CLASSIC_COOP || coop & ENHANCED_COOP || deathmatch)
		{
			if (self.ammo_lockout[other.colormap] == -1) return; // Lockout
		}
	}	
	#endif
	// ========================================================
	
	self.ammo_pickedup[other.colormap] = 1;
		
	// Sleeper: Courtesy of Alkaline. This calculates the delta between the amount of ammo picked up and the particular ammo's inventory cap.
	// Shells
	if (self.weapon == 1) 
	{
		if (other.ammo_shells >= 100) return;
		prev_ammo = other.ammo_shells;	
		other.ammo_shells += self.cnt;
		bound_other_ammo();
		picked_amount = other.ammo_shells - prev_ammo;
	}
	// Spikes
	if (self.weapon == 2) 
	{
		if (other.ammo_nails >= 200) return;
		prev_ammo = other.ammo_nails;
		other.ammo_nails += self.cnt;
		bound_other_ammo();
		picked_amount = other.ammo_nails - prev_ammo;
	}
	// Rockets
	if (self.weapon == 3) 
	{
		if (other.ammo_rockets >= 100) return;
		prev_ammo = other.ammo_rockets;
		other.ammo_rockets += self.cnt;
		bound_other_ammo();
		picked_amount = other.ammo_rockets - prev_ammo;
	}
	// Cells
	if (self.weapon == 4) 
	{
		if (other.ammo_cells >= 100) return;
		prev_ammo = other.ammo_cells;
		other.ammo_cells += self.cnt;
		bound_other_ammo();
		picked_amount = other.ammo_cells - prev_ammo;
	}
	// Lava Spikes	
	if (self.weapon == 5)			
	{
		if (other.ammo_lava_nails >= 200) return;
		prev_ammo = other.ammo_lava_nails;
		other.ammo_lava_nails += self.cnt;
		bound_other_ammo();
		picked_amount = other.ammo_lava_nails - prev_ammo;
		other.ammo_lava_nails = prev_ammo; // Sleeper: Hack the ammo, so it doesn't double.
	}
	// Multi-Rockets
	if (self.weapon == 6)
	{
		if (other.ammo_multi_rockets >= 100) return;
		prev_ammo = other.ammo_multi_rockets;
		other.ammo_multi_rockets += self.cnt;
		bound_other_ammo();
		picked_amount = other.ammo_multi_rockets - prev_ammo;
		other.ammo_multi_rockets = prev_ammo; // Sleeper: Hack the ammo, so it doesn't double.
	}
	// Plasma-Rockets
	if (self.weapon == 7)
	{
		if (other.ammo_plasma >= 100) return;
		prev_ammo = other.ammo_plasma;
		other.ammo_plasma += self.cnt;
		bound_other_ammo();
		picked_amount = other.ammo_plasma - prev_ammo;
		other.ammo_plasma = prev_ammo; // Sleeper: Hack the ammo, so it doesn't double.
	}				 				
	AddAmmo(other, self.aflag, self.cnt);	
	
	// Sleeper: Needed for MG1.
	// DOMA ===================================================
	#ifdef COOP_RESPAWN_ITEMS_FOR_PLAYERS
	if (coop & REIGNITED_COOP && other == self.enemy && self.wait <= 0) return; // In coop, don't allow the same player to pick up all the respawns.
	if (coop & REIGNITED_COOP && mapname == "mgend" && self.classname == "item_cells" && self.target == "cells_relay" && self.origin == '1008 -16 256') self.enemy = other;	// Store this player for coop
	#endif
	// ========================================================			
	
	local string s;
	
	// Sleeper: Make words plural or not plural when sending client prints texts and specify what size ammo box was picked up, what ammo type and how much was actually picked up if capacity for that ammo type were reached.
	if (picked_amount != 1)
	{
		if (self.netname != "plasma") s = "s";
		else s = "-rockets";
	}
	else if (picked_amount == 1)
	{
		if (self.netname == "plasma") s = "-rocket";
	}
	
	if (self.netname != "plasma")
	{
		if (self.spawnflags & WEAPON_BIG2) sprint (other, "You picked up a large box of ", self.netname, "s ");
		else sprint (other, "You picked up a small box of ", self.netname, "s ");		
	}
	else if (self.netname == "plasma")
	{
		if (self.spawnflags & WEAPON_BIG2) sprint (other, "You picked up a large box of ", self.netname, "-rockets ");
		else sprint (other, "You picked up a small box of ", self.netname, "-rockets ");			
	}
	sprint (other, "(+", ftos(picked_amount), " ", self.netname, s, ")\n");
		
	// ammo touch sound
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
		
	local entity o = self;
	self = other;
		
	EnableComboWeapons (other);
	UpdateAmmoCounts (other);	
	W_SetCurrentAmmo();
		
	self = o;	

	// MG1 --------------------------------------------------------------------------------------------------------
	#ifdef COOP_RESPAWN_ITEMS_FOR_PLAYERS
	// Sleeper: Respawnable items in coop 2 is only available in MG1 maps.
	if (coop & CLASSIC_COOP && gameworld == MG1 && !cvar("customcoop") && self.wait <= 0) // Wait overrides coop respawn behaviour
	{
		self.cnt_mg1++;		
		if (self.cnt_mg1 < num_players) // Not been picked up by all players yet.
		{
			self.nextthink = time + 1; 
			self.think = SUB_regen; // Respawn almost immediately
		}
		else
		{
			self.enemy = world;
			self.cnt_mg1 = 0;
			self.nextthink = time + (4 * 60);
			self.think = SUB_regen; // Respawn after 4 mins in case the players get stuck on something hard.
		}
	}
	if (coop & ENHANCED_COOP && !cvar("customcoop") && self.wait <= 0) // Wait overrides coop respawn behaviour
	{
		self.cnt_mg1++;		
		if (self.cnt_mg1 < num_players) // Not been picked up by all players yet.
		{
			self.nextthink = time + 1; 
			self.think = SUB_regen; // Respawn almost immediately
		}
		else
		{
			self.enemy = world;
			self.cnt_mg1 = 0;
			self.nextthink = time + (4 * 60);
			self.think = SUB_regen; // Respawn after 4 mins in case the players get stuck on something hard.
		}
	}	
	else if (coop)
	{
		if (cvar("customcoop") && self.wait <= 0)
		{
			self.cnt_mg1++;	
			if (coop & REIGNITED_COOP)
			{	
				if (self.cnt_mg1 < num_players)
				{
					self.alpha =  0.5;
					self.enemy = other;
				}		
				else
				{
					self.alpha = 1;
					self.enemy = world;
					self.cnt_mg1 = 0;
					self.nextthink = time + 20;
					self.think = SUB_regen; // Respawn after 20 seconds		
				}
			}
			else if (coop & CLASSIC_COOP || coop & ENHANCED_COOP)
			{
				self.enemy = world;
				self.cnt_mg1 = 0;
				self.nextthink = time + 20;
				self.think = SUB_regen; // Respawn after 20 seconds	
			}			
		}
	}		
	else if (deathmatch)
	// -------------------------------------------------------------------------------------------------------------	
	#endif				
	{
		if (deathmatch >= DM_DUEL && deathmatch <= DM_OneFlagCTF)
		{
			self.nextthink = time + 30;
			self.think = SUB_regen;
		}
	}
	else if (coop & CLASSIC_COOP && gameworld == MG1)	
	{
	        if (self.wait)
		{
			self.enemy = world;
			self.nextthink = time + self.wait;
		}
	}
	else if (coop & ENHANCED_COOP)	
	{
	        if (self.wait)
		{
			self.enemy = world;
			self.nextthink = time + self.wait;
		}
	}			
	else if (coop & CLASSIC_COOP && cvar("customcoop"))
	{
	        if (self.wait)
		{
			self.enemy = world;
			self.nextthink = time + self.wait;
		}
	}
	else if (coop & ENHANCED_COOP && cvar("customcoop"))
	{
	        if (self.wait)
		{
			self.enemy = world;
			self.nextthink = time + self.wait;
		}
	}		
							
	activator = other;
	SUB_UseTargets(); // Fire: All targets/Killtargets	
	
	// Sleeper: Hack to keep this item respawnable.
	if (mapname == "mgend" && self.classname == "item_cells" && self.target == "cells_relay")
	{
		self.nextthink = time + 12;
		self.think = SUB_regen;		
	}			
	
	// Select when to keep an ammo pack in the map without despawning it or despawn the ammo pack from the map.
	if (coop || deathmatch)
	{
		if (mapname == "mgend" && self.classname == "item_cells" && self.target == "cells_relay") self.ammo_lockout_selective = 0;
		else
		{
			if (coop & REIGNITED_COOP)
			{
				if (!cvar("customcoop"))
				{
					self.alpha = 0.5;
					self.ammo_lockout_selective = 1;
				}
				else
				{				
					if (self.enemy == other) 
					{
						self.alpha = 0.5;
						self.ammo_lockout_selective = 1;
					}
					else
					{
						self.alpha = 1;
						self.ammo_lockout_selective = 0;
					}
				}				
			} 		
			else self.ammo_lockout_selective = 0;
		}
	}
			
	// Sleeper: Hacking ammo packs in secret areas of Horde maps in Reignited Coop to stay spawned for other players to pick up.
	if (cvar("horde"))
	{
		if (mapname == "horde2")
		{
			if (self.classname == "item_spikes")
			{
				if (self.origin == '-752 736 128' || self.origin == '-616 736 128')
				{
					self.alpha = 0.5;
					self.ammo_lockout_selective = 1;				
				}
			}
			else if (self.classname == "item_cells")
			{
				if (self.origin == '592 -736 128' || self.origin == '720 -736 128')
				{
					self.alpha = 0.5;
					self.ammo_lockout_selective = 1;				
				}
			}
			else self.ammo_lockout_selective = 0;	
		}		
		else if (mapname == "horde3")
		{
			if (self.classname == "item_spikes" && self.origin == '-16 -112 1536' || self.classname == "item_rockets" && self.origin == '-16 -112 1536')
			{
				self.alpha = 0.5;
				self.ammo_lockout_selective = 1;				
			}
			else self.ammo_lockout_selective = 0;			
		}
		else if (mapname == "horde6")
		{
			if (self.classname == "item_shells")
			{
				if (self.origin == '-64 416 1024' || self.origin == '-64 320 1024' || self.origin == '32 416 1024' || self.origin == '32 320 1024')
				{
					self.alpha = 0.5;
					self.ammo_lockout_selective = 1;
				}
			}
			else if (self.classname == "item_spikes")
			{
				if (self.origin == '-64 -448 1024' || self.origin == '-64 -352 1024' || self.origin == '32 -352 1024' || self.origin == '32 -448 1024')
				{
					self.alpha = 0.5;
					self.ammo_lockout_selective = 1;
				}
			}			
			else if (self.classname == "item_rockets")
			{
				if (self.origin == '416 40 1024' || self.origin == '416 -56 1024' || self.origin == '320 40 1024' || self.origin == '320 -56 1024')
				{
					self.alpha = 0.5;
					self.ammo_lockout_selective = 1;				
				}
			}			
			else if (self.classname == "item_cells")
			{
				if (self.origin == '-448 32 1024' || self.origin == '-448 -64 1024' || self.origin == '-352 -64 1024' || self.origin == '-352 32 1024')
				{
					self.alpha = 0.5;
					self.ammo_lockout_selective = 1;				
				}
			}
			else self.ammo_lockout_selective = 0;						
		}			
		else self.ammo_lockout_selective = 0;
	}	
	
	if (!self.ammo_lockout_selective) 
	{
		self.model = string_null;
		self.solid = SOLID_NOT;
	}
					
	if (self.ammo_lockout_selective == 1) self.ammo_lockout[other.colormap] = -1; // Lockout ammo boxes		

	if (self.ammo_pickedup[other.colormap] == 1 && !deathmatch && coop == REIGNITED_COOP) self.customizeentityforclient = ammo_customizeentityforclient;
};

float WEAPON_BIG2 = 1;

/*QUAKED item_shells (0 .5 .8) (0 0 0) (32 32 32) big
Small box is 20, Big box is 40.
*/
void() item_shells =
{
	if (cvar("instagib"))
	{
		remove (self);
		return;
	}
	
	self.touch = ammo_touch;
	self.aflag = IT_SHELLS;
	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_shell1.bsp");
		setmodel (self, "maps/b_shell1.bsp");
		self.cnt = 40;
	}
	else
	{
		precache_model ("maps/b_shell0.bsp");
		setmodel (self, "maps/b_shell0.bsp");
		self.cnt = 20;
	}
	self.weapon = 1;
	self.netname = "shell";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};


/*QUAKED item_spikes (0 .5 .8) (0 0 0) (32 32 32) big
Small box is 25, Big box is 50.
*/
void() item_spikes =
{
	if (cvar("instagib"))
	{
		remove (self);
		return;
	}

	self.touch = ammo_touch;
	self.aflag = IT_NAILS;
	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_nail1.bsp");
		setmodel (self, "maps/b_nail1.bsp");
		self.cnt = 50;
	}
	else
	{
		precache_model ("maps/b_nail0.bsp");
		setmodel (self, "maps/b_nail0.bsp");
		self.cnt = 25;
	}
	self.weapon = 2;
	self.netname = "nail";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

/*QUAKED item_lava_spikes (0 .5 .8) (0 0 0) (32 32 32) big
Small box is 25, Big box is 50.
*/
void() item_lava_spikes =
{
	if (cvar("instagib") || deathmatch == DM_DUEL)
	{
		remove (self);
		return;
	}

	self.touch = ammo_touch;
	self.aflag = DOE_LAVA_NAILS;
	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_lnail1.bsp");
		setmodel (self, "maps/b_lnail1.bsp");
		self.cnt = 50;
	}
	else
	{
		precache_model ("maps/b_lnail0.bsp");
		setmodel (self, "maps/b_lnail0.bsp");
		self.cnt = 25;
	}
	self.weapon = 5;
	self.netname = "lava nail";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

/*QUAKED item_rockets (0 .5 .8) (0 0 0) (32 32 32) big
Small box is 5, Big box is 10.
*/
void() item_rockets =
{
	if (cvar("instagib"))
	{
		remove (self);
		return;
	}

	self.touch = ammo_touch;
	self.aflag = IT_ROCKETS;
	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_rock1.bsp");
		setmodel (self, "maps/b_rock1.bsp");
		self.cnt = 10;
	}
	else
	{
		precache_model ("maps/b_rock0.bsp");
		setmodel (self, "maps/b_rock0.bsp");
		self.cnt = 5;
	}
	self.weapon = 3;
	self.netname = "rocket";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

/*QUAKED item_multi_rockets (0 .5 .8) (0 0 0) (32 32 32) big
Small box is 5, Big box is 10.
*/
void() item_multi_rockets =
{
	if (cvar("instagib") || deathmatch == DM_DUEL)
	{
		remove (self);
		return;
	}

	self.touch = ammo_touch;
	self.aflag = DOE_MULTI_ROCKETS;
	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_mrock1.bsp");
		setmodel (self, "maps/b_mrock1.bsp");
		self.cnt = 10;
	}
	else
	{
		precache_model ("maps/b_mrock0.bsp");
		setmodel (self, "maps/b_mrock0.bsp");
		self.cnt = 5;
	}
	self.weapon = 6;
	self.netname = "multi-rocket";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

/*QUAKED item_cells (0 .5 .8) (0 0 0) (32 32 32) big
Small box is 6, Big box is 12.
*/
void() item_cells =
{
	if (cvar("instagib"))
	{
		remove (self);
		return;
	}
	
	self.touch = ammo_touch;
	self.aflag = IT_CELLS;
	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_batt1.bsp");
		setmodel (self, "maps/b_batt1.bsp");
		self.cnt = 12;
	}
	else
	{
		precache_model ("maps/b_batt0.bsp");
		setmodel (self, "maps/b_batt0.bsp");
		self.cnt = 6;
	}
	self.weapon = 4;
	self.netname = "cell";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

/*QUAKED item_plasma (0 .5 .8) (0 0 0) (32 32 32) big
Small box is 6, Big box is 12.
*/
void() item_plasma =
{
	if (cvar("instagib") || deathmatch == DM_DUEL)
	{
		remove (self);
		return;
	}

	self.touch = ammo_touch;
	self.aflag = DOE_PLASMA_AMMO;
	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_plas1.bsp");
		setmodel (self, "maps/b_plas1.bsp");
		self.cnt = 12;
	}
	else
	{
		precache_model ("maps/b_plas0.bsp");
		setmodel (self, "maps/b_plas0.bsp");
		self.cnt = 6;
	}
	self.weapon = 7;
	self.netname = "plasma";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

/*QUAKED item_weapon (0 .5 .8) (0 0 0) (32 32 32) shotgun rocket spikes big
DO NOT USE THIS!!!! IT WILL BE REMOVED!
*/
float WEAPON_SHOTGUN = 1;
float WEAPON_ROCKET = 2;
float WEAPON_SPIKES = 4;
float WEAPON_BIG = 8;
void() item_weapon =
{
	self.touch = ammo_touch;
	if (self.spawnflags & WEAPON_SHOTGUN)
	{
		self.aflag = IT_SHELLS;
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_shell1.bsp");
			setmodel (self, "maps/b_shell1.bsp");
			self.cnt = 40;
		}
		else
		{
			precache_model ("maps/b_shell0.bsp");
			setmodel (self, "maps/b_shell0.bsp");
			self.cnt = 20;
		}
		self.weapon = 1;
		self.netname = "shell";
	}
	else if (self.spawnflags & WEAPON_SPIKES)
	{
		self.aflag = IT_NAILS;
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_nail1.bsp");
			setmodel (self, "maps/b_nail1.bsp");
			self.cnt = 50;
		}
		else
		{
			precache_model ("maps/b_nail0.bsp");
			setmodel (self, "maps/b_nail0.bsp");
			self.cnt = 25;
		}
		self.weapon = 2;
		self.netname = "nail";
	}
	else if (self.spawnflags & WEAPON_ROCKET)
	{
		self.aflag = IT_ROCKETS;
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_rock1.bsp");
			setmodel (self, "maps/b_rock1.bsp");
			self.cnt = 10;
		}
		else
		{
			precache_model ("maps/b_rock0.bsp");
			setmodel (self, "maps/b_rock0.bsp");
			self.cnt = 5;
		}
		self.weapon = 3;
		self.netname = "rocket";
	}

	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

/*
===============================================================================

KEYS

===============================================================================
*/

void() key_touch =
{
	local entity all_players;

	if (other.netname == "[overseer]-BOT") return;
	if (other.classname != "player") return;
	if (other.health <= 0) return;
	if (other.items & self.items) return;
	if (initiate_matchtime == FALSE && cvar("deathmatch")) return;	

	sprint (other, "You have obtained the ", self.netname, "\n");
	stuffcmd (other, "bf\n");
	
//	if (cvar("coop")) self.coop_key_pickup = 1;
					
	if (!cvar("customcoop"))
	{ 		
//		sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
		if (cvar("coop") == REIGNITED_COOP || cvar("coop") == ENHANCED_COOP) // Sleeper: Conveniently give all players the key if one of the players obtains it.
		{
			dprint ("Keys are shared\n");
			sound (other, CHAN_ITEM, self.noise, 1, ATTN_NONE);
			all_players = find (world, classname, "player"); 	
			while (all_players)
			{						
				all_players.items |= self.items;
				all_players.keytaker = self; 	
				if (all_players != other) // Display a centerprint to players that don't have the key yet.
				{
					if ((all_players.items & other.items) == other.items) sprint (all_players, other.netname, " has obtained the ", self.netname, "\n");
				}			
				all_players = find (all_players, classname, "player");					
			}
		}
		else 
		{
			if (cvar("coop") == CLASSIC_COOP) // Sleeper: Each player will have to fetch the key themselves.
			{
				sound (other, CHAN_ITEM, self.noise, 1, ATTN_NONE);
				all_players = find (world, classname, "player"); 	
				while (all_players)
				{	
					all_players.keytaker = self; 						
					if (all_players != other) // Display a centerprint to players that don't have the key yet.
					{
						if ((all_players.items & other.items) == other.items) sprint (all_players, other.netname, " has obtained the ", self.netname, "\n");
					}			
					all_players = find (all_players, classname, "player");					
				}
			}
			else sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
			dprint ("Keys are not shared\n");	
			other.items |= self.items;
		}
	}
	else
	{	
		// Sleeper: Conveniently give all players the key if one of the players obtains it.
		dprint ("Keys are shared\n");
		sound (self, CHAN_ITEM, self.noise, 1, ATTN_NONE); // Set to "self" to give some sorts of sense of direction if someone were to pick it up. Set to "ATTN_NONE" so everyone can hear it being picked up.			
		all_players = find (world, classname, "player"); 	
		while (all_players)
		{	
			all_players.keytaker = self; 						
			all_players.items |= self.items;
			if (all_players != other) // Display a centerprint to players that don't have the key yet.
			{
				if ((all_players.items & other.items) == other.items) sprint (all_players, other.netname, " has obtained the ", self.netname, "\n");
			}			
			all_players = find (all_players, classname, "player");					
		}
	}
	
	if (cvar("coop") != CLASSIC_COOP) 
	{
		self.solid = SOLID_NOT;
		self.model = string_null;
	}	

	activator = other;
	SUB_UseTargets ();				// fire all targets / killtargets
	
	if (world.model == "maps/hip3m1.bsp" && other.nqwCharacter == NQW_DUKENUKEM && !other.onetime_line && self.items == IT_KEY1)
	{
		sound (other, CHAN_VOICE, "duke/seemydickfromhere.wav", 1, ATTN_NORM);	
		other.onetime_line = 1;
		other.nqwTauntTimer = time + 6;
	}
};

void() key_setsounds =
{
	if (world.worldtype == 0)
	{
		precache_sound ("misc/medkey.wav");
		self.noise = "misc/medkey.wav";
	}
	if (world.worldtype == 1)
	{
		precache_sound ("misc/runekey.wav");
		self.noise = "misc/runekey.wav";
	}
	if (world.worldtype == 2)
	{
		precache_sound2 ("misc/basekey.wav");
		self.noise = "misc/basekey.wav";
	}
};

/*QUAKED item_key1 (0 .5 .8) (-16 -16 -24) (16 16 32)
SILVER key
In order for keys to work
you MUST set your maps
worldtype to one of the
following:
0: medieval
1: metal
2: base
*/

void() item_key1 =
{
	if (cvar("instagib"))
	{
		remove (self);
		return;
	}

	if (world.worldtype == 0)
	{
		precache_model ("progs/w_s_key.mdl");
		setmodel (self, "progs/w_s_key.mdl");
		self.netname = "silver key";
	}
	if (world.worldtype == 1)
	{
		precache_model ("progs/m_s_key.mdl");
		setmodel (self, "progs/m_s_key.mdl");
		self.netname = "silver runekey";
	}
	if (world.worldtype == 2)
	{
		precache_model2 ("progs/b_s_key.mdl");
		setmodel (self, "progs/b_s_key.mdl");
		self.netname = "silver keycard";
	}
	key_setsounds();
	self.touch = key_touch;
	self.items = IT_KEY1;
	self.classname = "silver key";
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*QUAKED item_key2 (0 .5 .8) (-16 -16 -24) (16 16 32)
GOLD key
In order for keys to work
you MUST set your maps
worldtype to one of the
following:
0: medieval
1: metal
2: base
*/

void() item_key2 =
{
	if (cvar("instagib"))
	{
		remove (self);
		return;
	}

	if (world.worldtype == 0)
	{
		precache_model ("progs/w_g_key.mdl");
		setmodel (self, "progs/w_g_key.mdl");
		self.netname = "gold key";
	}
	if (world.worldtype == 1)
	{
		precache_model ("progs/m_g_key.mdl");
		setmodel (self, "progs/m_g_key.mdl");
		self.netname = "gold runekey";
	}
	if (world.worldtype == 2)
	{
		precache_model2 ("progs/b_g_key.mdl");
		setmodel (self, "progs/b_g_key.mdl");
		self.netname = "gold keycard";
	}
	key_setsounds();
	self.touch = key_touch;
	self.items = IT_KEY2;
	self.classname = "gold key";
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*
===============================================================================

END OF LEVEL RUNES

===============================================================================
*/
void() sigil_touch_mg1;

void() sigil_touch =
{	
	if (other.netname == "[overseer]-BOT") return;
	if (other.classname != "player") return;
	if (other.health <= 0) return;
	if (initiate_matchtime == FALSE && cvar("deathmatch")) return;	

	// MG1 ====================
	if (gameworld == MG1)
	{	
		sigil_touch_mg1 ();
		return;
	}
	// ========================	

	id1_centerprint (other, "You got the ", self.netname, "!\n");
	
	// Broadcast a centerprint to all players with the player's nickname added to the message, unless it's a single player game.
	if (coop >= REIGNITED_COOP)
	{
		local entity all_players = find (world, classname, "player");
		while (all_players)
		{	
//			all_players.playerrunes |= self.spawnflags & 15;
			if (all_players != other) id1_centerprint (all_players, other.netname, " got the\n", self.netname, "!\n");
			all_players = find (all_players, classname, "player");
		}
	}
	
	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	self.model = string_null;
	serverflags |= self.spawnflags & 15;
	self.classname = ""; // so rune doors won't find it

	activator = other;
	SUB_UseTargets ();   // fire all targets / killtargets
};


/*QUAKED item_sigil (0 .5 .8) (-16 -16 -24) (16 16 32) E1 E2 E3 E4
End of level sigil, pick up to end episode and return to jrstart.
*/
void() item_sigil_mg1;
void() item_sigil =
{
	if (cvar("instagib"))
	{
		remove (self);
		return;
	}
	
	// MG1 ===================
	if (gameworld == MG1)
	{
		item_sigil_mg1 ();
		return;
	}
	// =======================
	
	if (!self.spawnflags) objerror ("no spawnflags");

	precache_sound ("misc/runekey.wav");
	self.noise = "misc/runekey.wav";
		
	self.netname = "Rune";
	if (self.spawnflags & 1)
	{
		precache_model ("progs/end1.mdl");
		setmodel (self, "progs/end1.mdl");
		self.netname = "Rune of Earth Magic";
	}
	if (self.spawnflags & 2)
	{
		precache_model2 ("progs/end2.mdl");
		setmodel (self, "progs/end2.mdl");
		self.netname = "Rune of Black Magic";
	}
	if (self.spawnflags & 4)
	{
		precache_model2 ("progs/end3.mdl");
		setmodel (self, "progs/end3.mdl");
		self.netname = "Rune of Hell Magic";
	}
	if (self.spawnflags & 8)
	{
		precache_model2 ("progs/end4.mdl");
		setmodel (self, "progs/end4.mdl");
		self.netname = "Rune of Elder Magic";
	}
		
	self.touch = sigil_touch;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*
===============================================================================

POWERUPS

===============================================================================
*/
void() powerup_touch;
void() random_regen;
.float storetime, fresh_powerup;
void() powerup_touch =
{
	if (other.netname == "[overseer]-BOT") return;
	if (other.classname != "player") return;
	if (other.health <= 0) return;
	if (initiate_matchtime == FALSE && cvar("deathmatch")) return;	
	
	if (!self.droppable_item) self.fresh_powerup = TRUE;
	else self.fresh_powerup = FALSE;	

	if (self.powerup_lockout_selective == 1) // Choose what powerup that can lockout a player from picking the same powerup again.
	{
		if (self.powerup_lockout[other.colormap] > time || self.powerup_lockout[other.colormap] == -1) return; // Lockout
	}	// Time + # is temporary lockout, -1 is permanent lockout.

	if (deathmatch && !coop)
	{
		self.mdl = self.model;

		if (self.classname == "item_artifact_invulnerability" || 
		    self.classname == "item_artifact_invisibility") self.nextthink = time + (5 * 60); // Respawn after 5 minutes.
		else self.nextthink = time + 60; // Respawn after a minute.

		self.think = SUB_regen;
	}
		
	if (coop == REIGNITED_COOP && !deathmatch) 
	{
		if (!cvar("customcoop") && !deathmatch)
		{
			if (self.classname == "item_artifact_envirosuit" && !self.droppable_item) self.powerup_lockout_selective = 1; // Sleeper: Let biosuit respawn an infinite amount of times, as it is a minor powerup to let other players gain access to water secrets easier.				
			if (world.model == "maps/e1m8.bsp" && self.classname == "item_artifact_invulnerability" && self.spawnflags != 256 && !self.droppable_item)
			{
				self.alpha = 0.45;
				self.powerup_lockout_selective = 1;							
			} // Sleeper: Although this is a major powerup, E1M8 will be an exception due to the Quad Secret hiding in the lava. Only one pentagram will be able to be obtained by all players in this map,
			  // but will be permanently locked out after picking it once to retain balance.
		}		
		else
		{				
			if (self.classname == "item_artifact_envirosuit" || 
			    self.classname == "item_artifact_invulnerability" ||
			    self.classname == "item_artifact_super_damage" || 
			    self.classname == "item_artifact_invisibility") self.powerup_lockout_selective = 1; // Sleeper: Major items get locked out longer than minor items to prevent overusages.																			
		}
	}
	
	if (coop == ENHANCED_COOP && !deathmatch) // Sleeper: To mirror Reignited Coop, but in the Enhanced Coop fashion.
	{	
		if (!cvar("customcoop") && !deathmatch)
		{		
			if (self.classname == "item_artifact_envirosuit" && !self.droppable_item) self.powerup_lockout_selective = 1; // Sleeper: Let biosuit respawn an infinite amount of times, as it is a minor powerup to let other players gain access to water secrets easier.	
			if (world.model == "maps/e1m8.bsp" && self.classname == "item_artifact_invulnerability" && self.spawnflags != 256 && !self.droppable_item)
			{
				if (self.wait <= 0)
				{
					self.cnt_mg1++;		
					if (self.cnt_mg1 < num_players && self.enemy != other) // Not been picked up by all players yet.
					{
						self.enemy = other;
						self.nextthink = time + 1; 
						self.think = SUB_regen; // Respawn almost immediately
					}
				}
				if (self.wait)
				{
					self.enemy = world;
					self.nextthink = time + self.wait;
				}						
			}
		}
		else
		{				
			if (self.classname == "item_artifact_envirosuit" || 
			    self.classname == "item_artifact_invulnerability" ||
			    self.classname == "item_artifact_super_damage" || 
			    self.classname == "item_artifact_invisibility") self.powerup_lockout_selective = 1; // Sleeper: Major items get locked out longer than minor items to prevent overusages.																			
		}						
	}

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	if (!self.powerup_lockout_selective) self.solid = SOLID_NOT;
	other.items |= self.items;
	if (!self.powerup_lockout_selective) self.model = string_null;	
	
	if (self.powerup_lockout_selective == 1)
	{
		if (!deathmatch)
		{
			if (!cvar("customcoop") && self.classname != "item_artifact_envirosuit") self.powerup_lockout[other.colormap] = -1;			
			else
			{
				if (self.classname == "item_artifact_envirosuit") self.powerup_lockout[other.colormap] = time + 5; // Short lockout time for biosuit.
				else self.powerup_lockout[other.colormap] = time + (2 * 60); // Prevent players from overusing major powerups in customcoop.
			}
		}
	}	

	local float seconds_left = rint (self.delay);

	// Do the apropriate action
	if (self.classname == "item_artifact_envirosuit")
	{
		other.rad_time = 1;
		
		// Sleeper: Don't need this, but it's good for consistent item behavior.
		if (other.radsuit_finished > time) self.storetime = other.radsuit_finished - time; // Sleeper: Store our current Quad timer for later.	
		
		if (self.droppable_item == 1) 
		{ 	
			// Sleeper: If we picked up a dropped pre-decayed Quad, make sure to add it's delay to the next Quad's pickup. Whether it was dropped, or an untouched Quad.
			if (other.radsuit_finished > time && self.fresh_powerup == TRUE) other.radsuit_finished = time + self.delay + self.storetime;
			else other.radsuit_finished = time + self.delay;
			
			if (other.radsuit_finished > time + 30) other.radsuit_finished = time + 30; // Sleeper: Don't overstack the timer.
		}		
		else other.radsuit_finished = time + 30;
		if (!self.droppable_item) sprint (other, "", "You got the ", self.netname, "\n");
		else
		{
			if (coop) sprint (other, "You recovered a fallen ally's decaying Biosuit ");
			else sprint (other, "You recovered a decaying Biosuit ");
			if (seconds_left >= 2)
			{
				sprint (other, "(", ftos(seconds_left), " seconds remaining)");
				sprint (other, "\n");
			}
			else
			{
				sprint (other, "(", ftos(seconds_left), " second remaining)");
				sprint (other, "\n");
			}
		}
	}
	if (self.classname == "item_artifact_invulnerability")
	{
		other.invincible_time = 1;	
		
		if (other.invincible_finished > time) self.storetime = other.invincible_finished - time; // Sleeper: Store our current Quad timer for later.	
			
		// MG1: Yoder Sept24 2021 Horde Merge
		if (horde_ent) other.invincible_finished = time + 5;
		else if (self.droppable_item == 1)
		{ 	
			// Sleeper: If we picked up a dropped pre-decayed Quad, make sure to add it's delay to the next Quad's pickup. Whether it was dropped, or an untouched Quad.
			if (other.invincible_finished > time && self.fresh_powerup == TRUE) other.invincible_finished = time + self.delay + self.storetime;
			else other.invincible_finished = time + self.delay;
			
			if (other.invincible_finished > time + 30) other.invincible_finished = time + 30; // Sleeper: Don't overstack the timer.
		}		
		else other.invincible_finished = time + 30;
		if (cvar("skill") <= 4)
		{
			if (!self.droppable_item)
			{
				if (other.super_time == 1 && other.invincible_time == 1) sprint (other, "", "Your reign of power has come!\n");
				else sprint (other, "", "You got the ", self.netname, "\n");
			}
			else
			{			
				if (other.super_time == 1 && other.invincible_time == 1) sprint (other, "", "Your reign of power has come! ");					
				else 
				{
					if (coop) sprint (other, "You recovered a fallen ally's decaying Pentagram of Protection ");
					else sprint (other, "You recovered a decaying Pentagram of Protection ");
					if (seconds_left >= 2)
					{
						sprint (other, "(", ftos(seconds_left), " seconds remaining)");
						sprint (other, "\n");
					}
					else
					{
						sprint (other, "(", ftos(seconds_left), " second remaining)");
						sprint (other, "\n");
					}					
				}				
			}			
		}
		else
		{
			if (!self.droppable_item)
			{
				if (other.super_time == 1 && other.invincible_time == 1)
				{
					if (other.nqwCharacter == NQW_SLEEPER) sprint (other, "", "You have become an Unstoppable Devilwalker!\n");
					else sprint (other, "", "Your reign of power has come!\n");
				}
				else sprint (other, "", "An unholy ward surrounds you!\n");
			}
			else
			{
				if (other.super_time == 1 && other.invincible_time == 1) sprint(other, "", "Your reign of power has come! ");					
				else 
				{
					if (coop) sprint (other, "You recovered a fallen ally's decaying Pentagram of Protection ");
					else sprint (other, "You recovered a decaying Pentagram of Protection ");
					if (seconds_left >= 2)
					{
						sprint (other, "(", ftos(seconds_left), " seconds remaining)");
						sprint (other, "\n");
					}
					else
					{
						sprint (other, "(", ftos(seconds_left), " second remaining)");
						sprint (other, "\n");
					}					
				}
			}			
		}		
	}
	if (self.classname == "item_artifact_invisibility")
	{
		other.invisible_time = 1;
		
		if (other.invisible_finished > time) self.storetime = other.invisible_finished - time; // Sleeper: Store our current Quad timer for later.	
		
		if (self.droppable_item == 1)
		{ 	
			// Sleeper: If we picked up a dropped pre-decayed Quad, make sure to add it's delay to the next Quad's pickup. Whether it was dropped, or an untouched Quad.
			if (other.invisible_finished > time && self.fresh_powerup == TRUE) other.invisible_finished = time + self.delay + self.storetime;
			else other.invisible_finished = time + self.delay;
			
			if (other.invisible_finished > time + 30) other.invisible_finished = time + 30; // Sleeper: Don't overstack the timer.
		}		
		else other.invisible_finished = time + 30;
		if (!self.droppable_item) sprint (other, "", "You got the ", self.netname, "\n");
		else
		{
			if (coop) sprint (other, "You recovered a fallen ally's decaying Ring of Shadows ");
			else sprint (other, "You recovered a decaying Ring of Shadows ");
			if (seconds_left >= 2)
			{
				sprint (other, "(", ftos(seconds_left), " seconds remaining)");
				sprint (other, "\n");
			}
			else
			{
				sprint (other, "(", ftos(seconds_left), " second remaining)");
				sprint (other, "\n");
			}
		}
	}
	if (self.classname == "item_artifact_super_damage")
	{						
		other.super_time = TRUE;	
		
		if (other.super_damage_finished > time) self.storetime = other.super_damage_finished - time; // Sleeper: Store our current Quad timer for later.	
		
		// MG1: Yoder Sept24 2021 Horde Merge
		if (horde_ent) other.super_damage_finished = time + 5;		
		else if (self.droppable_item == TRUE) 
		{ 	
			// Sleeper: If we picked up a dropped pre-decayed Quad, make sure to add it's delay to the next Quad's pickup. Whether it was dropped, or an untouched Quad.
			if (other.super_damage_finished > time && self.fresh_powerup == TRUE) other.super_damage_finished = time + self.delay + self.storetime;
			else other.super_damage_finished = time + self.delay;
			
			if (other.super_damage_finished > time + 30) other.super_damage_finished = time + 30; // Sleeper: Don't overstack the timer.
		}
		else other.super_damage_finished = time + 30;
		if (cvar("skill") <= 4)
		{
			if (!self.droppable_item)
			{
				if (other.super_time == TRUE && other.invincible_time == TRUE) sprint (other, "", "Your reign of power has come!\n");
				else sprint (other, "", "You got the ", self.netname, "\n");
			}
			else
			{			
				if (other.super_time == TRUE && other.invincible_time == TRUE) sprint (other, "", "Your reign of power has come! ");					
				else 
				{
					if (coop) sprint (other, "You recovered a fallen ally's decaying Quad Damage ");
					else sprint (other, "You recovered a decaying Quad Damage ");
					if (seconds_left >= 2)
					{
						sprint (other, "(", ftos(seconds_left), " seconds remaining)");
						sprint (other, "\n");
					}
					else
					{
						sprint (other, "(", ftos(seconds_left), " second remaining)");
						sprint (other, "\n");
					}					
				}
			}			
		}
		else
		{
			if (!self.droppable_item)
			{
				if (other.super_time == 1 && other.invincible_time == 1)
				{
					if (other.nqwCharacter == NQW_SLEEPER) sprint (other, "", "You have become an Unstoppable Devilwalker!\n");
					else sprint (other, "", "Your reign of power has come!\n");
				}
				else sprint (other, "", "You begin to channel an unstoppable power!\n");
			}
			else
			{
				if (other.super_time == 1 && other.invincible_time == 1) sprint(other, "", "Your reign of power has come! ");					
				else 
				{
					if (coop) sprint (other, "You recovered a fallen ally's decaying decaying Quad Damage ");
					else sprint (other, "You recovered a decaying decaying Quad Damage ");
					if (seconds_left >= 2)
					{
						sprint (other, "(", ftos(seconds_left), " seconds remaining)");
						sprint (other, "\n");
					}
					else
					{
						sprint (other, "(", ftos(seconds_left), " second remaining)");
						sprint (other, "\n");
					}					
				}
			}			
		}
	}	

	activator = other;
	SUB_UseTargets (); // Fire all Targets/Killtargets
	
	other.nqwSpeakItem (other, self);	
		
	if (self.droppable_item == 1) remove (self);
};

/*QUAKED item_artifact_invulnerability (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invulnerable for 30 seconds
*/
void() item_artifact_invulnerability =
{
	// Sleeper: Duels don't have powerups.
	if (cvar("instagib") || deathmatch == DM_DUEL)
	{
		remove (self);
		return;
	}
	
	self.touch = powerup_touch;
	precache_model ("progs/invulner.mdl");
	precache_sound ("items/protect.wav");
	precache_sound ("items/protect2.wav");
	precache_sound ("items/protect3.wav");
	self.noise = "items/protect.wav";
	setmodel (self, "progs/invulner.mdl");
	self.netname = "Pentagram of Protection";
	self.items = IT_INVULNERABILITY;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*QUAKED item_artifact_envirosuit (0 .5 .8) (-16 -16 -24) (16 16 32)
Player takes no damage from water or slime for 30 seconds
*/
void() item_artifact_envirosuit =
{
	// Sleeper: Duels don't have powerups.
	if (cvar("instagib") || deathmatch == DM_DUEL)
	{
		remove (self);
		return;
	}
	
	self.touch = powerup_touch;
	precache_model ("progs/suit.mdl");
	precache_sound ("items/suit.wav");
	precache_sound ("items/suit2.wav");
	self.noise = "items/suit.wav";
	setmodel (self, "progs/suit.mdl");
	self.netname = "Biosuit";
	self.items = IT_SUIT;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*QUAKED item_artifact_invisibility (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invisible for 30 seconds
*/
void() item_artifact_invisibility =
{
	// Sleeper: Duels don't have powerups.
	if (cvar("instagib") || deathmatch == DM_DUEL)
	{
		remove (self);
		return;
	}
	
	self.touch = powerup_touch;
	precache_model ("progs/invisibl.mdl");
	precache_sound ("items/inv1.wav");
	precache_sound ("items/inv2.wav");
	precache_sound ("items/inv3.wav");
	self.noise = "items/inv1.wav";
	setmodel (self, "progs/invisibl.mdl");
	self.netname = "Ring of Shadows";
	self.items = IT_INVISIBILITY;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};


/*QUAKED item_artifact_super_damage (0 .5 .8) (-16 -16 -24) (16 16 32)
The next attack from the player will do 4x damage
*/
void() item_artifact_super_damage =
{
	// Sleeper: Duels don't have powerups.
	if (cvar("instagib") || deathmatch == DM_DUEL)
	{
		remove (self);
		return;
	}
	
	self.touch = powerup_touch;
	precache_model ("progs/quaddama.mdl");
	precache_sound ("items/damage.wav");
	precache_sound ("items/damage2.wav");
	precache_sound ("items/damage3.wav");
	self.noise = "items/damage.wav";
	setmodel (self, "progs/quaddama.mdl");
	self.netname = "Quad Damage";
	self.items = IT_QUAD;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*
===============================================================================

PLAYER BACKPACKS

===============================================================================
*/
void() BackpackTouch =
{
	if (other.netname == "[overseer]-BOT") return;
	if (other.health <= 0) return;
	if (other.classname != "player") return;
	if (initiate_matchtime == FALSE && cvar("deathmatch")) return;		
	
	// Nothing to pick up
	local float nopickup_weapons = (other.weapons & self.weapons) == self.weapons;
	if (nopickup_weapons)
	{
		nopickup_weapons &= (self.ammo_shells1 <= 0 || !CheckAmmoPickup(other, IT_SHELLS));
		if (nopickup_weapons)
		{
			nopickup_weapons &= (self.ammo_nails1 <= 0 || !CheckAmmoPickup(other, IT_NAILS));
			if (nopickup_weapons)
			{
				nopickup_weapons &= (self.ammo_rockets1 <= 0 || !CheckAmmoPickup(other, IT_ROCKETS));
				if (nopickup_weapons)
				{
					nopickup_weapons &= (self.ammo_cells1 <= 0 || !CheckAmmoPickup(other, IT_CELLS));
					if (nopickup_weapons)
					{
						nopickup_weapons &= (self.ammo_lava_nails <= 0 || !CheckAmmoPickup(other, DOE_LAVA_NAILS));
						if (nopickup_weapons)
						{
							nopickup_weapons &= (self.ammo_multi_rockets <= 0 || !CheckAmmoPickup(other, DOE_MULTI_ROCKETS));
							if (nopickup_weapons) nopickup_weapons &= (self.ammo_plasma <= 0 || !CheckAmmoPickup(other, DOE_PLASMA_AMMO));
						}
					}
				}	
			}
		}
	}	
	
	if (nopickup_weapons) return;	
									
	other.items |= self.items;
	other.weapons |= self.weapons;
	
	local float prev_ammo_shell, prev_ammo_nail, prev_ammo_rocket, prev_ammo_cell;
	local float prev_ammo_lava_nail, prev_ammo_multi_rocket, prev_ammo_plasma; // ROGUE
	
	local float picked_amount_shell, picked_amount_nail, picked_amount_rocket, picked_amount_cell;
	local float picked_amount_lava_nail, picked_amount_multi_rocket, picked_amount_plasma; // ROGUE
	
	// Shells
	prev_ammo_shell = other.ammo_shells1;	
	other.ammo_shells1 += self.ammo_shells1;
	bound_other_ammo();
	picked_amount_shell = other.ammo_shells1 - prev_ammo_shell;
	other.ammo_shells1 = prev_ammo_shell; // Set it back, so ammo doesn't double.
	
	// Nails
	prev_ammo_nail = other.ammo_nails1;	
	other.ammo_nails1 += self.ammo_nails1;
	bound_other_ammo();
	picked_amount_nail = other.ammo_nails1 - prev_ammo_nail;	
	other.ammo_nails1 = prev_ammo_nail; // Set it back, so ammo doesn't double.

	// Rockets
	prev_ammo_rocket = other.ammo_rockets1;	
	other.ammo_rockets1 += self.ammo_rockets1;
	bound_other_ammo();
	picked_amount_rocket = other.ammo_rockets1 - prev_ammo_rocket;
	other.ammo_rockets1 = prev_ammo_rocket; // Set it back, so ammo doesn't double.
	
	// Cells
	prev_ammo_cell = other.ammo_cells1;	
	other.ammo_cells1 += self.ammo_cells1;
	bound_other_ammo();
	picked_amount_cell = other.ammo_cells1 - prev_ammo_cell;
	other.ammo_cells1 = prev_ammo_cell; // Set it back, so ammo doesn't double.

	// Lava Nails
	prev_ammo_lava_nail = other.ammo_lava_nails;	
	other.ammo_lava_nails += self.ammo_lava_nails;
	bound_other_ammo();
	picked_amount_lava_nail = other.ammo_lava_nails - prev_ammo_lava_nail;
	other.ammo_lava_nails = prev_ammo_lava_nail; // Set it back, so ammo doesn't double.

	// Multi-Rockets
	prev_ammo_multi_rocket = other.ammo_multi_rockets;	
	other.ammo_multi_rockets += self.ammo_multi_rockets;
	bound_other_ammo();
	picked_amount_multi_rocket = other.ammo_multi_rockets - prev_ammo_multi_rocket;
	other.ammo_multi_rockets = prev_ammo_multi_rocket; // Set it back, so ammo doesn't double.

	// Plasma-Rockets
	prev_ammo_plasma = other.ammo_plasma;	
	other.ammo_plasma += self.ammo_plasma;
	bound_other_ammo();
	picked_amount_plasma = other.ammo_plasma - prev_ammo_plasma;	
	other.ammo_plasma = prev_ammo_plasma; // Set it back, so ammo doesn't double.					
						 			
	AddAmmo (other, IT_SHELLS, self.ammo_shells1);	
	AddAmmo (other, IT_NAILS, self.ammo_nails1);	
	AddAmmo (other, IT_ROCKETS, self.ammo_rockets1);	
	AddAmmo (other, IT_CELLS, self.ammo_cells1);	
	// ROGUE REIGNITED -----------------------------------------	
	AddAmmo (other, DOE_LAVA_NAILS, self.ammo_lava_nails);	
	AddAmmo (other, DOE_MULTI_ROCKETS, self.ammo_multi_rockets);	
	AddAmmo (other, DOE_PLASMA_AMMO, self.ammo_plasma);
	// ---------------------------------------------------------
		
	local entity o = self;
	self = other;
	
	W_SetCurrentAmmo();
	
	self = o;
		
	if (!(self.ammo_shells1 + self.ammo_nails1 + self.ammo_rockets1 + self.ammo_cells1 + self.ammo_lava_nails + self.ammo_multi_rockets + self.ammo_plasma)) 
		sprint (other, "You picked up a backpack with a ", self.netname, " stored in it\n"); // Sleeper: When it's just the weapon.
	else
	{
	     // local float acount;
		local float weapons_in_backpack, ammo_in_backpack;
		
		sprint (other, "You picked up a backpack with ");			
		if (self.weapons & (IT_SUPER_SHOTGUN) ||
		    self.weapons & (IT_NAILGUN) ||
		    self.weapons & (IT_SUPER_NAILGUN)||
		    self.weapons & (IT_GRENADE_LAUNCHER) ||
		    self.weapons & (IT_ROCKET_LAUNCHER) || 
		    self.weapons & (IT_LIGHTNING) ||
		    self.weapons & (IT_PROXIMITY_GUN) ||
		    self.weapons & (IT_LASER_CANNON) ||
		    self.weapons & (IT_MJOLNIR)) weapons_in_backpack = 1;
		    
		if (picked_amount_shell > 0 && picked_amount_shell <= 100 || 
		    picked_amount_nail > 0 && picked_amount_nail <= 200 || 
		    picked_amount_rocket > 0 && picked_amount_rocket <= 100 ||
		    picked_amount_cell > 0 && picked_amount_cell <= 100 ||
		    picked_amount_lava_nail > 0 && picked_amount_lava_nail <= 200 ||
		    picked_amount_multi_rocket > 0 && picked_amount_multi_rocket <= 100 ||
		    picked_amount_plasma > 0 && picked_amount_plasma <= 100)
		{
			if (self.ammo_shells1 > 0 && other.ammo_shells1 <= 100 ||
			    self.ammo_nails1 > 0 && other.ammo_nails1 <= 200 || 
			    self.ammo_rockets1 > 0 && other.ammo_rockets1 <= 100 ||
			    self.ammo_cells1 > 0 && other.ammo_cells1 <= 100 ||
			    self.ammo_lava_nails > 0 && other.ammo_lava_nails <= 200 ||
			    self.ammo_multi_rockets > 0 && other.ammo_multi_rockets <= 100 ||
			    self.ammo_plasma > 0 && other.ammo_plasma <= 100) ammo_in_backpack = 1;
		}
		
		if (weapons_in_backpack == 1)
		{ 
			if (deathmatch)
			{ 
				if (self.weapons & (IT_SUPER_SHOTGUN)) sprint (other, "a Super Shotgun");
				if (self.weapons & (IT_NAILGUN)) sprint (other, "a Nailgun");
				if (self.weapons & (IT_SUPER_NAILGUN)) sprint (other, "a Super Nailgun");
				if (self.weapons & (IT_GRENADE_LAUNCHER)) sprint (other, "a Grenade Launcher");
				if (self.weapons & (IT_ROCKET_LAUNCHER)) sprint (other, "a Rocket Launcher");
				if (self.weapons & (IT_LIGHTNING)) sprint (other, "a Thunderbolt");
				if (self.weapons & (IT_LASER_CANNON)) sprint (other, "a Laser Cannon");
				if (self.weapons & (IT_MJOLNIR)) sprint (other, "Mjolnir");
			}
			else sprint (other, "weapons");
		}
		if (!deathmatch)
		{
			if (weapons_in_backpack == 1 && ammo_in_backpack == 1) sprint (other, " and ");
			if (ammo_in_backpack == 1) sprint (other, "ammo");
		}
		if (deathmatch && ammo_in_backpack == 1 && !weapons_in_backpack) sprint (other, "ammo");
		
		if (!deathmatch)
		{
			if (weapons_in_backpack == 1) sprint (other, "\n");
		}		
		
		if (!deathmatch)
		{
			if (weapons_in_backpack == 1)
			{
				sprint (other, "(WEAPONS: ");
				if (self.weapons & (IT_SUPER_SHOTGUN)) 
				{
					sprint (other, "SSG");
					if (self.weapons & (IT_NAILGUN | IT_SUPER_NAILGUN | IT_GRENADE_LAUNCHER | IT_PROXIMITY_GUN | IT_ROCKET_LAUNCHER | IT_LIGHTNING | IT_LASER_CANNON | IT_MJOLNIR)) sprint (other, ", ");
				}
				if (self.weapons & (IT_NAILGUN))
				{
					sprint (other, "NG");
					if (self.items & (IT_SUPER_NAILGUN | IT_GRENADE_LAUNCHER | IT_PROXIMITY_GUN | IT_ROCKET_LAUNCHER | IT_LIGHTNING | IT_LASER_CANNON | IT_MJOLNIR)) sprint (other, ", ");
				}
				if (self.weapons & (IT_SUPER_NAILGUN)) 
				{
					sprint (other, "SNG");
					if (self.weapons & (IT_GRENADE_LAUNCHER | IT_PROXIMITY_GUN | IT_ROCKET_LAUNCHER | IT_LIGHTNING | IT_LASER_CANNON | IT_MJOLNIR)) sprint (other, ", ");
				}
				if (self.weapons & (IT_GRENADE_LAUNCHER)) 
				{
					sprint (other, "GL");
					if (self.weapons & (IT_PROXIMITY_GUN | IT_ROCKET_LAUNCHER | IT_LIGHTNING | IT_LASER_CANNON | IT_MJOLNIR)) sprint (other, ", ");
				}
				if (self.weapons & (IT_PROXIMITY_GUN))
				{ 
					sprint (other, "PROX");
					if (self.weapons & (IT_ROCKET_LAUNCHER | IT_LIGHTNING | IT_LASER_CANNON | IT_MJOLNIR)) sprint (other, ", ");
				}
				if (self.weapons & (IT_ROCKET_LAUNCHER))
				{ 
					sprint (other, "RL");
					if (self.weapons & (IT_LIGHTNING | IT_LASER_CANNON | IT_MJOLNIR)) sprint (other, ", ");
				}
				if (self.weapons & (IT_LIGHTNING))
				{ 
					sprint (other, "LG");
					if (self.weapons & (IT_LASER_CANNON | IT_MJOLNIR)) sprint (other, ", ");
				}
				if (self.weapons & (IT_LASER_CANNON))
				{ 
					sprint (other, "LC");
					if (self.weapons & (IT_MJOLNIR)) sprint (other, ", ");
				}
				if (self.weapons & (IT_MJOLNIR)) sprint (other, "HAM");
				sprint (other, ")");
			}
		}
		
		if (deathmatch)
		{
			if (ammo_in_backpack == 1 || weapons_in_backpack == 1) sprint (other, "\n(");
		}
		
		if (!deathmatch)
		{
			if (ammo_in_backpack == 1) sprint (other, "\n");
		}		
		
		if (ammo_in_backpack == 1)
		{
			if (!deathmatch) sprint (other, "(AMMO: ");
			if (picked_amount_shell > 0 && picked_amount_shell <= 100)
			{
				if (self.ammo_shells1 > 0 && other.ammo_shells1 <= 100) 
				{
					sprint (other, "+");
					sprint (other, ftos(picked_amount_shell));
					if (picked_amount_shell == 1) sprint (other, " shell");
					else if (picked_amount_shell != 1)  sprint (other, " shells");	
					
					if (picked_amount_nail > 0 && picked_amount_nail <= 200 || 
					picked_amount_rocket > 0 && picked_amount_rocket <= 100 ||
					picked_amount_cell > 0 && picked_amount_cell <= 100 ||
					picked_amount_lava_nail > 0 && picked_amount_lava_nail <= 200 ||
					picked_amount_multi_rocket > 0 && picked_amount_multi_rocket <= 100 ||
					picked_amount_plasma > 0 && picked_amount_plasma <= 100) sprint (other, ", ");
				}
			}
			if (picked_amount_nail > 0 && picked_amount_nail <= 200)
			{
				if (self.ammo_nails1 > 0 && other.ammo_nails1 <= 200) 
				{
					sprint (other, "+");
					sprint (other, ftos(picked_amount_nail));
					if (picked_amount_nail == 1) sprint (other, " nail");
					else if (picked_amount_nail != 1)  sprint (other, " nails");
					
					if (picked_amount_rocket > 0 && picked_amount_rocket <= 100 ||
					picked_amount_cell > 0 && picked_amount_cell <= 100 ||
					picked_amount_lava_nail > 0 && picked_amount_lava_nail <= 200 ||
					picked_amount_multi_rocket > 0 && picked_amount_multi_rocket <= 100 ||
					picked_amount_plasma > 0 && picked_amount_plasma <= 100) sprint (other, ", ");	
				}
			}
			if (picked_amount_rocket > 0 && picked_amount_rocket <= 100)
			{
				if (self.ammo_rockets1 > 0 && other.ammo_rockets1 <= 100) 
				{
					sprint (other, "+");
					sprint (other, ftos(picked_amount_rocket));
					if (picked_amount_rocket == 1) sprint (other, " rocket");
					else if (picked_amount_rocket != 1)  sprint (other, " rockets");
					
					if (picked_amount_cell > 0 && picked_amount_cell <= 100 ||
					picked_amount_lava_nail > 0 && picked_amount_lava_nail <= 200 ||
					picked_amount_multi_rocket > 0 && picked_amount_multi_rocket <= 100 ||
					picked_amount_plasma > 0 && picked_amount_plasma <= 100) sprint (other, ", ");	
				}
			}
			if (picked_amount_cell > 0 && picked_amount_cell <= 100)
			{
				if (self.ammo_cells1 > 0 && other.ammo_cells1 <= 100) 
				{
					sprint (other, "+");
					sprint (other, ftos(picked_amount_cell));
					if (picked_amount_cell == 1) sprint (other, " cell");
					else if (picked_amount_cell != 1)  sprint (other, " cells");
					
					if (picked_amount_lava_nail > 0 && picked_amount_lava_nail <= 200 ||
					picked_amount_multi_rocket > 0 && picked_amount_multi_rocket <= 100 ||
					picked_amount_plasma > 0 && picked_amount_plasma <= 100) sprint (other, ", ");	
				}
			}
			if (picked_amount_lava_nail > 0 && picked_amount_lava_nail <= 200)
			{
				if (self.ammo_lava_nails > 0 && other.ammo_lava_nails <= 200) 
				{
					sprint (other, "+");
					sprint (other, ftos(picked_amount_lava_nail));
					if (picked_amount_lava_nail == 1) sprint (other, " lava nail");
					else if (picked_amount_lava_nail != 1)  sprint (other, " lava nails");	
					
					if (picked_amount_multi_rocket > 0 && picked_amount_multi_rocket <= 100 ||
					picked_amount_plasma > 0 && picked_amount_plasma <= 100) sprint (other, ", ");
				}
			}
			if (picked_amount_multi_rocket > 0 && picked_amount_multi_rocket <= 100)
			{
				if (self.ammo_multi_rockets > 0 && other.ammo_multi_rockets <= 100) 
				{
					sprint (other, "+");
					sprint (other, ftos(picked_amount_multi_rocket));
					if (picked_amount_multi_rocket == 1) sprint (other, " multi-rocket");
					else if (picked_amount_multi_rocket != 1)  sprint (other, " multi-rockets");	
					
					if (picked_amount_plasma > 0 && picked_amount_plasma <= 100) sprint (other, ", ");
				}
			}
			if (picked_amount_plasma > 0 && picked_amount_plasma <= 100)
			{
				if (self.ammo_plasma > 0 && other.ammo_plasma <= 100) 
				{
					sprint (other, "+");
					sprint (other, ftos(picked_amount_plasma));
					if (picked_amount_plasma == 1) sprint (other, " plasma-rocket");
					else if (picked_amount_plasma != 1)  sprint (other, " plasma-rockets");	
				}
			}
		}																					
		sprint (other, ")\n");
	}
	
	EnableComboWeapons (self);	
	UpdateAmmoCounts (self);
		
	// backpack touch sound
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	// remove the backpack
	remove (self);
};

/*
===============
DropBackpack
===============
*/
void() DropBackpack =
{
	// ROGUE ------------------------------------------------------
	// this is to compensate for the new way we're hacking the ammo
	// counts. If they're monsters, just copy shells->shells1 etc.
	if (self.flags & FL_MONSTER)
	{
		self.ammo_shells1  = self.ammo_shells;
		self.ammo_nails1   = self.ammo_nails;
		self.ammo_rockets1 = self.ammo_rockets;
		self.ammo_cells1   = self.ammo_cells;
	}
	// ------------------------------------------------------------
	
	local float items_weapons = self.items & HUD_WEAPONS;
	local float weapons_weapons = self.weapons & ALL_WEAPONS;

	// MG1 ------------------------------
	// Yoder Sept24 2021 Horde Merge
	// don't drop backpacks in horde mode
	if (horde_ent) return; 
	// ----------------------------------
	if (cvar("instagib")) return;
	if (initiate_matchtime == FALSE && cvar("deathmatch")) return;	
			
	if (!weapons_weapons && !(self.ammo_shells1 + self.ammo_nails1 + self.ammo_rockets1 + self.ammo_cells1 + self.ammo_lava_nails + self.ammo_multi_rockets + self.ammo_plasma)) return; // nothing in it

	local entity item = spawn ();
	item.origin = self.origin - '0 0 24';
	item.netname = "Backpack";
	
	if (deathmatch) item.items = self.weapon; // Deathmatch will be like usual. 
	else item.items = items_weapons;
	item.weapons = weapons_weapons;
	
	item.ammo_shells1  = self.ammo_shells1;
	item.ammo_nails1   = self.ammo_nails1;
	item.ammo_rockets1 = self.ammo_rockets1;
	item.ammo_cells1   = self.ammo_cells1;	
	// ROGUE REIGNITED -------------------------------
	item.ammo_lava_nails    = self.ammo_lava_nails;
	item.ammo_multi_rockets = self.ammo_multi_rockets;
	item.ammo_plasma        = self.ammo_plasma;
	// -----------------------------------------------

	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);

	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel (item, "progs/backpack.mdl");
	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;
	
	if (deathmatch) // Sleeper: Remove backpacks in deathmatch after a minute.
	{
		item.nextthink = time + 60;
		item.think = SUB_Remove;	
	}
	if (coop == CLASSIC_COOP) // Sleeper: Remove backpacks in Classic Coop after 2 minutes.
	{
		item.nextthink = time + 120;
		item.think = SUB_Remove;	
	}	
};
