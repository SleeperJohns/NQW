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

/*
===============================================================================

END OF LEVEL RUNES

===============================================================================
*/

/*
float SIGIL_E1 = 16; //1;
float SIGIL_E2 = 32; //2;
float SIGIL_E3 = 64; //4;
float SIGIL_E4 = 128; //8;
float SIGIL_E5 = 256; //16;
float SIGIL_E6 = 512; //32;
float SIGIL_NUMBITS = 6;
*/

float SIGIL_ALL = SIGIL_E1 | SIGIL_E2 | SIGIL_E3 | SIGIL_E4 | SIGIL_E5;
float SIGIL_ALL_ALL_ALLLL = SIGIL_E1 | SIGIL_E2 | SIGIL_E3 | SIGIL_E4 | SIGIL_E5 | SIGIL_E6;


void() sigil_touch_mg1 =
{
	if (other.netname == "[overseer]-BOT") return;
	if (other.classname != "player") return;
	if (other.health <= 0) return;

//	centerprint_all (self.netname); // Netname is localized
	
	id1_centerprint (other, "You got the ", self.netname, "!\n");
	
	// Broadcast a centerprint to all players with the player's nickname added to the message, unless it's a single player game.
	if (coop >= REIGNITED_COOP)
	{
		local entity all_players = find (world, classname, "player");
		while (all_players)
		{	
			if (all_players != other) id1_centerprint (all_players, other.netname, " got the\n", self.netname, "!\n");
			all_players = find (all_players, classname, "player");
		}
	}
	
	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	self.model = string_null;
	
	float lastPickup = SUB_LeftShift (self.spawnflags & SIGIL_ALL, SIGIL_NUMBITS);
	serverflags |= (self.spawnflags & SIGIL_ALL) | lastPickup;
	
	if (cvar("horde") && (self.spawnflags & SIGIL_E2)) // Hunger
	{
		local entity e = find (world, classname, "player");
		while (e)
		{
			e.hunger_time = time + HUNGER_MAX;
			dprint ("hunger time is: ");
			dprint (ftos(e.hunger_time));
			dprint ("\n");
			e = find (e, classname, "player");
		}
	}
	
	activator = other;
	SUB_UseTargets ();				// fire all targets / killtargets
};


float() sigil_getLastPickup =
{
	float lastPickup = SUB_RightShift (serverflags, SIGIL_NUMBITS) & SIGIL_ALL;
	return lastPickup;
};

void() sigil_clearLastPickup =
{
	serverflags &= ~SUB_LeftShift (SIGIL_ALL, SIGIL_NUMBITS);
};

/*QUAKED item_sigil_mg1 (0 .5 .8) (-16 -16 -24) (16 16 32) E1 E2 E3 E4 E5 E6
End of level sigil_mg1, pick up to end episode and return to jrhub.
*/

void() item_sigil_mg1 =
{
	dprint ("SPAWNING SIGIL: ");
	dprint (ftos(self.spawnflags));
	dprint ("\n");
	if (!self.spawnflags) self.spawnflags |= SIGIL_E1;

	precache_sound ("misc/runekey.wav");
	self.noise = "misc/runekey.wav";

	string tempmdl = string_null;

	if (self.spawnflags & SIGIL_E1)
	{
		self.spawnflags = SIGIL_E1;
		tempmdl = "progs/mg1_rune1.mdl";
		self.netname = "Rune of Machinists";
	}
	else if (self.spawnflags & SIGIL_E2)
	{
		self.spawnflags = SIGIL_E2;
		tempmdl = "progs/mg1_rune2.mdl";
		self.netname = "Rune of Blacksmiths";
	}
	else if (self.spawnflags & SIGIL_E3)
	{
		self.spawnflags = SIGIL_E3;
		tempmdl = "progs/mg1_rune3.mdl";
		self.netname = "Rune of Stonemasons";
	}
	else if (self.spawnflags & SIGIL_E4)
	{
		self.spawnflags = SIGIL_E4;
		tempmdl = "progs/mg1_rune4.mdl";
		self.netname = "Rune of Cultists";
	}
	else if (self.spawnflags & SIGIL_E5)
	{
		self.spawnflags = SIGIL_E5;
		tempmdl = "progs/mg1_rune5.mdl";
		self.netname = "Rune of Astrologers";
	}
	else if (self.spawnflags & SIGIL_E6)
	{
		self.spawnflags = SIGIL_E6;
		tempmdl = "progs/mg1_rune6.mdl";
		self.netname = "Secret Rune";
	}
    
	dprint ("PREP SIGIL\n");

	precache_model (tempmdl);
	setmodel (self, tempmdl);

	self.touch = sigil_touch;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

// ===============================================================================

const float RUNE_INDICATOR_ACTIVE = 1024;

void() misc_rune_indicator_use =
{
	self.alpha = 1.0;
	SUB_UseTargets ();
};

void() misc_rune_indicator =
{
	float active = self.spawnflags & RUNE_INDICATOR_ACTIVE ? TRUE : FALSE;
	self.spawnflags (-) RUNE_INDICATOR_ACTIVE;
	if (!self.spawnflags) self.spawnflags |= SIGIL_E1;
		
	self.spawnflags &= SIGIL_ALL_ALL_ALLLL;

	string mdl = string_null;

	if (self.spawnflags & SIGIL_E1)
	{
		self.spawnflags = SIGIL_E1;
		mdl = "progs/mg1_rune1.mdl";
	}
	else if (self.spawnflags & SIGIL_E2)
	{
		self.spawnflags = SIGIL_E2;
		mdl = "progs/mg1_rune2.mdl";
	}
	else if (self.spawnflags & SIGIL_E3)
	{
		self.spawnflags = SIGIL_E3;
		mdl = "progs/mg1_rune3.mdl";
	}
	else if (self.spawnflags & SIGIL_E4)
	{
		self.spawnflags = SIGIL_E4;
		mdl = "progs/mg1_rune4.mdl";
	}
	else if (self.spawnflags & SIGIL_E5)
	{
		self.spawnflags = SIGIL_E5;
		mdl = "progs/mg1_rune5.mdl";
	}
	else if (self.spawnflags & SIGIL_E6)
	{
		self.spawnflags = SIGIL_E6;
		mdl = "progs/mg1_rune6.mdl";
	}
    
	precache_model (mdl);
	setmodel (self, mdl);

	self.use = misc_rune_indicator_use;

	if (((self.spawnflags & serverflags) == self.spawnflags) || active)
	{
		self.think = SUB_UseTargets;
		self.nextthink = time + 0.2;
	}
	else
	{
		// Show a ghost of the rune before you collect it.
		if (!(self.spawnflags & SIGIL_E6)) self.alpha = 0.2; // Sleeper: Secret Rune should be at a full opacity.
	}
};