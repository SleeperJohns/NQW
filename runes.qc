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

// Rogue Runes
// Jan'97 by ZOID <zoid@threewave.com>
// Under contract to id software for Rogue Entertainment

float ITEM_RUNE1 = 1;	// Rune of Earth Magic:  Resistance
float ITEM_RUNE2 = 2;	// Rune of Black Magic:  Strength
float ITEM_RUNE3 = 4;	// Rune of Hell  Magic:  Haste
float ITEM_RUNE4 = 8;	// Rune of Edler Magic:  Regeneration

.entity runetaker;
.float rune;		// what rune does this guy have?
.float runetime;	// last time we told him he's already got a rune

void() RuneTouch;
void() StartItem;
void() team1_support_rune1 = 
{
	if (cvar("gamecfg") != GAMECFG_NQW_RUNES && cvar("gamecfg") != GAMECFG_ORIGINAL_RUNES)
	{
		remove (self);
		return;
	}

	self.touch = RuneTouch;
	precache_model("progs/end1.mdl");
	precache_sound("runes/end1.wav");
	setmodel (self, "progs/end1.mdl");
	self.netname = "Rune of Resistence";
	self.rune = ITEM_RUNE1;
	setsize (self, '-16 -16 0', '16 16 56');
	self.team = TEAM1;
	StartItem ();
};

void() team2_support_rune1 = 
{
	if (cvar("gamecfg") != GAMECFG_NQW_RUNES && cvar("gamecfg") != GAMECFG_ORIGINAL_RUNES)
	{
		remove (self);
		return;
	}

	self.touch = RuneTouch;
	precache_model("progs/end1.mdl");
	precache_sound("runes/end1.wav");
	setmodel (self, "progs/end1.mdl");
	self.netname = "Rune of Resistence";
	self.rune = ITEM_RUNE1;
	setsize (self, '-16 -16 0', '16 16 56');
	self.team = TEAM2;
	StartItem ();
};

void() team1_support_rune2 = 
{
	if (cvar("gamecfg") != GAMECFG_NQW_RUNES && cvar("gamecfg") != GAMECFG_ORIGINAL_RUNES)
	{
		remove (self);
		return;
	}

	self.touch = RuneTouch;
	precache_model("progs/end2.mdl");
	precache_sound("runes/end2.wav");
	setmodel (self, "progs/end2.mdl");
	self.netname = "Rune of Strength";
	self.rune = ITEM_RUNE2;
	setsize (self, '-16 -16 0', '16 16 56');
	self.team = TEAM1;
	StartItem ();
};

void() team2_support_rune2 = 
{
	if (cvar("gamecfg") != GAMECFG_NQW_RUNES && cvar("gamecfg") != GAMECFG_ORIGINAL_RUNES)
	{
		remove (self);
		return;
	}

	self.touch = RuneTouch;
	precache_model("progs/end2.mdl");
	precache_sound("runes/end2.wav");
	setmodel (self, "progs/end2.mdl");
	self.netname = "Rune of Strength";
	self.rune = ITEM_RUNE2;
	setsize (self, '-16 -16 0', '16 16 56');
	self.team = TEAM2;
	StartItem ();
};

void() team1_support_rune3 = 
{
	if (cvar("gamecfg") != GAMECFG_NQW_RUNES && cvar("gamecfg") != GAMECFG_ORIGINAL_RUNES)
	{
		remove (self);
		return;
	}

	self.touch = RuneTouch;
	precache_model("progs/end3.mdl");
	precache_sound("runes/end3.wav");
	setmodel (self, "progs/end3.mdl");
	self.netname = "Rune of Haste";
	self.rune = ITEM_RUNE3;
	setsize (self, '-16 -16 0', '16 16 56');
	self.team = TEAM1;
	StartItem ();
};

void() team2_support_rune3 = 
{
	if (cvar("gamecfg") != GAMECFG_NQW_RUNES && cvar("gamecfg") != GAMECFG_ORIGINAL_RUNES)
	{
		remove (self);
		return;
	}

	self.touch = RuneTouch;
	precache_model("progs/end3.mdl");
	precache_sound("runes/end3.wav");
	setmodel (self, "progs/end3.mdl");
	self.netname = "Rune of Haste";
	self.rune = ITEM_RUNE3;
	setsize (self, '-16 -16 0', '16 16 56');
	self.team = TEAM2;
	StartItem ();
};

void() team1_support_rune4 = 
{
	if (cvar("gamecfg") != GAMECFG_NQW_RUNES && cvar("gamecfg") != GAMECFG_ORIGINAL_RUNES)
	{
		remove (self);
		return;
	}

	self.touch = RuneTouch;
	precache_model("progs/end4.mdl");
	precache_sound("runes/end4.wav");
	setmodel (self, "progs/end4.mdl");
	self.netname = "Rune of Regeneration";
	self.rune = ITEM_RUNE4;
	setsize (self, '-16 -16 0', '16 16 56');
	self.team = TEAM1;
	StartItem ();
};

void() team2_support_rune4 = 
{
	if (cvar("gamecfg") != GAMECFG_NQW_RUNES && cvar("gamecfg") != GAMECFG_ORIGINAL_RUNES)
	{
		remove (self);
		return;
	}

	self.touch = RuneTouch;
	precache_model("progs/end4.mdl");
	precache_sound("runes/end4.wav");
	setmodel (self, "progs/end4.mdl");
	self.netname = "Rune of Regeneration";
	self.rune = ITEM_RUNE4;
	setsize (self, '-16 -16 0', '16 16 56');
	self.team = TEAM2;
	StartItem ();
};

.float rune1_last_noise_time;
.float rune2_last_noise_time;
.float rune3_last_noise_time;
.float rune4_last_regen_time;

// float runespawn;	// have we spawned runes?
// entity rune_spawn_spot; // spawn spot for runes

//prototypes
void() RuneTouch = 
{
	if (other.classname != "player" || other.health <= 0) return;
	
	if (other.team != self.team) return; // Sleeper: Don't let the opposite team take a support rune that isn't part of their team.
	
	if (other.rune) 
	{
		if (other.runetime < time) id1_centerprint (other, "You already have a rune...\n");
		other.runetime = time + 5;
		return;
	}
	
	sprint (other, "You picked up the ");
	if (self.rune & ITEM_RUNE1) sprint (other, "Rune of Resistance (Incoming Damage Halved)\n");
	if (self.rune & ITEM_RUNE3) sprint (other, "Rune of Haste (2x Fire Rate)\n");
	if (cvar("gamecfg") == GAMECFG_NQW_RUNES)
	{
		if (self.rune & ITEM_RUNE2) sprint (other, "Rune of Doubler (Deal Double Damage)\n");
		if (self.rune & ITEM_RUNE4) sprint (other, "Rune of Guard (Non-Regenable Armor + Health Regen)\n");
	}
	else if (cvar("gamecfg") == GAMECFG_ORIGINAL_RUNES)
	{
		if (self.rune & ITEM_RUNE2) sprint (other, "Rune of Strength (Deal Double Damage)\n");
		if (self.rune & ITEM_RUNE4) sprint (other, "Rune of Regeneration (Health Regen)\n");
	}
	
	other.rune |= self.rune;
	other.runetaker = self; // Sleeper: This support rune's respawn is controlled by this player's death.
	sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	
	// Sleeper: Make support runes respawnable.
	self.solid = SOLID_NOT;
	self.model = string_null;
		
//	remove (self);
};

// Sleeper: Respawn support runes after a player's death.
void() SUB_regen;
void() RuneRespawn =
{
	if (self.rune & ITEM_RUNE4) // Sleeper: Might not be needed, but reset the max health just in case if the player had Regeneration/Guard support rune.
	{
		if (!cvar("deathmatch"))
		{
			if (cvar("skill") <= 3) self.max_health = 100;
			else if (cvar("skill") == 4) self.max_health = 50;
			else if (cvar("skill") == 5) self.max_health = 125;
		}
		else self.max_health = 100;
			
		if (self.health > self.max_health) self.health_deflate = 1;
		else self.health_deflate = 0;	
	}
	
	self.rune = 0; // Sleeper: Remove the support rune.	
	self.runetaker.nextthink = time + 0.1;
	self.runetaker.think = SUB_regen; // Sleeper: Respawn this support rune immediately after this player dies.
};

/*
void(entity spot, float r, float specify_team) SpawnRune =
{
	local entity item;
	
	if (spot == world) spot = RuneSpawnPoint ();

	item = spawn ();
	item.owner = item;
	
	setorigin (item, spot.origin);
//	item.velocity_z = 300;
//	item.velocity_x = -300 + (random() * 600);
//	item.velocity_y = -300 + (random() * 600);
	
	item.rune = r;
	
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	item.team = specify_team;

	if (r & ITEM_RUNE1) setmodel (item, "progs/end1.mdl");
	else if (r & ITEM_RUNE2) setmodel (item, "progs/end2.mdl");
	else if (r & ITEM_RUNE3) setmodel (item, "progs/end3.mdl");
	else if (r & ITEM_RUNE4) setmodel (item, "progs/end4.mdl");

	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = RuneTouch;	
//	item.nextthink = time + 120;	// remove after 2 minutes
//	item.think = RuneRespawn;
	
	item.classname = "item_rune";
};
*/

/*
// Self is player
void() DropRune =
{
//	if (self.team == TEAM1)
//	{
		if (self.rune & ITEM_RUNE1) SpawnRune (ITEM_RUNE1, TEAM1);
		if (self.rune & ITEM_RUNE2) SpawnRune (ITEM_RUNE2, TEAM1);
		if (self.rune & ITEM_RUNE3) SpawnRune (ITEM_RUNE3, TEAM1);
		if (self.rune & ITEM_RUNE4) 
		{
			if (!cvar("deathmatch"))
			{
				if (cvar("skill") <= 3) self.max_health = 100;
				else if (cvar("skill") == 4) self.max_health = 50;
				else if (cvar("skill") == 5) self.max_health = 125;
			}
			else self.max_health = 100;
			
			if (self.health > self.max_health) self.health_deflate = 1;
			else self.health_deflate = 0;	
			SpawnRune (ITEM_RUNE4, TEAM1);
		}
		
		self.rune = 0;
//	}
	
//	if (self.team == TEAM2)
//	{
		if (self.rune & ITEM_RUNE1) SpawnRune (ITEM_RUNE1, TEAM2);
		if (self.rune & ITEM_RUNE2) SpawnRune (ITEM_RUNE2, TEAM2);
		if (self.rune & ITEM_RUNE3) SpawnRune (ITEM_RUNE3, TEAM2);
		if (self.rune & ITEM_RUNE4) 
		{
			if (!cvar("deathmatch"))
			{
				if (cvar("skill") <= 3) self.max_health = 100;
				else if (cvar("skill") == 4) self.max_health = 50;
				else if (cvar("skill") == 5) self.max_health = 125;
			}
			else self.max_health = 100;
			
			if (self.health > self.max_health) self.health_deflate = 1;
			else self.health_deflate = 0;	
			SpawnRune (ITEM_RUNE4, TEAM2);
		}
		
		self.rune = 0;
//	}	
};
*/

/*
void() DoSpawnRunes =
{
	local entity oself = self;
	
//	remove (self);
	
	self = find (world, classname, "info_team1_rune1");
//	SpawnRune (ITEM_RUNE1, TEAM1);
	
	remove (oself);
};


void() SpawnRunes =
{
	local entity spawner;

//	if (!deathmatch || !(cvar("gamecfg") & GAMECFG_ENABLE_RUNES) || runespawn) return;
	runespawn = 1;
	spawner = spawn ();
	spawner.think = DoSpawnRunes;
	spawner.nextthink = time + 0.1;
};
*/

float(float damage, entity who) RuneApplyEarth =
{
	if (who.rune & ITEM_RUNE1) 
	{
		if (who.rune1_last_noise_time < time) 
		{
			sound (who, CHAN_VOICE, "runes/end1.wav", 1, ATTN_NORM);
			// Tune as needed
			who.rune1_last_noise_time = time + 1.0;
		}
		return damage / 2;
	}
	return damage;
};

void(entity who) RuneApplyBlackNoise =
{
	if (who.rune & ITEM_RUNE2)
	{
		if (who.rune2_last_noise_time < time) 
		{
			sound (who, CHAN_VOICE, "runes/end2.wav", 1, ATTN_NORM);
			// Tune as needed
			who.rune2_last_noise_time = time + 1.0;
		}
	}
};

float(float damage, entity who) RuneApplyBlack =
{
	if (who.rune & ITEM_RUNE2) return damage * 2;
	return damage;
};

float(float tvalue, entity who) RuneApplyHell =
{
	if (who.rune & ITEM_RUNE3) 
	{
		if (who.rune3_last_noise_time < time) 
		{
			sound (who, CHAN_VOICE, "runes/end3.wav", 1, ATTN_NORM);
			// Tune as needed
			who.rune3_last_noise_time = time + 1.0;
		}
		return (tvalue * 2) / 3;
	}
	return tvalue;
};

.float guard;

void(entity who) RuneApplyElder =
{
	if (cvar("gamecfg") == GAMECFG_ORIGINAL_RUNES)
	{
		if (who.rune & ITEM_RUNE4)
		{
			if (who.rune4_last_regen_time < time && who.health < 100) 
			{
				sound (who, CHAN_VOICE, "runes/end4.wav", 1, ATTN_NORM);
				who.health += 5;
				if (who.health > 100) who.health = 100;
				who.rune4_last_regen_time = time + 1;
			}
		}
	}	
	else if (cvar("gamecfg") == GAMECFG_NQW_RUNES)
	{
		if (who.rune & ITEM_RUNE4)
		{
			if (!who.guard) // To be like Quake III: Team Arena's Guard
			{ 
				who.max_health = 200;
				who.health = 200;
				who.armorvalue = 200;
				who.armortype = 0.8;
				who.items -= who.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3);
				who.items |= IT_ARMOR3;
				who.guard = 1;
			}
			if (who.rune4_last_regen_time < time && who.health < 200) 
			{
				sound (who, CHAN_VOICE, "runes/end4.wav", 1, ATTN_NORM);
				if (who.guard == 1) who.health += 5;
				if (who.health > 200) who.health = 200;
				who.rune4_last_regen_time = time + 1;
			}
		}
	}
};

float(entity who) RuneHasElder =
{
	if (who.rune & ITEM_RUNE4) return TRUE;
	return FALSE;
};

/*
void() RunePrecache = 
{
	if (cvar("deathmatch"))
	{
		if (cvar("gamecfg") & GAMECFG_ORIGINAL_RUNES || cvar("gamecfg") & GAMECFG_NQW_RUNES) 
		{
			precache_model("progs/end1.mdl");
			precache_model("progs/end2.mdl");
			precache_model("progs/end3.mdl");
			precache_model("progs/end4.mdl");

			precache_sound("runes/end1.wav");
			precache_sound("runes/end2.wav");
			precache_sound("runes/end3.wav");
			precache_sound("runes/end4.wav");
		}
	}
};
*/