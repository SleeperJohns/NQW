/*
=================================================
NET QUAKEWORLD
=================================================
NEW CHARACTER INSTRUCTIONS
* Character mdl must have matching animation frame counts with default player.mdl;
	they don't have to be animated the same, but we still use the player animation calls.
	Ability / extra animations should start on frame 144.
* Character should be sized similarly to Ranger as they will use his navigation hull. See nqwcharcs.qc > NQW_SpawnCharacter.
* If using a custom melee weapon, the first 9 frames must be dedicated to idle (1), swing A (2-4), and swing B (5-8).
	If reusing the melee model for an ability, add these extra animations starting from frame 10.
* nqwdefs.qc:
	-Add the Spawn method references.
	-Add a float constant for the Character ID. Don't conflict with other Character IDs.
* nqwcharcs.qc:
	-Add all required precaches (models, sounds) to NQW_Precaches. Every model and sound you use for your champion.
	-Add Character spawn method call to NQW_SpawnCharacter.
	-Add Character to selection method NQW_PickCharacter.

Character SPAWN METHOD TEMPLATE
All of the fields must be defined. I can't be held responsible for your failure to do so.

Disclaimer: PLEASE NOTE THAT THIS IS BASED OF QUAKE CHAMPIONS CLASSIC MOD! I DID NOT CODE THIS FROM SCRATCH! ALL CREDIT GOES IT'S ORIGINAL CREATOR! - Sleeper, Son Of Spyro

void() NQW_CharacterName =
	{
		// Model
		setmodel (self, "progs/player_ranger.mdl");
		NQW_SetSkin(1); // argument is # of skins in mdl
		self.nqwChampGib = "progs/h_player.mdl"; // head model on gib
		self.nqwMeleeMdl = "progs/v_axe.mdl"; // melee weapon model
		// Sounds
		self.nqwSndMelee = // axe, sword, gauntlet sound
		self.nqwSndMeleeHit = // melee weapon sound when hitting an enemy; leave as "" for none (default behavior)
		self.nqwSndMeleeWall = // melee weapon sound when hitting a wall
		self.nqwSndJump = 
		self.nqwSndLand1 = // soft landing
		self.nqwSndLand2 = // cronch landing
		self.nqwSndPain1 = 
		self.nqwSndPain2 = 
		self.nqwSndPain3 = 
		self.nqwSndPain4 = 
		self.nqwSndPain5 = 
		self.nqwSndPain6 = 
		self.nqwSndDeath1 = 
		self.nqwSndDeath2 = 
		self.nqwSndDeath3 = 
		self.nqwSndDeath4 = 
		self.nqwSndDeath5 = 
		self.nqwSndAxHit1 = 
		self.nqwSndBurn1 = 
		self.nqwSndBurn2 = 
		self.nqwSndGasp1 = // gasping for air on water exit
		self.nqwSndGasp2 = 
		self.nqwSndDrown1 = // water pain
		self.nqwSndDrown2 = 
		self.nqwSndH2oDeath = 
	};
	
*/

// Sleeper: Note to self, all this shit needs to properly organized.

//.float player_collision;

#define redify(s) strconv(0,2,2,s)

void() OffHand_W_FireGrapple;
void() OffHand_UnHookPlayer;
.entity hook; // This is my hook
.float hookdmg;

// Weapon Grappling Hook
.entity hookentity;
.float on_hook;  // We're on it
.float hook_out; // It's out
.float grappling_hook_time;

// Offhand Grappling Hook
.entity offhand_hookentity;
.float offhand_on_hook;      // We're on it
.float offhand_hook_out;     // It's out
.float offhand_fire_hook;    // Sleeper: For Off-Hand Grappling Hook.
.float offhand_hook_enabled; // Sleeper: A fake pickup.
.float offhand_hook_time;

float sys_ticrate = 0.013;

float OGRE_BOSS	= 2;
float OGRE_NORMAL = 4;

.float playerjump_finished;

string themap;
// .float has_vote;
float nomap;
float num_votes;
float votestarted;
.float has_voted;
.float vote_wait;
.float startedvote;

string gametype_coop = "0";
string gametype_dm = "1";
string gametype_vote_style;

// Horde Mode
.float killcount;
.float killtotal;
.float cnt_horde;

// Custom Coop flag
float customcoop_flags;

// Spawn Protection (Custom Coop only)
.float spawn_protection_finished;
.float spawn_protection_time;
// .float spawn_protection_sound;

// Item lockout systems (Index number usually is the choice of max player limit, adjust if desired but must match max player limit or higher on your server).
// Just keep in mind that 256 is the absolute maximum you can achieve for an array due to the max player limit.
// Time + # is temporary lockout for that player that picked up the item, -1 is permanent lockout for that player that picked up the item.
float MAX_ACTIVE_PLAYERS = 16; 		    // Sleeper: Adjust this depending on your maxplayers limit desires.
// Powerups
.float powerup_lockout[MAX_ACTIVE_PLAYERS];  // Up to 16 players allowed to pickup the same powerup.
.float powerup_lockout_selective; 	     // A hack to use self.model & self.solid in certain cases.
.float powerup_pickedup[MAX_ACTIVE_PLAYERS]; // Visually despawn a powerup for a player.
// Weapons
.float weapon_lockout[MAX_ACTIVE_PLAYERS];   // Up to 16 players allowed to pickup the same weapon.
.float weapon_lockout_selective; 	     // A hack to use self.model & self.solid in certain cases.
.float weapon_pickedup[MAX_ACTIVE_PLAYERS];  // Visually despawn a weapon for a player.
// Ammo
.float ammo_lockout[MAX_ACTIVE_PLAYERS];     // Up to 16 players allowed to pickup the same ammo pack.
.float ammo_lockout_selective;   	     // A hack to use self.model & self.solid in certain cases.
.float ammo_pickedup[MAX_ACTIVE_PLAYERS];    // Visually despawn an ammopack for a player.
// Armor
.float armor_lockout[MAX_ACTIVE_PLAYERS];    // Up to 16 players allowed to pickup the same armor.
.float armor_lockout_selective;   	     // A hack to use self.model & self.solid in certain cases.
.float armor_pickedup[MAX_ACTIVE_PLAYERS];   // Visually despawn an armor for a player.
// Health
.float health_lockout[MAX_ACTIVE_PLAYERS];   // Up to 16 players allowed to pickup the same health pack.
.float health_lockout_selective;  	     // A hack to use self.model & self.solid in certain cases.
.float health_pickedup[MAX_ACTIVE_PLAYERS];  // Visually despawn a healthpack for a player.

// Sleeper: I'm curious how I would be able to replace self.model with this. The goal is to make the item systems like Destiny, Serious Sam or Quake II's remaster item system.
// .string item_model[32];

// Config Settings
float initial_vote;
void() Gametype_Duel_Settings;
void() Gametype_FFA_Settings;
void() Gametype_TDM_Settings;
void() Gametype_CTF_Settings;
void() Gametype_OneFlagCTF_Settings;
void() Gametype_Reignited_Coop_Settings;
void() Gametype_Classic_Coop_Settings;
void() Gametype_Enhanced_Coop_Settings;
void() Gametype_Instagib_FFA_Settings;
// void() Gametype_Instagib_TDM_Settings;
// void() Gametype_Instagib_CTF_Settings;
// void() Gametype_Instagib_OneFlagCTF_Settings;
void() Gametype_Railwarz_FFA_Settings;
void() Gametype_Railwarz_CTF_Settings;
void() Gametype_Railwarz_OneFlagCTF_Settings;

// .float team_connection;
.float spectator;
// .string spectator;
// .float spectator_fake;
.float in_game;

float NEW_ONLY = 0;
float ALWAYS = 1;
float DISABLE = 2;
// .float weapon_autoswitch_mode;

// protocol bytes
float SVC_UPDATESTAT  = 3; // Yoder add, 23/09/2020
float SVC_CENTERPRINT = 26; // Yoder add, 23/09/2020		      

//
// monster ai
//
.float speed2;			// Yoder add, July 10 2020, used by func_doors' "door_go_down"

//
// object stuff
//
float START_OFF = 1;

.float special_spawned_pickup_sound;
.float special_noise;

void(string s) centerprint_all =
{
	entity e = find (world, classname, "player");
	while (e)
	{
		id1_centerprint(e, s);
		e = find (e, classname, "player");
	}
};

// const float DROPTOFLOOR_DISABLE = 65536;
const float WORLDTYPE_HUB = 3;
//
// quakeed fields
//
float SPAWNFLAG_NOMESSAGE = 1;
float SPAWNFLAG_NOTOUCH = 1;
float SPAWNFLAG_TRIGGER_FIRST = 2;
float SPAWNFLAG_NEARSIGHTED = 8192;
.float spawn_deferred;
void(float step) movetogoal = #67;
// Path monsters to the goal using any available nav nodes on the map
float(float movedist, vector goal) walkpathtogoal = #0:ex_walkpathtogoal;
// mal: codes that the QuakeC built-in "walkpathtogoal" will return each time it's called
float PATH_ERROR 	    = 0;	// something bad happened ( no nav nodes, no nearby nodes, no path, etc. ).
float PATH_REACHED_GOAL     = 1;	// reached whatever we were trying to get to.
float PATH_REACHED_PATH_END = 2;	// reached the end of the path - can now move directly to target.
float PATH_MOVE_BLOCKED     = 3;	// something ( or someone ) is in our way.
float PATH_IN_PROGRESS 	    = 4;	// path was found, and we're following it.

// Combat style
.float combat_style;
float CS_NONE   = 0; // default - for bosses or other monsters that don't move.
float CS_RANGED	= 1;
float CS_MELEE	= 2;
float CS_MIXED  = 3; // can do ranged or melee equally.
.float allowPathFind; // whether or not AI can used advanced pathfinder.
nosave float load_flag;
float isHordeMode; 	// mal: cache off horde cvar
float keys_silver; // number of silver keys the players are carrying
float keys_gold; // number of gold keys the players are carrying
entity horde_ent; // global horde manager so code can reference without lookup
float DEFAULT_POWERUP_CHANCE = 0.025;
float POWERUP_CHANCE_GAIN = 0.025;
float powerup_chance;
.string category; // to do find operations by type
string CATEGORY_MONSTER = "monster";
const float WORLDTYPE_MEDIEVAL = 0;
const float WORLDTYPE_METAL = 1;
const float WORLDTYPE_BASE = 2;
const float WORLDTYPE_HUB = 3;
.float worldtype;
float FADETIME = 5; // STATIC GLOBAL, how long after death until monsters fade out

.float aggro_time; // when a monster is aggro'd, set this value to the time. Future aggro's check against this.
float AGGRO_MIN = 1; // how long to wait before allowing a new Aggro
float AGGRO_ADD = 1; // random additional wait

.float killtime; // game time at which player got their last killed
.float killspree; // player's current killing spree
float KILLSPREE_GAP = 2; // amount of time that can lapse for a kill to no longer count as part of a spree

float MONSTER_ATTACK_FRIEND = 32;
#ifdef MONSTERS_AWARE_OF_CONTENTS
float	SPAWNFLAG_NO_CONTENTS_DAMAGE = 16384;
#endif

void() remote_wavecheck; // trigger wavecheck from outside the base entity

.float hunger_time;
float HUNGER_MAX = 10; // max delay between hunger pangs
float HUNGER_MIN = 2.5; // min delay between hunger pangs
float HORDE_START_DELAY = 10; // how long to wait before starting
float HORDE_AMMO_RESPAWN_DELAY = 20; // how long between horde ammo spawns

// AY Dec15 2021, moving from item_runes to defs since these get used by horde now
/*
float SIGIL_E1 = 1;
float SIGIL_E2 = 2;
float SIGIL_E3 = 4;
float SIGIL_E4 = 8;
float SIGIL_E5 = 16;
float SIGIL_E6 = 32;
*/
float SIGIL_E1 = 16;
float SIGIL_E2 = 32;
float SIGIL_E3 = 64;
float SIGIL_E4 = 128;
float SIGIL_E5 = 256;
float SIGIL_E6 = 512;
float SIGIL_NUMBITS = 6;

// Bots. Probably will give support for only Deathmatch modes.
float FL_ISBOT = 8192; 	// mal: this will be set on bot players

// Borrowed from Triggers
void(vector org) spawn_tfog;
void(vector org, entity death_owner) spawn_tdeath; 

// Spawned in worldspawn function
entity nqw_announcer;
.float nqw_queue_index;
.float delay1, delay2, delay3, delay4;
void() NQW_AnnouncerPlayback;
void(string snd, float delay) NQW_Announce;

// PRECACHE
/*
void() NQW_RangerPrecache;
void() NQW_SleeperPrecache;
void() NQW_VenomPrecache;
void() NQW_DoomguyPrecache;
*/
void() NQW_Precaches;

// SHARED
void() NQW_SpawnCharacter;
void() NQW_PickCharacter;
void(float max_skins) NQW_SetSkin;
void() NQW_SwapSkin;

// CHARACTERS
void() NQW_Ranger; // Ranger
void() NQW_Sleeper; // Sleeper
void() NQW_Venom; // Venom
void() NQW_Doomguy; // Doomguy
void() NQW_Scalebearer; // Scalebearer
void() NQW_Sorlag; // Sorlag
void() NQW_DukeNukem; // Duke Nukem
void() NQW_DuskDude; // Dusk Dude

// Duke Nukem Stuff
void(entity collector, entity item) NQW_DukeItem;
void(entity targ, entity attacker) NQW_DukeFrag;
void() NQW_DukeModel;
void() NQW_DukeSpawn;
void() NQW_Duke_tauntlist;
.float onetime_line;

// Caleb stuff
void(entity targ, entity attacker) NQW_CalebFrag;
void(entity collector, entity item) NQW_CalebItem;
void() NQW_Caleb;
void() NQW_CalebSpawn;
void() NQW_Caleb_tauntlist;

// Character IDs
/*
float NQW_RANGER = 0;
float NQW_SLEEPER = 1;
float NQW_VENOM = 2;
float NQW_DOOMGUY = 3;
float NQW_SCALEBEARER = 4;
float NQW_SORLAG = 5;
float NQW_DUKENUKEM = 6;
float NQW_CALEB
float NQW_DUSKDUDE = 7;
float NQW_CHARCS_MAX = 8;
*/

// Character IDs
enum: float 
{
	NQW_RANGER,
	NQW_SLEEPER,
	NQW_VENOM,
	NQW_DOOMGUY,
	NQW_SCALEBEARER,
	NQW_SORLAG,
	NQW_DUKENUKEM,
	NQW_CALEB,
	NQW_DUSKDUDE,
	NQW_CHARCS_MAX
};

// Flags
float NQW_FL_THROWABLE = 1;
// .float nqwFlags;

.float nqwNextCharacter;
.float nqwCharacter;
// .float nqwLastCharacter;
.float modelindex_nqwplayer; // used in conjunction with the client.qc hackery, maintains champion model indexing after invisibility and other nonsense
.float nqwSkin;
.float nqwGibSkins;
.string nqwCharGib; // head model on gib
.string nqwMeleeMdl; // melee weapon model
.string nqwHammerMdl; // mjolnir model

.float nqwTauntTimer;

// .float weapons_inventory;
.float falling;

void(entity targ, entity attacker) NQW_SpeakFragNull = {};
void(entity collector, entity item) NQW_SpeakItemNull = {};

.void() nqwSpeakSpawn;
.void(entity targ, entity attacker) nqwSpeakFrag;
.void(entity collector, entity item) nqwSpeakItem;
.string nqwSpeakCthonGreet;
.string nqwSpeakCthonKill;
.string nqwSpeakShubGreet;
.string nqwSpeakShubKill;

// Players Sounds
.string nqwSndMelee; // axe, sword, gauntlet sound
.string nqwSndMeleeHit; // melee weapon enemy hit sound; leave "" for silent (default behavior)
.string nqwSndMeleeWall; // melee weapon wall hit sound
.string nqwSndJump;
.string nqwSndLand1; // soft landing
.string nqwSndLand2; // cronch landing
.string nqwSndFallDeath; // fall death
.string nqwSndQ1Pain1;
.string nqwSndQ1Pain2;
.string nqwSndQ1Pain3;
.string nqwSndQ1Pain4;
.string nqwSndQ1Pain5;
.string nqwSndQ1Pain6;
.string nqwSndQ2Pain1;
.string nqwSndQ2Pain2;
.string nqwSndQ2Pain3;
.string nqwSndQ2Pain4;
.string nqwSndQ2Pain5;
.string nqwSndQ2Pain6;
.string nqwSndQ2Pain7;
.string nqwSndQ2Pain8;
.string nqwSndDeath1;
.string nqwSndDeath2;
.string nqwSndDeath3;
.string nqwSndDeath4;
.string nqwSndDeath5;
.string nqwSndAxHit1;
.string nqwSndBurn1;
.string nqwSndBurn2;
.string nqwSndGasp1; // gasping for air on water exit
.string nqwSndGasp2;
.string nqwSndDrown1; // water pain
.string nqwSndDrown2;
.string nqwSndH2oDeath;
.string nqwSndFalling;

.float weapons;

// Powerup Drop
void(float powerup) Powerup_Drop;
.float droppable_item;

// float DROPTOFLOOR_DISABLE;
// Yoder add, September 9 2020
.float is_frozen; // defines whether an entity is frozen
const float COOP_ONLY = 32768; // yoder add, Jan 16 2021; Only spawn in coop. Used by items and monsters
const float COOP_SPAWN_ACTIVE = 73;

const float NOT_IN_COOP = 131072;
#define INHIBIT_COOP if (coop && self.spawnflags & NOT_IN_COOP) {remove(self); return;}

// Keep count of players
var float num_players = 0;
var float spectating_players = 0;

// Keep count of players on teams
var float redteam	 = 0;
var float blueteam	 = 0;
var float greyteam 	 = 0;
// var float humanteam	 = 0;
// var float monsterteam = 0;

// For nudging players off the respawn point
// .float deferspawn;

// ClientConnect Greetings
.float greet;
// .float MOTDstay;
float DISABLE_MOTD = 0;
float ENABLE_MOTD = 1;

// (FTE Only) New Cached Cvars
float teamknockback;
float falldamage;
float qw_physics_capped;
float qw_physics_speedcap;
float use_offhand_hook;
float use_grappling_hook;
float offhand_skyhook;
float offhand_hook_speed;
float offhand_hook_pullspeed;
float offhand_hook_anchor_time;
float offhand_hook_anchor_timeout;
float offhand_hook_enable_damage;
float offhand_hook_damage;
float grappling_skyhook;
float grappling_hook_speed;
float grappling_hook_pullspeed;
float grappling_hook_anchor_time;
float grappling_hook_anchor_timeout;
float grappling_hook_enable_damage;
float grappling_hook_damage;
float killthebunny;
// float speedrunning_mode; // Not yet.

// float sudden_death; // Overtime cvar
// float sudden_death_type; // 0 = Default (Off), 1 = Unbalanced Score Overtime Rules (Quake III: Arena/Team Arena/Champions), 2 = Enhanced Overtime Rules (Quake Live).
float sudden_death_engaged; // Put Sudden Death into affect when necessary.
float sudden_death_timelimit; // When does Sudden Death rounds expire?
// float sudden_death_max_rounds; // How many rounds can Sudden Death can have before the match is declared to be a draw.
float sudden_death_round_count; // What Sudden Death round are we on?
float loophack;  // Not a fucking word, Bell...
float loophack2; // Not a fucking word, Bell...
float endgame;
// float tourney_mode; // Not yet.
// float speedrunning_mode; // Not yet.
float warmup_engaged;
float warmup_countdown;
float start_warmup;
float warmup_counttime;

float initiate_matchtime;
float matchtime_timer;
float matchtime;


// Counts
.float cnt_mg1;  // Item Respawn cycles whenever the server is in Classic Co-Op in MG1, or in Custom Co-Op mode.
.float cnt_trig; // Trigger

// NQW miscs
.float nqwMaxSkins;
// .float nqwShubSight;

// Health Rot Systems
void() Vanilla_Item_Megahealth_Rot; // Vanilla 
void() Enhanced_Item_Megahealth_Rot; // Enhanced
void() Deflate_Health_Rot; // Deflate Health Spawn/Respawn only
.float health_deflate; // Deflate Health flag
.float health_overstacked; // Overstacked flag

// New Armor Rot System
void() Item_Armor_Rot;
.float armorrottime;
.float max_armorvalue;

// Client Checks
.string client;
string QSSM_CLIENT    = "QSS-M";
string FTEQW_CLIENT   = "FTE";
string EzQ_CLIENT     = "ezQuake";
string VANILLA_CLIENT = "Quake";

// Greeting Sound Controllers
void(string soundToPlay, float special_delay) greet_announcer;
entity speaker;
// .string snd;

// Are we playing any of the official campaigns?
float campaign_valid;
float campaign;

// Are we a brand new player connecting into the server?
// .float is_new;
// Client Identity States
.float client_tags;
float NEW_PLAYER_INIT 	       = 1;     // This player is brand new to the server. To be removed immediately after inheriting weapons and items.
float DETECT_NEW_CLIENT        = 2;     // Detect Clients. To be removed immediately after detecting a source port.
float CLIENT_PLAYER	       = 4;     // This client is a player.
float CLIENT_ENTERED           = 8;     // Client has entered the server. To be removed on notify.
float CLIENT_JOINED	       = 16;    // Client has joined the world. To be removed after disconnecting or joining spectator mode, or adding when joining the game.
float CLIENT_SPECTATOR         = 32;    // Client is a spectator. To be removed after disconnecting or joining the game.
float CLIENT_SPECTATOR_ENTERED = 64;    // Client has entered as a spectator. To be removed on notify.
float CLIENT_SPECTATOR_JOINED  = 128;   // Client has joined the sidelines. To be removed on notify.
float CLIENT_SPECTATOR_MOVED   = 256;   // Client moved to the sidelines. To be removed on notify.
// float HUMAN_PLAYER	       = 512;
// float BOT_PLAYER	       = 1024;
// float TEAM_HUMAN	       = 2048;
// float TEAM_BLUE	       = 4096;
// float TEAM_RED	       = 8192;
float NEW_PLAYER_MOTD          = 16384; // Send Message Of The Day to New Client. To be removed on join.

enum : float 
{
	TEAM_NONE,
	TEAM_WHITE_0,
	TEAM_BROWN_1,
	TEAM_LIGHT_BLUE_2,
	TEAM_GREEN_3,
	TEAM_RED_4,
	TEAM_ORANGE_5,
	TEAM_GOLD_6,
	TEAM_PEACH_7,
	TEAM_PURPLE_8,
	TEAM_MAGENTA_9,
	TEAM_TAN_10,
	TEAM_GREEN_11,
	TEAM_YELLOW_12,
	TEAM_BLUE_13,
	TEAM_MAX
};

float TeamScore[TEAM_MAX];
void(entity fragger, float new_frags) add_frag;
void(entity scorer, float new_score) add_score;

// Support for alpha
.float alpha;

/*
// Which Co-Operative experience do we want?
float REIGNITED_COOP = 1; // The Reignited Experience
float CLASSIC_COOP   = 2; // The Classic Experience
float ENHANCED_COOP  = 4; // The Enhanced Experience
*/

// Sleeper Must Die! spawnfunctions (Mainly for Skill 5, but can be used in Deathmatch and other skills too)
// Sleeper: This is used to manually tweak an experience in QC.
void(vector pos, vector angle, string clname, void() func) func_SpawnMonsterIdle;
void(vector pos, vector angle, string x, string clname, void() func) func_SpawnMonsterWalk;
void(vector pos, vector angle, string x, string y, void() func) func_SpawnPathCorner;
void(vector pos, vector angle, string clname, float ammo_type, void() func) func_SpawnAmmo;
void(vector pos, vector angle, string clname, float health_type, void() func) func_SpawnHealth;
void(vector pos, vector angle, string clname, void() func) func_SpawnWeapon;
void(vector pos, vector angle, string clname, float makesound, string msg, void() func) func_SpecialSpawnItem;
void(vector pos, vector angle, string clname, void() func) func_SpawnPowerups;
void() NQW_SleeperMustDie; // Call this in worldspawn once you grouped the spawnfunctions in this.

// Animate dummy after telefragging Shub Niggurath
void() standin_idle;

// What Mission Pack/Mod are we playing?
float gameworld;           // Mission Pack/Mod Controller
float UNKNOWN	     = -1; // Not a valid gameworld
float CUSTOM         = 0;  // Custom Maps for Custom Coop
float ID1            = 1;  // The base game
float HIPNOTIC       = 2;  // Official Mission Pack #1
float ROGUE          = 3;  // Official Mission Pack #2
float DOPA           = 4;  // Official Mission Pack #3
float MG1            = 5;  // Official Mission Pack #4
float APOTHEOSIS     = 6;  // NQW Exclusive Endless Horde Mode (For now)
// These are planned to be a built-in to this codebase. Although, I'll probably only get one or two of them in my lifetime added, there's just so much code to go through.
// float IMPEL       = 7;  // Unofficial Mission Pack #3
// float BBELIEF     = 8;  // Built-in MOD #1: Beyond Belief
// float RDE	     = 9;  // Built-in MOD #2: Runner's Delight
// float AD          = 10; // Built-in MOD #3: Arcane Dimensions
// float GOTSHUN     = 11; // Built-in MOD #4: Gotshun (uses Hipnotic assets)
// float DWELL 	     = 12; // Built-in MOD #5: Dwell (uses Copper assets)
// float ALKALINE    = 13; // Built-in MOD #6: Alkaline
// float BASEQ2_DEMO = 14; // Quake II Demo // Sleeper: To avoid a possible takedown, I'm only making the Quake II Demo maps playable. Not sure about adding all the weapons, but campaign wise, it'll only be the demo.
float Halt_GameWorld_Traffic;
void() Change_New_Cvars;
// float update_serverinfo;

// Sleeper: Bit of a clever hack. This field helps to respawn keys in coop when they have been removed out the world.
// It's main use for now, is when all players have disconnected, the key can automatically be respawned. As long as it
// wasn't already been used. 
// -1 = The key has been used, we don't need to respawn keys anymore.
//  0 = The key hasn't been picked up. 
//  1 = The key has been picked up. 
// .float coop_key_pickup;
.entity keytaker; // Sleeper: Hey, look another .owner deal.

float(string s) checkextension = #99;

// .__uint mask;
// __uint nomask = 0;
// __uint playermask = 1;
// __uint monstermask = 2;

// void(entity client, string sample) localsound = #0:ex_localsound;

/* Creates more Parm space */
// Encode and Decode Parms ------------------------------------------
float(float f) fixbyte =
{
	f = rint(f);
	if (f > 255) f = 255;
	else if (f < 0) f = 0;
	return f & 255;
};

float(float s1, float s2, float s3) encodeparms = {return fixbyte(s1) * 65536 + fixbyte(s2) * 256 + fixbyte(s3);};

float(float parm, float which) decodeparms =
{
	if (which == 1) return (parm / 65536) & 255;
	else if (which == 2) return (parm / 256) & 255;
	else return parm & 255;
};
// ------------------------------------------------------------------

// float(vector v) horizontal_vlen = {return (v_x + v_y) / 2;};

// Various helpful math functions
vector(vector point, float ang) NQW_RotatePointYaw =
{
	local vector vec = '0 1 0' * self.angles_y;
	
	makevectors(vec);
	vec = point;
	local float x = vec_x * v_forward_x - vec_y * v_forward_y;
	local float y = vec_x * v_forward_y + vec_y * v_forward_x;
	vec_x = x;
	vec_y = y;
	
	return vec;
};

// const float A_SHITLOAD = 9999999;

/*
=================================================
MODIFIED BASE QC FUNCTIONS
combat
	T_Damage			|	
	Killed				|	
	WaterMove			|	???
	PlayerPostThink		|	^^^
items
	T_Heal				|	
	item_health			|	
	health_touch		|	
	armor_touch			|	^^^
	weapon_touch		|	^^^
	sigil_touch			|	^^^
	powerup_touch		|	^^^
	bound_other_ammo	|	set ammo limits - shells, rockets: 100, nails: 200, cells: 100
	weapon_touch		|	set cells added on LG pickup 15
	ammo_touch			|	set ammo limits - shells, rockets: 100, nails: 200, cells: 100; remove auto swap
weapons
	W_FireAxe			|	added optional hit sound; set damage to 20
	W_FireShotgun		|	set pellets to 6
	W_FireSuperShotgun	|	set pellets to 14
	T_MissileTouch		|	removed RNG from damage
	W_FireLightning		|	set damage to 30
	spike_touch			|	set damage to 9
	superspike_touch	|	set damage to 12
	W_SetCurrentAmmo	|	don't update if using an ability; changed axe models to use nqwMeleeMdl reference
	W_BestWeapon		|	
	W_Attack			|	changed axe sound to use NQW reference
	CheatCommand		|	
	ImpulseCommands		|	added NQW_PickCharacter as Impulse 100; added NQW_SwapSkin as Impulse 137
world
	worldspawn			|	added call to NQW_Precache()
	CopyToBodyQue		|	added line to set proper skin
client
	SetChangeParms		|	parm16 to current champion; parm15 to current skin
	SetNewParms			|	parm15 to current skin (we don't add Champion here because it ends up in a loop of picking Ranger over and over)
	DecodeLevelParms	|	parm16 to current champion; parm15 to current skin
	ClientKill			|	changed modelindex_player to self.modelindex_nqwplayer
	PutClientInServer	|	this is where the player spawning happens; we should override it with NQW_SpawnCharacter()
	CheckPowerups		|	changed modelindex_player to self.modelindex_nqwplayer; override model update if playing as Nyx; ability ready notification
	PlayerJump			|	
	WaterMove			|	
	PlayerPreThink		|	
						|	
	ClientObituary		|	Added character specific melee and ability death messages; added inflictor entity to arguments
player
	player_axe1			|	
	player_axeb1		|	^^^^^^
	player_axec1		|	^^^^^^
	player_axed1		|	^^^^^^
	PainSound			|	modified all sound references to use nqwSnd... strings
	DeathSound			|	^^^^^^
	GibPlayer			|	changed ThrowHead() to use nqwCharGib
	PlayerDie			|	changed modelindex_player to self.modelindex_nqwplayer
monster_boss / cthon
	boss_death10		|	
	boss_awake			|	
monster_oldone / shub
	old_wait			|	new animation function to assist with "find_character()" (see below)
	find_character		|	new handler for when Shub sees a Character
	old_idle46			|	animation calls th_stand now, to make sure we can switch back to default behavior
	finale_1			|	changed "if (!pl) {error...}" to "if (pl) { remove(pl) }" on line 125;
	finale_4			|	changed player model placement to use the current champion model instead
	monster_oldone		|	Commented out "self.think = old_idle1"; added "self.th_stand = old_wait"
*/