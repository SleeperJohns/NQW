/*
======================================================
NQW: Caleb
======================================================
*/

void() NQW_Caleb =
{
	// Player Model
	setmodel 	          (self, "progs/player_caleb.mdl"); // Caleb's Player Model
	self.nqwCharGib         = "progs/h_player_caleb.mdl";       // Caleb's Head when gibbed
	
	// Melee Weapon Models
	self.nqwMeleeMdl        = "progs/v_pfork.mdl"; 	     // Caleb's pitchfork (Melee weapon)
	self.nqwHammerMdl       = "progs/v_hammer.mdl";      // Mjolnir (Thor's Hammer)
	
	// Max Skins
	NQW_SetSkin (6);
	
	// Melee Sounds
	self.nqwSndMelee        = "weapons/ax1.wav";	  
	self.nqwSndMeleeHit     = "caleb/meleeflesh.wav";
	self.nqwSndMeleeWall    = "caleb/meleewall.wav";
	
	// Jump and landing sounds
	self.nqwSndJump         = "caleb/jump.wav";	  // Caleb's "HUUH" sound
	self.nqwSndLand1        = "caleb/land.wav";	  // Safe land sound
	self.nqwSndLand2        = "caleb/land2.wav";  	  // Cratered sound
	self.nqwSndFallDeath    = "player/splat1.wav";
	
	// Caleb's Quake 1-style pain sounds
	self.nqwSndQ1Pain1      = "caleb/pain1.wav";
	self.nqwSndQ1Pain2      = "caleb/pain2.wav";
	self.nqwSndQ1Pain3      = "caleb/pain3.wav";
	self.nqwSndQ1Pain4      = "caleb/pain4.wav";
	self.nqwSndQ1Pain5      = "caleb/pain5.wav";
	self.nqwSndQ1Pain6      = "caleb/pain6.wav";
		
	// Caleb's Quake 2-style pain sounds	
	self.nqwSndQ2Pain1      = "caleb/pain1.wav";
	self.nqwSndQ2Pain2      = "caleb/pain1.wav";
	self.nqwSndQ2Pain3      = "caleb/pain2.wav";
	self.nqwSndQ2Pain4      = "caleb/pain3.wav";
	self.nqwSndQ2Pain5      = "caleb/pain4.wav";
	self.nqwSndQ2Pain6      = "caleb/pain5.wav";
	self.nqwSndQ2Pain7      = "caleb/pain6.wav";
	self.nqwSndQ2Pain8      = "caleb/pain6.wav";
	
	// Caleb's Hazard and Death sounds					
	self.nqwSndDeath1       = "caleb/death1.wav";
	self.nqwSndDeath2       = "caleb/death2.wav";
	self.nqwSndDeath3       = "caleb/death3.wav";
	self.nqwSndDeath4       = "caleb/death4.wav";
	self.nqwSndDeath5       = "caleb/death5.wav";
	self.nqwSndAxHit1       = "caleb/agony.wav";        // The sound of the melee hitting another player
	self.nqwSndBurn1        = "caleb/burn1.wav";
	self.nqwSndBurn2        = "caleb/burn2.wav";
	self.nqwSndGasp1        = "caleb/gasp.wav";
	self.nqwSndGasp2        = "caleb/gasp.wav";
	self.nqwSndDrown1       = "caleb/drown1.wav";
	self.nqwSndDrown2       = "caleb/drown2.wav";
	self.nqwSndH2oDeath     = "caleb/h2odeath.wav";
	
	self.nqwSpeakSpawn      = NQW_CalebSpawn;
	self.nqwSpeakFrag       = NQW_CalebFrag;
	self.nqwSpeakItem       = NQW_CalebItem;		
	self.nqwSpeakCthonGreet = "caleb/extrabad.wav";
	self.nqwSpeakCthonKill  = "caleb/thatsallfolks.wav";
	self.nqwSpeakShubGreet  = "caleb/shebitch.wav";
	self.nqwSpeakShubKill   = "caleb/dingdong.wav";
};

void() NQW_CalebSpawn = 
{	  
	if (self.waterlevel > 2) return;
    
	string s = "";   
	// Map just started
	float x = 0;
	if (time > self.ltime + 15) x = 1;

        // No frags, so probably just started
	if (x != 1) 
	{
		if (world.model == "maps/start.bsp") 
		{
			// First time starting
			if (!(serverflags)) 
			{
				sound (self, CHAN_VOICE, "caleb/liveagain.wav", 1, ATTN_NORM);
				return;
			}
			// Opened the pit
			else if ((serverflags & 15) == 15) 
			{
				sound (self, CHAN_VOICE, "caleb/putdown.wav", 1, ATTN_NORM);
				return;
			}
		}

		float r = random() * 8;
		
		if (r < 1) s = "caleb/liveagain.wav";
		else if (r < 2) s = "caleb/alldead.wav";
		else if (r < 3) s = "caleb/comeout.wav";
		else if (r < 4) s = "caleb/donateblood.wav";
		else if (r < 5) s = "caleb/business.wav";
		else if (r < 6) s = "caleb/promisesfun.wav";
		else if (r < 7) s = "caleb/sweethome.wav";
		else s = "caleb/sweetsuffering.wav";

		if (s == "") return;
		
		sound (self, CHAN_VOICE, s, 1, ATTN_NORM);
		self.nqwTauntTimer = time + 10;
	}
};

void() NQW_Caleb_tauntlist =
{
	if (self.waterlevel > 2) return;      
	if (self.nqwTauntTimer > time) return;  	
	
	string s = "";
	float r = floor(random() * 39);
	
	switch (r) 
	{
		case 0: s = "caleb/alreadydead.wav"; break;
		case 1: s = "caleb/amateurs.wav"; break;
		case 2: s = "caleb/anothercorpse.wav"; break;
		case 3: s = "caleb/cackle1.wav"; break;
		case 5: s = "caleb/cackle2.wav"; break;
		case 6: s = "caleb/cackle3.wav"; break;
		case 7: s = "caleb/coagulate.wav"; break;
		case 8: s = "caleb/dontwaste.wav"; break;
		case 9: s = "caleb/downhatch.wav"; break;
		case 10: s = "caleb/endline.wav"; break;
		case 11: s = "caleb/faith.wav"; break;
		case 12: s = "caleb/freshvictims.wav"; break;
		case 13: s = "caleb/goodway.wav"; break;
		case 14: s = "caleb/guywithgun.wav"; break;
		case 15: s = "caleb/hurtingstop.wav"; break;
		case 16: s = "caleb/insects.wav"; break;
		case 17: s = "caleb/laugh1.wav"; break;
		case 18: s = "caleb/laugh2.wav"; break;
		case 19: s = "caleb/laugh3.wav"; break;
		case 20: s = "caleb/letsdoit.wav"; break;
		case 21: s = "caleb/lookedbetter.wav"; break;
		case 22: s = "caleb/nevermore.wav"; break;
		case 23: s = "caleb/nightnight.wav"; break;
		case 24: s = "caleb/notlookinatyou.wav"; break;
		case 25: s = "caleb/notnice.wav"; break;
		case 26: s = "caleb/playdead.wav"; break;
		case 27: s = "caleb/reflexes.wav"; break;
		case 28: s = "caleb/rip.wav"; break;
		case 29: s = "caleb/standandbleed.wav"; break;
		case 30: s = "caleb/strangers.wav"; break;
		case 31: s = "caleb/sunshine.wav"; break;
		case 32: s = "caleb/whosnext.wav"; break;
		case 33: s = "caleb/teachya.wav"; break;
		case 34: s = "caleb/victims.wav"; break;
		case 35: s = "caleb/tipperary.wav"; break;
		case 36: s = "caleb/train.wav"; break;
		case 37: s = "caleb/undermyskin.wav"; break;
		default: s = "caleb/whoslaughing.wav"; break;
	}
	
	if (s == "") return;
	
	sound (self, CHAN_VOICE, s, 1, ATTN_NORM);
	self.nqwTauntTimer = time + 10;	
};

void(entity targ, entity attacker) NQW_CalebFrag = 
{
	if (attacker.health < 1) return;
	if (attacker.nqwTauntTimer > time) return;
	if (attacker.waterlevel > 2) return;

	string s = "";
	float r = random();

	// Someone alert PETA
	if (targ.classname == "monster_dog") 
	{
		if (r < 0.4) s = "caleb/arf.wav";
		else s = "playdead.wav";
	}
	
	// Weapon specific deaths
	if (attacker.weapon == IT_AXE) 
	{
		if (r < 0.25) s = "caleb/lambs.wav";
		else if (r < 0.5) s = "caleb/heresjohnny.wav";
		else if (r < 0.75) s = "caleb/faceoff.wav";
		else s = "caleb/bleedonme.wav";
	}
	else if (r < 0.2 && (attacker.weapon == IT_ROCKET_LAUNCHER || attacker.weapon == IT_LIGHTNING || attacker.weapon == IT_GRENADE_LAUNCHER || attacker.weapon == IT_LASER_CANNON || attacker.weapon == IT_MJOLNIR)) 
		s = "caleb/fleshcooked.wav";
	else if (r < 0.3 && (attacker.weapon == IT_SHOTGUN || attacker.weapon == IT_SUPER_SHOTGUN)) 
	{
		if (r < 0.15) s = "caleb/boomstick.wav";
		else s = "caleb/shotgun.wav";
	}

	// Check if target is using Caleb
	if (r < 0.2 && (targ.flags & FL_CLIENT) && targ.nqwCharacter == NQW_CALEB)
		s = "caleb/hatemimes.wav";
	else if (r < 0.4 && (targ.flags & FL_CLIENT) && targ.nqwCharacter == NQW_DUKENUKEM) 
	{
		if (r < 0.2) s = "caleb/timetoplay.wav";
		else s = "caleb/shakeit.wav";
	}
	// Random taunt
	else 
	{
		r = floor(random() * 39);
		switch (r) 
		{
			case 0: s = "caleb/alreadydead.wav"; break;
			case 1: s = "caleb/amateurs.wav"; break;
			case 2: s = "caleb/anothercorpse.wav"; break;
			case 3: s = "caleb/cackle1.wav"; break;
			case 5: s = "caleb/cackle2.wav"; break;
			case 6: s = "caleb/cackle3.wav"; break;
			case 7: s = "caleb/coagulate.wav"; break;
			case 8: s = "caleb/dontwaste.wav"; break;
			case 9: s = "caleb/downhatch.wav"; break;
			case 10: s = "caleb/endline.wav"; break;
			case 11: s = "caleb/faith.wav"; break;
			case 12: s = "caleb/freshvictims.wav"; break;
			case 13: s = "caleb/goodway.wav"; break;
			case 14: s = "caleb/guywithgun.wav"; break;
			case 15: s = "caleb/hurtingstop.wav"; break;
			case 16: s = "caleb/insects.wav"; break;
			case 17: s = "caleb/laugh1.wav"; break;
			case 18: s = "caleb/laugh2.wav"; break;
			case 19: s = "caleb/laugh3.wav"; break;
			case 20: s = "caleb/letsdoit.wav"; break;
			case 21: s = "caleb/lookedbetter.wav"; break;
			case 22: s = "caleb/nevermore.wav"; break;
			case 23: s = "caleb/nightnight.wav"; break;
			case 24: s = "caleb/notlookinatyou.wav"; break;
			case 25: s = "caleb/notnice.wav"; break;
			case 26: s = "caleb/playdead.wav"; break;
			case 27: s = "caleb/reflexes.wav"; break;
			case 28: s = "caleb/rip.wav"; break;
			case 29: s = "caleb/standandbleed.wav"; break;
			case 30: s = "caleb/strangers.wav"; break;
			case 31: s = "caleb/sunshine.wav"; break;
			case 32: s = "caleb/whosnext.wav"; break;
			case 33: s = "caleb/teachya.wav"; break;
			case 34: s = "caleb/victims.wav"; break;
			case 35: s = "caleb/tipperary.wav"; break;
			case 36: s = "caleb/train.wav"; break;
			case 37: s = "caleb/undermyskin.wav"; break;
			default: s = "caleb/whoslaughing.wav"; break;
		}
	}

	if (s == "") return;

	sound (attacker, CHAN_VOICE, s, 1, ATTN_NORM);
	attacker.nqwTauntTimer = time + 10;
};

void(entity collector, entity item) NQW_CalebItem = 
{
	local float r;

	if (collector.nqwTauntTimer > time) return;   
	if (collector.waterlevel > 2) return;

	local string s = "";

    // Weapons
	if (item.classname == "weapon_nailgun" || item.classname == "weapon_supernailgun" || item.classname == "weapon_grenadelauncher" || item.classname == "weapon_proximity_gun") 
	{    
		r = random();
		if (r < 0.5) s = "caleb/weapon.wav";
		else s = "caleb/laugh1.wav";
	}
	else if (item.classname == "weapon_supershotgun") 
	{
		r = random();
		if (r < 0.5) s = "caleb/boomstick.wav";
		else s = "caleb/shotgun.wav";
	}
	else if (item.classname == "weapon_rocketlauncher" || item.classname == "weapon_lightning" || item.classname == "weapon_laser_gun" || item.classname == "weapon_mjolnir")
	{
		r = random();
		if (r < 0.5) s = "caleb/rocket.wav";
		else s = "caleb/laugh3.wav";
	}
	// Powerups
	else if (item.classname == "item_artifact_super_damage" || item.classname == "item_artifact_invulnerability") 
	{
		r = random();
		if (r < 0.5) s = "caleb/quad.wav";
		else s = "caleb/everybodydies.wav";
	}
	else if (item.classname == "item_artifact_invisibility") s = "caleb/tada.wav";
	// Runes
	else if (item.classname == "item_sigil") s = "caleb/sigil.wav";

	if (s == "") return;
    
	sound (collector, CHAN_VOICE, s, 1, ATTN_NORM);
	collector.nqwTauntTimer = time + 6;
};