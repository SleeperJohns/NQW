//Decompiled code. Please respect the original copyright.
// Yoder Sept24 2021 Horde Merge
void() horde_spawn_powerup;

float empathyused;
float IsExplosionDamage;

/*
============
CanDamage

Returns true if the inflictor can directly damage the target.  Used for
explosions and melee attacks.
============
*/
float(entity targ, entity inflictor) CanDamage =
{
	// bmodels need special checking because their origin is 0, 0, 0
	if (targ.movetype == MOVETYPE_PUSH)
	{
		traceline (inflictor.origin, 0.5 * (targ.absmin + targ.absmax), TRUE, self);
		if (trace_fraction == 1) return TRUE;
		if (trace_ent == targ) return TRUE;
		return FALSE;
	}
	
	traceline (inflictor.origin, targ.origin, TRUE, self);
	if (trace_fraction == 1) return TRUE;
	
	traceline (inflictor.origin, targ.origin + '15 15 0', TRUE, self);
	if (trace_fraction == 1) return TRUE;
	
	traceline (inflictor.origin, targ.origin + '-15 -15 0', TRUE, self);
	if (trace_fraction == 1) return TRUE;
	
	traceline (inflictor.origin, targ.origin + '-15 15 0', TRUE, self);
	if (trace_fraction == 1) return TRUE;
	
	traceline (inflictor.origin, targ.origin + '15 -15 0', TRUE, self);
	if (trace_fraction == 1) return TRUE;

	return FALSE;
};

/*
============
Killed
============
*/
void(entity targ, entity attacker) Killed =
{
	local entity oself;

	oself = self;
	self = targ;
	if (self.health < -99) self.health = -99;
//	bprint ("Health: ", ftos(self.health), "\n");

	// HIP: MED -------------------------------------------------
	if (self.charmed) self.effects -= self.effects & (EF_DIMLIGHT);
	// ----------------------------------------------------------
					
	if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE)
	{
		self.th_die ();
		self = oself;
		return;
	}
	self.enemy = attacker;
	
	// MG1: Yoder March04 2022, punish team killspree
	if (cvar("horde") && attacker.classname == "player" && targ.classname == "player")
	{
		dprint ("punish teamkill\n");
		attacker.killtime = 0;
		add_frag (attacker, -2);
	}	
	
	if (self.flags & FL_MONSTER)
	{
		// Yoder Sept24, 2021 Horde Merge
		if (horde_ent)
		{
			if (self.classname != "monster_zombie") // zombies don't count
			{
				killed_monsters += 1;
				WriteByte (MSG_ALL, SVC_KILLEDMONSTER); 
			}
			
			// check kill spree
			if (attacker.classname == "player")
			{
				attacker.killspree++;
				attacker.killtime = time + KILLSPREE_GAP;
					
				if (time < attacker.killtime)
				{
					if (attacker.killspree >= 14) sprint (attacker, ftos(attacker.killspree), " Kills Streak!\n");
					else if (attacker.killspree == 13) sprint (attacker, "13 Kills Streak!\n");
					else if (attacker.killspree == 12) sprint (attacker, "12 Kills Streak!\n");
					else if (attacker.killspree == 11) sprint (attacker, "11 Kills Streak!\n");
					else if (attacker.killspree == 10) sprint (attacker, "10 Kills Streak!\n");
					else if (attacker.killspree == 9) sprint (attacker, "9 Kills Streak!\n");
					else if (attacker.killspree == 8) sprint (attacker, "8 Kills Streak!\n");
					else if (attacker.killspree == 7) sprint (attacker, "7 Kills Streak!\n");
					else if (attacker.killspree == 6) sprint (attacker, "6 Kills Streak!\n");
					else if (attacker.killspree == 5) sprint (attacker, "5 Kills Streak!\n");
					else if (attacker.killspree == 4) sprint (attacker, "Quad Kill!\n");
					else if (attacker.killspree == 3) sprint (attacker, "Triple Kill!\n");
					else if (attacker.killspree == 2) sprint (attacker, "Double Kill!\n");
				}
			}
			// check to see about spawning a powerup
			horde_spawn_powerup();
			
			// Sleeper: Put monsters in certain pools to tally up a certain amount of points (frags) to the player when the killing spree timer ends.
			if (cvar("horde") && attacker.flags & FL_CLIENT)
			{
				// Cannon Fodder Enemies
				if (targ.classname == "monster_army" || targ.classname == "monster_enforcer" || targ.classname == "monster_dog" || 
				    targ.classname == "monster_zombie" || targ.classname == "monster_wizard" || targ.classname == "monster_knight" || 
				    targ.classname == "monster_fish" || targ.classname == "monster_sword" || targ.classname == "monster_eel" || targ.classname == "monster_gremlin")
					attacker.killcount += 1;	
				// Minor Enemies				
				else if (targ.classname == "monster_ogre" || targ.classname == "monster_demon1" || targ.classname == "monster_hell_knight" || 
				         targ.classname == "monster_vomit" || targ.classname == "monster_vomitus" || targ.classname == "monster_tarbaby" || 
				         targ.classname == "monster_scourge" || targ.classname == "trap_spike_mine")
					attacker.killcount += 3;	
				// Major Enemies			
				else if (targ.classname == "monster_shambler" || targ.classname == "monster_shalrath" || targ.classname == "monster_wrath" || targ.classname == "monster_mummy")
					attacker.killcount += 5;
				// Mini-Bosses Enemies			
				else if (targ.classname == "monster_super_wrath" || targ.classname == "monster_lava_man")
					attacker.killcount += 7;	
				// Bosses Enemies		
				else if (targ.classname == "monster_morph" || targ.classname == "monster_dragon" || targ.classname == "monster_armagon" || targ.classname == "monster_oldone" || targ.classname == "monster_boss")
					attacker.killcount += 8;				
				attacker.killtotal = attacker.killcount; // Sleeper: Tally up the points before giving them to the player later.
			}
			killed_monsters += 1;		
		}
		else
		{			
			if (coop && attacker.flags & FL_CLIENT) add_frag (attacker, 1); // Award score in Cooperative Game Types			
			killed_monsters += 1;
		}
		WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
	}
	
	// PGM - guarantee gib if killed by buzzsaw.
	if (attacker.classname == "buzzsaw" || attacker.classname == "Vengeance" || attacker.classname == "pendulum") self.health = -99;

	// PGM - gravity fix!
	self.gravity = 1.0;	
	
	// Some characters have taunts
	if (attacker.classname == "player") attacker.nqwSpeakFrag (targ, attacker);
		
	ClientObituary (self, attacker);
	self.takedamage = DAMAGE_NO;
	self.touch = SUB_Null;
	monster_death_use ();
	self.th_die ();	
	self = oself;
};

// Sleeper: Determine exactly when to use knockback.
void(entity targ, entity inflictor, entity attacker, float damage) Knockback =
{
	local vector dir;
	local float save, take;
	
	dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
	dir = normalize(dir);
	
	if (targ.flags & FL_CLIENT && attacker.flags & FL_MONSTER && attacker != targ) 
	{
		if (cvar("skill") == 5 && !cvar("deathmatch")) targ.velocity += dir * damage * 7; // Sleeper: The double damage is causing too much knockback.
		else targ.velocity += dir * damage * 8;
		return;
	}
	
	if (targ.flags & FL_CLIENT && targ == attacker) // Sleeper: Oh, we're not taking this way. No way.
	{
		if (cvar("skill") == 5 && !cvar("deathmatch")) targ.velocity += dir * damage * 16; // Sleeper: Compensate for half self-damage on skill 5.
		else targ.velocity += dir * damage * 8; // Sleeper: Standard knockback.
		if (cvar("qw_physics_capped") >= 0 && cvar("qw_physics_capped") <= 1 && cvar("allow_bunnyhopping") >= 0 && cvar("allow_bunnyhopping") <= 1) targ.flags |= FL_DAMAGEBOOSTED;
		return;
	}
	
	if (cvar("teamplay") == 2) // Sleeper: Make a hardcoded exception for teamplay 2, since teammates take damage from other teammates anyway.
	{
		if (attacker.classname == "player" && targ.classname == "player" && attacker != targ)
		{
			// Sleeper: Because we want some flinch feedback.
			save = ceil(targ.armortype * damage);
			take = ceil(damage - save);	
			if (targ.flags & FL_CLIENT)
			{
				targ.dmg_take += take;
				targ.dmg_save += save;
				targ.dmg_inflictor = inflictor;
			}
		
			if (cvar("qw_physics_capped") >= 0 && cvar("qw_physics_capped") <= 1 && cvar("allow_bunnyhopping") >= 0 && cvar("allow_bunnyhopping") <= 1) targ.flags |= FL_DAMAGEBOOSTED;
			targ.velocity += dir * damage * 8;
			return;	
		}
	}	
			
	if (!cvar("deathmatch") && !cvar("teamknockback") && attacker.classname == "player" && targ.classname == "player" && attacker != targ) return; // Sleeper: Don't do team knockback.
		
	if (cvar("deathmatch") >= DM_TDM && cvar("deathmatch") <= DM_OneFlagCTF && !cvar("coop"))
	{	
		if (cvar("teamknockback") == TRUE && attacker.steam == targ.steam && attacker != targ) // Sleeper: Do team knockback.
		{
			// Sleeper: Because we want some flinch feedback.
			save = ceil(targ.armortype * damage);
			take = ceil(damage - save);	
			if (targ.flags & FL_CLIENT)
			{
				targ.dmg_take += take;
				targ.dmg_save += save;
				targ.dmg_inflictor = inflictor;
			}
	
			if (cvar("qw_physics_capped") >= 0 && cvar("qw_physics_capped") <= 1 && cvar("allow_bunnyhopping") >= 0 && cvar("allow_bunnyhopping") <= 1) targ.flags |= FL_DAMAGEBOOSTED;
			targ.velocity += dir * damage * 8;
			return;
		}
		
		if (!cvar("teamknockback") && attacker.steam == targ.steam && attacker != targ) return; // Sleeper: Don't do team knockback.
	}	

	if (cvar("qw_physics_capped") >= 0 && cvar("qw_physics_capped") <= 1 && cvar("allow_bunnyhopping") >= 0 && cvar("allow_bunnyhopping") <= 1)
	{
		if (attacker.classname == "player" && targ.classname == "player" && targ != attacker) targ.flags |= FL_DAMAGEBOOSTED;
	}
	targ.velocity += dir * damage * 8; // Sleeper: Everyone at this point takes knockback.
};

// ====
// Function prototype for shield impact handler.
// ====
float(entity targ, entity inflictor, entity attacker, float damage) shield_hit;

// ===================================================== //
// --------------Friendly Fire Description-------------- //
// COOP:
// Teamplay 1 = Disable Friendly Fire (Health & Armor), Disable Self Damage (Classic Coop's default option; Recommended for Speedrunning)
// Teamplay 2 = All Friendly Fire Features Enabled (Not recommended for Co-Operative)
// Teamplay 3 = Disable Friendly Fire (Health & Armor), Enable Self Damage (Reignited Coop's default option)
// DEATHMATCH:
// Teamplay 1 = Disable Friendly Fire (Health only protected), Enable Self Damage (Classic "No Team DMG" option for any Team Modes)
// Teamplay 2 = All Friendly Fire Features Enabled (Default option for Team Deathmatch mode)
// Teamplay 3 = Enable Friendly Fire (Armor only protected), Enable Self Damage (Not recommended in any Deathmatch mode)
// Teamplay 4 = Disabled Friendly Fire (Health & Armor protected), Enable Self Damage (Recommended for any Team Modes)
// Team Knockback Settings:
// Teamknockback 0 = Disabled Knockback on Teammates (Recommended in casual co-operative)
// Teamknockback 1 = Enables Knockback on Teammates (Recommended in deathmatch modes and speedrunning)
// --------------Friendly Fire Description-------------- //
// ===================================================== //

void(entity targ, entity inflictor, entity attacker, float damage) T_DamageApply;
void(entity targ, entity inflictor, entity attacker, float damage) T_Damage =
{
	T_DamageApply (targ, inflictor, attacker, damage);
};

void(entity targ, entity inflictor, entity attacker, float damage) T_DamageApply =
{
//	local vector dir;
	local entity oldself;
	local float save, take;

	if (!targ.takedamage) return;              
	if (targ.is_frozen) return; // MG1: Yoder add, September 9 2020	            
	if (discharged && targ.wetsuit_finished) return;     
	if (attacker.super_damage_finished > time) damage *= 4; // Check for quad damage powerup on the attacker    
	if (deathmatch) damage = RuneApplyBlack (damage, attacker); // rune power up (Black Magic) 
	if (!cvar("deathmatch") && cvar("skill") == 5 && targ.flags & FL_CLIENT && targ == attacker) damage /= 2; // Sleeper: Reduce self-damage by 50% on skill 5.
				          
/* 	// MED: Moved damage_attacker down a bit
	dprint("netname = ");
	dprint(attacker.netname);
	dprint(" classname = ");
	dprint(attacker.classname);
	dprint(" classname = ");
	dprint(inflictor.classname);
	dprint("\n");
*/ 	
	// mal: in Coop, don't let bots hurt human teammates -- that would be REALLY annoying...
	if (coop && targ != attacker && targ.classname == "player" && attacker.classname == "player")
	{
		if (attacker.flags & FL_ISBOT && (!(targ.flags & FL_ISBOT))) return;
	}	
		
	// New Teamplay damage avoidance system (Team Knockback Disabled (Coop 1 Only))
	if (!cvar("deathmatch"))
	{
		// Figure momentum add
		// Sleeper: Separated Single Player && Co-Operative from Deathmatch to separate armor and health damage in team based Deathmatch modes for teammates only. (Blame Rogue's weird teamplay tactics...)
		if (inflictor != world && targ.movetype == MOVETYPE_WALK) Knockback (targ, inflictor, attacker, damage);	
		if (cvar("coop") == REIGNITED_COOP || cvar("coop") == ENHANCED_COOP)
		{	
			if (teamplay == COOP_FF_OFF || teamplay == COOP_FF_ALT)
			{ 
//				if (!deathmatch && targ.team > 0 && targ.team == attacker.team && targ != attacker && attacker.classname == "player" && inflictor.classname != "door") return;
				// Sleeper: Players no longer take damage of any kind or knockback from other players in Reignited Coop. Same pants color is no longer required.
				if (attacker.classname == "player" && targ.classname == "player" && attacker != targ && inflictor.classname != "door") return;	
			}
		}
	}
	        
	// Check for empathy shields  
	if ((targ.expansionitems & HIP_IT_EMPATHY_SHIELDS) && !(inflictor.expansionitems & HIP_IT_EMPATHY_SHIELDS) && (targ != attacker))
	{
		empathyused = TRUE;
		damage /= 2;
		T_DamageApply (attacker, targ, targ, damage);
		empathyused = FALSE;
	} 
    
	if (targ.classname == "trigger_explosion")
	{
		if (IsExplosionDamage != TRUE) return;
	}
	IsExplosionDamage = 0;  
    
	if (targ.expansionitems & DOE_SHIELD)
	{	
		// Allow some damage to pass through.
		damage = shield_hit (targ, inflictor, attacker, damage);		
		if (damage == 0) return;		
	}      
      
	// Used by buttons and triggers to set activator for target firing 
	damage_attacker = attacker;
      
	// Used to keep track of what hit us
	damage_inflictor = inflictor; 	

	// Sleeper: In Skill 5 ("Sleeper Must Die"), armors will appear more durable to damage.
	if  (cvar("skill") == 5 && !cvar("deathmatch") && attacker.flags & FL_MONSTER && targ.flags & FL_CLIENT)
	{
		     if (targ.items & IT_ARMOR1) damage /= 1.05;
		else if (targ.items & IT_ARMOR2) damage /= 1.3;
		else if (targ.items & IT_ARMOR3) damage /= 1.6;
	}    

	// Sleeper: Disable Friendly Fire Damage to Team Armor in team modes for deathmatch.
	if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF && !coop)
	{
		if (TeamArmorDam(targ, inflictor, attacker, damage)) save = ceil(targ.armortype * damage);
		else save = 0;		
	}
	else save = ceil (targ.armortype * damage); // Save damage based on the target's armor level
        
	// Limit damage saving to the amount of armor left
	if (save >= targ.armorvalue) save = targ.armorvalue;

	take = ceil (damage - save);
	
	// Sleeper: Spawn protection; Blocks all health and armor damage after 5 seconds from a spawn/respawn.
	if (targ.spawn_protection_finished >= time)
	{
		// Sleeper: Needed for the flinch reaction, although there isn't any REAL damage being done.
		if (targ.flags & FL_CLIENT)
		{
			targ.dmg_take += take;
			targ.dmg_save += save;
			targ.dmg_inflictor = inflictor;
		}
		
		// Sleeper: Make invulnerability sounds.
		if (self.spawn_protection_finished < time)
		{
			sound (targ, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
			self.invincible_sound = time + 2;
		}
		return;
	}
        
	// Apply armor reduction
	if (save >= targ.armorvalue) 
	{
		targ.armortype = 0;
		targ.items -= targ.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3);
	}
	targ.armorvalue -= save;	
	
	if (deathmatch && !coop) // Sleeper: A copy and paste hack to disable team knockback separately and adding other teamplay stuff from Rogue.
	{
		if (inflictor != world && targ.movetype == MOVETYPE_WALK) Knockback (targ, inflictor, attacker, damage);
		if (!TeamHealthDam(targ, inflictor, attacker, damage)) return; // Same team
	}
    
	// Add to the damage total for clients, which will be sent as a single
	// message at the end of the frame
	// FIXME: Remove after combining shotgun blasts?
	if (targ.flags & FL_CLIENT)
	{
		targ.dmg_take += take;
		targ.dmg_save += save;
		targ.dmg_inflictor = inflictor;
	}	
    
	// Check for godmode or invincibility
	if (targ.flags & FL_GODMODE) return;

	if (targ.invincible_finished >= time)
	{
		if (self.invincible_sound < time)
		{
			sound (targ, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
			self.invincible_sound = time + 2;
		}
		return;
	}
	
	// Special case for killable chthon (yoder, december 16 2020)
	if (world.model == "maps/mgend.bsp")
	{
		if ((targ.classname == "monster_boss") && (targ.spawnflags & 2)) // is killable chthon
		{		
			if (attacker.weapon == IT_LIGHTNING)
			{
				// TODO: Spawn blood
				dprint ("Player has LG! Damage Chthon!\n");
			}
			else
			{
				dprint ("player attacked with non-lightning weapon. Do nothing.\n");
				return;
			}
		}
	}
	    
	if (targ.expansionitems & HIP_IT_EMPATHY_SHIELDS)
	{
		if (self.empathy_sound < time)
		{
			sound (targ, CHAN_ITEM, "hipitems/empathy2.wav", TRUE, ATTN_NORM);
			self.empathy_sound = time + 0.5;
		}
	}
    
	// Classic Teamplay damage avoidance system (Team Knockback Enabled (Coop 2 Only))
	if (cvar("coop") == CLASSIC_COOP)
	{
		// Sleeper: Same pants color is no longer required, but you will take armor damage from other players as it were in vanilla.
		if (!deathmatch && attacker.classname == "player" && targ.classname == "player" && attacker != targ) return;
	}
    
	// Disable self damage in co-op while teamplay is 1 for a vanilla feel
	if (cvar("coop"))
	{
		if (!deathmatch && teamplay == COOP_FF_OFF && attacker.flags & FL_CLIENT && attacker == targ) return;  
	}   
	 
//ZOID--// Sleeper: Moved this up.
/*
	if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF && !coop)
	{
		if (!TeamHealthDam(targ, inflictor, attacker, damage)) return; // same team
	}
*/     
	// rune power up (Earth Magic)
	if (deathmatch) take = RuneApplyEarth (take, targ); 
//--ZOID  	        
	// Sleeper: Monsters do 2x damage to players on skill 5, while keeping in-fighting damage normal.
	if (cvar("skill") == 5 && attacker.flags & FL_MONSTER && targ.flags & FL_CLIENT) take *= 2;    
    
	// Do damage
	targ.health -= take;		

	// They dead
	if (targ.health <= 0)
	{
		Killed (targ, attacker);
		return;
	}
	
	// React to the damage
	oldself = self;
	self = targ;

	if ((self.flags & FL_MONSTER) && attacker != world)
	{
		// Get mad unless of the same class (except for Soldiers)
		if (self != attacker && attacker != self.enemy)
		{						       // Skill 4 and below Soldier          // Skill 5 Soldier (Will use eventually)
			if ((self.classname != attacker.classname) || (self.classname == "monster_army") || (self.classname == "nqw_monster_army") || (self.classname == "monster_dragon"))
			{
				// yoder Sept24, 2021
				// If in horde mode, have enemies obey a reaggro time
				// TODO: Evaluate if we want this as default in co-op?
				if (cvar("horde"))
				{
					if ((self.enemy.classname == "player") && (attacker.classname == "player")) // current and new enemy are both players, check reaggro times
					{
						// Check reaggro times
						if ((!self.aggro_time) || (self.aggro_time + AGGRO_MIN + (random() * AGGRO_ADD < time)))
						{
							self.oldenemy = self.enemy;
							self.enemy = attacker;
							self.aggro_time = time;
							FoundTarget ();
						}
						else
						{
							// Ignore new aggro from this hit
							dprint ("ignore new aggro\n");
						}
					}
					else // Immediately aggro, store the player if previous was player
					{
						if (self.enemy.classname == "player") self.oldenemy = self.enemy;
						self.enemy = attacker;
						FoundTarget ();
					}
				}
				else // Original behavior
				{
					if (self.enemy.classname == "player") self.oldenemy = self.enemy;
					self.enemy = attacker;
					FoundTarget ();
				}
			}
		}
	} 
	
	// Sleeper: Allow the player to make pain sounds as often as possible. Quake 2-like.
	if (self.th_pain && (!(self.flags & FL_MONSTER)))
	{
		self.th_pain (attacker, take);       
		if (!(self.flags & FL_CLIENT)) self.pain_finished = time + 5;  // Sleeper: A hack for shootable buttons to stay reactive.
	}
	if (self.th_pain && self.flags & FL_MONSTER) // Only Monsters
	{
		self.th_pain (attacker, take);
		if (!(self.flags & FL_CLIENT))
		{
			// Nightmare mode monsters don't go into pain frames often
			if (cvar("skill") == 3 || cvar("skill") == 4) self.pain_finished = time + 5; 		    
			// Sleeper: Even though monsters have their pain frames removed in skill 5, let them still have their pain sounds often.
			if (cvar("skill") == 5) self.pain_finished = time + 1.5;		
		}
	}
	self = oldself;
};

/*
============
T_EELZap
============
*/
void(entity inflictor, entity attacker, float damage) T_EELZap =
{
	local float  points;
	local vector org;

	local entity head = findradius (inflictor.origin, damage + 40);
	while (head)
	{
		if (head.takedamage)
		{
			org = head.origin + (head.mins + head.maxs) * 0.5;
			points = 0.5 * vlen (inflictor.origin - org);
			if (points < 0) points = 0;
			points = damage - points;
			if (head == attacker) points *= 0.5;
			if (points > 0)
			{
				if (CanDamage (head, inflictor))
				{	
					// eels take no damage from this attack
					if (head.classname != "monster_eel" && (head.flags & FL_INWATER)) T_Damage (head, inflictor, attacker, points);
				}
			}
		}
		head = head.chain;
	}
};

void(entity inflictor, entity attacker, float damage, entity ignore, string dtype) T_RadiusDamage =
{
	local float points;
	local vector org;
	
	IsExplosionDamage = 1;

	local entity head = findradius(inflictor.origin, (damage + 40));
	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage)
			{
				org = head.origin + ((head.mins + head.maxs) * 0.5);
				points = 0.5 * vlen(inflictor.origin - org);
				if (points < 0) points = 0;
				points = damage - points;
				if (head == attacker) points *= 0.5;
				if (points > 0)
				{
					if (CanDamage(head, inflictor))
					{
						head.deathtype = dtype;	// QIP
						if ((head.classname == "monster_shambler"))
						{
							if (skill == 5)
							{
								T_Damage (head, inflictor, attacker, (points * 0.25));  // ~75% immunity to grenades and splash damage
								sound (head, CHAN_AUTO, "items/protect3.wav", 1, ATTN_NORM); // Make a sound to signify immunity.
							}
							else T_Damage(head, inflictor, attacker, (points * 0.5)); // ~50% immunity to grenades and splash damage								
						}
						else if (head.classname == "trap_spike_mine")
						{
							if (skill <= 0) T_Damage (head, inflictor, attacker, (points * 1)); // ~0% immunity to grenades and splash damage (Emulate 200 health)
							else if (skill >= 1 && skill <= 4) T_Damage (head, inflictor, attacker, (points * 0.5)); // ~50% immunity to grenades and splash damage (Emulate 400 health)
							else if (skill == 5)
							{
								T_Damage (head, inflictor, attacker, (points * 0.25)); // ~75% immunity to grenades and splash damage (Emulate 800 health)
//								sound (head, CHAN_AUTO, "items/protect3.wav", 1, ATTN_NORM); // Make a sound to signify immunity.
							}									
							else T_Damage (head, inflictor, attacker, (points * 0.5)); // ~50% immunity to grenades and splash damage
						}
						else T_Damage (head, inflictor, attacker, points);
					}
				}
			}
		}
		head = head.chain;
	}
};

/* // Sleeper: This is unused.
============
T_BeamDamage
============
*/
/*
void(entity attacker, float damage) T_BeamDamage =
{
	local float  points;
	
	local entity head = findradius (attacker.origin, damage + 40);	
	while (head)
	{
		if (head.takedamage)
		{
			points = 0.5 * vlen (attacker.origin - head.origin);
			if (points < 0) points = 0;

			points = damage - points;

			if (head == attacker) points *= 0.5;

			if (points > 0)
			{
				if (CanDamage (head, attacker))
				{
					if (head.classname == "monster_shambler") T_Damage (head, attacker, attacker, points * 0.5);
					else T_Damage (head, attacker, attacker, points);
				}
			}
		}
		head = head.chain;
	}
};
*/