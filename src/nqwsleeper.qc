/*
======================================================
NQW: SLEEPER
======================================================
*/

void() NQW_Sleeper =
{
	// Player Model
	self.nqwMdlChar      = "progs/player_sleeper.mdl";    // Sleeper's Player Model
	self.nqwCharGib      = "progs/h_player.mdl";      // Ranger's Head when gibbed (Temporary)
	self.view_ofs 	     = '0 0 22';
	
	// Melee Weapon Models
	self.nqwMeleeMdl     = "progs/v_sleeper_axe.mdl"; // Sleeper's Bloodstained Axe ((Temporary) Melee weapon)
	self.nqwHammerMdl    = "progs/v_hammer.mdl";      // Mjolnir (Thor's Hammer)
	
	// Max Skins
	NQW_SetSkin (1);
	
	// Melee Sounds
	self.nqwSndMelee     = "weapons/ax1.wav";	  // The sound of the axe hitting flesh
	self.nqwSndMeleeHit  = "sleeper/axhit2.wav";      // The sound of the axe hitting something living
	self.nqwSndMeleeWall = "sleeper/axhitwall.wav";   // The sound of the axe hitting the wall
	
	// Jump and landing sounds
	self.nqwSndJump      = "sleeper/sleepjump.wav";	  // Sleeper's "HUUH" sound
	self.nqwSndLand1     = "sleeper/sleepland.wav";	  // Safe land sound
	self.nqwSndLand2     = "sleeper/sleepland2.wav";  // Cratered sound
	self.nqwSndFallDeath = "player/splat1.wav";
	
	// Sleeper's Quake 1-style pain sounds
	self.nqwSndQ1Pain1   = "sleeper/sleeppain1.wav";
	self.nqwSndQ1Pain2   = "sleeper/sleeppain2.wav";
	self.nqwSndQ1Pain3   = "sleeper/sleeppain3.wav";
	self.nqwSndQ1Pain4   = "sleeper/sleeppain4.wav";
	self.nqwSndQ1Pain5   = "sleeper/sleeppain5.wav";
	self.nqwSndQ1Pain6   = "sleeper/sleeppain6.wav";
		
	// Sleeper's Quake 2-style pain sounds	
	self.nqwSndQ2Pain1   = "sleeper/pain100_1.wav";
	self.nqwSndQ2Pain2   = "sleeper/pain100_2.wav";
	self.nqwSndQ2Pain3   = "sleeper/pain75_1.wav";
	self.nqwSndQ2Pain4   = "sleeper/pain75_2.wav";
	self.nqwSndQ2Pain5   = "sleeper/pain50_1.wav";
	self.nqwSndQ2Pain6   = "sleeper/pain50_2.wav";
	self.nqwSndQ2Pain7   = "sleeper/pain25_1.wav";
	self.nqwSndQ2Pain8   = "sleeper/pain25_2.wav";
	
	// Sleeper's Hazard and Death sounds					
	self.nqwSndDeath1    = "sleeper/sleepdeath1.wav";
	self.nqwSndDeath2    = "sleeper/sleepdeath2.wav";
	self.nqwSndDeath3    = "sleeper/sleepdeath3.wav";
	self.nqwSndDeath4    = "sleeper/sleepdeath4.wav";
	self.nqwSndDeath5    = "sleeper/sleepdeath5.wav";
	self.nqwSndAxHit1    = "player/axhit1.wav";       // The sound of the axe hitting another player
	self.nqwSndBurn1     = "player/lburn1.wav";
	self.nqwSndBurn2     = "player/lburn2.wav";
	self.nqwSndGasp1     = "player/gasp1.wav";
	self.nqwSndGasp2     = "player/gasp2.wav";
	self.nqwSndDrown1    = "player/drown1.wav";
	self.nqwSndDrown2    = "player/drown2.wav";
	self.nqwSndH2oDeath  = "player/h2odeath.wav";
	self.nqwSndFalling   = "";
};