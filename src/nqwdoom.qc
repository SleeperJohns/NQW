/*
======================================================
NQW: Doomguy
======================================================
*/
/*
void() NQW_DoomguyPrecache =
{
	precache_model ("progs/player_doomguy.mdl"); // player Doomguy model
}
*/

void() NQW_Doomguy =
{
	// Model
	setmodel (self, "progs/player_doomguy.mdl");
	self.nqwCharGib = "progs/h_player_doomguy.mdl";
	self.nqwMeleeMdl = "progs/v_punch.mdl";
	self.nqwHammerMdl = "progs/v_hammer.mdl";
	NQW_SetSkin(5);
	// Sounds
	self.nqwSndMelee = "weapons/ax1.wav";
	self.nqwSndMeleeHit = "doomguy/dspunch.wav";
	self.nqwSndMeleeWall = "";
	self.nqwSndJump = "doomguy/doomjump.wav";
	self.nqwSndLand1 = "doomguy/doomland.wav";
	self.nqwSndLand2 = "doomguy/doomland2.wav";
	self.nqwSndFallDeath = "player/splat1.wav";	
	
	self.nqwSndQ1Pain1 = "doomguy/doompain.wav";
	self.nqwSndQ1Pain2 = "doomguy/doompain.wav";
	self.nqwSndQ1Pain3 = "doomguy/doompain.wav";
	self.nqwSndQ1Pain4 = "doomguy/doompain.wav";
	self.nqwSndQ1Pain5 = "doomguy/doompain.wav";
	self.nqwSndQ1Pain6 = "doomguy/doompain.wav";

	self.nqwSndQ2Pain1 = "doomguy/pain100_1.wav";
	self.nqwSndQ2Pain2 = "doomguy/pain100_2.wav";
	self.nqwSndQ2Pain3 = "doomguy/pain75_1.wav";
	self.nqwSndQ2Pain4 = "doomguy/pain75_2.wav";
	self.nqwSndQ2Pain5 = "doomguy/pain50_2.wav";
	self.nqwSndQ2Pain6 = "doomguy/pain50_1.wav";
	self.nqwSndQ2Pain7 = "doomguy/pain25_1.wav";
	self.nqwSndQ2Pain8 = "doomguy/pain25_1.wav";

	self.nqwSndDeath1 = "doomguy/doomdeath1.wav";
	self.nqwSndDeath2 = "doomguy/doomdeath2.wav";
	self.nqwSndDeath3 = "doomguy/doomdeath3.wav";
	self.nqwSndDeath4 = "doomguy/doomdeath4.wav";
	self.nqwSndDeath5 = "doomguy/doomdeath5.wav";
	self.nqwSndAxHit1 = "doomguy/doompain.wav";
	self.nqwSndBurn1 = "doomguy/doompain.wav";
	self.nqwSndBurn2 = "doomguy/doompain.wav";
	self.nqwSndGasp1 = "player/gasp1.wav";
	self.nqwSndGasp2 = "player/gasp2.wav";
	self.nqwSndDrown1 = "player/drown1.wav";
	self.nqwSndDrown2 = "player/drown2.wav";
	self.nqwSndH2oDeath = "player/h2odeath.wav";
	self.nqwSndFalling = "";
};