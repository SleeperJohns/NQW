/*
=================================================
Net QuakeWorld Co-Op: Sleeper Must Die! (Skill 5)
=================================================
*/

/*
This modification's objective is to give Quake a higher difficulty choice by spawning new entities,
such as weapons, enemies, ammo, powerups, armor and health. This modification also puts your skills
(pun intended), to the test. Your weapon discipline to the test. Enemies do make pain sounds, but
they won't react to the it. Also Shamblers have increased explosive weapon resistance from 50% to 
75%. However, Quad eliminates this effect all together so you can still 2 - 3 tap them with Quad 
Rockets. However, I heavily advise against Rockets against Shamblers in the first place, as the
manual for Quake also says so. But don't let me stop you from wasting your ammo. It will become
a consequence in itself when you don't have enough Rockets do deal with zombies at some point. :)

Due to the fact that it is impossible to add skill 5 only entities via an .ent file, 
so we much have to do this the hard way and make spawnsfunctions via QuakeC. Good luck modifying
this stuff, as it may take you a while fitting spawns right. Remember to Use viewpos in console
to get your coordinates. Do make sure if you compile your version take "skill = cvar("skill")"
out of "StartFrame" and put it into "worldspawn". This will make these spawnfunctions work
flawlessly. 	  Have fun, and don't die too much! >:) - Sleeper, Son Of Spyro
*/

/*
============================
Spawnfunction Items

Manually spawn items in maps
============================
*/

// Spawnfunction for Special Items
void(vector pos, vector angle, string clname, float makesound, string msg, void() func) func_SpecialSpawnItem =
{ 	
        entity it = spawn();
                               
        it.origin = pos;
        it.angles = angle;
            
        it.classname = clname; // Mostly for safety
        	                        
	it.message = msg;
	it.special_noise = TRUE;
	it.special_spawned_pickup_sound = makesound;
        
        // Change self to the new entity and initialize it
        entity oldself2 = self;     
        self = it;
        func();     
        self = oldself2; // Revert it back after we're done
};

// Spawnfunction for Weapons
void(vector pos, vector angle, string clname, void() func) func_SpawnWeapon =
{
        entity wep = spawn();
        
        wep.origin = pos;
        wep.angles = angle;
            
        wep.classname = clname; // Mostly for safety	
        
        // Change self to the new entity and initialize it
        entity oldself = self;
        self = wep;
        func();
        self = oldself; // Revert it back after we're done
};

// Spawnfunction for Powerups
void(vector pos, vector angle, string clname, void() func) func_SpawnPowerups =
{
        entity pow = spawn();
        
        pow.origin = pos;
        pow.angles = angle;
            
        pow.classname = clname; // Mostly for safety
          
        // Change self to the new entity and initialize it
        entity oldself = self;
        self = pow;
        func();
        self = oldself; // Revert it back after we're done
};

// Spawnfunction for Armor
void(vector pos, vector angle, string clname, void() func) func_SpawnArmor =
{
        entity ar = spawn();
        
        ar.origin = pos;
        ar.angles = angle;
            
        ar.classname = clname; // Mostly for safety
          
        // Change self to the new entity and initialize it
        entity oldself = self;
        self = ar;
        func();
        self = oldself; // Revert it back after we're done
};

// Spawnfunction for Ammo
void(vector pos, vector angle, string clname, float ammo_type, void() func) func_SpawnAmmo =
{
        entity am = spawn();
        
        am.origin = pos;
        am.angles = angle;
            
        am.classname = clname; // Mostly for safety

	// Changes ammopacks size to large or small.
	am.spawnflags = ammo_type;
                  
        // Change self to the new entity and initialize it
        entity oldself = self;
        self = am;
        func();
        self = oldself; // Revert it back after we're done
};

// Spawnfunction for Health
void(vector pos, vector angle, string clname, float health_type, void() func) func_SpawnHealth =
{
        entity hel = spawn();
        
        hel.origin = pos;
        hel.angles = angle;
            
        hel.classname = clname; // Mostly for safety

	// Changes health to Rotten (Heal by 15), or Unrotten (Heal by 25)
	hel.spawnflags = health_type;
                  
        // Change self to the new entity and initialize it
        entity oldself = self;
        self = hel;
        func();
        self = oldself; // Revert it back after we're done
};

// Spawnfunction for team#_support_rune# (Sleeper: For team#, replace "#" with the number 1 for Team Red or 2 for Team Blue. For rune#, replace "#" with a number from 1 through 4.)
void(vector pos, vector angle, float specify_team, string clname, void() func) func_SpawnInfoRunes =
{
        entity inforune = spawn();
        
        inforune.origin = pos;
        inforune.angles = angle;
            
        inforune.classname = clname; // Mostly for safety
        inforune.team = specify_team; // For choosing a team
          
        // Change self to the new entity and initialize it
        entity oldself = self;
        self = inforune;
        func();
        self = oldself; // Revert it back after we're done
};

// Anything that may be missing in Deathmatch maps by default
void() NQW_SMD_DMItems =
{
	if (world.model == "maps/dm7.bsp")
	{
		func_SpawnPowerups('-5 830 472', '0 0 0', "item_artifact_invulnerability", item_artifact_invulnerability);
		func_SpawnPowerups('1546 -182 663', '0 0 0', "item_artifact_invisibility", item_artifact_invisibility);
		func_SpawnPowerups('1180 666 472', '0 0 0', "item_artifact_super_damage", item_artifact_super_damage);
	}		
};

// Skill 5 Items
void() NQW_SMD_CoopItems =
{
	// Sleeper: Stuff to test.
	if (cvar("developer"))
	{
		if (world.model == "maps/start.bsp")
		{
			func_SpecialSpawnItem('543 675 -40', '0 0 0', "weapon_rocketlauncher", 1, "You found a\nSpecial Spawned Weapon!\n", weapon_rocketlauncher);
		}
	}	
	
	// Item spawnlist for E1M1
	if (world.model == "maps/e1m1.bsp")
	{
		func_SpawnAmmo('445 725 88', '0 0 0', "item_spikes", 0, item_spikes);
		func_SpawnAmmo('-132 600 -224', '0 0 0', "item_spikes", 0, item_spikes);
		func_SpawnAmmo('1198 870 -410', '0 0 0', "item_spikes", 0, item_spikes);
		func_SpawnAmmo('1409 981 -410', '0 0 0', "item_spikes", 0, item_spikes);
		func_SpawnAmmo('1385 532 -256', '0 0 0', "item_spikes", 0, item_spikes);
		func_SpawnAmmo('1385 498 -256', '0 0 0', "item_spikes", 0, item_spikes);
		func_SpawnAmmo('1385 464 -256', '0 0 0', "item_spikes", 0, item_spikes);
		func_SpawnAmmo('1385 430 -256', '0 0 0', "item_spikes", 0, item_spikes);
		func_SpawnAmmo('1419 532 -256', '0 0 0', "item_shells", 0, item_shells);
		func_SpawnAmmo('1419 498 -256', '0 0 0', "item_shells", 0, item_shells);
		func_SpawnAmmo('1419 464 -256', '0 0 0', "item_shells", 0, item_shells);
		func_SpawnAmmo('1419 430 -256', '0 0 0', "item_shells", 0, item_shells);
		func_SpawnAmmo('734 820 -344', '0 45 0', "item_shells", 0, item_shells);
		func_SpawnAmmo('1311 815 -410', '0 0 0', "item_shells", 0, item_shells);
		func_SpawnHealth('656 944 -344', '0 0 0', "item_health", 1, item_health);
		func_SpawnHealth('943 534 -312', '0 0 0', "item_health", 1, item_health);
		func_SpawnHealth('961 728 -344', '0 0 0', "item_health", 1, item_health);
		func_SpawnHealth('860 1078 -248', '0 0 0', "item_health", 1, item_health);
		func_SpawnHealth('530 1870 -168', '0 0 0', "item_health", 1, item_health);
		func_SpawnHealth('-64 1145 -312', '0 0 0', "item_health", 1, item_health);
		func_SpawnHealth('-64 1190 -312', '0 0 0', "item_health", 1, item_health);
		func_SpawnHealth('-64 1235 -312', '0 0 0', "item_health", 1, item_health);
		func_SpawnHealth('547 1193 -312', '0 0 0', "item_health", 1, item_health);
		func_SpawnHealth('-145 845 -200', '0 0 0', "item_health", 1, item_health);
		func_SpawnArmor('972 1098 -248', '0 0 0', "item_armor2", item_armor2);
		func_SpecialSpawnItem('-120 557 -200', '0 0 0', "weapon_nailgun", 0, "\"Take this, and Good luck!\"\n- Sleeper, Son Of Spyro", weapon_nailgun);
		// Co-Op specific items
		if (coop)
		{	
			func_SpecialSpawnItem('1210 430 -256', '0 0 0', "weapon_rocketlauncher", 0, "You are such a cheater...\n", weapon_rocketlauncher); // Sleeper: Just there to tease the player.
			func_SpecialSpawnItem('1312 550 -64', '0 0 0', "item_artifact_invulnerability", 0, "You are such a cheater...\n", item_artifact_invulnerability); // Sleeper: Just there to tease the player.
		}
	}
	// Item spawnlist for E1M2
	if (world.model == "maps/e1m2.bsp")
	{
		func_SpawnHealth('1135 1275 344', '0 0 0', "item_health", 0, item_health);
		func_SpawnHealth('1195 940 80', '0 0 0', "item_health", 0, item_health);
		func_SpawnHealth('-112 344 664', '0 0 0', "item_health", 2, item_health); // Sleeper: If you can grab it, you can have it.
		func_SpawnAmmo('1312 1648 392', '0 0 0', "item_spikes", 1, item_spikes);
		func_SpawnArmor('1776 964 80', '0 0 0', "item_armor1", item_armor1);
		func_SpawnArmor('-305 185 790', '0 0 0', "item_armorInv", item_armorInv); // Sleeper: If you can grab it, you can have it.
		func_SpawnWeapon('1869 1290 344', '0 0 0', "weapon_lightning", weapon_lightning); // Sleeper: Just there to tease the player. Not suppose to have this in Episode 1 anyway.
		func_SpawnWeapon('-95 620 320', '0 0 0', "weapon_grenadelauncher", weapon_grenadelauncher);
	}
	// Item spawnlist for E1M3
	if (world.model == "maps/e1m3.bsp")
	{
		func_SpawnHealth('544 -1465 -128', '0 0 0', "item_health", 1, item_health);
		func_SpawnHealth('1313 446 176', '0 0 0', "item_health", 0, item_health);
		func_SpawnHealth('1313 412 176', '0 0 0', "item_health", 0, item_health);
		func_SpawnAmmo('332 -1443 -128', '0 0 0', "item_shells", 1, item_shells);
		func_SpawnAmmo('1376 378 176', '0 0 0', "item_shells", 1, item_shells);
		func_SpawnAmmo('1376 446 176', '0 0 0', "item_spikes", 1, item_spikes);
		func_SpawnAmmo('1376 412 176', '0 0 0', "item_spikes", 1, item_spikes);
		func_SpawnAmmo('-1065 -782 -72', '0 0 0', "item_spikes", 0, item_spikes);
		func_SpawnAmmo('-1065 -818 -72', '0 0 0', "item_spikes", 0, item_spikes);
		func_SpawnAmmo('-1069 -80 -72', '0 0 0', "item_spikes", 0, item_spikes);
		func_SpawnAmmo('-1242 -23 -72', '0 0 0', "item_spikes", 0, item_spikes);
		func_SpawnAmmo('1376 480 176', '0 0 0', "item_rockets", 1, item_rockets);
		func_SpawnAmmo('1376 496 176', '0 0 0', "item_rockets", 1, item_rockets);
		func_SpawnArmor('1216 -64 -162', '0 0 0', "item_armor1", item_armor1);
		func_SpecialSpawnItem('-537 -1801 346', '0 0 0', "item_armor2", 1, "You found old man Wugga's armor!\n", item_armor2);
		func_SpawnArmor('1351 256 568', '0 0 0', "item_armor2", item_armor2);
		func_SpawnArmor('1347 987 802', '0 0 0', "item_armor2", item_armor2);
		func_SpecialSpawnItem('1608 -17 80', '0 0 0', "item_artifact_super_damage", 1, "Oooh, shiny Quad!\n", item_artifact_super_damage);
		// Co-Op specific items
		if (coop)
		{
			func_SpecialSpawnItem('-961 -1857 72', '0 0 0', "weapon_supershotgun", 1, "A gift from a Devilwalker!\n", weapon_supershotgun);
			func_SpecialSpawnItem('1416 -150 111', '0 0 0', "weapon_supernailgun", 0, "You can't hide from me!\n", weapon_supernailgun);
		}
	}
	// Item spawnlist for E1M4
	if (world.model == "maps/e1m4.bsp")
	{
		func_SpawnHealth('814 1782 944', '0 0 0', "item_health", 0, item_health);
		func_SpawnArmor('-255 1900 1390', '0 0 0', "item_armor1", item_armor1);
		func_SpawnArmor('700 1363 692', '0 0 0', "item_armor1", item_armor1);	
		func_SpawnArmor('1400 1352 884', '0 0 0', "item_armor1", item_armor1);	
		func_SpawnAmmo('1180 1500 884', '0 0 0', "item_spikes", 1, item_spikes);
		func_SpawnAmmo('1180 1455 884', '0 0 0', "item_spikes", 1, item_spikes);
		func_SpecialSpawnItem('696 -123 1544', '0 0 0', "item_artifact_super_damage", 1, "You found a secret OwO!\n", item_artifact_super_damage);
		if (coop)
		{
			func_SpecialSpawnItem('709 2448 1232', '0 0 0', "weapon_rocketlauncher", 1, "How the fuck did you get up here?\n", weapon_rocketlauncher); // Sleeper: If you can grab it, you can have it.
			func_SpawnWeapon('-114 1913 1384', '0 0 0', "weapon_supershotgun", weapon_supershotgun);
			func_SpawnWeapon('-415 1913 1384', '0 0 0', "weapon_nailgun", weapon_nailgun);	
		}		
	}
	// Item spawnlist for E1M5
	if (world.model == "maps/e1m5.bsp")
	{
		func_SpawnHealth('-716 175 171', '0 0 0', "item_health", 0, item_health);
		func_SpawnHealth('-684 217 171', '0 0 0', "item_health", 0, item_health);
		func_SpawnHealth('-1065 512 111', '0 0 0', "item_health", 1, item_health);
		func_SpawnArmor('-576 443 422', '0 0 0', "item_armor2", item_armor2);
		func_SpawnArmor('-832 963 615', '0 0 0', "item_armorInv", item_armorInv);
		func_SpawnHealth('-1063 860 342', '0 0 0', "item_health", 2, item_health);
	}
	// Item spawnlist for E1M6
	if (world.model == "maps/e1m6.bsp")
	{
		func_SpawnArmor('-133 831 -215', '0 0 0', "item_armor2", item_armor2);
	}
	// Item spawnlist for E1M7
	if (world.model == "maps/e1m7.bsp")
	{
		// Nothing to spawn in this map yet.
	}			
	// Item spawnlist for E1M8
	if (world.model == "maps/e1m8.bsp")
	{
		func_SpawnPowerups('704 -640 -712', '0 0 0', "item_artifact_super_damage", item_artifact_super_damage);
	}	
};

/*
===============================
Spawnfunction Monsters

Manually spawn monsters in maps
===============================
*/
	
// Spawnfunction for Standing Monsters
void(vector pos, vector angle, string clname, void() func) func_SpawnMonsterIdle =
{
        entity mon = spawn();
        
        mon.origin = pos;
        mon.angles = angle;
            
        mon.classname = clname; // Mostly for safety
       
	// Sleeper: Let the player know this skill means business.
        float normal;
        self.cnt = 0;
        entity attacker, targ;      
        local float take;
        if ((cvar("skill") == 5) && (attacker.flags & FL_MONSTER) && (targ.flags & FL_CLIENT)) // Copied from combat.qc just to be safe that the enemies do double damage.
		take *= 2;
	mon.attack_finished = time + normal;
                   
        // Change self to the new entity and initialize it
        entity oldself = self;
        self = mon;
        func();
        self = oldself; // Revert it back after we're done
};

// Spawnfunction for Walking Monsters
void(vector pos, vector angle, string x, string clname, void() func) func_SpawnMonsterWalk =
{
        entity mon2 = spawn();
        
        mon2.origin = pos;
        mon2.angles = angle;
              
        mon2.classname = clname; // Mostly for safety
        mon2.target = x; // Name of the entity
            
	// Sleeper: Let the player know this skill means business.
        float normal;
        self.cnt = 0;
        entity attacker, targ;      
        local float take;
        if ((cvar("skill") == 5) && (attacker.flags & FL_MONSTER) && (targ.flags & FL_CLIENT)) // Copied from combat.qc just to be safe that the enemies still do double damage
		take *= 2;
	mon2.attack_finished = time + normal;
		            
        // Change self to the new entity and initialize it
        entity oldself2 = self;
        self = mon2;
        func();
        self = oldself2; // Revert it back after we're done
};

// Spawnfunction for Path Corners
void(vector pos, vector angle, string x, string y, void() func) func_SpawnPathCorner =
{
	entity path = spawn(); // Not sure if this correct but.. huh?
	
	path.origin = pos;
	path.angles = angle;
	
	path.classname = "path_corner";
	path.target = x; // Name of the entity
	path.targetname = y; // Name of the Path Corner
		
        // Change self to the new entity and initialize it
        entity oldself = self;
        self = path;
        func();
        self = oldself; // Revert it back after we're done
};

/* // Sleeper: Just a point of reference for how Path Corners can be done, so I don't forget.
if (world.model == "maps/[MAPNAME GOES HERE].bsp") // Specify a map, and put these in NQW_SMD_PathCorners.
{
	func_SpawnPathCorner('545 650 -30', '0 0 0', "t2", "t1", path_corner); // Give a Path Corner a named "targetname" (i.e.: t2), Use a named "target" of a Monster (i.e.: t1)
	func_SpawnPathCorner('545 800 -30', '0 0 0', "t3", "t2", path_corner); // Replace Path Corner's named "targetname" with the Monster's named "target" and repeat until looping back.
	func_SpawnPathCorner('650 800 -30', '0 0 0', "t4", "t3", path_corner); // Monster hits his destination, turn him back around to make a loop
	func_SpawnPathCorner('545 800 -30', '0 0 0', "t5", "t4", path_corner); // When looping back, make sure to mirror the coordinates
	func_SpawnPathCorner('545 650 -30', '0 0 0', "t1", "t5", path_corner); // At the final corner, go back to the original named "target" (t1) by setting t1 as a named "targetname" and t5 as the named "target".  	
}
*/
/*
if (world.model == "maps/[MAPNAME GOES HERE].bsp") // Specify a map, and put into NQW_SMD_Mobs.
{
	func_SpawnMonsterWalk('545 650 -30', '0 90 0', "t1", "monster_army", monster_army); // Give a monster a named "target" (t1).
}
*/

// Sleeper: Borrowed to spawn any monster entity.
void() monster_army;
void() monster_fish;
void() monster_wizard;
void() monster_dog;
void() monster_tarbaby;
void() monster_ogre;
void() monster_enforcer;
void() monster_knight;
void() monster_hell_knight;
void() monster_shambler;
void() monster_zombie;
void() monster_demon1;
void() monster_shalrath;
void() monster_spikemine;
void() monster_scourge;

// iD Software's Cut Enemies. Yeah, we're using them for skill 5, soon though.
void() monster_vomit; // "Uber Zombie" Vomitus
void() monster_vomitus; // "Spawn Mother" Vomitus
// void() monster_original dragon;   // Not yet.
// void() monster_serpent; 	     // Not yet.
// void() monster_axe_ogre; 	     // Not yet.

// Sleeper: Spawn Skill 5 Path Corners
void() NQW_SMD_PathCorners =
{
	// Path Corner spawnlist for E1M1
	if (world.model == "maps/e1m1.bsp")
	{
		func_SpawnPathCorner('130 1400 -200', '0 0 0', "nqw_001b", "nqw_001a", path_corner);
		func_SpawnPathCorner('130 1000 -200', '0 0 0', "nqw_001a", "nqw_001b", path_corner);
		func_SpawnPathCorner('687 941 -315', '0 0 0', "nqw_002b", "nqw_002a", path_corner);
		func_SpawnPathCorner('868 792 -315', '0 0 0', "nqw_002a", "nqw_002b", path_corner);
		func_SpawnPathCorner('480 100 25', '0 0 0', "nqw_003b", "nqw_003a", path_corner);
		func_SpawnPathCorner('480 573 25', '0 0 0', "nqw_003c", "nqw_003b", path_corner);
		func_SpawnPathCorner('61 573 25', '0 0 0', "nqw_003d", "nqw_003c", path_corner);
		func_SpawnPathCorner('70 573 25', '0 0 0', "nqw_003e", "nqw_003d", path_corner);
		func_SpawnPathCorner('115 573 25', '0 0 0', "nqw_003f", "nqw_003e", path_corner);
		func_SpawnPathCorner('-322 2280 -136', '0 0 0', "nqw_004b", "nqw_004a", path_corner);
		func_SpawnPathCorner('-337 2563 -120', '0 0 0', "nqw_004c", "nqw_004b", path_corner);
		func_SpawnPathCorner('-219 2694 -88', '0 0 0', "nqw_004d", "nqw_004c", path_corner);
		func_SpawnPathCorner('-45 2763 -72', '0 0 0', "nqw_004e", "nqw_004d", path_corner);
		func_SpawnPathCorner('-219 2694 -88', '0 0 0', "nqw_004f", "nqw_004e", path_corner);
		func_SpawnPathCorner('-337 2563 -120', '0 0 0', "nqw_004g", "nqw_004f", path_corner);
		func_SpawnPathCorner('-322 2280 -136', '0 0 0', "nqw_004a", "nqw_004g", path_corner);
		func_SpawnPathCorner('353 650 72', '0 0 0', "nqw_005b", "nqw_005a", path_corner);
		func_SpawnPathCorner('353 740 72', '0 0 0', "nqw_005c", "nqw_005b", path_corner);
		func_SpawnPathCorner('582 740 104', '0 0 0', "nqw_005d", "nqw_005c", path_corner);
		func_SpawnPathCorner('353 740 72', '0 0 0', "nqw_005e", "nqw_005d", path_corner);
		func_SpawnPathCorner('353 650 72', '0 0 0', "nqw_005a", "nqw_005e", path_corner);
	}
	// Path Corner spawnlist for E1M2
	if (world.model == "maps/e1m2.bsp")
	{
		func_SpawnPathCorner('1307 227 468', '0 0 0', "nqw_001b", "nqw_001a", path_corner);
		func_SpawnPathCorner('930 223 468', '0 0 0', "nqw_001a", "nqw_001b", path_corner);
		func_SpawnPathCorner('430 -154 334', '0 0 0', "nqw_002b", "nqw_002a", path_corner);
		func_SpawnPathCorner('430 343 334', '0 0 0', "nqw_002a", "nqw_002b", path_corner);
		func_SpawnPathCorner('1802 314 133', '0 0 0', "nqw_003b", "nqw_003a", path_corner);
		func_SpawnPathCorner('1341 301 133', '0 0 0', "nqw_003a", "nqw_003b", path_corner);
		func_SpawnPathCorner('1106 94 133', '0 0 0', "nqw_004b", "nqw_004a", path_corner);
		func_SpawnPathCorner('1106 592 133', '0 0 0', "nqw_004a", "nqw_004b", path_corner);
		func_SpawnPathCorner('710 325 130', '0 0 0', "nqw_005b", "nqw_005a", path_corner);
		func_SpawnPathCorner('414 325 133', '0 0 0', "nqw_005a", "nqw_005b", path_corner);
	}
	// Path Corner spawnlist for E1M3
	if (world.model == "maps/e1m3.bsp")
	{
		func_SpawnPathCorner('195 -1173 -128', '0 0 0', "nqw_001b", "nqw_001a", path_corner);
		func_SpawnPathCorner('645 -1173 -128', '0 0 0', "nqw_001a", "nqw_001b", path_corner);
		func_SpawnPathCorner('234 -922 -328', '0 0 0', "nqw_002b", "nqw_002a", path_corner);
		func_SpawnPathCorner('78 -918 -328', '0 0 0', "nqw_002a", "nqw_002b", path_corner);
		func_SpawnPathCorner('1599 700 560', '0 0 0', "nqw_003b", "nqw_003a", path_corner);
		func_SpawnPathCorner('1166 700 560', '0 0 0', "nqw_003a", "nqw_003b", path_corner);
		func_SpawnPathCorner('1599 850 560', '0 0 0', "nqw_004b", "nqw_004a", path_corner);
		func_SpawnPathCorner('1166 850 560', '0 0 0', "nqw_004a", "nqw_004b", path_corner);
		func_SpawnPathCorner('1614 -398 -136', '0 0 0', "nqw_005b", "nqw_005a", path_corner);
		func_SpawnPathCorner('1605 36 -136', '0 0 0', "nqw_005a", "nqw_005b", path_corner);
		func_SpawnPathCorner('968 -225 28', '0 0 0', "nqw_006b", "nqw_006a", path_corner);
		func_SpawnPathCorner('1355 -225 28', '0 0 0', "nqw_006a", "nqw_006b", path_corner);
		func_SpawnPathCorner('1355 -490 28', '0 0 0', "nqw_007b", "nqw_007a", path_corner);
		func_SpawnPathCorner('968 -490 28', '0 0 0', "nqw_007a", "nqw_007b", path_corner);
	}
	// Path Corner spawnlist for E1M4
	if (world.model == "maps/e1m4.bsp")
	{
		func_SpawnPathCorner('-319 1578 888', '0 0 0', "nqw_001b", "nqw_001a", path_corner);
		func_SpawnPathCorner('-175 1578 888', '0 0 0', "nqw_001a", "nqw_001b", path_corner);
		func_SpawnPathCorner('-175 1700 888', '0 0 0', "nqw_002b", "nqw_002a", path_corner);
		func_SpawnPathCorner('-319 1700 888', '0 0 0', "nqw_002a", "nqw_002b", path_corner);
		func_SpawnPathCorner('450 1030 965', '0 0 0', "nqw_002a", "nqw_002b", path_corner);
		func_SpawnPathCorner('995 1030 965', '0 0 0', "nqw_002b", "nqw_002a", path_corner);		
		func_SpawnPathCorner('708 1370 350', '0 0 0', "nqw_003a", "nqw_003b", path_corner);
		func_SpawnPathCorner('711 1083 344', '0 0 0', "nqw_003b", "nqw_003a", path_corner);
		func_SpawnPathCorner('404 1045 965', '0 0 0', "nqw_004a", "nqw_004b", path_corner);
		func_SpawnPathCorner('995 1030 965', '0 0 0', "nqw_004b", "nqw_004a", path_corner);
		func_SpawnPathCorner('708 1794 344', '0 0 0', "nqw_005a", "nqw_005b", path_corner);
		func_SpawnPathCorner('708 2076 344', '0 0 0', "nqw_005b", "nqw_005a", path_corner);
		func_SpawnPathCorner('915 857 344', '0 0 0', "nqw_006b", "nqw_006a", path_corner);
		func_SpawnPathCorner('433 857 344', '0 0 0', "nqw_006c", "nqw_006b", path_corner);
		func_SpawnPathCorner('433 1604 344', '0 0 0', "nqw_006d", "nqw_006c", path_corner);
		func_SpawnPathCorner('921 1604 344', '0 0 0', "nqw_006e", "nqw_006d", path_corner);
		func_SpawnPathCorner('915 857 344', '0 0 0', "nqw_006a", "nqw_006e", path_corner);
		func_SpawnPathCorner('433 1356 344', '0 0 0', "nqw_006c", "nqw_007a", path_corner);
		func_SpawnPathCorner('910 1356 344', '0 0 0', "nqw_006a", "nqw_008a", path_corner);
		func_SpawnPathCorner('704 2436 944', '0 0 0', "nqw_009b", "nqw_009a", path_corner);
		func_SpawnPathCorner('704 2702 944', '0 0 0', "nqw_009a", "nqw_009b", path_corner);
		func_SpawnPathCorner('484 1358 800', '0 0 0', "nqw_010a", "nqw_010b", path_corner);
		func_SpawnPathCorner('957 1360 800', '0 0 0', "nqw_010b", "nqw_010a", path_corner);		
		func_SpawnPathCorner('441 850 572', '0 0 0', "nqw_011a", "nqw_011b", path_corner);
		func_SpawnPathCorner('963 850 572', '0 0 0', "nqw_011b", "nqw_011a", path_corner);		
		func_SpawnPathCorner('975 1602 437', '0 0 0', "nqw_012a", "nqw_012b", path_corner);
		func_SpawnPathCorner('387 1588 437', '0 0 0', "nqw_012b", "nqw_012a", path_corner);	
		func_SpawnPathCorner('423 197 896', '0 0 0', "nqw_013b", "nqw_013a", path_corner);
		func_SpawnPathCorner('1039 212 896', '0 0 0', "nqw_013a", "nqw_013b", path_corner);
	}
	// Path Corner spawnlist for E1M5
	if (world.model == "maps/e1m5.bsp")
	{
		func_SpawnPathCorner('-319 1736 200', '0 0 0', "nqw_001b", "nqw_001a", path_corner);
		func_SpawnPathCorner('-319 1504 200', '0 0 0', "nqw_001c", "nqw_001b", path_corner);
		func_SpawnPathCorner('-431 1410 200', '0 0 0', "nqw_001d", "nqw_001c", path_corner);
		func_SpawnPathCorner('-319 1504 200', '0 0 0', "nqw_001e", "nqw_001d", path_corner);
		func_SpawnPathCorner('-319 1736 200', '0 0 0', "nqw_001a", "nqw_001e", path_corner);		
		func_SpawnPathCorner('-205 308 15', '0 0 0', "nqw_002b", "nqw_002a", path_corner);
		func_SpawnPathCorner('-905 308 15', '0 0 0', "nqw_002a", "nqw_002b", path_corner);		
		func_SpawnPathCorner('53 314 15', '0 0 0', "nqw_003b", "nqw_003a", path_corner);
		func_SpawnPathCorner('53 631 15', '0 0 0', "nqw_003a", "nqw_003b", path_corner);
	}
	// Path Corner spawnlist for E1M7
	if (world.model == "maps/e1m7.bsp")
	{
		// Nothing to spawn in this map yet.
	}	
	// Path Corner spawnlist for E1M8
	if (world.model == "maps/e1m8.bsp")
	{
		func_SpawnPathCorner('900 525 176', '0 0 0', "nqw_001b", "nqw_001a", path_corner);
		func_SpawnPathCorner('175 525 176', '0 0 0', "nqw_001a", "nqw_001b", path_corner);	
		func_SpawnPathCorner('330 706 24', '0 0 0', "nqw_002b", "nqw_002a", path_corner);
		func_SpawnPathCorner('906 706 24', '0 0 0', "nqw_002a", "nqw_002b", path_corner);	
		func_SpawnPathCorner('1260 -265 -552', '0 0 0', "nqw_003b", "nqw_003a", path_corner);
		func_SpawnPathCorner('950 -265 -552', '0 0 0', "nqw_003c", "nqw_003b", path_corner);
		func_SpawnPathCorner('1260 -265 -552', '0 0 0', "nqw_003d", "nqw_003c", path_corner);
		func_SpawnPathCorner('1260 -105 -552', '0 0 0', "nqw_003a", "nqw_003d", path_corner);
	}	
};

// Sleeper: Spawn Skill 5 Mobs
void() NQW_SMD_Mobs =
{		
	// Mob spawnlist for E1M1
	if (world.model == "maps/e1m1.bsp")
	{
		// Standing Monsters
		func_SpawnMonsterIdle('343 70 40', '0 0 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('-214 1666 -200', '0 317 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('-290 1566 -200', '0 354 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('-165 1581 -200', '0 301 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('-75 2245 40', '0 90 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('-20 1805 -40', '0 30 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('250 1675 -200', '0 270 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('350 2210 -105', '0 270 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('10 1675 -200', '0 270 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('595 1640 -200', '0 210 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('500 1655 -200', '0 235 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('480 1555 -200', '0 220 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('675 1685 -200', '0 215 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('335 1380 -200', '0 270 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('15 1380 -200', '0 270 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('260 935 -200', '0 220 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('605 1945 -105', '0 180 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('135 2080 -105', '0 270 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('245 1805 -40', '0 130 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('545 2301 -105', '0 270 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('700 2480 -60', '0 360 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('-385 2080 -135', '0 345 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('730 2125 -380', '0 0 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('910 1962 -380', '0 180 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('765 1960 -380', '0 0 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('920 2125 -380', '0 180 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('1190 570 -88', '0 60 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('1440 610 -190', '0 130 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('-415 1680 -200', '0 330 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('1225 940 -256', '0 90 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('175 1520 -200', '0 270 0', "monster_dog", monster_dog);
		func_SpawnMonsterIdle('-60 1380 -200', '0 270 0', "monster_dog", monster_dog);
		func_SpawnMonsterIdle('270 1380 -200', '0 270 0', "monster_dog", monster_dog);
		func_SpawnMonsterIdle('1260 1060 -224', '0 90 0', "monster_dog", monster_dog);
		func_SpawnMonsterIdle('1370 1060 -224', '0 90 0', "monster_dog", monster_dog);
		func_SpawnMonsterIdle('241 768 24', '0 131 0', "monster_enforcer", monster_enforcer);
		func_SpawnMonsterIdle('166 701 24', '0 130 0', "monster_enforcer", monster_enforcer);
		func_SpawnMonsterIdle('1260 845 -256', '0 90 0', "monster_enforcer", monster_enforcer);
		func_SpawnMonsterIdle('1375 845 -256', '0 90 0', "monster_enforcer", monster_enforcer);
		func_SpawnMonsterIdle('1340 1460 -405', '0 90 0', "monster_enforcer", monster_enforcer);
		func_SpawnMonsterIdle('1280 1460 -405', '0 90 0', "monster_enforcer", monster_enforcer);
		func_SpawnMonsterIdle('1310 550 -224', '0 90 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('1420 490 -110', '0 90 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('1200 490 -110', '0 90 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('960 695 -320', '0 120 0', "monster_fish", monster_fish);
		func_SpawnMonsterIdle('580 950 -315', '0 40 0', "monster_fish", monster_fish);
		func_SpawnMonsterIdle('1225 1045 -370', '0 310 0', "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterIdle('1410 1045 -370', '0 225 0', "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterIdle('-360 2914 -56', '0 360 0', "monster_tarbaby", monster_tarbaby);
		// Walking Monsters	
		func_SpawnMonsterWalk('130 1400 -200', '0 270 0', "nqw_001a", "monster_army", monster_army);
		func_SpawnMonsterWalk('687 941 -315', '0 320 0', "nqw_002a", "monster_fish", monster_fish);
		func_SpawnMonsterWalk('480 90 25', '0 90 0', "nqw_003a", "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterWalk('-322 2244 -136', '0 90 0', "nqw_004a", "monster_army", monster_army);
		func_SpawnMonsterWalk('353 660 72', '0 90 0', "nqw_005a", "monster_army", monster_army);	
	}
	// Mob spawnlist for E1M2
	if (world.model == "maps/e1m2.bsp")
	{
		// Standing Monsters
		func_SpawnMonsterIdle('455 -740 432', '0 270 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('400 -740 432', '0 270 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('345 -740 432', '0 270 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('1839 1295 345', '0 180 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('1145 1291 345', '0 360 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('-25 10 490', '0 90 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('-165 10 490', '0 90 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('1565 482 320', '0 270 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('1000 -40 320', '0 0 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('588 -1272 432', '0 90 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('635 -1112 432', '0 180 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('528 -992 432', '0 0 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('1620 1453 200', '0 270 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('1360 1453 432', '0 270 0', "monster_army", monster_army);
		func_SpawnMonsterIdle('1498 1066 111', '0 90 0', "monster_fish", monster_fish);
		func_SpawnMonsterIdle('1103 1153 100', '0 360 0', "monster_fish", monster_fish);
		func_SpawnMonsterIdle('1630 460 133', '0 310 0', "monster_fish", monster_fish);
		func_SpawnMonsterIdle('960 530 130', '0 40 0', "monster_fish", monster_fish);
		func_SpawnMonsterIdle('1420 105 130', '0 140 0', "monster_fish", monster_fish);
		func_SpawnMonsterIdle('772 115 130', '0 35 0', "monster_fish", monster_fish);
		func_SpawnMonsterIdle('659 815 341', '0 315 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('-308 300 523', '0 315 0', "monster_wizard", monster_wizard);	
		func_SpawnMonsterIdle('144 300 523', '0 210 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('1704 1362 393', '0 270 0', "monster_wizard", monster_wizard);	
		func_SpawnMonsterIdle('1287 1362 393', '0 270 0', "monster_wizard", monster_wizard);	
		func_SpawnMonsterIdle('1918 85 377', '0 90 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('1370 -1175 520', '0 90 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('1245 -1175 520', '0 90 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('1135 -1175 520', '0 90 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('1585 -565 395', '0 0 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('1505 -385 475', '0 180 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('1600 -705 515', '0 0 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('1495 875 390', '0 270 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('1525 -911 615', '0 180 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('1440 -128 465', '0 180 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('-98 -67 470', '0 270 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('578 -561 485', '0 270 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('850 -1100 440', '0 90 0', "monster_dog", monster_dog);
		func_SpawnMonsterIdle('915 -1100 440', '0 90 0', "monster_dog", monster_dog);
		func_SpawnMonsterIdle('-420 -153 320', '0 90 0', "monster_dog", monster_dog);
		func_SpawnMonsterIdle('1342 1293 200', '0 270 0', "monster_dog", monster_dog);	
		func_SpawnMonsterIdle('1670 1290 200', '0 270 0', "monster_dog", monster_dog);
		func_SpawnMonsterIdle('-322 -695 480', '0 130 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('-160 -75 665', '0 90 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('-20 -75 665', '0 90 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('1785 395 315', '0 180 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('-488 -10 665', '0 35 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('-488 -104 665', '0 35 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('315 -10 665', '0 135 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('315 -104 665', '0 135 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('1472 -683 312', '0 90 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('1157 -1100 440', '0 90 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('1226 -1118 440', '0 125 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('1275 -1120 440', '0 50 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('1455 -1124 440', '0 132 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('1446 -1184 440', '0 120 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('1346 -1169 440', '0 90 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('1173 -1183 440', '0 90 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('1110 -1169 440', '0 90 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('1053 -1192 440', '0 45 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('1149 -1137 440', '0 90 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('1386 -1097 440', '0 90 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('1299 -1174 440', '0 75 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('1398 -1180 440', '0 95 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('1109 -1131 440', '0 65 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('1192 -1150 440', '0 100 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('1355 -1136 440', '0 90 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('1191 -1109 440', '0 85 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('1422 -1106 440', '0 90 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('1248 -1160 440', '0 90 0', "monster_hell_knight", monster_hell_knight);
		func_SpawnMonsterIdle('-697 -495 480', '0 0 0', "monster_shambler", monster_shambler);
		func_SpawnMonsterIdle('885 -615 216', '0 90 0', "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterIdle('1192 1628 264', '0 360 0', "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterIdle('793 -912 440', '0 360 0', "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterIdle('1734 -565 280', '0 0 0', "monster_vomit", monster_vomit);
		// Walking Monsters
		func_SpawnMonsterWalk('1300 225 468', '0 180 0', "nqw_001a", "monster_wizard", monster_wizard);	
		func_SpawnMonsterWalk('430 -154 334', '0 90 0', "nqw_002a", "monster_wizard", monster_wizard);	
		func_SpawnMonsterWalk('1802 314 133', '0 180 0', "nqw_003a", "monster_fish", monster_fish);
		func_SpawnMonsterWalk('1106 94 133', '0 180 0', "nqw_004a", "monster_fish", monster_fish);
		func_SpawnMonsterWalk('710 325 130', '0 180 0', "nqw_005a", "monster_fish", monster_fish);				
	}
	// Mob spawnlist for E1M3
	if (world.model == "maps/e1m3.bsp")
	{
		// Standing Monsters
		func_SpawnMonsterIdle('-475 -1714 112', '0 270 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('-120 -1863 112', '0 180 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('-120 -1813 112', '0 180 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('-120 -1763 112', '0 180 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('-120 -1713 112', '0 180 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('-1261 -506 -440', '0 0 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('-917 -45 -456', '0 320 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('-866 -90 -456', '0 320 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('324 -1075 -128', '0 320 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('400 -1075 -128', '0 270 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('710 -1075 -128', '0 215 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('645 -1075 -128', '0 270 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('515 -1115 -128', '0 270 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('-1473 -330 -368', '0 144 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('-1075 -847 -368', '0 270 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('-1055 82 -368', '0 130 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('-1593 -610 -336', '0 145 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('-1593 -510 -336', '0 224 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('30 -506 -360', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('90 -506 -360', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('460 -486 -288', '0 215 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('550 -486 -288', '0 135 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('600 -486 -288', '0 135 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('750 -486 -288', '0 135 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('460 -209 -288', '0 195 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('630 -209 -288', '0 195 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('735 -209 -288', '0 195 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('810 -275 -288', '0 180 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('810 -450 -288', '0 180 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('418 -638 -288', '0 130 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('353 -504 -288', '0 270 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('265 -821 -328', '0 235 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('-100 -898 -328', '0 50 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('-156 -675 -328', '0 245 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('1548 76 -136', '0 285 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('1419 117 -136', '0 0 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('1270 150 -136', '0 0 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('667 -1071 44', '0 270 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('-1000 20 80', '0 90 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('-253 -999 80', '0 270 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('-550 -1245 72', '0 360 0', "monster_demon1", monster_demon1);
		func_SpawnMonsterIdle('1118 296 560', '0 35 0', "monster_demon1", monster_demon1);
		func_SpawnMonsterIdle('1601 286 560', '0 125 0', "monster_demon1", monster_demon1);
		func_SpawnMonsterIdle('1272 458 -132', '0 315 0', "monster_shambler", monster_shambler);
		func_SpawnMonsterIdle('1456 458 -132', '0 225 0', "monster_shambler", monster_shambler);
		func_SpawnMonsterIdle('-450 -161 -72', '0 180 0', "monster_shambler", monster_shambler);
		func_SpawnMonsterIdle('-852 -1210 -8', '0 0 0', "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterIdle('-852 -1285 -8', '0 360 0', "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterIdle('361 -1342 -128', '0 90 0', "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterIdle('1386 -517 -184', '0 180 0', "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterIdle('1681 125 -136', '0 238 0', "monster_vomit", monster_vomit);
		func_SpawnMonsterIdle('-1741 -551 -336', '0 0 0', "monster_vomit", monster_vomit);
		func_SpawnMonsterIdle('383 131 -184', '0 233 0', "monster_vomit", monster_vomit);
		func_SpawnMonsterIdle('230 -1012 -128', '0 270 0', "monster_vomit", monster_vomit);
		func_SpawnMonsterIdle('239 -1235 -40', '0 148 0', "monster_vomit", monster_vomit);
		func_SpawnMonsterIdle('522 -750 -103', '0 270 0', "monster_vomit", monster_vomit);
		func_SpawnMonsterIdle('68 -164 -184', '0 270 0', "monster_vomitus", monster_vomitus);
		// Co-Op specific enemies
		if (coop)
		{
			func_SpawnMonsterIdle('1280 360 176', '0 48 0', "monster_shalrath", monster_shalrath);
			func_SpawnMonsterIdle('1430 356 176', '0 140 0', "monster_shalrath", monster_shalrath);
		}
		else
		{
			func_SpawnMonsterIdle('1371 342 176', '0 90 0', "monster_shalrath", monster_shalrath);
		}	
		// Walking Monsters
		func_SpawnMonsterWalk('195 -1173 -128', '0 0 0', "nqw_001a", "monster_zombie", monster_zombie);
		func_SpawnMonsterWalk('234 -922 -328', '0 0 0', "nqw_002a", "monster_zombie", monster_zombie);
		func_SpawnMonsterWalk('1599 700 560', '0 180 0', "nqw_003a", "monster_demon1", monster_demon1);
		func_SpawnMonsterWalk('1166 850 560', '0 180 0', "nqw_004a", "monster_demon1", monster_demon1);
		func_SpawnMonsterWalk('1614 -147 -136', '0 270 0', "nqw_005a", "monster_ogre", monster_ogre);
		func_SpawnMonsterWalk('970 -225 28', '0 0 0', "nqw_006a", "monster_wizard", monster_wizard);
		func_SpawnMonsterWalk('1355 -490 28', '0 180 0', "nqw_007a", "monster_wizard", monster_wizard);
	}
	// Mob spawnlist for E1M4
	if (world.model == "maps/e1m4.bsp")
	{
		// Standing Monsters
		func_SpawnMonsterIdle('836 1310 344', '0 0 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('836 1400 344', '0 0 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('557 1310 344', '0 180 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('557 1400 344', '0 180 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('900 1730 344', '0 300 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('507 1750 344', '0 235 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('336 991 344', '0 0 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('336 1098 344', '0 0 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('1003 793 344', '0 130 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('625 1168 344', '0 0 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('430 2345 344', '0 90 0', "monster_zombie", monster_zombie);		
		func_SpawnMonsterIdle('465 2345 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('465 2310 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('465 2275 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('500 2345 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('500 2310 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('500 2275 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('535 2345 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('535 2310 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('535 2275 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('570 2345 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('570 2310 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('570 2275 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('605 2345 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('605 2310 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('605 2275 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('640 2345 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('640 2310 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('640 2275 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('675 2345 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('675 2310 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('675 2275 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('710 2345 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('710 2310 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('710 2275 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('745 2345 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('745 2310 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('745 2275 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('780 2345 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('780 2310 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('780 2275 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('815 2345 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('815 2310 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('815 2275 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('850 2345 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('850 2310 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('850 2275 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('430 2310 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('430 2275 344', '0 90 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('950 2621 344', '0 270 0', "monster_zombie", monster_zombie);	
		func_SpawnMonsterIdle('1119 1227 344', '0 144 0', "monster_zombie", monster_zombie);
		func_SpawnMonsterIdle('496 2548 536', '0 270 0', "monster_ogre", monster_ogre);	
		func_SpawnMonsterIdle('1101 2483 944', '0 180 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('-225 1570 1370', '0 90 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('513 -578 865', '0 0 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('1207 826 1408', '0 205 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('1020 1585 1067', '0 205 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('340 165 1050', '0 50 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('346 1613 1043', '0 233 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('809 2441 536', '0 180 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('826 2293 536', '0 278 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('578 2834 944', '0 310 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('1031 -262 1160', '0 270 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('925 -732 1128', '0 150 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('925 -410 1128', '0 225 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('1070 -493 1128', '0 180 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('1070 -655 1128', '0 180 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('-254 1799 1176', '0 90 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('340 2334 944', '0 0 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('702 2845 586', '0 270 0', "monster_hell_knight", monster_hell_knight);
		func_SpawnMonsterIdle('831 25 896', '0 90 0', "monster_hell_knight", monster_hell_knight);
		func_SpawnMonsterIdle('570 25 896', '0 90 0', "monster_hell_knight", monster_hell_knight);
		func_SpawnMonsterIdle('815 -151 1507', '0 90 0', "monster_hell_knight", monster_hell_knight);
		func_SpawnMonsterIdle('579 -151 1507', '0 90 0', "monster_hell_knight", monster_hell_knight);	
		func_SpawnMonsterIdle('963 831 800', '0 135 0', "monster_fish", monster_fish);
		func_SpawnMonsterIdle('694 1692 800', '0 270 0', "monster_fish", monster_fish);
		func_SpawnMonsterIdle('1233 1396 785', '0 205 0', "monster_fish", monster_fish);
		func_SpawnMonsterIdle('1233 1344 785', '0 190 0', "monster_fish", monster_fish);
		func_SpawnMonsterIdle('1233 1300 785', '0 180 0', "monster_fish", monster_fish);
		func_SpawnMonsterIdle('1254 1300 666', '0 180 0', "monster_fish", monster_fish);
		func_SpawnMonsterIdle('1254 1344 666', '0 190 0', "monster_fish", monster_fish);
		func_SpawnMonsterIdle('1254 1396 666', '0 205 0', "monster_fish", monster_fish);
		func_SpawnMonsterIdle('73 1532 912', '0 90 0', "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterIdle('319 736 728', '0 90 0', "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterIdle('985 2579 344', '0 270 0', "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterIdle('920 2579 344', '0 270 0', "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterIdle('682 -860 1120', '0 90 0', "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterIdle('682 -290 1120', '0 270 0', "monster_tarbaby", monster_tarbaby);	
		func_SpawnMonsterIdle('1300 1482 884', '0 234 0', "monster_vomit", monster_vomit);
		func_SpawnMonsterIdle('1005 333 896', '0 225 0', "monster_vomit", monster_vomit);
		func_SpawnMonsterIdle('393 421 896', '0 305 0', "monster_vomitus", monster_vomitus);		
		// Walking Monsters
		func_SpawnMonsterWalk('-175 1578 888', '0 180 0', "nqw_001a", "monster_knight", monster_knight);
		func_SpawnMonsterWalk('-319 1700 888', '0 0 0', "nqw_002a", "monster_knight", monster_knight);
		func_SpawnMonsterWalk('711 1083 344', '0 0 0', "nqw_003a", "monster_zombie", monster_zombie);
		func_SpawnMonsterWalk('995 1030 965', '0 180 0', "nqw_004a", "monster_wizard", monster_wizard);	
		func_SpawnMonsterWalk('708 2076 344', '0 270 0', "nqw_005a", "monster_zombie", monster_zombie);	
		func_SpawnMonsterWalk('960 857 344', '0 180 0', "nqw_006a", "monster_zombie", monster_zombie);	
		func_SpawnMonsterWalk('433 1356 344', '0 180 0', "nqw_007a", "monster_zombie", monster_zombie);	
		func_SpawnMonsterWalk('910 1356 344', '0 180 0', "nqw_008a", "monster_zombie", monster_zombie);	
		func_SpawnMonsterWalk('704 2702 944', '0 270 0', "nqw_009a", "monster_hell_knight", monster_hell_knight);
		func_SpawnMonsterWalk('957 1360 800', '0 180 0', "nqw_010a", "monster_fish", monster_fish);
		func_SpawnMonsterWalk('963 850 572', '0 180 0', "nqw_011a", "monster_fish", monster_fish);
		func_SpawnMonsterWalk('387 1588 437', '0 0 0', "nqw_012a", "monster_fish", monster_fish);
		func_SpawnMonsterWalk('1039 212 896', '0 180 0', "nqw_013a", "monster_shambler", monster_shambler);
	}
	// Mob spawnlist for E1M5
	if (world.model == "maps/e1m5.bsp")
	{
		// Standing Monsters
		func_SpawnMonsterIdle('61 902 690', '0 45 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('-955 2370 394', '0 90 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('-312 1290 386', '0 135 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('-771 1290 386', '0 50 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('141 2389 386', '0 225 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('-192 2105 386', '0 35 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('-322 1756 308', '0 90 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('-578 364 100', '0 270 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('-543 2438 296', '0 166 0', "monster_knight", monster_knight);
		func_SpawnMonsterIdle('-162 1797 -24', '0 315 0', "monster_hell_knight", monster_hell_knight);
		func_SpawnMonsterIdle('-73 1070 95', '0 270 0', "monster_demon1", monster_demon1);
		func_SpawnMonsterIdle('-395 1610 -24', '0 300 0', "monster_demon1", monster_demon1);
		func_SpawnMonsterIdle('-290 1445 -24', '0 270 0', "monster_demon1", monster_demon1);
		func_SpawnMonsterIdle('-543 1161 -24', '0 90 0', "monster_demon1", monster_demon1);
		func_SpawnMonsterIdle('-1626 2258 24', '0 315 0', "monster_demon1", monster_demon1);
		func_SpawnMonsterIdle('-697 1556 345', '0 270 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('-1060 2178 152', '0 180 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('-383 1999 -240', '0 213 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('-695 1999 -240', '0 312 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('-120 2540 344', '0 270 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('943 1608 16', '0 180 0', "monster_shambler", monster_shambler);
		func_SpawnMonsterIdle('483 1608 16', '0 0 0', "monster_shambler", monster_shambler);
		func_SpawnMonsterIdle('-539 1743 -240', '0 90 0', "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterIdle('-1315 1865 24', '0 270 0', "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterIdle('606 2264 264', '0 180 0', "monster_shalrath", monster_shalrath);	
		func_SpawnMonsterIdle('-160 80 80', '0 90 0', "monster_vomit", monster_vomit);
		func_SpawnMonsterIdle('122 1808 -24', '0 180 0', "monster_vomit", monster_vomit);
		func_SpawnMonsterIdle('-808 435 15', '0 215 0', "monster_fish", monster_fish);
		func_SpawnMonsterIdle('164 510 15', '0 197 0', "monster_fish", monster_fish);
		func_SpawnMonsterIdle('-577 172 15', '0 90 0', "monster_fish", monster_fish);
		// Walking Monsters
		func_SpawnMonsterWalk('-319 1736 200', '0 270 0', "nqw_001a", "monster_knight", monster_knight);	
		func_SpawnMonsterWalk('-905 308 15', '0 0 0', "nqw_002a", "monster_fish", monster_fish);
		func_SpawnMonsterWalk('53 631 15', '0 270 0', "nqw_003a", "monster_fish", monster_fish);	
	}
	// Mob spawnlist for E1M6
	if (world.model == "maps/e1m6.bsp")
	{
		func_SpawnMonsterIdle('620 405 24', '0 180 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('617 164 24', '0 109 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('506 164 24', '0 90 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('341 1281 24', '0 180 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('-100 1173 215', '0 180 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('-350 1545 88', '0 270 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('-864 1507 -488', '0 270 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('-680 1415 -232', '0 180 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('-648 1155 -232', '0 180 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('-478 1020 -232', '0 270 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('-520 1144 24', '0 20 0', "monster_shalrath", monster_shalrath);
		func_SpawnMonsterIdle('-520 1416 24', '0 340 0', "monster_shalrath", monster_shalrath);
		func_SpawnMonsterIdle('-185 1416 24', '0 200 0', "monster_shalrath", monster_shalrath);
		func_SpawnMonsterIdle('-185 1144 24', '0 160 0', "monster_shalrath", monster_shalrath);
		func_SpawnMonsterIdle('1034 392 24', '0 340 0', "monster_shalrath", monster_shalrath);
		func_SpawnMonsterIdle('1034 182 24', '0 20 0', "monster_shalrath", monster_shalrath);
		func_SpawnMonsterIdle('-478 566 328', '0 270 0', "monster_tarbaby", monster_tarbaby);	
		func_SpawnMonsterIdle('-558 571 328', '0 270 0', "monster_tarbaby", monster_tarbaby);	
		func_SpawnMonsterIdle('-887 413 304', '0 0 0', "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterIdle('-541 1890 -232', '0 90 0', "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterIdle('-479 1890 -232', '0 90 0', "monster_tarbaby", monster_tarbaby);		
		func_SpawnMonsterIdle('-526 262 328', '0 90 0', "monster_vomit", monster_vomit);
		func_SpawnMonsterIdle('-512 53 -56', '0 90 0', "monster_vomit", monster_vomit);
		func_SpawnMonsterIdle('-703 1904 -488', '0 270 0', "monster_vomit", monster_vomit);
		func_SpawnMonsterIdle('-512 114 104', '0 90 0', "monster_vomit", monster_vomit);
		func_SpawnMonsterIdle('-507 366 -136', '0 270 0', "monster_vomitus", monster_vomitus);	
	}	
	// Mob spawnlist for E1M7
	if (world.model == "maps/e1m7.bsp")
	{
		// Nothing to spawn in this map yet. Needs teleport triggers for enemies to teleport into the map based on Chthon's health. It would make Chthon  much more challenging.
	}			
	// Mob spawnlist for E1M8
	if (world.model == "maps/e1m8.bsp")
	{
		// Standing Monsters		
		func_SpawnMonsterIdle('1035 687 24', '0 270 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('672 242 280', '0 90 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('1253 75 240', '0 137 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('835 -256 -552', '0 180 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('554 -256 -552', '0 0 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('306 -690 24', '0 0 0', "monster_ogre", monster_ogre);
		func_SpawnMonsterIdle('350 410 24', '0 90 0', "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterIdle('300 375 24', '0 55 0', "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterIdle('350 312 24', '0 90 0', "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterIdle('350 215 24', '0 90 0', "monster_tarbaby", monster_tarbaby);
		func_SpawnMonsterIdle('300 168 24', '0 90 0', "monster_tarbaby", monster_tarbaby);	
		func_SpawnMonsterIdle('212 700 24', '0 0 0', "monster_shambler", monster_shambler);
		func_SpawnMonsterIdle('1236 -138 24', '0 270 0', "monster_shambler", monster_shambler);
		func_SpawnMonsterIdle('668 58 416', '0 90 0', "monster_shalrath", monster_shalrath);
		func_SpawnMonsterIdle('596 -156 416', '0 270 0', "monster_shalrath", monster_shalrath);
		func_SpawnMonsterIdle('1277 40 395', '0 140 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('104 -726 420', '0 35 0', "monster_wizard", monster_wizard);
		func_SpawnMonsterIdle('77 67 395', '0 30 0', "monster_wizard", monster_wizard);	
		// Walking Monsters
		func_SpawnMonsterWalk('175 525 176', '0 0 0', "nqw_001a", "monster_shambler", monster_shambler);
		func_SpawnMonsterWalk('906 706 24', '0 180 0', "nqw_002a", "monster_ogre", monster_ogre);
		func_SpawnMonsterWalk('1260 -130 -552', '0 270 0', "nqw_003a", "monster_ogre", monster_ogre);
	}
};

// void(vector pos, vector angle, float specify_team, string clname, void() func) func_SpawnInfoRunes
// Team1 = Red, Team2 = Blue
void() NQW_SMD_RuneSpawnSpots =
{
	if (world.model == "maps/ctf1.bsp") 
	{
		// Team Red
		func_SpawnInfoRunes('2215 1320 316', '0 0 0', TEAM1, "team1_support_rune1", team1_support_rune1);  // Resistence
		func_SpawnInfoRunes('2140 840 100', '0 0 0', TEAM1, "team1_support_rune2", team1_support_rune2);   // Strength/Doubler
		func_SpawnInfoRunes('2835 1465 40', '0 0 0', TEAM1, "team1_support_rune3", team1_support_rune3);   // Haste
		func_SpawnInfoRunes('2985 1320 154', '0 0 0', TEAM1, "team1_support_rune4", team2_support_rune4);  // Regeneration/Guard
				
		// Team Blue
		func_SpawnInfoRunes('-1670 1330 308', '0 0 0', TEAM2, "team2_support_rune1", team2_support_rune1); // Resistence
		func_SpawnInfoRunes('-1605 1793 108', '0 0 0', TEAM2, "team2_support_rune2", team2_support_rune2); // Strength/Doubler
		func_SpawnInfoRunes('-2305 1190 32', '0 0 0', TEAM2, "team2_support_rune3", team2_support_rune3);  // Haste
		func_SpawnInfoRunes('-2445 1330 148', '0 0 0', TEAM2, "team2_support_rune4", team2_support_rune4); // Regeneration/Guard
	}
	
	if (world.model == "maps/ctf1_3wave.bsp")
	{
		// Team Red
		func_SpawnInfoRunes('-1090 680 520', '0 0 0', TEAM1, "team1_support_rune1", team1_support_rune1);  // Resistence
		func_SpawnInfoRunes('-512 167 328', '0 0 0', TEAM1, "team1_support_rune2", team1_support_rune2);   // Strength/Doubler
		func_SpawnInfoRunes('-1310 952 520', '0 0 0', TEAM1, "team1_support_rune4", team1_support_rune4);  // Regeneration/Guard
		
		// Team Blue
		func_SpawnInfoRunes('1090 55 520', '0 0 0', TEAM2, "team2_support_rune1", team2_support_rune1);    // Resistence
		func_SpawnInfoRunes('512 577 328', '0 0 0', TEAM2, "team2_support_rune2", team2_support_rune2);    // Strength/Doubler
		func_SpawnInfoRunes('1308 -216 520', '0 0 0', TEAM2, "team2_support_rune4", team2_support_rune4);  // Regeneration/Guard
	}
	
	if (world.model == "maps/ctf2_3wave.bsp")
	{
	}

	if (world.model == "maps/ctf3_3wave.bsp")
	{
		// Team Red
		func_SpawnInfoRunes('-1380 -352 120', '0 0 0', TEAM1, "team1_support_rune1", team1_support_rune1); // Resistence
		func_SpawnInfoRunes('-1118 -5 401', '0 0 0', TEAM1, "team1_support_rune2", team1_support_rune2);   // Strength/Doubler
		func_SpawnInfoRunes('-1670 160 120', '0 0 0', TEAM1, "team1_support_rune3", team1_support_rune3);  // Haste
		func_SpawnInfoRunes('-1180 -352 120', '0 0 0', TEAM1, "team1_support_rune4", team1_support_rune4); // Regeneration/Guard
		
		// Team Blue
		func_SpawnInfoRunes('1380 352 120', '0 0 0', TEAM2, "team2_support_rune1", team2_support_rune1);   // Resistence
		func_SpawnInfoRunes('1118 5 401', '0 0 0', TEAM2, "team2_support_rune2", team2_support_rune2);     // Strength/Doubler
		func_SpawnInfoRunes('1670 -160 120', '0 0 0', TEAM2, "team2_support_rune3", team2_support_rune3);  // Haste
		func_SpawnInfoRunes('1180 352 120', '0 0 0', TEAM2, "team2_support_rune4", team2_support_rune4);   // Regeneration/Guard		
	}
	
	if (world.model == "maps/ctf4_3wave.bsp")
	{
	}
	
	if (world.model == "maps/ctf5_3wave.bsp")
	{
	}
	
	if (world.model == "maps/ctf6_3wave.bsp")
	{
	}
	
	if (world.model == "maps/ctf7_3wave.bsp")
	{
	}
	
	if (world.model == "maps/ctf8_3wave.bsp")
	{
	}
	
	if (world.model == "maps/ctf8_3wave_qe.bsp")
	{
		// Team Red
		func_SpawnInfoRunes('-2130 295 216', '0 0 0', TEAM1, "team1_support_rune1", team1_support_rune1);  // Resistence
		func_SpawnInfoRunes('-1600 -350 216', '0 0 0', TEAM1, "team1_support_rune2", team1_support_rune2); // Strength/Doubler
		func_SpawnInfoRunes('-1146 -168 216', '0 0 0', TEAM1, "team1_support_rune3", team1_support_rune3); // Haste
		func_SpawnInfoRunes('-1605 480 216', '0 0 0', TEAM1, "team1_support_rune4", team1_support_rune4);  // Regeneration/Guard
		
		// Team Blue
		func_SpawnInfoRunes('1065 -170 216', '0 0 0', TEAM2, "team2_support_rune1", team2_support_rune1);  // Resistence
		func_SpawnInfoRunes('545 465 216', '0 0 0', TEAM2, "team2_support_rune2", team2_support_rune2);    // Strength/Doubler
		func_SpawnInfoRunes('80 295 232', '0 0 0', TEAM2, "team2_support_rune3", team2_support_rune3);     // Haste
		func_SpawnInfoRunes('545 -345 216', '0 0 0', TEAM2, "team2_support_rune4", team2_support_rune4);   // Regeneration/Guard
	}	
};

void() dev_stuff =
{
	// Sleeper: Testing key respawns, whenever there's no players in the server.
	if (world.model == "maps/e1m3.bsp") func_SpawnWeapon('-648 -1679 151', '0 0 0', "gold key", item_key2);
	if (world.model == "maps/400m.bsp") func_SpawnWeapon('1820 -314 60', '0 0 0', "gold key", item_key2);
	
	// Easy Hallway
	// Red
	if (world.model == "maps/start.bsp") func_SpawnInfoRunes('110 900 -40', '0 0 0', TEAM1, "team1_support_rune1", team1_support_rune1);
	if (world.model == "maps/start.bsp") func_SpawnInfoRunes('110 950 -40', '0 0 0', TEAM1, "team1_support_rune2", team1_support_rune2);
	if (world.model == "maps/start.bsp") func_SpawnInfoRunes('110 1000 -40', '0 0 0', TEAM1, "team1_support_rune3", team1_support_rune3);
	if (world.model == "maps/start.bsp") func_SpawnInfoRunes('110 1050 -40', '0 0 0', TEAM1, "team1_support_rune4", team1_support_rune4);
	
	// Blue
	if (world.model == "maps/start.bsp") func_SpawnInfoRunes('325 900 -40', '0 0 0', TEAM2, "team2_support_rune1", team2_support_rune1);
	if (world.model == "maps/start.bsp") func_SpawnInfoRunes('325 950 -40', '0 0 0', TEAM2, "team2_support_rune2", team2_support_rune2);
	if (world.model == "maps/start.bsp") func_SpawnInfoRunes('325 1000 -40', '0 0 0', TEAM2, "team2_support_rune3", team2_support_rune3);
	if (world.model == "maps/start.bsp") func_SpawnInfoRunes('325 1050 -40', '0 0 0', TEAM2, "team2_support_rune4", team2_support_rune4);				
};


/*
======================
Sleeper Must Die Skill

Call for Skill 5 stuff
======================
*/

// Sleeper: Skill 5 needs to be called something, ya know.
void() NQW_SleeperMustDie =
{
	if (cvar("developer")) dev_stuff ();
	
	// Group all spawn calls into a single call then call this from worldspawn. Now we have a proper custom skill for Single Player and Cooperative. (Currently can only be used in FTEQW)
	if (coop < 5 && skill == 5 && !deathmatch)
	{
		 NQW_SMD_Mobs ();
		 NQW_SMD_CoopItems ();
		 NQW_SMD_PathCorners ();
	}
	// Add items that maybe missing in deathmatch.
	if (deathmatch && !coop) 
	{
		NQW_SMD_DMItems ();	
		if (deathmatch == DM_CTF || deathmatch == DM_OneFlagCTF) NQW_SMD_RuneSpawnSpots ();
	}		
};