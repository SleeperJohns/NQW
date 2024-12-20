/*
======================================================
NQW: Ranger
======================================================
*/

void() NQW_Ranger =
{
	// Player Model
	setmodel (self, "progs/player_ranger.mdl");    // Ranger's Player Model
	self.nqwCharGib = "progs/h_player.mdl";        // Ranger's Head when gibbed
	
	// Melee Weapon Models
	self.nqwMeleeMdl = "progs/v_axe.mdl";	       // Ranger's Bloodstained Axe (Melee weapon)
	self.nqwHammerMdl = "progs/v_hammer.mdl";      // Mjolnir (Thor's Hammer)
	
	// Max Skins
	NQW_SetSkin(7);	
	
	// Melee Sounds
	self.nqwSndMelee = "weapons/ax1.wav";	       // The sound of the axe hitting another player
	self.nqwSndMeleeHit = "ranger/axhit.wav";      // The sound of the axe hitting something living
	self.nqwSndMeleeWall = "ranger/axhit2.wav";    // The sound of the axe hitting the wall
	
	// Jump and landing sounds
	self.nqwSndJump      = "ranger/rangerjump.wav";     // The famous "HUUH" sound of Ranger
	self.nqwSndLand1     = "ranger/rangerland.wav";    // Safe land sound
	self.nqwSndLand2     = "ranger/rangerland2.wav";   // Cratered sound
	self.nqwSndFallDeath = "player/splat1.wav";
	
	// Ranger's Quake 1-style pain sounds
	self.nqwSndQ1Pain1 = "ranger/rangerpain1.wav";
	self.nqwSndQ1Pain2 = "ranger/rangerpain2.wav";
	self.nqwSndQ1Pain3 = "ranger/rangerpain3.wav";
	self.nqwSndQ1Pain4 = "ranger/rangerpain4.wav";
	self.nqwSndQ1Pain5 = "ranger/rangerpain5.wav";
	self.nqwSndQ1Pain6 = "ranger/rangerpain6.wav";
	
	// Ranger's Quake 2-style pain sounds	
	self.nqwSndQ2Pain1 = "ranger/rangerpain1.wav";
	self.nqwSndQ2Pain2 = "ranger/rangerpain2.wav";
	self.nqwSndQ2Pain3 = "ranger/rangerpain3.wav";
	self.nqwSndQ2Pain4 = "ranger/rangerpain4.wav";
	self.nqwSndQ2Pain5 = "ranger/rangerpain5.wav";
	self.nqwSndQ2Pain6 = "ranger/rangerpain6.wav";
	self.nqwSndQ2Pain7 = "ranger/rangerpain5.wav";
	self.nqwSndQ2Pain8 = "ranger/rangerpain6.wav";
	
	// Ranger's Hazard and Death sounds		
	self.nqwSndDeath1 = "ranger/rangerdeath1.wav";
	self.nqwSndDeath2 = "ranger/rangerdeath2.wav";
	self.nqwSndDeath3 = "ranger/rangerdeath3.wav";
	self.nqwSndDeath4 = "ranger/rangerdeath4.wav";
	self.nqwSndDeath5 = "ranger/rangerdeath5.wav";
	self.nqwSndAxHit1 = "player/axhit1.wav";
	self.nqwSndBurn1 = "player/lburn1.wav";
	self.nqwSndBurn2 = "player/lburn2.wav";
	self.nqwSndGasp1 = "player/gasp1.wav";
	self.nqwSndGasp2 = "player/gasp2.wav";
	self.nqwSndDrown1 = "player/drown1.wav";
	self.nqwSndDrown2 = "player/drown2.wav";
	self.nqwSndH2oDeath = "player/h2odeath.wav";
};