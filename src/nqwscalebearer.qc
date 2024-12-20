/*
======================================================
NQW: SCALEBEARER
======================================================
*/
/*
void() NQW_ScalebearerPrecache =
{
	precache_model ("progs/player_scalebearer.mdl"); // player Dusk model
}
*/

void() NQW_Scalebearer =
{
	// Model
	setmodel (self, "progs/player_scalebearer.mdl");
	self.nqwCharGib = "progs/h_player_scalebearer.mdl";
	self.nqwMeleeMdl = "progs/v_gaunt.mdl";
	self.nqwHammerMdl = "progs/v_hammer.mdl";
	NQW_SetSkin(5);
	self.nqwGibSkins = self.nqwMaxSkins;
	// Sounds
	self.nqwSndMelee = "weapons/gauntshot.wav";
	self.nqwSndMeleeHit = "";
	self.nqwSndMeleeWall = "player/axhit2.wav";
	self.nqwSndJump = "scale/scalejump.wav";
	self.nqwSndLand1 = "scale/scaleland.wav";
	self.nqwSndLand2 = "scale/scaleland2.wav";
	self.nqwSndFallDeath = "player/splat1.wav";	
	
	// Quake 1 style pain sounds
	self.nqwSndQ1Pain1 = "scale/scalepain1.wav";
	self.nqwSndQ1Pain2 = "scale/scalepain2.wav";
	self.nqwSndQ1Pain3 = "scale/scalepain2.wav";
	self.nqwSndQ1Pain4 = "scale/scalepain3.wav";
	self.nqwSndQ1Pain5 = "scale/scalepain3.wav";
	self.nqwSndQ1Pain6 = "scale/scalepain4.wav";
		
	// Quake 2 style pain sounds	
	self.nqwSndQ2Pain1 = "scale/scalepain1.wav";
	self.nqwSndQ2Pain2 = "scale/scalepain1.wav";
	self.nqwSndQ2Pain3 = "scale/scalepain2.wav";
	self.nqwSndQ2Pain4 = "scale/scalepain2.wav";
	self.nqwSndQ2Pain5 = "scale/scalepain3.wav";
	self.nqwSndQ2Pain6 = "scale/scalepain3.wav";
	self.nqwSndQ2Pain7 = "scale/scalepain4.wav";
	self.nqwSndQ2Pain8 = "scale/scalepain4.wav";
					
	self.nqwSndDeath1 = "scale/scaledeath1.wav";
	self.nqwSndDeath2 = "scale/scaledeath2.wav";
	self.nqwSndDeath3 = "scale/scaledeath3.wav";
	self.nqwSndDeath4 = "scale/scaledeath2.wav";
	self.nqwSndDeath5 = "scale/scaledeath3.wav";
	self.nqwSndAxHit1 = "scale/scalepain4.wav";
	self.nqwSndBurn1 = "scale/scalepain4.wav";
	self.nqwSndBurn2 = "scale/scalepain4.wav";
	self.nqwSndGasp1 = "scale/scalegasp1.wav";
	self.nqwSndGasp2 = "scale/scalegasp2.wav";
	self.nqwSndDrown1 = "player/drown1.wav";
	self.nqwSndDrown2 = "player/drown1.wav";
	self.nqwSndH2oDeath = "player/h2odeath.wav";
	self.nqwSndFalling = "";
};