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

/* Items QuickC program
   By Jim Dose'  9/13/96
*/

float UNDERWATER = 2;

/*
===============================================================================

HIPNOTIC ITEMS

===============================================================================
*/
//
// hip_powerup_touch function
//
void() hip_powerup_touch =
{
	if (other.classname != "player") return;
	if (other.health <= 0) return;
	if (initiate_matchtime == FALSE && cvar("deathmatch")) return;	
	if (self.powerup_lockout_selective == 1) // Choose what powerup that can lockout a player from picking the same powerup again.
	{
		if (self.powerup_lockout[other.colormap] > time || self.powerup_lockout[other.colormap] == -1) return; // Lockout
	}
	
	self.storetime = 0;
	
	local float seconds_left = 0;

	if (deathmatch && !coop)
	{
		self.mdl = self.model;

//      	if ((self.classname == "item_artifact_invulnerability") ||
//         	(self.classname == "item_artifact_invisibility"))
//        		 self.nextthink = time + 60*5;
//     	 	else
		self.nextthink = time + 60;
		self.think = SUB_regen;
	}
	
	if (coop == REIGNITED_COOP && !deathmatch)
	{
		if (self.classname == "item_artifact_wetsuit") self.powerup_lockout_selective = 1; // This is a minor powerup item, let it respawn and have players grab it an infinite amount of times	
		if (self.classname == "item_artifact_empathy_shields" && world.model == "maps/hip1m3.bsp" && !self.droppable_item)
		{
			self.alpha = 0.85;
			self.powerup_lockout_selective = TRUE;							
		} // This is a major powerup item, don't let it respawn, unless it's hip1m3. Then let everyone get this item.
	}
	
	if (self.powerup_lockout_selective == 1)
	{
		if (!deathmatch)
		{
			if (!cvar("customcoop") && self.classname != "item_artifact_wetsuit") self.powerup_lockout[other.colormap] = -1;
			else
			{
				if (self.classname == "item_artifact_wetsuit") self.powerup_lockout[other.colormap] = time + 5; // Short lockout time for wetsuit.
				else self.powerup_lockout[other.colormap] = time + 120;
			}
		}
	}

	// do the apropriate action
	if (self.classname == "item_artifact_wetsuit")
	{
		other.wetsuit_time = TRUE;
		
		// Sleeper: Don't need this, but it's good for consistent item behavior.
		if (other.wetsuit_finished > time) self.storetime = other.wetsuit_finished - time;
		
		if (self.droppable_item == TRUE)
		{ 	
			// Sleeper: If we picked up a dropped pre-decayed Ring, make sure to add it's delay to the next Ring's pickup. Whether it was dropped, or an untouched Ring.
			other.wetsuit_finished = time + self.delay + self.storetime;															
			if (other.wetsuit_finished > time + 30) // Sleeper: Don't overstack the timer.	
			{
				seconds_left = 30;
				other.wetsuit_finished = time + 30;
			}		
			else seconds_left = rint(self.delay + self.storetime);		
			
			sprint (other, "You have recovered a decaying ", self.netname);
			if (seconds_left != 1) sprint (other, " (", ftos(seconds_left), " seconds remaining)");
			else sprint (other, " (", ftos(seconds_left), " second remaining)");
		}		
		else 
		{
			other.wetsuit_time = time + 30;
			sprint (other, "You got the ", self.netname);
		}
	}
	if (self.classname == "item_artifact_empathy_shields")
	{
		other.empathy_time = TRUE;
		
		if (other.empathy_finished > time) self.storetime = other.empathy_finished - time;
		
		if (horde_ent) other.empathy_finished = time + 12;
		else if (self.droppable_item == TRUE)
		{ 	
			// Sleeper: If we picked up a dropped pre-decayed Ring, make sure to add it's delay to the next Ring's pickup. Whether it was dropped, or an untouched Ring.
			other.empathy_finished = time + self.delay + self.storetime;								
			if (other.empathy_finished > time + 30) // Sleeper: Don't overstack the timer.	
			{
				seconds_left = 30;
				other.empathy_finished = time + 30;
			}		
			else seconds_left = rint(self.delay + self.storetime);		
			
			sprint (other, "You have recovered a decaying ", self.netname);
			if (seconds_left != 1) sprint (other, " (", ftos(seconds_left), " seconds remaining)");
			else sprint (other, " (", ftos(seconds_left), " second remaining)");
		}		
		else 
		{
			other.wetsuit_time = time + 30;
			sprint (other, "You got the ", self.netname);
		}
	}	

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	if (!self.powerup_lockout_selective) self.solid = SOLID_NOT;
	other.expansionitems |= self.expansionitems;
        if (!self.powerup_lockout_selective) self.model = string_null;

	activator = other;
	SUB_UseTargets ();				// fire all targets / killtargets
	
	if (self.droppable_item == TRUE) remove (self);	
};


/*QUAKED item_artifact_wetsuit (0 .5 .8) (-16 -16 -24) (16 16 32)
Player takes no damage from electrical attacks and swims faster for 30 seconds
*/
void() item_artifact_wetsuit =
{
	// Duels normally don't have powerups
	if (cvar("instagib") || deathmatch == DM_DUEL)
	{
		remove(self);
		return;
	}
	
	self.touch = hip_powerup_touch;
	precache_model ("progs/wetsuit.mdl");
	precache_sound ("misc/wetsuit.wav");
	precache_sound ("misc/weton.wav");
	precache_sound ("items/suit2.wav");
	self.noise = "misc/weton.wav";
	setmodel (self, "progs/wetsuit.mdl");
	self.netname = "Wetsuit";
	self.expansionitems = HIP_IT_WETSUIT;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*
===============================================================================
//
// Horn of Conjuring
//
===============================================================================
*/

void() horn_touch =
{

	if (other.classname != "player")
		return;

   if (deathmatch)
	{
		self.mdl = self.model;

      self.nextthink = time + 60;

		self.think = SUB_regen;
	}

	self.solid = SOLID_NOT;
	self.model = string_null;
   sprint (other, "You got the Horn of Conjuring\n");
   sound (other, CHAN_VOICE, self.noise, 1, ATTN_NONE);
	stuffcmd (other, "bf\n");
   activator = other;
   horn_active = 1;
   horn_charmer = other;
	SUB_UseTargets();				// fire all targets / killtargets
   horn_active = 0;
};

/*QUAKED item_hornofconjuring (0 .5 .8) (-16 -16 0) (16 16 32)
Horn of Conjuring.
You must make func_spawn entities connected to this entity
to spawn the charmed creature.
*/
void() item_hornofconjuring =
{
	// Spawns monsters, no need.
	if (cvar("instagib") || deathmatch)
	{
		remove(self);
		return;
	}   
	
	self.touch = horn_touch;
	precache_model("progs/horn.mdl");
	precache_sound("hipitems/horn.wav");
	setmodel(self, "progs/horn.mdl");
	self.noise = "hipitems/horn.wav";
	setsize (self, '-16 -16 0', '16 16 32');
	StartItem ();
};

/*QUAKED item_artifact_empathy_shields (0 .5 .8) (-16 -16 0) (16 16 32)
Empathy Shield.
*/
void() item_artifact_empathy_shields =
{
	// Duels normally don't have powerups
	if (cvar("instagib") || deathmatch == DM_DUEL)
	{
		remove(self);
		return;
	}
	 
	self.touch = hip_powerup_touch;
	precache_model("progs/empathy.mdl");
	precache_sound("hipitems/empathy.wav");
	precache_sound("hipitems/empathy2.wav");
	precache_sound ("items/suit2.wav");
	setmodel(self, "progs/empathy.mdl");
	self.noise = "hipitems/empathy.wav";
	self.netname = "Empathy Shields";
	self.expansionitems = HIP_IT_EMPATHY_SHIELDS;
	setsize (self, '-16 -16 0', '16 16 32');
	StartItem ();
};
   
/*
===============================================================================

HIPNOTIC WEAPONS

===============================================================================
*/

/*QUAKED weapon_mjolnir (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_mjolnir =
{
	if (cvar("instagib"))
	{
		remove (self);
		return;
	}

	precache_model ("progs/g_hammer.mdl");
	setmodel (self, "progs/g_hammer.mdl");
	self.weapon = IT_MJOLNIR;
	self.aflag = IT_CELLS;
	self.cnt = 30;
	self.netname = "Mjolnir";
// 	self.items2 = IT_MJOLNIR;
// 	self.items = IT_MJOLNIR;
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_laser_gun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_laser_gun =
{
	if (cvar("instagib"))
	{
		remove (self);
		return;
	}

	precache_model ("progs/g_laserg.mdl");
	setmodel (self, "progs/g_laserg.mdl");
	self.weapon = IT_LASER_CANNON;
	self.aflag = IT_CELLS;
	self.cnt = 30;	
	self.netname = "Laser Cannon";
// 	self.items2 = IT_LASER_CANNON;
// 	self.items = IT_LASER_CANNON;
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_proximity_gun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_proximity_gun =
{
	if (cvar("instagib"))
	{
		remove (self);
		return;
	}

	precache_model ("progs/g_prox.mdl");
	setmodel (self, "progs/g_prox.mdl");
	self.weapon = IT_PROXIMITY_GUN;
	self.aflag = IT_ROCKETS;
	self.cnt = 6;	
	self.netname = "Proximity Gun";
// 	self.items2 = IT_PROXIMITY_GUN;
//	self.items = IT_PROXIMITY_GUN;
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*
===============================================================================

HIPNOTIC HAZARDS

===============================================================================
*/

void() spikemine_Home =
   {
   local entity head;
   local entity selected;
   local float cur_dist;
   local float head_dist;
   local vector dir, vtemp;
   
   self.frame = self.frame + 1;
   if (self.frame==9) self.frame = 0;
   self.nextthink = time + 0.2;
   self.think = spikemine_Home;

// look in our immediate vicinity

   if (self.search_time < time)
      {
      selected = world;
      cur_dist = 2000;
      head = findradius(self.origin, 2000);
      while(head)
         {
         if(!(head.flags & FL_NOTARGET) && (head.flags & FL_CLIENT))
            {
            if (visible(head) && (head.health > 0))
               {
               head_dist = vlen(head.origin-self.origin);
               if (head_dist < cur_dist)
                  {
                  selected = head;
                  cur_dist = head_dist;
                  }
               }
            }
         head = head.chain;
         }
//      if (selected != world && selected != self.enemy)
      if (selected != world)
         sound (self, CHAN_VOICE, "hipitems/spikmine.wav", 1, ATTN_NORM);
      self.enemy = selected;
      self.search_time = time + 1.3;
      }
   if (self.enemy == world)
      {
      sound (self, CHAN_VOICE, "misc/null.wav", 1, ATTN_NORM);
      self.velocity = '0 0 0';
      return;
      }
   vtemp = self.enemy.origin + '0 0 10';
	dir = normalize(vtemp - self.origin);
   if (infront(self.enemy))
      {
      self.velocity = dir * ((cvar("skill")*50) + 50); // Sleeper: Changed from skill to cvar("skill") so the when the skill changes on the fly, the speed will get adjusted in real time rather than waiting for a map restart.
      }
   else
      {
      self.velocity = dir * ((cvar("skill")*50) + 150); // Sleeper: Changed from skill to cvar("skill") so the when the skill changes on the fly, the speed will get adjusted in real time rather than waiting for a map restart.
      }
   };

void() spikemine_Touch =
   {
   if (self.health>0)
      {
      if (other.classname == "trap_spike_mine")
         return;
      if (other.classname == "missile")
         return;
      if (other.classname == "grenade")
         return;
      if (other.classname == "hiplaser")
         return;
      if (other.classname == "proximity_grenade")
         return;
   
      T_Damage(self,self,self,self.health+10);
//      killed_monsters = killed_monsters + 1;
//      WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
      }
//   self.effects = self.effects | EF_MUZZLEFLASH;

//   T_RadiusDamage (self, self, 110, world);
	T_RadiusDamage (self, self, 110, world, "");
	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

   sound (self, CHAN_VOICE, "misc/null.wav", 1, ATTN_NORM);
   self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();	
   };

/*
spike_mine_first_think
*/

void() spike_mine_first_think =
   {
   self.think = spikemine_Home;
   self.nextthink = time + 0.1;
   self.search_time = 0;
   self.takedamage = DAMAGE_AIM;
	self.use = monster_use;
   };

/*QUAKED trap_spike_mine (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() trap_spike_mine =
   {
   if (deathmatch)
	{
		remove(self);
		return;
	}
	self.netname = "Spike Mine";
   precache_model ("progs/spikmine.mdl");
   precache_sound ("weapons/r_exp3.wav");
   precache_sound ("hipitems/spikmine.wav");
   precache_sound ("misc/null.wav");
   setmodel (self, "progs/spikmine.mdl");
// setmodel (self, "progs/spike.mdl");
   setsize (self, self.mins, self.maxs);
   self.classname = "trap_spike_mine";
   self.solid = SOLID_BBOX;
   self.movetype = MOVETYPE_FLYMISSILE;
// setsize (self, '0 0 0', '0 0 0');
// self.avelocity = '-100 100 -100';
   self.avelocity = '-50 100 150';
   // Sleeper: Removed health conditional and went with resistance on every weapon to emulate different health values between skills on the fly (experience with this enemy should still be feel unchanged).
   self.health = 200;
   self.frame = 0;
   self.think = spike_mine_first_think;
   self.touch = spikemine_Touch;
   self.th_die = spikemine_Touch;
   self.th_stand = spikemine_Home;
   self.th_walk = spikemine_Home;
   self.th_run = spikemine_Home;
   self.th_melee = spikemine_Home;
   self.th_missile = spikemine_Home;
   self.nextthink = time + 0.2;
   total_monsters += 1;
   self.flags |= FL_MONSTER;
   // Sleeper: Removed self.deathtype and put in the Obituary instead.
   };

//============================================================================
float LIGHTNING_RANDOM = 1;
float LIGHTNING_BOOM = 2;

void() SpawnLightningThink =
   {
   if (time > self.delay)
      {
      remove(self);
      return;
      }
   self.think = SpawnLightningThink;
   if (checkclient())
      {
      WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
      WriteEntity (MSG_BROADCAST, self);
      WriteCoord (MSG_BROADCAST, self.origin_x);
      WriteCoord (MSG_BROADCAST, self.origin_y);
      WriteCoord (MSG_BROADCAST, self.origin_z);
      WriteCoord (MSG_BROADCAST, self.oldorigin_x);
      WriteCoord (MSG_BROADCAST, self.oldorigin_y);
      WriteCoord (MSG_BROADCAST, self.oldorigin_z);
      }
   LightningDamage(self.origin, self.oldorigin, self.lastvictim, self.dmg);
   self.nextthink = time + 0.1;
   };

void() trap_lightning_use =
   {
   local vector p1, p2;
   local vector dir;
   local float dst;
   local float remainder;

   if (time >= self.pausetime)
      {
      if (self.spawnflags & LIGHTNING_BOOM)
         sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
      else
         sound (self, CHAN_AUTO, "weapons/lhit.wav", 1, ATTN_NORM);
      if (self.classname == "trap_lightning_triggered")
         self.pausetime = time + 0.1;
      }
   if (self.target)
      {
      p1 = self.origin;
      p2 = self.enemy.origin;
      }
   else
      {
      makevectors (self.angles);
      self.movedir = v_forward;
      traceline (self.origin, self.origin + self.movedir*600, TRUE, self);
      p1 = self.origin;
      p2 = trace_endpos;
      }
   // fix up both ends of the lightning
   // lightning bolts are 30 units long each
   dir = normalize( p2-p1 );
   dst = vlen(p2-p1);
   dst = dst / 30.0;
   remainder = dst - floor(dst);
   if (remainder > 0)
      {
      remainder = remainder - 1;
      // split half the remainder with the front and back
      remainder = remainder * 15;
      p1 = p1 + (remainder*dir);
      p2 = p2 - (remainder*dir);
      }
   if (self.duration > 0.1)
      {
      local entity temp;

      temp = self;
      self = spawn();
      self.origin = p1;
      self.oldorigin = p2;
      self.lastvictim = temp;
      self.dmg = temp.dmg;
      self.delay = time + temp.duration;
      SpawnLightningThink();
      self = temp;
      }
   else if (checkclient())
      {
      WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
      WriteEntity (MSG_BROADCAST, self);
      WriteCoord (MSG_BROADCAST, p1_x);
      WriteCoord (MSG_BROADCAST, p1_y);
      WriteCoord (MSG_BROADCAST, p1_z);
      WriteCoord (MSG_BROADCAST, p2_x);
      WriteCoord (MSG_BROADCAST, p2_y);
      WriteCoord (MSG_BROADCAST, p2_z);
      LightningDamage(p1, p2, self, self.dmg);
      }
   else
      LightningDamage(p1, p2, self, self.dmg);
   };

void() lightning_think =
   {
   local float timedelay;

   if (self.state)
      {
      trap_lightning_use();
      }
   if (self.cnt == 0)
      {
      if (self.spawnflags & LIGHTNING_RANDOM)
         {
         timedelay = self.wait*random();
         }
      else
         {
         timedelay = self.wait;
         }
      self.cnt = 1;
      self.t_length = time + self.duration - 0.1;
      self.pausetime = time + self.duration - 0.1;
      if (self.pausetime  < time + 0.3)
         self.pausetime = time + 0.3;
      if (timedelay < self.duration)
         timedelay = self.duration;
      self.t_width = time + timedelay;
      }
   if (time >= self.t_length)
      {
      self.cnt = 0;
      self.nextthink = self.t_width;
      }
   else
      {
      self.nextthink = time + 0.2;
      }
   };

void() lightning_firstthink =
   {
   local entity targ;
   if (self.target)
      {
      targ = find(world,targetname,self.target);
      self.dest = targ.origin;
      self.enemy = targ;
      }
   self.think = SUB_Null;
   self.nextthink = 0;
   if (self.classname != "trap_lightning_triggered")
      {
      self.nextthink = self.huntingcharmer + self.wait + self.ltime;
      self.think = lightning_think;
      }
   };

/*QUAKED trap_lightning_triggered (0 .5 .8) (-8 -8 -8) (8 8 8) random boom
When triggered, fires lightning in the direction set in QuakeEd.
"wait" how long to wait between blasts (1.0 default)
       if in random mode wait is multiplied by random
"dmg" how much damage lightning should inflict (30 default)
"duration" how long each lightning attack should last (0.1 default)
*/

void() trap_lightning_triggered =
   {
   if (self.wait == 0)
      self.wait = 1.0;
   if (self.dmg == 0)
      self.dmg = 30;
   if (self.duration == 0)
      self.duration = 0.1;
   self.cnt = 0;
   self.use = trap_lightning_use;
   precache_sound ("weapons/lhit.wav");
   precache_sound ("weapons/lstart.wav");
   self.huntingcharmer = self.nextthink;
   self.think = lightning_firstthink;
   self.nextthink = time + 0.25;
   self.deathtype = "is electrocuted";
   };


/*QUAKED trap_lightning (0 .5 .8) (-8 -8 -8) (8 8 8) random boom
Continuously fire lightning.
"wait" how long to wait between blasts (1.0 default)
       if in random mode wait is multiplied by random
"nextthink" delay before firing first lightning, so multiple traps can be stagered.
"dmg" how much damage lightning should inflict (30 default)
"duration" how long each lightning attack should last (0.1 default)
*/
void() trap_lightning =
   {
   trap_lightning_triggered ();
   self.state = 1;
   };

void() trap_lightning_switched_use =
   {
   self.state = 1 - self.state;
   if (self.state == 1)
      self.nextthink = self.huntingcharmer;
   };
/*QUAKED trap_lightning_switched (0 .5 .8) (-8 -8 -8) (8 8 8) random boom
Continuously fires lightning.
"wait" how long to wait between blasts (1.0 default)
       if in random mode wait is multiplied by random
"nextthink" delay before firing first lightning, so multiple traps can be stagered.
"dmg" how much damage lightning should inflict (30 default)
"duration" how long each lightning attack should last (0.1 default)
"state" 0 (default) initially off, 1 initially on.
*/
void() trap_lightning_switched =
   {
   trap_lightning_triggered ();
   self.use = trap_lightning_switched_use;
   };


entity tesla_target;
float tesla_numtargets;
void() trap_tesla_scan =
   {
   local entity head;
   local entity prev;

// look in our immediate vicinity

   tesla_numtargets = 0;
   head = findradius(self.origin, self.distance);
   while(head)
      {
      if(!(head.flags & FL_NOTARGET) && (head.flags & self.cnt))
         {
         if (visible(head) && (head.health > 0) && (head.struck_by_mjolnir==0))
            {
            if (tesla_numtargets == 0)
               {
               tesla_target = head;
               }
            else
               {
               prev.next_ent = head;
               }
            tesla_numtargets = tesla_numtargets + 1;
            prev = head;
            if (tesla_numtargets==self.count)
               return;
            }
         }
      head = head.chain;
      }
   };

void() TeslaLightningThink =
   {
   self.owner.attack_state = 2;
   if (time > self.delay)
      {
      self.enemy.struck_by_mjolnir = 0;
      remove(self);
      return;
      }
   traceline (self.origin, self.enemy.origin, TRUE, self);

   if (trace_fraction != 1.0 || self.enemy.health<=0 || vlen(self.origin-self.enemy.origin) > (self.distance+10))
      {
      self.enemy.struck_by_mjolnir = 0;
      remove(self);
      return;
      }
   WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
   WriteEntity (MSG_BROADCAST, self);
   WriteCoord (MSG_BROADCAST, self.origin_x);
   WriteCoord (MSG_BROADCAST, self.origin_y);
   WriteCoord (MSG_BROADCAST, self.origin_z);
   WriteCoord (MSG_BROADCAST, trace_endpos_x);
   WriteCoord (MSG_BROADCAST, trace_endpos_y);
   WriteCoord (MSG_BROADCAST, trace_endpos_z);
   LightningDamage(self.origin, trace_endpos, self.lastvictim, self.dmg);
   self.nextthink = time + 0.1;
   };

void(entity targ) SpawnTeslaLightning =
   {
   local entity lgt;
   // spawn actual lightning
   lgt = spawn();
   if (self.duration>0)
      {
      lgt.delay = time + self.duration;
      }
   else
      {
      lgt.delay = time + 9999;
      }
   lgt.enemy = targ;
   targ.struck_by_mjolnir = 1;
   lgt.distance = self.distance;
   lgt.owner = self;
   lgt.lastvictim = self.lastvictim;
   lgt.dmg = self.dmg;
   lgt.origin = self.origin;
   lgt.think = TeslaLightningThink;
   lgt.nextthink = time;
   lgt.deathtype = self.deathtype;
   };

void() trap_tesla_think =
   {
   if (self.state == 0)
      {
      self.nextthink = time + 0.25;
      return;
      }
   if (self.attack_state == 0)
      {
      self.think = trap_tesla_think;
      trap_tesla_scan();
      if (tesla_numtargets > 0)
         {
         if (self.wait > 0)
            sound (self, CHAN_AUTO, "misc/tesla.wav", 1, ATTN_NORM);
         self.attack_state = 1;
         self.nextthink = time + self.wait;
         return;
         }
      self.nextthink = time + 0.25;
      if (self.delay > 0)
         {
         if (time > self.search_time)
            {
            self.attack_state = 3;
            }
         }
      }
   else if (self.attack_state == 1)
      {
      trap_tesla_scan();
      while (tesla_numtargets > 0)
         {
         sound (self, CHAN_AUTO, "hipweap/mjolhit.wav", 1, ATTN_NORM);
         SpawnTeslaLightning (tesla_target);
         tesla_target = tesla_target.next_ent;
         tesla_numtargets = tesla_numtargets - 1;
         }
      self.attack_state = 2;
      self.nextthink = time + 1;
      }
   else if (self.attack_state == 2)
      {
      self.attack_state = 3;
      self.nextthink = time + 0.2;
      }
   else if (self.attack_state == 3)
      {
      self.attack_state = 0;
      self.nextthink = time + 0.1;
      if (self.classname == "trap_gods_wrath")
         {
         self.nextthink = -1;
         }
      }
   };

/*QUAKED trap_tesla_coil (0 .5 .8) (-8 -8 -8) (8 8 8) targetenemies
targets enemies in vicinity and fires at them
"wait" how long build up should be (2 second default)
"dmg" how much damage lightning should inflict (2 + 5*skill default)
"duration" how long each lightning attack should last (continuous default)
"distance" how far the tesla coil should reach (600 default)
"state" on/off for the coil (0 default is off)
"count" number of people to target (2 default)
*/
void() trap_tesla_coil =
   {
   precache_sound ("misc/tesla.wav");
   precache_sound ("hipweap/mjolhit.wav");   // lightning sound
   if (self.wait == 0)
      self.wait = 2;
   if (self.dmg == 0)
      self.dmg = 2 + (5*cvar("skill"));
   if (self.duration == 0)
      self.duration = -1;
   if (self.distance == 0)
      self.distance = 600;
   if (self.spawnflags & 1)
      self.cnt = FL_CLIENT | FL_MONSTER;
   else
      self.cnt = FL_CLIENT;
   self.use = trap_lightning_switched_use;
   if (self.delay == 0)
      self.delay = -1;
   self.nextthink = time + random();
   self.think = trap_tesla_think;
   self.lastvictim = world;
   tesla_numtargets = 0;
   self.attack_state = 0;
   self.deathtype = "is electrocuted";
   };

void() trap_gods_wrath_use =
   {
   if (self.attack_state==0)
      {
      self.search_time = time + self.delay;
      self.lastvictim = activator;
      trap_tesla_think();
      }
   };

/*QUAKED trap_gods_wrath (0 .5 .8) (-8 -8 -8) (8 8 8) targetenemies
targets enemies in vicinity and fires at them
"dmg" how much damage lightning should inflict (5 default)
"duration" how long each lightning attack should last (continuous default)
"distance" how far god's wrath should reach (600 default)
"delay" how long to wait until god calms down
   this is only needed if no one is targetted (5 seconds default)
"count" number of people to target (2 default)
*/
void() trap_gods_wrath =
   {
   if (self.delay == 0)
      self.delay = 5;
   trap_tesla_coil();
   self.wait = 0;
   self.state = 1;
   self.nextthink = -1;
   self.deathtype = "suffers the wrath of God";
//   self.attack_state = 1;
   self.use = trap_gods_wrath_use;
   };

void() trap_gravity_touch =
   {
   if ( self.attack_finished > time )
      return;

   if (other.takedamage)
      {
      T_Damage (other, self, self, self.dmg );
      self.attack_finished = time + 0.2;
      }
   };

void() trap_gravity_think =
   {
   local vector vel;
   local vector dir;
   local vector delta;

   self.ltime = time;
   trap_tesla_scan();
   while (tesla_numtargets > 0)
      {
      delta = self.origin - tesla_target.origin;
      dir = normalize( delta );
      vel = dir * self.speed;
      if ( ( tesla_target.wetsuit_finished > time ) &&
         ( self.spawnflags & UNDERWATER ) )
         {
         vel = vel * 0.6;
         }

      tesla_target.velocity = tesla_target.velocity + vel;
      tesla_target = tesla_target.next_ent;
      tesla_numtargets = tesla_numtargets - 1;
      }
   self.nextthink = time + 0.1;
   };

/*QUAKED trap_gravity_well (.8 .5 0) (-8 -8 -8) (8 8 8) targetenemies UNDERWATER
targets enemies in vicinity and draws them near, gibbing them on contact.

UNDERWATER cuts the pull in half for players wearing the wetsuit

"distance" how far the gravity well should reach (600 default)
"count" number of people to target (2 default)
"speed" is how strong the pull is. (210 default)
"dmg" is how much damage to do each touch. (10000 default)
*/
void() trap_gravity_well =
   {
   self.solid = SOLID_TRIGGER;
   self.movetype = MOVETYPE_NONE;
   setsize( self, '-16 -16 -16','16 16 16');
   if ( self.dmg == 0 )
      {
      self.dmg = 10000;
      }
   if ( self.speed == 0 )
      self.speed = 210;
   if (self.distance == 0)
      self.distance = 600;
   if (self.spawnflags & 1)
      self.cnt = FL_CLIENT | FL_MONSTER;
   else
      self.cnt = FL_CLIENT;

   self.attack_finished = 0;
   self.think = trap_gravity_think;
   self.touch = trap_gravity_touch;
   self.lastvictim = world;
   tesla_numtargets = 0;
   self.nextthink = time + 0.1;
   self.ltime = time;
   };
