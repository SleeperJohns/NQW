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

// vengeance sphere

// ==============================
// sphere_impact
// ==============================
void() sphere_impact =
{
	if (other.health) T_Damage (other, self, self, 1000);

	// don't do radius damage to the other, because all the damage
	// was done in the impact
//	T_RadiusDamage (self, self, 300, other);
	T_RadiusDamage (self, self, 300, other, "");

//	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin -= 8 * normalize (self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};

void(entity ownerEntity) sphere_remove =
{
	local entity theSphere;
	
	theSphere = find (world, classname, "Vengeance");
	while (theSphere != world)
	{
		if (theSphere.owner == self)
		{
			bprint (theSphere.owner.netname, " was denied of Vengeance\n");
			remove (theSphere);
			theSphere = find (world, classname, "Vengeance");
		}
		else theSphere = find (theSphere, classname, "Vengeance");
	}
};

// ==============================
// sphere_attack
// ==============================
void() sphere_attack =
{
	self.solid = SOLID_TRIGGER;
	self.touch = sphere_impact;

	if (self.enemy.health < 1)
	{
		sprint (self.owner, "You are denied of Vengeance");
		remove(self);
		return;
	}

	ai_track (self.enemy, 650);
	self.nextthink = time + 0.1;
	self.think = sphere_attack; 
};

// ==============================
// sphere_think
// ==============================
void() sphere_think =
{
	if (self.shieldSoundTime < time)
	{
		sound (self, CHAN_VOICE, "sphere/sphere.wav", 1, ATTN_NORM);
		self.shieldSoundTime = time + 4;
	}
	
	if (time > self.delay)
	{
		if (self.owner.expansionitems & DOE_V_SPHERE) self.owner.expansionitems = self.owner.expansionitems - DOE_V_SPHERE;
		sprint (self.owner, "Vengenance Lost.\n");
		remove (self);
		return;
	}

	if (self.owner.health < 1)
	{
		if (self.owner.expansionitems & DOE_V_SPHERE) self.owner.expansionitems = self.owner.expansionitems - DOE_V_SPHERE;
		if (self.owner.enemy.classname == "player")
		{
			self.enemy = self.owner.enemy;
			sphere_attack();
			return;
		}
		if (self.owner.enemy.owner.classname == "player")
		{
			self.enemy = self.owner.enemy.owner;
			sphere_attack();
			return;
		}
		remove (self);
		return;
	}
	
	ai_orbit(self.owner, 16, '0 0 48');
	
    self.think = sphere_think;
    self.nextthink = time + 0.1;
};

// ==============================
// sphere_spawn
// ==============================
void() sphere_spawn =
{
	local   entity missile;

	missile = spawn();
	missile.movetype = MOVETYPE_FLYMISSILE;
//	missile.solid = SOLID_BBOX;
	missile.solid = SOLID_NOT;
	missile.classname = "Vengeance";
	missile.owner = other;
	missile.weapon = 0;
	missile.delay = time + 30;
	setmodel (missile, "progs/sphere.mdl");
	setsize (missile, '0 0 0', '0 0 0');     
	setorigin (missile, self.origin );
	missile.avelocity = '40 40 40';
	missile.think = sphere_think;
	missile.nextthink = time + 0.1;
	
	if (other.classname == "player")
	{
		if (cvar("coop") >= 0 && !cvar("deathmatch"))
		{
			if (cvar("player_collision") == FALSE) entity_collision (missile, PROJECTILE, MONSTERMASK, PVE_BOTH_ENTITY_MASKS, PVE_BOTH_ENTITY_MASKS, EMPTYMASK, 0);	
			else entity_collision (missile, PROJECTILE, PVE_BOTH_ENTITY_MASKS, PVE_BOTH_ENTITY_MASKS, PVE_BOTH_ENTITY_MASKS, EMPTYMASK, 0);
		}						
		else if (cvar("deathmatch") >= DM_TDM && cvar("deathmatch") <= DM_OneFlagCTF)
		{
			if (cvar("player_collision") == FALSE) 
			{
				if (other.steam == TEAM_RED_4) entity_collision (missile, PROJECTILE, TEAMBLUE13_PLAYERMASK, PvP_BOTH_CLIENT_TEAMS, PvP_BOTH_CLIENT_TEAMS, EMPTYMASK, 0);
				if (other.steam == TEAM_BLUE_13) entity_collision (missile, PROJECTILE, TEAMRED4_PLAYERMASK, PvP_BOTH_CLIENT_TEAMS, PvP_BOTH_CLIENT_TEAMS, EMPTYMASK, 0);
			}
			else entity_collision (missile, PROJECTILE, PvP_BOTH_CLIENT_TEAMS, PvP_BOTH_CLIENT_TEAMS, PvP_BOTH_CLIENT_TEAMS, EMPTYMASK, 0);
		}
		else entity_collision (missile, PROJECTILE, PLAYERMASK, PLAYERMASK, PLAYERMASK, EMPTYMASK, 0);
	}
	else entity_collision (missile, PROJECTILE, PVE_BOTH_ENTITY_MASKS, PVE_BOTH_ENTITY_MASKS, PVE_BOTH_ENTITY_MASKS, EMPTYMASK, 0);
};

/*QUAKED item_sphere (0 0 1) (-8 -8 -8) (8 8 8) ?
The $qc_vengeance_sphere. DEATHMATCH ONLY.
*/
void() item_sphere =
{
	if (cvar("instagib") || deathmatch == DM_DISABLED)
	{
		remove(self);
		return;
	}

	precache_model ("progs/sphere.mdl");
	precache_sound ("sphere/sphere.wav");

	self.noise = "sphere/sphere.wav";
	self.netname = "Vengenance Sphere";
	self.touch = newitems_touch;

	setmodel (self, "progs/sphere.mdl");
	setsize (self, '-8 -8 -8', '8 8 8');
	self.avelocity = '40 40 40';
	StartItem ();
};
