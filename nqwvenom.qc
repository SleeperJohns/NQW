/*
======================================================
NQW: Venom
======================================================
*/
/*
void() NQW_VenomPrecache =
{
	precache_model ("progs/player_venom.mdl"); // player Ranger model
}
*/

void() NQW_Venom =
{
	// Model
	setmodel (self, "progs/player_venom.mdl");
	self.nqwCharGib = "progs/h_player.mdl";
	self.nqwMeleeMdl = "progs/v_axe.mdl";
	self.nqwHammerMdl = "progs/v_hammer.mdl";
	NQW_SetSkin(1);
	// Sounds
	self.nqwSndMelee = "weapons/ax1.wav";
	self.nqwSndMeleeHit = "venom/axhit2.wav";
	self.nqwSndMeleeWall = "venom/axhitwall.wav";
	self.nqwSndJump = "player/plyrjmp8.wav";
	self.nqwSndLand1 = "player/land.wav";
	self.nqwSndLand2 = "player/land2.wav";
	self.nqwSndFallDeath = "player/splat1.wav";	
	
	self.nqwSndQ1Pain1 = "player/pain1.wav";
	self.nqwSndQ1Pain2 = "player/pain2.wav";
	self.nqwSndQ1Pain3 = "player/pain3.wav";
	self.nqwSndQ1Pain4 = "player/pain4.wav";
	self.nqwSndQ1Pain5 = "player/pain5.wav";
	self.nqwSndQ1Pain6 = "player/pain6.wav";

	self.nqwSndQ2Pain1 = "player/pain1.wav";
	self.nqwSndQ2Pain2 = "player/pain2.wav";
	self.nqwSndQ2Pain3 = "player/pain3.wav";
	self.nqwSndQ2Pain4 = "player/pain4.wav";
	self.nqwSndQ2Pain5 = "player/pain5.wav";
	self.nqwSndQ2Pain6 = "player/pain6.wav";
	self.nqwSndQ2Pain7 = "player/pain5.wav";
	self.nqwSndQ2Pain8 = "player/pain6.wav";
	
	self.nqwSndDeath1 = "player/death1.wav";
	self.nqwSndDeath2 = "player/death2.wav";
	self.nqwSndDeath3 = "player/death3.wav";
	self.nqwSndDeath4 = "player/death4.wav";
	self.nqwSndDeath5 = "player/death5.wav";
	self.nqwSndAxHit1 = "player/axhit1.wav";
	self.nqwSndBurn1 = "player/lburn1.wav";
	self.nqwSndBurn2 = "player/lburn2.wav";
	self.nqwSndGasp1 = "player/gasp1.wav";
	self.nqwSndGasp2 = "player/gasp2.wav";
	self.nqwSndDrown1 = "player/drown1.wav";
	self.nqwSndDrown2 = "player/drown2.wav";
	self.nqwSndH2oDeath = "player/h2odeath.wav";
};