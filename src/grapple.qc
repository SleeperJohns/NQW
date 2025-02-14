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

// Sleeper: Just a disclaimer: this is not the Rogue implementation of the grappling hook, 
// however it's still made by the same guy that made Threewave CTF. 
// It just has a few modern enhancements and is completely server-side
// as opposed to using the beam model rendered client-side.

// New entity fields
// Sleeper: Moved to nqwdefs.qc
// .float hook_finished;

// prototypes for WEAPONS.QC functions
float() crandom;
void(vector org, vector vel, float damage) SpawnBlood;

// Originally from Zoid's 3Wave
/*********\
* LinkPos *
\*********/
void() LinkPos =
{
	// R00k added
	local vector dir = '0 0 0';

	dir = self.owner.origin - (self.owner.owner.origin + '0 0 16');  
  	self.angles = vectoangles(dir);
  	
	makevectors (self.enemy.angles);
	setorigin (self, self.owner.origin + (((self.enemy.origin + (v_up * 16) /* * (!self.enemy.button2))*/ + (v_forward * 16)) - self.owner.origin) * (self.weapon)));
	self.nextthink = time;
};

/************\
* HookVanish *
\************/
void() HookVanish =
{
	self.owner.hook_out = FALSE;
	self.owner.attack_finished = time + 0.25;	
		
	do
	{	
		if ((self.classname == "hook_chain_link") || (self.classname == "hook_entity")) remove (self); // sanity check
		self = self.hookentity;
	} 
	while (self);
};

void() UnHookPlayer = {if (self.hook_out) SUB_CallAsSelf (self.hookentity, HookVanish);};

/**********\
* HookPull *
\**********/
void() HookPull =
{
	local vector vel;
	local float v;	
		
	if ((!self.owner.button0 && self.owner.weapon == DOE_GRAPPLE) || (self.owner.teleport_time > time) || (self.owner.deadflag) || (gameover))
	{
		HookVanish ();
		return;
	}
	
	if (self.enemy.solid == SOLID_BSP && cvar("grappling_hook_anchor_timeout") == TRUE && self.grappling_hook_time < time)
	{
		HookVanish ();
		return;
	}	
	
	if (self.enemy.solid == SOLID_NOT)
	{
		HookVanish ();
		return;
	}

	if (self.enemy.takedamage)
	{
		if (!teamplay || self.enemy.steam != self.owner.steam)
		{
			if (other.classname == "missile" || other.classname == "grenade" || 
			    other.classname == "spike" || other.classname == "hook_entity" || other.classname == "offhand_hook_entity") 
			{
				HookVanish ();
				return;
			}

			self.enemy.deathtype = "hook";		

			// T_Damage (self.enemy, self, self.owner, 1);
			// at lower ticrates the hook damage is updated too fast
			// default 200a+100h = 30 seconds to death by hook
			
			if (cvar("grappling_hook_enable_damage"))
			{
				self.hookdmg += sys_ticrate / 0.1;

				if (self.hookdmg >= 1)
				{
					sound (self, CHAN_WEAPON, "pendulum/hit.wav", 1, ATTN_NORM);
					T_Damage (self.enemy, self, self.owner, grappling_hook_damage); // Sleeper: Default is 5.
					if (self.enemy.classname == "player") SpawnBlood (self.origin, self.velocity, 10);
					self.hookdmg = 0;
				}
			}

			makevectors (self.v_angle);
		}

		if (self.enemy.classname == "player") setorigin (self, self.enemy.origin + self.enemy.mins + (self.enemy.size * 0.5));
		else self.velocity = self.enemy.velocity;
	}
	else self.velocity = self.enemy.velocity;

	makevectors (self.owner.v_angle);
	vel = self.origin - (self.owner.origin + (v_up * 16) /* * (!self.owner.button2))*/ + (v_forward * 16));

	v = vlen (vel);

//	if (hookspeedpull < 600) hookspeedpull = 850;

	if (v > 100) vel = normalize(vel) * grappling_hook_pullspeed;
	else vel = normalize(vel) * v * 10;

	self.owner.velocity = vel;	

	self.frame = 2;
	self.dest = self.owner.origin;
	self.nextthink = time;
};

void() T_HookTouch =
{
	if (other == self.owner) return;
	
	if (other.solid == SOLID_BSP && cvar("grappling_hook_anchor_timeout") == TRUE) self.grappling_hook_time = time + cvar("grappling_hook_anchor_time");  // Sleeper: 5 is default.	
		
	if (!cvar("grappling_hook_enable_damage") && other.classname == "player") 
	{
		HookVanish ();
		return;
	}
			
	if ((pointcontents(self.origin) == CONTENT_SKY && !cvar("grappling_skyhook")) || (gameover))
	{
		HookVanish ();
		return;
	}
		
	if (other.solid == SOLID_SLIDEBOX)
	{
		if ((other.steam == self.owner.steam) && (teamplay))
		{
			HookVanish ();
			return;
		}
		other.axhitme = 1; // make axe noise
	}

	if (other.takedamage)
	{
		if (cvar("grappling_hook_enable_damage")) T_Damage (other, self, self.owner, grappling_hook_damage);
		//R00k fixed bleeding buttons/triggers
		if (other.flags & FL_CLIENT || other.flags & FL_MONSTER) SpawnBlood (self.origin, self.velocity, 10);
		else
		{	
			//R00k: hook hits triggers, just show sparks
			WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte(MSG_BROADCAST, TE_GUNSHOT);
			WriteCoord (MSG_BROADCAST, self.origin_x);
			WriteCoord (MSG_BROADCAST, self.origin_y);
			WriteCoord (MSG_BROADCAST, self.origin_z);
		}
	}
	else
	{		
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		self.avelocity = '0 0 0';
	}

	if (self.owner.button0)
	{				
		if (other.solid == SOLID_SLIDEBOX)
		{
			setorigin (self, other.origin + other.mins + (other.size * 0.5));
			//self.velocity = '0 0 0';					
			self.velocity = other.velocity;
		}
		else self.velocity = other.velocity;
		self.weapon = other.nextthink - time;
				
//		sound (self.owner, CHAN_WEAPON, "weapons/chain2.wav", 1, ATTN_NORM);
		self.enemy = other;
//		self.owner.ltime = time;
		self.nextthink = time;
		self.think = HookPull;
		self.touch = SUB_Null;					
	}
	else
	{
		self.nextthink = time;
		self.think = HookVanish;
	}	
};

void() Hook_Check =
{		
	if ((!self.owner.button0 && self.owner.weapon == DOE_GRAPPLE) || (self.owner.deadflag) || (gameover))
	{
		HookVanish ();
		return;
	}	
	
	if (self)
	{
		self.nextthink = time;
		self.think = Hook_Check;
	}	
};

//This is a combination of the old 'W_FireChain' and 'MakeChain' functions; removed .goalentity.
void() W_FireGrapple =
{
	local entity hook = world;
	local float linknum = 0;
	local entity link = world;
	local entity prevlink = world;

	self.hook_out = TRUE;
	hook = spawn ();
	hook.classname  = "hook_entity";
	hook.owner = self;
	self.hookentity = hook;
	hook.movetype = MOVETYPE_FLY;
	hook.solid = SOLID_BBOX;
	makevectors (self.v_angle);	
	hook.velocity = grappling_hook_pullspeed * aim(self, grappling_hook_speed);
	hook.angles = vectoangles (hook.velocity);
	hook.avelocity 	= '0 0 -500';
	hook.touch = T_HookTouch;
	hook.nextthink = time + sys_ticrate; // instead lets check if we let off the button in mid-flight! eh?
	hook.think = Hook_Check;
	setmodel (hook, "progs/hook.mdl");
	hook.frame = 1; // hook spread
	setorigin (hook, self.origin + (v_forward * 16) + '0 0 16');
	setsize (hook, '0 0 0', '0 0 0');
	sound (self, CHAN_WEAPON, "weapons/chain1.wav", 1, ATTN_NORM);

	linknum = 36;
	prevlink = world;
	while (linknum)
	{
		link = spawn();
		link.classname = "hook_chain_link";
		link.hookentity = prevlink;
		prevlink = link;
		link.owner = hook;
		link.enemy = self;
		link.weapon = (linknum / 36); 
		link.movetype = MOVETYPE_NOCLIP;
		link.solid = SOLID_NOT;
		link.angles = vectoangles(hook.velocity);
		setmodel (link, "progs/chain_tail.mdl");
		link.alpha = 0.4;		
		makevectors (self.angles);
		setorigin (link, hook.origin + (((self.origin + (v_up * 16)/* * (!self.button2))*/ + (v_forward * 16)) - hook.origin) * (link.weapon)));
		setsize (link, '0 0 0', '0 0 0');
		link.nextthink = time;
		link.think = LinkPos;
		linknum -= 1;
	}
	
	hook.hookentity = link;
};

/*********\
* LinkPos *
\*********/
void() OffHand_LinkPos =
{
	// R00k added
	local vector dir = '0 0 0';

	dir = self.owner.origin - (self.owner.owner.origin + '0 0 16');  
  	self.angles = vectoangles(dir);
	makevectors (self.enemy.angles);
	setorigin (self, self.owner.origin + (((self.enemy.origin + (v_up * 16) /* * (!self.enemy.button2))*/ + (v_forward * 16)) - self.owner.origin) * self.weapon));
	self.nextthink = time;
};

/************\
* HookVanish *
\************/
void() OffHand_HookVanish =
{
	self.owner.offhand_hook_out = FALSE;	
	self.owner.offhand_fire_hook = FALSE;
	self.owner.offhand_on_hook = FALSE;
		
	do
	{	
		if ((self.classname == "offhand_hook_chain_link") || (self.classname == "offhand_hook_entity")) remove (self); //sanity check
		self = self.offhand_hookentity;
	} 
	while (self);
};

void() OffHand_UnHookPlayer = {if (self.offhand_hook_out) SUB_CallAsSelf (self.offhand_hookentity, OffHand_HookVanish);};

/**********\
* HookPull *
\**********/
void() OffHand_HookPull =
{
	local vector vel;
	local float v;	
		
	if ((!self.owner.offhand_fire_hook && self.offhand_hook_enabled) || (self.owner.teleport_time > time) || (self.owner.deadflag) || (gameover))
	{
		OffHand_HookVanish ();
		return;
	}
	
	if (self.enemy.solid == SOLID_BSP && cvar("offhand_hook_anchor_timeout") == TRUE && self.offhand_hook_time < time)
	{
		OffHand_HookVanish ();
		return;
	}	
	
	if (self.enemy.solid == SOLID_NOT)
	{
		OffHand_HookVanish ();
		return;
	}
	
	if (!self.owner.offhand_on_hook)
	{
		OffHand_HookVanish ();
		return;
	}	

	if (self.enemy.takedamage)
	{
		if (!teamplay || self.enemy.steam != self.owner.steam)
		{
			if (other.classname == "missile" || other.classname == "grenade" || 
			    other.classname == "spike" || other.classname == "hook_entity" || other.classname == "offhand_hook_entity") 
			{
				OffHand_HookVanish ();
				return;
			}
			
			self.enemy.deathtype = "hook";		

		     // T_Damage (self.enemy, self, self.owner, 1);
			// at lower ticrates the hook damage is updated too fast
			// default 200a + 100h = 30 seconds to death by hook
			
			if (cvar("offhand_hook_enable_damage"))
			{
				self.hookdmg += sys_ticrate / 0.1;
				if (self.hookdmg >= 1)
				{
					sound (self, CHAN_WEAPON, "pendulum/hit.wav", 1, ATTN_NORM);
					T_Damage (self.enemy, self, self.owner, offhand_hook_damage); // Sleeper: Default is 5.
					if (self.enemy.classname == "player") SpawnBlood (self.origin, self.velocity, 10);
					self.hookdmg = 0;
				}
			}

			makevectors (self.v_angle);
		}

		if (self.enemy.classname == "player") setorigin (self, self.enemy.origin + self.enemy.mins + (self.enemy.size * 0.5));
		else self.velocity = self.enemy.velocity;
	}
	else self.velocity = self.enemy.velocity;

	makevectors (self.owner.v_angle);
	vel = self.origin - (self.owner.origin + (v_up * 16) /* * (!self.owner.button2))*/ + (v_forward * 16));

	v = vlen (vel);

//	if (hookspeedpull < 600) hookspeedpull = 850;

	if (v > 100) vel = normalize(vel) * offhand_hook_pullspeed;
	else vel = normalize(vel) * v * 10;

	self.owner.velocity = vel;	
	self.dest = self.owner.origin;
	self.nextthink = time;
};

void() OffHand_T_HookTouch =
{
	if (other == self.owner) return;
	
	if (other.solid == SOLID_BSP && cvar("offhand_hook_anchor_timeout") == TRUE) self.offhand_hook_time = time + cvar("offhand_hook_anchor_time");  // Sleeper: 5 is default.	
		
	if (!cvar("offhand_hook_enable_damage") && other.classname == "player") 
	{
		OffHand_HookVanish ();
		return;
	}
			
	if ((pointcontents(self.origin) == CONTENT_SKY && !cvar("offhand_skyhook")) || (gameover))
	{
		OffHand_HookVanish ();
		return;
	}
		
	if (other.solid == SOLID_SLIDEBOX)
	{
		if ((other.steam == self.owner.steam) && (teamplay))
		{
			OffHand_HookVanish ();
			return;
		}
		other.axhitme = 1; // make axe noise
	}

	if (other.takedamage)
	{
		if (cvar("offhand_hook_enable_damage"))
		{
			T_Damage (other, self, self.owner, offhand_hook_damage);
			// R00k fixed bleeding buttons/triggers
			if (other.flags & FL_CLIENT || other.flags & FL_MONSTER) SpawnBlood (self.origin, self.velocity, 10);
			else
			{	
				// R00k: hook hits triggers, just show sparks
				WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
				WriteByte(MSG_BROADCAST, TE_GUNSHOT);
				WriteCoord (MSG_BROADCAST, self.origin_x);
				WriteCoord (MSG_BROADCAST, self.origin_y);
				WriteCoord (MSG_BROADCAST, self.origin_z);
			}
		}
	}
	else
	{		
//		sound (self, CHAN_ITEM, "railwarz/laserhook_pull.wav", 1, ATTN_NORM);
		self.avelocity = '0 0 0';
	}
	
	sound (self, CHAN_ITEM, "railwarz/laserhook_pull.wav", 1, ATTN_NORM);

	self.owner.offhand_on_hook = TRUE;
	
	if (self.owner.offhand_fire_hook)
	{				
		if (other.solid == SOLID_SLIDEBOX)
		{
			setorigin (self, other.origin + other.mins + (other.size * 0.5));
			// self.velocity = '0 0 0';					
			self.velocity = other.velocity;
		}
		else self.velocity = other.velocity;
		
		self.weapon = other.nextthink - time;
		self.enemy = other;
		self.nextthink = time;
		self.think = OffHand_HookPull;
		self.touch = SUB_Null;					
	}
	else
	{
		self.nextthink = time;
		self.think = OffHand_HookVanish;
	}	
};

void() OffHand_Hook_Check =
{
	if ((!self.offhand_fire_hook && self.offhand_hook_enabled) || (self.owner.deadflag) || (gameover))
	{
		OffHand_HookVanish ();
		return;
	}
	
	if (self)
	{
		self.nextthink = time;
		self.think = OffHand_Hook_Check;
	}
};

//This is a combination of the old 'W_FireChain' and 'MakeChain' functions; removed .goalentity.
void() OffHand_W_FireGrapple =
{
	local entity hook = world;
	local float linknum = 0;
	local entity link = world;
	local entity prevlink = world;

	self.offhand_hook_out = TRUE;
	self.offhand_fire_hook = TRUE;
	hook = spawn ();
	hook.classname  = "offhand_hook_entity";
	hook.owner = self;
	self.offhand_hookentity = hook;
	hook.movetype = MOVETYPE_FLY;
	hook.solid = SOLID_BBOX;
	makevectors (self.v_angle);	
	hook.velocity = offhand_hook_speed * aim(self, offhand_hook_speed);
	hook.angles = vectoangles(hook.velocity);
	hook.avelocity 	= '0 0 -500';
	hook.touch = OffHand_T_HookTouch;
	hook.nextthink = time + sys_ticrate; // Instead lets check if we let off the button in mid-flight! eh?
	hook.think = OffHand_Hook_Check;
	setorigin (hook, self.origin + (v_forward * 16) + '0 0 16');
	setsize (hook, '0 0 0', '0 0 0');
	sound (self, CHAN_ITEM, "railwarz/laserhook_fire.wav", 1, ATTN_NORM);

	linknum = 36;
	prevlink = world;
	while (linknum)
	{
		link = spawn ();
		link.classname = "offhand_hook_chain_link";
		link.offhand_hookentity = prevlink;
		prevlink = link;
		link.owner = hook;
		link.enemy = self;
		link.weapon = (linknum / 36); 
		link.movetype = MOVETYPE_NOCLIP;
		link.solid = SOLID_NOT;
		link.angles = vectoangles(hook.velocity);
		
		if (cvar("deathmatch") >= DM_TDM && cvar("deathmatch") <= DM_OneFlagCTF)
		{
			if (self.steam == TEAM_BLUE_13) setmodel (link, "progs/laserhook_blue.mdl"); // Team Blue
			if (self.steam == TEAM_RED_4) setmodel (link, "progs/laserhook_red.mdl"); // Team Red
		}
		else setmodel (link, "progs/laserhook.mdl"); // Default
//		setmodel (link, "progs/beam.mdl"); // Sleeper: This is the old grappling hook model trail.

		link.alpha = 0.4;
		link.scale = 0.5;		
		makevectors (self.angles);
		setorigin (link, hook.origin + (((self.origin + (v_up * 16)/* * (!self.button2))*/ + (v_forward * 16)) - hook.origin) * (link.weapon)));
		setsize (link, '0 0 0', '0 0 0');
		link.nextthink = time + sys_ticrate;
		link.think = OffHand_LinkPos;
		linknum -= 1;
	}
	
	hook.offhand_hookentity = link;
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
};