/*
======================================================
NQW: DUKE NUKEM
======================================================
*/
void() NQW_DukeNukem =
{
	// Model
	setmodel (self, "progs/player_dukenukem.mdl");
	self.nqwCharGib = "progs/h_player_dukenukem.mdl";
	self.nqwMeleeMdl = "progs/v_mfoot.mdl";
	self.nqwHammerMdl = "progs/v_hammer.mdl";
	NQW_SetSkin(7);
	NQW_DukeModel();
	// Sounds
	self.nqwSndMelee = "weapons/ax1.wav";
	self.nqwSndMeleeHit = "duke/kickhit.wav";
	self.nqwSndMeleeWall = "duke/kickhit.wav";
	self.nqwSndJump = "duke/jump.wav";
	self.nqwSndLand1 = "duke/land02.wav";
	self.nqwSndLand2 = "duke/land2.wav";
	self.nqwSndFallDeath = "duke/falldeath.wav";	
	
	// Quake 1 style pain sounds
	self.nqwSndQ1Pain1 = "duke/pain2.wav";
	self.nqwSndQ1Pain2 = "duke/pain3.wav";
	self.nqwSndQ1Pain3 = "duke/pain5.wav";
	self.nqwSndQ1Pain4 = "duke/pain6.wav";
	self.nqwSndQ1Pain5 = "duke/pain7.wav";
	self.nqwSndQ1Pain6 = "duke/pain8.wav";
		
	// Quake 2 style pain sounds
	self.nqwSndQ2Pain1 = "duke/pain2.wav";
	self.nqwSndQ2Pain2 = "duke/pain3.wav";
	self.nqwSndQ2Pain3 = "duke/pain5.wav";
	self.nqwSndQ2Pain4 = "duke/pain6.wav";
	self.nqwSndQ2Pain5 = "duke/pain7.wav";
	self.nqwSndQ2Pain6 = "duke/pain8.wav";
	self.nqwSndQ2Pain7 = "duke/pain7.wav";
	self.nqwSndQ2Pain8 = "duke/pain8.wav";
		
	self.nqwSndDeath1 = "duke/dmdeath.wav";
	self.nqwSndDeath2 = "duke/dscrem2.wav";
	self.nqwSndDeath3 = "duke/dscrem3.wav";
	self.nqwSndDeath4 = "duke/dmdeath.wav";
	self.nqwSndDeath5 = "duke/dscrem1.wav";
	self.nqwSndAxHit1 = "duke/dscrem4.wav";
	self.nqwSndBurn1 = "duke/dscrem5.wav";
	self.nqwSndBurn2 = "duke/dscrem6.wav";
	self.nqwSndGasp1 = "duke/gasps.wav";
	self.nqwSndGasp2 = "duke/gasps.wav";
	self.nqwSndDrown1 = "duke/drown1.wav";
	self.nqwSndDrown2 = "duke/drown2.wav";
	self.nqwSndH2oDeath = "duke/chokn.wav";
	
	self.nqwSpeakSpawn = NQW_DukeSpawn;
	self.nqwSpeakFrag = NQW_DukeFrag;
	self.nqwSpeakItem = NQW_DukeItem;
	self.nqwSpeakCthonGreet = "duke/rip.wav";
	self.nqwSpeakCthonKill = "duke/dukesentya.wav";
	self.nqwSpeakShubGreet = "duke/quake.wav";
	self.nqwSpeakShubKill = "duke/teleport.wav";
//	NQW_DukeSpawn();
};

void(entity targ, entity attacker) NQW_DukeFrag =
{   
	if (self.waterlevel > 2) return;       
	if (attacker.nqwTauntTimer > time) return;
 
	local string s = "";
	local float r = random();
    
	// Mighty foot killed target
	if (attacker.weapon == IT_AXE) 
	{
		if (r < 0.25) s = "duke/footface.wav";
		else if (r < 0.5) s = "duke/stomped.wav";
		else if (r < 0.75) s = "duke/bug.wav";
		else s = "duke/bloodboot.wav";
	}     
	// Check if target is using a specific champion
	else if (r < 0.3) 
	{
		if (targ.flags & FL_CLIENT) 
		{
			if (targ.nqwCharacter == NQW_RANGER) 
			{
				r = random();
				if (r < 0.5) s = "duke/teleport.wav";
				else s = "duke/quake.wav";
			}
			else if (targ.nqwCharacter == NQW_SLEEPER) s = "duke/dukesentya.wav";
			else if (targ.nqwCharacter == NQW_SORLAG) s = "duke/allbizbabe.wav";
			else if (targ.nqwCharacter == NQW_DOOMGUY) s = "duke/doomedsm.wav";
			else if (targ.nqwCharacter == NQW_DUKENUKEM) 
			{
				r = random();
				if (r < 0.333) s = "duke/myself.wav";
				else if (r < 0.666) s = "duke/realthing.wav";
				else s = "duke/kickmyass.wav";
			}
		}
	}     

	// Random taunt
	if (s == "") 
	{
		r = floor(random() * 31);
		switch (r) 
		{
			case 0: s = "duke/trd.wav"; break;
			case 1: s = "duke/aisle.wav"; break;
			case 2: s = "duke/amess.wav"; break;
			case 3: s = "duke/bitchn.wav"; break;
			case 4: s = "duke/blowit.wav"; break;
			case 5: s = "duke/bookem.wav"; break;
			case 6: s = "duke/cool.wav"; break;
			case 7: s = "duke/damn.wav"; break;
			case 8: s = "duke/getsom.wav"; break;
			case 9: s = "duke/gmeovr.wav"; break;
			case 10: s = "duke/gothrt.wav"; break;
			case 11: s = "duke/groovy.wav"; break;
			case 12: s = "duke/hail.wav"; break;
			case 13: s = "duke/holysh.wav"; break;
			case 14: s = "duke/imgood.wav"; break;
			case 15: s = "duke/inhell.wav"; break;
			case 16: s = "duke/letsrk.wav"; break;
			case 17: s = "duke/lookin.wav"; break;
			case 18: s = "duke/meat.wav"; break;
			case 19: s = "duke/name.wav"; break;
			case 20: s = "duke/nobody.wav"; break;
			case 21: s = "duke/piece.wav"; break;
			case 22: s = "duke/slacker.wav"; break;
			case 23: s = "duke/sukitdn.wav"; break;
			case 24: s = "duke/rokrol.wav"; break;
			case 25: s = "duke/betduke2.wav"; break;
			case 26: s = "duke/huckleberry.wav"; break;
			case 27: s = "duke/itsgood.wav"; break;
			case 28: s = "duke/ripieces.wav"; break;
			case 29: s = "duke/oneking.wav"; break;
			default: s = "duke/fragged.wav"; break;
		}
	}

	if (s == "") return;

	sound (attacker, CHAN_VOICE, s, 1, ATTN_NORM);
	attacker.nqwTauntTimer = time + 6;
};

void() NQW_Duke_tauntlist =
{	
	if (self.waterlevel > 2) return;      
	if (self.nqwTauntTimer > time) return;  
	     
        local string s = "";
	local float r = random();

	// Random taunt
	if (s == "")
	{
		local float x = 0.058;
		r = random();
		if (r < x) s = "duke/aisle.wav";
		else if (r < x * 2) s = "duke/amess.wav";
		else if (r < x * 3) s = "duke/blowit.wav";
		else if (r < x * 4) s = "duke/getsom.wav";
		else if (r < x * 5) s = "duke/gmeovr.wav";
		else if (r < x * 6) s = "duke/sukitdn.wav";
		else if (r < x * 7) s = "duke/ripieces.wav";
		else if (r < x * 8) s = "duke/fragged.wav";
		else if (r < x * 9) s = "duke/trd.wav";
		else if (r < x * 10) s = "duke/hell90s.wav";
		else if (r < x * 11) s = "duke/romero.wav";
		else if (r < x * 12) s = "duke/chew.wav";
		else if (r < x * 13) s = "duke/blowshitup.wav";
		else if (r < x * 14) s = "duke/rip.wav";
		else if (r < x * 15) s = "duke/wthplc.wav";
		else if (r < x * 16) s = "duke/stormgates.wav";   
		else if (r < x * 17) s = "duke/quake.wav";
	}

	if (s == "") return;

	sound (self, CHAN_VOICE, s, 1, ATTN_NORM);
	self.nqwTauntTimer = time + 6; 
};

void() NQW_DukeSpawn =
{    
	if (self.waterlevel > 2) return;
    
	local float r = random();
	local string s = "";
    
	// Map just started
	local float x = 0;
	if (time > self.ltime + 15) x = 1;

	// No frags, so probably just started
	if (x != 1)
	{
		if (world.model == "maps/start.bsp")
		{
			// First time starting
			if (!(serverflags))
			{
				sound (self, CHAN_VOICE, "duke/wthplc.wav", 1, ATTN_NORM);
				return;
			}
			// Opened the pit
			else if ((serverflags & 15) == 15)
			{
				sound (self, CHAN_VOICE, "duke/stormgates.wav", 1, ATTN_NORM);
				return;
			}
		}
		x = 0.1111;
		if (r < x) s = "duke/letsrk.wav";
		else if (r < x * 2) s = "duke/wherami.wav";
		else if (r < x * 3) s = "duke/hell90s.wav";
		else if (r < x * 4) s = "duke/romero.wav";
		else if (r < x * 5) s = "duke/betduke.wav";
		else if (r < x * 6) s = "duke/chew.wav";
		else if (r < x * 7) s = "duke/blowshitup.wav";
		else if (r < x * 8) s = "duke/cokrok.wav";
		else if (r < x * 9) s = "duke/wansom.wav";
	}
	// Respawning
	else
	{
		x = 0.125;
		if (r < x) s = "duke/cry.wav";
		else if (r < x * 2) s = "duke/kicka.wav";
		else if (r < x * 3) s = "duke/pissin.wav";
		else if (r < x * 4) s = "duke/rip.wav";
		else if (r < x * 5) s = "duke/smackdb.wav";
		else if (r < x * 6) s = "duke/yohoho2.wav";
		else if (r < x * 7) s = "duke/nothink.wav";
		else if (r < x * 8) s = "duke/mthrfkr.wav";
	}
    
	if (s == "") return;
    
	sound (self, CHAN_VOICE, s, 1, ATTN_NORM);
};

void() NQW_DukeModel =
{
//  	self.nqwSkin = self.nqwSkin % self.nqwMaxSkins;
	if (self.nqwSkin != 6) setmodel (self, "progs/player_dukenukem.mdl");
	else setmodel (self, "progs/player_olddukenukem.mdl");
	self.modelindex_nqwplayer = self.modelindex;
	self.view_ofs = '0 0 22';
	self.velocity = '0 0 0';	// 1998-07-21 Player moves after respawn fix by Xian
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
    
	self.skin = self.nqwSkin;
};


void() duke_run;
void() duke_stand;
void() duke_shoot;

/* Originally used this for some animation abuse, but it interrupted the weapon animations causing unpredictable behavior
void() duke_fly =
{	
	local vector vspd;

	self.qccDoubleJump += 1;
	if (self.qccDoubleJump > 100 || !self.button2)
	{
		self.qccDoubleJump = 300;
		player_run ();
		sound (self, CHAN_ITEM, "duke/jetpakof.wav", 1, ATTN_NORM);
		return;
	}
	
	if (!self.button0) self.frame = 144;

	// Lift up when going still, keep height when going forward
	vspd = self.velocity;
	vspd_z = 0;
	self.velocity_z = 200 - vlen (vspd);
	if (self.velocity_z < 10) self.velocity_z = 10;

	if (self.qccDoubleJump % 10 == 9) sound (self, CHAN_ITEM, "duke/jetpaki.wav", 1, ATTN_NORM);
}
*/

void() duke_stand = [ 151, duke_stand ]
{
	self.weaponframe = 0;

	if (self.button0)
	{
		duke_shoot();
		return;
	}

	if (self.velocity_x || self.velocity_y)
	{
		self.walkframe = 0;
		duke_run ();
		return;
	}
	if (self.walkframe >= 4) self.walkframe = 0;
	self.frame += self.walkframe;
	self.walkframe += 1;	
}

void() duke_run = [ 145, duke_run ]
{
	self.weaponframe = 0;

	if (self.button0)
	{
		duke_shoot ();
		return;
	}

	if (!self.velocity_x && !self.velocity_y)
	{
		self.walkframe = 0;
		duke_stand ();
		return;
	}
	if (self.walkframe == 6) self.walkframe = 0;
	self.frame += self.walkframe;

	self.walkframe += 1;
}

void() duke_pain_proc =
{
	if (self.button0)
	{
		duke_shoot();
		return;
	}
};

void()	duke_pain1 =	[	156,	duke_pain2	] {PainSound();self.weaponframe=0;duke_pain_proc();};
void()	duke_pain2 =	[	157,	duke_pain3	] {duke_pain_proc();};
void()	duke_pain3 =	[	158,	duke_pain4	] {duke_pain_proc();};
void()	duke_pain4 =	[	159,	duke_pain5	] {duke_pain_proc();};
void()	duke_pain5 =	[	160,	duke_pain6	] {duke_pain_proc();};
void()	duke_pain6 =	[	161,	duke_run	] {duke_pain_proc();};

void(entity attacker, float damage) duke_pain = {duke_pain1();};

void() duke_shoot = [ 161, duke_shoot ]
{
	self.effects |= EF_MUZZLEFLASH;

	if (!self.button0)
	{
		duke_stand();
		return;
	}
    
	self.weaponframe += 1;    
	if (self.weaponframe == 5) self.weaponframe = 1;
      
	self.frame += self.weaponframe;
}

void(entity collector, entity item) NQW_DukeItem =
{
	local float r;

	if (collector.waterlevel > 2) return;		
	if (collector.nqwTauntTimer > time) return;        

	local string s = "";
    
	if (world.worldtype == WORLDTYPE_BASE && (item.items & collector.items) != item.items)
	{
		if (item.items == IT_KEY1 || item.items == IT_KEY2) s = "duke/nokeycard.wav";
	}
		
	// Weapons
	if (item.classname == "weapon_nailgun" || item.classname == "weapon_supernailgun" || item.classname == "weapon_supershotgun")
	{    
		r = random();
		if (r < 0.25) s = "duke/wansom.wav";
		else if (r < 0.5) s = "duke/cool.wav";
		else if (r < 0.75) s = "duke/groovy.wav";
		else s = "duke/getsom.wav";
	}
	else if (item.classname == "weapon_rocketlauncher" || item.classname == "weapon_grenadelauncher" || item.classname == "weapon_proximity_gun")
	{
		r = random();
		if (r < 1) s = "duke/blowshitup.wav";
	}		
	else if (item.classname == "weapon_lightning" || item.classname == "weapon_laser_gun" || item.classname == "weapon_mjolnir")
	{
		r = random();
		if (r < 0.333) s = "duke/hehehe.wav";
		else if (r < 0.666) s = "duke/letsrk.wav";
		else s = "duke/timetokill.wav";
	}
	// Armor
	else if (item.classname == "item_armor1" || item.classname == "item_armor2" || item.classname == "item_armor3")
	{
		r = random();
		if (r < 0.333) s = "duke/pwrarmr.wav";
		else if (r < 0.666) s = "duke/groovy.wav";
		else s = "duke/cool.wav";
	}
	// Megahealth
	else if (item.classname == "item_health" && item.spawnflags & H_MEGA) s = "duke/lookin.wav";
	// Powerups
	else if (item.classname == "item_artifact_super_damage") s = "duke/timetokill.wav";
	else if (item.classname == "item_artifact_invulnerability") s = "duke/bos.wav";
	else if (item.classname == "item_artifact_invisibility") s = "duke/wherami.wav";
	else if (item.classname == "item_artifact_empathy_shields") s = "duke/getsom.wav";  
	else if (item.classname == "item_hornofconjuring") s = "duke/kicka.wav";
	else if (item.classname == "item_artifact_wetsuit") s = "duke/groovy.wav";
	else if (item.classname == "item_artifact_envirosuit") s = "duke/groovy.wav";        
	// Runes
	else if (item.classname == "item_sigil") s = "duke/imgood.wav";

	if (s == "") return;
    
	sound (collector, CHAN_VOICE, s, 1, ATTN_NORM);
	collector.nqwTauntTimer = time + 6;
};