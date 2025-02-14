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

// LAVA Weapon Routines

/*
===============
launch_lava_spike

Used for both the player and the ogre
===============
*/
void(vector org, vector dir) launch_lava_spike =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);
	
	newmis.touch = lavaspike_touch;
	newmis.classname = "lava_spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 6;
	setmodel (newmis, "progs/lspike.mdl");	
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin (newmis, org);

	newmis.velocity = dir * 1000;
	
	if (self.classname == "player")
	{
		if (cvar("coop") >= 0 && !cvar("deathmatch"))
		{
			if (cvar("player_collision") == FALSE) entity_collision (newmis, PROJECTILE, MONSTERMASK, PVE_BOTH_ENTITY_MASKS, PVE_BOTH_ENTITY_MASKS, EMPTYMASK, 0);	
			else entity_collision (newmis, PROJECTILE, PVE_BOTH_ENTITY_MASKS, PVE_BOTH_ENTITY_MASKS, PVE_BOTH_ENTITY_MASKS, EMPTYMASK, 0);
		}				
		else if (cvar("deathmatch") >= DM_TDM && cvar("deathmatch") <= DM_OneFlagCTF)
		{
			if (cvar("player_collision") == FALSE) 
			{
				if (self.steam == TEAM_RED_4) entity_collision (newmis, PROJECTILE, TEAMBLUE13_PLAYERMASK, PvP_BOTH_CLIENT_TEAMS, PvP_BOTH_CLIENT_TEAMS, EMPTYMASK, 0);
				if (self.steam == TEAM_BLUE_13) entity_collision (newmis, PROJECTILE, TEAMRED4_PLAYERMASK, PvP_BOTH_CLIENT_TEAMS, PvP_BOTH_CLIENT_TEAMS, EMPTYMASK, 0);
			}
			else entity_collision (newmis, PROJECTILE, PvP_BOTH_CLIENT_TEAMS, PvP_BOTH_CLIENT_TEAMS, PvP_BOTH_CLIENT_TEAMS, EMPTYMASK, 0);
		}
		else entity_collision (newmis, PROJECTILE, PLAYERMASK, PLAYERMASK, PLAYERMASK, EMPTYMASK, 0);
	}
	else entity_collision (newmis, PROJECTILE, PVE_BOTH_ENTITY_MASKS, PVE_BOTH_ENTITY_MASKS, PVE_BOTH_ENTITY_MASKS, EMPTYMASK, 0);
};

void() W_FireSuperLavaSpikes =
{
	local vector	dir;
	
	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_lava_nails = self.ammo_lava_nails - 2;
	UpdateAmmoCounts (self);
	
	dir = aim (self, 1000);
	launch_lava_spike (self.origin + '0 0 16', dir);
	newmis.touch = superlavaspike_touch;

//	setmodel (newmis, "progs/lspike.mdl");			

	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	self.punchangle_x = -2;
	
//	player_projectile_collision (newmis);
};

void(float ox) W_FireLavaSpikes =
{
	local vector	dir;
	
	makevectors (self.v_angle);
	
	if (self.ammo_lava_nails >= 2 && self.weapon == DOE_LAVA_SUPER_NAILGUN)
	{
		W_FireSuperLavaSpikes ();
		return;
	}

	if (self.ammo_lava_nails < 1)
	{
		sprint (self, "out of lava nails\n");
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_lava_nails = self.ammo_lava_nails - 1;
	UpdateAmmoCounts (self);
	
	dir = aim (self, 1000);
	launch_lava_spike (self.origin + '0 0 16' + v_right*ox, dir);

	self.punchangle_x = -2;
};

// =============== Lava Spike Touch Routines

void() lavaspike_touch =
{
	local float old_armortype, old_armorvalue, old_armormask;

	if (other == self.owner) return;

	if (other.solid == SOLID_TRIGGER) return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
// hit something that bleeds
	if (other.takedamage)
	{
		other.deathtype = "lava_nail";
		spawn_touchblood (9);
		if (other.classname == "player") // Sleeper: Armor Piercing... kinda.
		{
			old_armortype = other.armortype;
			old_armorvalue = other.armorvalue;
			old_armormask = other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3);
			other.armortype = 0;
			other.armorvalue = 0;
			T_Damage (other, self, self.owner, 9);
			other.armortype = old_armortype;
			other.armorvalue = old_armorvalue;
			other.items |= old_armormask;
		}
		else		// is a monster
		{
			if (other.classname != "monster_lava_man") T_Damage (other, self, self.owner, 15);
		}
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		
		if (self.classname == "wizspike") WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
		else if (self.classname == "knightspike") WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
		else WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	remove (self);

};

void() superlavaspike_touch =
{
	local float old_armortype,/* old_armorvalue*/;

	if (other == self.owner) return;

	if (other.solid == SOLID_TRIGGER) return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
// hit something that bleeds
	if (other.takedamage)
	{
		other.deathtype = "super_lava_nail";
		spawn_touchblood (18);
		
		// halve the effectiveness of the armor for players..
		if (other.classname == "player")
		{
			// save the old armor values...
			old_armortype = other.armortype;
//			old_armorvalue = other.armorvalue;
			other.armortype *= 0.5;
//			other.armorvalue = 0;
			T_Damage (other, self, self.owner, 18);
			
			// if the damage didn't wipe out the armor, armortype 
			if (other.armortype != 0)
			{
				other.armortype = old_armortype;
//				other.armorvalue = old_armorvalue;
			}
		}
		else		// is a monster, do 50% more damage
		{
			if (other.classname != "monster_lava_man") T_Damage (other, self, self.owner, 30);
		}
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	remove (self);
};
