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

// Sleeper: Changed from float to .float due the sound wasn't being played to the correct modelindexed player,
// as we use custom player models (and skins) for cosmetics
.float lavaGunFired;

/*
*/
//JIM
void( vector pos ) placebullethole;
void (entity targ, entity inflictor, entity attacker, float damage) T_Damage;
void () player_run;
// void(entity bomb, entity attacker, float rad, entity ignore) T_RadiusDamage;
void(entity inflictor, entity attacker, float damage, entity ignore, string dtype) T_RadiusDamage;

void(vector org, vector vel, float damage) SpawnBlood;
void() SuperDamageSound;

//MED 10/18/96
void(float damage) spawn_touchblood;
/*
================
HIPNOTIC WEAPONS
================
*/
void() HIP_LaserTouch =
{
	local vector org, spot1, spot2, oldvel;
	local float r;
 
	self.owner = world;
	self.cnt += 1;
	
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove (self);
		return;
	}
	
	oldvel = normalize (self.old_velocity);
	spot1 = self.origin - (16 * oldvel);
	spot2 = self.origin + (16 * oldvel);
	traceline (spot1, spot2, FALSE, self);  // see through other monsters
	self.origin = trace_endpos;

	org = self.origin;

	if (other.health)
	{
		other.deathtype = "laser_spike";
		if (self.lastvictim == other) self.dmg /= 2;
		else if (other.classname == "trap_spike_mine")
		{
			if (cvar("skill") == 5) self.dmg /= 4; // ~75% immunity to Lasers (Emulate 800 health)
			else if (cvar("skill") >= 1 && cvar("skill") <= 4) self.dmg /= 2; // ~50% immunity to Lasers (Emulate 400 health)
			else if (cvar("skill") == 0) self.dmg = self.dmg; // ~0% immunity to rockets (Emulate 200 health)
		}
		spawn_touchblood (self.dmg);
		T_Damage (other, self, self.lastvictim, self.dmg);
	}
	else if ((self.cnt == 3) || (random() < 0.15))
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
	else
	{
//      	self.dmg = 0.66 * self.dmg;
		self.dmg = 0.9 * self.dmg;
//      	self.speed = 0.95 * self.speed;
		self.velocity = oldvel + (2 * trace_plane_normal);
		self.velocity = normalize(self.velocity);
		self.velocity = self.speed * self.velocity;
		self.old_velocity = self.velocity;
		if (self.flags & FL_ONGROUND) self.flags -= FL_ONGROUND;
		r = random ();
		sound (self, CHAN_WEAPON, "hipweap/laserric.wav", 1, ATTN_STATIC);
/*
		if (r < 0.33) sound (self, CHAN_WEAPON, "weapons/ric1.wav", 1, ATTN_STATIC);
		else if (r < 0.66) sound (self, CHAN_WEAPON, "weapons/ric2.wav", 1, ATTN_STATIC);
		else sound (self, CHAN_WEAPON, "weapons/ric3.wav", 1, ATTN_STATIC);
*/
		return;
	}
	
	sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
	remove (self);
};
void() HIP_LaserThink =
{
	if (time>self.attack_finished)
	{
		remove (self);
		return;
	}
	
	if (self.flags & FL_ONGROUND) self.flags -= FL_ONGROUND;
	self.velocity = self.old_velocity;
	self.angles = vectoangles(self.velocity);
	self.nextthink = time + 0.1;
};

void(vector org, vector vec, float light) HIP_LaunchLaser =
{
//  	sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);
	sound (self ,CHAN_WEAPON, "hipweap/laserg.wav", 1, ATTN_NORM);

	vec = normalize(vec);

	newmis = spawn();
	newmis.owner = self;
	newmis.classname = "hiplaser";
	newmis.lastvictim = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
//  	if (light)
		newmis.effects |= EF_DIMLIGHT;

	setmodel (newmis, "progs/lasrspik.mdl");
	setsize (newmis, '0 0 0', '0 0 0');

	setorigin (newmis, org);

	newmis.speed = 1000;
	newmis.dmg = 18;
	newmis.velocity = vec * newmis.speed;
	newmis.old_velocity = newmis.velocity;
	newmis.angles = vectoangles(newmis.velocity);
	newmis.avelocity = '0 0 400';

	newmis.nextthink = time;
	newmis.attack_finished = time + 5;
	newmis.think = HIP_LaserThink;
	newmis.touch = HIP_LaserTouch;
	newmis.count = 0;
};

/*
=================
HIP_FireLaser
=================
*/
void(float stat) HIP_FireLaser =
{
	local vector org;
	local vector dir;
	local vector out;
	local float ofs;
	local float aofs;

	if (!self.button0)
	{
		player_run ();
		return;
	}
	
	if (self.ammo_cells1 < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}
	
	SuperDamageSound ();
	self.effects |= EF_MUZZLEFLASH;
	makevectors (self.v_angle);

	ofs = 6;
	out = v_forward;
	out_z = 0;
	out = normalize(out);
	org = self.origin + ((12 - ofs) * v_up) + (12 * out);
//   	org = self.origin + (1 * v_forward);
	dir = aim (self, 1000);
	aofs = ofs * 0.707;
	
	if (stat == 0)
	{
		self.currentammo = self.ammo_cells1 = self.ammo_cells1 - 1;
		org += (aofs * v_right);
		org -= (aofs * v_up);
		HIP_LaunchLaser (org, dir, 0);
		org -= (2 * aofs * v_right);
		HIP_LaunchLaser(org, dir, 0);
		UpdateAmmoCounts(self);
	}
	else if (stat == 1)
	{
		self.currentammo = self.ammo_cells1 = self.ammo_cells1 - 1;
		org += (ofs * v_up);
		if (random()<0.1)
		{
			HIP_LaunchLaser (org, dir, 1);
			newmis.dmg = 25;
		}
		else HIP_LaunchLaser (org, dir, 0);
		UpdateAmmoCounts(self);
	}
	
	self.punchangle_x = -1;
};

/*
=================
HIP_HammerDamage
=================
*/
void(vector p1, vector p2, entity from, float damage) HIP_HammerDamage =
{
	local entity		e1, e2;
	local vector		f;

	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);
//JIM
	if (trace_ent.takedamage && !trace_ent.wetsuit_finished )
	{
		if (trace_ent.classname == "trap_spike_mine")
		{
			if (cvar("skill") == 5)
			{
				particle (trace_endpos, '0 0 100', 225, damage*4);
				T_Damage (trace_ent, from, from, damage * 0.25); // ~75% immunity to the Mjolnir's Lightning (Emulate 800 Health)
			}
			else if (cvar("skill") >= 1 && cvar("skill") <= 4)
			{
				particle (trace_endpos, '0 0 100', 225, damage*4);
				T_Damage (trace_ent, from, from, damage * 0.5); // ~50% immunity to the Mjolnir's Lightning (Emulate 400 Health)
			}
			else if (cvar("skill") == 0)
			{
				particle (trace_endpos, '0 0 100', 225, damage*4);
				T_Damage (trace_ent, from, from, damage); // 0% immunity to the Mjolnir's Lightning (Emulate 200 Health)
			}
		}
		else
		{
			particle (trace_endpos, '0 0 100', 225, damage*4);
			T_Damage (trace_ent, from, from, damage);
		}
		if (self.classname == "player")
		{
			if (other.classname == "player")
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}
	}
	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
//JIM
	if (trace_ent != e1 && trace_ent.takedamage &&
		!trace_ent.wetsuit_finished )
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
//JIM
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage &&
		!trace_ent.wetsuit_finished )
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
	}
};

/*
void() HIP_DiversionLightningThink =
{
	local vector   org,end;

	if (time > self.delay)
	{
		remove (self);
		return;
	}

	makevectors(self.v_angle);
	org = self.origin;
	end = org + v_forward * 200;
//   	end += (((200 * random()) - 100) * v_up);
	end += (((400 * random()) - 200) * v_right);

	traceline (org, end, TRUE, self);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	self.nextthink = time + 0.1;
};
*/

//void(entity prev, entity owner, float dst) HIP_SpawnMjolnirLightning;
void() HIP_LightningThink =
{
	local vector org;
	local vector dst;
	local entity head;
	local entity selected;
	local float cur_dist;
	local float head_dist;
	local vector vec;
	local float dot;
	local float oldstate;
	local float dam;


	if (time > self.delay)
	{
		if (self.enemy != world) self.enemy.struck_by_mjolnir = 0;
		remove(self);
		return;
	}
	
	oldstate = self.state;
	if (self.state == 0)
	{
		// look in our immediate vicinity
		self.enemy = world;
		selected = world;
		cur_dist = self.distance;
		head = findradius(self.owner.origin, self.distance);
		while (head)
		{
			if (coop <= ENHANCED_COOP)
			{
				if (!(head.flags & FL_NOTARGET) && (head.flags & FL_MONSTER))
				{
//            				if (visible(head) && (head != self.owner.owner) && (head.health > 0))
					if ((visible(head)) && (head != self.owner.owner) && (head.health > 0))
					{
						head_dist = vlen(head.origin - self.lastvictim.origin);
						if ((head_dist < cur_dist) && (head.struck_by_mjolnir == 0))
						{
							selected = head;
							cur_dist = head_dist;
						}
					}
				}
			}
			if (deathmatch)
			{
				if (deathmatch == DM_DUEL || deathmatch == DM_FFA)
				{
					if (head.flags & FL_CLIENT)
					{
//           					if (visible(head) && (head != self.owner.owner) && (head.health > 0))
						if ((visible(head)) && (head != self.owner.owner) && (head.health > 0))
						{
							head_dist = vlen(head.origin - self.lastvictim.origin);
							if ((head_dist < cur_dist) && (head.struck_by_mjolnir == 0))
							{
								selected = head;
								cur_dist = head_dist;
							}
						}
					}
				}
				if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF)
				{
					if (head.flags & FL_CLIENT)
					{
//           					if (visible(head) && (head != self.owner.owner) && (head.health > 0))
						if ((visible(head)) && (head != self.owner.owner) && (head.health > 0) && head.team != self.owner.owner.team)
						{
							head_dist = vlen(head.origin - self.lastvictim.origin);
							if ((head_dist < cur_dist) && (head.struck_by_mjolnir == 0))
							{
								selected = head;
								cur_dist = head_dist;
							}
						}
					}
				}		 	
			} 
			head = head.chain;
		}
		if (selected != world)
		{
			self.state = 1;
			self.enemy = selected;
			self.enemy.struck_by_mjolnir = 1;
		}
		else
		{
			local vector end;

			makevectors(self.v_angle);
			org = self.owner.origin;
			end = org + v_forward * 200;
			end += (((400 * random()) - 200) * v_right);

			traceline (org, end, TRUE, self);

			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
			WriteEntity (MSG_BROADCAST, self);
			WriteCoord (MSG_BROADCAST, org_x);
			WriteCoord (MSG_BROADCAST, org_y);
			WriteCoord (MSG_BROADCAST, org_z);
			WriteCoord (MSG_BROADCAST, trace_endpos_x);
			WriteCoord (MSG_BROADCAST, trace_endpos_y);
			WriteCoord (MSG_BROADCAST, trace_endpos_z);

			self.nextthink = time + 0.1;
//       		self.think = HIP_DiversionLightningThink;
//         		self.nextthink = time;
//         		self.delay = time + 0.30;
//         		self.origin = self.owner.origin;
//         		self.think();
			return;
		}
	}
	org = self.lastvictim.origin;
	dst = self.enemy.absmin + 0.25 * (self.enemy.absmax - self.enemy.absmin);
	dst += (random() * 0.5 * (self.enemy.absmax - self.enemy.absmin));
	traceline (org, dst, TRUE, self.owner.owner);

	if (trace_fraction != 1.0 || self.enemy.health <= 0)
	{
		self.enemy.struck_by_mjolnir = 0;
		self.state = 0;
		self.nextthink = time + 0.1;
		return;
	}
	
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);
	vec = normalize(self.enemy.origin - self.owner.origin);
	dot = vec * self.owner.movedir;
	head = self;
	self = self.owner.owner;
	
	if (oldstate == 0) dam = 80;
	else dam = 30;
	
	if (dot > 0.3) HIP_HammerDamage (org, trace_endpos, self, dam);
	else HIP_HammerDamage (org, trace_endpos, self, dam * 0.5);
	
	self = head;

	self.nextthink = time + 0.2;
};

void(entity prev, entity own, float dst) HIP_SpawnMjolnirLightning =
   {
   local entity light;
   // spawn actual lightning
   light = spawn();
   light.delay = time + 0.8;
   light.state = 0;
   light.lastvictim = prev;
   light.distance = dst;
   light.owner = own;
   light.v_angle = self.angles;
   light.v_angle_x = 0;
   light.v_angle_z = 0;
   light.origin = own.origin;
   light.think = HIP_LightningThink;
   light.nextthink = time;
   };

void() HIP_SpawnMjolnirBase =
   {
   local entity light;
   // spawn lightning base
   light = spawn();
//   light.origin = self.origin - '0 0 24' + (32*v_forward);
   light.origin = trace_endpos;
   light.flags = 0;
   light.owner = self;
   light.struck_by_mjolnir = 1;
   light.think = SUB_Remove;
   light.nextthink = time + 1;
   sound (light, CHAN_AUTO, "hipweap/mjolslap.wav", 1, ATTN_NORM);
   sound (light, CHAN_WEAPON, "hipweap/mjolhit.wav", 1, ATTN_NORM);
   makevectors(self.v_angle);
   light.movedir = v_forward;
   HIP_SpawnMjolnirLightning( light, light, 350 );
   HIP_SpawnMjolnirLightning( light, light, 350 );
   HIP_SpawnMjolnirLightning( light, light, 350 );
   HIP_SpawnMjolnirLightning( light, light, 350 );
   };

void() respawn;

void() HIP_FireMjolnirLightning =
{
	local float cells, rnum;

	// explode if under water
	if (self.waterlevel > 1)
	{
		cells = self.ammo_cells1;
		self.ammo_cells1 = 0;
		UpdateAmmoCounts(self);
		discharged = 1;
//		T_RadiusDamage (self, self, 35*cells, world);
		T_RadiusDamage (self, self, 35*cells, world, "");
		// Sleeper: Emulate self discharge in co-op even if we've completely disabled friendly fire and self-damage.
		if (teamplay == 1 && coop == 1)
		{
			// don't kill yourself if have pentagram
			if (self.invincible_finished >= 1)
			{
				self.health -= 0;
				self.ammo_cells1 = 0;
				UpdateAmmoCounts(self);
				W_SetCurrentAmmo();
				return;
			}
			// don't kill yourself if have wetsuit
			else if (self.wetsuit_finished >= 1)
	                {
				self.health -= 0;
				self.ammo_cells1 = 0;
				UpdateAmmoCounts(self);
				W_SetCurrentAmmo();
				return;
			}
			// don't kill yourself if god mode is enabled
			else if (self.flags & FL_GODMODE)
			{
				self.health -= 0;
				self.ammo_cells1 = 0;
				UpdateAmmoCounts(self);
				W_SetCurrentAmmo();
				return;
			}
			// Sleeper: Take self discharge damage when Pentagram and Wetsuit are off.
			else if (self.health >= 0 && self.invincible_time == 0 && self.wetsuit_time == 0)
			{
				self.health -= 25 * cells; // 25 self (health) damage per cell, we normally end up doing half damage to ourselves for self-damage. But discharges are overpowered, so it doesn't matter. You're going to die anyways.
				if (self.health <= 0) // Sleeper: Artificially die if below 0 health.
				{
					self.th_die ();//R00k: Reset powerups and drop Backpack
					set_suicide_frame();
					if (self.health < -99) // Doesn't need to show extremely low negative numbers.
						self.health = -99;						
					self.modelindex = modelindex_nqwplayer;	
																
					// Emulate an Obituary	
					bprint (self.netname);
					if 	(self.watertype == CONTENT_WATER)
					{
						rnum = random();
						if (rnum < 0.4)
							bprint (" is unworthy of wielding Mjolnir in water\n");
						else
							bprint (" quaked himself in the water\n"); // Added
					}
					else if (self.watertype == CONTENT_SLIME)
						bprint (" is unworthy of wielding Mjolnir in slime\n");
					else if (self.watertype == CONTENT_LAVA)
						bprint (" is unworthy of wielding Mjolnir in lava\n");
					if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp") 
						self.frags -= 1;	
						
					respawn(); // Sleeper: Respawn immediately if self discharge kills you.
					self.ammo_cells1 = 0;
					UpdateAmmoCounts(self);
					W_SetCurrentAmmo();
					return;
				}
			}
		}
		discharged = 0;
		W_SetCurrentAmmo ();
		return;
	}

//  	if (self.t_width < time)
//  	{
//      	sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
//     		self.t_width = time + 0.6;
//   	}
//   	self.punchangle_x = 12;

	self.currentammo = self.ammo_cells1 = self.ammo_cells1 - 15;
	UpdateAmmoCounts(self);
	HIP_SpawnMjolnirBase();
};

void() HIP_FireMjolnir =
   {
   local vector   org;
   local float    damage;
   local vector   source;


   self.attack_finished = time + 0.4;
   source = self.origin + '0 0 16';
//   ang = self.angles;
//   ang_x = 0;
//   ang_y = 0;
   makevectors(self.v_angle);
   traceline (source, source + v_forward*32, FALSE, self);
   if (trace_fraction == 1.0 && (self.ammo_cells1 >= 15))
      {
      source = source + v_forward*32;
      traceline (source , source - v_up*50, FALSE, self);
//      dprint("fraction = ");
//      dprint(ftos(trace_fraction));
//      dprint("\n");
      if (trace_fraction > 0.3 && trace_fraction< 1.0)
         {
         HIP_FireMjolnirLightning();
         self.attack_finished = time + 1.5;
         return;
         }
      }
   org = trace_endpos - v_forward*4;

   if (trace_ent.takedamage)
      {
      damage = 50;
      if (trace_ent.classname == "monster_zombie")
         damage = 70;
      if (trace_ent.classname == "trap_spike_mine")
      {
	if (cvar("skill") == 5)
	{
		damage = 50 * 0.25; // ~75% immunity to Mjolnir's Melee (Emulate 800 health)... Like the axe, I don't know why you would melee a Spike Mine.
	}
	else if (cvar("skill") >= 1 && cvar("skill") <= 4)
	{
		damage = 50 * 0.5; // ~50% immunity to Mjolnir's Melee (Emulate 400 health)... Like the axe, I don't know why you would melee a Spike Mine.
	}
	else if (cvar("skill") == 0)
	{
		damage = 50; // ~0% immunity to Mjolnir's Melee (Emulate 200 health)... Like the axe, I don't know why you would melee a Spike Mine.
	}
      }
      trace_ent.axhitme = 1;
      SpawnBlood (org, v_forward, damage);
      T_Damage (trace_ent, self, self, damage);
      }
   else
      {  // hit wall
      if (trace_fraction != 1.0)
         {
//         sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
         sound (self, CHAN_WEAPON, "hipweap/mjoltink.wav", 1, ATTN_NORM);
         WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
         WriteByte (MSG_BROADCAST, TE_GUNSHOT);
         WriteCoord (MSG_BROADCAST, org_x);
         WriteCoord (MSG_BROADCAST, org_y);
         WriteCoord (MSG_BROADCAST, org_z);
         }
      else
         {
         sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
         }
      }
   self.attack_finished = time + 0.4;

   };

// called by worldspawn
void() W_Precache =
{
	precache_sound ("weapons/r_exp3.wav");	// new rocket explosion
	precache_sound ("weapons/rocket1i.wav");	// spike gun
	precache_sound ("weapons/sgun1.wav");
	precache_sound ("weapons/guncock.wav");	// player shotgun
	precache_sound ("weapons/ric1.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric2.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric3.wav");	// ricochet (used in c code)
	precache_sound ("weapons/spike2.wav");	// super spikes
	precache_sound ("weapons/tink1.wav");	// spikes tink (used in c code)
	precache_sound ("weapons/grenade.wav");	// grenade launcher
	precache_sound ("weapons/bounce.wav");		// grenade bounce
	precache_sound ("weapons/shotgn2.wav");	// super shotgun
//MED
   precache_sound ("enforcer/enfstop.wav");   // laser cannon
//MED 11/06/96
   precache_sound ("knight/sword1.wav");   // laser cannon
   precache_sound ("hipweap/laserg.wav");   // laser cannon
   precache_sound ("hipweap/laserric.wav");   // laser cannon ricochet
   precache_sound ("hipweap/proxwarn.wav");   // proximity bomb
   precache_sound ("hipweap/proxbomb.wav");   // proximity bomb
//MED 11/19/96
   precache_sound ("hipweap/mjolhit.wav");   // mjolnir
   precache_sound ("hipweap/mjolslap.wav");   // mjolnir
   precache_sound ("hipweap/mjoltink.wav");   // mjolnir
   
//ZOID--
	// grapple
	precache_sound("weapons/chain1.wav");
//	precache_sound("weapons/chain2.wav");
//	precache_sound("weapons/chain3.wav");
//	precache_sound("weapons/bounce2.wav");
//	precache_sound("blob/land1.wav");
	precache_sound("pendulum/hit.wav");
//--ZOID

	precache_sound ("lavagun/snail.wav");		// lava nail gun cooldown   
};

float() crandom =
{
	return 2 * (random() - 0.5);
};

/*
================
W_FireAxe
================
*/
void() W_FireAxe =
{
	local vector source, org;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward * 64, FALSE, self);
	if (trace_fraction == 1.0) return;

	org = trace_endpos - v_forward * 4;

	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 1;
		SpawnBlood (org, '0 0 0', 20);
		if (self.nqwSndMeleeHit != "")
			sound(self, TRUE, self.nqwSndMeleeHit, TRUE, TRUE);
		if (trace_ent.classname == "trap_spike_mine")
		{
			if (cvar("skill") == 5)
				T_Damage (trace_ent, self, self, 20 * 0.25); // ~75% immunity to the Axe (Emulate 800 Health)... Don't know why you would axe a Spike Mine though.
			else if (cvar("skill") >= 1 && cvar("skill") <= 4)
				T_Damage (trace_ent, self, self, 20 * 0.5); // ~50% immunity to the Axe (Emulate 400 Health)... Don't know why you would axe a Spike Mine though.
			else if (cvar("skill") == 0)
				T_Damage (trace_ent, self, self, 20); // 0% immunity to the Axe (Emulate 200 Health)... Don't know why you would axe a Spike Mine though.
		}
		else
		{
			if (trace_ent.classname == "monster_zombie" && cvar("customcoop"))
				T_Damage (trace_ent, self, self, 60);
			else
				T_Damage (trace_ent, self, self, 20);
		}
	}
	else
	{	// hit wall
		sound(self, CHAN_WEAPON, self.nqwSndMeleeWall, TRUE, ATTN_NORM);
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};


//============================================================================


vector() wall_velocity =
{
	local vector	vel;

	vel = normalize (self.velocity);
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	return vel;
};


/*
================
SpawnMeatSpray
================
*/
void(vector org, vector vel) SpawnMeatSpray =
{
	local	entity missile;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;

	makevectors (self.angles);

	missile.velocity = vel;
	missile.velocity_z += 250 + 50 * random();

	missile.avelocity = '3000 1000 2000';

// set missile duration
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/zom_gib.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, org);
};

/*
================
SpawnBlood
================
*/
void(vector org, vector vel, float damage) SpawnBlood = {particle (org, vel * 0.1, 73, damage * 2);};

/*
================
spawn_touchblood
================
*/
void(float damage) spawn_touchblood =
{
	local vector vel = wall_velocity() * 0.2;
	SpawnBlood (self.origin + vel * 0.01, vel, damage);
};


/*
================
SpawnChunk
================
*/
void(vector org, vector vel) SpawnChunk = {particle (org, vel * 0.02, 0, 10);};

/*
==============================================================================

MULTI-DAMAGE

Collects multiple small damages into a single damage

==============================================================================
*/

entity multi_ent;
float  multi_damage;

void() ClearMultiDamage =
{
	multi_ent = world;
	multi_damage = 0;
};

void() ApplyMultiDamage =
{
	if (!multi_ent) return;
	T_Damage (multi_ent, self, self, multi_damage);
};

void(entity hit, float damage) AddMultiDamage =
{
	if (!hit) return;

	if (hit != multi_ent)
	{
		ApplyMultiDamage ();
		multi_damage = damage;
		multi_ent = hit;
	}
	else multi_damage += damage;
};

/*
==============================================================================

BULLETS

==============================================================================
*/

/*
================
TraceAttack
================
*/
void(float damage, vector dir) TraceAttack =
{
	local vector vel, org;

	vel = normalize(dir + v_up * crandom() + v_right * crandom());
	vel += 2 * trace_plane_normal;
	vel *= 200;

	org = trace_endpos - dir * 4;

	if (trace_ent.takedamage)
	{
		if (trace_ent.classname == "trap_spike_mine")
		{
			if (cvar("skill") == 5)
			{
				SpawnBlood (org, vel * 0.2, damage);
				AddMultiDamage (trace_ent, damage * 0.25); // ~75% immunity to Shotgun Shells (Emulate 800 health)
			}
			else if (cvar("skill") >= 1 && cvar("skill") <= 4)
			{
				SpawnBlood (org, vel * 0.2, damage);
				AddMultiDamage (trace_ent, damage * 0.5); // ~50% immunity to Shotgun Shells (Emulate 400 health)
			}
			else if (cvar("skill") == 0)
			{
				SpawnBlood (org, vel * 0.2, damage);
				AddMultiDamage (trace_ent, damage); // ~0% immunity to Shotgun Shells (Emulate 200 health)
			}
		}
		else
		{	
			SpawnBlood (org, vel * 0.2, damage);
			AddMultiDamage (trace_ent, damage);	
		}				
	}			
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};

/*
void() FireSlug =
{
	makevectors(self.v_angle);

	local vector src = self.origin + self.view_ofs - v_up * 8;	
	src_z = self.absmin_z + self.size_z * 0.8125;
	local vector finaldest = src + v_forward * 4000;

	// bmFbr: Cache v_forward locally to make sure it won't be lost during loop shenanigans.
	local vector pl_v_forward = v_forward;

	traceline (src, finaldest, 0, self);

	local entity victim;
	local vector endpos;
	local float damg;	
	
	while (trace_ent.takedamage) 
	{
		// bmFbr: Just to make sure, since after a T_Damage call all hell may break loose.
		victim = trace_ent;
		endpos = trace_endpos;	

		if (trace_ent.classname == "player") damg = 80;
		else damg = 125 + random() * 25;

//		if (!cvar("instagib"))
//		{
			if (trace_ent.classname == "trap_spike_mine")
			{
				if (cvar("skill") == 5) T_Damage (victim, self, self, damg * 0.25); // ~75% immunity to Slugs (Emulate 800 health)
				else if (cvar("skill") >= 1 && cvar("skill") <= 4) T_Damage (victim, self, self, damg * 0.5); // ~50% immunity to Slugs (Emulate 400 health)
				else if (cvar("skill") == 0) T_Damage (victim, self, self, damg); // ~0% immunity to Slugs (Emulate 200 health)
			}
			else if (trace_ent.classname == "monster_shambler") T_Damage (victim, self, self, damg * 0.5);
			else T_Damage (victim, self, self, damg);
//		}
//		else T_Damage (victim, self, self, 50000);
		SpawnBlood (endpos, pl_v_forward * 300, 80);

		// Sleeper: Don't pierce through secret doors.
		if (trace_ent.classname != "func_door_secret") traceline (endpos, finaldest, 0, victim);
	}
	
	if (trace_ent.classname == "func_door_secret") SpawnBlood (endpos, pl_v_forward * 300, 80); // Sleeper: Should just spawn blood, not both.
	else
	{
		if (trace_fraction < 1) 
		{
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, TE_GUNSHOT);
			WriteCoord (MSG_BROADCAST, trace_endpos_x);
			WriteCoord (MSG_BROADCAST, trace_endpos_y);
			WriteCoord (MSG_BROADCAST, trace_endpos_z);
		} 
	}
	
	// Sleeper: Create a simple particle trail.
	local float segments = rint(vlen(src - trace_endpos) / 32) - 0.005;
	for (float i = 0; i < segments; i++) particle (trace_endpos - pl_v_forward * i * 32, pl_v_forward * 0, 5, 20);	
};	

void() W_FireCoilgun =
{
	local vector dir;

	sound (self, CHAN_WEAPON, "weapons/coilgun.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	if (!cvar("instagib")) self.currentammo = self.ammo_slugs = self.ammo_slugs - 1;
	else self.currentammo = self.ammo_slugs;
	UpdateAmmoCounts(self);
	dir = aim (self, 100000);
	FireSlug ();
};
*/

/*
================
FireBullets

Used by shotgun, super shotgun, and enemy soldier firing
Go to the trouble of combining multiple pellets into a single damage call.
================
*/
void(float shotcount, vector dir, vector spread) FireBullets =
{
	local vector direction;
	local vector src;
	//JIM
	local float bullet = 0;

	makevectors (self.v_angle);

	src = self.origin + v_forward * 10;
	src_z = self.absmin_z + self.size_z * 0.8125;

	ClearMultiDamage ();
	while (shotcount > 0)
	{
		direction = dir + crandom() * spread_x * v_right + crandom() * spread_y * v_up;

		traceline (src, src + direction * 2048, 0, self);
		if (trace_fraction != 1.0)
		{
			// JIM
			TraceAttack (4, direction);
			
			// Sleeper: Only make bullet hole sprites on walls if game world is hipnotic
			if (gameworld == HIPNOTIC)
			{	
				if ((!bullet) && (trace_ent == world))
				{
					placebullethole (trace_endpos);
					bullet = 1;
				}
			}
		}
		shotcount -= 1;
	}
	ApplyMultiDamage ();	
};

/*
================
W_FireShotgun
================
*/
void() W_FireShotgun =
{
	local vector dir;

	sound (self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	self.currentammo = self.ammo_shells1 = self.ammo_shells1 - 1;
	UpdateAmmoCounts (self);
	dir = aim (self, 100000);
	FireBullets (6, dir, '0.04 0.04 0');
};

/*
================
W_FireSuperShotgun
================
*/
void() W_FireSuperShotgun =
{
	local vector dir;

	if (self.currentammo == 1)
	{
		W_FireShotgun ();
		return;
	}

	sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);

	self.punchangle_x = -4;

	self.currentammo = self.ammo_shells1 = self.ammo_shells1 - 2;
	UpdateAmmoCounts (self);
	dir = aim (self, 100000);
	FireBullets (14, dir, '0.14 0.08 0');
};


/*
==============================================================================

ROCKETS

==============================================================================
*/

void()	s_explode1	=	[0,		s_explode2] {};
void()	s_explode2	=	[1,		s_explode3] {};
void()	s_explode3	=	[2,		s_explode4] {};
void()	s_explode4	=	[3,		s_explode5] {};
void()	s_explode5	=	[4,		s_explode6] {};
void()	s_explode6	=	[5,		SUB_Remove] {};

void() BecomeExplosion =
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};

void() T_MissileTouch =
{
	local float damg;

	if (other == self.owner) return; // don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	if (deathmatch && !coop) damg = 100;
	else damg = 100 + random() * 20;

	if (other.health)
	{
		other.deathtype = "rocket";	// QIP
		if (other.classname == "monster_shambler")
		{
			if (cvar("skill") == 5)
			{
				if (self.owner.super_damage_finished > time)
					damg = damg * 0.5;
				else
				{
					sound (self, CHAN_AUTO, "items/protect3.wav", 1, ATTN_NORM);
					damg = damg * 0.25; // ~75% immunity to rockets
				}
			}
			else 
			{
				if (self.owner.super_damage_finished > time)
					damg = damg * 0.5;
				else
					damg = damg * 0.5;  // ~50% immunity to rockets
			}
		}
		
		if (other.classname == "trap_spike_mine")
		{
			if (cvar("skill") <= 0)
				damg = damg * 1;  // 0% immunity to Rockets (Emulate 200 health)		
			else if (cvar("skill") >= 1 && cvar("skill") <= 4)
			{
				sound (self, CHAN_AUTO, "items/protect3.wav", 1, ATTN_NORM);
				damg = damg * 0.5;  // ~50% immunity to Rockets (Emulate 400 health)
			}
			else
			{
				if (self.owner.super_damage_finished > time)
					damg = damg * 0.5;
				else
				{
					sound (self, CHAN_AUTO, "items/protect3.wav", 1, ATTN_NORM);
					damg = damg * 0.25;  // ~75% immunity to Rockets (Emulate 800 health)
				}
			}		
		}
		
		// Chthon does double damage. You will not survive at least two direct hits.
		if (cvar("skill") == 5 && self.owner.classname == "monster_boss")
			T_Damage(other, self, self.owner, damg * 2);
		else
			T_Damage(other, self, self.owner, damg);
		
		// Centerprints to let the player know that Shamblers are resistant to Rockets.		
		if (T_Damage && other.classname == "monster_shambler")
		{
			if ((cvar("skill") == 5) && self.owner.super_damage_finished < time)
				id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Shamblers are heavily resistant\n to your rockets!");
			else if ((cvar("skill") == 5) && self.owner.super_damage_finished > time)
				id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Shamblers are resistant\n to your rockets!");
			else if ((cvar("skill") <= 4) && self.owner.super_damage_finished < time)
				id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Shamblers are resistant\n to your rockets!");
			else if ((cvar("skill") <= 4) && self.owner.super_damage_finished > time)	
				id1_centerprint(self.owner, "");
		}	
		// Sleeper: Tell the player that Spike Mines are resistant to rockets.
		if (T_Damage && other.classname == "trap_spike_mine")
		{
			if (cvar("skill") >= 1 && cvar("skill") <= 4 && self.owner.super_damage_finished < time)
				id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Spike Mines are resistant\n to your rockets!");
			else if (cvar("skill") >= 1 && cvar("skill") <= 4 && self.owner.super_damage_finished > time)
				id1_centerprint(self.owner, "");
			else if (cvar("skill") == 5 && self.owner.super_damage_finished < time)
				id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Spike Mines are heavily resistant\n to your rockets!");
			else if (cvar("skill") == 5 && self.owner.super_damage_finished > time)
				id1_centerprint(self.owner, "");
		}					
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact
//	T_RadiusDamage (self, self.owner, 120, other);
	T_RadiusDamage (self, self.owner, 120, other, "rocket");	// QIP

//	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin -= 8 * normalize (self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};



/*
================
W_FireRocket
================
*/
void() W_FireRocket =
{
	local entity missile;

	self.currentammo = self.ammo_rockets1 = self.ammo_rockets1 - 1;
	UpdateAmmoCounts(self);

	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";

// set missile speed

	makevectors (self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);

	missile.touch = T_MissileTouch;

// set missile duration
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/missile.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin + v_forward*8 + '0 0 16');
	//MED 11/09/96
	newmis = missile;
};

/*
===============================================================================

LIGHTNING

===============================================================================
*/

/*
=================
LightningDamage
=================
*/
void(vector p1, vector p2, entity from, float damage) LightningDamage =
{
	local entity e1, e2;
	local vector f;

	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f *= 16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);
//JIM
	if (trace_ent.takedamage && !trace_ent.wetsuit_finished)
	{
		if (trace_ent.classname == "trap_spike_mine")
		{
			if (cvar("skill") == 5)
			{
				particle (trace_endpos, '0 0 100', 225, damage * 4);
				T_Damage (trace_ent, from, from, damage * 0.25); // ~75% immunity to the Lightning Gun (Emulate 800 Health)
			}
			else if (cvar("skill") >= 1 && cvar("skill") <= 4)
			{
				particle (trace_endpos, '0 0 100', 225, damage * 4);
				T_Damage (trace_ent, from, from, damage * 0.5); // ~50% immunity to the Lightning Gun (Emulate 400 Health)
			}
			else if (cvar("skill") == 0)
			{
				particle (trace_endpos, '0 0 100', 225, damage * 4);
				T_Damage (trace_ent, from, from, damage); // 0% immunity to the Lightning Gun (Emulate 200 Health)
			}
		}
		else
		{
			particle (trace_endpos, '0 0 100', 225, damage * 4);
			T_Damage (trace_ent, from, from, damage);
		}
		
		/*
		if (self.classname == "player")
		{
			if (other.classname == "player") trace_ent.velocity_z += 400;
		}	
		*/	
	}
	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
//JIM
	if (trace_ent != e1 && trace_ent.takedamage && !trace_ent.wetsuit_finished)
	{
		particle (trace_endpos, '0 0 100', 225, damage * 4);
		T_Damage (trace_ent, from, from, damage);		
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
//JIM
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage && !trace_ent.wetsuit_finished)
	{
		particle (trace_endpos, '0 0 100', 225, damage * 4);
		T_Damage (trace_ent, from, from, damage);
	}
};

void() W_FireLightning =
{
	local vector org;
	local float cells, rnum;

	if (self.ammo_cells1 < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

// explode if under water
	if (self.waterlevel > 1)
	{
		cells = self.ammo_cells1;
		self.ammo_cells1 = 0;
		UpdateAmmoCounts(self);
		//MED 01/05/97 added discharge flag
		discharged = 1;
//		T_RadiusDamage (self, self, 35 * cells, world);
		T_RadiusDamage (self, self, 35 * cells, world, "");	// QIP
		// Sleeper: Emulate self discharge in co-op even if we've completely disabled friendly fire and self-damage.
		if (teamplay == 1 && coop == 1)
		{
			// don't kill yourself if have pentagram
			if (self.invincible_finished >= 1)
			{
				self.health -= 0;
				self.ammo_cells1 = 0;
				UpdateAmmoCounts(self);
				W_SetCurrentAmmo();
				return;
			}
			// don't kill yourself if have wetsuit
			else if (self.wetsuit_finished >= 1)
	                {
				self.health -= 0;
				self.ammo_cells1 = 0;
				UpdateAmmoCounts(self);
				W_SetCurrentAmmo();
				return;
			}
			// don't kill yourself if god mode is enabled
			else if (self.flags & FL_GODMODE)
			{
				self.health -= 0;
				self.ammo_cells1 = 0;
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
					if 	(self.watertype == CONTENT_WATER)
					{
						rnum = random();
						if (rnum < 0.4)
							bprint (" discharges into the water\n");
						else
							bprint (" heats up the water\n"); // Added
					}
					else if (self.watertype == CONTENT_SLIME)
						bprint (" discharges into the slime\n");
					else if (self.watertype == CONTENT_LAVA)
						bprint (" discharges into the lava\n");
					if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp")
						self.frags -= 1;	
							
					respawn();	
					self.ammo_cells1 = 0;
					UpdateAmmoCounts(self);
					W_SetCurrentAmmo();
					return;
				}
			}
		}
		discharged = 0;
		self.ammo_cells1 = 0;
		UpdateAmmoCounts(self);
		W_SetCurrentAmmo ();
		return;
	}

	if (self.t_width < time)
	{
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}
	self.punchangle_x = -2;

	self.currentammo = self.ammo_cells1 = self.ammo_cells1 - 1;
	UpdateAmmoCounts(self);

	org = self.origin + '0 0 16';

	traceline (org, org + v_forward * 600, TRUE, self);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	LightningDamage (self.origin, trace_endpos + v_forward * 4, self, 30);
};


//=============================================================================


void() GrenadeExplode =
{
//	T_RadiusDamage (self, self.owner, 120, world);
	T_RadiusDamage (self, self.owner, 120, world, "grenade");	// QIP

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};

void() GrenadeTouch =
{
	if (other == self.owner) return; // don't explode on owner
	
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}	
	
	// Centerprints to let the player know that Shamblers are resistant to Rockets.		
	if (T_Damage && other.classname == "monster_shambler")
	{
		if ((cvar("skill") == 5) && self.owner.super_damage_finished < time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Shamblers are heavily resistant\n to your grenades!");
		else if ((cvar("skill") == 5) && self.owner.super_damage_finished > time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Shamblers are resistant\n to your grenades!");
		else if ((cvar("skill") <= 4) && self.owner.super_damage_finished < time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Shamblers are resistant\n to your grenades!");
		else if ((cvar("skill") <= 4) && self.owner.super_damage_finished > time)	
			id1_centerprint(self.owner, "");
	}
		
	// Sleeper: Tell the player that Spike Mines are resistant to rockets.
	if (T_Damage && other.classname == "trap_spike_mine")
	{
		if (cvar("skill") >= 1 && cvar("skill") <= 4 && self.owner.super_damage_finished < time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Spike Mines are resistant\n to your grenades!");
		else if (cvar("skill") >= 1 && cvar("skill") <= 4 && self.owner.super_damage_finished > time)
			id1_centerprint(self.owner, "");
		else if (cvar("skill") == 5 && self.owner.super_damage_finished < time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Spike Mines are heavily resistant\n to your grenades!");
		else if (cvar("skill") == 5 && self.owner.super_damage_finished > time)
			id1_centerprint(self.owner, "");
	}
		
	if (other.takedamage == DAMAGE_AIM)
	{
		GrenadeExplode();
		return;
	}
	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);	// bounce sound
	if (self.velocity == '0 0 0') self.avelocity = '0 0 0';
};

/*
string GrenadeTimer_Slider_Animation[] =
{
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x81\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",
	"\x80\x83\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x81\x82",	
};

.float grenade_update_slider;
string() GrenadeTimer_Slider =
{
	if (self.grenade_update_slider < time) 
	{
		self.grenade_update_slider++;
		if (self.grenade_update_slider >= 30) self.grenade_update_slider = 0;
		self.grenade_update_slider = time + 0.2;
	}		
	
	return GrenadeTimer_Slider_Animation[self.grenade_update_slider];	
};
void() missile_timer_think =
{
	self.health -= 0.1;

	if (self.health <= 0 || self.owner == world)
	{
		self.health = 0;
		self.think = SUB_Null;
		remove (self);
		return;
	}
	else self.nextthink = time + 0.1;
	id1_centerprint(self.owner.owner, sprintf("%g", self.health));        
};
*/
/*
================
W_FireGrenade
================
*/
void() W_FireGrenade =
{
	local entity missile/*, timer*/;

	self.currentammo = self.ammo_rockets1 = self.ammo_rockets1 - 1;
	UpdateAmmoCounts(self);

	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
/*	
	timer = spawn ();
	timer.owner = missile;
	timer.think = missile_timer_think;
	timer.health = 2.5;
	timer.nextthink = time;
*/

// set missile speed

	makevectors (self.v_angle);

	if (self.v_angle_x) missile.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity_z = 200;
	}

	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);

	missile.touch = GrenadeTouch;

// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = GrenadeExplode;

	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin);
};

void() ProximityExplode =
{
//	T_RadiusDamage (self, self.owner, 95, world);
	T_RadiusDamage (self, self.owner, 95, world, "prox_mine");	// QIP

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};

//MED 10/31/96
float NumProximityGrenades;
/*
================
ProximityGrenadeExplode
================
*/
void() ProximityGrenadeExplode =
   {
   self.takedamage = DAMAGE_NO;
   NumProximityGrenades = NumProximityGrenades - 1;
   self.deathtype = "exploding";
   self.nextthink = time + 0.1;
   self.owner = self.lastvictim;
   self.think = ProximityExplode;
   };

/*
================
ProximityGrenadeTouch
================
*/
void() ProximityGrenadeTouch =
   {
   
         if (pointcontents(self.origin) == CONTENT_SKY) // Sleeper: Felt it was missing.
	{
		remove(self);
		return;
	}
   
   if (other == self)
      return;
  
	// Centerprints to let the player know that Shamblers are resistant to Rockets.		
	if (T_Damage && other.classname == "monster_shambler")
	{
		if ((cvar("skill") == 5) && self.owner.super_damage_finished < time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Shamblers are heavily resistant\n to your proximity mines!");
		else if ((cvar("skill") == 5) && self.owner.super_damage_finished > time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Shamblers are resistant\n to your proximity mines!");
		else if ((cvar("skill") <= 4) && self.owner.super_damage_finished < time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Shamblers are resistant\n to your proximity mines!");
		else if ((cvar("skill") <= 4) && self.owner.super_damage_finished > time)	
			id1_centerprint(self.owner, "");
	}
		
	// Sleeper: Tell the player that Spike Mines are resistant to rockets.
	if (T_Damage && other.classname == "trap_spike_mine")
	{
		if (cvar("skill") >= 1 && cvar("skill") <= 4 && self.owner.super_damage_finished < time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Spike Mines are resistant\n to your proximity mines!");
		else if (cvar("skill") >= 1 && cvar("skill") <= 4 && self.owner.super_damage_finished > time)
			id1_centerprint(self.owner, "");
		else if (cvar("skill") == 5 && self.owner.super_damage_finished < time)
			id1_centerprint(self.owner, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nCheck your fire!\n\n Spike Mines are heavily resistant\n to your proximity mines!");
		else if (cvar("skill") == 5 && self.owner.super_damage_finished > time)
			id1_centerprint(self.owner, "");
	}  
      
   if (other.classname == self.classname)
      return;
   self.movetype = MOVETYPE_TOSS;
   if (self.state == 1)
      return;
   if (vlen(other.velocity) > 0)
      {
      ProximityGrenadeExplode();
      self.think();
      return;
      }
   if (other.takedamage == DAMAGE_AIM)
      {
      ProximityGrenadeExplode();
      self.think();
      return;
      }
   sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM); // bounce sound
   self.movetype = MOVETYPE_NONE;
   setsize (self, '-8 -8 -8', '8 8 8');
   self.state = 1;
   self.spawnmaster = other;
   };

/*
================
ProximityBomb
================
*/
void() ProximityBomb =
   {
   local entity   head;
   local float    blowup;

   if ((time > self.delay) || (NumProximityGrenades > 15) || (vlen(self.spawnmaster.velocity)>0) )
      {
      ProximityGrenadeExplode();
      self.think();
      return;
      }
   self.owner = world;
   self.takedamage = DAMAGE_YES;
   head = findradius(self.origin, 140);
   blowup = 0;

   while (head)
      {
      if ((head != self) && (head.health > 0) && (head.flags & (FL_CLIENT|FL_MONSTER)) && (head.classname!=self.classname))
         blowup = 1;
      if ((head.classname == self.classname) && (head.state==0))
         blowup = 1;
      traceline(self.origin,head.origin,TRUE,self);
      if (trace_fraction != 1.0)
         blowup = 0;
      if (blowup==1)
         {
         sound (self, CHAN_WEAPON, "hipweap/proxwarn.wav", 1, ATTN_NORM);
         ProximityGrenadeExplode();
         self.nextthink = time + 0.5;
         return;
         }
      head = head.chain;
      }
   self.nextthink = time + 0.25;
   };

/*
================
W_FireProximityGrenade
================
*/
void() W_FireProximityGrenade =
   {
   local entity missile;

   NumProximityGrenades = NumProximityGrenades + 1;
   self.currentammo = self.ammo_rockets1 = self.ammo_rockets1 - 1;
   UpdateAmmoCounts(self);

   sound (self, CHAN_WEAPON, "hipweap/proxbomb.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
   missile.owner = self;
   missile.lastvictim = self;
   missile.movetype = MOVETYPE_TOSS;
	missile.solid = SOLID_BBOX;
   missile.classname = "proximity_grenade";
   missile.takedamage = DAMAGE_NO;
   missile.health = 5;
   missile.state = 0;

// set missile speed

	makevectors (self.v_angle);

	if (self.v_angle_x)
		missile.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity_z = 200;
	}

   missile.avelocity = '100 600 100';

	missile.angles = vectoangles(missile.velocity);

   missile.touch = ProximityGrenadeTouch;

// set missile duration
   missile.nextthink = time + 2;
   missile.delay = time + 15 + (10*random());
   missile.think = ProximityBomb;
   missile.th_die = ProximityGrenadeExplode;

   setmodel (missile, "progs/proxbomb.mdl");
   setorigin (missile, self.origin);
   setsize (missile, '-1 -1 -1', '1 1 1');
   };

//=============================================================================

void() spike_touch;
void() superspike_touch;
void() lavaspike_touch;
void() superlavaspike_touch;

/*
===============
launch_spike

Used for both the player and the ogre
===============
*/
void(vector org, vector dir) launch_spike =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);
	
	newmis.touch = spike_touch;
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 6;
	setmodel (newmis, "progs/spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (newmis, org);

	newmis.velocity = dir * 1000;
};

void(vector org, vector dir) launch_super_spike =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);
	
	newmis.touch = spike_touch;
	newmis.classname = "super_spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 6;
	setmodel (newmis, "progs/spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (newmis, org);

	newmis.velocity = dir * 1000;
};

void() W_FireSuperSpikes =
{
	local vector	dir;

	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails1 = self.ammo_nails1 - 2;
	UpdateAmmoCounts(self);
	dir = aim (self, 1000);
	launch_super_spike (self.origin + '0 0 16', dir);
	newmis.touch = superspike_touch;
	setmodel (newmis, "progs/s_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	self.punchangle_x = -2;
};

void(float ox) W_FireSpikes =
{
	local vector	dir;

	makevectors (self.v_angle);

	if (self.ammo_nails1 >= 2 && self.weapon == IT_SUPER_NAILGUN)
	{
		W_FireSuperSpikes ();
		return;
	}

	if (self.ammo_nails1 < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails1 = self.ammo_nails1 - 1;
	UpdateAmmoCounts(self);
	dir = aim (self, 1000);
	launch_spike (self.origin + '0 0 16' + v_right * ox, dir);

	self.punchangle_x = -2;
};



// .float hit_z;
void() spike_touch =
{
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

// hit something that bleeds
	if (other.takedamage)
	{
		other.deathtype = "nail";	// QIP
		if (other.classname == "trap_spike_mine")
		{
			if (cvar("skill") == 5)
			{
				spawn_touchblood (9);
				T_Damage (other, self, self.owner, 9 * 0.25); // 75% immunity to the Nailgun (Emulate 800 Health)... currently doesn't do anything because Spike Mines pop with one nail.
			}
			else if (cvar("skill") >= 1 && cvar("skill") <= 4)
			{
				spawn_touchblood (9);
				T_Damage (other, self, self.owner, 9 * 0.50); // 50% immunity to the Nailgun (Emulate 400 Health)... currently doesn't do anything because Spike Mines pop with one nail.
			}
			else if (cvar("skill") == 0)
			{
				spawn_touchblood (9);
				T_Damage (other, self, self.owner, 9); // 0% immunity to the Nailgun (Emulate 200 Health)... currently doesn't do anything because Spike Mines pop with one nail.
			}
		}
		else
		{
			spawn_touchblood (9);
			T_Damage (other, self, self.owner, 9);
		}
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);

		if (self.classname == "wizspike")
			WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
		else if (self.classname == "knightspike")
			WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
		else
			WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	remove(self);

};

void() superspike_touch =
{
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

// hit something that bleeds
	if (other.takedamage)
	{
		other.deathtype = "super_nail";	// QIP
		if (other.classname == "trap_spike_mine")
		{
			if (cvar("skill") == 5)
			{
				spawn_touchblood (18);
				T_Damage (other, self, self.owner, 18 * 0.25);	// 75% immunity to the Super Nailgun (Emulate 800 Health)... currently doesn't do anything because Spike Mines pop with one nail.
			}
			else if (cvar("skill") >= 1 && cvar("skill") <= 4)
			{
				spawn_touchblood (18);
				T_Damage (other, self, self.owner, 18 * 0.50); // 50% immunity to the Super Nailgun (Emulate 400 Health)... currently doesn't do anything because Spike Mines pop with one nail.
			}
			else if (cvar("skill") == 0)
			{
				spawn_touchblood (18);
				T_Damage (other, self, self.owner, 18); // 0% immunity to the Super Nailgun (Emulate 200 Health)... currently doesn't do anything because Spike Mines pop with one nail.
			}
		}
		else
		{
			spawn_touchblood (18);
			T_Damage (other, self, self.owner, 18);
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

	remove(self);

};

/*
===============================================================================

PLAYER WEAPON USE

===============================================================================
*/

//MED 10/18/96 added HIPWEAPONS
void() W_SetCurrentAmmo =
{
	player_run ();		// get out of any weapon firing states

	self.items -= self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS);
	self.expansionitems -= self.expansionitems & (DOE_LAVA_NAILS | DOE_PLASMA_AMMO | DOE_MULTI_ROCKETS/* | NQW_IT_SLUGS*/);	

	if (self.weapon == IT_AXE)
	{
		self.currentammo = 0;
		self.weaponmodel = self.nqwMeleeMdl;
		self.weaponframe = 0;
	}
// ZOID--
	else if (self.weapon == DOE_GRAPPLE)
	{
		self.currentammo = 0;
		self.weaponmodel = "progs/v_grpple.mdl";
		self.weaponframe = 0;
	}
// --ZOID	
	else if (self.weapon == IT_SHOTGUN)
	{
		self.currentammo = self.ammo_shells1;
		self.weaponmodel = "progs/v_shot.mdl";
		self.weaponframe = 0;
		self.items |= IT_SHELLS;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		self.currentammo = self.ammo_shells1;
		self.weaponmodel = "progs/v_shot2.mdl";
		self.weaponframe = 0;
		self.items |= IT_SHELLS;
	}
	// ROGUE ---------------------------------------
	else if (self.weapon == DOE_LAVA_NAILGUN)
	{
		self.currentammo = self.ammo_lava_nails;
		self.weaponmodel = "progs/v_lava.mdl";
		self.weaponframe = 0;
		self.expansionitems |= DOE_LAVA_NAILS;
	}
	else if (self.weapon == DOE_LAVA_SUPER_NAILGUN)
	{
		self.currentammo = self.ammo_lava_nails;
		self.weaponmodel = "progs/v_lava2.mdl";
		self.weaponframe = 0;
		self.expansionitems |= DOE_LAVA_NAILS;
	}
	else if (self.weapon == DOE_MULTI_GRENADE)
	{
		self.currentammo = self.ammo_multi_rockets;
		self.weaponmodel = "progs/v_multi.mdl";
		self.weaponframe = 0;
		self.expansionitems |= DOE_MULTI_ROCKETS;
	}
	else if (self.weapon == DOE_MULTI_ROCKET)
	{			
		self.currentammo = self.ammo_multi_rockets;
		self.weaponmodel = "progs/v_multi2.mdl";
		self.weaponframe = 0;
		self.expansionitems |= DOE_MULTI_ROCKETS;
	}
	else if (self.weapon == DOE_PLASMA_GUN)
	{
		self.currentammo = self.ammo_plasma;
		self.weaponmodel = "progs/v_plasma.mdl";
		self.weaponframe = 0;
		self.expansionitems |= DOE_PLASMA_AMMO;
	}
	// ---------------------------------------------	
	else if (self.weapon == IT_NAILGUN)
	{
		self.currentammo = self.ammo_nails1;
		self.weaponmodel = "progs/v_nail.mdl";
		self.weaponframe = 0;
		self.items |= IT_NAILS;
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		self.currentammo = self.ammo_nails1;
		self.weaponmodel = "progs/v_nail2.mdl";
		self.weaponframe = 0;
		self.items |= IT_NAILS;
	}
// MED  // HIPNOTIC ------------------------------------
	else if (self.weapon == IT_LASER_CANNON)
	{
		self.currentammo = self.ammo_cells1;
		self.weaponmodel = "progs/v_laserg.mdl";
		self.weaponframe = 0;
		self.items |= IT_CELLS;
	}
	// ---------------------------------------------
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets1;
		self.weaponmodel = "progs/v_rock.mdl";
		self.weaponframe = 0;
		self.items |= IT_ROCKETS;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets1;
		self.weaponmodel = "progs/v_rock2.mdl";
		self.weaponframe = 0;
		self.items |= IT_ROCKETS;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		self.currentammo = self.ammo_cells1;
		self.weaponmodel = "progs/v_light.mdl";
		self.weaponframe = 0;
		self.items |= IT_CELLS;
	}
// MED	// HIPNOTIC --------------------------------- 
	else if (self.weapon == IT_MJOLNIR)
	{
		self.currentammo = self.ammo_cells1;
		self.weaponmodel = self.nqwHammerMdl;
		self.weaponframe = 0;
		self.items |= IT_CELLS;
	}
	else if (self.weapon == IT_PROXIMITY_GUN)
	{
		self.currentammo = self.ammo_rockets1;
		self.weaponmodel = "progs/v_prox.mdl";
		self.weaponframe = 0;
		self.items |= IT_ROCKETS;
	}
	// -------------------------------------------
	/*
	else if (self.weapon == NQW_IT_COILGUN)
	{
		self.currentammo = self.ammo_slugs;
		self.weaponmodel = "progs/v_coilgun.mdl";
		self.weaponframe = 0;
		self.expansionitems |= NQW_IT_SLUGS;
	}
	*/
	else
	{
		self.currentammo = 0;
		self.weaponmodel = "";
		self.weaponframe = 0;
	}
	
	UpdateAmmoCounts(self);
};

float() W_BestWeapon =
{
	local	float	it;
	

	it = self.items;
	
	// pgm - fix for sandy. will not change to plasma gun
		
//	if (self.waterlevel <= 1 && self.ammo_plasma >= 1 && (it & IT_PLASMA_GUN))
//		return IT_PLASMA_GUN;
//	else 
	if (self.waterlevel <= 1 && self.ammo_cells1 >= 1 && (it & IT_LIGHTNING)) return IT_LIGHTNING;
	else if (self.ammo_cells1 >= 1 && (it & IT_LASER_CANNON)) return IT_LASER_CANNON;			
	else if (self.ammo_lava_nails >= 2 && (it & DOE_LAVA_SUPER_NAILGUN)) return DOE_LAVA_SUPER_NAILGUN;
	else if (self.ammo_nails1 >= 2 && (it & IT_SUPER_NAILGUN)) return IT_SUPER_NAILGUN;
	else if (self.ammo_lava_nails >= 1 && (it & DOE_LAVA_NAILGUN)) return DOE_LAVA_NAILGUN;
	else if (self.ammo_nails1 >= 1 && (it & IT_NAILGUN)) return IT_NAILGUN;
	else if (self.ammo_shells1 >= 2 && (it & IT_SUPER_SHOTGUN)) return IT_SUPER_SHOTGUN;
	else if (self.ammo_shells1 >= 1 && (it & IT_SHOTGUN)) return IT_SHOTGUN;
	else if (it & IT_MJOLNIR) return IT_MJOLNIR;
//	else if (self.ammo_slugs >= 1 && (it & NQW_IT_SLUGS)) return NQW_IT_COILGUN;
			
	return IT_AXE;
};

float() W_CheckNoAmmo =
{
	if (self.currentammo > 0) return TRUE;
//ZOID--
	if (self.weapon == IT_AXE || self.weapon == DOE_GRAPPLE) return TRUE;
//--ZOID
//	if (self.weapon == IT_AXE) return TRUE;
//MED
	if (self.weapon == IT_MJOLNIR) return TRUE;

	self.weapon = W_BestWeapon ();

	W_SetCurrentAmmo ();

// drop the weapon down
	return FALSE;
};

/*
============
W_Attack

An attack impulse can be triggered now
============
*/
void() player_axe1;
void() player_axeb1;
void() player_axec1;
void() player_axed1;
void() player_shot1;
void() player_nail1;
void() player_light1;
void() player_rocket1;
//MED
void() player_laser1;
void() player_hammer1;
void() player_mjolnir1;
void() player_lava_nail1;
//ZOID--
void() player_grapple1;
void() player_grapple3;
//--ZOID
void() W_FireMultiGrenade;
void() W_FireMultiRocket;


void() W_Attack =
{
	local float r;

	if (!W_CheckNoAmmo()) return;

	makevectors (self.v_angle); // Calculate forward angle for velocity
	self.show_hostile = time + 1;	// Wake monsters up
	

// ZOID--
	RuneApplyBlackNoise (self); // make rune noise
//--ZOID

	if (self.weapon == IT_AXE)
	{
		sound (self, CHAN_WEAPON, self.nqwSndMelee, 1, ATTN_NORM);
		r = random();
		if (r < 0.25) player_axe1 ();
		else if (r < 0.5) player_axeb1 ();
		else if (r < 0.75) player_axec1 ();
		else player_axed1 ();
		self.attack_finished = time + RuneApplyHell(0.5, self);
	}
	else if (self.weapon == DOE_GRAPPLE)
	{
		if (!self.hook_out) player_grapple1();
		else player_grapple3 ();
		self.attack_finished = time + 0.1;
	}	
	else if (self.weapon == IT_SHOTGUN)
	{
		player_shot1 ();
		W_FireShotgun ();
		self.attack_finished = time + RuneApplyHell(0.5, self);
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		player_shot1 ();
		W_FireSuperShotgun ();
		self.attack_finished = time + RuneApplyHell(0.7, self);
	}
	else if (self.weapon == DOE_LAVA_NAILGUN)
	{
		self.lavaGunFired = 1;
		player_lava_nail1 ();
	}
	else if (self.weapon == DOE_LAVA_SUPER_NAILGUN)
	{
		self.lavaGunFired = 1;
		player_lava_nail1 ();
	}
	else if (self.weapon == DOE_MULTI_GRENADE)
	{
		player_rocket1 ();
		W_FireMultiGrenade ();
		self.attack_finished = time + RuneApplyHell(0.6, self);
	}
	else if (self.weapon == DOE_MULTI_ROCKET)
	{
		player_rocket1 ();
		W_FireMultiRocket ();
		self.attack_finished = time + RuneApplyHell(0.8, self);
	}
	else if (self.weapon == DOE_PLASMA_GUN)
	{
		// player_light1 determines choice of W_FireLightning 
		//	or W_FirePlasma, but same lighting and frames...
		player_light1 ();
		self.attack_finished = time + RuneApplyHell(1.0, self);
	}	
	else if (self.weapon == IT_NAILGUN) player_nail1 ();
	else if (self.weapon == IT_SUPER_NAILGUN) player_nail1 ();
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		player_rocket1 ();
		W_FireGrenade ();
		self.attack_finished = time + RuneApplyHell(0.6, self);
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		player_rocket1 ();
		W_FireRocket ();
		self.attack_finished = time + RuneApplyHell(0.8, self);
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		player_light1 ();
//		self.attack_finished = time + 0.1;
//		self.attack_finished = time + RuneApplyHell(0.1, self);
		sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
	}
//MED
	else if (self.weapon == IT_LASER_CANNON) player_laser1 ();
//MED
	else if (self.weapon == IT_MJOLNIR)
	{
		if (self.ammo_cells1 < 30) player_hammer1 ();
		else player_mjolnir1 ();
		self.attack_finished = time + RuneApplyHell(0.8, self);
	}
//MED
	else if (self.weapon == IT_PROXIMITY_GUN)
	{
		player_rocket1();
		W_FireProximityGrenade ();
		self.attack_finished = time + RuneApplyHell(0.6, self);
	}
	/*else if (self.weapon == NQW_IT_COILGUN)
	{
		player_rocket1();
		W_FireCoilgun ();
		if (cvar("instagib") == 2) self.attack_finished = time + RuneApplyHell(1.1, self);
		else self.attack_finished = time + RuneApplyHell(2, self);
	}*/
	
	else return;
};

/*
============
W_ChangeWeapon

============
*/
//MED 10/18/96 added hipweapons
void() W_ChangeWeapon =
{
	local float noammo;
	local float new, current;
	local float item;
	
	EnableComboWeapons (self);
	UpdateAmmoCounts (self);
	
	noammo = 0;

	if (self.impulse == 1) 
	{	
		if (self.weapon == IT_AXE) 
		{
			if (!cvar("use_grappling_hook")) // Sleeper: Grappling hook is disabled, don't use it.
			{		
				sprint (self, "Grappling Hook must be enabled first!\n");
				new = IT_AXE;
			}
			else 
			{
				if (self.weapons & DOE_GRAPPLE) new = DOE_GRAPPLE;
				else new = IT_AXE;
			}
		}
		else new = IT_AXE; 								 
	}
	else if (self.impulse == 22) 
	{
		if (!cvar("use_grappling_hook")) // Sleeper: Grappling hook is disabled, don't use it.
		{
			sprint (self, "Grappling Hook must be enabled first!\n");
			return;
		}
		new = DOE_GRAPPLE;
	}
	else if (self.impulse == 23) new = IT_AXE;	
	else if (self.impulse == 2) 
	{
		new = IT_SHOTGUN;
		if (self.ammo_shells1 < 1) noammo = 1;
	}
	else if (self.impulse == 3) 
	{
		new = IT_SUPER_SHOTGUN;
		if (self.ammo_shells1 < 2) noammo = 1;
	}		
	else if (self.impulse == 4) 
	{
		if (self.weapon == IT_NAILGUN)
		{
			if (self.weapons & DOE_LAVA_NAILGUN)
			{
				new = DOE_LAVA_NAILGUN;
				if (self.ammo_lava_nails < 1) noammo = 1;
			}
			else
			{
				new = IT_NAILGUN;
				if (self.ammo_nails1 < 1) noammo = 1;
			}
		}
		else if (self.weapons & IT_NAILGUN)
		{
			new = IT_NAILGUN;
			if (self.ammo_nails1 < 1) noammo = 1;
		}
		else
		{
			new = DOE_LAVA_NAILGUN;
			if (self.ammo_lava_nails < 1) noammo = 1;
		}
	}
	else if (self.impulse == 5) 
	{
		if (self.weapon == IT_SUPER_NAILGUN)
		{
			if (self.weapons & DOE_LAVA_SUPER_NAILGUN)
			{
				new = DOE_LAVA_SUPER_NAILGUN;
				if (self.ammo_lava_nails < 2) noammo = 1;
			}
			else
			{
				new = IT_SUPER_NAILGUN;
				if (self.ammo_nails1 < 2) noammo = 1;
			}
		}
		else if (self.weapons & IT_SUPER_NAILGUN)
		{
			new = IT_SUPER_NAILGUN;
			if (self.ammo_nails1 < 2) noammo = 1;
		}
		else
		{
			new = DOE_LAVA_SUPER_NAILGUN;
			if (self.ammo_lava_nails < 2) noammo = 1;
		}		
	}
	else if (self.impulse == 6) 
	{		
		if (self.weapon == IT_GRENADE_LAUNCHER) 
		{
			if (self.weapons & IT_PROXIMITY_GUN)
			{
				new = IT_PROXIMITY_GUN;
				if (self.ammo_rockets1 < 1) noammo = 1;
			}
			else
			{
				new = DOE_MULTI_GRENADE;
				if (self.ammo_multi_rockets < 1) noammo = 1;
			}
		}
		else if (self.weapon == IT_PROXIMITY_GUN) 
		{
			if (self.weapons & DOE_MULTI_GRENADE)
			{
				new = DOE_MULTI_GRENADE;
				if (self.ammo_multi_rockets < 1) noammo = 1;
			}
			else 
			{
				new = item = IT_GRENADE_LAUNCHER;
				if (self.ammo_rockets1 < 1) noammo = 1;
			}
		}
		else if (self.weapon == DOE_MULTI_GRENADE)
		{
			if (self.weapons & IT_GRENADE_LAUNCHER)
			{
				new = IT_GRENADE_LAUNCHER;
				if (self.ammo_rockets1 < 1) noammo = 1;
			}
			else
			{
				new = IT_PROXIMITY_GUN;
				if (self.ammo_rockets1 < 1) noammo = 1;				
			}
		}
		else if (self.weapons & IT_GRENADE_LAUNCHER)
		{
			new = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets1 < 1) noammo = 1;			
		}
		else if (self.weapons & IT_PROXIMITY_GUN)
		{
			new = IT_PROXIMITY_GUN;
			if (self.ammo_rockets1 < 1) noammo = 1;			
		}
		else
		{
			new =  DOE_MULTI_GRENADE;
			if (self.ammo_multi_rockets < 1) noammo = 1;				
		}
	}
	else if (self.impulse == 7) 
	{
		if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			if (self.weapons & DOE_MULTI_ROCKET)
			{
				new = DOE_MULTI_ROCKET;
				if (self.ammo_multi_rockets < 1) noammo = 1;
			}
			else
			{
				new = IT_ROCKET_LAUNCHER;
				if (self.ammo_rockets1 < 1) noammo = 1;
			}		
		}
		else if (self.weapon == DOE_MULTI_ROCKET)
		{
			if (self.weapons & IT_ROCKET_LAUNCHER)
			{
				new = IT_ROCKET_LAUNCHER;
				if (self.ammo_rockets < 1) noammo = 1;
			}	
			else
			{
				new = DOE_MULTI_ROCKET;
				if (self.ammo_multi_rockets < 1) noammo = 1;
			}
		}
		else if (self.weapons & IT_ROCKET_LAUNCHER)
		{
			new = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1) noammo = 1;			
		}
		else
		{		
			new = DOE_MULTI_ROCKET;
			if (self.ammo_multi_rockets < 1) noammo = 1;			
		}
	}
	else if (self.impulse == 8) 
	{
		if (self.weapon == IT_LIGHTNING) 
		{
			if (self.weapons & DOE_PLASMA_GUN)
			{
				new = DOE_PLASMA_GUN;
				if (self.ammo_plasma < 1) noammo = 1;
			}
			else
			{
				new = IT_LIGHTNING;
				if (self.ammo_cells1 < 1) noammo = 1;
			}
		}
		else if (self.weapon == DOE_PLASMA_GUN) 
		{
			if (self.weapons & IT_LIGHTNING)
			{
				new = IT_LIGHTNING;
				if (self.ammo_cells1 < 1) noammo = 1;
			}
			else 
			{
				new = DOE_PLASMA_GUN;
				if (self.ammo_plasma < 1) noammo = 1;				
			}
		}
		else if (self.weapons & IT_LIGHTNING)
		{
			new = IT_LIGHTNING;
			if (self.ammo_cells1 < 1) noammo = 1;			
		}
		else 
		{
			new = DOE_PLASMA_GUN;
			if (self.ammo_plasma < 1) noammo = 1;
		}
	}
	else if (self.impulse == 60)
	{
		new = DOE_LAVA_NAILGUN;
		if (self.ammo_lava_nails < 1) noammo = 1;
	}
	else if (self.impulse == 61)
	{
		new = DOE_LAVA_SUPER_NAILGUN;
		if (self.ammo_lava_nails < 1) noammo = 1;
	}
	else if (self.impulse == 62)
	{
		new = DOE_MULTI_GRENADE;
		if (self.ammo_multi_rockets < 1) noammo = 1;
	}
	else if (self.impulse == 63)
	{
		new = DOE_MULTI_ROCKET;
		if (self.ammo_multi_rockets < 1) noammo = 1;
	}
	else if (self.impulse == 64)
	{
		new = DOE_PLASMA_GUN;
		if (self.ammo_plasma < 1) noammo = 1;
	}	
	else if (self.impulse == 225) 
	{
		new = IT_LASER_CANNON;
		if (self.ammo_cells1 < 1) noammo = 1;
	}
	else if (self.impulse == 226) new = IT_MJOLNIR;		
	else if (self.impulse == 227) 
	{
		new = IT_PROXIMITY_GUN;
		if (self.ammo_cells1 < 1) noammo = 1;
	} 
	else if (self.impulse == 228) 
	{
		new = IT_GRENADE_LAUNCHER;
		if (self.ammo_cells1 < 1) noammo = 1;
	}/*
	else if (self.impulse == 229)
	{
		new = NQW_IT_COILGUN;
		if (self.ammo_slugs < 1) noammo = 1;
	}*/
	
	
	self.impulse = 0;
	
	if (new) 
	{
		if (!(self.weapons & new))
		 {	
		 	// don't have the weapon or the ammo
			sprint (self, "no weapon.\n");
			return;
		}
	}
		
	if (noammo) 
	{	
		// don't have the ammo
		sprint (self, "not enough ammo.\n");
		return;
	}
	
	if (gameworld == HIPNOTIC || gameworld == ROGUE) // Sleeper: Might get annoying outside the mission packs.
	{
		if (self.weapon != new)
		{
			if (new == IT_NAILGUN || new == IT_SUPER_NAILGUN) sprint (self, "Normal Nails\n");
			else if (new == IT_GRENADE_LAUNCHER) sprint (self, "Normal Grenades\n");
			else if (new == IT_PROXIMITY_GUN) sprint (self, "Proximity Mines\n");
			else if (new == IT_ROCKET_LAUNCHER) sprint (self, "Normal Rockets\n");
			else if (new == IT_LIGHTNING) sprint (self, "Lightning Gun\n");
			else if (new == DOE_LAVA_NAILGUN || new == DOE_LAVA_SUPER_NAILGUN) sprint (self, "Lava Nails!\n");
			else if (new == DOE_MULTI_GRENADE) sprint (self, "Multi Grenades!\n");
			else if (new == DOE_MULTI_ROCKET) sprint (self, "Multi Rockets!\n");
			else if (new == DOE_PLASMA_GUN) sprint (self, "Plasma Gun!\n");
		}
	}	
	
//
// set weapon, set ammo
//
	current = self.weapon;
	self.weapon = new;

	W_SetCurrentAmmo ();	
};	

float cheats_allowed;

/*
============
CheatCommand
============
*/
void() CheatCommand =
{
	if ((deathmatch || coop) && (cheats_allowed == 0) && !(cvar("developer"))) return; // mal: allow impulse 9 IF cheats allowed

	self.ammo_rockets1 	= 100;
	self.ammo_nails1 	= 200;
	self.ammo_shells1 	= 100;
	self.ammo_cells1	= 100;
	self.ammo_lava_nails    = 200;
	self.ammo_multi_rockets = 100;
	self.ammo_plasma 	= 100;	
	self.ammo_slugs		= 100;
	
//	self.armorvalue 	= 200;		
//	self.items   |= HUD_WEAPONS | IT_ARMOR3 | IT_KEY1 | IT_KEY2 | IT_INVULNERABILITY | IT_QUAD | IT_SUIT | IT_INVISIBILITY;
	self.items   |= HUD_WEAPONS;			
	self.weapons |= ALL_WEAPONS;				
	self.weapon   = IT_ROCKET_LAUNCHER;		       
	self.impulse  = 0;
	W_SetCurrentAmmo ();
};

/*
============
CycleWeaponCommand

Go to the next weapon with ammo
============
*/
void() CycleWeaponCommand =
{
	local float weaps, current, noammo, loop;
	
	EnableComboWeapons (self);
	UpdateAmmoCounts (self);	
	weaps = self.weapons;
	
	self.impulse = 0;
	self.weaponframe = 0;

	current = self.weapon;
	
	while (TRUE)
	{
		noammo = FALSE;
		
		if (self.weapon == IT_AXE) self.weapon = DOE_GRAPPLE;			
		else if (self.weapon == DOE_GRAPPLE)
		{
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells1 < 1) noammo = TRUE;
		}
		else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells1 < 2) noammo = TRUE;
		}		
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_NAILGUN;
			if (self.ammo_nails1 < 1) noammo = TRUE;
		}
		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = DOE_LAVA_NAILGUN;
			if (self.ammo_lava_nails < 1) noammo = TRUE;
		}
		else if (self.weapon == DOE_LAVA_NAILGUN)
		{
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails1 < 2) noammo = TRUE;
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = DOE_LAVA_SUPER_NAILGUN;
			if (self.ammo_nails1 < 2) noammo = TRUE;
		}	
		else if (self.weapon == DOE_LAVA_SUPER_NAILGUN)
		{
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_nails1 < 2) noammo = TRUE;
		}				
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets1 < 1) noammo = TRUE;
		}
		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = IT_PROXIMITY_GUN;
			if (self.ammo_rockets1 < 1) noammo = TRUE;
		}
		else if (self.weapon == IT_PROXIMITY_GUN)
		{
			self.weapon = DOE_MULTI_GRENADE;
			if (self.ammo_multi_rockets < 1) noammo = TRUE;
		}
		else if (self.weapon == DOE_MULTI_GRENADE)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets1 < 1) noammo = TRUE;
		}
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = DOE_MULTI_ROCKET;
			if (self.ammo_multi_rockets < 1) noammo = TRUE;
		}
		else if (self.weapon == DOE_MULTI_ROCKET)
		{
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells1 < 1) noammo = TRUE;
		}				
		else if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = DOE_PLASMA_GUN;
			if (self.ammo_plasma < 1) noammo = TRUE;
		}
		else if (self.weapon == DOE_PLASMA_GUN)
		{
			self.weapon = IT_LASER_CANNON;
			if (self.ammo_cells1 < 1) noammo = TRUE;			
		}
		else if (self.weapon == IT_LASER_CANNON)
		{
			self.weapon = IT_MJOLNIR;
			if (self.ammo_cells1 < 1) noammo = TRUE;			
		}		
		else if (self.weapon == IT_MJOLNIR) self.weapon = IT_AXE;
/*		else if (self.weapon == IT_MJOLNIR) 
		{	
			self.weapon = NQW_IT_COILGUN;
			if (self.ammo_slugs < 1) noammo = TRUE;
		}
		else if (self.weapon == NQW_IT_COILGUN) self.weapon = IT_AXE;
		*/
			
		
//		if ((weaps & self.weapon && !noammo) || loop > 18)
		if ((weaps & self.weapon && !noammo) || loop > 17)
		{
			W_SetCurrentAmmo();			
			return;
		}

		loop++;
	}
};

/*
============
CycleWeaponReverseCommand

Go to the prev weapon with ammo
============
*/
void() CycleWeaponReverseCommand =
{
	local float weaps, current, noammo, loop;
	
	EnableComboWeapons (self);
	UpdateAmmoCounts (self);	
	weaps = self.weapons;

	self.impulse = 0;
	self.weaponframe = 0;

	current = self.weapon;

	while (TRUE)
	{
		noammo = FALSE;
			
		if (self.weapon == IT_MJOLNIR)
		{
			self.weapon = IT_LASER_CANNON;
			if (self.ammo_cells1 < 1) noammo = TRUE;
		}
		else if (self.weapon == IT_LASER_CANNON)
		{
			self.weapon = DOE_PLASMA_GUN;
			if (self.ammo_plasma < 1) noammo = TRUE;
		}		
		else if (self.weapon == DOE_PLASMA_GUN)
		{
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells1 < 1) noammo = TRUE;
		}
		else if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = DOE_MULTI_ROCKET;
			if (self.ammo_multi_rockets < 1) noammo = TRUE;
		}		
		else if (self.weapon == DOE_MULTI_ROCKET)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets1 < 1) noammo = TRUE;
		}
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = DOE_MULTI_GRENADE;
			if (self.ammo_multi_rockets < 1) noammo = TRUE;
		}	
		else if (self.weapon == DOE_MULTI_GRENADE)
		{
			self.weapon = IT_PROXIMITY_GUN;
			if (self.ammo_rockets1 < 1) noammo = TRUE;
		}
		else if (self.weapon == IT_PROXIMITY_GUN)
		{
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets1 < 1) noammo = TRUE;
		}
		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = DOE_LAVA_SUPER_NAILGUN;
			if (self.ammo_lava_nails < 2) noammo = TRUE;
		}
		else if (self.weapon == DOE_LAVA_SUPER_NAILGUN)
		{
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails1 < 2) noammo = TRUE;
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = DOE_LAVA_NAILGUN;
			if (self.ammo_nails1 < 1) noammo = TRUE;
		}				
		else if (self.weapon == DOE_LAVA_NAILGUN)
		{
			self.weapon = IT_NAILGUN;
			if (self.ammo_nails1 < 1) noammo = TRUE;
		}
		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells1 < 2) noammo = TRUE;
		}		
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells1 < 1) noammo = TRUE;
		}
		else if (self.weapon == IT_SHOTGUN) self.weapon = DOE_GRAPPLE;
		else if (self.weapon == DOE_GRAPPLE) self.weapon = IT_AXE;
		else if (self.weapon == IT_AXE) self.weapon = IT_MJOLNIR;

/*		else if (self.weapon == IT_AXE) self.weapon = NQW_IT_COILGUN;
		else if (self.weapon == NQW_IT_COILGUN) self.weapon = IT_MJOLNIR;*/
				
//		if ((weaps & self.weapon && !noammo) || loop > 18)
		if ((weaps & self.weapon && !noammo) || loop > 17)
		{
			W_SetCurrentAmmo();
			return;
		}
		
		loop++;
	}
};

/*
============
ServerflagsCommand

Just for development
============
*/
void() ServerflagsCommand = {serverflags *= 2 + 1;};

void() QuadCheat =
{
	if (deathmatch || coop && !cvar("developer")) return;
		
	self.super_time = 1;
	self.super_damage_finished = time + 30;
	self.items |= IT_QUAD;
	sprint (self, "quad cheat\n");	
};

//MED
void() WetsuitCheat =
{
	if (deathmatch || coop) return;
	
	self.expansionitems |= HIP_IT_WETSUIT;
	self.wetsuit_time = 1;
	self.wetsuit_finished = time + 30;
	bprint ("wetsuit cheat\n");
};

//MED
void() EmpathyShieldsCheat =
{
	if (deathmatch || coop) return;
	
	self.expansionitems |= HIP_IT_EMPATHY_SHIELDS;
	self.empathy_time = 1;
	self.empathy_finished = time + 30;
	bprint ("empathycheat\n");
};

void() DumpEntities =
{
	local float i = 1;
	local entity head = nextent (world);
	while (head != world)
	{
		dprint (ftos(i));
		dprint (" ");
		dprint (head.classname);
		dprint ("\n");
		head = nextent (head);
		i += 1;
	}
};

void() DumpLiveEntities =
{
	local float i = 1;
	local entity head = nextent (world);
	while (head != world)
	{
		if (head.health > 0)
		{
			dprint (ftos(i));
			dprint (" ");
			dprint (head.classname);
			dprint (" ");
			dprint (vtos(head.origin));
			dprint ("\n");
			dprint ("--------------------\n");
		}
		head = nextent(head);
		i += 1;
	}
};

float dump_coord;
void() ToggleDump =
{
	dump_coord = 1 - dump_coord;
	if (dump_coord == 1) bprint ("$qc_dump_player_loc");
};

void() DumpCoordinates =
{
	local entity pl = checkclient ();
	if (pl)
	{
		bprint ("Player: ");
		bprint (vtos(pl.origin));
		bprint ("\n");
	}
};

void() Omnicide = 
{
	local entity oself = self;
	self = nextent (world);
	while (self)
	{
		if (self.flags & (FL_MONSTER | FL_FUTUREMONSTER))
		{
			if (self.target || self.killtarget) SUB_UseTargets ();
			SUB_Remove ();
		}
		self = nextent (self);
	}
	self = oself;

	killed_monsters = total_monsters;
	WriteByte (MSG_ALL, SVC_UPDATESTAT);
	WriteByte (MSG_ALL, 14); // 14 = STAT_MONSTERS
	WriteLong (MSG_ALL, total_monsters);
}
  
void() Skill_Scaled =
{	
	if (!cvar("customcoop")) return;

	local entity cl = find (world, classname, "player");
	while (cl != world) 
	{
		if (cvar("skill") <= 2 && num_players == 3)
		{
			id1_centerprint (cl, "Skill has scaled to Classic Nightmare!", "\n");
			sound (cl, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);
		}
		cl = find (cl, classname, "player");
	}
};
   
/*
============
SkillVotables

Choose a skill on the fly (Note: Changing a skill on the fly may introduce bugs -- players should report them)
============
*/
void() SkillVotables =
{
	local float start_maps = (world.model == "maps/start.bsp" || world.model == "maps/hipstart.bsp" || world.model == "maps/rstart.bsp" || world.model == "maps/e5start.bsp" || world.model == "maps/mgstart.bsp" || world.model == "maps/hub.bsp");
	
	entity cl = find(world, classname, "player");
	if (self.impulse == 50)
	{
		bprint("Skill changed to Easy", "\n");
		while (cl) 
		{
			// Set the skill on the server.
			localcmd("skill 0\n");
			// Set the skill on the client. (Makes things convenient to check skill)
			stuffcmd(cl, "skill 0\n");
			
			// Upon skill change, for players less than 50 health will be brought up to 50 health.
			if (cl.health < 50) cl.health = 50;
			// If the map is a start map, allow players to bring their health back up to 100.
			if (start_maps) cl.health = 100;		
			cl.max_health = 100;  // Make sure max health is 100.
			
			// To make sure armors are ironed out so they don't appear to be a higher value -- however, if players have rot-able armor values, armors will rot first in skill 5.
			if (cl.items & IT_ARMOR1) // Set max Armorvalue and armortype.
			{
				cl.armortype = 0.3;
				cl.max_armorvalue = 100;			
			}
			if (cl.items & IT_ARMOR2) // Set max Armorvalue and armortype.
			{
				cl.armortype = 0.6;	
				cl.max_armorvalue = 150;		
			}
			if (cl.items & IT_ARMOR3) // Set max Armorvalue and armortype.
			{
				cl.armortype = 0.8;
				cl.max_armorvalue = 200;		
			}
			if (cl.health_deflate == 0)
			{			
				if (cl.health > cl.max_health)
					cl.health_deflate = 1;
				else if (cl.health <= cl.max_health)
					cl.health_deflate = 0;
			}			
			
			id1_centerprint(cl, "Easy Skill has been set");
			sound(cl, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC); // Sound for when the skill gets changed.
			cl = find(cl, classname, "player");	
		}
	}
	else if (self.impulse == 51)
	{
		bprint("Skill changed to Normal", "\n");
		while (cl) 
		{
			// Set the skill on the server.
			localcmd("skill 1\n");
			// Set the skill on the client. (Makes things convenient to check skill)
			stuffcmd(cl, "skill 1\n");
			
			// Upon skill change, for players less than 50 health will be brought up to 50 health.
			if (cl.health < 50) cl.health = 50;
			// If the map is a start map, allow players to bring their health back up to 100.
			if (start_maps) cl.health = 100;
			cl.max_health = 100; // Make sure max health is 100.
			
			// To make sure armors are ironed out so they don't appear to be a higher value -- however, if players have rot-able armor values, armors will rot first in skill 5.
			if (cl.items & IT_ARMOR1) // Set max Armorvalue and armortype.
			{
				cl.armortype = 0.3;
				cl.max_armorvalue = 100;			
			}
			if (cl.items & IT_ARMOR2) // Set max Armorvalue and armortype.
			{
				cl.armortype = 0.6;	
				cl.max_armorvalue = 150;		
			}
			if (cl.items & IT_ARMOR3) // Set max Armorvalue and armortype.
			{
				cl.armortype = 0.8;
				cl.max_armorvalue = 200;		
			}			
			if (cl.health_deflate == 0)
			{			
				if (cl.health > cl.max_health)
					cl.health_deflate = 1;
				else if (cl.health <= cl.max_health)
					cl.health_deflate = 0;
			}
			
			id1_centerprint(cl, "Normal Skill has been set");
			sound(cl, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC); // Sound for when the skill gets changed.
			cl = find(cl, classname, "player");
		}
	}
	else if (self.impulse == 52)
	{
		bprint("Skill changed to Hard", "\n");
		while (cl) 
		{
			// Set the skill on the server.
			localcmd("skill 2\n");
			// Set the skill on the client. (Makes things convenient to check skill)
			stuffcmd(cl, "skill 2\n");
			
			// Upon skill change, for players less than 50 health will be brought up to 50 health.
			if (cl.health < 50) cl.health = 50;
			// If the map is a start map, allow players to bring their health back up to 100.
			if (start_maps) cl.health = 100;		
			cl.max_health = 100; // Make sure max health is 100.

			// To make sure armors are ironed out so they don't appear to be a higher value -- however, if players have rot-able armor values, armors will rot first in skill 5.
			if (cl.items & IT_ARMOR1) // Set max Armorvalue and armortype.
			{
				cl.armortype = 0.3;
				cl.max_armorvalue = 100;			
			}
			if (cl.items & IT_ARMOR2) // Set max Armorvalue and armortype.
			{
				cl.armortype = 0.6;	
				cl.max_armorvalue = 150;		
			}
			if (cl.items & IT_ARMOR3) // Set max Armorvalue and armortype.
			{
				cl.armortype = 0.8;
				cl.max_armorvalue = 200;		
			}
			if (cl.health_deflate == 0)
			{			
				if (cl.health > cl.max_health)
					cl.health_deflate = 1;
				else if (cl.health <= cl.max_health)
					cl.health_deflate = 0;
			}		
			
			id1_centerprint(cl, "Hard Skill has been set");
			sound(cl, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC); // Sound for when the skill gets changed.
			cl = find(cl, classname, "player");
		}
	}
	else if (self.impulse == 53)
	{
		bprint("Skill changed to Classic Nightmare!", "\n");
		while (cl) 
		{
			// Set the skill on the server.
			localcmd("skill 3\n");
			// Set the skill on the client. (Makes things convenient to check skill)
			stuffcmd(cl, "skill 3\n");
			
			// Upon skill change, for players less than 50 health will be brought up to 50 health.
			if (cl.health < 50) cl.health = 50;
			// If the map is a start map, allow players to bring their health back up to 100.
			if (start_maps) cl.health = 100;		
			cl.max_health = 100; // Make sure max health is 100.
			
			// To make sure armors are ironed out so they don't appear to be a higher value -- however, if players have rot-able armor values, armors will rot first in skill 5.
			if (cl.items & IT_ARMOR1) // Set max Armorvalue and armortype.
			{
				cl.armortype = 0.3;
				cl.max_armorvalue = 100;			
			}
			if (cl.items & IT_ARMOR2) // Set max Armorvalue and armortype.
			{
				cl.armortype = 0.6;	
				cl.max_armorvalue = 150;		
			}
			if (cl.items & IT_ARMOR3) // Set max Armorvalue and armortype.
			{
				cl.armortype = 0.8;
				cl.max_armorvalue = 200;		
			}
			if (cl.health_deflate == 0)
			{			
				if (cl.health > cl.max_health)
					cl.health_deflate = 1;
				else if (cl.health <= cl.max_health)
					cl.health_deflate = 0;
			}
			
			id1_centerprint(cl, "Classic Nightmare! Skill has been set");
			sound(cl, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC); // Sound for when the skill gets changed.
			cl = find(cl, classname, "player");
		}
	}
	else if (self.impulse == 54)
	{
		bprint("Skill changed to KEX Nightmare!", "\n");
		while (cl) 
		{
			// Set the skill on the server.
			localcmd("skill 4\n");
			// Set the skill on the client. (Makes things convenient to check skill)
			stuffcmd(cl, "skill 4\n");
			
			// Upon skill change, for players less than 25 health will be brought up to 25 health.
			if (cl.health < 25) cl.health = 25;
			// If the map is a start map, allow players to bring their health back up to 50.
			if (start_maps) cl.health = 50;	
			cl.max_health = 50; // Make sure max health is 50. 
			
			// To make sure armors are ironed out so they don't appear to be a higher value -- however, if players have rot-able armor values, armors will rot first in skill 5.
			if (cl.items & IT_ARMOR1) // Set max Armorvalue and armortype.
			{
				cl.armortype = 0.3;
				cl.max_armorvalue = 100;			
			}
			if (cl.items & IT_ARMOR2) // Set max Armorvalue and armortype.
			{
				cl.armortype = 0.6;	
				cl.max_armorvalue = 150;		
			}
			if (cl.items & IT_ARMOR3) // Set max Armorvalue and armortype.
			{
				cl.armortype = 0.8;
				cl.max_armorvalue = 200;		
			}
			if (cl.health_deflate == 0)
			{			
				if (cl.health > cl.max_health)
					cl.health_deflate = 1;
				else if (cl.health <= cl.max_health)
					cl.health_deflate = 0;
			}
									
			id1_centerprint(cl, "Kex Nightmare! Skill has been set");
			sound(cl, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC); // Sound for when the skill gets changed.
			cl = find(cl, classname, "player");
		}	  
	}
	else if (self.impulse == 55)
	{
		bprint("Skill changed to 'Sleeper Must Die!'", "\n");	
		while (cl) 
		{
			// Set the skill on the server.
			localcmd("skill 5\n");
			// Set the skill on the client. (Makes things convenient to check skill)
			stuffcmd(cl, "skill 5\n");
			
			// Upon skill change, for players less than 25 health will be brought up to 25 health. 
			if (cl.health < 25) cl.health = 25;
			// Upon skill change, for players less than 50, but greater than 25 health, health will be brought up to 50 health. 
			if (cl.health > 25 && cl.health < 50) cl.health = 50;	
			// If the map is a start map, allow players to bring their health back up to 125.
			if (start_maps) cl.health = 125;
			cl.max_health = 125; // Make sure max health is 125.
			
			// Make sure armors are ironed out so they don't appear to be a higher value -- however, if players have rot-able armor values, armors will rot first to their max_armorvalue.
			if (cl.items & IT_ARMOR1)
			{
				if (cl.armorvalue <= cl.max_armorvalue) cl.armorrottime = time + 6.66; // Rot armor when armorvalue is no longer equal or less than max armorvalue.
				cl.armortype = 0.15;   
				cl.max_armorvalue = 25;
				if (cl.armorvalue > 50) cl.armorvalue = 50; // If this armor came from another skill, adjust it's value and maximum value.								
			}
			if (cl.items & IT_ARMOR2)
			{
				if (cl.armorvalue <= cl.max_armorvalue) cl.armorrottime = time + 6.66; // Rot armor when armorvalue is no longer equal or less than max armorvalue.
				cl.armortype = 0.19;
				cl.max_armorvalue = 50;						
				if (cl.armorvalue > 100) cl.armorvalue = 100; // If this armor came from another skill, adjust it's value and maximum value.			
			}
			if (cl.items & IT_ARMOR3)
			{
				if (cl.armorvalue <= cl.max_armorvalue) cl.armorrottime = time + 6.66; // Rot armor when armorvalue is no longer equal or less than max armorvalue.
				cl.armortype = 0.245;
				cl.max_armorvalue = 75;
				if (cl.armorvalue > 150) cl.armorvalue = 150; // If this armor came from another skill, adjust it's value and maximum value.																
			}
			if (cl.health_deflate == 0)
			{			
				if (cl.health > cl.max_health)
					cl.health_deflate = 1;
				else if (cl.health <= cl.max_health)
					cl.health_deflate = 0;
			}				
		
			id1_centerprint(cl, "Sleeper Must Die! Skill has been set");
			sound(cl, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC); // Sound for when the skill gets changed.
			sound(cl, CHAN_ITEM, "misc/sleepermustdie.wav", 1, ATTN_STATIC); // Sound exclusively for the skill 5 change.
			cl = find(cl, classname, "player");
		}
	}
};

void () taunt =
{

	if (self.nqwCharacter == NQW_DUKENUKEM)
	{
		if (self.impulse == 40) NQW_Duke_tauntlist ();
	}
	if (self.nqwCharacter == NQW_CALEB)
	{
		if (self.impulse == 40) NQW_Caleb_tauntlist ();
	}

/*	else if (self.nqwCharacter == NQW_SLEEPER)
	{
	     if (self.impulse == 40)
		NQW_Sleeper_tauntlist();
	}
	else if (self.nqwCharacter == NQW_SORLAG)
	{
	     if (self.impulse == 40)
		NQW_Sleeper_tauntlist();
	}
*/
};

// Every server needs a information menu.
void() Info_Menus =
{
	if (self.impulse == 80)
	{
		sprint(self, "", "\n");
		sprint(self, "", "Cosmetic Information:", "\n");
		sprint(self, "", "\n");
		sprint(self, "", "Cosmetics exist to add a bit more personality to the Co-Op experience.", "\n");
		sprint(self, "", "Almost like VRChat or Second Life, but for Quake.", "\n");
		sprint(self, "", "It's not needed here to play, but it's there to give players some customization.","\n");
		sprint(self, "", "\n");
		sprint(self, "", " * To change characters, type change_model", "\n");
		sprint(self, "", " * To change skins, type change_skin", "\n");
		sprint(self, "", " * To taunt (if character supports), type taunt", "\n");
		sprint(self, "", "\n");
		sprint(self, "", "Best way to use cosmetics, is to bind them to a key for every one of them.", "\n");
		sprint(self, "", "Example: In console, bind u taunt", "\n");
		sprint(self, "", "\n");
	}
	if (self.impulse == 81)
	{
		sprint(self, "", "\n");
		sprint(self, "", "Skill Information:", "\n");
		sprint(self, "", "\n");
		sprint(self, "", "Changing the server's skill will also change your client's skill", "\n");
		sprint(self, "", "so that it's convenient to know what the difficulty is when you check the scoreboard.", "\n");
		sprint(self, "", "\n");
		sprint(self, "", " * To change difficulty, type setskill#. (Replace '#' with a number)", "\n");
		sprint(self, "", "\n");
		sprint(self, "", "Example: In console, type setskill3 for 'Classic Nightmare!'", "\n");
		sprint(self, "", "\n");
		sprint(self, "", "NOTE: You can't use this in deathmatch!", "\n");
		sprint(self, "", "\n");
	}
	if (self.impulse == 82)
	{	
		sprint(self, "", "\n");
		sprint(self, "", "Available Skills:", "\n");
		sprint(self, "", "\n");
		sprint(self, "", " * Skill 0 (Easy) - For those who gotta go fast.", "\n");
		sprint(self, "", " * Skill 1 (Normal) - For those who shoot themselves in the foot often.", "\n");
		sprint(self, "", " * Skill 2 (Hard) - For those who are looking to wake up in the morning.", "\n");
		sprint(self, "", " * Skill 3 (Classic Nightmare!) - For those who become a monster.", "\n");
		sprint(self, "", " * Skill 4 (KEX Nightmare!) - For those who become half human, half monster.", "\n");
		sprint(self, "", " * Skill 5 (Sleeper Must Die!) - For those who have mastered all the realms of Quake.", "\n");
		sprint(self, "", " * Skill ? (???) - This Skill is Not Ready Yet", "\n");
		sprint(self, "", " * Skill ? (???) - This Skill is Not Ready Yet", "\n");
		sprint(self, "", "\n");
		sprint(self, "", "NOTE: Skill 5 is still not finished.", "\n");
		sprint(self, "", "Of id1, Episode 1 is 90% finished, Episode 2-4 and Final Level haven't been started yet.", "\n");
		sprint(self, "", "\n");
		sprint(self, "", "See skill_info for help.", "\n");
		sprint(self, "", "\n");	
	}
	if (self.impulse == 83)
	{
		sprint(self, "", "\n");
		sprint(self, "", "Map Voting:", "\n");
		sprint(self, "", "\n");
		sprint(self, "", "There are a view ways to cast a vote.", "\n");
		sprint(self, "", "\n");		
		sprint(self, "", "With \"cmd vote map [INSERT MAPNAME HERE]\" you can cast a mapvote to change the map.", "\n");
		sprint(self, "", "\n");		
		sprint(self, "", "\"cmd vote campaign [INSERT ID1, HIPNOTIC, ROGUE, DOPA, or MG1 HERE]\", you launch any of ");
		sprint(self, "", "the official campaigns all on the same server.", "\n");
		sprint(self, "", "\n");		
		sprint(self, "", "\"cmd vote horde\", you can start a horde mode session.", "\n");	
		sprint(self, "", "\n");		
		sprint(self, "", "\"cmd vote gametype [INSERT 1v1, ffa, tdm, ctf, or oneflagctf here]\", you can change the game type to a Player Versus Player mode.", "\n");	
		sprint(self, "", "\n");			
		sprint(self, "", "And lastly, to agree on a vote, type voteyes in console\n");
		sprint(self, "", "\n");
		sprint(self, "", "Keep in mind that these commands can only be executed here in the console.", "\n");	
		sprint(self, "", "\n");					
		sprint(self, "", "If the server doesn't have the map, ask the server admin to add it into the server.", "\n");
		sprint(self, "", "\n");
		sprint(self, "", "Examples:", "\n");
		sprint(self, "", "\n");
		sprint(self, "", "cmd vote map examplemap.bsp", "\n");
		sprint(self, "", "cmd vote campaign rogue", "\n");
		sprint(self, "", "cmd vote horde", "\n");
		sprint(self, "", "\n");
	}
	if (self.impulse == 84)
	{
		sprint(self, "", "\n");
		sprint(self, "", "Speedrunning Info:", "\n");
		sprint(self, "", "\n");
		sprint(self, "", "Information for this is not available yet. Come back later!", "\n");
		sprint(self, "", "\n");				
	}
	if (self.impulse == 85)
	{
		sprint(self, "", "\n");
		sprint(self, "", "Troubleshooting:", "\n");
		sprint(self, "", "\n");
		sprint(self, "", "If you've manage to get into the server, but you are still having issues,", "\n");
		sprint(self, "", "consider trying other third-party source ports like FTEQW, Quakespasm-Spiked Multiplayer, ezQuake.", "\n");
		sprint(self, "", "These clients have content downloading capabilities that you need to have to get the necessary assets", "\n");
		sprint(self, "", "on this server, or any server that has custom material.", "\n");
		sprint(self, "", "\n");
		sprint(self, "", "Another thing you may need to check is cl_nopext (cl_pext in FTEQW) and allow_download from the console.", "\n");
		sprint(self, "", "These cvars need to be set accordingly. cl_nopext needs to be set to 1 (same with cl_pext if using FTEQW), and allow_download needs to be set to 2.", "\n");
		sprint(self, "", "If you need more information, you should consider joining the Quake Mapping Discord Server -- the people there will,", "\n");
		sprint(self, "", "are experts and will gladly try to assist you if you're not tech savvy.", "\n");
		sprint(self, "", "\n");
		sprint(self, "", "Quake Mapping Discord Server: https://discord.gg/mE5XwQa2j3", "\n");
		sprint(self, "", "\n");
		sprint(self, "", "NOTE: More troubleshooting tips will become available if and when more problems arise.", "\n");
		sprint(self, "", "\n");
	}
	if (self.impulse == 86)
	{
		sprint(self, "", "\n");
		sprint(self, "", "Available Game Types:", "\n");
		sprint(self, "", "\n");
		sprint(self, "", " * Cooperative (Quake) --> Play Quake's campaign with your friends or other people.", "\n");
		sprint(self, "", " * Cooperative (Scourge Of Armagon) --> Play the campaign of the first Mission Pack: Scourge of Armagon with your friends or other people.", "\n");
		sprint(self, "", " * Cooperative (Dissolution Of Eternity) --> Play the campaign of the second Mission Pack: Dissolution Of Eternity with your friends or other people.", "\n");
		sprint(self, "", " * Cooperative (Dimension Of The Past) --> Play the campaign of the third Mission Pack: Dimension Of The Past with your friends or other people.", "\n");
		sprint(self, "", " * Cooperative (Dimension Of The Machine) --> Play the campaign of the fourth Mission Pack: Dimension Of The Machine with your friends or other people.", "\n");
		sprint(self, "", " * Horde Mode --> Test your mettle against thousands of lovecraftian horrors in an arena. Can you survive the longest?", "\n");
		sprint(self, "", " * Free For Fall --> It's you against the world", "\n");
		sprint(self, "", " * Team Deathmatch --> Dominate the Arenas with your allies", "\n");
		sprint(self, "", " * Duel --> Fight for map control", "\n");
		sprint(self, "", " * Capture The Flag --> Take your enemy base's flag to your base to score!", "\n");
		sprint(self, "", " * One Flag CTF --> Only one flag, take it to the enemy base to score!", "\n");		
		sprint(self, "", " * ??? --> This Game Type isn't ready yet (Let's assuming it's instagib)", "\n");
		sprint(self, "", "\n");
	}
	if (self.impulse == 87)
	{
		sprint(self, "", "\n");
		sprint(self, "", "Current Game Type:", "\n");
		sprint(self, "", "\n");	
		if (deathmatch && !cvar("horde") && !coop && !cvar("customcoop"))
		{
			if (deathmatch == DM_DUEL) sprint(self, "", "Duel", "\n");
			else if (deathmatch == DM_FFA) sprint(self, "", "Free For Fall", "\n");
			else if (deathmatch == DM_TDM) sprint(self, "", "Team Deathmatch", "\n");
			else if (deathmatch == DM_CTF) sprint(self, "", "Capture The Flag", "\n");
			else if (deathmatch == DM_OneFlagCTF) sprint(self, "", "One Flag CTF", "\n");				
		}
		else if (coop && !cvar("horde") && !deathmatch)
		{
			if (!cvar("customcoop"))
			{
				if (teamplay >= 1 && teamplay <= 3)
				{
					if (coop == 1) sprint(self, "", "Reignited Cooperative", "\n");
					else if (coop == 2) 
					{
//						if (cvar("speedrunning") == 1)
//						else
						sprint(self, "", "Classic Cooperative", "\n");
					}
					else if (coop == 4) sprint(self, "", "Enhanced Cooperative", "\n");					
				}
			}
			else 
			{
				if (teamplay >= 1 && teamplay <= 3 && coop >= 1) sprint(self, "", "Custom Cooperative", "\n");
			}			
		}
		else if (!coop && !deathmatch && !cvar("horde")) sprint(self, "", "Speedrunning", "\n"); // Essentially Single Player but repurposed for those who want solo speedrunning rankings on a server.
		else if (cvar("horde") && !deathmatch) sprint(self, "", "Horde Mode", "\n");
		else sprint(self, "", "Unknown", "\n");
		sprint(self, "", "\n");		
	}
	if (self.impulse == 88)
	{
		if (coop >= 0)
		{
			if (cvar("skill") == 0)
			{
				sprint(self, "\n");
				sprint(self, "Current Skill: 0 (Easy)", "\n");
				sprint(self, "\n");
			}
			else if (cvar("skill") == 1)
			{
				sprint(self, "", "\n");
				sprint(self, "", "Current Skill: 1 (Normal)", "\n");
				sprint(self, "", "\n");
			}	
			else if (cvar("skill") == 2)
			{
				sprint(self, "", "\n");
				sprint(self, "", "Current Skill: 2 (Hard)", "\n");
				sprint(self, "", "\n");
			}
			else if (cvar("skill") == 3)
			{
				sprint(self, "", "\n");
				sprint(self, "", "Current Skill: 3 (Classic Nightmare!)", "\n");
				sprint(self, "", "\n");
			}
			else if (cvar("skill") == 4)
			{
				sprint(self, "", "\n");
				sprint(self, "", "Current Skill: 4 (KEX Nightmare!)", "\n");
				sprint(self, "", "\n");
			}
			else if (cvar("skill") == 5)
			{
				sprint(self, "", "\n");
				sprint(self, "", "Current Skill: 5 (Sleeper Must Die!)", "\n");
				sprint(self, "", "\n");
			}
			else if (cvar("skill") > 5)
			{
				sprint(self, "", "\n");
				sprint(self, "", "Current Skill: Unknown", "\n");
				sprint(self, "", "\n");
			}
		}
	}
	if (self.impulse == 89)
	{	
		if (cvar("sv_nqplayerphysics") == 1)
		{
			sprint(self, "", "\n");
			sprint(self, "", "Check Player Physics:", "\n");
			sprint(self, "", "\n");
			sprint(self, "", "Net Quake Physics on, QuakeWorld Physics off", "\n");
			sprint(self, "", "\n");
		}
		else if (cvar("sv_nqplayerphysics") == 0)
		{
			sprint(self, "", "\n");
			sprint(self, "", "Check Player Physics:", "\n");
			sprint(self, "", "\n");
			sprint(self, "", "Net Quake Physics off, QuakeWorld Physics on", "\n");
			sprint(self, "", "\n");
		}
	}
	if (self.impulse == 90)
	{
		if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF && !coop)
		{
			if (teamplay == 1)
			{
				sprint(self, "", "\n");
				sprint(self, "", "Check Friendly Fire:", "\n");
				sprint(self, "", "\n");
				sprint(self, "", "(Health Protected) Friendly Fire is Disabled", "\n");
				sprint(self, "", "\n");
			}
			
			if (teamplay == 2)
			{
				sprint(self, "", "\n");
				sprint(self, "", "Check Friendly Fire:", "\n");
				sprint(self, "", "\n");
				sprint(self, "", "Friendly Fire is Enabled", "\n");
				sprint(self, "", "\n");
			}
			
			if (teamplay == 3) 
			{
				sprint(self, "", "\n");
				sprint(self, "", "Check Friendly Fire:", "\n");
				sprint(self, "", "\n");
				sprint(self, "", "(Armor Protected) Friendly Fire is Enabled", "\n");
				sprint(self, "", "\n");
			}
			
			if (teamplay == 4)
			{
				sprint(self, "", "\n");
				sprint(self, "", "Check Friendly Fire:", "\n");
				sprint(self, "", "\n");
				sprint(self, "", "(Health & Armor Protected) Friendly Fire is Disabled", "\n");
				sprint(self, "", "\n");
			}			
		}
		
		if (coop >= REIGNITED_COOP && !deathmatch)
		{
			if (teamplay == 1)
			{
				sprint(self, "", "\n");
				sprint(self, "", "Check Self Damage:", "\n");
				sprint(self, "", "\n");
				sprint(self, "", "Self Damage is Disabled", "\n");
				sprint(self, "", "\n");
			}
					
			if (teamplay == 2 || teamplay == 3)
			{
				sprint(self, "", "\n");
				sprint(self, "", "Check Self Damage:", "\n");
				sprint(self, "", "\n");
				sprint(self, "", "Self Damage is Enabled", "\n");
				sprint(self, "", "\n");
			}
		}		
	}
	
	if (self.impulse == 91)
	{
		if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF)
		{
			if (!cvar("teamknockback"))
			{
				sprint(self, "", "\n");
				sprint(self, "", "Check Team Knockback:", "\n");
				sprint(self, "", "\n");
				sprint(self, "", "Team Knockback is Disabled", "\n");
				sprint(self, "", "\n");
			}
			
			if (cvar("teamknockback") == 1)
			{
				sprint(self, "", "\n");
				sprint(self, "", "Check Team Knockback:", "\n");
				sprint(self, "", "\n");
				sprint(self, "", "Team Knockback is Enabled", "\n");
				sprint(self, "", "\n");
			}
		}
		
		if (coop >= REIGNITED_COOP && !deathmatch)
		{
			if (!cvar("teamknockback"))
			{
				sprint(self, "", "\n");
				sprint(self, "", "Check Ally Knockback:", "\n");
				sprint(self, "", "\n");
				sprint(self, "", "Ally Knockback is Disabled", "\n");
				sprint(self, "", "\n");
			}
			
			if (cvar("teamknockback") == 1)
			{
				sprint(self, "", "\n");
				sprint(self, "", "Check Ally Knockback:", "\n");
				sprint(self, "", "\n");
				sprint(self, "", "Ally Knockback is Enabled", "\n");
				sprint(self, "", "\n");
			}
		}
	}		
	
	if (self.impulse == 92)
	{
		sprint(self, "", "\n");
		sprint(self, "", "Server Help:", "\n");
		sprint(self, "", "\n");
		sprint(self, "", "--------Information--------", "\n");
		sprint(self, "", " * cosmetic_info ---> Information for custom players models, skins and taunts", "\n");
		sprint(self, "", " * troubleshoot_info ---> Information for troubleshooting your client when playing on this server", "\n");
		sprint(self, "", " * skill_info ---> Information for how to change difficulty", "\n");
		sprint(self, "", " * mapvote_info ---> Information for mapvoting", "\n");
		sprint(self, "", " * speedrunning_info ---> Information for speedrunning", "\n");		
		sprint(self, "", " * avail_skill ---> Information for what difficulties are available", "\n");
		sprint(self, "", " * avail_gametype ---> Information for available gametypes", "\n");
		sprint(self, "", "--------Information--------", "\n");
		sprint(self, "", "\n");	
		sprint(self, "", "\n");		
		sprint(self, "", "----------Commands---------", "\n");
		sprint(self, "", " * setskill# ---> Set a skill", "\n");
		sprint(self, "", " * change_playerphysics ---> Enable or Disable QuakeWorld Physics", "\n");
		sprint(self, "", " * enable_friendlyfire ---> Enable Friendly Fire (Team Modes Only)", "\n");
		sprint(self, "", " * disable_friendlyfire ---> Disable Friendly Fire (Team Modes Only)", "\n");
		sprint(self, "", " * enable_teamknockback ---> Enable Team Knockback (Team Modes Only)", "\n");
		sprint(self, "", " * disable_teamknockback ---> Disable Team Knockback (Team Modes Only)", "\n");		
		sprint(self, "", " * enable_selfdamage ---> Enable Self Damage (Cooperative Only)", "\n");
		sprint(self, "", " * disable_selfdamage ---> Disable Self Damage (Cooperative Only)", "\n");	
		sprint(self, "", " * enable_allyknockback ---> Enable Ally Knockback (Cooperative Only)", "\n");
		sprint(self, "", " * disable_allyknockback ---> Disable Ally Knockback (Cooperative Only)", "\n");			
		sprint(self, "", " * check_gametype --->  Check the Game Type", "\n");
		sprint(self, "", " * check_skill --->  Check the difficulty", "\n");
		sprint(self, "", " * check_playerphysics --->  Check the Player Physics", "\n");
		sprint(self, "", " * check_friendlyfire ---> Check if Friendly Fire is Enabled or Disabled (Team Modes Only)", "\n");
		sprint(self, "", " * check_teamknockback ---> Check if Team Knockback is Enabled or Disabled (Team Modes Only)", "\n");
		sprint(self, "", " * check_allyknockback ---> Check if Ally Knockback is Enabled or Disabled (Cooperative Only)", "\n");
		sprint(self, "", " * check_selfdamage ---> Check if Self Damage is Enabled or Disabled (Cooperative Only)", "\n");				
		sprint(self, "", "----------Commands---------", "\n");
		sprint(self, "", "\n");
		sprint(self, "", "\n");
		sprint(self, "", "---Cooperative Campaigns---", "\n");
		sprint(self, "", " * id1 ---> Launch the Quake: The Offering Campaign", "\n");
		sprint(self, "", " * hipnotic ---> Launch the Quake: Scourge Of Armagon Campaign", "\n");
		sprint(self, "", " * rogue ---> Launch the Quake: Dissolution Of Eternity Campaign", "\n");
		sprint(self, "", " * dopa ---> Launch the Quake: Dimension Of The Past Campaign", "\n");
		sprint(self, "", " * mg1 ---> Launch the Quake: Dimension Of The Machine Campaign", "\n");
		sprint(self, "", "\n");			
		sprint(self, "", "NOTE: A vote campaign vote needs to be casted. See mapvote_info for info.", "\n");	
		sprint(self, "", "\n");								
		sprint(self, "", "---Cooperative Campaigns---", "\n");
		sprint(self, "", "\n");
		sprint(self, "", "\n");
		sprint(self, "", "---Deathmatch Game Types---", "\n");	
		sprint(self, "", " * Free For All (ffa) ---> Change Game Type to Free For All", "\n");	
		sprint(self, "", " * Team Deathmatch (tdm) ---> Change Game Type to Team Deathmatch", "\n");	
		sprint(self, "", " * Duel (1v1) ---> Change Game Type to Duel", "\n");
		sprint(self, "", " * Capture The Flag (ctf) ---> Change Game Type to Capture The Flag", "\n");
		sprint(self, "", " * One Flag CTF (oneflagctf) ---> Change Game Type to One Flag Capture The Flag", "\n");						
                sprint(self, "", "---Deathmatch Game Types---", "\n");	
		sprint(self, "", "\n");
		sprint(self, "", "\n"); 		
		sprint(self, "", "--------Horde Mode---------", "\n");
		sprint(self, "", " * horde ---> Launch Horde Mode", "\n");
		sprint(self, "", "\n");			
		sprint(self, "", "NOTE: A vote horde vote needs to be casted. See mapvote_info for info.", "\n");		
		sprint(self, "", "\n");			
		sprint(self, "", "--------Horde Mode---------", "\n"); 
		sprint(self, "", "\n");
		sprint(self, "", "\n"); 		            	
		sprint(self, "", "---------Cosmetics---------", "\n");
		sprint(self, "", " * change_model ---> Change your player model", "\n");
		sprint(self, "", " * change_skin ---> Change your player model's skin", "\n");
		sprint(self, "", " * taunt ---> Taunt at monsters or other players", "\n");
		sprint(self, "", "---------Cosmetics---------", "\n");
		sprint(self, "", "\n");
		sprint(self, "", "Type the option to use/view it.", "\n");
		sprint(self, "", "\n");
		sprint(self, "", "NOTE: More options will be added for more functionality.", "\n");
		sprint(self, "", "\n");
	}
};

/*
// This needs to be votable at some point.
void() Change_Gametype =
{
	entity cl = find(world, classname, "player");
	// iD1 Net Quake Speedrunning
	if (self.impulse == 150)
	{
		centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(self, "Changing Game Type to Speedrunning (NQ-Physics).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-id1(NQW)-NQSPEED.cfg ; map start");
		return;		
	}
	// iD1 QuakeWorld Speedrunning
	if (self.impulse == 151)
	{
		centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(self, "Changing Game Type to Speedrunning (QW-Physics).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-id1(NQW)-QWSPEED.cfg ; map start");
		return;		
	}
	// iD1 Co-Op
	if (self.impulse == 152)
	{
	while (cl) {
		id1_centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(cl, "", "Changing Game Type to Cooperative (iD1).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);
		localcmd("exec serverconfig-id1(NQW)-COOP.cfg ; changelevel start\n");	
		cl = find(cl, classname, "player");
		return;			
		}
	}	
	// iD1 QuakeWorld Co-Op
	if (self.impulse == 153)
	{
		centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(self, "Changing Game Type to Cooperative (QW-Physics).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-id1(NQW)-QWCOOP.cfg ; map start");
		return;		
	}
	// iD1 Net Quake Co-Op Speedrunning
	if (self.impulse == 154)
	{
		centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(self, "Changing Game Type to Cooperative Speedrunning (NQ-Physics).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-id1(NQW)-COOPNQSPEED.cfg ; map start");
		return;		
	}
	// iD1 QuakeWorld Co-Op Speedrunning
	if (self.impulse == 155)
	{
		sprint(self, "Changing Game Type to Cooperative Speedrunning (QW-Physics).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-id1(NQW)-COOPQWSPEED.cfg ; map start");
		return;		
	}				
	// iD1 Free For All
	if (self.impulse == 156)
	{
	while (cl) {
		id1_centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(cl, "", "Changing Game Type to Free For All (iD1).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);
		localcmd("exec serverconfig-id1(NQW)-FFA.cfg ; changelevel dm2\n");
		cl = find(cl, classname, "player");
		return;	
		}
	}
	// iD1 Team Deathmatch
	if (self.impulse == 157)
	{
	while (cl) {
		id1_centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(cl, "", "Changing Game Type to Team Deathmatch (iD1).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);
		localcmd("exec serverconfig-id1(NQW)-TDM.cfg ; changelevel dm2\n");
		cl = find(cl, classname, "player");
		return;	
		}
	}
	// iD1 Duel
	if (self.impulse == 158)
	{
	while (cl) {
		id1_centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(cl, "", "Changing Game Type to Duel (iD1).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-id1(NQW)-Duel.cfg ; changelevel dm4\n");
		cl = find(cl, classname, "player");
		return;	
		}
	}	
	// Hipnotic Co-Op
	if (self.impulse == 159)
	{
	while (cl) {
		id1_centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(cl, "", "Changing Game Type to Cooperative (Hipnotic).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-HIP(NQW)-COOP.cfg ; changelevel hipstart\n");
		cl = find(cl, classname, "player");
		return;	
		}
	}
	// Hipnotic Free For All
	if (self.impulse == 160)
	{
	while (cl) {
		id1_centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(cl, "", "Changing Game Type to Free For All (Hipnotic).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-HIP(NQW)-FFA.cfg ; changelevel hipdm1\n");
		cl = find(cl, classname, "player");
		return;	
		}
	}
	// Hipnotic Team Deathmatch
	if (self.impulse == 161)
	{
	while (cl) {
		id1_centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(cl, "", "Changing Game Type to Team Deathmatch (Hipnotic).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-HIP(NQW)-TDM.cfg ; changelevel hipdm1\n");
		cl = find(cl, classname, "player");
		return;	
		}
	}
	// Hipnotic Duel
	if (self.impulse == 162)
	{
	while (cl) {
		id1_centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(cl, "", "Changing Game Type to Duel (Hipnotic).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-HIP(NQW)-Duel.cfg ; changelevel hipdm1\n");
		cl = find(cl, classname, "player");
		return;	
		}
	}			
	// Rogue Co-Op
	if (self.impulse == 163)
	{
	while (cl) {
		id1_centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(cl, "", "Changing Game Type to Cooperative (Rogue).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-DOE(NQW)-COOP.cfg ; changelevel rstart\n");
		cl = find(cl, classname, "player");
		return;	
		}
	}
	// Rogue Free For All
	if (self.impulse == 164)
	{
	while (cl) {
		id1_centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(cl, "", "Changing Game Type to Free For All (Rogue).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-DOE(NQW)-FFA.cfg ; changelevel rstart\n");
		cl = find(cl, classname, "player");
		return;	
		}
	}
	// Rogue Team Deathmatch
	if (self.impulse == 165)
	{
	while (cl) {
		id1_centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(cl, "", "Changing Game Type to Team Deathmatch (Rogue).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-DOE(NQW)-TDM.cfg ; changelevel ctf1\n");
		cl = find(cl, classname, "player");
		return;	
		}
	}
	// Rogue Duel
	if (self.impulse == 166)
	{
	while (cl) {
		id1_centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(cl, "", "Changing Game Type to Duel (Rogue).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-DOE(NQW)-Duel.cfg ; changelevel rstart\n");
		cl = find(cl, classname, "player");
		return;	
		}
	}			
	// DOPA Co-Op		
	if (self.impulse == 167)
	{
	while (cl) {
		id1_centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(cl, "", "Changing Game Type to Cooperative (DOPA).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-DOPA(NQW)-COOP.cfg ; changelevel e5start\n");
		cl = find(cl, classname, "player");
		return;	
		}
	// DOPA Free For All
	if (self.impulse == 168)
	{
	while (cl) {
		id1_centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(cl, "", "Changing Game Type to Free For All (DOPA).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-DOPA(NQW)-FFA.cfg ; changelevel e5dm\n");
		cl = find(cl, classname, "player");
		return;	
		}
	}
	// DOPA Team Deathmatch
	if (self.impulse == 169)
	{
	while (cl) {
		id1_centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(cl, "", "Changing Game Type to Team Deathmatch (DOPA).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-DOPA(NQW)-TDM.cfg ; changelevel e5dm\n");
		cl = find(cl, classname, "player");
		return;	
		}
	}
	// DOPA Duel
	if (self.impulse == 170)
	{
	while (cl) {
		id1_centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(cl, "", "Changing Game Type to Duel (DOPA).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-DOPA(NQW)-Duel.cfg ; changelevel e5dm\n");
		cl = find(cl, classname, "player");
		return;	
		}
	}	
	// MG1 Co-Op
	if (self.impulse == 171)
	{
	while (cl) {
		id1_centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(cl, "", "Changing Game Type to Cooperative (MG1).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-MG1(NQW)-COOP.cfg ; changelevel mgstart\n");
		cl = find(cl, classname, "player");
		return;	
		}
	}
	// MG1 Free For All
	if (self.impulse == 172)
	{
	while (cl) {
		id1_centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(cl, "", "Changing Game Type to Free For All (MG1).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-MG1(NQW)-FFA.cfg ; changelevel mgdm1\n");
		cl = find(cl, classname, "player");
		return;	
		}
	}
	// MG1 Team Deathmatch
	if (self.impulse == 173)
	{
	while (cl) {
		id1_centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(cl, "", "Changing Game Type to Team Deathmatch (MG1).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-MG1(NQW)-TDM.cfg ; changelevel mgdm3\n");
		cl = find(cl, classname, "player");
		return;	
		}
	}
	// MG1 Duel
	if (self.impulse == 174)
	{
	while (cl) {
		id1_centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(cl, "", "Changing Game Type to Duel (MG1).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-MG1(NQW)-Duel.cfg ; changelevel mgdm3\n");
		cl = find(cl, classname, "player");
		return;	
		}
	}
	// MG1 Horde Mode
	if (self.impulse == 175)
	{
	while (cl) {
		id1_centerprint(self, ""); // Any centerprint active will get removed with a blank one.
		sprint(cl, "", "Changing Game Type to Horde Mode (MG1).", "\n");
//		sound(self, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);	
		localcmd("exec serverconfig-MG1(NQW)-Horde.cfg ; changelevel horde1\n");
		cl = find(cl, classname, "player");
		return;	
		}
	}								
	return;	
	// May add Capture The Flag, Instagib, iCTF, and the Quake 1 version of Railwarz.		
};
*/

// Toggle QW-Physics
void() PlayerPhysics =
{
	entity cl = find(world, classname, "player");
	if (self.impulse == 59)
	{
		localcmd("toggle sv_nqplayerphysics\n");
		while (cl) 
		{
			sound(cl, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);
			if (cvar("sv_nqplayerphysics") == 1)
			{
				if (deathmatch > 1 || coop)
					id1_centerprint(cl, "QuakeWorld Physics has been enabled");
				sprint(cl, "", "Physics changed to QuakeWorld", "\n");
			}
			else
			{
				if (deathmatch > 1 || coop)
					id1_centerprint(cl, "QuakeWorld Physics has been disabled");
				sprint(cl, "", "Physics changed to Net Quake", "\n");
			}
			cl = find(cl, classname, "player");
		}
	}	
};

void() Change_FriendlyFire =
{
	entity cl = find(world, classname, "player");
	if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF && !coop)
	{
		// Disable Friendly Fire (Health protected)
		if (self.impulse == 101)
		{
			while (cl) 
			{
				localcmd("teamplay 1\n");
				sound(cl, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);
				sprint(cl, "", "(Health Only Protected) Armor Only Friendly Fire has been disabled!", "\n");
				cl = find(cl, classname, "player");
			}
			
		}
		
		// Enable Friendly Fire
		if (self.impulse == 102)
		{
			while (cl) 
			{
				localcmd("teamplay 2\n");
				sound(cl, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);
				sprint(cl, "", "Friendly Fire has been enabled!", "\n");
				cl = find(cl, classname, "player");
			}
		}
		
		// Enable Friendly Fire (Armor protected)
		if (self.impulse == 103)
		{
			while (cl) 
			{
				localcmd("teamplay 3\n");
				sound(cl, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);
				sprint(cl, "", "(Armor Only Protected) Friendly Fire has been enabled!", "\n");
				cl = find(cl, classname, "player");
			}	
		}
		
		// Disable Friendly Fire (Health & Armor Protected)
		if (self.impulse == 104)
		{
			while (cl) 
			{
				localcmd("teamplay 4\n");
				sound(cl, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);
				sprint(cl, "", "(Health & Armor Protected) Friendly Fire has been disabled!", "\n");
				cl = find(cl, classname, "player");
			}
		}			
	}
	
	if (coop >= REIGNITED_COOP && !deathmatch)
	{
		// Disable Self & Ally Damage
		if (self.impulse == 101)
		{
			while (cl) 
			{
				localcmd("teamplay 1\n");
				sound(cl, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);
				sprint(cl, "", "Self Damage has been disabled!", "\n");
				cl = find(cl, classname, "player");
			}		
		}

		// Enable Self & Ally Damage
		if (self.impulse == 102) // Sleeper: There is some douche bags out there that can't play Quake responsible enough with the team damage on, so... no. Play by yourself....
		{
			if (cvar("sv_public") >= 1)
			{
				sprint(self, "Go quack yourself...\n");
				return;
			}
			while (cl) 
			{
				localcmd("teamplay 2\n");
				sound(cl, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);
				sprint(cl, "", "Self & Ally Damage has been enabled!", "\n");
				cl = find(cl, classname, "player");
			}
		}
				
		// Enable Self Damage but Disable Ally Damage (Default)
		if (self.impulse == 103)
		{
			while (cl) 
			{
				localcmd("teamplay 3\n");
				sound(cl, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);
				sprint(cl, "", "Self Damage has been enabled!", "\n");
				cl = find(cl, classname, "player");
			}
		}
	}
};

void() Change_Teamknockback =
{
	entity cl = find(world, classname, "player");
	if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF && !coop)
	{
		// Disable Team Knockback
		if (self.impulse == 105)
		{
			while (cl) 
			{
				localcmd("teamknockback 0\n");
				sound(cl, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);
				sprint(cl, "", "Team Knockback has been disabled!", "\n");
				cl = find(cl, classname, "player");
			}
		}
		
		// Enable Team Knockback
		if (self.impulse == 106)
		{
			while (cl) 
			{
				localcmd("teamknockback 1\n");
				sound(cl, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);
				sprint(cl, "", "Team Knockback has been enabled!", "\n");
				cl = find(cl, classname, "player");
			}
		}				
	}
	
	if (coop >= REIGNITED_COOP && !deathmatch)
	{
		// Disable Ally Knockback
		if (self.impulse == 105)
		{
			while (cl) 
			{
				localcmd("teamknockback 0\n");
				sound(cl, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);
				sprint(cl, "", "Ally Knockback has been disabled!", "\n");
				cl = find(cl, classname, "player");
			}
		}
		
		// Enable Ally Knockback
		if (self.impulse == 106)
		{
			while (cl) 
			{
				localcmd("teamknockback 1\n");
				sound(cl, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);
				sprint(cl, "", "Ally Knockback has been enabled!", "\n");
				cl = find(cl, classname, "player");
			}
		}
	}			
};

void() Toggle_Grappling_Hook_Settings =
{
	local entity all_clients = find (world, classname, "player");
	if (self.impulse == 107) 
	{
		localcmd ("toggle use_grappling_hook");	
		if (!cvar("use_grappling_hook")) bprint ("Grappling Hook Enabled\n");
		if (cvar("use_grappling_hook") == TRUE) bprint ("Grappling Hook Disabled\n");		
		while (all_clients)
		{
			// Sleeper: Give everyone the weapon based Grappling Hook.
			if (!cvar("use_grappling_hook"))
			{
				if (!(self.weapons & DOE_GRAPPLE)) self.weapons |= DOE_GRAPPLE; // Sleeper: Give the grappling hook.			
				sprint (all_clients, "You got the Grappling Hook\n");
				sound (all_clients, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
			}
			if (cvar("use_grappling_hook") == TRUE)
			{
				if (self.weapons & DOE_GRAPPLE) self.weapons -= DOE_GRAPPLE;
				if (self.weapon == DOE_GRAPPLE) self.weapon = IT_SHOTGUN;
				sprint (all_clients, "Your Grappling Hook has been removed\n");				
				sound (all_clients, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);
			}
			all_clients = find (all_clients, classname, "player");
		}			
	}
	if (self.impulse == 108) 
	{
		localcmd ("toggle skyhook");	
		bprint ("Skyhook Enabled\n");
	}
	if (self.impulse == 109) 
	{
		localcmd ("toggle use_offhand_hook");	
		if (!cvar("use_offhand_hook")) bprint ("Offhand Hook Enabled\n");
		if (cvar("use_offhand_hook") == TRUE) bprint ("Offhand Hook Disabled\n");
		while (all_clients)
		{		
			// Sleeper: Fake a pickup to give everyone a fake Offhanded Grappling Hook.
			if (!cvar("use_offhand_hook") && !all_clients.offhand_hook_enabled)
			{			
				all_clients.offhand_hook_enabled = TRUE; // Sleeper: Give the offhand hook.
				sprint (all_clients, "You got the Offhand Hook\n");			
				sound (all_clients, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
			}
			if (cvar("use_offhand_hook") == TRUE && self.offhand_hook_enabled)
			{
				all_clients.offhand_hook_enabled = FALSE; // Sleeper: Remove the offhand hook.
				sprint (all_clients, "Your Offhand Hook has been removed\n");				
				sound (all_clients, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);			
			}
			all_clients = find (all_clients, classname, "player");	
		}		
	}	
};

/*		
void() Custom_Coop_Mode =
{
	entity cl = find(world, classname, "player");
	while (cl) 
	{
		if (!cvar("customcoop"))
			id1_centerprint(cl, "Custom Coop Server Settings Enabled\n");
		else if (cvar("customcoop"))
			id1_centerprint(cl, "Custom Coop Server Settings Disabled\n");
		sound(cl, CHAN_AUTO, "misc/runekey.wav", 1, ATTN_STATIC);
		cl = find(cl, classname, "player");
	}
	localcmd("toggle customcoop\n");
};
*/

// For a future speedrunning mode.
/*
void() map_restart =
{
	if (self.impulse == 111)
	{
		localcmd("map_restart\n");
		return;
	}
}
*/

void() NQW_RedTeam; 
void() NQW_BlueTeam;    
   
/*
============
ImpulseCommands

============
*/
void() ImpulseCommands =
{
	// iD1 Weapons --------------------------------
	if (self.impulse >= 1 && self.impulse <= 8) W_ChangeWeapon ();
	// HIPNOTIC Weapons ---------------------------
	if (self.impulse >= 225 && self.impulse <= 228) W_ChangeWeapon ();
	// ROGUE Weapons ------------------------------ 
	if (self.impulse >= 60 && self.impulse <= 68) W_ChangeWeapon ();
	if (self.impulse == 22) W_ChangeWeapon (); // Sleeper: Grappling Hook (independant from the Axe)
	if (self.impulse == 23) W_ChangeWeapon (); // Sleeper: Axe (independant from the grappling hook)					
	// --------------------------------------------		
	// Net QuakeWorld Weapons
//	if (self.impulse == 229) W_ChangeWeapon ();
	// --------------------------------------------	
		
	if (self.impulse == 9) CheatCommand ();
	if (self.impulse == 10) CycleWeaponCommand ();
	if (self.impulse == 11) ServerflagsCommand ();
	if (self.impulse == 12) CycleWeaponReverseCommand ();
		
	//ZOID--
	// Teamplay stuff
	if (self.impulse == 20) TossBackpack ();
	if (self.impulse == 21) TossWeapon ();		
				
	// Net QuakeWorld ===========================================
	
	// For a future speedrunning mode.	
//	if (self.impulse == 111) map_restart ();

	if (self.impulse == 40) taunt (); // Voice-lined Taunts
	if (self.impulse == 59) PlayerPhysics (); // Enable or Disable QuakeWorld Physics
//	if (self.impulse >= 150 && self.impulse <= 175) Change_Gametype (); // Change to Co-Op (iD1/SoA/DoE/DOPA/MG1), FFA, TDM, CTF, OneFlagCTF or Duel
	if (self.impulse >= 101 && self.impulse <= 104) Change_FriendlyFire ();	 // Teamplay adjustment	
	if (self.impulse >= 105 && self.impulse <= 106) Change_Teamknockback ();
	if (self.impulse >= 80 && self.impulse <= 92) Info_Menus (); // Server Help menu
		
	if (!deathmatch && self.impulse >= 50 && self.impulse <= 55) SkillVotables (); // Change Skills	
	if (self.impulse == 100) NQW_PickCharacter (); // Change Characters
	if (self.impulse == 137) NQW_SwapSkin (); // Change Skins
//	if ((deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF && !coop) || (cvar("developer") >= 1))
//	{
		if (self.impulse >= 107 && self.impulse <= 109) Toggle_Grappling_Hook_Settings ();
		if (self.impulse == 138) NQW_RedTeam ();
		if (self.impulse == 139) NQW_BlueTeam ();
//	}
	
//	if (self.impulse == 220) voteyes ();
	// ==========================================================
	
//JIM
	if (self.impulse == 200) WetsuitCheat ();
//MED
	if (self.impulse == 201) EmpathyShieldsCheat ();
	if (self.impulse == 205) ToggleDump ();
	if (self.impulse == 202) DumpEntities ();
	if (self.impulse == 203) DumpLiveEntities ();
	if (self.impulse == 255) QuadCheat ();
	if (dump_coord == 1) DumpCoordinates ();
	if (self.impulse == 219)
	{
		if (!coop && !deathmatch && !cvar("horde") && !cvar("sv_public") || cvar("developer")) Omnicide ();	
	}
	
//	CheckStatImpulses ();	

	self.impulse = 0;
};

/*
============
W_WeaponFrame

Called every frame so impulse events can be handled as well as possible
============
*/
void() W_WeaponFrame =
{		
	if (self.attack_finished > time) return;
		
	if (self.lavaGunFired)
	{
		if (self.weapon == DOE_LAVA_NAILGUN || self.weapon == DOE_LAVA_SUPER_NAILGUN)
			sound (self, CHAN_WEAPON, "lavagun/snail.wav", 1, ATTN_NORM);
		self.lavaGunFired = 0;
	}		

	if (self.impulse) ImpulseCommands ();

// check for attack
	if (self.button0)
	{
		SuperDamageSound ();
		W_Attack ();
	} 
};

/*
========
SuperDamageSound

Plays sound if needed
========
*/
void() SuperDamageSound =
{
	if (self.super_damage_finished > time)
	{
		if (self.super_sound < time)
		{
			self.super_sound = time + 1;
			sound (self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
		}
	}
	return;
};
