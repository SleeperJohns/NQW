#define FTE_QC_HASHTABLES /* Provides efficient string-based lookups. */
#define _ACCESSORS
#define DP_SV_CUSTOMIZEENTITYFORCLIENT /* Deprecated feature for compat with DP. Can be slow, incompatible with splitscreen, usually malfunctions with mvds. */
#define FTE_FORCEINFOKEY /* Provides an easy way to change a user's userinfo from the server. */

#define PROTOCOL_VERSION_FTE		(('F'<<0) + ('T'<<8) + ('E'<<16) + ('X' << 24))
#define PEXT_FLOATCOORDS		0x00008000

#define PROTOCOL_VERSION_FTE2		(('F'<<0) + ('T'<<8) + ('E'<<16) + ('2' << 24))
#define PEXT2_REPLACEMENTDELTAS		0x00000008

#define DP_REGISTERCVAR

#define DP_QC_ETOS

#define EXT_DIMENSION_VISIBILITY
#define EXT_DIMENSION_PHYSICS
#define EXT_DIMENSION_GHOST

#ifdef _ACCESSORS
accessor strbuf : float;
accessor searchhandle : float;
accessor hashtable : float;
accessor infostring : string;
accessor filestream : float;
accessor filestream : float;
#else
#define strbuf float
#define searchhandle float
#define hashtable float
#define infostring string
#define filestream float
#endif

void(hashtable table, string name, __variant value, optional float typeandflags) hash_add = #289; /* Part of FTE_QC_HASHTABLES
		Adds the given key with the given value to the table.
		If flags&HASH_REPLACE, the old value will be removed, otherwise if flags&HASH_ADD then a duplicate entry will be added with a second value (can be obtained via hash_get's index argument).
		The type argument describes how the value should be stored in saved games, as well as providing constraints with the hash_get function. While you can claim that all variables are just vectors, being more precise can result in less issues with tempstrings or saved games - be sure to be explicit with EV_STRING where appropriate because tempstrings may be reclaimed before the get (especially with saved games or table 0). */

__variant(hashtable table, string name, optional __variant deflt, optional float requiretype, optional float index) hash_get = #290; /* Part of FTE_QC_HASHTABLES
		Looks up the specified key name in the hash table. Returns deflt if the key was not found.
		If requiretype is specified then the function will only consider entries of the matching type (allowing you to store both flags+strings under a single name without getting confused).
		If index is specified then the function will ignore the first N entries with the same key (applicable only with entries added using HASH_ADD, not HASH_REPLACE), allowing you to store multiple entries. Keep querying higher indexes starting from 0 until it returns the deflt value.
		You will usually need to cast the result of this function to a real datatype. */

const float HASH_REPLACE = 256;	/* Used with hash_add. Attempts to remove the old value instead of adding two values for a single key. */
const float HASH_ADD = 512;	/* Used with hash_add. The new entry will be inserted in addition to the existing entry. */
const float EV_STRING = 1;
const float EV_FLOAT = 2;
const float EV_VECTOR = 3;
const float EV_ENTITY = 4;
const float EV_FIELD = 5;
const float EV_FUNCTION = 6;
const float EV_POINTER = 7;
const float EV_INTEGER = 8;
const float EV_UINT = 9;
const float EV_INT64 = 10;
const float EV_UINT64 = 11;
const float EV_DOUBLE = 12;

#ifdef _ACCESSORS
accessor hashtable : float
{
	inline get vector v[string key] = {return hash_get(this, key, '0 0 0', EV_VECTOR);};
	inline set vector v[string key] = {hash_add(this, key, value, HASH_REPLACE|EV_VECTOR);};
	inline get string s[string key] = {return hash_get(this, key, "", EV_STRING);};
	inline set string s[string key] = {hash_add(this, key, value, HASH_REPLACE|EV_STRING);};
	inline get float f[string key] = {return hash_get(this, key, 0.0, EV_FLOAT);};
	inline set float f[string key] = {hash_add(this, key, value, HASH_REPLACE|EV_FLOAT);};
	inline get __variant[string key] = {return hash_get(this, key, __NULL__);};
	inline set __variant[string key] = {hash_add(this, key, value, HASH_REPLACE);};
};
#endif

float(string s) stof = #81; // get numerical value from a string
float(string filename, float mode) fopen = #110; // opens a file inside quake/gamedir/data/ (mode is FILE_READ, FILE_APPEND, or FILE_WRITE), returns fhandle >= 0 if successful, or fhandle < 0 if unable to open file for any reason
void(float fhandle) fclose = #111; // closes a file
string(float fhandle) fgets = #112; // reads a line of text from the file and returns as a tempstring
void(float fhandle, string s, ...) fputs = #113; // writes a line of text to the end of the file
float(string s) strlen = #114; // returns how many characters are in a string
string(string s1, string s2, ...) strcat = #115; // concatenates two or more strings (for example "abc", "def" would return "abcdef") and returns as a tempstring
string(string s, float start, float length) substring = #116; // returns a section of a string as a tempstring
vector(string s) stov = #117; // returns vector value from a string
string(string s, ...) strzone = #118; // makes a copy of a string into the string zone and returns it, this is often used to keep around a tempstring for longer periods of time (tempstrings are replaced often)
void(string s) strunzone = #119; // removes a copy of a string from the string zone (you can not use that string again or it may crash!!!)
string(float ccase, float redalpha, float redchars, string str, ...) strconv = #224; /* Part of FTE_STRINGS
		Converts quake chars in the input string amongst different representations.
		ccase specifies the new case for letters.
		 0: not changed.
		 1: forced to lower case.
		 2: forced to upper case.
		redalpha and redchars switch between colour ranges.
		 0: no change.
		 1: Forced white.
		 2: Forced red.
		 3: Forced gold(low) (numbers only).
		 4: Forced gold (high) (numbers only).
		 5+6: Forced to white and red alternately.
		You should not use this builtin in combination with UTF-8. */

float FILE_READ = 0; // opens file for read only
float FILE_APPEND = 1; // opens file for writing to the end of said file
float FILE_WRITE = 2; // opens file for writing only

#if MENU
FTEDEP("Redundant") string(string) strzone = #56; /* Part of FRIK_FILE, FTE_STRINGS, ZQ_QC_STRINGS Exists in FTE for compat only, no different from strcat. */
FTEDEP("Redundant") void(string) strunzone = #57; /* Part of FRIK_FILE, FTE_STRINGS, ZQ_QC_STRINGS Exists in FTE for compat only, does nothing. */
float(string) tokenize = #58; 			  /* Part of KRIMZON_SV_PARSECLIENTCOMMAND Splits up the given string into its different components (what constitutes a token separator is not well defined and has been hacked about with over the years so have fun with that), returning the number of tokens that were found. Call argv(0 through ret-1) to retrieve each individual token. Take care to not use this recursively. */
string(float) argv = #59; 			  /* Part of KRIMZON_SV_PARSECLIENTCOMMAND Returns one of the tokens found via tokenize (and equivelent builtins). */
#endif

#if !defined(CSQC) && !defined(NQSSQC) && !defined(QWSSQC)&& !defined(MENU)
	#ifdef QUAKEWORLD
		#define QWSSQC
	#else
		#define NQSSQC
	#endif
#endif
#if !defined(SSQC) && (defined(QWSSQC) || defined(NQSSQC))
	#define SSQC
#endif
#if defined(CSQC) || defined(MENU)
	#define DEP_CSQC DEP
#else
	#define DEP_CSQC __deprecated("Use CSQC for this")
#endif
#ifndef DEP
	#define DEP __deprecated //predefine this if you want to avoid our deprecation warnings.
#endif
#ifndef FTEDEP

#define strcmp strncmp
float(string s1, string s2) strcasecmp = #229; /* Part of FTE_STRINGS Compares the two strings without case sensitivity. Returns 0 if they are equal. The sign of the return value may be significant, but should not be depended upon. */
		
#ifdef SSQC

float SVC_SETVIEWPORT = 5;
.float hull;	/* Overrides the hull used by the entity for walkmove/movetogoal and not traceline/tracebox. */
.void() customphysics;	/* Called once each physics frame, overriding the entity's .movetype field and associated logic. You'll probably want to use tracebox to move it through the world. Be sure to call .think as appropriate. */
float trace_allsolid;
float trace_startsolid;
const float CONTENT_LADDER = -16;	/* If this value is assigned to a solid_bsp's .skin field, the entity will become a ladder volume. */
const float FL_FINDABLE_NONSOLID = 16384;	/* Allows this entity to be found with findradius */
const float MOVE_NORMAL = 0;
const float MOVE_NOMONSTERS = 1;	/* The trace will ignore all non-solid_bsp entities. */
const float MOVE_MISSILE = 2;	/* The trace will use a bbox size of +/- 15 against entities with FL_MONSTER set. */
const float MOVE_WORLDONLY = 3;	/* The trace will ignore everything but the worldmodel. This is useful for to prevent the q3bsp pvs+culling issues that come with spectator modes leaving the world . */
const float MOVE_HITMODEL = 4;	/* Traces will impact the actual mesh of the model instead of merely their bounding box. Should generally only be used for tracelines. Note that this flag is unreliable as an object can animate through projectiles. The bounding box MUST be set to completely encompass the entity or those extra areas will be non-solid (leaving a hole for things to go through). */
const float MOVE_TRIGGERS = 16;	/* This trace type will impact only triggers. It will ignore non-solid entities. */
const float MOVE_EVERYTHING = 32;	/* This type of trace will hit solids and triggers alike. Even non-solid entities. */
const float MOVE_LAGGED = 64;
const float FL_LAGGEDMOVE = 65536;

float(vector pos) pointcontents = #41; /*
		Checks the given point to see what is there. Returns one of the CONTENTS_* constants. Just because a point is empty does not mean that the player can stand there due to the size of the player - use tracebox for such tests. */
			
void(vector start, vector mins, vector maxs, vector end, float nomonsters, entity ent) tracebox = #90; /* Part of DP_QC_TRACEBOX
		Exactly like traceline, but a box instead of a uselessly thin point. Acceptable sizes are limited by bsp format, q1bsp has strict acceptable size values. */			

// Sleeper: More parms just in case.
float parm17, parm18, parm19, parm20, parm21, parm22, parm23, parm24, parm25, parm26, parm27, parm28, parm29, parm30, parm31, parm32;	/* Additional spawn parms, following the same parmN theme. */
float parm33, parm34, parm35, parm36, parm37, parm38, parm39, parm40, parm41, parm42, parm43, parm44, parm45, parm46, parm47, parm48;
float parm49, parm50, parm51, parm52, parm53, parm54, parm55, parm56, parm57, parm58, parm59, parm60, parm61, parm62, parm63, parm64;
string parm_string;	/* Like the regular parmN globals, but preserves string contents. */

// Sleeper: Useless prints.
void(entity ent, string text, optional string s0, optional string s1, optional string s2, optional string s3, optional string s4, optional string s5) centerprint_qex = #0:centerprint_qex; /* Remaster: Sends the strings to the client, which will order according to {#}. Also substitutes localised strings for $NAME strings. */	
void(string s, optional string s0, optional string s1, optional string s2, optional string s3, optional string s4, optional string s5, optional string s6) bprint_qex = #0:bprint_qex; 	    /* Remaster: Sends the strings to all clients, which will order them according to {#}. Also substitutes localised strings for $NAME strings. */
void(entity client, string s, optional string s0, optional string s1, optional string s2, optional string s3, optional string s4, optional string s5) sprint_qex = #0:sprint_qex; 	    /* Remaster: Sends the strings to the client, which will order according to {#}. Also substitutes localised strings for $NAME strings. */

string(string fmt, ...) sprintf = #627; /* Part of DP_QC_SPRINTF
		'prints' to a formatted temp-string. Mostly acts as in C, however %d assumes floats (fteqcc has arg checking. Use it.).
		type conversions: l=arg is an int, h=arg is a float, and will work as a prefix for any float or int representation.
		float representations: d=decimal, e,E=exponent-notation, f,F=floating-point notation, g,G=terse float, c=char code, x,X=hex
		other representations: i=int, s=string, S=quoted and marked-up string, v=vector, p=pointer
		so %ld will accept an int arg, while %hi will expect a float arg.
		entities, fields, and functions will generally need to be printed as ints with %i. */

// Sleeper: FTE Spectator Mode.
void() SpectatorConnect;		/* Called when a spectator joins the game. */
void() SpectatorDisconnect;		/* Called when a spectator disconnects from the game. */
void() SpectatorThink;			/* Called each frame for each spectator. */

string(string key) serverkey = #354; /*
		Look up a key in the server's public serverinfo string. If the key contains binary data then it will be truncated at the first null. */

float(string key, optional float assumevalue) serverkeyfloat = #0:serverkeyfloat; /*
		Version of serverkey that returns the value as a float (which avoids tempstrings). */

void(string key, void *ptr, optional int size) setserverkey = #0:setserverkey; /*
		Changes the server's serverinfo. */

.float maxspeed;

.vector movement;	/* These are the directions that the player is currently trying to move in (ie: which +forward/+moveright/+moveup etc buttons they have held), expressed relative to that player's angles. Order is forward, right, up. */

// Sleeper: Voting System (Mainly).
void(string cmd) SV_ParseClientCommand;	/* Provides QC with a way to intercept 'cmd foo' commands from the client. Very handy. Self will be set to the sending client, while the 'cmd' argument can be tokenize()d and each element retrieved via argv(argno). Unrecognised cmds MUST be passed on to the clientcommand builtin. */
string(entity e, string key) infokey = #80;    /* Part of FTE_QC_INFOKEY, QW_ENGINE If e is world, returns the field 'key' from either the serverinfo or the localinfo. If e is a player, returns the value of 'key' from the player's userinfo string. There are a few special exceptions, like 'ip' which is not technically part of the userinfo. */
float(string st) validatefile = #91;
void(entity e, string s) clientcommand = #440; /* Part of KRIMZON_SV_PARSECLIENTCOMMAND */
float(string s) tokenize = #441;	       /* Part of KRIMZON_SV_PARSECLIENTCOMMAND */
string(float n) argv = #442;		       /* Part of KRIMZON_SV_PARSECLIENTCOMMAND */

// string(string addr, string uinfo, string features) SV_CheckRejectConnection;	/* Called to give the mod a chance to ignore connection requests based upon client protocol support or other properties. Use infoget to read the uinfo and features arguments. */

.float pvsflags;	/* Reconfigures when the entity is visible to clients */
.float uniquespawnid;	/* Incremented by 1 whenever the entity is respawned. Persists across remove calls, for when the two-second grace period is insufficient. */
DEP_CSQC .float() customizeentityforclient;	/* Called just before an entity is sent to a client (non-csqc protocol). This gives you a chance to tailor 'self' according to what 'other' should see. */

void(entity player, string key, string value) forceinfokey = #213; /* Part of FTE_FORCEINFOKEY
		Directly changes a user's info without pinging off the client. Also allows explicitly setting * keys, including *spectator. Does not affect the user's config or other servers. */
		
string(entity ent) etos = #65; /* Part of DP_QC_ETOS*/

// Plays a sound that only "client" can hear. Useful for announcers...
// void(entity client, string sample) localsound = #0:qex_localsound;
// void(string soundname, optional float channel, optional float volume) localsound = #0:ex_localsound;
#endif

#define DP_QC_SPRINTF 
/* Provides the sprintf builtin, which allows for rich formatting along the lines of C's function with the same name. Not to be confused with QC's sprint builtin.*/

#define DP_QC_TRACEBOX

.float dimension_solid;    /* This is the bitmask of dimensions which the entity is solid within. This is not networked, instead csqc traces impacting ssqc entities assumes the ssqc entity to have a dimension_solid of 1. */
.float dimension_hit;    /* This is the bitmask of dimensions which the entity will be blocked by. If other.dimension_solid & self.dimension_hit, our traces will impact and not proceed. If its false, the traces will NOT impact, allowing self to pass straight through. */
.float dimension_see;    /* This is the dimension mask (bitfield) that the client is allowed to see. Entities and events not in this dimension mask will be invisible. */
.float dimension_seen;    /* This is the dimension mask (bitfield) that the client is visible within. Clients that cannot see this dimension mask will not see this entity. */
.float dimension_ghost;    /* If this entity is visible only within these dimensions, it will become transparent, as if a ghost. */
.float dimension_ghost_alpha;    /* If this entity is subject to dimension_ghost, this is the scaler for its alpha value. If 0, 0.5 will be used instead. */

void(float buf, float fl) WriteFloat = #280; /*
		Writes a full 32bit float without any data conversions at all, for full precision. */

void(vector where, float set) multicast = #82; /*
		Once the MSG_MULTICAST network message buffer has been filled with data, this builtin is used to dispatch it to the given target, filtering by pvs for reduced network bandwidth. */

const float SVC_CGAMEPACKET = 83;	/* Direct ssqc->csqc message. Must only be multicast. The data triggers a CSQC_Parse_Event call in the csqc for the csqc to read the contents. The server *may* insert length information for clients connected via proxies which are not able to cope with custom csqc payloads. This should only ever be used in conjunction with the MSG_MULTICAST destination. */

hashtable gamestate;	/* Special hash table index for hash_add and hash_get. Entries in this table will persist over map changes (and doesn't need to be created/deleted). */
const float MSG_MULTICAST = 4;
const float MSG_ENTITY = 5;
const float MSG_MULTICAST	= 4;
const float MULTICAST_ALL	= 0;
const float MULTICAST_PVS	= 2;
const float MULTICAST_ONE	= 6;
const float MULTICAST_ALL_R	= 3;
const float MULTICAST_PVS_R	= 5;
const float MULTICAST_ONE_R	= 7;
const float MULTICAST_INIT	= 8;

const float EVENT_HUD_ITEMS = 64;

void(float num, float type, .__variant fld) clientstat = #232; /* Part of EXT_CSQC
		Specifies what data to use in order to send various stats, in a client-specific way.
		'num' should be a value between 32 and 127, other values are reserved.
		'type' must be set to one of the EV_* constants, one of EV_FLOAT, EV_STRING, EV_INTEGER, EV_ENTITY.
		fld must be a reference to the field used, each player will be sent only their own copy of these fields. */
		
.float scale;

#ifdef MENU
float(string name, string value, float flags) registercvar = #42; /* Part of DP_REGISTERCVAR
		Creates the cvar if it didn't already exist. This presents issues for setting those cvars via startup configs of course, and autocvars are easier but I suppose they don't get any flags (which are ignored anyway, of course). */

string(entity) etos = #20; /* Part of DP_QC_ETOS*/
#endif

#ifdef CSQC
void(string sample, optional float channel, optional float volume) localsound = #65;
#endif