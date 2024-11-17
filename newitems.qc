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

// New Items
//
// Items added for the Rogue XPACK.

void() sphere_spawn;

void(entity theEntity) UpdateAmmoCounts =
{
	if (self.weapon >= DOE_LAVA_NAILGUN)
	{
		theEntity.ammo_shells = theEntity.ammo_shells1;
		theEntity.ammo_nails = theEntity.ammo_lava_nails;
		theEntity.ammo_rockets = theEntity.ammo_multi_rockets;
		theEntity.ammo_cells = theEntity.ammo_plasma;
	}
	else
	{
		theEntity.ammo_shells = theEntity.ammo_shells1;
		theEntity.ammo_nails = theEntity.ammo_nails1;
		theEntity.ammo_rockets = theEntity.ammo_rockets1;
		theEntity.ammo_cells = theEntity.ammo_cells1;
	}
};

void() newitems_touch =
{
	if (other.classname != "player") return;
	if (other.health <= 0) return;
		
	// Only one per person, please.
	if (self.classname == "item_sphere")
	{
		if (other.expansionitems & DOE_V_SPHERE) return;
	}
	
	if (!self.droppable_item) self.fresh_powerup = TRUE;
	else self.fresh_powerup = FALSE;	

	local float seconds_left = rint (self.delay);
		
	if (!self.droppable_item) sprint(other, "You got the ", self.netname, "\n");
	else
	{
		if (coop) sprint (other, "You recovered a fallen ally's decaying ", self.netname, " ");
		else sprint (other, "You recovered a decaying ", self.netname, " ");
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

	if (deathmatch)
	{
		if (self.classname == "item_random_powerup")
		{
			self.nextthink = time + 60;
			self.think = random_regen;
		}
		else if (self.classname == "item_sphere")
		{
			self.mdl = self.model;
			self.nextthink = time + (3 * 60);
			self.think = SUB_regen;
		}
		else 
		{
			self.mdl = self.model;
			self.nextthink = time + 60;
			self.think = SUB_regen;
		}
	}	

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	other.items |= self.items;
	other.expansionitems |= self.expansionitems;
	self.model = string_null;

	// Do the apropriate action
	if (self.netname == "Power Shield")
	{
		other.shield_time = 1;
		
		if (other.shield_finished > time) self.storetime = other.shield_finished - time;
		
		if (horde_ent) other.shield_finished = time + 12;
		else if (self.droppable_item == 1)
		{
			if (other.shield_finished > time && self.fresh_powerup == TRUE) other.shield_finished = time + self.delay + self.storetime;
			else other.shield_finished = time + self.delay;
			
			if (other.shield_finished > time + 30) other.shield_finished = time + 30; // Sleeper: Don't overstack the timer.
		}
		else other.shield_finished = time + 30;
	}
	else if (self.netname == "Anti-Grav Belt")
	{
		other.antigrav_time = 1;
		
		if (other.antigrav_finished > time) self.storetime = other.antigrav_finished - time;
		
		if (horde_ent) other.antigrav_finished = time + 12;
		else if (self.droppable_item == 1)
		{
			if (other.antigrav_finished > time && self.fresh_powerup == TRUE) other.antigrav_finished = time + self.delay + self.storetime;
			else other.antigrav_finished = time + self.delay;
			
			if (other.antigrav_finished > time + 30) other.antigrav_finished = time + 30; // Sleeper: Don't overstack the timer.
		}
		else other.antigrav_finished = time + 45;
		
		other.gravity = 0.25;
	}
	else if (self.classname == "item_sphere")
	{
		other.expansionitems |= DOE_V_SPHERE;
		sphere_spawn();
	}
	
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
	
	if (self.droppable_item == 1) remove (self);
};


/*QUAKED item_powerup_shield (0 .5 .8) (-16 -16 -24) (16 16 32)
The shield upgrade
*/
void() item_powerup_shield =
{
	if (/*cvar("instagib") || */deathmatch == DM_DUEL)
	{
		remove (self);
		return;
	}

	self.touch = newitems_touch;
	precache_model ("progs/shield.mdl");
	precache_model ("progs/p_shield.mdl");
	precache_sound ("shield/pickup.wav");
	precache_sound ("shield/hit.wav");
	precache_sound ("shield/fadeout.wav");
	self.noise = "shield/pickup.wav";
	setmodel (self, "progs/shield.mdl");
	self.netname = "Power Shield";
	self.expansionitems = DOE_SHIELD;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*QUAKED item_powerup_belt (0 .5 .8) (-16 -16 -24) (16 16 32)
The anti-grav belt
*/
void() item_powerup_belt =
{
	if (/*cvar("instagib") || */deathmatch == DM_DUEL)
	{
		remove(self);
		return;
	}
	
	self.touch = newitems_touch;
	precache_model ("progs/beltup.mdl");
	precache_sound ("belt/pickup.wav");
	precache_sound ("belt/use.wav");
	precache_sound ("belt/fadeout.wav");
	self.noise = "belt/pickup.wav";
	setmodel (self, "progs/beltup.mdl");
	self.netname = "Anti-Grav Belt";
	self.expansionitems = DOE_ANTIGRAV;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};