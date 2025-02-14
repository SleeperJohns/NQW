
void() InitBodyQue;
// HIP: JIM =====================================================
void() InitBulletHoles;
// MG1 ==========================================================
// Yoder Sept24, Horde Merge
void() PrecacheMonsters;
void() InitLightStyles;
// ==============================================================

void() main =
{
	dprint ("main function\n");
	
// These are just commands the prog compiler to copy these files

	precache_file ("progs.dat");
	precache_file ("gfx.wad");
	precache_file ("quake.rc");
	precache_file ("default.cfg");

	precache_file ("end1.bin");
	precache_file2 ("end2.bin");

	precache_file ("demo1.dem");
	precache_file ("demo2.dem");
	precache_file ("demo3.dem");

// ---------------------------------------------------
// These are all of the lumps from the cached.ls files
// ---------------------------------------------------
	precache_file ("gfx/palette.lmp");
	precache_file ("gfx/colormap.lmp");

	precache_file2 ("gfx/pop.lmp");

	precache_file ("gfx/complete.lmp");
	precache_file ("gfx/inter.lmp");

	precache_file ("gfx/ranking.lmp");
	precache_file ("gfx/vidmodes.lmp");
	precache_file ("gfx/finale.lmp");
	precache_file ("gfx/conback.lmp");
	precache_file ("gfx/qplaque.lmp");

	precache_file ("gfx/menudot1.lmp");
	precache_file ("gfx/menudot2.lmp");
	precache_file ("gfx/menudot3.lmp");
	precache_file ("gfx/menudot4.lmp");
	precache_file ("gfx/menudot5.lmp");
	precache_file ("gfx/menudot6.lmp");

	precache_file ("gfx/menuplyr.lmp");
	precache_file ("gfx/bigbox.lmp");
	precache_file ("gfx/dim_modm.lmp");
	precache_file ("gfx/dim_drct.lmp");
	precache_file ("gfx/dim_ipx.lmp");
	precache_file ("gfx/dim_tcp.lmp");
	precache_file ("gfx/dim_mult.lmp");
	precache_file ("gfx/mainmenu.lmp");
	
	precache_file ("gfx/box_tl.lmp");
	precache_file ("gfx/box_tm.lmp");
	precache_file ("gfx/box_tr.lmp");
	
	precache_file ("gfx/box_ml.lmp");
	precache_file ("gfx/box_mm.lmp");
	precache_file ("gfx/box_mm2.lmp");
	precache_file ("gfx/box_mr.lmp");
	
	precache_file ("gfx/box_bl.lmp");
	precache_file ("gfx/box_bm.lmp");
	precache_file ("gfx/box_br.lmp");
	
	precache_file ("gfx/sp_menu.lmp");
	precache_file ("gfx/ttl_sgl.lmp");
	precache_file ("gfx/ttl_main.lmp");
	precache_file ("gfx/ttl_cstm.lmp");
	
	precache_file ("gfx/mp_menu.lmp");
	
	precache_file ("gfx/netmen1.lmp");
	precache_file ("gfx/netmen2.lmp");
	precache_file ("gfx/netmen3.lmp");
	precache_file ("gfx/netmen4.lmp");
	precache_file ("gfx/netmen5.lmp");
	
	precache_file ("gfx/sell.lmp");
	
	precache_file ("gfx/help0.lmp");
	precache_file ("gfx/help1.lmp");
	precache_file ("gfx/help2.lmp");
	precache_file ("gfx/help3.lmp");
	precache_file ("gfx/help4.lmp");
	precache_file ("gfx/help5.lmp");

	precache_file ("gfx/pause.lmp");
	precache_file ("gfx/loading.lmp");

	precache_file ("gfx/p_option.lmp");
	precache_file ("gfx/p_load.lmp");
	precache_file ("gfx/p_save.lmp");
	precache_file ("gfx/p_multi.lmp");

	// Sounds loaded by C code
	precache_sound ("misc/menu1.wav");
	precache_sound ("misc/menu2.wav");
	precache_sound ("misc/menu3.wav");

	precache_sound ("ambience/water1.wav");
	precache_sound ("ambience/wind2.wav");
	
	// Soundtracks (A reference to external .ent files)
	// ID1 (Phase 1 to 4) --------------
	precache_file ("music/track02.mp3");
	precache_file ("music/track02.ogg");
	precache_file ("music/track03.mp3");
	precache_file ("music/track03.ogg");
	precache_file ("music/track04.mp3");
	precache_file ("music/track04.ogg");
	precache_file ("music/track05.mp3");
	precache_file ("music/track05.ogg");
	precache_file ("music/track06.mp3");
	precache_file ("music/track06.ogg");
	precache_file ("music/track07.mp3");
	precache_file ("music/track07.ogg");	
	precache_file ("music/track08.mp3");
	precache_file ("music/track08.ogg");
	precache_file ("music/track09.mp3");
	precache_file ("music/track09.ogg");
	precache_file ("music/track10.mp3");
	precache_file ("music/track10.ogg");
	precache_file ("music/track11.mp3");
	precache_file ("music/track11.ogg");
	// HIPNOTIC (Phase 5 to 7) ---------
	precache_file ("music/track12.mp3");
	precache_file ("music/track12.ogg");
	precache_file ("music/track13.mp3");
	precache_file ("music/track13.ogg");
	precache_file ("music/track14.mp3");
	precache_file ("music/track14.ogg");
	precache_file ("music/track15.mp3");
	precache_file ("music/track15.ogg");
	precache_file ("music/track16.mp3");
	precache_file ("music/track16.ogg");
	precache_file ("music/track17.mp3");
	precache_file ("music/track17.ogg");
	precache_file ("music/track18.mp3");
	precache_file ("music/track18.ogg");
	precache_file ("music/track19.mp3");
	precache_file ("music/track19.ogg");
	// ROGUE (Phase 8 & 9) -------------
	precache_file ("music/track22.mp3");
	precache_file ("music/track22.ogg");
	precache_file ("music/track23.mp3");
	precache_file ("music/track23.ogg");
	precache_file ("music/track24.mp3");
	precache_file ("music/track24.ogg");
	precache_file ("music/track25.mp3");
	precache_file ("music/track25.ogg");
	precache_file ("music/track26.mp3");
	precache_file ("music/track26.ogg");
	precache_file ("music/track27.mp3");
	precache_file ("music/track27.ogg");
	precache_file ("music/track28.mp3");
	precache_file ("music/track28.ogg");
	precache_file ("music/track29.mp3");
	precache_file ("music/track29.ogg");	
	// ---------------------------------
	
	// Start Maps
	// ID1 (Phase 1 to 4) --------------
	precache_file ("maps/start.bsp");
	// HIPNOTIC (Phase 5 to 7) ---------
	precache_file ("maps/hipstart.bsp");
	// ROGUE (Phase 8 & 9) -------------
	precache_file ("maps/rstart.bsp");
	// DOPA (Phase 10) -----------------
	precache_file ("maps/e5start.bsp");
	// MG1 (Phase 11 to 15) ------------															
	precache_file ("maps/mgstart.bsp");
	precache_file ("maps/hub.bsp");
	// ---------------------------------
	
	// Shareware ID1 Maps ----------
	// ID1 Episode 1 (Phase 1) -----
	precache_file ("maps/e1m1.bsp");
	precache_file ("maps/e1m2.bsp");
	precache_file ("maps/e1m3.bsp");
	precache_file ("maps/e1m4.bsp");
	precache_file ("maps/e1m5.bsp");
	precache_file ("maps/e1m6.bsp");
	precache_file ("maps/e1m7.bsp");
	precache_file ("maps/e1m8.bsp");
	// Registered
	precache_file2 ("gfx/pop.lmp");
	// Registered ID1 Maps
	// ID1 Episode 2 (Phase 2) ------
	precache_file2 ("maps/e2m1.bsp");
	precache_file2 ("maps/e2m2.bsp");
	precache_file2 ("maps/e2m3.bsp");
	precache_file2 ("maps/e2m4.bsp");
	precache_file2 ("maps/e2m4_qe.bsp");
	precache_file2 ("maps/e2m5.bsp");
	precache_file2 ("maps/e2m6.bsp");
	precache_file2 ("maps/e2m6_qe.bsp");
	precache_file2 ("maps/e2m7.bsp");
	// ID1 Episode 3 (Phase 3) ------
	precache_file2 ("maps/e3m1.bsp");
	precache_file2 ("maps/e3m2.bsp");
	precache_file2 ("maps/e3m3.bsp");
	precache_file2 ("maps/e3m4.bsp");
	precache_file2 ("maps/e3m5.bsp");
	precache_file2 ("maps/e3m6.bsp");
	precache_file2 ("maps/e3m7.bsp");
	// ID1 Episode 4 (Phase 4) ------
	precache_file2 ("maps/e4m1.bsp");
	precache_file2 ("maps/e4m2.bsp");
	precache_file2 ("maps/e4m3.bsp");
	precache_file2 ("maps/e4m4.bsp");
	precache_file2 ("maps/e4m5.bsp");
	precache_file2 ("maps/e4m6.bsp");
	precache_file2 ("maps/e4m7.bsp");
	precache_file2 ("maps/e4m8.bsp");
	// SP-Deathmatch Maps (Bonus) ---
	precache_file ("maps/dm1sp.bsp");
	precache_file ("maps/dm2sp.bsp");
	precache_file ("maps/dm3sp.bsp");
	precache_file ("maps/dm4sp.bsp");
	precache_file ("maps/dm5sp.bsp");
	precache_file ("maps/dm6sp.bsp");
	// ------------------------------
	
	// End Maps
	// ID1 (Phase 1 to 4) ------------
	precache_file2 ("maps/end.bsp");
	// HIPNOTIC (Phase 5 to 7) -------
	precache_file2 ("maps/hipend.bsp");
	// ROGUE (Phase 8 & 9) -----------
	precache_file2 ("maps/rend.bsp");
	// DOPA (Phase 10) ---------------
	precache_file2 ("maps/e5end.bsp");
	// MG1 (Phase 11 to 15) ----------
	precache_file2 ("maps/mgend.bsp");
	// -------------------------------
	
	// Hipnotic Epsiode Maps
	// HIPNOTIC Episode 1 (Phase 5) --
	precache_file2 ("maps/hip1m1.bsp");
	precache_file2 ("maps/hip1m2.bsp");
	precache_file2 ("maps/hip1m3.bsp");
	precache_file2 ("maps/hip1m4.bsp");
	precache_file2 ("maps/hip1m5.bsp");
	// HIPNOTIC Episode 2 (Phase 6) --
	precache_file2 ("maps/hip2m1.bsp");
	precache_file2 ("maps/hip2m2.bsp");
	precache_file2 ("maps/hip2m3.bsp");
	precache_file2 ("maps/hip2m4.bsp");
	precache_file2 ("maps/hip2m5.bsp");
	precache_file2 ("maps/hip2m6.bsp");
	// HIPNOTIC Episode 3 (Phase 7) --
	precache_file2 ("maps/hip3m1.bsp");
	precache_file2 ("maps/hip3m2.bsp");
	precache_file2 ("maps/hip3m3.bsp");
	precache_file2 ("maps/hip3m4.bsp");
	// -------------------------------
	
	// Rogue Episode Maps
	// ROGUE Episode 1 (Phase 8) ---
	precache_file2 ("maps/r1m1.bsp");
	precache_file2 ("maps/r1m2.bsp");
	precache_file2 ("maps/r1m3.bsp");
	precache_file2 ("maps/r1m4.bsp");
	precache_file2 ("maps/r1m5.bsp");
	precache_file2 ("maps/r1m6.bsp");
	precache_file2 ("maps/r1m7.bsp");
	// ROGUE Episode 2 (Phase 9) ---
	precache_file2 ("maps/r2m1.bsp");
	precache_file2 ("maps/r2m2.bsp");
	precache_file2 ("maps/r2m3.bsp");
	precache_file2 ("maps/r2m4.bsp");
	precache_file2 ("maps/r2m5.bsp");
	precache_file2 ("maps/r2m6.bsp");
	precache_file2 ("maps/r2m7.bsp");
	// -----------------------------
	
	// Dimension Of The Past Maps
	// DOPA Episode 5 (Phase 10) ----
	precache_file2 ("maps/e5m1.bsp");
	precache_file2 ("maps/e5m2.bsp");
	precache_file2 ("maps/e5m3.bsp");
	precache_file2 ("maps/e5m4.bsp");
	precache_file2 ("maps/e5m5.bsp");
	precache_file2 ("maps/e5m6.bsp");
	precache_file2 ("maps/e5m7.bsp");
	precache_file2 ("maps/e5sm1.bsp");
	precache_file2 ("maps/e5sm2.bsp");
	// ------------------------------
	
	// Dimension Of The Machine Episode Maps
	// MG1 Episode 1 (Phase 11) ------
	precache_file2 ("maps/mge1m1.bsp");
	precache_file2 ("maps/mge1m2.bsp");
	precache_file2 ("maps/mge1m3.bsp");
	// MG1 Episode 2 (Phase 12) ------
	precache_file2 ("maps/mge2m1.bsp");
	precache_file2 ("maps/mge2m2.bsp");
	// MG1 Episode 3 (Phase 13) ------
	precache_file2 ("maps/mge3m1.bsp");
	precache_file2 ("maps/mge3m2.bsp");
	// MG1 Episode 4 (Phase 14) ------
	precache_file2 ("maps/mge4m1.bsp");
	precache_file2 ("maps/mge4m2.bsp");
	precache_file ("maps/mge4m2b.bsp");
	precache_file ("maps/mge4arena.bsp");
	// MG1 Episode 5 (Phase 15) ------
	precache_file2 ("maps/mge5m1.bsp");
	precache_file2 ("maps/mge5m2.bsp");
	// -------------------------------
	
	// Horde Maps
	// MG1 ---------------------------
	precache_file ("maps/horde1.bsp");
	precache_file ("maps/horde2.bsp");
	precache_file ("maps/horde3.bsp");
	precache_file ("maps/horde4.bsp");
	precache_file ("maps/horde5.bsp");
	precache_file ("maps/horde6.bsp");
	precache_file ("maps/horde7.bsp");
	// -------------------------------
		
	// Deathmatch Maps
	// ID1 (Phase 1 to 4) ------------
	precache_file ("maps/dm1.bsp");
	precache_file ("maps/dm2.bsp");
	precache_file ("maps/dm3.bsp");
	precache_file ("maps/dm4.bsp");
	precache_file ("maps/dm5.bsp");
	precache_file ("maps/dm6.bsp");	
	precache_file ("maps/dm7.bsp");	     // Released with the KEX Source Port.
	precache_file ("maps/dm8.bsp");	     // Released with the KEX Source Port.
	// HIPNOTIC (Phase 5 to 7) -------
	precache_file ("maps/hipdm1.bsp");   // Playable in Single Player and Co-operative with monsters.
	// ROGUE (Phase 8 & 9) -----------
	precache_file ("maps/ctf1.bsp");     // Not exactly a DM map, but it's played with Deathmatch on in some capacity
	// DOPA (Phase 10) ---------------
	precache_file ("maps/e5dm.bsp");
	// MG1 (Phase 11 to 15) ----------
	precache_file ("maps/mgdm1.bsp");
	precache_file ("maps/mgdm2.bsp");
	precache_file ("maps/mgdm3.bsp");
	precache_file ("maps/mgdm4.bsp");
	// Bonus DM Maps -----------------
	precache_file ("maps/base32b.bsp");  // Released with the KEX Source Port.
	precache_file ("maps/death32c.bsp"); // Released with the KEX Source Port.
	// -------------------------------	
};

/*
==============================================================================

BODY QUE

==============================================================================
*/

entity	bodyque_head;

void() bodyque = { }; // just here so spawn functions don't complain after the world creates bodyques

void() InitBodyQue =
{
	bodyque_head = spawn();
	bodyque_head.classname = "bodyque";
	bodyque_head.owner = spawn();
	bodyque_head.owner.classname = "bodyque";
	bodyque_head.owner.owner = spawn();
	bodyque_head.owner.owner.classname = "bodyque";
	bodyque_head.owner.owner.owner = spawn();
	bodyque_head.owner.owner.owner.classname = "bodyque";
	bodyque_head.owner.owner.owner.owner = bodyque_head;
};


// make a body que entry for the given ent so the ent can be
// respawned elsewhere
void(entity ent) CopyToBodyQue =
{
	bodyque_head.angles = ent.angles;
	bodyque_head.model = ent.model;
	bodyque_head.modelindex = ent.modelindex;
	bodyque_head.frame = ent.frame;
	bodyque_head.colormap = ent.colormap;
	bodyque_head.skin = ent.skin; // NQW add
	bodyque_head.movetype = ent.movetype;
	bodyque_head.velocity = ent.velocity;
	bodyque_head.flags = 0;
	setorigin (bodyque_head, ent.origin);
	setsize (bodyque_head, ent.mins, ent.maxs);
	bodyque_head = bodyque_head.owner;
};

entity	lastspawn;
//=======================
/*QUAKED worldspawn (0 0 0) ?
Only used for the world entity.
Set message to the level name.
Set sounds to the cd track to play.

World Types:
0: medieval
1: metal
2: base
*/
//=======================
float startingserverflags;

void() Server_Hostname_Change;
void() worldspawn =
{	
	precache_sound ("misc/runekey.wav"); // Latched sound for voting
	precache_sound ("misc/sleepermustdie.wav"); // Sleeper Must Die! Skill Sound
	startingserverflags = serverflags;
	skill = cvar("skill");
	isHordeMode = cvar("horde");	
	lastspawn = world;	
	
	if (cvar("pr_checkextension") && checkextension("QUAKE_EX")) isKex = TRUE;	
	
	send_ssqc_to_csqc ();
	
	// Sleeper: This skill 5 difficulty only works in FTE QuakeWorld, just keep in mind.
	NQW_SleeperMustDie();
	
	// Keep deathmatch separated from Cooperative and Single Player
	if (cvar("deathmatch")) cvar_set("skill", ""); // Sleeper: This was *realnull*. ._. It's a joke.
	
	mlstage = 0;
	InitBodyQue ();
	
	// JIM
	InitBulletHoles();
	
	     if (self.model == Start_Maplist_World[1] || self.model == ID1_Maplist_World[ID1_Maps_Finder()]) gameworld = ID1;
	else if (self.model == Start_Maplist_World[2] || self.model == HIP_Maplist_World[HIP_Maps_Finder()]) gameworld = HIPNOTIC;
	else if (self.model == Start_Maplist_World[3] || self.model == ROGUE_Maplist_World[ROGUE_Maps_Finder()]) gameworld = ROGUE;
	else if (self.model == Start_Maplist_World[4] || self.model == DOPA_Maplist_World[DOPA_Maps_Finder()]) gameworld = DOPA;
	else if ((self.model == Start_Maplist_World[5]) || (self.model == Start_Maplist_World[6] && self.worldtype == WORLDTYPE_HUB) || (self.model == MG1_Maplist_World[MG1_Maps_Finder()]) || (self.model == HordeMode_MapsList_World[HordeMaps_Finder()])) gameworld = MG1;
	else if (self.model == CustomCoop_MapsList_World[CustomCoopMaps_Finder()] || self.model == CustomDM_Maplist_World[CustomDMMaps_Finder()]) gameworld = CUSTOM;
	else if (self.model == "maps/apotheosis_sleeper.bsp") gameworld = APOTHEOSIS;
	else gameworld = UNKNOWN;	
					      	
	// Custom map attributes
	if (!self.gravity) 
	{
		if (self.model == "maps/e1m8.bsp") self.gravity = 100;
		else self.gravity = 800;
	}

	cvar_set ("sv_gravity", ftos(self.gravity));

// the area based ambient sounds MUST be the first precache_sounds

// player precaches	
	W_Precache ();			// get weapon precaches
	// ROGUE =======================================================
//	RunePrecache ();			// precache the runes
	// Net QuakeWorld PRECACHES ====================================
	NQW_Precaches ();
	// =============================================================	

// sounds used from C physics code
	precache_sound ("demon/dland2.wav");		// landing thud
	precache_sound ("misc/h2ohit1.wav");		// landing splash

// setup precaches allways needed
	precache_sound ("items/itembk2.wav");		// item respawn sound
	precache_sound ("player/plyrjmp8.wav");		// player jump
	precache_sound ("player/land.wav");			// player landing
	precache_sound ("player/land2.wav");		// player hurt landing
	precache_sound ("player/drown1.wav");		// drowning pain
	precache_sound ("player/drown2.wav");		// drowning pain
	precache_sound ("player/gasp1.wav");		// gasping for air
	precache_sound ("player/gasp2.wav");		// taking breath
	precache_sound ("player/h2odeath.wav");		// drowning death

	precache_sound ("misc/secret.wav");
	precache_sound ("misc/talk.wav");			// talk
	precache_sound ("player/teledth1.wav");		// telefrag
	precache_sound ("misc/r_tele1.wav");		// teleport sounds
	precache_sound ("misc/r_tele2.wav");
	precache_sound ("misc/r_tele3.wav");
	precache_sound ("misc/r_tele4.wav");
	precache_sound ("misc/r_tele5.wav");
	precache_sound ("weapons/lock4.wav");		// ammo pick up
	precache_sound ("weapons/pkup.wav");		// weapon up
	precache_sound ("items/armor1.wav");		// armor up
	precache_sound ("items/q2armor1.wav");		// skill 5's jacket armor sound
	precache_sound ("items/q3armor1.wav");		// skill 5's combat armor sound
	precache_sound ("items/q4armor1.wav");		// skill 5's heavy armor sound
	precache_sound ("weapons/lhit.wav");		//lightning
	precache_sound ("weapons/lstart.wav");		//lightning start
	precache_model ("progs/quaddama.mdl");
	precache_sound ("items/damage.wav");
	precache_sound ("items/damage3.wav");
	precache_sound("items/protect2.wav");	
	precache_sound("items/protect3.wav");

	precache_sound ("misc/power.wav");			//lightning for boss

// player gib sounds
	precache_sound ("player/gib.wav");			// player gib sound
	precache_sound ("player/udeath.wav");		// player gib sound
	precache_sound ("player/tornoff2.wav");		// gib sound

// player pain sounds

	precache_sound ("player/pain1.wav");
	precache_sound ("player/pain2.wav");
	precache_sound ("player/pain3.wav");
	precache_sound ("player/pain4.wav");
	precache_sound ("player/pain5.wav");
	precache_sound ("player/pain6.wav");

// player death sounds
	precache_sound ("player/death1.wav");
	precache_sound ("player/death2.wav");
	precache_sound ("player/death3.wav");
	precache_sound ("player/death4.wav");
	precache_sound ("player/death5.wav");

	// ax sounds	
	precache_sound ("weapons/ax1.wav");			// ax swoosh
	precache_sound ("player/axhit1.wav");		// ax hit meat
	precache_sound ("player/axhit2.wav");		// ax hit world

	precache_sound ("player/h2ojump.wav");		// player jumping into water
	precache_sound ("player/slimbrn2.wav");		// player enter slime
	precache_sound ("player/inh2o.wav");		// player enter water
	precache_sound ("player/inlava.wav");		// player enter lava
	precache_sound ("misc/outwater.wav");		// leaving water sound

	precache_sound ("player/lburn1.wav");		// lava burn
	precache_sound ("player/lburn2.wav");		// lava burn

	precache_sound ("misc/water1.wav");			// swimming
	precache_sound ("misc/water2.wav");			// swimming
	
	// PGM Addition Sounds
	precache_sound ("enforcer/enfstop.wav");    // shield impact
	precache_sound ("plasma/explode.wav");
	precache_sound ("plasma/flight.wav");			
	precache_sound ("plasma/fire.wav");
	precache_sound ("shield/hit.wav");
	precache_sound ("belt/use.wav");
	precache_sound ("items/damage2.wav");	
	
	if (deathmatch) precache_sound ("buttons/switch04.wav");
	
	//MED 10/21/96 added flies sound
	precache_sound ("misc/flys.wav");
	
	//MED 01/13/97 added explosion sounds
	precache_sound ("misc/shortexp.wav");
	precache_sound ("misc/longexpl.wav");
	
	// Footstep sounds
	precache_sound ("misc/foot1.wav");
	precache_sound ("misc/foot2.wav");
	precache_sound ("misc/foot3.wav");
	precache_sound ("misc/foot4.wav");
	precache_sound ("misc/foot5.wav");
	precache_sound ("misc/foot6.wav");
	precache_sound ("misc/foot7.wav");
	
	precache_sound ("weapons/coilgun.wav");
	precache_sound ("railwarz/laserhook_pull.wav");
	precache_sound ("railwarz/laserhook_fire.wav");

	precache_model ("progs/player.mdl");
	precache_model ("progs/eyes.mdl");
	precache_model ("progs/h_player.mdl");
	
	//MED 12/03/96 added player with hammer
	precache_model ("progs/playham.mdl");
	
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	precache_model ("progs/s_bullet.spr"); 	// bullet decals		
	precache_model ("progs/s_bubble.spr");	// drowning bubbles
	precache_model ("progs/s_explod.spr");	// sprite explosion

	precache_model ("progs/v_axe.mdl");
	precache_model ("progs/v_shot.mdl");
	precache_model ("progs/v_nail.mdl");
	precache_model ("progs/v_rock.mdl");
	precache_model ("progs/v_shot2.mdl");
	precache_model ("progs/v_nail2.mdl");
	precache_model ("progs/v_rock2.mdl");
	
	precache_model ("progs/v_coilgun.mdl");
//	precache_model ("progs/rail3_1.mdl");
	
	// Sleeper: Precache world weapons to drop them.
	precache_model ("progs/g_shot.mdl");
	precache_model ("progs/g_nail.mdl");
	precache_model ("progs/g_nail2.mdl");
	precache_model ("progs/g_rock.mdl");
	precache_model ("progs/g_rock2.mdl");
	precache_model ("progs/g_light.mdl");
	precache_model ("progs/g_prox.mdl");
	precache_model ("progs/g_laserg.mdl");
	precache_model ("progs/g_hammer.mdl");
		
	//MED 10/31/96 added precache for hip view models
	precache_model ("progs/v_laserg.mdl");
	precache_model ("progs/v_hammer.mdl");
	precache_model ("progs/v_prox.mdl");
	precache_model ("progs/proxbomb.mdl");
	
	// Lava Gun models - pgm change
	precache_model ("progs/v_lava.mdl");
	precache_model ("progs/v_lava2.mdl");
	precache_model ("progs/v_multi.mdl");
	precache_model ("progs/v_multi2.mdl");
	precache_model ("progs/plasma.mdl");
	precache_model ("progs/v_plasma.mdl");
//ZOID--
	// hook for CTF
	precache_model ("progs/hook.mdl");
	precache_model ("progs/v_grpple.mdl");
	precache_model ("progs/beam.mdl");
	precache_model ("progs/chain.mdl");
	precache_model ("progs/chain_short.mdl");
	precache_model ("progs/chain_tail.mdl");
	precache_model ("progs/laserhook_red.mdl");
	precache_model ("progs/laserhook_blue.mdl");
	precache_model ("progs/laserhook.mdl");
//	precache_model ("progs/bit.mdl");
//--ZOID	

	precache_model ("progs/bolt.mdl");		// for lightning gun
	precache_model ("progs/bolt2.mdl");		// for lightning gun
	precache_model ("progs/bolt3.mdl");		// for boss shock
	precache_model ("progs/lavaball.mdl");		// for testing
	
	//MED 10/18/96 added precache for laser cannon
	precache_model ("progs/lasrspik.mdl");
	
	//JIM
	StopEarthQuake();
	
	// MED
	/*
	if (cvar("crosshair") == 2) footsteps = 1;
	else footsteps = 0;	
	*/
	
	if ((gameworld == HIPNOTIC && !deathmatch) || (cvar("instagib") == INSTAGIB_RAILWARZ && deathmatch)) footsteps = 1;
	else footsteps = 0;
	
	precache_model ("progs/missile.mdl");
	precache_model ("progs/grenade.mdl");
	precache_model ("progs/spike.mdl");
	precache_model ("progs/s_spike.mdl");
	
	// PGM addition
	precache_model ("progs/mervup.mdl");
	precache_model ("progs/rockup.mdl");
	precache_model ("progs/rockup_d.mdl");
	precache_model ("progs/lspike.mdl");
	precache_model ("progs/shield.mdl");
	precache_model ("progs/p_shield.mdl");	

	precache_model ("progs/backpack.mdl");

	precache_model ("progs/zom_gib.mdl");

	precache_model ("progs/v_light.mdl");
	
	// Yoder Sept24, 2021, Horde Merge	
	// Moved to lights.qc
	InitLightStyles();		
	
	precache_sound("items/armorrot.wav"); // Armor rotting
	precache_sound("wizard/wsight.wav");

	// Announcer stuff
	nqw_announcer = spawn ();
	nqw_announcer.nqw_queue_index = 0;
	nqw_announcer.nextthink = 0.1;
	nqw_announcer.think = NQW_AnnouncerPlayback;
};

void() LoadGame;
void() CheckRules;

float LastTime;
float idk;

void() StartFrame =
{
	local float mg1_horde_maps_pool  = (world.model == "maps/horde1.bsp" || world.model == "maps/horde2.bsp" || world.model == "maps/horde3.bsp" || world.model == "maps/horde4.bsp" || world.model == "maps/horde5.bsp" || world.model == "maps/horde6.bsp" || world.model == "maps/horde7.bsp");

	local float routine_server_restart = (60 * 60) * 6; // 6 hour resets
			                    
//	local float custom_story_maps_pool; // This is for community maps that deserve to be played as a campaign. There are no stories yet to be told.
			                                 			                   	
	teamplay = cvar("teamplay");
	cheats_allowed = cvar("sv_cheats");
	isHordeMode = cvar("horde");	
	customcoop_flags = cvar("customcoop");
	
	// Restart the server every set amount of hours when there's no players in the server. This helps with floating point issues.
        if (time >= routine_server_restart)
        {
                local entity server_inactive = find (world, classname, "player");
                if (server_inactive == world)
                {
			dprint ("!ROUTINE 6-HOUR SERVER RESTART INITIATED!\n");
			if (cvar("coop") && !cvar("deathmatch") && !cvar("customcoop")) // Sleeper: If the server is hosted in the middle or late in an episode, restart the episode from the beginning.
			{
				if (world.model == "maps/e1m2.bsp" || world.model == "maps/e1m3.bsp" || world.model == "maps/e1m4.bsp" || world.model == "maps/e1m5.bsp" || world.model == "maps/e1m6.bsp" || world.model == "maps/e1m7.bsp" || world.model == "maps/e1m8.bsp")
					localcmd ("changelevel e1m1\n");	
				else if (world.model == "maps/e2m2.bsp" || world.model == "maps/e2m3.bsp" || world.model == "maps/e2m4.bsp" || world.model == "maps/e2m5.bsp" || world.model == "maps/e2m6.bsp" || world.model == "maps/e2m6_qe.bsp" || world.model == "maps/e2m7.bsp")
					localcmd ("changelevel e2m1\n");
				else if (world.model == "maps/e3m2.bsp" || world.model == "maps/e3m3.bsp" || world.model == "maps/e3m4.bsp" || world.model == "maps/e3m5.bsp" || world.model == "maps/e3m6.bsp" || world.model == "maps/e3m7.bsp")
					localcmd ("changelevel e3m1\n");	
				else if (world.model == "maps/e4m2.bsp" || world.model == "maps/e4m3.bsp" || world.model == "maps/e4m4.bsp" || world.model == "maps/e4m5.bsp" || world.model == "maps/e4m6.bsp" || world.model == "maps/e4m7.bsp" || world.model == "maps/e4m8.bsp")
					localcmd ("changelevel e4m1\n");
				else if (world.model == "maps/hip1m2.bsp" || world.model == "maps/hip1m3.bsp" || world.model == "maps/hip1m4.bsp" || world.model == "maps/hip1m5.bsp")
					localcmd ("changelevel hip1m1\n");
				else if (world.model == "maps/hip2m2.bsp" || world.model == "maps/hip2m3.bsp" || world.model == "maps/hip2m4.bsp" || world.model == "maps/hip2m5.bsp" || world.model == "maps/hip2m6.bsp")
					localcmd ("changelevel hip2m1\n");
				else if (world.model == "maps/hip3m2.bsp" || world.model == "maps/hip3m3.bsp" || world.model == "maps/hip3m4.bsp" || world.model == "maps/hipdm1.bsp" || world.model == "maps/hipend.bsp")
					localcmd ("changelevel hip3m1\n");	
				else if (world.model == "maps/r1m2.bsp" || world.model == "maps/r1m3.bsp" || world.model == "maps/r1m4.bsp" || world.model == "maps/r1m5.bsp" || world.model == "maps/r1m6.bsp" || world.model == "maps/r1m7.bsp")
					localcmd ("changelevel r1m1\n");
				else if (world.model == "maps/r2m2.bsp" || world.model == "maps/r2m3.bsp" || world.model == "maps/r2m4.bsp" || world.model == "maps/r2m5.bsp" || world.model == "maps/r2m6.bsp" || world.model == "maps/r2m7.bsp" || world.model == "maps/rend.bsp")
					localcmd ("changelevel r2m1\n");
				else if (world.model == "maps/e5m2.bsp" || world.model == "maps/e5m3.bsp" || world.model == "maps/e5m4.bsp" || world.model == "maps/e5m5.bsp" || world.model == "maps/e5m6.bsp" || world.model == "maps/e5m7.bsp" || world.model == "maps/e5end.bsp" || world.model == "maps/e5sm1.bsp" || world.model == "maps/e5sm2.bsp")
					localcmd ("changelevel e5m1\n");	
				else if (world.model == "maps/mge1m2.bsp" || world.model == "maps/mge1m3.bsp") localcmd ("changelevel mge1m1\n");
				else if (world.model == "maps/mge2m2.bsp") localcmd ("changelevel mge2m1\n");
				else if (world.model == "maps/mge3m2.bsp") localcmd ("changelevel mge3m1\n");
				else if (world.model == "maps/mge4m2.bsp") localcmd ("changelevel mge4m1\n");
				else if (world.model == "maps/mge5m2.bsp") localcmd ("changelevel mge5m1\n");
				else localcmd ("restart\n"); // Sleeper: Custom maps or Horde maps can just restart plainly.
			}
			else localcmd ("restart\n"); // Sleeper: Because we still want deathmatch and custom coop to receive the routine restart.
		}
	}
				
	// Disable Horde Mode when not playing horde mode maps.
	if (!mg1_horde_maps_pool && gameworld != APOTHEOSIS) cvar_set("horde", "0");
	
	if (cvar("deathmatch"))
	{
		cvar_set("customcoop", "0");
		cvar_set("horde", "0");
		cvar_set("campaign", "0");
		cvar_set("coop", "0");
		if (campaign_valid == TRUE) campaign_valid = FALSE;
	}
	
	if (!idk && cvar("deathmatch") >= DM_TDM && cvar("deathmatch") <= DM_OneFlagCTF)
	{
		redteam = 0;
		blueteam = 0;
		greyteam = 0;
		idk = TRUE;
	}
		
	// Determine if we're playing custom maps, horde mode or the campaign maps.
	if (gameworld >= ID1 && gameworld <= MG1/* && !custom_story_maps_pool*/)
	{
		cvar_set("customcoop", "0");
	}
	else if (gameworld == CUSTOM && !cvar("deathmatch"))
	{
		cvar_set("customcoop", "1");
	}
	
//	skill = cvar("skill"); // Moved to worldspawn.
	framecount += 1;
	float DeltaTime = time - LastTime;
	LastTime = time;
	
	// save off a global here so it gets included in savegames
	if (gameworld >= CUSTOM && gameworld <= MG1 && !cvar("deathmatch") && !campaign_valid) 
	{
		campaign = cvar("campaign");
		cvar_set("campaign", ftos(gameworld));	
		campaign_valid = TRUE;		
	} 
	
	if (!load_flag && framecount > 2)
	{
		if (framecount != 3) LoadGame ();
		load_flag = TRUE;
	}
	RunFrameTickEntities (DeltaTime);
	
	// Display version in server information      
	if (!Version_To_Startframe_Traffic)
	{
		localcmd ("serverinfo ");
		localcmd (NQW_Version);
		localcmd ("\n");
		Version_To_Startframe_Traffic = TRUE; // Spam prevention for developer command shell
	}
		
	if (!Halt_GameWorld_Traffic)
	{
		// Determine what Game World we are in.
		forceinfokey (world, "GameWorld", GameWorld_Name());
		forceinfokey (world, "Campaign", Campaign_Name());						
		Halt_GameWorld_Traffic = TRUE; // Safety against traffic spam
	}		
	// Net QuakeWorld ------------------------------------
	Server_Hostname_Change (); // Public Servers	
	Create_New_Cvars ();	   // Create custom cvars
	Change_New_Cvars ();	   // Change custom cvars
	// ---------------------------------------------------	
	
	CheckRules (); // Sleeper: Moved from PlayerPreThink.
};