void() W_SetCurrentAmmo;

void() NQW_Precaches =
{	
	// RANGER
	precache_model ("progs/player_ranger.mdl"); // player Ranger model (has new animations)
	precache_sound ("ranger/axhit.wav"); // Ranger's axe sound for hitting something living
	precache_sound ("ranger/axhit2.wav"); // Ranger's axe sound for hitting the wall
	precache_sound ("ranger/rangerjump.wav"); // Ranger's iconic HUUH (jump) sound
	precache_sound ("ranger/rangerland.wav"); // Ranger's landing sound
	precache_sound ("ranger/rangerland2.wav"); // Ranger's cratering sound
	precache_sound ("ranger/rangerpain1.wav"); // Ranger's first pain sound
	precache_sound ("ranger/rangerpain2.wav"); // Ranger's second pain sound
	precache_sound ("ranger/rangerpain3.wav"); // Ranger's third pain sound
	precache_sound ("ranger/rangerpain4.wav"); // Ranger's fourth pain sound
	precache_sound ("ranger/rangerpain5.wav"); // Ranger's fifth pain sound
	precache_sound ("ranger/rangerpain6.wav"); // Ranger's sixth (and last) pain sound
	precache_sound ("ranger/rangerdeath1.wav"); // Ranger's first death sound
	precache_sound ("ranger/rangerdeath2.wav"); // Ranger's second death sound
	precache_sound ("ranger/rangerdeath3.wav"); // Ranger's third death sound
	precache_sound ("ranger/rangerdeath4.wav"); // Ranger's fourth death sound
	precache_sound ("ranger/rangerdeath5.wav"); // Ranger's fifth (and last) death sound
	precache_sound ("ranger/falling.wav");
	
	// SLEEPER (Quake 1 stuff)
	precache_model ("progs/player_sleeper.mdl"); // player Sleeper model
	precache_model ("progs/v_sleeper_axe.mdl");  // Sleeper's Temporary Axe model
	precache_sound ("sleeper/axhit2.wav"); // Sleeper's axe sound for hitting something living
	precache_sound ("sleeper/axhitwall.wav"); // Sleeper's axe sound for hitting the wall
	precache_sound ("sleeper/sleepjump.wav"); // Sleeper's HUUH (jump) sound
	precache_sound ("sleeper/sleepland.wav"); // Sleeper's landing sound
	precache_sound ("sleeper/sleepland2.wav"); // Sleeper's cratering sound
	precache_sound ("sleeper/sleeppain1.wav"); // Sleeper's first pain sound
	precache_sound ("sleeper/sleeppain2.wav"); // Sleeper's second pain sound
	precache_sound ("sleeper/sleeppain3.wav"); // Sleeper's third pain sound
	precache_sound ("sleeper/sleeppain4.wav"); // Sleeper's fourth pain sound
	precache_sound ("sleeper/sleeppain5.wav"); // Sleeper's fifth pain sound
	precache_sound ("sleeper/sleeppain6.wav"); // Sleeper's sixth (and last) pain sound
	precache_sound ("sleeper/sleepdeath1.wav"); // Sleeper's first death sound
	precache_sound ("sleeper/sleepdeath2.wav"); // Sleeper's second death sound
	precache_sound ("sleeper/sleepdeath3.wav"); // Sleeper's third death sound
	precache_sound ("sleeper/sleepdeath4.wav"); // Sleeper's fourth death sound
	precache_sound ("sleeper/sleepdeath5.wav"); // Sleeper's fifth (and last) pain sound
	// SLEEPER (Quake 2 stuff)
	precache_sound ("sleeper/pain100_1.wav"); // Sleeper first (skill 5) pain sound when between 125 and 75 health
	precache_sound ("sleeper/pain100_2.wav"); // Sleeper second (skill 5) pain sound when between 125 and 75 health
	precache_sound ("sleeper/pain75_1.wav"); // Sleeper first (skill 5) pain sound when between 74 and 51 health
	precache_sound ("sleeper/pain75_2.wav"); // Sleeper first (skill 5) pain sound when between 74 and 51 health
	precache_sound ("sleeper/pain50_1.wav"); // Sleeper first (skill 5) pain sound when between 50 and 26 health
	precache_sound ("sleeper/pain50_2.wav"); // Sleeper first (skill 5) pain sound when between 50 and 26 health
	precache_sound ("sleeper/pain25_1.wav"); // Sleeper first (skill 5) pain sound when between 25 and 1 health
	precache_sound ("sleeper/pain25_2.wav"); // Sleeper first (skill 5) pain sound when between 25 and 1 health
	
	// VENOM
	precache_model ("progs/player_venom.mdl"); // player Venom model
	precache_sound ("venom/axhit2.wav"); // Venom's axe sound for hitting something living
	precache_sound ("venom/axhitwall.wav"); // Venom's axe sound for hitting the wall
	precache_sound ("player/splat1.wav");
	
	// DOOMGUY (Quake 1 stuff)
	precache_model ("progs/player_doomguy.mdl"); // player Doomguy model
	precache_model ("progs/h_player_doomguy.mdl"); // player Doomguy model
	precache_model ("progs/v_punch.mdl"); // player Doomguy model
	precache_sound ("doomguy/doomjump.wav"); // Doomguy's silent jumping sound
	precache_sound ("doomguy/doomland.wav"); // Doomguy's landing sound
	precache_sound ("doomguy/doomland2.wav"); // Doomguy's cratering sound
	precache_sound ("doomguy/doomdeath1.wav"); // Doomguy's first death sound
	precache_sound ("doomguy/doomdeath2.wav"); // Doomguy's second death sound
	precache_sound ("doomguy/doomdeath3.wav"); // Doomguy's third death sound
	precache_sound ("doomguy/doomdeath4.wav"); // Doomguy's fourth death sound
	precache_sound ("doomguy/doomdeath5.wav"); // Doomguy's fifth (and last) death sound
	precache_sound ("doomguy/doompain.wav"); // Doomguy's "standard" pain sound
	precache_sound ("doomguy/dspunch.wav"); // Doomguy's melee hit sound
	// DOOMGUY (Quake 2 stuff)
	precache_sound ("doomguy/pain100_1.wav");
	precache_sound ("doomguy/pain100_2.wav");
	precache_sound ("doomguy/pain75_1.wav");
	precache_sound ("doomguy/pain75_2.wav");
	precache_sound ("doomguy/pain50_1.wav");
	precache_sound ("doomguy/pain50_2.wav");
	precache_sound ("doomguy/pain25_1.wav");

	// SCALEBEARER
	precache_model("progs/player_scalebearer.mdl"); // player Scalebearer model
	precache_model("progs/h_player_scalebearer.mdl"); // gib model
	precache_model("progs/v_gaunt.mdl"); // gauntlet view model
	precache_sound("weapons/gauntshot.wav");	
	precache_sound("scale/scalejump.wav"); precache_sound("scale/scaleland.wav"); precache_sound("scale/scaleland2.wav");
	precache_sound("scale/scalepain1.wav"); precache_sound("scale/scalepain2.wav"); precache_sound("scale/scalepain3.wav"); precache_sound("scale/scalepain4.wav");
	precache_sound("scale/scaledeath1.wav"); precache_sound("scale/scaledeath2.wav"); precache_sound("scale/scaledeath3.wav");
	precache_sound("scale/scalegasp1.wav"); precache_sound("scale/scalegasp2.wav");
	
	// SORLAG
	precache_model ("progs/player_sorlag.mdl"); // player Sorlag model
	precache_model("progs/h_player_sorlag.mdl"); // gib model
	precache_model("progs/v_sorclaw.mdl"); // Sorlag melee model
	precache_sound("demon/dhit2.wav"); precache_sound("sorlag/sorjump.wav"); precache_sound("sorlag/sorland.wav"); precache_sound("sorlag/sorland2.wav");
	precache_sound("sorlag/sorpain1.wav"); precache_sound("sorlag/sorpain2.wav"); precache_sound("sorlag/sorpain3.wav"); precache_sound("sorlag/sorpain4.wav");
	precache_sound("sorlag/sordeath1.wav"); precache_sound("sorlag/sordeath2.wav"); precache_sound("sorlag/sordeath3.wav");
	precache_sound("sorlag/sorgasp1.wav"); precache_sound("sorlag/sorgasp2.wav");	
	
	// DUKE NUKEM
	precache_model ("progs/player_dukenukem.mdl");	// player Duke model
	precache_model ("progs/player_olddukenukem.mdl");	// Duke Nukem 1 skin model
	precache_model ("progs/h_player_dukenukem.mdl");	// gib model
	precache_model ("progs/v_mfoot.mdl");	// Duke melee view model
	precache_sound ("duke/kickhit.wav"); // Melee sound
	precache_sound ("duke/jetpaki.wav"); // Jetpack idle
	precache_sound ("duke/jetpakof.wav"); // Jetpack end
	precache_sound ("duke/jump.wav");precache_sound ("duke/land02.wav");precache_sound ("duke/land2.wav");
	precache_sound ("duke/pain2.wav");precache_sound ("duke/pain3.wav");precache_sound ("duke/pain5.wav");precache_sound ("duke/pain6.wav");
	precache_sound ("duke/pain7.wav");precache_sound ("duke/pain8.wav");
	precache_sound ("duke/dmdeath.wav");precache_sound ("duke/dscrem2.wav");precache_sound ("duke/dscrem3.wav");precache_sound ("duke/dscrem1.wav");
	precache_sound ("duke/dscrem4.wav");precache_sound ("duke/dscrem5.wav");precache_sound ("duke/dscrem6.wav");
	precache_sound ("duke/gasps.wav");precache_sound ("duke/drown1.wav");precache_sound ("duke/drown2.wav");precache_sound ("duke/chokn.wav");
	precache_sound ("duke/nokeycard.wav"); precache_sound ("duke/falldeath.wav"); precache_sound ("duke/seemydickfromhere.wav");
	// Start Map
	precache_sound ("duke/wthplc.wav");
	precache_sound ("duke/stormgates.wav");
	precache_sound ("duke/wherami.wav");precache_sound ("duke/hell90s.wav");precache_sound ("duke/romero.wav");precache_sound ("duke/betduke.wav");
	precache_sound ("duke/chew.wav");precache_sound ("duke/blowshitup.wav");precache_sound ("duke/cokrok.wav");precache_sound ("duke/wansom.wav");
	// Respawn
	precache_sound ("duke/cry.wav");precache_sound ("duke/kicka.wav");precache_sound ("duke/pissin.wav");precache_sound ("duke/rip.wav");
	precache_sound ("duke/smackdb.wav");precache_sound ("duke/yohoho2.wav");precache_sound ("duke/nothink.wav");precache_sound ("duke/mthrfkr.wav");
	// Devastator
	precache_sound ("duke/dance.wav");precache_sound ("duke/letgod.wav");precache_sound ("duke/gotmilk.wav");precache_sound ("duke/hehehe.wav");
	precache_sound ("duke/timetokill.wav");precache_sound ("duke/arrivederci.wav");precache_sound ("duke/ihop.wav");precache_sound ("duke/gunguy.wav");
	precache_sound ("duke/mod.wav");
	// Killed an opponent
	precache_sound ("duke/aisle.wav");precache_sound ("duke/amess.wav");precache_sound ("duke/bitchn.wav");precache_sound ("duke/blowit.wav");
	precache_sound ("duke/bookem.wav");precache_sound ("duke/cool.wav");precache_sound ("duke/damn.wav");precache_sound ("duke/getsom.wav");
	precache_sound ("duke/gmeovr.wav");precache_sound ("duke/gothrt.wav");precache_sound ("duke/groovy.wav");precache_sound ("duke/hail.wav");
	precache_sound ("duke/holysh.wav");precache_sound ("duke/imgood.wav");precache_sound ("duke/inhell.wav");precache_sound ("duke/letsrk.wav");
	precache_sound ("duke/lookin.wav");precache_sound ("duke/meat.wav");precache_sound ("duke/name.wav");precache_sound ("duke/nobody.wav"); 
	precache_sound ("duke/piece.wav");precache_sound ("duke/slacker.wav");precache_sound ("duke/sukitdn.wav");precache_sound ("duke/bos.wav");
	precache_sound ("duke/rokrol.wav");precache_sound ("duke/betduke2.wav");precache_sound ("duke/huckleberry.wav");precache_sound ("duke/itsgood.wav");
	precache_sound ("duke/ripieces.wav");precache_sound ("duke/oneking.wav");precache_sound ("duke/fragged.wav");precache_sound ("duke/trd.wav");
	// Melee kills
	precache_sound ("duke/footface.wav");precache_sound ("duke/stomped.wav");precache_sound ("duke/bloodboot.wav");precache_sound ("duke/bug.wav");
	// Opponent specific kill messages
	precache_sound ("duke/myself.wav");precache_sound ("duke/realthing.wav");precache_sound ("duke/kickmyass.wav"); // DUKE
	precache_sound ("duke/quake.wav");precache_sound ("duke/teleport.wav"); // RANGER, SHUB
	precache_sound ("duke/doomedsm.wav"); // DOOM SLAYER
	precache_sound ("duke/scrapyard.wav"); // STROGG, CLUTCH
	precache_sound ("duke/allbizbabe.wav"); // NYX, GALENA, ATHENA, SORLAG
	precache_sound ("duke/crowbar.wav"); // GORDON FREEMAN
	precache_sound ("duke/pwrarmr.wav"); // MASTER CHIEF
	precache_sound ("duke/dukesentya.wav"); // CTHON, DEATH KNIGHT
	
	// CALEB
	precache_model("progs/player_caleb.mdl"); precache_model("progs/h_player_caleb.mdl"); // precache_model("progs/lifeessence.mdl");
	precache_model("progs/v_pfork.mdl"); // precache_model("progs/v_dynamite.mdl"); precache_model("progs/w_dynamite.mdl");
	precache_sound("caleb/meleeflesh.wav"); precache_sound("caleb/meleewall.wav"); precache_sound("caleb/jump.wav"); precache_sound("caleb/land.wav"); precache_sound("caleb/land2.wav"); 
	precache_sound("caleb/pain1.wav"); precache_sound("caleb/pain2.wav"); precache_sound("caleb/pain3.wav"); precache_sound("caleb/pain4.wav"); precache_sound("caleb/pain5.wav"); precache_sound("caleb/pain6.wav"); 
	precache_sound("caleb/death1.wav"); precache_sound("caleb/death2.wav"); precache_sound("caleb/death3.wav"); precache_sound("caleb/death4.wav"); precache_sound("caleb/death5.wav"); precache_sound("caleb/h2odeath.wav"); 
	precache_sound("caleb/agony.wav"); precache_sound("caleb/burn1.wav"); precache_sound("caleb/burn2.wav"); precache_sound("caleb/gasp.wav"); precache_sound("caleb/drown1.wav"); precache_sound("caleb/drown2.wav"); 
	// Abilities
//	precache_sound("caleb/lifeessence.wav"); precache_sound("caleb/dynalight.wav"); precache_sound("caleb/dynafuse.wav"); precache_sound("caleb/dynatoss.wav"); 
	// Bosses
	precache_sound("caleb/extrabad.wav"); precache_sound("caleb/thatsallfolks.wav"); precache_sound("caleb/shebitch.wav"); precache_sound("caleb/dingdong.wav");
	// Spawn
	precache_sound("caleb/liveagain.wav"); precache_sound("caleb/putdown.wav"); precache_sound("caleb/alldead.wav"); precache_sound("caleb/comeout.wav"); precache_sound("caleb/donateblood.wav"); 
	precache_sound("caleb/business.wav"); precache_sound("caleb/promisesfun.wav"); precache_sound("caleb/sweethome.wav"); precache_sound("caleb/sweetsuffering.wav");
	// Frags
	precache_sound("caleb/arf.wav"); precache_sound("caleb/playdead.wav"); precache_sound("caleb/lambs.wav"); precache_sound("caleb/heresjohnny.wav"); precache_sound("caleb/faceoff.wav"); precache_sound("caleb/bleedonme.wav"); 
	precache_sound("caleb/fleshcooked.wav"); precache_sound("caleb/boomstick.wav"); precache_sound("caleb/shotgun.wav"); precache_sound("caleb/hatemimes.wav"); 
	precache_sound("caleb/alreadydead.wav"); precache_sound("caleb/amateurs.wav"); precache_sound("caleb/anothercorpse.wav"); precache_sound("caleb/cackle1.wav"); precache_sound("caleb/cackle2.wav"); 
	precache_sound("caleb/cackle3.wav"); precache_sound("caleb/coagulate.wav"); precache_sound("caleb/dontwaste.wav"); precache_sound("caleb/downhatch.wav"); precache_sound("caleb/endline.wav"); 
	precache_sound("caleb/faith.wav"); precache_sound("caleb/freshvictims.wav"); precache_sound("caleb/goodway.wav"); precache_sound("caleb/guywithgun.wav"); precache_sound("caleb/hurtingstop.wav"); 
	precache_sound("caleb/insects.wav"); precache_sound("caleb/laugh1.wav"); precache_sound("caleb/laugh2.wav"); precache_sound("caleb/laugh3.wav"); precache_sound("caleb/letsdoit.wav"); 
	precache_sound("caleb/lookedbetter.wav"); precache_sound("caleb/nevermore.wav"); precache_sound("caleb/nightnight.wav"); precache_sound("caleb/notnice.wav"); precache_sound("caleb/reflexes.wav"); 
	precache_sound("caleb/rip.wav"); precache_sound("caleb/standandbleed.wav"); precache_sound("caleb/strangers.wav"); precache_sound("caleb/sunshine.wav"); precache_sound("caleb/whosnext.wav"); 
	precache_sound("caleb/teachya.wav"); precache_sound("caleb/timetoplay.wav"); precache_sound("caleb/tipperary.wav"); precache_sound("caleb/train.wav"); precache_sound("caleb/shakeit.wav");
	precache_sound("caleb/undermyskin.wav"); precache_sound("caleb/victims.wav"); precache_sound("caleb/whoslaughing.wav"); precache_sound("caleb/notlookinatyou.wav");
	// Items
	precache_sound("caleb/weapon.wav"); precache_sound("caleb/rocket.wav"); precache_sound("caleb/railgun.wav"); 
	precache_sound("caleb/quad.wav"); precache_sound("caleb/everybodydies.wav"); precache_sound("caleb/tada.wav"); precache_sound("caleb/sigil.wav"); 	
	
	// DUSK DUDE
	precache_model("progs/player_dusk.mdl");
	precache_model("progs/h_player_dusk.mdl");
	precache_model("progs/v_sickles.mdl");
	precache_sound("dusk/jump.wav"); precache_sound("dusk/land.wav"); precache_sound("dusk/land02.wav");
	precache_sound("dusk/damage.wav"); precache_sound("dusk/death.wav");
	precache_sound("dusk/sicklestart.wav"); precache_sound("dusk/sickleslice.wav");	
	precache_sound("silence.wav");
};
		
/*
======================================================
Character SPAWNING
======================================================
*/

/*
// checks if a box isn't inside any solid
// returns 1 if area is clear, 0 if not
float(vector org, vector minbbox, vector maxbbox) isClear = 
{
	local entity e = spawn();
	e.movetype = MOVETYPE_TOSS;
	setorigin(e, org);
	setsize(e, minbbox, maxbbox);

// 	droptofloor() returns false if the drop distance is more than 256
// 	and that's indistinguishable from a solid check.
// 	So we need to put another entity below as a stopper so droptofloor
//	will always return true if there's room
 
	entity e2 = spawn();
	e2.solid = SOLID_BBOX;
    
// 	slightly below the test box's lower bound
 
	setorigin(e2, e.origin + [0, 0, minbbox_z - 4]);
	setsize(e2, [minbbox_x, minbbox_y, -1], [maxbbox_x, maxbbox_y, 1]);

	local entity oldself = self;
	self = e;
        
	local float ret = droptofloor();

	self = oldself;

	remove (e);
	remove (e2);

	return ret;
};
*/

.float donttelefrag; // Don't need to accidentally telefrag players when changing player models. Simple hack.
void() NQW_SpawnCharacter = 
{
	self.nqwSpeakSpawn = SUB_Null;
	self.nqwSpeakFrag = NQW_SpeakFragNull;
	self.nqwSpeakItem = NQW_SpeakItemNull;
	self.nqwSpeakCthonGreet = string_null;
	self.nqwSpeakCthonKill = string_null;
	self.nqwSpeakShubGreet = string_null;
	self.nqwSpeakShubKill = string_null;	
		
	switch (self.nqwNextCharacter) 
	{
		case NQW_RANGER: NQW_Ranger(); break;
		case NQW_SLEEPER: NQW_Sleeper(); break;
		case NQW_VENOM: NQW_Venom(); break;
		case NQW_DOOMGUY: NQW_Doomguy(); break;
		case NQW_SCALEBEARER: NQW_Scalebearer(); break;
		case NQW_SORLAG: NQW_Sorlag(); break;
		case NQW_DUKENUKEM: NQW_DukeNukem(); break;
		case NQW_CALEB: NQW_Caleb(); break;
		case NQW_DUSKDUDE: NQW_DuskDude(); break;
		default: NQW_Ranger(); break;
	}	
	
	setmodel (self, self.nqwMdlChar);			
	self.modelindex_nqwplayer = self.modelindex;
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.nqwCharacter = self.nqwNextCharacter;
	player_stand1 ();
	if (!self.spectator && !self.donttelefrag) spawn_tdeath (self.origin, self);
	
	if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF && !coop)
	{	
		if (self.team == TEAM1) self.skin = 1;
		if (self.team == TEAM2) self.skin = 2;			
	}
		
	// If starter health is over max health, add a deflate flag.					
	if (self.health > self.max_health) self.health_deflate = 1;
	else if (self.health <= self.max_health) self.health_deflate = 0;	
		
	// To make sure armors don't rot beyond their intended limits on a spawn/respawn in skill 5 when you have an armor that came from a previous map.
	if (cvar("skill") == 5 && !deathmatch)
	{
		if (self.items & IT_ARMOR1) 	 // Jacket Armor
		{
			self.armortype = 0.15;
			self.max_armorvalue = 50;
			self.fake_armortype = 0.3;
			if (self.armorvalue > self.max_armorvalue / 2) self.armorrottime = time + 5; // Wait 6.66 seconds before rotting the excess armor away after a respawn.
		}
		else if (self.items & IT_ARMOR2) // Combat Armor
		{
			self.armortype = 0.19;
			self.max_armorvalue = 100;
			self.fake_armortype = 0.6;
			if (self.armorvalue > self.max_armorvalue / 2) self.armorrottime = time + 5; // Wait 6.66 seconds before rotting the excess armor away after a respawn.			
		}
		else if (self.items & IT_ARMOR3) // Heavy Armor
		{
			self.armortype = 0.245;
			self.max_armorvalue = 150;
			self.fake_armortype = 0.8;
			if (self.armorvalue > self.max_armorvalue / 2) self.armorrottime = time + 5; // Wait 6.66 seconds before rotting the excess armor away after a respawn.			
		}
	}
	else // Skill 4 and below, and deathmatch is not needed, but it's good to add for consistency.
	{
		if (self.items & IT_ARMOR1) 	 // Green Armor
		{
			self.armortype = 0.3;
			self.fake_armortype = 0.3;
			self.max_armorvalue = 100;
		}
		else if (self.items & IT_ARMOR2) // Yellow Armor
		{
			self.armortype = 0.6;
			self.fake_armortype = 0.6;
			self.max_armorvalue = 150;
		}
		else if (self.items & IT_ARMOR3) // Red Armor
		{
			self.armortype = 0.8;
			self.fake_armortype = 0.8;
			self.max_armorvalue = 200;
		}
	}
	
	self.donttelefrag = 0;	
	W_SetCurrentAmmo ();			
	self.nqwSpeakSpawn ();			
};

void() NQW_PickCharacter =
{
	if (self.nqwNextCharacter == NQW_RANGER)
	{
		self.nqwNextCharacter = NQW_SLEEPER;
		if (deathmatch) sprint (self, "", "Changed player model to Sleeper\n");
		else id1_centerprint (self, "You are now \nSleeper, Son Of Spyro\n");
	}
	else if (self.nqwNextCharacter == NQW_SLEEPER)
	{
		self.nqwNextCharacter = NQW_VENOM;
		if (deathmatch) sprint (self, "", "Changed player model to Venom\n");
		else id1_centerprint (self, "You are now Venom\n");
	}
	else if (self.nqwNextCharacter == NQW_VENOM)
	{
		self.nqwNextCharacter = NQW_DOOMGUY;
		if (deathmatch) sprint (self, "", "Changed player model to Doomguy\n");
		else id1_centerprint (self, "You are now Doomguy\n");
	}
	else if (self.nqwNextCharacter == NQW_DOOMGUY)	
	{
		self.nqwNextCharacter = NQW_SCALEBEARER;
		if (deathmatch) sprint (self, "", "Changed player model to Scalebearer\n");
		else id1_centerprint (self, "You are now Scalebearer\n");
	}		
	else if (self.nqwNextCharacter == NQW_SCALEBEARER)
	{
		self.nqwNextCharacter = NQW_SORLAG;
		if (deathmatch) sprint (self, "", "Changed player model to Sorlag\n");
		else id1_centerprint (self, "You are now Sorlag\n");
	}
	else if (self.nqwNextCharacter == NQW_SORLAG)
	{
		self.nqwNextCharacter = NQW_DUKENUKEM;
		if (deathmatch) sprint (self, "", "Changed player model to Duke Nukem\n");
		else id1_centerprint (self, "You are now Duke Nukem\n");
	}
	else if (self.nqwNextCharacter == NQW_DUKENUKEM)
	{
		self.nqwNextCharacter = NQW_CALEB;
		if (deathmatch) sprint (self, "", "Changed player model to Caleb\n");
		else id1_centerprint (self, "You are now Caleb\n");
	}	
	else if (self.nqwNextCharacter == NQW_CALEB)
	{
		self.nqwNextCharacter = NQW_DUSKDUDE;
		if (deathmatch) sprint (self, "", "Changed player model to The Intruder\n");
		else id1_centerprint (self, "You are now The Intruder\n");
	}			
	else
	{
		self.nqwNextCharacter = NQW_RANGER;
		if (deathmatch) sprint (self, "", "Changed player model to Ranger\n");
		else id1_centerprint (self, "You are now Ranger\n");
	}
				
//	if (coop < 5 || deathmatch) NQW_SpawnCharacter ();
	self.donttelefrag = 1;
	NQW_SpawnCharacter ();
};


void(float max_skins) NQW_SetSkin =
{	
	if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF) // Sleeper: Enforce for TDM, CTF, OneFlag.
	{
		     if (self.team == TEAM1) self.skin = 1;
		else if (self.team == TEAM2) self.skin = 2;
		self.nqwSkin = self.skin;
	}
	else
	{		
		self.nqwMaxSkins = max_skins;
		self.skin = self.nqwSkin;
	}
	
//	self.nqwSkin = self.nqwSkin % self.nqwMaxSkins;
	// Team play sets skins accordingly; Most engines automatically set team based upon pants color	
//	if (deathmatch >= 3 && deathmatch <= 5 && teamplay >= 1 && self.steam >= 0)
//		self.skin = self.steam % self.nqwMaxSkins;

	// Doomguy on Green Team should be green, not black
//	if (deathmatch >= 3 && deathmatch <= 5 && self.nqwCharacter == NQW_DOOMGUY && self.team == 4)
//		self.skin = 0;

	// In the remaster, non-team modes set Team to -1, so we'll keep track of skins a a different way as a fallback
//	else self.skin = self.nqwSkin;
};

// Called by impulse 137
void() NQW_SwapSkin = 
{
	if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF) 
	{
		sprint (self, "You can't swap skins in Team Modes!\n");
		return; // Don't change skins in TDM, CTF and OneFlag
	}
		
	self.nqwSkin += 1;
	if (self.nqwSkin >= self.nqwMaxSkins) self.nqwSkin = self.nqwSkin % self.nqwMaxSkins;
	self.skin = self.nqwSkin;
	
	if (self.skin == 0) sprint (self, "", "Changed Skin to Default\n");
	
	if (self.nqwCharacter == NQW_RANGER)
	{
		     if (self.skin == 1) sprint (self, "", "Changed Skin to Red/Black\n");
		else if (self.skin == 2) sprint (self, "", "Changed Skin to Blue/Purple\n");
		else if (self.skin == 3) sprint (self, "", "Changed Skin to Yellow/Green\n");
		else if (self.skin == 4) sprint (self, "", "Changed Skin to Black/Blue\n");
		else if (self.skin == 5) sprint (self, "", "Changed Skin to White/Black\n"); 
		else if (self.skin == 6) sprint (self, "", "Changed Skin to Gold/Blue\n");
	}
	else if (self.nqwCharacter == NQW_DOOMGUY)
	{
		     if (self.skin == 1) sprint (self, "", "Changed Skin to Red\n");
		else if (self.skin == 2) sprint (self, "", "Changed Skin to Blue\n");
		else if (self.skin == 3) sprint (self, "", "Changed Skin to Brown\n");	
		else if (self.skin == 4) sprint (self, "", "Changed Skin to Black\n");
	}
	else if (self.nqwCharacter == NQW_SCALEBEARER)	
	{
		     if (self.skin == 1) sprint (self, "", "Changed Skin to Red\n");
		else if (self.skin == 2) sprint (self, "", "Changed Skin to Blue\n");
		else if (self.skin == 3) sprint (self, "", "Changed Skin to Orange/Yellow\n");	
		else if (self.skin == 4) sprint (self, "", "Changed Skin to Green\n");
	}
	else if (self.nqwCharacter == NQW_SORLAG)
	{
		     if (self.skin == 1) sprint (self, "", "Changed Skin to Red\n");
		else if (self.skin == 2) sprint (self, "", "Changed Skin to Blue\n");
		else if (self.skin == 3) sprint (self, "", "Changed Skin to Orange\n");	
		else if (self.skin == 4) sprint (self, "", "Changed Skin to Green\n");
	}
	else if (self.nqwCharacter == NQW_DUKENUKEM)
	{
		     if (self.skin == 1) sprint (self, "", "Changed Skin to Red/Blue\n");	
		else if (self.skin == 2) sprint (self, "", "Changed Skin to Blue/Black\n");
		else if (self.skin == 3) sprint (self, "", "Changed Skin to Yellow/Black\n");	
		else if (self.skin == 4) sprint (self, "", "Changed Skin to Green/Purple\n");
		else if (self.skin == 5) sprint (self, "", "Changed Skin to Black/Blue\n");
		else if (self.skin == 6) sprint (self, "", "Changed Skin to Pink/Blue\n");
	}
	else if (self.nqwCharacter == NQW_CALEB)
	{
		     if (self.skin == 1) sprint (self, "", "Changed Skin to Red/Black\n");
		else if (self.skin == 2) sprint (self, "", "Changed Skin to Blue/Brown\n");
		else if (self.skin == 3) sprint (self, "", "Changed Skin to Gold/Black\n");
		else if (self.skin == 4) sprint (self, "", "Changed Skin to Green/Brown\n");
		else if (self.skin == 5) sprint (self, "", "Changed Skin to Alt\n");
	}
	else if (self.nqwCharacter == NQW_DUSKDUDE)
	{
		     if (self.skin == 1) sprint (self, "", "Changed Skin to Red/Blue\n");	
		else if (self.skin == 2) sprint (self, "", "Changed Skin to Black/White\n");
		else if (self.skin == 3) sprint (self, "", "Changed Skin to Yellow/Black\n");	
		else if (self.skin == 4) sprint (self, "", "Changed Skin to Green\n");	
		else if (self.skin == 5) sprint (self, "", "Changed Skin to Alt\n");
	}																
															
//	sprint(self, "", "Changed Skin to ", ftos(self.skin), "\n");
};

void() respawn;

void() NQW_RedTeam =
{
	if (self.steam == TEAM1) 
	{
		sprint (self, "You are already on the RED Team!\n");
		return;
	}
	if (deathmatch != DM_TDM && deathmatch != DM_CTF && deathmatch != DM_OneFlagCTF)
	{
		sprint (self, "You must be in TDM, CTF, or One Flag CTF to join Team RED!\n");
		return;
	}	
	
	blueteam--;
	redteam++;
	TeamDropFlagOfPlayer (self); // Drop of the flag
	self.frags = 0; // Reset frags.
	self.team = TEAM1;
	stuffcmd (self, "color 4\n");
	self.nqwSkin = 1;	
	
	// There's no blue skin yet for Sleeper
	if (self.nqwCharacter == NQW_SLEEPER) self.nqwSkin = 0;
		
	self.skin = self.nqwSkin;	
	
	bprint (self.netname, " joined Team RED\n");
	PutClientInServer ();
};

void() NQW_BlueTeam =
{
	if (self.steam == TEAM2)
	{
		sprint (self, "You are already on the BLUE Team!\n");
		return;
	}	
	if (deathmatch != DM_TDM && deathmatch != DM_CTF && deathmatch != DM_OneFlagCTF)
	{
		sprint (self, "You must be in TDM, CTF, or One Flag CTF to join Team BLUE!\n");
		return;
	}	
	
	redteam--;
	blueteam++;
	TeamDropFlagOfPlayer (self); // Drop of the flag
	self.frags = 0; // Reset frags.
	self.team = TEAM2;	
	stuffcmd (self, "color 13\n");
	self.nqwSkin = 2;
		
	self.skin = self.nqwSkin;		
	
	bprint (self.netname, " joined Team BLUE\n");
	PutClientInServer ();
};