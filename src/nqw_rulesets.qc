/* DEATHMATCH CVAR VALUES
*/
float DM_DISABLED		    =	0;	// Disable Deathmatch
float DM_DUEL			    = 	1;	// 1v1
float DM_FFA			    = 	2;	// Free For All
float DM_TDM			    =	3; 	// Team Deathmatch
float DM_CTF			    =	4;	// Capture The Flag
float DM_OneFlagCTF		    =	5;	// One Flag Capture The Flag
// float DM_CA			    =	6;	// Clan Arena
// float DM_RA			    =	7;	// Rocket Arena
// float DM_Abyss_Duel		    =	8;	// Apotheosis Duel (1v1 with Monsters)
// float DM_Abyss_TDM		    =	9;	// Apotheosis Team Deathmatch (up to 4v4 with Monsters)

// Sleeper: Might add these back at a later time to make the everything official wise complete.
/*
float DM_DMATCH_TAG		    =	10;	// deathmatch tag, no 'team' stuff
float DM_CTF_ALT		    =	11;	// alternate CTF (three teams)
*/

/* INSTAGIB CVAR VALUES
*/
float INSTAGIB_OFF 	= 0;
float INSTAGIB_ON	= 1;
float INSTAGIB_RAILWARZ = 2; // Sleeper: Increases Railgun rate of fire from 2 to 1.1. Grappling Hooks do not harm players. Fast Grappling Hook Speeds.

/* COOPERATIVE CVAR VALUES
*/
float SINGLE_PLAYER  = 0; // The Single Player Experience
float REIGNITED_COOP = 1; // The Reignited Experience
float CLASSIC_COOP   = 2; // The Classic Experience
float ENHANCED_COOP  = 4; // The Enhanced Experience

/* DEATHMATCH TEAMPLAY CVAR VALUES
*/
float TEAM_FF_DISABLED		    =	0;	// Sleeper: Disabled Friendly Fire, used for Duels and Free For All.
float TEAM_FF_OFF		    =	1;	// Sleeper: You can only HURT yourself, but can't hurt your teammates. (Health only is protected)
float TEAM_FF_ON		    =	2;	// Sleeper: You can HURT yourself and your teammates. (Health and Armor won't be protected)
float TEAM_FF_NO_ARMOR_DMG     	    =	3;	// Sleeper: Like Teamplay 2, but you won't harm a teammate's armor. (Armor only is protected)
float TEAM_FF_NO_HEALTH_ARMOR_DMG   =	4;	// Sleeper: You can only HURT yourself, but can't HURT teammates. (Both Health and Armor are protected)

/* COOPERATIVE TEAMPLAY CVAR VALUES (A lazy copy of above lol)
*/
float COOP_FF_DISABLED		    =	0;	// Sleeper: If Teamplay and Deathmatch is off, Quake turns into a Single Player experience.
float COOP_FF_OFF		    =	1;	// Sleeper: You can't harm yourself, nor your allies.
float COOP_FF_ON		    =	2;	// Sleeper: You can harm yourself and your allies.
float COOP_FF_ALT		    =	3;	// Sleeper: An alternate variant of teamplay 1. You can harm self, but can't harm teammates.

/* GAMECFG CVAR VALUES
*/
float GAMECFG_ORIGINAL_RUNES	    =	1; // enable original runeset (default is disabled)
float GAMECFG_NQW_RUNES		    =	2; // enable Net QuakeWorld's variant of runeset (Quake III: Team Arena-like) 

// Sleeper: The rest of these serve no purpose -- prefer to be achieved by other means
// float GAMECFG_TEAM_ARMOR_DMG		=	2; // 2 team damage affects armor (default is not)
// float GAMECFG_TEAM_HEALTH_DMG	=	4; // 4 team damage affects health (default is not)
// float GAMECFG_USE_COLOR		=	8; // use color player joins as (if you join and start with blue, you will go
//    to blue team, same with red/green.  If you are an illegal color, you'll
//    get assigned).
// float GAMECFG_ALLOW_CHG		=	16; // allow people to change teams

/* Rulesets // Sleeper: Used to be very precise and accurate for every gameplay engagement without overlap.
*/
// Sleeper: Basic stuff.
/*
float() Is_SinglePlayer =
{
	if (cvar("deathmatch")) return FALSE;

	if (cvar("coop") & SINGLE_PLAYER) return TRUE;
	return FALSE;
};

float() Is_Coop =
{
	if (cvar("deathmatch")) return FALSE;

	if (cvar("coop")) return TRUE;
	return FALSE;
};

float() Is_Horde =
{
	if (cvar("deathmatch")) return FALSE;
	
	if (cvar("horde")) return TRUE;
	return FALSE;
};

float() Is_DM =
{
	if (cvar("coop") || cvar("horde")) return FALSE;

	if (cvar("deathmatch")) return TRUE;
	return FALSE;	
};

// Sleeper: For anything that needs specific modes.
float() Is_TeamBasedDMModes =
{
	if (cvar("coop") || cvar("horde")) return FALSE;

	if (cvar("deathmatch") == DM_TDM || cvar("deathmatch") == DM_CTF || cvar("deathmatch") == DM_OneFlagCTF) return TRUE;
	return FALSE;
};

float() Is_TDMMode =
{
	if (cvar("coop") || cvar("horde")) return FALSE;
	
	if (cvar("deathmatch") == DM_TDM) return TRUE;
	return FALSE;
};

float() Is_CTFModes =
{
	if (cvar("coop") || cvar("horde")) return FALSE;

	if (cvar("deathmatch") == DM_CTF) return TRUE;
	return FALSE;
};

float() Is_OneFlagCTFModes = 
{
	if (cvar("coop") || cvar("horde")) return FALSE;
	
	if (cvar("deathmatch") == DM_OneFlagCTF) return TRUE;
	return FALSE;
};

float() Is_DMModes =
{
	if (cvar("coop") || cvar("horde")) return FALSE;

	if (cvar("deathmatch") == DM_FFA) return TRUE;
	return FALSE;
};

float() Is_DuelDMMode = 
{
	if (cvar("coop") || cvar("horde")) return FALSE;

	if (cvar("deathmatch") == DM_DUEL) return TRUE;
	return FALSE;
};

float() Is_DMModes_NoItems =
{
	if (cvar("coop") || cvar("horde")) return FALSE;

	if (cvar("instagib")) return TRUE;
	return FALSE;
};

float() Is_DMModes_Items = 
{
	if (cvar("coop") || cvar("horde")) return FALSE;

	// Sleeper: Duels are wildcards for powerups, leave it out.
	if (cvar("deathmatch") == DM_FFA || cvar("deathmatch") == DM_TDM || cvar("deathmatch") == DM_CTF || cvar("deathmatch") == DM_OneFlagCTF) return TRUE;
	return FALSE;	
};

float() Is_InstaDM =
{
	if (cvar("coop") || cvar("horde")) return FALSE;
	
	if (cvar("instagib") == INSTAGIB_ON) return TRUE;	
	return FALSE;
};

float() Is_RailwarzDM =
{
	if (cvar("coop") || cvar("horde")) return FALSE;
	
	if (cvar("instagib") == INSTAGIB_RAILWARZ) return TRUE;
	return FALSE;
};

float() Is_DuelDMMode =
{
	if (cvar("coop") || cvar("horde")) return FALSE;
	
	if (cvar("deathmatch") == DM_DUEL) return TRUE;
	return FALSE;
}
*/
/* Rulesets End */