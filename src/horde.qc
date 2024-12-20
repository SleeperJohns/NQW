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

.float storednextthink;
.void() storedthink;
void() Countdown;
void() Wavecheck;
void() SpawnAmmo;
float spawnme;
.float	wave; // what wave of the horde mode we're on
.float	fodder; // how many fodder squads to spawn
.float	elites; // how many elite squads to spawn
.float	bosses; // how many bosses to spawn
// .float 	spawncount; // number of monster spawns
.float army; // Spawn Army? True/fallse
float(entity spawnpoint) CheckBlockedSpawn;

float key_spawned; // TRUE/FALSE, determine if key has already been spawned, prevent dupes.

float SPAWN_RESET_TIME = 5; // amount of time that a spawn point is considered occupied and not valid for use

/*
================
HordeGetPlayersAlive

added Aug31 2021
Returns a float for the number of living players
================
*/
float() HordeGetPlayersAlive =
{
	local float playercount;
	
	// count entities
	local entity e = find (world, classname, "player");
	while (e)
	{
		if (e.health > 0)
		{
			if (e.flags & FL_CLIENT) playercount++;
			else dprint ("Player is no longer a client!\n");
		}
		e = find (e, classname, "player");
	}
	dprint ("there are ");
	dprint (ftos(playercount));
	dprint (" players alive.\n");
	
	return playercount;
};

/*
================
HordeGetMonstersAlive

added Oct28 2021
Manually counts all living monsters
================
*/
float() HordeGetMonstersAlive =
{
	local float monstercount;
	
	// count monster entities
	local entity e = find (world, category, "monster");
	while (e)
	{
		if ((e.health > 0) && (e.classname != "monster_zombie")) monstercount++;
		
		e = find(e, category, "monster");
	}
	dprint ("verification count. There are ");
	dprint (ftos(monstercount));
	dprint (" monsters alive.\n");
	
	return monstercount;
};
/*
================
HordeFindTarget

added Aug31 2021
Returns a random living player
================
*/
entity() HordeFindTarget =
{
	local float playercount = HordeGetPlayersAlive();
	
	if (playercount == 0) return world;

	local float rcount = random() * playercount; // random value [0,count]
	
	playercount = 0; // reset for new count
	local entity e = find (world, classname, "player");
	while(e)
	{
		if (e.health > 0) playercount++;
		if ((rcount <= playercount) && !(e.flags & FL_NOTARGET)) return e;
		else e = find (e, classname, "player");
	}
	return world;
};


/*QUAKED info_monster_start START_OFF
if targeted, it will toggle between on or off, like lights 
*/
float SKIP_BLOCK_CHECK = 2;
void() monster_start_use =
{
	if (self.spawnflags & START_OFF) self.spawnflags -= START_OFF;
	else self.spawnflags += START_OFF;
};

void() info_monster_start =
{
	self.wait = 0; // used for checking if this is a valid spawn
	self.use = monster_start_use;
	setorigin (self, self.origin);	
	setsize (self, '-80 -80 0', '80 80 128');
};

void() info_monster_start_ranged = // used for ogres and enforcers
{
	self.wait = 0; // used for checking if this is a valid spawn
	self.use = monster_start_use;
	setorigin (self, self.origin);	
	setsize (self, '-44 -44 0', '44 44 128');
};

void() info_monster_start_flying = // used exclusively for scrags (wizards)
{
	self.wait = 0; // used for checking if this is a valid spawn
	self.use = monster_start_use;
	setorigin (self, self.origin);	
	setsize (self, '-80 -80 0', '80 80 128');
};

void() info_monster_start_boss = // used for shalraths and shamblers
{
	self.wait = 0; // used for checking if this is a valid spawn
	self.use = monster_start_use;
	setorigin (self, self.origin);	
	setsize (self, '-44 -44 0', '44 44 128');
};

void() info_horde_weapon =
{
	// self.wait = 0;
//	self.think = SpawnWeapon;
//	self.nextthink = time + HORDE_START_DELAY + random() * 3;	
};

// ENTITY
void() info_horde_ammo =
{
	// self.wait = 0; 
	if (gameworld != APOTHEOSIS)
	{
		self.think = SpawnAmmo;
		self.nextthink = time + HORDE_START_DELAY + random() * 3;	
	}
};

// ENTITY
void() info_horde_item = {self.wait = 0;};

float KEY_FIRST = 1;
float KEY_SECOND = 2;
float KEY_THIRD = 4;
float KEY_FOURTH_PLUS = 8;

// ENTITY
void() info_horde_key = {self.wait = 0;};
//============================================================================
void() PrecacheMonsters =
{
	// knight
	precache_model ("progs/knight.mdl");
	precache_model ("progs/h_knight.mdl");

	precache_sound ("knight/kdeath.wav");
	precache_sound ("knight/khurt.wav");
	precache_sound ("knight/ksight.wav");
	precache_sound ("knight/sword1.wav");
	precache_sound ("knight/sword2.wav");
	precache_sound ("knight/idle.wav");
	
	// hellknight
	precache_model2 ("progs/hknight.mdl");
	precache_model2 ("progs/k_spike.mdl");
	precache_model2 ("progs/h_hellkn.mdl");
	
	precache_sound2 ("hknight/attack1.wav");
	precache_sound2 ("hknight/death1.wav");
	precache_sound2 ("hknight/pain1.wav");
	precache_sound2 ("hknight/sight1.wav");
	precache_sound ("hknight/hit.wav");		// used by C code, so don't sound2
	precache_sound2 ("hknight/slash1.wav");
	precache_sound2 ("hknight/idle.wav");
	precache_sound2 ("hknight/grunt.wav");

	precache_sound ("knight/sword1.wav");
	precache_sound ("knight/sword2.wav");
	
	// dog
	precache_model ("progs/h_dog.mdl");
	precache_model ("progs/dog.mdl");

	precache_sound ("dog/dattack1.wav");
	precache_sound ("dog/ddeath.wav");
	precache_sound ("dog/dpain1.wav");
	precache_sound ("dog/dsight.wav");
	precache_sound ("dog/idle.wav");
	
	// demon
	precache_model ("progs/demon.mdl");
	precache_model ("progs/h_demon.mdl");

	precache_sound ("demon/ddeath.wav");
	precache_sound ("demon/dhit2.wav");
	precache_sound ("demon/djump.wav");
	precache_sound ("demon/dpain1.wav");
	precache_sound ("demon/idle1.wav");
	precache_sound ("demon/sight2.wav");
	
	// ogre
	precache_model ("progs/ogre.mdl");
	precache_model ("progs/rogue_ogre.mdl");
	precache_model ("progs/h_ogre.mdl");
	precache_model ("progs/rogue_h_ogre.mdl");
	precache_model ("progs/grenade.mdl");

	precache_sound ("ogre/ogdrag.wav");
	precache_sound ("ogre/ogdth.wav");
	precache_sound ("ogre/ogidle.wav");
	precache_sound ("ogre/ogidle2.wav");
	precache_sound ("ogre/ogpain1.wav");
	precache_sound ("ogre/ogsawatk.wav");
	precache_sound ("ogre/ogwake.wav");
	
	// grunt
	precache_model ("progs/soldier.mdl");
	precache_model ("progs/h_guard.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	precache_sound ("soldier/death1.wav");
	precache_sound ("soldier/idle.wav");
	precache_sound ("soldier/pain1.wav");
	precache_sound ("soldier/pain2.wav");
	precache_sound ("soldier/sattck1.wav");
	precache_sound ("soldier/sight1.wav");

	precache_sound ("player/udeath.wav");		// gib death
	
	// enforcer
	precache_model2 ("progs/enforcer.mdl");
	precache_model2 ("progs/h_mega.mdl");
	precache_model2 ("progs/laser.mdl");

	precache_sound2 ("enforcer/death1.wav");
	precache_sound2 ("enforcer/enfire.wav");
	precache_sound2 ("enforcer/enfstop.wav");
	precache_sound2 ("enforcer/idle1.wav");
	precache_sound2 ("enforcer/pain1.wav");
	precache_sound2 ("enforcer/pain2.wav");
	precache_sound2 ("enforcer/sight1.wav");
	precache_sound2 ("enforcer/sight2.wav");
	precache_sound2 ("enforcer/sight3.wav");
	precache_sound2 ("enforcer/sight4.wav");
	
	// shambler
	precache_model ("progs/shambler.mdl");
	precache_model ("progs/s_light.mdl");
	precache_model ("progs/h_shams.mdl");
	precache_model ("progs/bolt.mdl");
	
	precache_sound ("shambler/sattck1.wav");
	precache_sound ("shambler/sboom.wav");
	precache_sound ("shambler/sdeath.wav");
	precache_sound ("shambler/shurt2.wav");
	precache_sound ("shambler/sidle.wav");
	precache_sound ("shambler/ssight.wav");
	precache_sound ("shambler/melee1.wav");
	precache_sound ("shambler/melee2.wav");
	precache_sound ("shambler/smack.wav");
	
	// shalrath
	precache_model2 ("progs/shalrath.mdl");
	precache_model2 ("progs/h_shal.mdl");
	precache_model2 ("progs/v_spike.mdl");
	
	precache_sound2 ("shalrath/attack.wav");
	precache_sound2 ("shalrath/attack2.wav");
	precache_sound2 ("shalrath/death.wav");
	precache_sound2 ("shalrath/idle.wav");
	precache_sound2 ("shalrath/pain.wav");
	precache_sound2 ("shalrath/sight.wav");
	
	// wizard
	precache_model ("progs/wizard.mdl");
	precache_model ("progs/h_wizard.mdl");
	precache_model ("progs/w_spike.mdl");

	precache_sound ("wizard/hit.wav");		// used by c code
	precache_sound ("wizard/wattack.wav");
	precache_sound ("wizard/wdeath.wav");
	precache_sound ("wizard/widle1.wav");
	precache_sound ("wizard/widle2.wav");
	precache_sound ("wizard/wpain.wav");
	precache_sound ("wizard/wsight.wav");	
	
	// zombies
	precache_model ("progs/zombie.mdl");
	precache_model ("progs/h_zombie.mdl");
	precache_model ("progs/zom_gib.mdl");

	precache_sound ("zombie/z_idle.wav");
	precache_sound ("zombie/z_idle1.wav");
	precache_sound ("zombie/z_shot1.wav");
	precache_sound ("zombie/z_gib.wav");
	precache_sound ("zombie/z_pain.wav");
	precache_sound ("zombie/z_pain1.wav");
	precache_sound ("zombie/z_fall.wav");
	precache_sound ("zombie/z_miss.wav");
	precache_sound ("zombie/z_hit.wav");
	precache_sound ("zombie/idle_w2.wav");

	// HIPNOTIC ------------------------------------------------
	// scourge
	precache_model ("progs/scor.mdl");
	precache_model ("progs/h_scourg.mdl");
	precache_model ("progs/spike.mdl");
	precache_sound ("misc/null.wav");
	precache_sound ("scourge/idle.wav");
	precache_sound ("scourge/pain.wav");
	precache_sound ("scourge/pain2.wav");
	precache_sound ("scourge/sight.wav");
	precache_sound ("scourge/tailswng.wav");
	precache_sound ("scourge/walk.wav");
	precache_sound ("weapons/rocket1i.wav");

	// gremlin
	precache_model ("progs/grem.mdl");
	precache_model ("progs/h_grem.mdl");
	precache_sound ("grem/death.wav");
	precache_sound ("grem/attack.wav");
	precache_sound ("grem/pain1.wav");
	precache_sound ("grem/pain2.wav");
	precache_sound ("grem/pain3.wav");
	precache_sound ("grem/idle.wav");
	precache_sound ("grem/sight1.wav");
	
	precache_model ("progs/spikmine.mdl");

	// ROGUE ----------------------------------------------------
	// sword (phantom swordsman)
	precache_model ("progs/sword.mdl");
	
	// mummy
	precache_model ("progs/mummy.mdl");

	// morph (guardian)
	precache_model ("progs/morph_gr.mdl");
	precache_model ("progs/morph_eg.mdl");
	precache_model ("progs/morph_az.mdl");
	precache_sound ("guard/death.wav");
	precache_sound ("guard/pain1.wav");
	precache_sound ("guard/see1.wav");

	// wrath
	precache_model ("progs/wrath.mdl");
	precache_model ("progs/w_ball.mdl");
	precache_model ("progs/wrthgib1.mdl");
	precache_model ("progs/wrthgib2.mdl");
	precache_model ("progs/wrthgib3.mdl");	
	precache_sound ("wrath/wsee.wav");
	precache_sound ("wrath/watt.wav");
	precache_sound ("wrath/wpain.wav");
	precache_sound ("wrath/wdthc.wav");

	// super_wrath (overlord)
	precache_model ("progs/s_wrath.mdl");
	precache_model ("progs/s_wrtgb1.mdl");
	precache_model ("progs/s_wrtgb2.mdl");
	precache_model ("progs/s_wrtgb3.mdl");
	precache_sound ("s_wrath/smash.wav");

	// ----------------------------------------------------------
	
	// ammo
	precache_model ("maps/b_shell1.bsp");
	precache_model ("maps/b_shell0.bsp");
	precache_model ("maps/b_nail1.bsp");
	precache_model ("maps/b_nail0.bsp");
	precache_model ("maps/b_rock1.bsp");
	precache_model ("maps/b_rock0.bsp");
	precache_model ("maps/b_batt1.bsp");
	precache_model ("maps/b_batt0.bsp");
	precache_model ("maps/b_lnail1.bsp");
	precache_model ("maps/b_lnail0.bsp");
	precache_model ("maps/b_plas0.bsp");
	precache_model ("maps/b_plas1.bsp");
	precache_model ("maps/b_mrock0.bsp");
	precache_model ("maps/b_mrock1.bsp");
	
	// items
	precache_model ("maps/b_bh10.bsp"); // rotten health
	precache_sound ("items/r_item1.wav");
	precache_model ("maps/b_bh25.bsp"); // regular health
	precache_sound ("items/health1.wav");
	precache_model ("progs/armor.mdl"); // regular armor
	
	// quad damage
	precache_model ("progs/quaddama.mdl");
	precache_sound ("items/damage.wav");
	precache_sound ("items/damage2.wav");
	precache_sound ("items/damage3.wav");
	
	// pentagram (invulnerability)
	precache_model ("progs/invulner.mdl");
	precache_sound ("items/protect.wav");
	precache_sound ("items/protect2.wav");
	precache_sound ("items/protect3.wav");

	// HIPNOTIC --------------------------------------
	// empathy shield
	precache_model ("progs/empathy.mdl");
	precache_sound ("hipitems/empathy.wav");
	precache_sound ("hipitems/empathy2.wav");
	precache_sound ("items/suit2.wav");

	// horn
	precache_model ("progs/horn.mdl");
	precache_sound ("hipitems/horn.wav");
	// -----------------------------------------------

	// ROGUE -----------------------------------------
	// power shield
	precache_model ("progs/shield.mdl");
	precache_model ("progs/p_shield.mdl");
	precache_sound ("shield/pickup.wav");
	precache_sound ("shield/hit.wav");
	precache_sound ("shield/fadeout.wav");

	// anti-gravity belt
	precache_model ("progs/beltup.mdl");
	precache_sound ("belt/pickup.wav");
	precache_sound ("belt/use.wav");
	precache_sound ("belt/fadeout.wav");
	// -----------------------------------------------
	
	// new horde sounds
	precache_sound("horde/nyom.wav");
	
	// precache keys
	if (world.worldtype == WORLDTYPE_MEDIEVAL || world.worldtype == WORLDTYPE_HUB)
	{
		precache_sound ("misc/medkey.wav");
		precache_model ("progs/w_g_key.mdl"); // gold key
		precache_model ("progs/w_s_key.mdl"); // silver key
	}
	if (world.worldtype == WORLDTYPE_METAL)
	{
		precache_sound ("misc/runekey.wav");
		precache_model ("progs/m_g_key.mdl");
		precache_model ("progs/m_s_key.mdl");
	}
	if (world.worldtype == WORLDTYPE_BASE)
	{
		precache_sound2 ("misc/basekey.wav");
		precache_model2 ("progs/b_g_key.mdl");
		precache_model2 ("progs/b_s_key.mdl");
	}
/*
	// QCC ------------------------------------------------
	precache_model ("progs/qclarmor.mdl");
	precache_model ("progs/qchourglass.mdl");
	// -----------------------------------------------------
*/
};
// =================================================================
void() GibMonster = {T_Damage(self, world, world, 4000);};
// =================================================================
/*
================
SpawnMonster
================
*/
entity(string class, vector org, vector temp_angles) SpawnMonster =
{
	local entity monster;
	local float rand;
	monster = spawn();
	
	monster.angles = temp_angles; 
	monster.solid = SOLID_SLIDEBOX;
	monster.movetype = MOVETYPE_STEP;
	//monster.target = "horde_manager";
	monster.flags |= FL_MONSTER;
	//monster.alpha = 1; // only set monster alpha after they're a corpse
	
	local entity oself; // old self
	
	// perform enemy-type specific loading
	if (class == "knight")
	{
		setmodel (monster, "progs/knight.mdl");
		setsize (monster, '-16 -16 -24', '16 16 40');
		org = org + '0 0 24'; // offset based on size
		monster.classname = "monster_knight";
		monster.health = 75;
		monster.th_stand = knight_stand1;
		monster.th_walk = knight_walk1;
		monster.th_run = knight_run1;
		monster.th_melee = knight_atk1;
		monster.th_pain = knight_pain;
		monster.th_die = knight_die;
		droptofloor();
	}
	else if (class == "hellknight")
	{
		setmodel (monster, "progs/hknight.mdl");
		setsize (monster, '-16 -16 -24', '16 16 40');
		org = org + '0 0 24';
		monster.classname = "monster_hell_knight";
		monster.health = 250;
		monster.th_stand = hknight_stand1;
		monster.th_walk = hknight_walk1;
		monster.th_run = hknight_run1;
		monster.th_melee = hknight_melee;
		monster.th_missile = hknight_magicc1;
		monster.th_pain = hknight_pain;
		monster.th_die = hknight_die;
		droptofloor();
	}
	else if (class == "dog")
	{
		setmodel (monster, "progs/dog.mdl");
		setsize (monster, '-32 -32 -24', '32 32 40');
		org = org + '0 0 24';
		monster.classname = "monster_dog";
		monster.health = 25;
		monster.th_stand = dog_stand1;
		monster.th_walk = dog_walk1;
		monster.th_run = dog_run1;
		monster.th_pain = dog_pain;
		monster.th_die = dog_die;
		monster.th_melee = dog_atta1;
		monster.th_missile = dog_leap1;
		droptofloor();
	}
	else if (class == "demon")
	{
		setmodel (monster, "progs/demon.mdl");

		setsize (monster, VEC_HULL2_MIN, VEC_HULL2_MAX);
		monster.classname = "monster_demon1";
		monster.health = 300;
		org = org + '0 0 48';
		monster.th_stand = demon1_stand1;
		monster.th_walk = demon1_walk1;
		monster.th_run = demon1_run1;
		monster.th_die = demon_die;
		monster.th_melee = Demon_MeleeAttack;
		monster.th_missile = demon1_jump1;
		monster.th_pain = demon1_pain;
		droptofloor();
	}
	else if (class == "ogre")
	{
		setmodel (monster, "progs/ogre.mdl");
		setsize (monster, VEC_HULL2_MIN, VEC_HULL2_MAX);
		monster.classname = "monster_ogre";
		monster.health = 200;
		org += '0 0 32';
		monster.th_stand = ogre_stand1;
		monster.th_walk = ogre_walk1;
		monster.th_run = ogre_run1;
		monster.th_die = ogre_die;
		monster.th_melee = ogre_melee;
		monster.th_missile = ogre_nail1;
		monster.th_pain = ogre_pain;
		droptofloor();
	}		
	else if (class == "grunt")
	{
		setmodel (monster, "progs/soldier.mdl");
		setsize (monster, '-16 -16 -24', '16 16 40');
		monster.classname = "monster_army";
		monster.health = 30;
		org = org + '0 0 24';
		monster.th_stand = army_stand1;
		monster.th_walk = army_walk1;
		monster.th_run = army_run1;
		monster.th_missile = army_atk1;
		monster.th_pain = army_pain;
		monster.th_die = army_die;
		droptofloor();
	}
	else if (class == "enforcer")
	{
		setmodel (monster, "progs/enforcer.mdl");
		setsize (monster, '-16 -16 -24', '16 16 40');
		monster.classname = "monster_enforcer";
		monster.health = 80;
		org = org + '0 0 24';
		monster.th_stand = enf_stand1;
		monster.th_walk = enf_walk1;
		monster.th_run = enf_run1;
		monster.th_pain = enf_pain;
		monster.th_die = enf_die;
		monster.th_missile = enf_atk1;
		droptofloor();
	}
	else if (class == "shambler")
	{
		setmodel (monster, "progs/shambler.mdl");
		setsize (monster, VEC_HULL2_MIN, VEC_HULL2_MAX);
		monster.classname = "monster_shambler";
		monster.health = 600;
		org = org + '0 0 32';
		monster.th_stand = sham_stand1;
		monster.th_walk = sham_walk1;
		monster.th_run = sham_run1;
		monster.th_die = sham_die;
		monster.th_melee = sham_melee;
		monster.th_missile = sham_magic1;
		monster.th_pain = sham_pain;
		droptofloor();
	}
	else if (class == "shalrath")
	{
		setmodel (monster, "progs/shalrath.mdl");
		setsize (monster, VEC_HULL2_MIN, VEC_HULL2_MAX);
		monster.classname = "monster_shalrath";
		org = org + '0 0 32';
		monster.health = 400;
		monster.th_stand = shal_stand;
		monster.th_walk = shal_walk1;
		monster.th_run = shal_run1;
		monster.th_die = shalrath_die;
		monster.th_pain = shalrath_pain;
		monster.th_missile = shal_attack1;
		droptofloor();
	}
	else if (class == "wizard")
	{
		setmodel (monster, "progs/wizard.mdl");
		monster.flags |= FL_FLY; // special behavior
		monster.classname = "monster_wizard";
		setsize (monster, VEC_HULL_MIN, VEC_HULL_MAX);
		org = org + '0 0 32';
		monster.health = 80;
		monster.th_stand = wiz_stand1;
		monster.th_walk = wiz_walk1;
		monster.th_run = wiz_run1;
		monster.th_missile = Wiz_Missile;
		monster.th_pain = Wiz_Pain;
		monster.th_die = wiz_die;
	}
	else if (class == "zombie")
	{
		setmodel (monster, "progs/zombie.mdl");
		setsize (monster, '-16 -16 -24', '16 16 40');
		monster.classname = "monster_zombie";
		org = org + '0 0 32';
		monster.health = 60;
		monster.th_stand = zombie_stand1;
		monster.th_walk = zombie_walk1;
		monster.th_run = zombie_run1;
		monster.th_pain = zombie_pain;
		monster.th_die = zombie_die;
		monster.th_missile = zombie_missile;
		monster.target = string_null; // don't target anything!
		droptofloor();
	}
	else if (class == "spawn")
	{
		setmodel (monster, "progs/tarbaby.mdl");
		setsize (monster, '-16 -16 -24', '16 16 40');
		monster.classname = "monster_tarbaby";
		org += '0 0 32';
		self.solid = SOLID_SLIDEBOX;
		self.movetype = MOVETYPE_BOUNCE;
		monster.health = 80;
		monster.th_stand = tbaby_stand1;
		monster.th_walk = tbaby_walk1;
		monster.th_run = tbaby_run1;
		monster.th_missile = tbaby_jump1;
		monster.th_melee = tbaby_jump1;
		monster.th_die = tbaby_die1;
		droptofloor();		
	}
	// HIPNOTIC ----------------------------------------------------------------
	else if (class == "scourge")
	{
		setmodel (monster, "progs/scor.mdl");
		setsize (monster, VEC_HULL2_MIN, VEC_HULL2_MAX);
		monster.classname = "monster_scourge";
		org = org + '0 0 32';
		monster.health = 300;
		monster.th_stand = scourge_stand1;
		monster.th_walk = scourge_walk1;
		monster.th_run = scourge_run1;
		monster.th_pain = scourge_pain;
		monster.th_die = scourge_die;
		monster.th_melee = scourge_melee;
		monster.th_missile = scourge_atk1;
		droptofloor();
	}
	else if (class == "gremlin")
	{
		NumGremlins += 1;
		setmodel (monster, "progs/grem.mdl");
		setsize (monster, VEC_HULL_MIN, VEC_HULL_MAX);
		monster.classname = "monster_gremlin";
		org = org + '0 0 24';
		monster.health = 100;
		monster.max_health = 101;
		monster.yaw_speed = 40;
		monster.th_stand = gremlin_stand1;
		monster.th_walk = gremlin_walk1;
		monster.th_run = gremlin_run1;
		monster.th_die = gremlin_die;
		monster.th_melee = Gremlin_MeleeAttack;     // one of two attacks
		monster.th_missile = Gremlin_MissileAttack; // check for random jump or firing of weapon
		monster.th_pain = gremlin_pain;
		droptofloor();
	}
	else if (class == "spike_mine")
	{
		setmodel (monster, "progs/spikmine.mdl");
		monster.classname = "trap_spike_mine";
		monster.solid = SOLID_BBOX;
		monster.movetype = MOVETYPE_FLYMISSILE;
		setsize (monster, monster.mins, monster.maxs);
		monster.avelocity = '-50 100 150';
		org += '0 0 32';
		monster.health = 200;
		monster.frame = 0;
		monster.think = spike_mine_first_think;
		monster.touch = spikemine_Touch;
		monster.th_die = spikemine_Touch;
		monster.th_stand = spikemine_Home;
		monster.th_walk = spikemine_Home;
		monster.th_run = spikemine_Home;
		monster.th_melee = spikemine_Home;
		monster.th_missile = spikemine_Home;
		monster.nextthink = time + 0.2;	
		monster.flags |= FL_MONSTER;		
	}	
	// ROGUE --------------------------------------------------------------------
	/*
	else if (class == "sword")
	{
		setmodel (monster, "progs/sword.mdl");
		setsize (monster, '-16 -16 -24', '16 16 40');
		org = org + '0 0 24';
		monster.classname = "monster_sword";
		monster.health = 150;
		monster.th_stand = sword_stand1;
		monster.th_walk = sword_stand1;
		monster.th_run = sword_pause;
		monster.th_melee = sword_atk1;
		monster.th_pain = sword_pain;
		monster.th_die = sword_die;
		droptofloor();
	}
	*/
	else if (class == "death_spawn")
	{
		setmodel (monster, "progs/rogue_tarbaby.mdl");
		setsize (monster, '-16 -16 -24', '16 16 40');
		monster.classname = "monster_tarbaby";
		org += '0 0 32';
		monster.th_stand = tbaby_stand1;
		monster.th_walk = tbaby_walk1;
		monster.th_run = tbaby_run1;
		monster.th_missile = tbaby_jump1;
		monster.th_melee = tbaby_jump1;
		monster.th_die = tbaby_die1;
		local float r = random();
		if (r < 0.5) 
		{
			monster.spawnflags |= 8;
			monster.health = 100;
			monster.skin = 2;
		}
		else
		{
			monster.spawnflags |= 4;
			monster.health = 60;
			monster.skin = 1;
		}
		
		droptofloor();		
	}	
	else if (class == "ogre_boss") // ROGUE: add Clusterbomb Ogre
	{
		setmodel (monster, "progs/rogue_ogre.mdl");
		setsize (monster, VEC_HULL2_MIN, VEC_HULL2_MAX);
		monster.classname = "monster_ogre";
		monster.health = 200;
		org += '0 0 32';
		monster.th_stand = ogre_stand1;
		monster.th_walk = ogre_walk1;
		monster.th_run = ogre_run1;
		monster.th_die = ogre_die;
		monster.th_melee = ogre_melee;
		monster.th_missile = ogre_nail1;
		monster.th_pain = ogre_pain;
		// ROGUE: Clusterbomb Ogre
		monster.spawnflags |= 2;
		monster.skin = 1;
		droptofloor();
	}	
	else if (class == "mummy")
	{
		setmodel (monster, "progs/mummy.mdl");
		setsize (monster, VEC_HULL_MIN, VEC_HULL_MAX);
		monster.classname = "monster_mummy";
		org = org + '0 0 32';
		monster.health = 500;
		monster.th_stand = mummy_stand1;
		monster.th_walk = mummy_walk1;
		monster.th_run = mummy_run1;
		monster.th_missile = mummy_missile;
		monster.th_pain = mummy_pain;
		monster.th_die = mummy_die;
		droptofloor();
	}
	
	else if (class == "morph")
	{
		rand = random() * 3;
		
		if (rand < 1) monster.model = "progs/morph_az.mdl"; // Aztec
		else if (rand < 2) monster.model = "progs/morph_eg.mdl"; // Egyptian
		else monster.model = "progs/morph_gr.mdl"; // Greek
		
		setmodel (monster, monster.model);
		setsize (monster, VEC_HULL_MIN, VEC_HULL_MAX);
		monster.classname = "monster_morph";
		org = org + '0 0 24';
		monster.health = 2000;
		monster.th_stand = morph_stand1;
		monster.th_walk = morph_walk1;
		monster.th_run = morph_run1;
		monster.th_melee = morph_attack;
		monster.th_missile = morph_fire1;
		monster.th_pain = morph_pain;
		monster.th_die = morph_die;
		droptofloor();
	}

	else if (class == "wrath")
	{
		setmodel (monster, "progs/wrath.mdl");
		monster.flags |= FL_FLY;
		monster.classname = "monster_wrath";
		setsize (monster, VEC_HULL_MIN, VEC_HULL_MAX);
		org = org + '0 0 32';
		monster.health = 400;
		monster.yaw_speed = 35;
		monster.th_stand = wrath_stand1;
		monster.th_walk = wrath_walk01;
		monster.th_run = wrath_run01;
		monster.th_missile = wrath_attack;
		monster.th_pain = wrath_pain;
		monster.th_die = wrath_die02;
	}
	else if (class == "super_wrath")
	{
		setmodel (monster, "progs/s_wrath.mdl");
		monster.flags |= FL_FLY;
		monster.classname = "monster_wrath";
		setsize (monster, VEC_HULL_MIN, VEC_HULL_MAX);
		org = org + '0 0 32';
		monster.health = 1000;
		monster.yaw_speed = 35;
		monster.th_stand = overlord_stand1;
		monster.th_walk = overlord_walk01;
		monster.th_run = overlord_run01;
		monster.th_missile = overlord_missile;
		monster.th_melee = overlord_melee;
		monster.th_pain = overlord_pain;
		monster.th_die = overlord_die02;
	}		
	// --------------------------------------------------------------------------
	else dprint("ERROR: No monster provided");
	
	// finish the shared settings
	setorigin (monster, org);
	monster.origin_z += 1;	// raise off floor a bit
	
	// temporarily swap self for next funcs
	oself = self;
	self = monster;
	 
//	if (class != "wizard") droptofloor();
	
	if (!walkmove(0,0))
	{
		dprint ("walkmonster in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}
	
	// resume normal self behavior
	self = oself;
	
	monster.category = CATEGORY_MONSTER;
	monster.takedamage = DAMAGE_AIM;
	monster.ideal_yaw = monster.angles * '0 1 0';
	if (!monster.yaw_speed) monster.yaw_speed = 20;
	monster.view_ofs = '0 0 25';
	monster.use = monster_use;
	
	monster.flags |= FL_MONSTER;
	
	monster.enemy = HordeFindTarget (); // find a random living player
	monster.think = FoundTarget;
	monster.nextthink = time + 0.1;
	
	spawn_tdeath_fast (monster.origin, monster);
	
	monster.owner = self;
//	if (monster.classname != "monster_zombie") total_monsters += 1; // don't count zombies toward total goal	
	total_monsters += 1;
	
	return monster;
};

void() horde_ammo_touch =
{
	local entity temp_player, t; 
	local float best_weapon, prev_ammo, picked_amount;
	
	// early exit touch if not a player or not alive
	if (other.classname != "player") return;
	if (other.health <= 0) return;
		
	if (self.weapon == 1) 
	{
		if (other.ammo_shells >= 100) return;
		prev_ammo = other.ammo_shells;	
		other.ammo_shells += self.cnt_horde;
		bound_other_ammo();
		picked_amount = other.ammo_shells - prev_ammo;
	}
	// Spikes
	if (self.weapon == 2) 
	{
		if (other.ammo_nails >= 200) return;
		prev_ammo = other.ammo_nails;
		other.ammo_nails += self.cnt_horde;
		bound_other_ammo();
		picked_amount = other.ammo_nails - prev_ammo;
	}
	// Rockets
	if (self.weapon == 3) 
	{
		if (other.ammo_rockets >= 100) return;
		prev_ammo = other.ammo_rockets;
		other.ammo_rockets += self.cnt_horde;
		bound_other_ammo();
		picked_amount = other.ammo_rockets - prev_ammo;
	}
	// Cells
	if (self.weapon == 4) 
	{
		if (other.ammo_cells >= 100) return;
		prev_ammo = other.ammo_cells;
		other.ammo_cells += self.cnt_horde;
		bound_other_ammo();
		picked_amount = other.ammo_cells - prev_ammo;
	}
	// Lava Spikes	
	if (self.weapon == 5)			
	{
		if (other.ammo_lava_nails >= 200) return;
		prev_ammo = other.ammo_lava_nails;
		other.ammo_lava_nails += self.cnt_horde;
		bound_other_ammo();
		picked_amount = other.ammo_lava_nails - prev_ammo;
		other.ammo_lava_nails = prev_ammo; // Sleeper: Hack the ammo, so it doesn't double.
	}
	// Multi-Rockets
	if (self.weapon == 6)
	{
		if (other.ammo_multi_rockets >= 100) return;
		prev_ammo = other.ammo_multi_rockets;
		other.ammo_multi_rockets += self.cnt_horde;
		bound_other_ammo();
		picked_amount = other.ammo_multi_rockets - prev_ammo;
		other.ammo_multi_rockets = prev_ammo; // Sleeper: Hack the ammo, so it doesn't double.
	}
	// Plasma-Rockets
	if (self.weapon == 7)
	{
		if (other.ammo_plasma >= 100) return;
		prev_ammo = other.ammo_plasma;
		other.ammo_plasma += self.cnt_horde;
		bound_other_ammo();
		picked_amount = other.ammo_plasma - prev_ammo;
		other.ammo_plasma = prev_ammo; // Sleeper: Hack the ammo, so it doesn't double.
	}			
	
	// if the player was using their best weapon, change up to the new one if better		
	t = self; // hang on to the ammo entity for a moment
	self = other;
	best_weapon = W_BestWeapon();
	self = t; // set self back to ammo entity

/*	
	// if player is at max ammo for ammo's type, return
	if (((self.weapon == 1) && (other.ammo_shells1 >= 100)) || // shotgun
		((self.weapon == 2) && (other.ammo_nails1 >= 200)) || // nailgun
		((self.weapon == 3) && (other.ammo_rockets1 >= 100)) || // rockets
		((self.weapon == 4) && (other.ammo_cells1 >= 100))) // cells
		return;
*/	 					
		
//	sprint(other, "You got the ", self.netname, "\n");

	string s;
	
	if (picked_amount != 1) s = "s";
	
	sprint (other, "You picked up a ", self.message, " of ", self.netname, "s ");
	sprint (other, "(+", ftos(picked_amount), " ", self.netname, s, ")\n");	
	self.message = string_null;
	
//	sprint (other, "", "You picked up ",  ftos(picked_amount), " ", self.netname, s, "\n");
	
	// ammo touch sound
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	// change to a better weapon if appropriate
	if (other.weapon == best_weapon)
	{
		t = self;
		self = other;
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo ();
		self = t;
	}

	// loop through all players and give ammo
	temp_player = find (world, classname, "player");
	while (temp_player)
	{
		if (temp_player.health > 0) // only give ammo to living players
		{
			if (self.weapon == 1) temp_player.ammo_shells1 += self.cnt_horde; // shells
			else if (self.weapon == 2) temp_player.ammo_nails1 += self.cnt_horde; // spikes
			else if (self.weapon == 3) temp_player.ammo_rockets1 += self.cnt_horde; // rockets
			else if (self.weapon == 4) temp_player.ammo_cells1 += self.cnt_horde; // cells
			else if (self.weapon == 5)  temp_player.ammo_lava_nails += self.cnt_horde;
			else if (self.weapon == 6)  temp_player.ammo_multi_rockets += self.cnt_horde;
			else if (self.weapon == 7)  temp_player.ammo_plasma += self.cnt_horde;
			
			EnableComboWeapons (other);
			UpdateAmmoCounts (other);

			// temp swap and set bounds
			t = other;
			other = temp_player;
			bound_other_ammo();
			other = t;
			
			// temp swap again and set current ammo
			t = self;
			self = temp_player;
			W_SetCurrentAmmo();
			self = t;
		}
		temp_player = find (temp_player, classname, "player");
	}
	
	// remove
	self.model = string_null;
	self.solid = SOLID_NOT;
	// AY dec06 2021
	// self.owner.wait = FALSE; The Old Way
	self.owner.think = SpawnAmmo;
	self.owner.nextthink = time + HORDE_AMMO_RESPAWN_DELAY;
	// end AY
	remove (self);
};

// void() SpawnItem;

void() horde_health_touch =
{	
	local float prev_health, picked_amount;
	
	if (other.classname != "player") return;
	
				       // Single Player / Cooperative / Horde Mode on a private server		   // Cooperative / Horde Mode on a public server			
	local float ChangeOnTheFly = ((coop < 5 && cvar("horde") < 2 && !deathmatch && cvar("sv_public") == 0) || (coop == 1 && cvar("horde") < 2 && !deathmatch && cvar("sv_public") == 1));
		
	// When playing Cooperative, let Health Touch handle Mega Health healamount values so that the healamount values can be changed on fly.
	if (ChangeOnTheFly)
	{	
		if (self.healtype == 2)
		{
			if (cvar("skill") <= 3) self.healamount = 100; // Default amount
			else if (cvar("skill") == 4) self.healamount = 50;  // Copper amount
			else if (cvar("skill") == 5) self.healamount = 75;  // Sleeper Must Die! amount
			other.health_overstacked = 1; 				 // Enable overstack flag	
			if (other.health_deflate == 1) other.health_deflate = 0; // Replace initial spawned deflate decay with the overstack decay.			
		}
		else if (self.healtype == 0)
		{
			if (cvar("skill") <= 4)	self.healamount = 15;
			else if (cvar("skill") == 5) self.healamount = 10;
		}	
	}	
	
	// Sleeper: Courtesy of Alkaline. This calculates the delta between the amount of health pickups and the player's health.
	prev_health   = other.health;
	other.health += self.healamount;
	bound_other_health();	     // Sleeper: Bound health in a similiar fashion to ammo.
	picked_amount = other.health - prev_health;
	other.health  = prev_health; // Sleeper: Hack the health, so it doesn't double.		
	
	local float shouldstay = (coop && !cvar("horde")) && self.healtype != 2 || (coop && cvar("horde")) && self.healtype == 2;
	if (self.healtype == 2)
	{
		if ((other.health >= 250)) return;
		if (shouldstay) // Sleeper: Allow Megahealth to be picked up by multiple players in Horde Mode. (FIXME: Should we make Megahealth respawnable instead?) 
		{
			self.health_lockout_selective = 1;
			if (self.health_lockout_selective == 1) // Choose when an ammo pack can be locked out from being picked up again from a player during coop.
			{	
				if (self.health_lockout[other.colormap] == -1) return; // Lockout
			}
		}	
		sprint (other, "You picked up Megahealth (+", ftos(picked_amount), " Health)\n");
		if (!T_Heal(other, self.healamount, 1)) return;
		if (shouldstay) self.alpha = 0.45;
	}
	else
	{
		if (!T_Heal(other, self.healamount, 0)) return;
	}
	
	// Health specific player prints
	if (cvar("skill") <= 4)
	{
		if (self.healtype == 0) sprint (other, "You picked up a Rotten Healthpack (+", ftos(picked_amount), " Health)\n");
		else if (self.healtype == 1) sprint (other, "You picked up a Healthpack (+", ftos(picked_amount), " Health)\n");		
	}
	else if (cvar("skill") == 5)
	{
		if (self.healtype == 0) sprint (other, "You picked up First Aid (+", ftos(picked_amount), " Health)\n");
		else if (self.healtype == 1) sprint (other, "You picked up a Medkit (+", ftos(picked_amount), " Health)\n");
	}
	
	// health touch sound
	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	
//	self.model = string_null;
//	self.solid = SOLID_NOT;

	if (!self.health_lockout_selective) 
	{
		self.model = string_null;
		self.solid = SOLID_NOT;
	}
	if (self.health_lockout_selective == 1) self.health_lockout[other.colormap] = -1;
	
	self.owner.wait = 0;
//	self.owner.think = SpawnItem;
//	self.owner.nextthink = time + HORDE_AMMO_RESPAWN_DELAY;
	remove (self);
};

void() horde_armor_touch =
{
	local float type, value, maxvalue;	

	if (other.health <= 0) return;
	if (other.classname != "player") return;
	
	// Fire trigger, even though the item hasn't been picked up.			
	if (!self.cnt_trig)
	{
		self.cnt_trig = 1;
		activator = other;
		SUB_UseTargets();
	}

	// Max Armor reached? Do nothing
	if (cvar("skill") == 5)
	{
		if (!(other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3))) other.max_armorvalue = 666; // Needs to be something
		if (self.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3) && other.armorvalue >= other.max_armorvalue * 2) return;																		
	}	
			
//	local float shouldstay = (coop) && !self.aflag;
//	if (shouldstay)
//	{
//		if (AlreadyPickedUp(other)) return;
//	}	
	
	if (self.classname == "item_armor1") // The Green Armor
	{
		if (cvar("skill") == 5)
		{
			maxvalue = 25;
			value = 50;
			type = 0.15;
			self.message = "You got the Jacket Armor";
			self.noise = "items/q2armor1.wav"; // Quake 2 Jacket Armor pickup sound		
		}
		else
		{
			maxvalue = 100;
			value = 100;
			type = 0.3;
			self.message = "You got the Green Armor";
			self.noise = "items/armor1.wav"; // Quake 1 Armor pickup sound	
			self.items = IT_ARMOR1;		
		}
	}
	else if (self.classname == "item_armor2") // The Yellow Armor
	{
		if (cvar("skill") == 5)
		{
			maxvalue = 50;
			value = 100;
			type = 0.19;
			self.message = "You got the Combat Armor";
			self.noise = "items/q3armor1.wav"; // Quake 3 Armor pickup sound
		}
		else
		{
			maxvalue = 150;
			value = 150;
			type = 0.6;
			self.message = "You got the Yellow Armor";
			self.noise = "items/armor1.wav"; // Quake 1 Armor pickup sound	
			self.items = IT_ARMOR2;		
		}			
	}
	else if (self.classname == "item_armorInv") // The Red Armor
	{
		if (cvar("skill") == 5)
		{
			maxvalue = 75;
			value = 150;
			type = 0.245;
			self.message = "You got the Heavy Armor";
			self.noise = "items/q4armor1.wav"; // Quake 4 Armor pickup sound
		}
		else 
		{
			maxvalue = 200;
			value = 200;
			type = 0.8;
			self.message = "You got the Red Armor";
			self.noise = "items/armor1.wav"; // Quake 1 Armor pickup sound
			self.items = IT_ARMOR3;
		}
	}		
	
	if (cvar("skill") == 5)
	{	
		// Quake 2 armor upgrading mechanics and introduce armorrot
		other.armortype = type;		 // Level of resistance
		other.max_armorvalue = maxvalue; // The maximum armor value			
		// Dictate overstacking
		if (self.classname == "item_armor1")
		{
			self.items = IT_ARMOR1;
			if (other.items & (IT_ARMOR1))
			{
				self.items           = IT_ARMOR1; // Override armor level
				other.armortype      = 0.15;      // Override Level of Resistence
				other.armorvalue    += 25;        // Override additional armorvalue
				other.max_armorvalue = 25;        // Override max armor if adding armorvalue
				if (other.armorvalue > 50) other.armorvalue = 50;        // Cap armor				
			}
			else if (other.items & (IT_ARMOR2))
			{
				self.items           = IT_ARMOR2; // Override armor level
				other.armortype      = 0.19;	  // Override Level of Resistence	
				other.armorvalue    += 12;        // Override additional armorvalue
				other.max_armorvalue = 50;        // Override max armor if adding armorvalue
				if (other.armorvalue > 100) other.armorvalue = 100;       // Cap armor									
			}
			else if (other.items & (IT_ARMOR3))
			{
				self.items           = IT_ARMOR3; // Override armor level
				other.armortype      = 0.245;     // Override Level of Resistence
				other.armorvalue    += 9; 	  // Override additional armorvalue
				other.max_armorvalue = 75;        // Override max armor if adding armorvalue
				if (other.armorvalue > 150) other.armorvalue = 150;       // Cap armor				
			}						
			else other.armorvalue = 25;	          // Fresh Armor?						
		}
		else if (self.classname == "item_armor2")
		{
			self.items = IT_ARMOR2;
			if (other.items & (IT_ARMOR2))
			{
				self.items           = IT_ARMOR2; // Override armor level
				other.armortype      = 0.19;	  // Override Level of Resistence
				other.armorvalue    += 50;        // Override additional armorvalue
				other.max_armorvalue = 50;        // Override max armor if adding armorvalue
				if (other.armorvalue > 100) other.armorvalue = 100;       // Cap armor							
			}
			else if (other.items & (IT_ARMOR1))
			{
				self.items           = IT_ARMOR2; // Override armor level
				other.armortype      = 0.19;	  // Override Level of Resistence
				other.armorvalue    += 22;        // Override additional armorvalue
				other.max_armorvalue = 50;        // Override max armor if adding armorvalue
				if (other.armorvalue > 100) other.armorvalue = 100;       // Cap armor				
			}
			else if (other.items & (IT_ARMOR3))
			{
				self.items           = IT_ARMOR3; // Override armor level
				other.armortype      = 0.245;     // Override Level of Resistence
				other.armorvalue    += 37;        // Override additional armorvalue	
				other.max_armorvalue = 75;        // Override max armor if adding armorvalue
				if (other.armorvalue > 150) other.armorvalue = 150;       // Cap armor				
			}			 
			else other.armorvalue = 50;	          // Fresh Armor?							
		}
		else if (self.classname == "item_armorInv")
		{
			self.items = IT_ARMOR3;
			if (other.items & (IT_ARMOR3))
			{
				self.items           = IT_ARMOR3; // Override armor level
				other.armortype      = 0.245;     // Override Level of Resistence
				other.armorvalue    += 75;        // Override additional armorvalue
				other.max_armorvalue = 75;  	  // Override max armor if adding armorvalue.
				if (other.armorvalue > 150) other.armorvalue = 150;       // Cap armor					
			}
			else if (other.items & (IT_ARMOR1))
			{
				self.items           = IT_ARMOR3; // Override armor level
				other.armortype      = 0.245;     // Override Level of Resistence			
				other.armorvalue    += 59;        // Override additional armorvalue
				other.max_armorvalue = 75;        // Override max armor if adding armorvalue.
				if (other.armorvalue > 150) other.armorvalue = 150;      // Cap armor				
			}
			else if (other.items & (IT_ARMOR2))
			{
				self.items           = IT_ARMOR3; // Override armor level
				other.armortype      = 0.245;     // Override Level of Resistence
				other.armorvalue    += 63;        // Override additional armorvalue
				other.max_armorvalue = 75;        // Override max armor if adding armorvalue.
				if (other.armorvalue > 150) other.armorvalue = 150;       // Cap armor				
			}
			else other.armorvalue = 75;	          // Fresh Armor?									
		}
		// Armor shards would go next												
	}
	else 
	{
		// General armor maths for Singleplayer/Cooperative and Deathmatch
		if (((other.armortype * other.armorvalue) >= (type * value))) return;
		other.armortype = type;
		other.armorvalue = value;
		other.max_armorvalue = maxvalue; // Not needed here, but is good for consistency
	}	
	other.items -= other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3);
	other.items |= self.items;
	
	self.model = string_null;
	self.solid = SOLID_NOT;	
	
	sprint (other, "", self.message, "\n");
	self.message = string_null;
// armor touch sound
	sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.owner.wait = 0;
//	self.owner.think = SpawnItem;
//	self.owner.nextthink = time + HORDE_AMMO_RESPAWN_DELAY;
	remove (self);
};

void() horde_print_keys =
{
	dprint (ftos(keys_silver));
	dprint (" silver keys : ");
	dprint (ftos(keys_gold));
	dprint (" gold keys\n");
};

void(entity temp_player) horde_set_keys =
{
	// player has just respawned, reset their keys based on global key values
	if (keys_silver > 0) temp_player.items += IT_KEY1;
	
	if (keys_gold > 0) temp_player.items += IT_KEY2;
};
	

void(float key_item) horde_key_give_all =
{
	local entity temp_player = find (world, classname, "player");	
	while (temp_player)
	{
		temp_player.items += key_item;
		temp_player = find (temp_player, classname, "player");
	}
	
	horde_print_keys();
};

void(float key_item) horde_key_remove_all =
{
	local entity temp_player = find (world, classname, "player");	
	while (temp_player)
	{
		temp_player.items -= key_item;
		temp_player = find (temp_player, classname, "player");
	}
	
	horde_print_keys();
};

void(float key_item) horde_key_give =
{
	if (key_item & IT_KEY1)
	{
		keys_silver++;
		if (keys_silver == 1) horde_key_give_all (IT_KEY1);
	}
	else if (key_item & IT_KEY2)
	{
		keys_gold++;
		if (keys_gold == 1) horde_key_give_all (IT_KEY2);
	}
	horde_print_keys();
}

void(float key_item) horde_key_spend =
{
	if (key_item & IT_KEY1)
	{
		keys_silver--;
		if (keys_silver == 0) horde_key_remove_all (IT_KEY1);
	}
	else if (key_item & IT_KEY2)
	{
		keys_gold--;
		if (keys_gold == 0) horde_key_remove_all (IT_KEY2);
	}
	horde_print_keys();
}

void() horde_key_touch =
{
	if (other.classname != "player") return;
	if (other.health <= 0) return;
	if (other.flags & FL_ISBOT) return;

	sprint (other, "", "You got the ", self.netname, "\n");
	
//	sprint(other, "$qc_got_item", self.netname);
	
	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	
	horde_key_give (self.items);
	
	// find the horde manager and trigger the next wave
	if (key_spawned)
	{
		dprint ("key triggers next wave\n");
		horde_ent.wait = TRUE;
		horde_ent.think = Countdown;
		horde_ent.nextthink = time;
	}
	else dprint("key shouldn't trigger next wave!\n");
	/*
	local entity t = find(world, classname, "horde_manager");
	if (t != world)
	{
		t.wait = TRUE;
		t.think = Countdown;
		t.nextthink = time;
	}
	*/
	remove (self);
}

float shift_weapon_spawn;
void() SpawnWeapon =
{
//	local float r; 
	local entity item = spawn();
	local vector pos = self.origin;
	
	if (gameworld == APOTHEOSIS)
	{
		if (!spawnme) return;
	}
		
	pos -= '12 12 0';
	
	shift_weapon_spawn++;
	if (shift_weapon_spawn == 1)
	{
		item.classname = "weapon_supershotgun";
		setmodel (item, "progs/g_shot.mdl");
		item.aflag = IT_SHELLS;
		item.cnt_horde = 5;
//		item.message = "";
		item.weapon = IT_SUPER_SHOTGUN;
		item.netname = "Double-barrelled Shotgun";
	}
	else if (shift_weapon_spawn == 2)
	{	
		item.classname = "weapon_nailgun";
		setmodel (item, "progs/g_nail.mdl");
		item.aflag = IT_NAILS;
		item.cnt_horde = 30;
//		item.message = "";
		item.weapon = IT_NAILGUN;
		item.netname = "Nailgun";				
	}
	else if (shift_weapon_spawn == 3)
	{
		item.classname = "weapon_supernailgun";
		setmodel (item, "progs/g_nail2.mdl");
		item.aflag = IT_NAILS;
		item.cnt_horde = 30;
//		item.message = "";
		item.weapon = IT_SUPER_NAILGUN;
		item.netname = "Super Nailgun";	
	}
	else if (shift_weapon_spawn == 4)
	{
		item.classname = "weapon_grenadelauncher";
		setmodel (item, "progs/g_rock.mdl");
		item.aflag = IT_ROCKETS;
	 	item.cnt_horde = 5;
//		item.message = "";
		item.weapon = IT_GRENADE_LAUNCHER;
		item.netname = "Grenade Launcher";	
	}
	else if (shift_weapon_spawn == 5)
	{
		item.classname = "weapon_rocketlauncher";
		setmodel (item, "progs/g_rock2.mdl");
		item.aflag = IT_ROCKETS;
		item.cnt_horde = 10;
//		item.message = "";
		item.weapon = IT_ROCKET_LAUNCHER;
		item.netname = "Rocket Launcher";	
	}
	else if (shift_weapon_spawn == 6)
	{
		item.classname = "weapon_lightning";
		setmodel (item, "progs/g_light.mdl");
		item.aflag = IT_CELLS;
		item.cnt_horde = 15;
//		item.message = "";
		item.weapon = IT_LIGHTNING;
		item.netname = "Thunderbolt";	
	}
	else if (shift_weapon_spawn == 7)
	{
		item.classname = "weapon_proximity_gun";
		setmodel (item, "progs/g_prox.mdl");
		item.aflag = IT_ROCKETS;
		item.cnt_horde = 6;
//		item.message = "";
		item.weapon = IT_PROXIMITY_GUN;
		item.netname = "Proximity Gun";	
	}
	else if (shift_weapon_spawn == 8)
	{
		item.classname = "weapon_laser_gun";
		setmodel (item, "progs/g_laserg.mdl");
		item.aflag = IT_CELLS;
		item.cnt_horde = 30;
//		item.message = "";
		item.weapon = IT_LASER_CANNON;
		item.netname = "Laser Cannon";	
	}						
	else if (shift_weapon_spawn == 9)
	{		
		item.classname = "weapon_mjolnir";
		setmodel (item, "progs/g_hammer.mdl");
		item.aflag = IT_CELLS;
		item.cnt_horde = 30;
//		item.message = "";
		item.weapon = IT_MJOLNIR;
		item.netname = "Mjolnir";		
	}
	setorigin (item, pos + '0 0 1');
	setsize (item, '0 0 0', '32 32 56');
	item.owner = self;
	self.wait = 1;
	item.movetype = MOVETYPE_TOSS;
	item.solid = SOLID_TRIGGER;
	item.flags = FL_ITEM;
	item.touch = weapon_touch;
		
	spawn_tfog_silent (pos + '0 0 8');
};

void() SpawnAmmo =
{
	local float r, is_big; 
	local entity item = spawn();
	local vector pos = self.origin;
		
	if (gameworld == APOTHEOSIS)
	{
		if (!spawnme) return;
	}	
		
	// roll a d4, a 1 means big ammo.
	is_big = (random() * 4) <= 1; 
	
	if (is_big) pos -= '16 16 0';
	else pos -= '12 12 0';
	
	// NEW: roll a d20, 1-8 is shells, 9-14 is spikes, 14-17 is rockets, 18-20 is cells
	// OLD: roll a d12, 1-5 is shells, 6-10 is spikes, 11 is rockets, 12 is cells
	/*
		ITEM		New %		Old %
		shells		40%			41.66%
		spikes		30%			33.33%
		rockets		20%			8.33 %
		cells		10%			8.33 %
	*/
//	r = random() * 20;
	r = random() * 41;
	if (r <= 7) // shells
	{
		item.classname = "item_shells";
		if (is_big)
		{
			setmodel (item, "maps/b_shell1.bsp");
			item.cnt_horde = 40;
			item.message = "large box";
		}
		else
		{
			setmodel (item, "maps/b_shell0.bsp");
			item.cnt_horde = 20;
			item.message = "small box";
		}
		item.weapon = 1;
		item.netname = "shell";	
	}
	else if (r <= 14) // spikes
	{
		
		item.classname = "item_spikes";
		if (is_big)
		{
			setmodel (item, "maps/b_nail1.bsp");
			item.cnt_horde = 50;
			item.message = "large box";
		}
		else
		{
			setmodel (item, "maps/b_nail0.bsp");
			item.cnt_horde = 25;
			item.message = "small box";
		}
		item.weapon = 2;
		item.netname = "nail";				
	}
	else if (r <= 21) // rockets
	{
	
		item.classname = "item_rockets";
		if (is_big)
		{
			setmodel (item, "maps/b_rock1.bsp");
			item.cnt_horde = 10;
			item.message = "large box";
		}
		else
		{
			setmodel (item, "maps/b_rock0.bsp");
			item.cnt_horde = 5;
			item.message = "small box";
		}
		item.weapon = 3;
		item.netname = "rocket";		
	}
	else if (r <= 28)
	{
		item.classname = "item_lava_spikes";
		if (is_big)
		{
			setmodel (item, "maps/b_lnail1.bsp");
			item.cnt_horde = 50;
			item.message = "large box";
		}
		else
		{
			setmodel (item, "maps/b_lnail0.bsp");
			item.cnt_horde = 25;
			item.message = "small box";
		}
		item.weapon = 5;
		item.netname = "lava nail";	
	}
	else if (r <= 35)
	{
		item.classname = "item_multi_rockets";
		if (is_big)
		{
			setmodel (item, "maps/b_mrock1.bsp");
			item.cnt_horde = 10;
			item.message = "large box";
		}
		else
		{
			setmodel (item, "maps/b_mrock0.bsp");
			item.cnt_horde = 5;
			item.message = "small box";
		}
		item.weapon = 6;
		item.netname = "multi-rocket";	
	}	
	else if (r <= 38)
	{
		item.classname = "item_plasma";
		if (is_big)
		{
			setmodel (item, "maps/b_plas1.bsp");
			item.cnt_horde = 12;
			item.message = "large box";
		}
		else
		{
			setmodel (item, "maps/b_plas1.bsp");
			item.cnt_horde = 6;
			item.message = "small box";
		}
		item.weapon = 7;
		item.netname = "plasma";	
	}	
	else // cells
	{
		
		item.classname = "item_cells";
		if (is_big)
		{
			setmodel (item, "maps/b_batt1.bsp");
			item.cnt_horde = 12;
			item.message = "large box";
		}
		else
		{
			setmodel (item, "maps/b_batt0.bsp");
			item.cnt_horde = 6;
			item.message = "small box";
		}
		item.weapon = 4;
		item.netname = "cell";		
	}
	setorigin (item, pos + '0 0 1');
	setsize (item, '0 0 0', '32 32 56');
	item.owner = self;
	self.wait = 1;
	item.movetype = MOVETYPE_TOSS;
	item.solid = SOLID_TRIGGER;
	item.flags = FL_ITEM;
	item.touch = horde_ammo_touch;
		
	spawn_tfog_silent(pos + '0 0 8'); // added aug30
		
	//item.think = PlaceItem;
	//item.nextthink = time + 0.1;
};

void(entity item, vector pos) Health_Spawn_Roll_Assist =
{
	local float r = random() * 8;
	
	if (r < 5) // rotten health
	{
		item.classname = "item_health";
		item.touch = horde_health_touch;
		setmodel (item, "maps/b_bh10.bsp");
		item.noise = "items/r_item1.wav";
//		item.healamount = 15;
		item.healtype = 0;
		setsize (item, '0 0 0', '32 32 56');
//		pos -= '16 16 0';
	}
	else if (r < 7) // regular health
	{
		item.classname = "item_health";
		item.touch = horde_health_touch;
		setmodel (item, "maps/b_bh25.bsp");
		item.noise = "items/health1.wav";
		item.healamount = 25;
		item.healtype = 1;
		setsize (item, '0 0 0', '32 32 56');
		pos -= '16 16 0';
	}
	else // mega health
	{
		item.classname = "item_health";
		item.touch = horde_health_touch;
		setmodel (item, "maps/b_bh100.bsp");
		item.noise = "items/r_item2.wav";
//		item.healamount = 100;
		item.healtype = 2;
		setsize (item, '0 0 0', '32 32 56');
		pos -= '16 16 0';
	}		
};

void(entity item) Armor_Spawn_Roll_Assist =
{
	local float r = random() * 6;
	
	if (r < 3)
	{
		item.classname = "item_armor1";
		item.touch = horde_armor_touch;
//		item.armortype = 0.3;
//		item.armorvalue = 100;
		setmodel (item, "progs/armor.mdl");
		item.skin = 0;
		setsize (item, '-16 -16 0', '16 16 56');
	}			
	else if (r < 5)
	{
		item.classname = "item_armor2";
		item.touch = horde_armor_touch;
//		item.armortype = 0.3;
//		item.armorvalue = 100;
		setmodel (item, "progs/armor.mdl");
		item.skin = 1;
		setsize (item, '-16 -16 0', '16 16 56');
	}			
	else
	{
		item.classname = "item_armorInv";
		item.touch = horde_armor_touch;
//		item.armortype = 0.3;
//		item.armorvalue = 100;
		setmodel (item, "progs/armor.mdl");
		item.skin = 2;
		setsize (item, '-16 -16 0', '16 16 56');
	}	
};

void() SpawnItem =
{
	local entity item = spawn();
	local vector pos = self.origin; // set to origin, then offset as needed
	local float r;
		
	if (gameworld == APOTHEOSIS)
	{
		if (!spawnme) return;
		
		r = random() * 4;
		if (r < 3) Health_Spawn_Roll_Assist (item, pos);
		else Armor_Spawn_Roll_Assist (item);
	}
	else
	{
		r = random() * 6;
		if (r < 3) // rotten health
		{
			item.classname = "item_health";
			item.touch = horde_health_touch;
			setmodel (item, "maps/b_bh10.bsp");
			item.noise = "items/r_item1.wav";
//			item.healamount = 15;
			item.healtype = 0;
			setsize (item, '0 0 0', '32 32 56');
		     // pos = pos - '16 16 0';
		}
		if (r < 5) // regular health
		{
			item.classname = "item_health";
			item.touch = horde_health_touch;
			setmodel (item, "maps/b_bh25.bsp");
			item.noise = "items/health1.wav";
			item.healamount = 25;
			item.healtype = 1;
			setsize (item, '0 0 0', '32 32 56');
			pos -= '16 16 0';
		}
		else // armor
		{
			item.classname = "item_armor1";
			item.touch = horde_armor_touch;
//			item.armortype = 0.3;
//			item.armorvalue = 100;
			setmodel (item, "progs/armor.mdl");
			item.skin = 0;
			setsize (item, '-16 -16 0', '16 16 56');
		}
	}

	setorigin (item, pos + '0 0 1');
	item.owner = self;
	self.wait = TRUE;	
	item.movetype = MOVETYPE_TOSS;
	item.solid = SOLID_TRIGGER;
	item.flags = FL_ITEM;
	//item.think = PlaceItem;
	//item.nextthink = time + 0.1;
	spawn_tfog_silent(pos + '0 0 8'); // added aug30
};

/* Spawn Key
A key should spawn after every boss wave.

*/
void(float is_gold) SpawnKey =
{
	local entity item = spawn();	
	if (is_gold)
	{
		item.items = IT_KEY2;
		
		// set model and sound based on worldtype
		if (world.worldtype == WORLDTYPE_METAL)
		{
			item.netname = "gold runekey";
			item.noise = "misc/runekey.wav";
			setmodel (item, "progs/m_g_key.mdl");
			centerprint_all ("A Gold Runekey appears...\n");
		}
		else if (world.worldtype == WORLDTYPE_BASE)
		{
			item.netname = "gold keycard";
			item.noise = "misc/basekey.wav";
			setmodel (item, "progs/b_g_key.mdl");
			centerprint_all ("A Gold Keycard appears...\n");
		}
		else // assume medieval
		{
			item.netname = "gold key";
			item.noise = "misc/medkey.wav";
			setmodel (item, "progs/w_g_key.mdl");
			centerprint_all ("A Gold Key appears...\n");
		}
	}
	else
	{
		item.items = IT_KEY1;		
		// set model and sound based on worldtype
		if (world.worldtype == WORLDTYPE_METAL)
		{
			item.netname = "silver runekey";
			item.noise = "misc/runekey.wav";
			setmodel (item, "progs/m_s_key.mdl");
			centerprint_all ("A Silver Runekey appears...\n");
		}
		else if (world.worldtype == WORLDTYPE_BASE)
		{
			item.netname = "silver keycard";
			item.noise = "misc/basekey.wav";
			setmodel (item, "progs/b_s_key.mdl");
			centerprint_all ("A Silver Keycard appears...\n");
		}
		else // assume medieval
		{
			item.netname = "silver key";
			item.noise = "misc/medkey.wav";
			setmodel (item, "progs/w_s_key.mdl");
			centerprint_all ("A Silver Key appears...\n");
		}

	}
	//item.noise = "misc/medkey.wav";
	setsize (item, '-16 -16 -25', '16 16 32');
	item.touch = horde_key_touch;
	//item.think = PlaceItem;
	//item.nextthink = time + 0.2;
	item.target = "horde_manager"; // when used, retrigger the horde manager
	item.flags = FL_ITEM;		// make extra wide
	//item.flags = item.flags & FL_NOBOTS; // AY 11 Nov 2021 so bots can't get keys
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setorigin (item, self.origin + '0 0 32');
	item.velocity = '0 0 255';
	
	// AY Feb22, 2022, rune keys shouldn't have light effects on them
	if (world.worldtype != WORLDTYPE_METAL) item.effects = EF_BRIGHTLIGHT;
	
	//dprint("     spawned key\n");
	spawn_tfog (item.origin);
	key_spawned = 1;
};

void() SpawnGoldKey = {SpawnKey (1);};
	
void() SpawnSilverKey = {SpawnKey (0);};

// Function get a key given the current wave
// Wave 3 should return a key with spawnflag "KEY_FIRST"
// Wave 6 should return a key with spawnflag "KEY_SECOND"
// Wave 9 should return a key with spawnflag "KEY_THIRD"
// Wave 9+ should return a key with spawnflag "KEY_FOURTH_PLUS"
// If a key with the correct spawnflag isn't found, return any key
void() SpawnWave2;
void() GetKey =
{
	local entity t = find (world, classname, "info_horde_key");
	local entity l = t; // save ref for later
		
	// check if any keys exist
	if (t == world)
	{
		dprint("ERROR: No info_horde_key!\n");
		// continue as if player got the key
		self.think = Countdown;
		if (gameworld == APOTHEOSIS) self.nextthink = time + 0.1;
		else self.nextthink = time + 4;
		return;
	}
	
	while (t != world)
	{
		if (self.wave <= 3) // looking for KEY_FIRST
		{
			if (t.spawnflags & KEY_FIRST)
			{
				t.think = SpawnSilverKey;
				t.nextthink = time;
				return;
			}
		}
		else if (self.wave <= 6) // looking for KEY_SECOND
		{
			if (t.spawnflags & KEY_SECOND)
			{
				t.think = SpawnSilverKey;
				t.nextthink = time;
				return;
			}
		}
		else if (self.wave <= 9) // looking for KEY_THIRD
		{
			if (t.spawnflags & KEY_THIRD)
			{
				t.think = SpawnGoldKey;
				t.nextthink = time;
				return;
			}
		}
		else // looking for KEY_FOURTH_PLUS
		{
			// check next key
			if (t.spawnflags & KEY_FOURTH_PLUS)
			{
				t.think = SpawnSilverKey;
				t.nextthink = time;
				return;
			}
		}
		t = find (t, classname, "info_horde_key");
	}
	
	// didn't find key with matching spawnflag, return any key
	dprint ("didn't find key with matching spawnflag. Return last: ");
	dprint (l.classname);
	
	if (self.wave == 9) l.think = SpawnGoldKey;
	else l.think = SpawnSilverKey;
	l.nextthink = time;
};


//============================================================================
/* 
SpawnSquad2

Yoder FEB02 2022
*/
void(string name, vector org, vector temp_angles) SpawnSquad2 =
{
	if (name == "3 grunts")
	{
		if (skill > 0)
		{
			SpawnMonster("grunt", org + '0 -40 0', temp_angles);
			SpawnMonster("grunt", org + '40 40 0', temp_angles);
			SpawnMonster("grunt", org + '-40 40 0', temp_angles);
		}
		else
		{
			SpawnMonster("grunt", org + '-40 0 0', temp_angles);
			SpawnMonster("grunt", org + '40 0 0', temp_angles);
		}
	}
	else if (name == "2 grunts, 1 dog")
	{
		SpawnMonster("dog", org + '44 0 0', temp_angles);
		SpawnMonster("grunt", org + '-40 -40 0', temp_angles);
		SpawnMonster("grunt", org + '-40 40 0', temp_angles);
	}
	else if (name == "2 dogs")
	{
		if (skill > 0)
		{
			SpawnMonster("dog", org + '-0 -44 0', temp_angles);
			SpawnMonster("dog", org + '0 44 0', temp_angles);
		}
		else
		{	
			SpawnMonster("dog", org + '-0 -44 0', temp_angles);
		}
	}
	else if (name == "1 enforcer")
	{
		SpawnMonster("enforcer", org + '0 0 0', temp_angles);
	}
	else if (name == "2 enforcers")
	{
		if (skill > 0)
		{
			SpawnMonster("enforcer", org + '40 0 0', temp_angles);
			SpawnMonster("enforcer", org + '-40 0 0', temp_angles);	
		}
		else
			SpawnMonster("enforcer", org + '0 0 0', temp_angles);
	}
	else if (name == "1 ogre")
	{
		SpawnMonster("ogre", org + '0 0 0', temp_angles);
	}
	else if (name == "2 knights")
	{
		if (skill > 0)
		{
			SpawnMonster("knight", org + '40 0 0', temp_angles);
			SpawnMonster("knight", org + '-40 0 0', temp_angles);
		}
		else
		{
			SpawnMonster("knight", org + '40 0 0', temp_angles);
		}
			
	}
	else if (name == "2 zombies")
	{
		SpawnMonster("zombie", org + '40 0 0', temp_angles);
		SpawnMonster("zombie", org + '-40 0 0', temp_angles);
	}
	else if (name == "1 wizard")
		SpawnMonster("wizard", org + '0 0 0', temp_angles);
	else if (name == "2 hellknights")
	{
		if (skill > 0)
		{
			SpawnMonster("hellknight", org + '0 40 0', temp_angles);
			SpawnMonster("hellknight", org + '0 -40 0', temp_angles);
		}
		else
		{
			SpawnMonster("hellknight", org + '0 40 0', temp_angles);
		}
	}
	else if (name == "2 knights, 1 hellknight")
	{
		SpawnMonster("hellknight", org + '40 0 0', temp_angles);
		SpawnMonster("knight", org + '-40 40 0', temp_angles);
		SpawnMonster("knight", org + '-40 -40 0', temp_angles);
	}
	else if (name == "3 wizards")
	{
		if (skill > 0)
		{
			SpawnMonster("wizard", org + '40 40 40', temp_angles);
			SpawnMonster("wizard", org + '-40 40 40', temp_angles);
			SpawnMonster("wizard", org + '-40 -40 40', temp_angles);
		}
		else
		{
			SpawnMonster("wizard", org + '40 40 40', temp_angles);
			SpawnMonster("wizard", org + '-40 40 40', temp_angles);
		}
	}
	else if (name == "shambler")
		SpawnMonster("shambler", org, temp_angles);
	else if (name == "double demon")
	{
		if (skill >= 3 && random() > 0.8)
		{
			// double shambler
			SpawnMonster("shambler", org + '40 40 0', temp_angles);
			SpawnMonster("shambler", org + '-40 -40 0', temp_angles);
		}
		else if (skill >= 1)
		{
			SpawnMonster("demon", org + '40 40 0', temp_angles);
			SpawnMonster("demon", org + '-40 -40 0', temp_angles);
		}
		else
		{
			SpawnMonster("demon", org, temp_angles);
		}
	}
	else if (name == "1 spawn")
	{
		SpawnMonster("spawn", org + '0 0 0', temp_angles);
	}
	else if (name == "3 spawns")
	{
		if (skill > 1)
		{
			SpawnMonster("spawn", org + '40 40 0', temp_angles);
			SpawnMonster("spawn", org + '-40 40 0', temp_angles);
			SpawnMonster("spawn", org + '-40 -40 0', temp_angles);	
		}
		else
		{
			SpawnMonster("spawn", org + '40 40 0', temp_angles);
			SpawnMonster("spawn", org + '-40 40 0', temp_angles);
		}			
	}	
	else if (name == "shalrath")
		SpawnMonster("shalrath", org, temp_angles);
	// HIPNOTIC ----------------------------------------------------------
	else if (name == "1 scourge")
		SpawnMonster("scourge", org, temp_angles);
	else if (name == "double scourge")
	{
		if (skill >= 1)
		{
			SpawnMonster("scourge", org + '40 40 0', temp_angles);
			SpawnMonster("scourge", org + '-40 -40 0', temp_angles);
		}
		else
		{
			SpawnMonster("scourge", org, temp_angles);
		}
	}
	else if (name == "2 grunts, 1 scourge")
	{
		SpawnMonster("scourge", org + '40 0 0', temp_angles);
		SpawnMonster("grunt", org + '-40 40 0', temp_angles);
		SpawnMonster("grunt", org + '-40 -40 0', temp_angles);
	}
	else if (name == "2 gremlins")
	{
		if (skill > 1)
		{
			SpawnMonster("gremlin", org + '-40 0 0', temp_angles);
			SpawnMonster("gremlin", org + '40 0 0', temp_angles);
		}
		else
		{
			SpawnMonster("gremlin", org, temp_angles);
		}
	}
	else if (name == "3 gremlins")
	{
		if (skill > 1) // gremlins like to spawn more gremlins, so this can get a bit much
		{
			SpawnMonster("gremlin", org + '0 -40 0', temp_angles);
			SpawnMonster("gremlin", org + '40 40 0', temp_angles);
			SpawnMonster("gremlin", org + '-40 40 0', temp_angles);
		}
		else
		{
			SpawnMonster("gremlin", org + '-40 0 0', temp_angles);
			SpawnMonster("gremlin", org + '40 0 0', temp_angles);
		}
	}
	else if (name == "1 spike mine")
		SpawnMonster("spike_mine", org + '0 0 0', temp_angles);	
	else if (name == "3 spike mines")
	{
		if (skill > 1)
		{
			SpawnMonster("spike_mine", org + '40 40 40', temp_angles);
			SpawnMonster("spike_mine", org + '-40 40 40', temp_angles);
			SpawnMonster("spike_mine", org + '-40 -40 40', temp_angles);	
		}
		else
		{
			SpawnMonster("spike_mine", org + '0 0 0', temp_angles);	
		}
	}	
	else if (name == "5 spike mines")
	{
		if (skill > 1)
		{
			SpawnMonster("spike_mine", org + '40 40 40', temp_angles);
			SpawnMonster("spike_mine", org + '-40 40 40', temp_angles);
			SpawnMonster("spike_mine", org + '-40 -40 40', temp_angles);
			SpawnMonster("spike_mine", org + '-120 -120 40', temp_angles);
			SpawnMonster("spike_mine", org + '-180 -180 40', temp_angles);	
		}
		else
		{
			SpawnMonster("spike_mine", org + '40 40 40', temp_angles);
			SpawnMonster("spike_mine", org + '-40 40 40', temp_angles);
			SpawnMonster("spike_mine", org + '-40 -40 40', temp_angles);	
		}
	}	
	// ROGUE -------------------------------------------------------------
/*	else if (name == "2 swords")
	{
		SpawnMonster("sword", org + '-40 0 0', temp_angles);
		SpawnMonster("sword", org + '40 0 0', temp_angles);
	}
*/
	else if (name == "1 death spawn")
	{
		SpawnMonster("death_spawn", org + '0 0 0', temp_angles);
	}
	else if (name == "3 death spawns")
	{
		if (skill > 1)
		{
			SpawnMonster("death_spawn", org + '40 40 0', temp_angles);
			SpawnMonster("death_spawn", org + '-40 40 0', temp_angles);
			SpawnMonster("death_spawn", org + '-40 -40 0', temp_angles);	
		}
		else
		{
			SpawnMonster("death_spawn", org + '40 40 0', temp_angles);
			SpawnMonster("death_spawn", org + '-40 40 0', temp_angles);
		}			
	}		
	else if (name == "1 ogre boss")
	{
		SpawnMonster("ogre_boss", org + '0 0 0', temp_angles);
	}
	else if (name == "mummy")
	{
		SpawnMonster("mummy", org, temp_angles);
	}
	else if (name == "morph")
	{
		SpawnMonster("morph", org, temp_angles);
	}
	else if (name == "wrath")
	{
		SpawnMonster("wrath", org, temp_angles);
	}
	else if (name == "2 wraths")
	{
		if (skill >= 1)
		{
			SpawnMonster("wrath", org + '40 40 0', temp_angles);
			SpawnMonster("wrath", org + '-40 -40 0', temp_angles);
		}
		else
		{
			SpawnMonster("wrath", org, temp_angles);
		}
	}
	else if (name == "super_wrath")
	{
		if (skill >= 1)
		{
			SpawnMonster("super_wrath", org, temp_angles);
		}
		else
		{
			SpawnMonster("wrath", org, temp_angles);
		}
	}
	// -------------------------------------------------------------------
	else dprint("ERROR: unrecognized squad name!\n");
	
	spawn_tfog (org);
};

/*
HordeFindSpawnpoint

Yoder February 2nd 2022
*/
float HORDE_SQUAD_TYPE_NORMAL = 0;
float HORDE_SQUAD_TYPE_RANGED = 1;
float HORDE_SQUAD_TYPE_FLYING = 2;
float HORDE_SQUAD_TYPE_BOSS = 3;

float HORDE_SQUAD_CAT_ERROR = -1;
float HORDE_SQUAD_CAT_FODDER = 0;
float HORDE_SQUAD_CAT_ELITE = 1;
float HORDE_SQUAD_CAT_BOSS = 2;

entity(float squad_type) HordeFindSpawnpoint =
{
	local float spawnpoint, temp_spawncount, loopcount, randomspawn;
	local float temp_spawncount_valid; // how many of the spawn points are valid
	local entity t;
	spawnpoint = 0;
	loopcount = 0;
	string squad_class;
	
	if (squad_type == HORDE_SQUAD_TYPE_BOSS) squad_class = "info_monster_start_boss";
	else if (squad_type == HORDE_SQUAD_TYPE_FLYING) squad_class = "info_monster_start_flying";
	else if (squad_type == HORDE_SQUAD_TYPE_RANGED) squad_class = "info_monster_start_ranged";
	else squad_class = "info_monster_start";
	
	// STEP 1: count all spawns of spawn type
	temp_spawncount = 0;
	temp_spawncount_valid = 0;

	// count the spawnpoints for squad_class
	t = find (world, classname, squad_class);
	while (t)
	{
		temp_spawncount++;
		if ((time > t.wait) && (!(t.spawnflags & START_OFF)) && (!CheckBlockedSpawn(t))) temp_spawncount_valid++;
		t = find (t, classname, squad_class);
	}
	
	// verify against 0 valid spawns
	if (temp_spawncount_valid <= 0)
	{
		if (squad_type == HORDE_SQUAD_TYPE_NORMAL)
		{
			dprint("HordeFindSpawnPoint: FOUND 0 Valid spawns\n");
			return world; // already on fallback option, oops
		}
		else
		{
			squad_type = HORDE_SQUAD_TYPE_NORMAL;
			squad_class = "info_monster_start";
			t = world;
			loopcount = 1;
		}
	}
	
	// count again, but for Normal spawn points?
	if (loopcount)
	{
		temp_spawncount = 0;
		temp_spawncount_valid = 0;
		
		t = find (world, classname, squad_class);
		while (t)
		{
			temp_spawncount++;
			if ((time > t.wait) && (!(t.spawnflags & START_OFF)) && (!CheckBlockedSpawn(t))) temp_spawncount_valid++;
			t = find (t, classname, squad_class);
		}
	}
	
	// verify against 0 valid spawns
	if (temp_spawncount_valid <= 0)
	{
		dprint ("HordeFindSpawnPoint: FOUND 0 Valid spawns after recheck\n");
		return world; // already on fallback option, oops
	}
	
	// pick random spawncount
	loopcount = 0;
	randomspawn = temp_spawncount * random();
	dprint ("randomspawn: "); dprint (ftos(randomspawn));
	dprint (" | whole count: "); dprint (ftos(temp_spawncount));
	dprint (" | valid count: "); dprint (ftos(temp_spawncount_valid)); dprint ("\n");
	t = find (world, classname, squad_class);
	while(t)
	{
		spawnpoint++;
		if (spawnpoint >= randomspawn)
		{
			if (!(t.spawnflags & START_OFF) && (time > t.wait) && (!(CheckBlockedSpawn(t))))
			{
				dprint ("picked spawnpoint: "); dprint (ftos(spawnpoint)); dprint ("\n");
				return t;
			}
		}
		t = find(t, classname, squad_class);
		
		if (!t)
		{
			if (loopcount)
				dprint("something has gone horribly wrong!\n");
			else
			{
				loopcount = 1;
				
				t = find(t, classname, squad_class);
				spawnpoint = 0;
				randomspawn = 0; // allow any valid spawn
			}
		}
	}
	return world;
};
/*
SpawnWave2

Instead of finding a spawn point and then spawning a squad,
decide a squad, and then find a spawn point.
Yoder February 2nd 2022

*/
void() SetHorde;
void() SpawnWave2 =
{
	local entity t, oself; // t is the temp spawn, oself is for temp storage of self
	local float squad_type;
	local string squad_name; // specific squad name
	local float r; // random roll
	local float squad_cat; //
	
	//STEP 1: determine what kind of monster is getting spawned
	if (gameworld == APOTHEOSIS)
	{	
		if (self.army)
		{			
			if (self.fodder > 0)
			{
				r = random() * 4;
				if (r < 1) squad_name = "3 grunts";
				else if (r < 2) squad_name = "2 grunts, 1 dog";
				else if (r < 3.5) squad_name = "2 dogs";
				else
				{
					squad_name = "1 enforcer";
					squad_type = HORDE_SQUAD_TYPE_RANGED;
				}
				squad_cat = HORDE_SQUAD_CAT_FODDER;
			}
			else if (self.elites > 0)
			{
				squad_type = HORDE_SQUAD_TYPE_RANGED; 
				r = random() * 2;
				if (r < 1.5) squad_name = "2 enforcers";
//				else if (r < 1.75) squad_name = "1 spawn";
				else squad_name = "1 scourge"; // HIP
				
				squad_cat = HORDE_SQUAD_CAT_ELITE;
			}
			else if (self.bosses > 0)
			{
				/*r = random();
				if (r < 0.25) squad_name = "3 spawns";
				else*/ squad_name = "double scourge";
				squad_type = HORDE_SQUAD_TYPE_NORMAL;
			}
		}
		else // NON-ARMY
		{
			if (self.fodder > 0)
			{
				r = random() * 10;
				if (r < 2) squad_name = "2 knights";
				else if (r < 4) squad_name = "2 gremlins"; // HIP
				else if (r < 5) squad_name = "2 zombies";
//				else if (r < 6) squad_name = "1 death spawn";
				else if (r < 8)
				{
					squad_name = "1 wizard";
					squad_type = HORDE_SQUAD_TYPE_FLYING;
				}
				// HIPNOTIC ---------------------------------
				else
				{
					squad_name = "1 spike mine";
					squad_type = HORDE_SQUAD_TYPE_FLYING;				
				}
				// ------------------------------------------
//				else squad_name = "2 swords"; // ROGUE
				
				squad_cat = HORDE_SQUAD_CAT_FODDER;
			}
			else if (self.elites > 0)
			{
				r = random() * 10;
				if (r < 1) squad_name = "2 hellknights";
				else if (r < 2) squad_name = "2 knights, 1 hellknight";
				else if (r < 3) squad_name = "3 gremlins"; // HIP
//				else if (r < 4) squad_name = "3 spawns";
				else if (r < 5)
				{
					squad_name = "1 ogre";
					squad_type = HORDE_SQUAD_TYPE_RANGED;
				}
				else if (r < 6)
				{
					squad_name = "3 wizards";
					squad_type = HORDE_SQUAD_TYPE_FLYING;
				}
				// ROGUE -------------------------------------
				else if (r < 7)
				{
					squad_name = "1 ogre boss";
					squad_type = HORDE_SQUAD_TYPE_RANGED;
				}
				else if (r < 8) squad_name = "mummy";
				// HIPNOTIC ----------------------------------
				else if (r < 9)
				{
					squad_name = "3 spike mines";
					squad_type = HORDE_SQUAD_TYPE_FLYING;				
				}
				// -------------------------------------------
				else squad_name = "wrath";
				
				squad_cat = HORDE_SQUAD_CAT_ELITE;
			}
			else if (self.bosses > 0)
			{
				squad_type = HORDE_SQUAD_TYPE_BOSS;
				r = random();
				if (r < 0.1) squad_name = "shambler";
//				else if (r < 0.3) squad_name = "3 spawns";
//				else if (r < 0.4) squad_name = "3 death spawn";
				else if (r < 0.5)
				{
					squad_name = "double demon";
					squad_type = HORDE_SQUAD_TYPE_NORMAL;
				}
				else if (r < 0.6) squad_name = "shalrath";
				// HIPNOTIC ---------------------------------
				else if (r < 0.7)
				{
					squad_name = "5 spike mines";
					squad_type = HORDE_SQUAD_TYPE_FLYING;	
				}				
				// ROGUE ------------------------------------
				else if (r < 0.8) squad_name = "morph";
				else if (r < 0.9) 
				{
					squad_name = "2 wraths";
					squad_type = HORDE_SQUAD_TYPE_NORMAL;
				}			
				else squad_name = "super_wrath";
				// ------------------------------------------		
				squad_cat = HORDE_SQUAD_CAT_BOSS;
			}
		}	
	}
	else
	{
		if (self.army)
		{
			
			if (self.fodder > 0)
			{
				r = random() * 4;
				if (r < 1) squad_name = "3 grunts";
				else if (r < 2) squad_name = "2 grunts, 1 dog";
				else if (r < 3.5) squad_name = "2 dogs";
				else
				{
					squad_name = "1 enforcer";
					squad_type = HORDE_SQUAD_TYPE_RANGED;
				}
				squad_cat = HORDE_SQUAD_CAT_FODDER;
			}
			else if (self.elites > 0)
			{
				squad_type = HORDE_SQUAD_TYPE_RANGED; 
				r = random() * 2;
				if (r < 1.5) squad_name = "2 enforcers";
				else squad_name = "1 scourge"; // HIP
				
				squad_cat = HORDE_SQUAD_CAT_ELITE;
			}
			else if (self.bosses > 0)
			{
				squad_name = "double scourge";
				squad_type = HORDE_SQUAD_TYPE_NORMAL;
			}
		}
		else // NON-ARMY
		{
			if (self.fodder > 0)
			{
				r = random() * 8;
				if (r < 2) squad_name = "2 knights";
				else if (r < 4) squad_name = "2 gremlins"; // HIP
				else if (r < 5) squad_name = "2 zombies";
				else if (r < 7)
				{
					squad_name = "1 wizard";
					squad_type = HORDE_SQUAD_TYPE_FLYING;
				}
				else squad_name = "2 swords"; // ROGUE
				
				squad_cat = HORDE_SQUAD_CAT_FODDER;
			}
			else if (self.elites > 0)
			{
				r = random() * 9;
				if (r < 1) squad_name = "2 hellknights";
				else if (r < 2) squad_name = "2 knights, 1 hellknight";
				else if (r < 3) squad_name = "3 gremlins"; // HIP
				else if (r < 4)
				{
					squad_name = "1 ogre";
					squad_type = HORDE_SQUAD_TYPE_RANGED;
				}
				else if (r < 5)
				{
					squad_name = "3 wizards";
					squad_type = HORDE_SQUAD_TYPE_FLYING;
				}
				// ROGUE -------------------------------------
				else if (r < 6)
				{
					squad_name = "1 ogre boss";
					squad_type = HORDE_SQUAD_TYPE_RANGED;
				}
				else if (r < 8) squad_name = "mummy";
				else squad_name = "wrath";
				
				squad_cat = HORDE_SQUAD_CAT_ELITE;
			}
			else if (self.bosses > 0)
			{
				squad_type = HORDE_SQUAD_TYPE_BOSS;
				r = random();
				if (r < 0.2) squad_name = "shambler";
				else if (r < 0.6)
				{
					squad_name = "double demon";
					squad_type = HORDE_SQUAD_TYPE_NORMAL;
				}
				else if (r < 0.7) squad_name = "shalrath";
				// ROGUE -----------------------------------------------
				else if (r < 0.8) squad_name = "morph";
				else if (r < 0.9) 
				{
					squad_name = "2 wraths";
					squad_type = HORDE_SQUAD_TYPE_NORMAL;
				}
				else squad_name = "super_wrath";
				// -----------------------------------------------------		
				squad_cat = HORDE_SQUAD_CAT_BOSS;
			}
		}
	}
	
	
	//STEP 2: find a spawn point for the squad
	t = HordeFindSpawnpoint(squad_type);
	dprint ("spawnpoint found was: "); dprint (t.classname); dprint ("\n");
	if (t && (squad_cat != HORDE_SQUAD_CAT_ERROR))
	{
		t.wait = time + SPAWN_RESET_TIME; // block spawnpoint from reuse for a duration
		
		// use targets
		oself = self;
		self = t;
		SUB_UseTargets();
		self = oself;
		
		// set angles, just in case
		if (!t.angles) t.angles = '0 0 0';
		
		SpawnSquad2 (squad_name, t.origin, t.angles);
		WriteByte(MSG_ALL, SVC_UPDATESTAT);
		WriteByte(MSG_ALL, 12); // 12 = STAT_TOTALMONSTERS
		WriteLong(MSG_ALL, total_monsters);
		
		if (squad_cat == HORDE_SQUAD_CAT_FODDER) self.fodder--;
		else if (squad_cat == HORDE_SQUAD_CAT_ELITE) self.elites--;
		else if (squad_cat == HORDE_SQUAD_CAT_BOSS) self.bosses--;
		
		if ((self.fodder + self.elites + self.bosses) <= 0) // max spawns hit
		{
			dprint ("wave spawn completed!\n");
			self.wait = 0;
			self.think = Wavecheck;
			self.nextthink = time + 30;
		}
		else
		{
			// normal spawnwave wait time
			self.think = SpawnWave2;
			if (gameworld == APOTHEOSIS) self.nextthink = time + 1;
			else self.nextthink = time + 1 + random() + 1;
		}
	}
	else
	{
		dprint ("no valid spawns, wait a moment\n");
		self.think = SpawnWave2;
		self.nextthink = time + 1;
	}
};

/* SpawnWavePrep
called once at the countdown starts
determines the number of squads by type
also spawns ammo and items
*/
float() SpawnWavePrep =
{
	local entity p, p2, p3;
	local float playercount, playerscalar;
	// Reset Key Spawn
	key_spawned = 0;
	
	// Respawn dead players!
	if (HordeGetPlayersAlive() < 1)
	{
		dprint("WARNING: Last player died at round end, don't start new round!\n");
		return 0;
	}	
	
	// Items
	p = find (world, classname, "info_horde_item");
	while (p)
	{
		if (!p.wait)
		{
			p.think = SpawnItem;
			if (gameworld == APOTHEOSIS) p.nextthink = time + random() * 0.05;
			else p.nextthink = time + random() * 2;
		}
		p = find (p, classname, "info_horde_item");
	}
	
	// Weapons and Ammo (Sleeper: Blocked spawns via infos so they can spawn in prep)
	if (gameworld == APOTHEOSIS)
	{
		p2 = find (world, classname, "info_horde_ammo");
		while (p2)
		{
			if (!p2.wait)
			{
				p2.think = SpawnAmmo;
				if (gameworld == APOTHEOSIS) p2.nextthink = time + random() * 0.05;
				else p2.nextthink = time + random() * 2;
			}
			p2 = find (p2, classname, "info_horde_ammo");
		}
		
		p3 = find (world, classname, "info_horde_weapon");
		while (p3)
		{
			if (!p3.wait)
			{
				p3.think = SpawnWeapon;
				if (gameworld == APOTHEOSIS) p3.nextthink = time + random() * 0.05;
				else p3.nextthink = time + random() * 2;
			}
			p3 = find (p3, classname, "info_horde_weapon");
		}
	}		

	self.wave++;
	dprint("wave ");
	dprint(ftos(self.wave));
	dprint("\n");
	
	// See spreadsheet for notes on squad scaling
	
	// AY FEB07 scaling start wave based on difficulty
	local float temp_wave;
	if (skill >= 3) temp_wave = self.wave + 6;
	else if (skill >= 2) temp_wave = self.wave + 3;
	else temp_wave = self.wave;
	
	// Determine if Army wave
	if ((temp_wave + 2) % 3 == 0) self.army = 1;
	else self.army = 0;
	
	// player scalar
	playercount = HordeGetPlayersAlive();
	if (playercount >= 4) playerscalar = 2;
	else if (playercount >= 3) playerscalar = 1.5;
	else if (playercount >= 2) playerscalar = 1.25;
	else playerscalar = 1;

	if (gameworld == APOTHEOSIS)
	{	
		local float apotheosis_modifier;
		
		if (skill >= 5) apotheosis_modifier = 4;
		else if (skill >= 3) apotheosis_modifier = 3;
		else if (skill >= 2) apotheosis_modifier = 2.5;
		else apotheosis_modifier = 2;
		
		// Boss Count
		if (temp_wave % 3 == 0)
		{
			self.bosses = floor((temp_wave + 1) / 4);
		}
//		else if ((skill > 1) && (!self.army) && (temp_wave > 9))
		else if ((skill > 1) && (temp_wave > 9))
		{
			//AY feb07, some extra spice
			self.bosses = floor((temp_wave + 1) / 8);
		}
		
		// Elite Count
		self.elites = ceil((temp_wave - 1) / 3) - floor(self.bosses / 2);
		self.elites = floor(self.elites * apotheosis_modifier * playerscalar);
		
		// Fodder Count
		self.fodder = (temp_wave + 2) - (self.bosses * 2 + self.elites);
		self.fodder = floor(self.fodder * apotheosis_modifier * playerscalar);
	}
	else
	{	
		// Boss Count
		if (temp_wave % 3 == 0)
		{
			self.bosses = floor((temp_wave+1)/4);
		}
		else if ((skill > 1) && (!self.army) && (temp_wave > 9))
		{
			//AY feb07, some extra spice
			self.bosses = floor((temp_wave+1)/8);
		}
		
		// Elite Count
		self.elites = ceil((temp_wave - 1) / 3) - floor(self.bosses / 2);
		self.elites = floor(self.elites * playerscalar);
		
		// Fodder Count
		self.fodder = (temp_wave + 2) - (self.bosses * 2 + self.elites);
		self.fodder = floor(self.fodder * playerscalar);
	}	
	
	// Trigger map entities
	local entity stemp;
	p = find (world, targetname, self.target);
	while (p)
	{
		stemp = self;
		self = p;
		if (self.use != SUB_Null)
		{
			if (self.use) self.use ();
		}
		self = stemp;
		p = find (p, targetname, self.target);
	}

	self.wait = 1;
	return TRUE;
}

void() Countdown4 = 
{
	if (gameworld != APOTHEOSIS)
	{
		if (self.wave % 3 == 0) centerprint_all ("BOSS WAVE!\n");
		else centerprint_all ("Fight!\n");
	}
	SpawnWave2();
	if (gameworld != APOTHEOSIS) sound (self, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NONE);
};
void() Countdown3 =
{
	if (gameworld != APOTHEOSIS) centerprint_all("1");
	self.think = Countdown4;
	if (gameworld == APOTHEOSIS) self.nextthink = time + 0.1;
	else self.nextthink = time + 1;
	if (gameworld != APOTHEOSIS) sound (self, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NONE);
};
void() Countdown2 =
{
	if (gameworld != APOTHEOSIS) centerprint_all ("2");
	self.think = Countdown3;
	if (gameworld == APOTHEOSIS) self.nextthink = time + 0.1;
	else self.nextthink = time + 1;
	if (gameworld != APOTHEOSIS) sound (self, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NONE);
};
void() Countdown =
{
	if (!SpawnWavePrep()) return;
	
	if (gameworld != APOTHEOSIS) centerprint_all ("3");
	self.think = Countdown2;
	if (gameworld == APOTHEOSIS) self.nextthink = time + 0.1;
	else self.nextthink = time + 1;	
	if (gameworld != APOTHEOSIS) sound (self, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NONE);
};

void() RespawnAllPlayers =
{
	local entity p, oself;
	p = find (world, classname, "player");
	while (p)
	{
		if (p.deadflag > 0) 
		{
			oself = self;
			self = p;
			horde_respawn_teammate();
			self = oself;
			//p.think = horde_respawn_teammate;
			//p.nextthink = time; // next frame
		}
		p = find (p, classname, "player");
	}
};

/*
When each enemy spawned by the horde manager dies, they trigger self.owner.use, which is wavecheck.
Wavecheck sees if all spawned monsters are dead, so it can determine if it needs to start a new wave.
*/
void() Wavecheck =
{
	if (self.wait) return; // still in the process of spawning monsters, don't wavecheck
		
	self.think = Wavecheck;
	self.nextthink = time + 10;
		
	dprint ("\n===============\n");
	dprint ("checking kills: ");
	dprint (ftos(killed_monsters));
	dprint (" of ");
	dprint (ftos(total_monsters));
	dprint ("\n");
	
	// debug checking last monster position
	if (killed_monsters + 3 >= total_monsters)
	{
		local entity t;
		t = find (world, category, CATEGORY_MONSTER);
		while(t)
		{
			if (t.health > 0)
			{
				dprint ("Position of monster: ");
				dprint (t.classname);
				dprint (" : ");
				dprint (vtos(t.origin));
				dprint ("\n");
			}
			else
				t.category = string_null;
			t = find (t, category, CATEGORY_MONSTER);
		}
	}
	
	// Early exit for kill count
	if ((self.wave % 3 == 0) || (self.wave < 3)) // Be exact?
	{
		dprint ("check monsters killed as boss wave\n");
		if (HordeGetMonstersAlive() > 0) return; // testing the new way
	     // if (killed_monsters < total_monsters) return;
	}
	else
	{
		dprint("check monsters killed as any other wave\n");
		if (HordeGetMonstersAlive() > 5) return;
	     // if (killed_monsters < (total_monsters -5)) return;
	}
	
	// Made it this far, means wave completed successfully
	dprint ("wavecheck looks good! Respawning players\n");
	RespawnAllPlayers();
	
	self.wait = 1;
	self.think = Countdown;
	
	if (gameworld == APOTHEOSIS) self.nextthink = time; // Sleeper: There is no keys to pick up in Apotheosis Abyss. Also, eliminate any short breathers to the player. No rest for the living.
	else
	{
		if (self.wave % 3 == 0) // it was a boss wave
		{
			if (!key_spawned) GetKey(); // key was already spawned, don't spawn another yet!

			self.nextthink = time + 20; // in case the players are slow to find the key
		}
		else self.nextthink = time;
	}
	dprint ("wavecheck now completed.\n");
};
void() horde_manager;
// setup horde rules
void() SetHorde =
{
	if (gameworld == APOTHEOSIS)
	{
		if (self.spawnflags & 1) 
		{
			local entity ent = find (world, targetname, "sleeper_light2");
			while (ent)
			{
				if (!ent.spawnflags) 
				{
					self.spawnflags = 0;
					spawnme = 1;
					dprint ("TEST: It is September 23, 2021!\n"); // yoder sanity test
					self.think = Countdown;
					self.nextthink = time + 0.1;					
				}
				else
				{
					spawnme = 0;
					self.think = horde_manager;
					self.nextthink = time + 0.1;	
				}				
				ent = find (ent, targetname, "sleeper_light2");
			}
			return;
		}
	}
	else
	{
		dprint ("TEST: It is September 23, 2021!\n");
		self.think = Countdown;
		self.nextthink = time + 1;
	}
}

// define entity 
void() horde_manager =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	// AY, Dec06 2021, auto set horde cvar
	if (!cvar("horde") && !deathmatch) cvar_set("horde", "1");		
	// end AY
		
	PrecacheMonsters();
	
	horde_ent = self; // set global reference to the horde manager
	
	if (!self.target) self.target = "horde_event"; // default name
	if (!self.targetname) self.targetname = "horde_manager";	
	self.think = SetHorde;

//	if (gameworld == APOTHEOSIS) self.nextthink = time + 15;
	if (gameworld == APOTHEOSIS) self.nextthink = time;
	else self.nextthink = time + HORDE_START_DELAY;
	
	self.use = Wavecheck;
	
	self.wait = 1; // waiting before next wave?
	self.delay = 9; // max number of  squads to spawn in a wave
	self.wave = 0;
	
     // if (!horde) horde = 1; // in case CVAR isn't already set	
};

void() PowerupFade =
{
	if (self.alpha > 0)
	{
		self.alpha -= 0.25 * frametime;
		self.nextthink = time; // think next frame
	}
	else remove (self);
}

void() horde_powerup_think =
{
	if (self.velocity_z < 0)
	{
		dprint("WARNING: Powerup fell out of world. Remove\n");
		remove(self);
	}
	else
	{
		self.alpha = 1;
		self.think = PowerupFade;
		self.nextthink = time;
	}
};

void() horde_spawn_powerup =
{
	local float rand;

	if (!powerup_chance) powerup_chance = DEFAULT_POWERUP_CHANCE;
	
	if (random() < powerup_chance) // "if(1)" to guarantee powerup drop
	{
		dprint ("powerup chance was: ");
		dprint (ftos(powerup_chance));
		dprint ("\n");
		
		powerup_chance = DEFAULT_POWERUP_CHANCE;
		
		local entity powerup = spawn();
		setorigin (powerup, self.origin + '0 0 0');

		//setsize (powerup, '-16 -16 -24', '16 16 32');
		powerup.flags = FL_ITEM;
		powerup.solid = SOLID_TRIGGER;
		powerup.movetype = MOVETYPE_BOUNCE;
		powerup.velocity = '0 0 300';
		
		//powerup.velocity_x = crandom() * 64;
		//powerup.velocity_y = crandom() * 64;
		powerup.touch = powerup_touch;
		powerup.think = horde_powerup_think;
		powerup.nextthink = time + 10;
		
		rand = random();
		// HIP -------------------------------------------------
/*
		if (rand < 0.05) // spawn horn of conjuring
		{
			powerup.noise = "hipitems/horn.wav";
			setmodel(powerup, "progs/horn.mdl");
			powerup.netname = "Horn of Conjuring";
			powerup.touch = horn_touch;
			powerup.classname = "item_hornofconjuring";
		}

	 else*/ if (rand < 0.15) // spawn empathy shields
		{
			powerup.noise = "hipitems/empathy.wav";
			setmodel(powerup, "progs/empathy.mdl");
			powerup.netname = "Empathy Shields";
			powerup.expansionitems = HIP_IT_EMPATHY_SHIELDS;
			powerup.touch = hip_powerup_touch;
			powerup.classname = "item_artifact_empathy_shields";
		}
		// ROGUE -----------------------------------------------
		else if (rand < 0.25) // spawn power shield
		{
			powerup.noise = "shield/pickup.wav";
			setmodel(powerup, "progs/shield.mdl");
			powerup.netname = "Power Shield";
			powerup.expansionitems = DOE_SHIELD;
			powerup.touch = newitems_touch;
			powerup.classname = "item_powerup_shield";
		}
		else if (rand < 0.3) // spawn anti-gravity belt
		{
			powerup.noise = "belt/pickup.wav";
			setmodel(powerup, "progs/beltup.mdl");
			powerup.netname = "Anti-Grav Belt";
			powerup.expansionitems = DOE_ANTIGRAV;
			powerup.touch = newitems_touch;
			powerup.classname = "item_powerup_belt";
		}
		// -----------------------------------------------------
		else if (random() < 0.6) // spawn pentagram (invulnerability)
		{
			powerup.noise = "items/protect.wav";
			setmodel(powerup, "progs/invulner.mdl");
			powerup.netname = "Pentagram of Protection";
			powerup.items = IT_INVULNERABILITY;
			powerup.classname = "item_artifact_invulnerability";
		}
		else // spawn quad damage
		{
			powerup.noise = "items/damage.wav";
			setmodel(powerup, "progs/quaddama.mdl");
			powerup.netname = "Quad Damage";
			powerup.items = IT_QUAD;
			powerup.classname = "item_artifact_super_damage";
		}
		//powerup.effects = EF_DIMLIGHT;
		
		setsize (powerup, '-12 -12 -12', '12 12 12');
	}
	else powerup_chance += POWERUP_CHANCE_GAIN;
};

// remote wavecheck
// this is to trigger a wavecheck from outside of horde mode
void() remote_wavecheck =
{
	if (!horde_ent || (intermission_running))
	{
		dprint ("no wavecheck.");
		if (!horde_ent) dprint (" no horde ent found.");
		if (intermission_running) dprint (" intermission running.");
		dprint ("\n\n");
		return;
	}
	dprint ("remote wavecheck from: ");
	dprint (self.classname);
	dprint ("\n");
	local entity stemp = self; // the entity that is triggering the remote wavecheck
	self = horde_ent;
	self.use();
	
	self = stemp; // set self back to whatever it was
};

/* CheckBlockedSpawn
AY Feb24, 2022
Checks the horde spawn against all living players
Returns true/false if spawn is blocked.
*/
float(entity spawnpoint) CheckBlockedSpawn =
{
	local float blocked = FALSE;
	local vector p_mins, p_maxs, s_mins, s_maxs;
	
	if (spawnpoint.spawnflags & SKIP_BLOCK_CHECK) return FALSE;
	
	local entity p = find(world, classname, "player");
	while (p && !blocked)
	{
		if ((p.health > 0) && (p.deadflag <= 0))
		{
			p_mins = p.origin + p.mins;
			p_maxs = p.origin + p.maxs;
			s_mins = spawnpoint.origin + spawnpoint.mins;
			s_maxs = spawnpoint.origin + spawnpoint.maxs;
				
			if (((p_maxs_x > s_mins_x) && (p_mins_x < s_maxs_x)) && ((p_maxs_y > s_mins_y) && (p_mins_y < s_maxs_y)) && ((p_maxs_y > s_mins_y) && (p_mins_y < s_maxs_y)))
			{
				dprint ("player blocking spawn\n");
				blocked = 1;
			}
		}
		p = find(p, classname, "player");
	}
	return blocked;
};