/*
======================================================
NQW: DUSKDUDE
======================================================
*/
/*
void() NQW_SorlagPrecache =
{
	precache_model ("progs/player_dusk.mdl"); // player Dusk model
}
*/

void() NQW_DuskDude =
{
	sound(self, CHAN_VOICE, "silence.wav", 1, ATTN_NORM);
	sound(self, CHAN_VOICE, "dusk/sicklestart.wav", 1, ATTN_NORM);
	// Model
	self.nqwMdlChar = "progs/player_dusk.mdl";
	self.view_ofs = '0 0 22';
	self.nqwCharGib = "progs/h_player_dusk.mdl";
	self.nqwMeleeMdl = "progs/v_sickles.mdl";
	self.nqwHammerMdl = "progs/v_hammer.mdl";
	NQW_SetSkin(6);
	self.nqwGibSkins = self.nqwMaxSkins;
	// Sounds
	self.nqwSndMelee = "dusk/sickleslice.wav";
	self.nqwSndMeleeHit = "ranger/axhit.wav";
	self.nqwSndMeleeWall = "sleeper/axhitwall.wav";
	self.nqwSndJump = "dusk/jump.wav";
	self.nqwSndLand1 = "dusk/land.wav";
	self.nqwSndLand2 = "dusk/land02.wav";
	self.nqwSndFallDeath = "player/splat1.wav";
	
	// Quake 1 style pain sounds
	self.nqwSndQ1Pain1 = "dusk/damage.wav";
	self.nqwSndQ1Pain2 = "dusk/damage.wav";
	self.nqwSndQ1Pain3 = "dusk/damage.wav";
	self.nqwSndQ1Pain4 = "dusk/damage.wav";
	self.nqwSndQ1Pain5 = "dusk/damage.wav";
	self.nqwSndQ1Pain6 = "dusk/damage.wav";
		
	// Quake 2 style pain sounds	
	self.nqwSndQ2Pain1 = "dusk/damage.wav";
	self.nqwSndQ2Pain2 = "dusk/damage.wav";
	self.nqwSndQ2Pain3 = "dusk/damage.wav";
	self.nqwSndQ2Pain4 = "dusk/damage.wav";
	self.nqwSndQ2Pain5 = "dusk/damage.wav";
	self.nqwSndQ2Pain6 = "dusk/damage.wav";
	self.nqwSndQ2Pain7 = "dusk/damage.wav";
	self.nqwSndQ2Pain8 = "dusk/damage.wav";
					
	self.nqwSndDeath1 = "dusk/death.wav";
	self.nqwSndDeath2 = "dusk/death.wav";
	self.nqwSndDeath3 = "dusk/death.wav";
	self.nqwSndDeath4 = "dusk/death.wav";
	self.nqwSndDeath5 = "dusk/death.wav";
	self.nqwSndAxHit1 = "dusk/damage.wav";
	self.nqwSndBurn1 = "dusk/damage.wav";
	self.nqwSndBurn2 = "dusk/damage.wav";
	self.nqwSndGasp1 = "dusk/jump.wav";
	self.nqwSndGasp2 = "dusk/jump.wav";
	self.nqwSndDrown1 = "dusk/damage.wav";
	self.nqwSndDrown2 = "dusk/damage.wav";
	self.nqwSndH2oDeath = "dusk/death.wav";
	self.nqwSndFalling = "";
};