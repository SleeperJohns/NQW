/*
======================================================
NQW: SORLAG
======================================================
*/
/*
void() NQW_SorlagPrecache =
{
	precache_model ("progs/player_sorlag.mdl"); // player Sorlag model
}
*/

void() NQW_Sorlag =
{
	// Model
	self.nqwMdlChar = "progs/player_sorlag.mdl";
//	setsize(self, '-16 -20 -24', '16 20 40');
   	self.view_ofs = '0 0 26';
	self.nqwCharGib = "progs/h_player_sorlag.mdl";
	self.nqwMeleeMdl = "progs/v_sorclaw.mdl";
	self.nqwHammerMdl = "progs/v_hammer.mdl";
	NQW_SetSkin(5);
	// Sounds
	self.nqwSndMelee = "weapons/ax1.wav";
	self.nqwSndMeleeHit = "demon/dhit2.wav";
	self.nqwSndMeleeWall = "player/axhit2.wav";
	self.nqwSndJump = "sorlag/sorjump.wav";
	self.nqwSndLand1 = "sorlag/sorland.wav";
	self.nqwSndLand2 = "sorlag/sorland2.wav";
	self.nqwSndFallDeath = "player/splat1.wav";
	
	// Quake 1 style pain sounds
	self.nqwSndQ1Pain1 = "sorlag/sorpain1.wav";
	self.nqwSndQ1Pain2 = "sorlag/sorpain2.wav";
	self.nqwSndQ1Pain3 = "sorlag/sorpain2.wav";
	self.nqwSndQ1Pain4 = "sorlag/sorpain3.wav";
	self.nqwSndQ1Pain5 = "sorlag/sorpain3.wav";
	self.nqwSndQ1Pain6 = "sorlag/sorpain4.wav";
	
	// Quake 2 style pain sounds	
	self.nqwSndQ2Pain1 = "sorlag/sorpain1.wav";
	self.nqwSndQ2Pain2 = "sorlag/sorpain1.wav";
	self.nqwSndQ2Pain3 = "sorlag/sorpain2.wav";
	self.nqwSndQ2Pain4 = "sorlag/sorpain2.wav";
	self.nqwSndQ2Pain5 = "sorlag/sorpain3.wav";
	self.nqwSndQ2Pain6 = "sorlag/sorpain3.wav";
	self.nqwSndQ2Pain7 = "sorlag/sorpain4.wav";
	self.nqwSndQ2Pain8 = "sorlag/sorpain4.wav";
					
	self.nqwSndDeath1 = "sorlag/sordeath1.wav";
	self.nqwSndDeath2 = "sorlag/sordeath2.wav";
	self.nqwSndDeath3 = "sorlag/sordeath3.wav";
	self.nqwSndDeath4 = "sorlag/sordeath2.wav";
	self.nqwSndDeath5 = "sorlag/sordeath3.wav";
	self.nqwSndAxHit1 = "sorlag/sorpain4.wav";
	self.nqwSndBurn1 = "sorlag/sorpain4.wav";
	self.nqwSndBurn2 = "sorlag/sorpain4.wav";
	self.nqwSndGasp1 = "sorlag/sorgasp1.wav";
	self.nqwSndGasp2 = "sorlag/sorgasp2.wav";
	self.nqwSndDrown1 = "player/drown1.wav";
	self.nqwSndDrown2 = "player/drown2.wav";
	self.nqwSndH2oDeath = "player/h2odeath.wav";
	self.nqwSndFalling = "";
};