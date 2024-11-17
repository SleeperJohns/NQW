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

// multi_weapons.qc
// pmack
// sept 96

//=============================================================================
// Multi Grenade Code
//=============================================================================
void() MultiGrenadeTouch;

//================================
//================================
void() MiniGrenadeExplode =
{
//	if (self.owner.classname == "player") T_RadiusDamage (self, self.owner, 90, world);
//	else T_RadiusDamage (self, self.owner, 60, world);
	
	if (self.owner.classname == "player") T_RadiusDamage (self, self.owner, 90, world, "multi_grenade");
	else T_RadiusDamage (self, self.owner, 60, world, "multi_grenade");	
	

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION2);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	WriteByte (MSG_BROADCAST, 230);
	WriteByte (MSG_BROADCAST, 5);
	BecomeExplosion ();
};

//================================
//================================
void(float offsetAngle) MiniGrenadeLaunch =
{
	local float tempRand;	
	local entity missile = spawn ();
	
	missile.owner = self.owner;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "MiniGrenade";
		
	// set missile speed	
	missile.v_angle = self.v_angle;
	missile.v_angle_y += offsetAngle;
	makevectors (missile.v_angle);
		
	missile.velocity = v_forward * 100 + v_up * 400;
	tempRand = (crandom() * 60) - 30;
	missile.velocity += tempRand * v_forward;
	tempRand = (crandom() * 40) - 20;
	missile.velocity += tempRand * v_right;
	tempRand = (crandom() * 60) - 30;
	missile.velocity += tempRand * v_up;

	missile.avelocity = '300 300 300';
	missile.angles = vectoangles (missile.velocity);
	missile.touch = MultiGrenadeTouch;
	
	setmodel (missile, "progs/mervup.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin);

	// set missile duration
	missile.nextthink = time + 1 + (crandom() * 0.5);
	missile.think = MiniGrenadeExplode;
};

//================================
//================================
void() MultiGrenadeExplode =
{
	MiniGrenadeLaunch(0);
	MiniGrenadeLaunch(72);
	MiniGrenadeLaunch(144);
	MiniGrenadeLaunch(216);
	MiniGrenadeLaunch(288);
	remove (self);
};

//================================
//================================
void() MultiGrenadeTouch =
{
	if (other == self.owner) return;		// don't explode on owner
	
	if (pointcontents(self.origin) == CONTENT_SKY) // Sleeper: Felt it was missing.
	{
		remove(self);
		return;
	}	
	
	// Centerprints to let the player know that Shamblers are resistant to Rockets.		
	if (T_Damage && other.classname == "monster_shambler")
	{
		if ((cvar("skill") == 5) && self.owner.super_damage_finished < time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Shamblers are heavily resistant\n to your multi-grenades!");
		else if ((cvar("skill") == 5) && self.owner.super_damage_finished > time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Shamblers are resistant\n to your multi-grenades!");
		else if ((cvar("skill") <= 4) && self.owner.super_damage_finished < time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Shamblers are resistant\n to your multi-grenades!");
		else if ((cvar("skill") <= 4) && self.owner.super_damage_finished > time)	
			id1_centerprint(self.owner, "");
	}
		
	// Sleeper: Tell the player that Spike Mines are resistant to rockets.
	if (T_Damage && other.classname == "trap_spike_mine")
	{
		if (cvar("skill") >= 1 && cvar("skill") <= 4 && self.owner.super_damage_finished < time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Spike Mines are resistant\n to your multi-grenades!");
		else if (cvar("skill") >= 1 && cvar("skill") <= 4 && self.owner.super_damage_finished > time)
			id1_centerprint(self.owner, "");
		else if (cvar("skill") == 5 && self.owner.super_damage_finished < time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Spike Mines are heavily resistant\n to your multi-grenades!");
		else if (cvar("skill") == 5 && self.owner.super_damage_finished > time)
			id1_centerprint(self.owner, "");
	}				
	if (other.takedamage == DAMAGE_AIM)
	{
		if (self.classname == "MiniGrenade") MiniGrenadeExplode ();
		else
		{
			if (self.owner.classname == "player") GrenadeExplode();
			else MiniGrenadeExplode ();
		}
		return;
	}
	// bounce sound
	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);	
	if (self.velocity == '0 0 0') self.avelocity = '0 0 0';
};

//================================
//================================
void() W_FireMultiGrenade =
{	
	self.currentammo = self.ammo_multi_rockets = self.ammo_multi_rockets - 1;
	UpdateAmmoCounts (self);
	
	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	local entity missile = spawn ();
	
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "MultiGrenade";
		
// set missile speed	
	makevectors (self.v_angle);
	if (self.v_angle_x) missile.velocity = v_forward * 600 + v_up * 200 + crandom() * v_right * 10 + crandom() * v_up * 10;
	else
	{
		missile.velocity = aim (self, 10000);
		missile.velocity *= 600;
		missile.velocity_z = 200;
	}

	missile.avelocity = '300 300 300';
	missile.angles = vectoangles (missile.velocity);
	missile.touch = MultiGrenadeTouch;
	
// set missile duration
	missile.nextthink = time + 1;
	missile.think = MultiGrenadeExplode;

	setmodel (missile, "progs/mervup.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin);
};

//=============================================================================
// Multi Rocket Code
//=============================================================================

//================================
//================================
void() MultiRocketExplode = 
{
//	Stock Single Rocket Damage...
//	damg = 100 + random()*20;

	local float damg; 
	if (deathmatch) damg = 60;
	else damg = 60 + random() * 15;

	if (other.health)
	{
		other.deathtype = "multi_rocket";
		if (other.classname == "monster_shambler")
		{
			if (cvar("skill") == 5)
			{
				if (self.owner.super_damage_finished > time) damg = damg * 0.5;
				else
				{
					sound (self, CHAN_AUTO, "items/protect3.wav", 1, ATTN_NORM);
					damg = damg * 0.25; // ~75% immunity to rockets
				}
			}
			else 
			{
				if (self.owner.super_damage_finished > time) damg = damg * 0.5;
				else damg = damg * 0.5;  // ~50% immunity to rockets
			}
		}
		if (other.classname == "trap_spike_mine")
		{
			if (cvar("skill") <= 0) damg = damg * 1;  // 0% immunity to Rockets (Emulate 200 health)			
			else if (cvar("skill") >= 1 && cvar("skill") <= 4)
			{
				sound (self, CHAN_AUTO, "items/protect3.wav", 1, ATTN_NORM);
				damg = damg * 0.5;  // ~50% immunity to Rockets (Emulate 400 health)
			}
			else
			{
				if (self.owner.super_damage_finished > time) damg = damg * 0.5;
				else
				{
					sound (self, CHAN_AUTO, "items/protect3.wav", 1, ATTN_NORM);
					damg = damg * 0.25;  // ~75% immunity to Rockets (Emulate 800 health)
				}
			}		
		}				
		if (other.classname == "monster_dragon") damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, damg );
	}	
	
	// Centerprints to let the player know that Shamblers are resistant to Rockets.		
	if (T_Damage && other.classname == "monster_shambler")
	{
		if ((cvar("skill") == 5) && self.owner.super_damage_finished < time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Shamblers are heavily resistant\n to your multi-rockets!");
		else if ((cvar("skill") == 5) && self.owner.super_damage_finished > time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Shamblers are resistant\n to your multi-rockets!");
		else if ((cvar("skill") <= 4) && self.owner.super_damage_finished < time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Shamblers are resistant\n to your multi-rockets!");
		else if ((cvar("skill") <= 4) && self.owner.super_damage_finished > time)	
			id1_centerprint(self.owner, "");
	}		
	// Sleeper: Tell the player that Spike Mines are resistant to rockets.
	if (T_Damage && other.classname == "trap_spike_mine")
	{
		if (cvar("skill") >= 1 && cvar("skill") <= 4 && self.owner.super_damage_finished < time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Spike Mines are resistant\n to your multi-rockets!");
		else if (cvar("skill") >= 1 && cvar("skill") <= 4 && self.owner.super_damage_finished > time)
			id1_centerprint(self.owner, "");
		else if (cvar("skill") == 5 && self.owner.super_damage_finished < time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Spike Mines are heavily resistant\n to your multi-rockets!");
		else if (cvar("skill") == 5 && self.owner.super_damage_finished > time)
			id1_centerprint(self.owner, "");
	}	

	// don't do radius damage to the other, because all the damage
	// was done in the impact
//	Stock single rocket damage.
//	T_RadiusDamage (self, self.owner, 120, other);

//	T_RadiusDamage (self, self.owner, 75, other);
	T_RadiusDamage (self, self.owner, 75, other, "multi_rocket");

//	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin -= 8 * normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	BecomeExplosion ();
};

//================================
//================================
void() MultiRocketTouch =
{
	if (other == self.owner) return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	MultiRocketExplode ();
};


//================================
//================================
void() HomingMissileThink =
{
	if (self.enemy.health < 1)
	{
		remove (self);
		return;
	}

	local vector dir = normalize(self.enemy.origin - self.origin);	
	self.velocity = dir * 1000;
	self.nextthink = time + 0.1;
	self.think = HomingMissileThink;	
};


//================================
//================================
void() HomingMissileAcquire =
{
	if (self.delay < time)
	{
		MultiRocketExplode ();
		return;
	}

	local vector oldVelocity = self.velocity;
	makevectors (self.v_angle);
	self.velocity = aim (self, 1000);
	self.velocity *= 1000;

	local vector aimangle = self.origin + self.velocity;	
	traceline (self.origin, aimangle, FALSE, self);
	if (trace_fraction < 1)
	{
		if (trace_ent.flags & FL_MONSTER)
		{
			self.enemy = trace_ent;
			HomingMissileThink ();
			return;
		}
	}
	
	self.velocity = oldVelocity;
	self.v_angle = vectoangles (self.velocity);
	self.angles = self.v_angle;
	self.think = HomingMissileAcquire;
	self.nextthink = time + 0.2;
};

//================================
//================================
void(float offset, float frameNum) MultiRocketLaunch = 
{
	local vector aimangle;	
	local entity missile = spawn ();
	
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "MultiRocket";
	missile.delay = time + 4;
	missile.frame = frameNum;
	missile.touch = MultiRocketTouch;

	if (deathmatch || coop) setmodel (missile, "progs/rockup_d.mdl");
	else setmodel (missile, "progs/rockup.mdl");

	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + v_forward * 8 + '0 0 16');
	
	if (deathmatch || coop == CLASSIC_COOP)
	{
		aimangle = self.v_angle;
		aimangle_y = aimangle_y + (offset * 0.66);
		makevectors (aimangle);
		missile.velocity = aim (self, 1000);
		missile.velocity = missile.velocity * 1000;
		missile.angles = vectoangles (missile.velocity);
		missile.think = MultiRocketExplode;
		missile.nextthink = time + 4;
	}
	else
	{
		makevectors (self.v_angle);
		missile.velocity = v_forward * 1000 - v_right * offset * 8;
		missile.angles = vectoangles (missile.velocity);
		missile.v_angle = self.v_angle;	
		aimangle = missile.origin + missile.velocity;
		traceline (missile.origin, aimangle, FALSE, self);
		if (trace_fraction < 1)
		{
			if (trace_ent.flags & FL_MONSTER)
			{
				missile.enemy = trace_ent;
				missile.think = HomingMissileThink;
				return;
			}
		}

		missile.think = HomingMissileAcquire;
		missile.nextthink = time + 0.1;
	}
};

//================================
//================================
void() W_FireMultiRocket =
{
	self.currentammo = self.ammo_multi_rockets = self.ammo_multi_rockets - 1;
	UpdateAmmoCounts (self);
	
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;
	
	MultiRocketLaunch (-10, 2);
	MultiRocketLaunch (-5, 3);
	MultiRocketLaunch (5, 0);
	MultiRocketLaunch (10, 1);
};

//=============================================================================
// Plasma Gun Code
//=============================================================================
void(vector p1, vector p2, entity from, float damage) PlasmaDamage =
{
	local entity e1, e2;	
	local vector f = p2 - p1;
	
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f *= 16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);
	if (trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage * 4);
		T_Damage (trace_ent, from, from.owner, damage);
		if (self.classname == "player")
		{
			if (other.classname == "player") trace_ent.velocity_z += 400;
		}
	}
	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
	if (trace_ent != e1 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage * 4);
		T_Damage (trace_ent, from, from.owner, damage);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage * 4);
		T_Damage (trace_ent, from, from.owner, damage);
	}
};

//================================
//================================
void(entity current, float doDamage) PlasmaDischarge =
{
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, current);
	WriteCoord (MSG_BROADCAST, current.origin_x);
	WriteCoord (MSG_BROADCAST, current.origin_y);
	WriteCoord (MSG_BROADCAST, current.origin_z);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	sound (self, CHAN_VOICE, "weapons/lhit.wav", 1, ATTN_NORM);
	if (doDamage == 1) PlasmaDamage (self.origin, current.origin, self, 50);
};

//================================
//================================
void() PlasmaGroundOut = 
{	
	local float monstersHit = 0;
	local entity current = findradius (self.origin, 320);
	local entity start = current;
	while (monstersHit < 5)
	{
		if (!cvar("deathmatch")) // Sleeper: Mainly for a better co-operative experience so players don't tag other players with the plasma gun.
		{
			if (cvar("coop") == REIGNITED_COOP || cvar("coop") == ENHANCED_COOP) // Sleeper: Reignited or Enhanced Coop
			{	
				if (cvar("teamplay") != COOP_FF_ON && cvar("teamplay") != COOP_FF_DISABLED) // Sleeper: Because it makes sense to be careful???
				{
					if (current.flags & FL_MONSTER) // Sleeper: Only players can tag monsters.
					{
						if (current != self.owner && current.health >= 1)
						{
							traceline (self.origin, current.origin, TRUE, world);
							if (trace_fraction == 1)
							{
								monstersHit += 1;
								PlasmaDischarge (current, 1);
							}
						}
					}
					if (self.owner.classname == "monster_dragon") // Sleeper: Only the dragon can tag players.
					{
						if (current != self.owner && current.health >= 1)
						{
							traceline (self.origin, self.owner.origin, TRUE, world);
							if (trace_fraction == 1)
							{
								monstersHit += 1;
								PlasmaDischarge (current, 1);
							}
						}
					}
				}
			}
			if (!cvar("coop") || cvar("coop") == CLASSIC_COOP) // Sleeper: Single Player or Classic Coop (to stay vanilla mainly).
			{
				if (current.flags & FL_MONSTER || current.classname == "player") // Sleeper: As vanilla.
				{
					if (current != self.owner && current.health >= 1)
					{
						traceline (self.origin, current.origin, TRUE, world);
						if (trace_fraction == 1)
						{
							monstersHit += 1;
							PlasmaDischarge (current, 1);
						}
					}
				}
			}				
		}
		else
		{
			if (cvar("deathmatch") == DM_DUEL || cvar("deathmatch") == DM_FFA) // Sleeper: Tag any player in Duels and Free For All.
			{
				if (current.classname == "player")
				{
					if (current != self.owner && current.health >= 1)
					{
						traceline (self.origin, current.origin, TRUE, world);
						if (trace_fraction == 1)
						{
							monstersHit += 1;
							PlasmaDischarge (current, 1);
						}
					}
				}
			}			
			if (cvar("deathmatch") >= DM_TDM && cvar("deathmatch") <= DM_OneFlagCTF) // Sleeper: Tag only the players aren't on your team.
			{
				if (cvar("teamplay") == TEAM_FF_DISABLED || cvar("teamplay") == TEAM_FF_ON) // Sleeper: Because it makes sense to be careful???
				{
					if (current.classname == "player")
					{
						if (current != self.owner && current.health >= 1)
						{
							traceline (self.origin, current.origin, TRUE, world);
							if (trace_fraction == 1)
							{
								monstersHit += 1;
								PlasmaDischarge (current, 1);
							}
						}
					}
				}
				if (cvar("teamplay") == TEAM_FF_OFF)
				{
					if (current.classname == "player" && current.team != self.owner.team)
					{
						if (current != self.owner && current.health >= 1)
						{
							traceline (self.origin, current.origin, TRUE, world);
							if (trace_fraction == 1)
							{
								monstersHit += 1;
								PlasmaDischarge (current, 1);
							}
						}
					}
				}
			}
		}
		current = current.chain;
		if (start == current || !current) return;
	}
};

//================================
//================================
void() PlasmaTouch = 
{
	local float damg;

	if (other == self.owner) return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove (self);
		return;
	}

	if (deathmatch && !coop) damg = 80; // Sleeper: In my opinion, random factors in deathmatch shouldn't be a thing.
	else damg = 80 + random() * 20;
	
	sound (self, CHAN_WEAPON, "plasma/explode.wav", 1, ATTN_NORM);
	
	if (other.health)
	{
		other.deathtype = "plasma_rocket";
		if (other.classname == "monster_shambler")
		{
			if (cvar("skill") == 5)
			{
				if (self.owner.super_damage_finished > time) damg = damg * 0.5;
				else
				{
					sound (self, CHAN_AUTO, "items/protect3.wav", 1, ATTN_NORM);
					damg = damg * 0.25; // ~75% immunity to rockets
				}
			}
			else 
			{
				if (self.owner.super_damage_finished > time) damg = damg * 0.5;
				else damg = damg * 0.5;  // ~50% immunity to rockets
			}
		}
		if (other.classname == "trap_spike_mine")
		{
			if (cvar("skill") <= 0) damg = damg * 1;  // 0% immunity to Rockets (Emulate 200 health)			
			else if (cvar("skill") >= 1 && cvar("skill") <= 4)
			{
				sound (self, CHAN_AUTO, "items/protect3.wav", 1, ATTN_NORM);
				damg = damg * 0.5;  // ~50% immunity to Rockets (Emulate 400 health)
			}
			else
			{
				if (self.owner.super_damage_finished > time) damg = damg * 0.5;
				else
				{
					sound (self, CHAN_AUTO, "items/protect3.wav", 1, ATTN_NORM);
					damg = damg * 0.25;  // ~75% immunity to Rockets (Emulate 800 health)
				}
			}		
		}
		T_Damage (other, self, self.owner, damg);
	}
	// Centerprints to let the player know that Shamblers are resistant to Rockets.		
	if (T_Damage && other.classname == "monster_shambler")
	{
		if ((cvar("skill") == 5) && self.owner.super_damage_finished < time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Shamblers are heavily resistant\n to your plasma balls!");
		else if ((cvar("skill") == 5) && self.owner.super_damage_finished > time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Shamblers are resistant\n to your plasma balls!");
		else if ((cvar("skill") <= 4) && self.owner.super_damage_finished < time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Shamblers are resistant\n to your plasma balls!");
		else if ((cvar("skill") <= 4) && self.owner.super_damage_finished > time)	
			id1_centerprint(self.owner, "");
	}		
	// Sleeper: Tell the player that Spike Mines are resistant to rockets.
	if (T_Damage && other.classname == "trap_spike_mine")
	{
		if (cvar("skill") >= 1 && cvar("skill") <= 4 && self.owner.super_damage_finished < time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Spike Mines are resistant\n to your plasma balls!");
		else if (cvar("skill") >= 1 && cvar("skill") <= 4 && self.owner.super_damage_finished > time)
			id1_centerprint(self.owner, "");
		else if (cvar("skill") == 5 && self.owner.super_damage_finished < time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Spike Mines are heavily resistant\n to your plasma balls!");
		else if (cvar("skill") == 5 && self.owner.super_damage_finished > time)
			id1_centerprint(self.owner, "");
	}	

	// don't do radius damage to the other, because all the damage
	// was done in the impact
//	T_RadiusDamage (self, self.owner, 70, other);
	T_RadiusDamage (self, self.owner, 70, other, "plasma_rocket");
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION2);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	WriteByte (MSG_BROADCAST, 244);
	WriteByte (MSG_BROADCAST, 3);
	PlasmaGroundOut ();
	remove (self);
};

//================================
//================================
void() PlasmaLaunch =
{
	self.velocity = normalize (self.velocity);
	self.velocity *= 1250;

	self.nextthink = time + 5;
	self.think = SUB_Remove;
};

void(vector org, vector dir) launch_plasma =
{
	local entity	missile;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "plasma";
	
	// set missile speed	
	missile.velocity = dir * 0.01;
	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = PlasmaTouch;
	
	setmodel (missile, "progs/plasma.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);

	sound (missile, CHAN_WEAPON, "plasma/flight.wav", 1, ATTN_NORM);
	if (!deathmatch && !coop) missile.effects = EF_BRIGHTLIGHT;
	
	// set missile duration
	missile.think = PlasmaLaunch;
	missile.nextthink = time + 0.1;
};

//================================
//================================
void() W_FirePlasma = 
{
	local float cells, rnum;
	local vector dir;
	
	if (self.ammo_plasma < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

// explode if under water
	if (self.waterlevel > 1)
	{
		cells = self.ammo_plasma;
		self.ammo_plasma = 0;
		W_SetCurrentAmmo ();
//		T_RadiusDamage (self, self, 35 * cells, world);
		T_RadiusDamage (self, self, 35 * cells, world, "");
		// Sleeper: Emulate self discharge in co-op even if we've completely disabled friendly fire and self-damage.
		if (teamplay == COOP_FF_OFF && coop == REIGNITED_COOP)
		{
			// don't kill yourself if have pentagram
			if (self.invincible_finished >= 1)
			{
				self.health -= 0;
				self.ammo_plasma = 0;
				UpdateAmmoCounts(self);
				W_SetCurrentAmmo();
				return;
			}
			// don't kill yourself if have wetsuit
			else if (self.wetsuit_finished >= 1)
	                {
				self.health -= 0;
				self.ammo_plasma = 0;
				UpdateAmmoCounts(self);
				W_SetCurrentAmmo();
				return;
			}
			// don't kill yourself if god mode is enabled
			else if (self.flags & FL_GODMODE)
			{
				self.health -= 0;
				self.ammo_plasma = 0;
				UpdateAmmoCounts(self);
				W_SetCurrentAmmo();
				return;
			}
			// Sleeper: Take self discharge damage when Pentagram and Wetsuit are off.
			else if (self.health >= 0 && self.invincible_time == 0 && self.wetsuit_time == 0)
			{
				self.health -= 15 * cells; // 15 self (health) damage per cell, we normally end up doing half damage to ourselves for self-damage. But discharges are overpowered, so it doesn't matter. You're going to die anyways.
				if (self.health <= 0) // Sleeper: Artificially die if below 0 health.
				{
					self.th_die ();//R00k: Reset powerups and drop Backpack
					set_suicide_frame();
					if (self.health < -99) // Doesn't need to show extremely low negative numbers.
						self.health = -99;
					self.modelindex = modelindex_nqwplayer;	
											
					// Emulate an Obituary
					bprint (self.netname);
					rnum = random();
					if (rnum < 0.3)
						bprint(" becomes bored with life\n");
					else if (rnum < 0.6)
						bprint(" checks if his weapon is loaded\n");
					else
						bprint(" discovers blast radius\n"); // Added
					if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp")
						self.frags -= 1;	
							
					respawn();	
					self.ammo_plasma = 0;
					UpdateAmmoCounts(self);
					W_SetCurrentAmmo();
					return;
				}
			}
		}
		return;
	}
	self.currentammo = self.ammo_plasma = self.ammo_plasma - 1;
	UpdateAmmoCounts (self);
	sound (self, CHAN_WEAPON, "plasma/fire.wav", 0.5, ATTN_NORM);
	self.punchangle_x = -2;

	makevectors (self.v_angle);
	dir = aim (self, 1000);
	launch_plasma (self.origin + v_forward * 24 + '0 0 16', dir);
};

