//Decompiled code. Please respect the original copyright.
float FALSE;
float TRUE    = 1;
float FL_FLY    = 1;
float FL_SWIM    = 2;
float FL_CLIENT    = 8;
float FL_INWATER    = 16;
float FL_MONSTER    = 32;
float FL_GODMODE    = 64;
float FL_NOTARGET    = 128;
float FL_ITEM    = 256;
float FL_ONGROUND    = 512;
float FL_PARTIALGROUND    = 1024;
float FL_WATERJUMP    = 2048;
float FL_JUMPRELEASED    = 4096;
float FL_ISBOT    = 8192;
float FL_FUTUREMONSTER		= 16384;// for marking unspawned monsters
float FL_INSHELTER			= 32768;// for marking entities as sheltered from trigger_push
float FL_OBJECTIVE			= 131072; 	// mal: any item marked with this is an objective of some kind.
float FL_DAMAGEBOOSTED 	= 262144;
float MOVETYPE_NONE;
float MOVETYPE_WALK    = 3;
float MOVETYPE_STEP    = 4;
float MOVETYPE_FLY    = 5;
float MOVETYPE_TOSS    = 6;
float MOVETYPE_PUSH    = 7;
float MOVETYPE_NOCLIP    = 8;
float MOVETYPE_FLYMISSILE    = 9;
float MOVETYPE_BOUNCE    = 10;
float MOVETYPE_BOUNCEMISSILE    = 11;
float SOLID_NOT;
float SOLID_TRIGGER    = 1;
float SOLID_BBOX    = 2;
float SOLID_SLIDEBOX    = 3;
float SOLID_BSP    = 4;
float RANGE_MELEE;
float RANGE_NEAR    = 1;
float RANGE_MID    = 2;
float RANGE_FAR    = 3;
float DEAD_NO;
float DEAD_DYING    = 1;
float DEAD_DEAD    = 2;
float DEAD_RESPAWNABLE    = 3;
float DAMAGE_NO;
float DAMAGE_YES    = 1;
float DAMAGE_AIM    = 2;

// Ammo Inventory Fields (Count: 7)
.float ammo_shells1;
.float ammo_nails1;
.float ammo_rockets1;
.float ammo_cells1;
.float ammo_lava_nails;
.float ammo_multi_rockets;
.float ammo_plasma;
.float ammo_slugs;

// Weapons (Count: 17)
float IT_SHOTGUN	     = 1;
float IT_SUPER_SHOTGUN       = 2;
float IT_NAILGUN	     = 4;
float IT_SUPER_NAILGUN       = 8;
float IT_GRENADE_LAUNCHER    = 16;
float IT_ROCKET_LAUNCHER     = 32;
float IT_LIGHTNING	     = 64;
float IT_MJOLNIR             = 128;
float IT_LASER_CANNON        = 256;
float IT_PROXIMITY_GUN       = 512;    // 3 Hipnotic Weapons 
float DOE_LAVA_SUPER_NAILGUN = 1024;
float IT_AXE		     = 2048;   // 8 ID Weapons
float DOE_LAVA_NAILGUN       = 4096;						
float DOE_MULTI_GRENADE      = 8192;		// 15
float DOE_MULTI_ROCKET       = 16384;
float DOE_PLASMA_GUN         = 32768;
float DOE_GRAPPLE	     = 65536;  // 6 Rogue Weapons
float NQW_IT_COILGUN         = 131072; // 1 Quake II Weapon (won't be on the same .weapons field)
// float IT_EXTRA_WEAPON     = 262144; // Most likely be Impel weapons after this point. (won't be on the same .weapons field)
// Railgun would nice.

// only the weapons shown in the vanilla HUD
float HUD_WEAPONS = IT_AXE + 
		    IT_SHOTGUN + 
		    IT_SUPER_SHOTGUN + 
		    IT_NAILGUN + 
		    IT_SUPER_NAILGUN + 
		    IT_GRENADE_LAUNCHER + 
		    IT_ROCKET_LAUNCHER + 
		    IT_LIGHTNING;

// Sleeper: Only a weapon needs giving.		  		    
float HIPNOTIC_WEAPONS = IT_PROXIMITY_GUN +
			 IT_LASER_CANNON + 
			 IT_MJOLNIR;
			 
float ROGUE_WEAPONS = DOE_LAVA_NAILGUN + 
		      DOE_LAVA_SUPER_NAILGUN + 
		      DOE_MULTI_GRENADE + 
		      DOE_MULTI_ROCKET +
		      DOE_PLASMA_GUN;
		    
float ALL_WEAPONS = IT_AXE + 
		    IT_SHOTGUN + 
		    IT_SUPER_SHOTGUN + 
		    IT_NAILGUN + 
		    DOE_LAVA_NAILGUN + 
		    IT_SUPER_NAILGUN + 
		    DOE_LAVA_SUPER_NAILGUN + 
		    IT_GRENADE_LAUNCHER + 
		    IT_PROXIMITY_GUN + 
		    DOE_MULTI_GRENADE + 
		    IT_ROCKET_LAUNCHER + 
		    DOE_MULTI_ROCKET + 
		    IT_LIGHTNING + 
		    DOE_PLASMA_GUN + 
		    IT_LASER_CANNON + 
		    IT_MJOLNIR;	      	    

// Ammo Types (Count: 7)
float IT_SHELLS		= 256;
float IT_NAILS  	= 512;
float IT_ROCKETS	= 1024;
float IT_CELLS		= 2048;  // 4 ID Ammo Types
float DOE_LAVA_NAILS	= 4096;
float DOE_MULTI_ROCKETS = 8192;  // 3 Rogue Ammo Types // 29
float DOE_PLASMA_AMMO	= 16384;
float NQW_IT_SLUGS 	= 32768;

// Armors (Count: 3)
float IT_ARMOR1	= 8192;
float IT_ARMOR2	= 16384;
float IT_ARMOR3	= 32768;
// Armor Shards would a nice addm but probably won't need bitflags.

// Unused Megahealth Flags (Replaced by .float health_overstacked)
// float DOE_SUPERHEALTH = 256;			// 32
// float IT_SUPERHEALTH	 = 65536;

// Keys (Count: 2)
float IT_KEY1 = 131072;
float IT_KEY2 = 262144;

// Powerups (Count: 10)
// ID1 Powerups (Count: 4)
float IT_INVISIBILITY          = 524288;
float IT_INVULNERABILITY       = 1048576;
float IT_SUIT		       = 2097152;
float IT_QUAD		       = 4194304; // 4 ID Powerups
// HIPNOTIC Powerups (Count: 3)
float HIP_IT_WETSUIT 	       = 2;
float HIP_IT_EMPATHY_SHIELDS   = 4;
float HIP_IT_HORN_OF_CONJURING = 8;	  // 3 Hipnotic Powerups
// ROGUE Powerups (Count: 3)
float DOE_SHIELD	       = 16;
float DOE_ANTIGRAV	       = 32;
float DOE_V_SPHERE	       = 64;	  // 3 Rogue Powerups

// Quake things
float DOE_EARTHQUAKE = 512;			

float CONTENT_EMPTY    = -1;
float CONTENT_SOLID    = -2;
float CONTENT_WATER    = -3;
float CONTENT_SLIME    = -4;
float CONTENT_LAVA    = -5;
float CONTENT_SKY    = -6;
float STATE_TOP;
float STATE_BOTTOM    = 1;
float STATE_UP    = 2;
float STATE_DOWN    = 3;
vector VEC_ORIGIN;
vector VEC_HULL_MIN    = '-16 -16 -24';
vector VEC_HULL_MAX    = '16 16 32';
vector VEC_HULL2_MIN    = '-32 -32 -24';
vector VEC_HULL2_MAX    = '32 32 64';
float SVC_TEMPENTITY    = 23;
float SVC_KILLEDMONSTER    = 27;
float SVC_FOUNDSECRET    = 28;
float SVC_INTERMISSION    = 30;
float SVC_FINALE    = 31;
float SVC_CDTRACK    = 32;
float SVC_SELLSCREEN    = 33;
float TE_SPIKE;
float TE_SUPERSPIKE    = 1;
float TE_GUNSHOT    = 2;
float TE_EXPLOSION    = 3;
float TE_TAREXPLOSION    = 4;
float TE_LIGHTNING1    = 5;
float TE_LIGHTNING2    = 6;
float TE_WIZSPIKE    = 7;
float TE_KNIGHTSPIKE    = 8;
float TE_LIGHTNING3    = 9;
float TE_LAVASPLASH    = 10;
float TE_TELEPORT    = 11;
float TE_EXPLOSION2   = 12;
float TE_BEAM	= 13;  	
float CHAN_AUTO;
float CHAN_WEAPON    = 1;
float CHAN_VOICE     = 2;
float CHAN_ITEM      = 3;
float CHAN_BODY      = 4;
float CHAN_POWERUP   = 5;
float CHAN_ANNOUNCER = 6;
float CHAN_OTHER     = 7;
float ATTN_NONE;
float ATTN_NORM    = 1;
float ATTN_IDLE    = 2;
float ATTN_STATIC    = 3;
// float UPDATE_GENERAL;
float UPDATE_STATIC    = 1;
float UPDATE_BINARY    = 2;
float UPDATE_TEMP    = 3;

float EF_BRIGHTFIELD    = 1;
float EF_MUZZLEFLASH    = 2;
float EF_BRIGHTLIGHT    = 4;
float EF_DIMLIGHT    = 8;
float EF_YELLOW    = 32;
float EF_BLUE    = 64;
float EF_RED    = 128;
/*
float EF_BRIGHTFIELD	= 1;
float EF_MUZZLEFLASH 	= 2;
float EF_BRIGHTLIGHT 	= 4;
float EF_DIMLIGHT 	= 8;
float EF_BLUE    = 16;
float EF_RED  = 32;
float EF_CANDLELIGHT	= 64;
float EF_YELLOW    = 128;
*/
float MSG_BROADCAST;
float MSG_ONE    = 1;
float MSG_ALL    = 2;
float MSG_INIT    = 3;
float DOOR_START_OPEN    = 1;
float DOOR_DONT_LINK    = 4;
float DOOR_GOLD_KEY    = 8;
float DOOR_SILVER_KEY    = 16;
float DOOR_TOGGLE    = 32;
float SECRET_OPEN_ONCE    = 1;
float SECRET_1ST_LEFT    = 2;
float SECRET_1ST_DOWN    = 4;
float SECRET_NO_SHOOT    = 8;
float SECRET_YES_SHOOT    = 16;
float H_ROTTEN    = 1;
float H_MEGA    = 2;
float WEAPON_BIG2    = 1;
float WEAPON_SHOTGUN    = 1;
float WEAPON_ROCKET    = 2;
float WEAPON_SPIKES    = 4;
float WEAPON_BIG    = 8;
float START_OFF    = 1;
float SPAWNFLAG_SUPERSPIKE    = 1;
float SPAWNFLAG_LASER    = 2;
float PLAT_LOW_TRIGGER    = 1;
float SPAWNFLAG_NOMESSAGE    = 1;
float SPAWNFLAG_NOTOUCH    = 1;
float PLAYER_ONLY    = 1;
float SILENT    = 2;
float PUSH_ONCE    = 1;
float SPAWN_CRUCIFIED    = 1;
float movedist;
float gameover;
string string_null;
// float empty_float;
entity newmis;
entity activator;
entity damage_attacker;
float framecount;
float skill;
.string wad;
.string map;
.float worldtype;
.string killtarget;
.float light_lev;
.float style;
.void() th_stand;
.void() th_walk;
.void() th_run;
.void() th_missile;
.void() th_melee;
.void(entity attacker, float damage) th_pain;
.void() th_die;
.entity oldenemy;
.float speed;
.float lefty;
.float search_time;
.float attack_state;
float AS_STRAIGHT    = 1;
float AS_SLIDING    = 2;
float AS_MELEE    = 3;
float AS_MISSILE    = 4;
.float walkframe;
.float attack_finished;
.float pain_finished;
.float invincible_finished;
.float invisible_finished;
.float super_damage_finished;
.float radsuit_finished;
.float invincible_time;
.float invincible_sound;
.float invisible_time;
.float invisible_sound;
.float super_time;
.float super_sound;
.float rad_time;
.float fly_sound;
.float axhitme;
.float show_hostile;
.float jump_flag;
.float swim_flag;
.float air_finished;
.float bubble_count;
.string deathtype;
.string mdl;
.vector mangle;
.float mangle_x;
.float mangle_y;
.float mangle_z;
.float t_length;
.float t_width;
.vector dest;
.float dest_x;
.float dest_y;
.float dest_z;
.vector dest1;
.float dest1_x;
.float dest1_y;
.float dest1_z;
.vector dest2;
.float dest2_x;
.float dest2_y;
.float dest2_z;
.float wait;
.float delay;
.entity trigger_field;
.string noise4;
.float pausetime;
.entity movetarget;
.float aflag;
.float dmg;
.float cnt;
.void() think1;
.vector finaldest;
.float finaldest_x;
.float finaldest_y;
.float finaldest_z;
.vector finalangle;
.float finalangle_x;
.float finalangle_y;
.float finalangle_z;
.float count;
.float lip;
.float state;
.vector pos1;
.float pos1_x;
.float pos1_y;
.float pos1_z;
.vector pos2;
.float pos2_x;
.float pos2_y;
.float pos2_z;
.float height;
.float waitmin;
.float waitmax;
.float distance;
.float volume;
// float current_yaw;
entity sight_entity;
float sight_entity_time;
entity le1;
entity le2;
float lightning_end;
float modelindex_eyes;
// float modelindex_player;
float intermission_running;
float intermission_exittime;
string nextmap;
.float dmgtime;
float enemy_vis;
float enemy_infront;
float enemy_range;
float enemy_yaw;
float hknight_type;
.float healamount;
.float healtype;
entity multi_ent;
float multi_damage;
entity bodyque_head;
entity lastspawn;
.float inpain;
void makevectorsfixed(vector ang);
void (vector ang) makevectors = #1; 
void (entity e, vector o) setorigin = #2; 
void (entity e, string m) setmodel = #3; 
void (entity e, vector min, vector max) setsize = #4; 
void () break = #6; 
float () random = #7; 
void (entity e, float chan, string samp, float vol, float atten) sound = #8; 
vector (vector v) normalize = #9; 
void (string e) error = #10; 
void (string e) objerror = #11; 
float (vector v) vlen = #12; 
float (vector v) vectoyaw = #13; 
entity () spawn = #14; 
// void (entity e) remove = #15; // MG1 modifies
.void(float deltaTime) tick;
void RemoveFrameTickEntity(entity rem);
void(entity e) remove_real			= #15;
void(entity e) remove
{
	if (e.tick) RemoveFrameTickEntity(e);
	remove_real(e);
};
void(vector v1, vector v2, float nomonsters, entity forent) traceline = #16; 
entity () checkclient = #17; 
entity (entity start, .string fld, string match) find = #18; 
string (string s) precache_sound = #19; 
string (string s) precache_model = #20; 
void (entity client, string s) stuffcmd = #21; 
entity (vector org, float rad) findradius = #22; 
void (...) bprint = #23:ex_bprint; 
void (...) sprint = #24:ex_sprint; 
void (...) dprint = #25; 
// void(string s, ...) kex_bprint = #0:ex_bprint;
// void(entity client, string s, ...) kex_sprint = #0:ex_sprint;
string (float f) ftos = #26; 
string (vector v) vtos = #27; 
void () coredump = #28; 
void () traceon = #29; 
void () traceoff = #30; 
void (entity e) eprint = #31; 
float (float yaw, float dist) walkmove = #32; 
float DROPTOFLOOR_DISABLE = 65536;
float(float yaw, float dist) droptofloor_real = #34;	// TRUE if landed on floor
float() droptofloor = 
{ 
	if (self.spawnflags & DROPTOFLOOR_DISABLE) return TRUE;
	return droptofloor_real(0, 0); 
}

// float () droptofloor = #34; 
// void (float style, string value) lightstyle = #35; 
void(float style, string value) lightstyle = #35;
float (float v) rint = #36; 
float (float v) floor = #37; 
float (float v) ceil = #38; 
float (entity e) checkbottom = #40; 
float (vector v) pointcontents = #41; 
float (float f) fabs = #43; 
vector (entity e, float speed) aim = #44; 
float (string s) cvar = #45; 
void (string s) localcmd = #46; 
entity (entity e) nextent = #47; 
void (vector o, vector d, float color, float count) particle = #48; 
void () ChangeYaw = #49; 
vector (vector v) vectoangles = #51; 
void (float to, float f) WriteByte = #52; 
void (float to, float f) WriteChar = #53; 
void (float to, float f) WriteShort = #54; 
void (float to, float f) WriteLong = #55; 
void (float to, float f) WriteCoord = #56; 
void (float to, float f) WriteAngle = #57; 
void (float to, string s) WriteString = #58; 
void (float to, entity s) WriteEntity = #59; 
void (float step) movetogoal = #67; 
string (string s) precache_file = #68; 
void (entity e) makestatic = #69; 
void (string s) changelevel = #70; 
void (string var, string val) cvar_set = #72; 
void (entity client, string s, ...) id1_centerprint = #73; // sprint, but in middle

// void (entity client, string s, ...) ex_centerprint = #0:ex_centerprint;	// sprint, but in middle
void (vector pos, string samp, float vol, float atten) ambientsound = #74; 
string (string s) precache_model2 = #75; 
string (string s) precache_sound2 = #76; 
string (string s) precache_file2 = #77; 
void (entity e) setspawnparms = #78; 

// .float healthrot_nextcheck;
.float healthtime;

void(vector tdest, float tspeed, void() func) SUB_CalcMove;
void(entity ent, vector tdest, float tspeed, void() func) SUB_CalcMoveEnt;
void(vector destangle, float tspeed, void() func) SUB_CalcAngleMove;
void() SUB_CalcMoveDone;
void() SUB_CalcAngleMoveDone;
void() SUB_Null;
void() SUB_UseTargets;
void() SUB_Remove;

.float captures;
float timelimit;
float fraglimit;
float capturelimit;

// 
// new_items.qc
//
void(entity theEntity) UpdateAmmoCounts;

//
// dmatch.qc
//
//void() tag_token_respawn;
//void() tag_token_touch;
//void() tag_token_drop;

// sphere.qc
void(entity ownerEntity) sphere_remove;

//
// elevator fields
//

.float 		elevatorLastUse;
.float		elevatorOnFloor;
.float		elevatorToFloor;
.vector		elevatorDestination; 

//
// plat2 fields
//
.float		plat2Called;
.float		plat2LastMove;
.float		plat2GoTime;
.float		plat2GoTo;

//
// new AI fields
//
.float		orbitPosition;

//
// dragon specific fields
// 
.float playerInRoom;
.float playerInTransit;
.float dragonInRoom;
.float dragonInTransit;
.float dragonAttacking;
.float dragonPainSequence;
.vector dragonLastVelocity;

//
// Other Rogue Fields
//
.float		AGping;
.float		childrenSpawned;
.float		ltrailLastUsed;
.float		shield_death_time;
.float		shieldSoundTime;
.float		dragonDeathState;

// .float		tag_frags;
// .float		tag_message_time;


.float		shield_finished, antigrav_finished;
.float		shield_time, antigrav_time;
.entity		shield_entity;

// rogue globals!
float 	earthquake_active;
float	earthquake_intensity;
float	cutscene_running;
// entity  tag_token_owner;

float() finaleFinished = #0:ex_finaleFinished;

// Debug rendering functions.
void draw_point( vector point, float colormap, float lifetime, float depthtest ) = #0:ex_draw_point;
void draw_line( vector start, vector end, float colormap, float lifetime, float depthtest ) = #0:ex_draw_line;
void draw_arrow( vector start, vector end, float colormap, float size, float lifetime, float depthtest ) = #0:ex_draw_arrow;
void draw_ray( vector start, vector direction, float length, float colormap, float size, float lifetime, float depthtest ) = #0:ex_draw_ray;
void draw_circle( vector origin, float radius, float colormap, float lifetime, float depthtest ) = #0:ex_draw_circle;
void draw_bounds( vector min, vector max, float colormap, float lifetime, float depthtest ) = #0:ex_draw_bounds;
void draw_worldtext( string s, vector origin, float size, float lifetime, float depthtest ) = #0:ex_draw_worldtext;
void draw_sphere( vector origin, float radius, float colormap, float lifetime, float depthtest ) = #0:ex_draw_sphere;
void draw_cylinder( vector origin, float halfHeight, float radius, float colormap, float lifetime, float depthtest ) = #0:ex_draw_cylinder;

// Bot functions that return a value based on "BOT_GOAL_<X>", depending on the status of the goal.
float bot_movetopoint( entity bot, vector point ) = #0:ex_bot_movetopoint;
float bot_followentity( entity bot, entity goal ) = #0:ex_bot_followentity;

void prompt( entity client, string text, float numChoices ) = #0:ex_prompt;
void promptchoice( entity client, string text, float impulse ) = #0:ex_promptchoice;
void clearprompt( entity client ) = #0:ex_clearprompt;

// .string		type;			// to make find()ing easier, and for tons of useful misc. classification
// .float		lifetime_finished;
float TRACK_RANGE      = 400;
float INACCURACY_RANGE = 400;
float INACCURACY_DIST  = 200;