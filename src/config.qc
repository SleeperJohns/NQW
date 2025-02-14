// What version are we on? (Major, Minor, Patches)
string NQW_Version = "NQWVer 1.15.0";

float Version_To_Startframe_Traffic;

string() GameWorld_Name =
{
	if (gameworld == CUSTOM) return "Custom";
	if (gameworld == ID1) return "ID1";
	if (gameworld == HIPNOTIC) return "HIPNOTIC";
	if (gameworld == ROGUE) return "ROGUE";
	if (gameworld == DOPA) return "DOPA";
	if (gameworld == MG1) return "MG1";
	if (gameworld == APOTHEOSIS) return "APOTHEOSIS";
	
	return "Unknown";
};

string() Campaign_Name =
{
	if (!cvar("deathmatch"))
	{
		if (gameworld == CUSTOM) 
		{
			if (cvar("horde")) return "";
			return "Custom Maps";
		}
		if (gameworld == ID1) 
		{
			if (cvar("horde")) return "";
			return "Quake: The Offering";
		}
		if (gameworld == HIPNOTIC) 
		{
			if (cvar("horde")) return "";
			return "Scourge Of Armagon";
		}
		if (gameworld == ROGUE) 
		{
			if (cvar("horde")) return "";
			return "Dissolution Of Eternity";
		}
		if (gameworld == DOPA) 
		{
			if (cvar("horde")) return "";
			return "Dimension Of The Past";
		}
		if (gameworld == MG1) 
		{
			if (cvar("horde")) return "";
			return "Dimension Of The Machine";
		}
		if (gameworld == APOTHEOSIS) return "Apotheosis Abyss";
		
		return "Unknown";
	}
	
	return "N/A";
};

void() Create_New_Cvars =
{		
	// Convenient Cvars
	customcoop_flags = cvar("customcoop");
	teamknockback = cvar("teamknockback");
	falldamage = cvar("falldamage");
	qw_physics_capped = cvar("qw_physics_capped");
	qw_physics_speedcap = cvar("qw_physics_speedcap");
	killthebunny = cvar("allow_bunnyhopping");
//	speedrunning_mode = cvar("speedrunning_mode"); // Sleeper: Clamps everything needed down to what would be considered legal in a real speedrun. 1 = NQ Single Player, 2 = QW Single Player, 3 = NQ Co-Operative, 4 = QW Co-Operative.
		
	// Grappling Hook Cvars		
	use_offhand_hook = cvar("use_offhand_hook");
	offhand_skyhook = cvar("offhand_skyhook");
	offhand_hook_speed = cvar("offhand_hook_speed");
	offhand_hook_pullspeed = cvar("offhand_hook_pullspeed");
	offhand_hook_anchor_time = cvar("offhand_hook_anchor_time");
	offhand_hook_anchor_timeout = cvar("offhand_hook_anchor_timeout");
	offhand_hook_enable_damage = cvar("offhand_hook_enable_damage");
	offhand_hook_damage = cvar("offhand_hook_damage");
	
	use_grappling_hook = cvar("use_grappling_hook");
	grappling_skyhook = cvar("grappling_skyhook");
	grappling_hook_speed = cvar("grappling_hook_speed");
	grappling_hook_pullspeed = cvar("grappling_hook_pullspeed");
	grappling_hook_anchor_time = cvar("grappling_hook_anchor_time");
	grappling_hook_anchor_timeout = cvar("grappling_hook_anchor_timeout");
	grappling_hook_enable_damage = cvar("grappling_hook_enable_damage");
	grappling_hook_damage = cvar("grappling_hook_damage");	

	// Randomize or Next Map
	random_maps = cvar("random_maps");
	
	// Player Collision
	player_collision_enabled = cvar("player_collision");
};

void() Change_New_Cvars =
{
	// Custom Coop	
	forceinfokey (world, "customcoop", ftos(cvar("customcoop")));
		
	// Teamknockback
	forceinfokey (world, "teamknockback", ftos(cvar("teamknockback")));
		
	// Falling Damage
	forceinfokey (world, "falldamage", ftos(cvar("falldamage")));
		
	// Offhand Hook	
	forceinfokey (world, "use_offhand_hook", ftos(cvar("use_offhand_hook")));
	forceinfokey (world, "offhand_hook_speed", ftos(cvar("offhand_hook_speed")));
	forceinfokey (world, "offhand_hook_pullspeed", ftos(cvar("offhand_hook_pullspeed")));
	forceinfokey (world, "offhand_hook_anchor_time", ftos(cvar("offhand_hook_anchor_time")));
	forceinfokey (world, "offhand_hook_anchor_timeout", ftos(cvar("offhand_hook_anchor_timeout")));
	forceinfokey (world, "offhand_hook_enable_damage", ftos(cvar("offhand_hook_enable_damage")));
	forceinfokey (world, "offhand_hook_damage", ftos(cvar("offhand_hook_damage")));
	forceinfokey (world, "offhand_skyhook", ftos(cvar("offhand_skyhook")));
		
	// Grappling Hook
	forceinfokey (world, "use_grappling_hook", ftos(cvar("use_grappling_hook")));
	forceinfokey (world, "grappling_hook_speed", ftos(cvar("grappling_hook_speed")));
	forceinfokey (world, "grappling_hook_pullspeed", ftos(cvar("grappling_hook_pullspeed")));
	forceinfokey (world, "grappling_hook_anchor_time", ftos(cvar("grappling_hook_anchor_time")));
	forceinfokey (world, "grappling_hook_anchor_timeout", ftos(cvar("grappling_hook_anchor_timeout")));
	forceinfokey (world, "grappling_hook_enable_damage", ftos(cvar("grappling_hook_enable_damage")));
	forceinfokey (world, "grappling_hook_damage", ftos(cvar("grappling_hook_damage")));
	forceinfokey (world, "grappling_skyhook", ftos(cvar("grappling_skyhook")));
		
	// Bunnies
	forceinfokey (world, "qw_physics_capped", ftos(cvar("qw_physics_capped")));
	forceinfokey (world, "qw_physics_speedcap", ftos(cvar("qw_physics_speedcap")));
	forceinfokey (world, "allow_bunnyhopping", ftos(cvar("allow_bunnyhopping")));
		
	// Capturelimit	
	forceinfokey (world, "capturelimit", ftos(cvar("capturelimit")));
		
	// Warmup
	forceinfokey (world, "warmup", ftos(cvar("warmup")));
		
	// Instagib
	forceinfokey (world, "instagib", ftos(cvar("instagib")));
		
	// Sudden Death
	forceinfokey (world, "sudden_death", ftos(cvar("sudden_death")));
	
	// Player Collision
	forceinfokey (world, "player_collision", ftos(cvar("player_collision")));					
};

/*
============================
Server_Hostname_Change

Change the server's hostname accordingly 
============================
*/
void() Server_Hostname_Change =
{	
	// Change hostname depending on the Game World and Gametype.
	if (!cvar("developer"))
	{
		// Cooperative
		if (cvar("sv_public") == 1)
		{
			if (cvar("coop") == REIGNITED_COOP && !cvar("horde") && !cvar("deathmatch") && !cvar("instagib"))
			{
				// iD1 Cooperative
				if (gameworld == ID1) cvar_set("hostname", "ID1-NQW: Co-Op (Hybrid: FTE/QSSM ONLY)");
				// HIPNOTIC Cooperative
				else if (gameworld == HIPNOTIC)	cvar_set("hostname", "HIPNOTIC-NQW: Co-Op (Hybrid: FTE/QSSM ONLY)");
				// ROGUE Cooperative
				else if (gameworld == ROGUE) cvar_set("hostname", "ROGUE-NQW: Co-Op (Hybrid: FTE/QSSM ONLY)");
				// DOPA Cooperative
				else if (gameworld == DOPA) cvar_set("hostname", "DOPA-NQW: Co-Op (Hybrid: FTE/QSSM ONLY)");
				// MG1 Cooperative
				else if (gameworld == MG1) cvar_set("hostname", "MG1-NQW: Co-Op (Hybrid: FTE/QSSM ONLY)");	
				// Custom Maps Cooperative
				else cvar_set("hostname", "CUSTOM-NQW: Co-Op (Hybrid: FTE/QSSM ONLY)");
			}
			// Cooperative Speedrun
			else if (cvar("coop") == CLASSIC_COOP && !cvar("horde") && !cvar("deathmatch") && !cvar("instagib"))
			{
				// iD1 Cooperative Speedrun
				if (gameworld == ID1) cvar_set("hostname", "ID1-NQW: Co-Op Speedrun (Hybrid: FTE/QSSM ONLY)");
				// HIPNOTIC Cooperative Speedrun	
				else if (gameworld == HIPNOTIC) cvar_set("hostname",  "HIPNOTIC-NQW: Co-Op Speedrun (Hybrid: FTE/QSSM ONLY)");
				// ROGUE Cooperative Speedrun
				else if (gameworld == ROGUE) cvar_set("hostname",  "ROGUE-NQW: Co-Op Speedrun (Hybrid: FTE/QSSM ONLY)");
				// DOPA Cooperative Speedrun
				else if (gameworld == DOPA) cvar_set("hostname",  "DOPA-NQW: Co-Op Speedrun (Hybrid: FTE/QSSM ONLY)");
				// MG1 Cooperative Speedrun
				else if (gameworld == MG1) cvar_set("hostname",  "MG1-NQW: Co-Op Speedrun (Hybrid: FTE/QSSM ONLY)");
				// Custom Maps Cooperative Speedrun
				else cvar_set("hostname",  "CUSTOM-NQW: Co-Op Speedrun (Hybrid: FTE/QSSM ONLY)");
			}
			// Single Player Speedrun
			else if (!cvar("coop") && !cvar("horde") && !cvar("deathmatch") && !cvar("instagib"))
			{
				// iD1 Single Player Speedrun
				if (gameworld == ID1) cvar_set("hostname",  "ID1-NQW: Solo Speedrun (Hybrid: FTE/QSSM ONLY)");
				// HIPNOTIC Single Player Speedrun
				else if (gameworld == HIPNOTIC)	cvar_set("hostname", "HIPNOTIC-NQW: Solo Speedrun (Hybrid: FTE/QSSM ONLY)");
				// ROGUE Single Player Speedrun
				else if (gameworld == ROGUE) cvar_set("hostname", "ROGUE-NQW: Solo Speedrun (Hybrid: FTE/QSSM ONLY)");
				// DOPA Single Player Speedrun	
				else if (gameworld == DOPA) cvar_set("hostname", "DOPA-NQW: Solo Speedrun (Hybrid: FTE/QSSM ONLY)");
				// MG1 Single Player Speedrun
				else if (gameworld == MG1) cvar_set("hostname", "MG1-NQW: Solo Speedrun (Hybrid: FTE/QSSM ONLY)");
				// Custom Maps Single Player Speedrun	
				else cvar_set("hostname", "CUSTOM-NQW: Solo Speedrun (Hybrid: FTE/QSSM ONLY)");
			}
			// Duel
			else if (!cvar("coop") && !cvar("horde") && cvar("deathmatch") == DM_DUEL && !cvar("instagib"))
			{
				// iD1 Duel
				if (gameworld == ID1) cvar_set("hostname", "ID1-NQW: Duel (Hybrid: FTE/QSSM ONLY)");
				// HIPNOTIC Duel
				else if (gameworld == HIPNOTIC)	cvar_set("hostname", "HIPNOTIC-NQW: Duel (Hybrid: FTE/QSSM ONLY)");
				// ROGUE Duel
				else if (gameworld == ROGUE) cvar_set("hostname", "ROGUE-NQW: Duel (Hybrid: FTE/QSSM ONLY)");
				// DOPA Duel	
				else if (gameworld == DOPA) cvar_set("hostname", "DOPA-NQW: Duel (Hybrid: FTE/QSSM ONLY)");
				// MG1 Duel
				else if (gameworld == MG1) cvar_set("hostname", "MG1-NQW: Duel (Hybrid: FTE/QSSM ONLY)");
				// Custom Maps Duel	
				else cvar_set("hostname", "CUSTOM-NQW: Duel (Hybrid: FTE/QSSM ONLY)");
			}
			// Free For All
			else if (!cvar("coop") && !cvar("horde") && cvar("deathmatch") == DM_FFA)
			{
				if (!cvar("instagib"))
				{
					// iD1 Free For All
					if (gameworld == ID1) cvar_set("hostname", "ID1-NQW: FFA (Hybrid: FTE/QSSM ONLY)");
					// HIPNOTIC Free For All	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "HIPNOTIC-NQW: FFA (Hybrid: FTE/QSSM ONLY)");
					// ROGUE Free For All
					else if (gameworld == ROGUE) cvar_set("hostname", "ROGUE-NQW: FFA (Hybrid: FTE/QSSM ONLY)");
					// DOPA Free For All	
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA-NQW: FFA (Hybrid: FTE/QSSM ONLY)");
					// MG1 Free For All
					else if (gameworld == MG1) cvar_set("hostname", "MG1-NQW: FFA (Hybrid: FTE/QSSM ONLY)");
					// Custom Maps Free For All	
					else cvar_set("hostname", "CUSTOM-NQW: FFA (Hybrid: FTE/QSSM ONLY)");
				}
				else if (cvar("instagib") == INSTAGIB_ON)
				{
					// iD1 Free For All
					if (gameworld == ID1) cvar_set("hostname", "ID1-NQW: iFFA (Hybrid: FTE/QSSM ONLY)");
					// HIPNOTIC Free For All	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "HIPNOTIC-NQW: iFFA (Hybrid: FTE/QSSM ONLY)");
					// ROGUE Free For All
					else if (gameworld == ROGUE) cvar_set("hostname", "ROGUE-NQW: iFFA (Hybrid: FTE/QSSM ONLY)");
					// DOPA Free For All	
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA-NQW: iFFA (Hybrid: FTE/QSSM ONLY)");
					// MG1 Free For All
					else if (gameworld == MG1) cvar_set("hostname", "MG1-NQW: iFFA (Hybrid: FTE/QSSM ONLY)");
					// Custom Maps Free For All	
					else cvar_set("hostname", "CUSTOM-NQW: iFFA (Hybrid: FTE/QSSM ONLY)");
				}
				else if (cvar("instagib") == INSTAGIB_RAILWARZ)
				{
					// iD1 Free For All
					if (gameworld == ID1) cvar_set("hostname", "ID1-NQW: Railwarz FFA (Hybrid: FTE/QSSM ONLY)");
					// HIPNOTIC Free For All	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "HIPNOTIC-NQW: Railwarz FFA (Hybrid: FTE/QSSM ONLY)");
					// ROGUE Free For All
					else if (gameworld == ROGUE) cvar_set("hostname", "ROGUE-NQW: Railwarz FFA (Hybrid: FTE/QSSM ONLY)");
					// DOPA Free For All	
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA-NQW: Railwarz FFA (Hybrid: FTE/QSSM ONLY)");
					// MG1 Free For All
					else if (gameworld == MG1) cvar_set("hostname", "MG1-NQW: Railwarz FFA (Hybrid: FTE/QSSM ONLY)");
					// Custom Maps Free For All	
					else cvar_set("hostname", "CUSTOM-NQW: Railwarz FFA (Hybrid: FTE/QSSM ONLY)");
				}												
			}
			// Team Deathmatch
			else if (!cvar("coop") && !cvar("horde") && cvar("deathmatch") == DM_TDM)
			{
				if (!cvar("instagib"))
				{
					// iD1 Team Deathmatch
					if (gameworld == ID1) cvar_set("hostname", "ID1-NQW: TDM (Hybrid: FTE/QSSM ONLY)");
					// HIPNOTIC Team Deathmatch	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "HIPNOTIC-NQW: TDM (Hybrid: FTE/QSSM ONLY)");
					// ROGUE Team Deathmatch
					else if (gameworld == ROGUE) cvar_set("hostname", "ROGUE-NQW: TDM (Hybrid: FTE/QSSM ONLY)");
					// DOPA Team Deathmatch
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA-NQW: TDM (Hybrid: FTE/QSSM ONLY)");
					// MG1 Team Deathmatch
					else if (gameworld == MG1) cvar_set("hostname", "MG1-NQW: TDM (Hybrid: FTE/QSSM ONLY)");
					// Custom Maps Team Deathmatch	
					else cvar_set("hostname", "CUSTOM-NQW: TDM (Hybrid: FTE/QSSM ONLY)");
				}
				else if (cvar("instagib") == INSTAGIB_ON)
				{
					// iD1 Team Deathmatch
					if (gameworld == ID1) cvar_set("hostname", "ID1-NQW: iTDM (Hybrid: FTE/QSSM ONLY)");
					// HIPNOTIC Team Deathmatch	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "HIPNOTIC-NQW: iTDM (Hybrid: FTE/QSSM ONLY)");
					// ROGUE Team Deathmatch
					else if (gameworld == ROGUE) cvar_set("hostname", "ROGUE-NQW: iTDM (Hybrid: FTE/QSSM ONLY)");
					// DOPA Team Deathmatch
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA-NQW: iTDM (Hybrid: FTE/QSSM ONLY)");
					// MG1 Team Deathmatch
					else if (gameworld == MG1) cvar_set("hostname", "MG1-NQW: iTDM (Hybrid: FTE/QSSM ONLY)");
					// Custom Maps Team Deathmatch	
					else cvar_set("hostname", "CUSTOM-NQW: iTDM (Hybrid: FTE/QSSM ONLY)");
				}				
				else if (cvar("instagib") == INSTAGIB_RAILWARZ)
				{
					// iD1 Team Deathmatch
					if (gameworld == ID1) cvar_set("hostname", "ID1-NQW: Railwarz TDM (Hybrid: FTE/QSSM ONLY)");
					// HIPNOTIC Team Deathmatch	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "HIPNOTIC-NQW: Railwarz TDM (Hybrid: FTE/QSSM ONLY)");
					// ROGUE Team Deathmatch
					else if (gameworld == ROGUE) cvar_set("hostname", "ROGUE-NQW: Railwarz TDM (Hybrid: FTE/QSSM ONLY)");
					// DOPA Team Deathmatch
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA-NQW: Railwarz TDM (Hybrid: FTE/QSSM ONLY)");
					// MG1 Team Deathmatch
					else if (gameworld == MG1) cvar_set("hostname", "MG1-NQW: Railwarz TDM (Hybrid: FTE/QSSM ONLY)");
					// Custom Maps Team Deathmatch	
					else cvar_set("hostname", "CUSTOM-NQW: Railwarz TDM (Hybrid: FTE/QSSM ONLY)");
				}				
			}
			// Capture The Flag
			else if (!cvar("coop") && !cvar("horde") && cvar("deathmatch") == DM_CTF)
			{
				if (!cvar("instagib"))
				{
					// iD1 Capture The Flag
					if (gameworld == ID1) cvar_set("hostname", "ID1-NQW: CTF (Hybrid: FTE/QSSM ONLY)");
					// HIPNOTIC Capture The Flag	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "HIPNOTIC-NQW: CTF (Hybrid: FTE/QSSM ONLY)");
					// ROGUE Capture The Flag
					else if (gameworld == ROGUE) cvar_set("hostname", "ROGUE-NQW: CTF (Hybrid: FTE/QSSM ONLY)");
					// DOPA Capture The Flag
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA-NQW: CTF (Hybrid: FTE/QSSM ONLY)");
					// MG1 Capture The Flag
					else if (gameworld == MG1) cvar_set("hostname", "MG1-NQW: CTF (Hybrid: FTE/QSSM ONLY)");
					// Custom Maps Capture The Flag
					else cvar_set("hostname", "CUSTOM-NQW: CTF (Hybrid: FTE/QSSM ONLY)");
				}
				else if (cvar("instagib") == INSTAGIB_ON)
				{
					// iD1 Capture The Flag
					if (gameworld == ID1) cvar_set("hostname", "ID1-NQW: iCTF (Hybrid: FTE/QSSM ONLY)");
					// HIPNOTIC Capture The Flag	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "HIPNOTIC-NQW: iCTF (Hybrid: FTE/QSSM ONLY)");
					// ROGUE Capture The Flag
					else if (gameworld == ROGUE) cvar_set("hostname", "ROGUE-NQW: iCTF (Hybrid: FTE/QSSM ONLY)");
					// DOPA Capture The Flag
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA-NQW: iCTF (Hybrid: FTE/QSSM ONLY)");
					// MG1 Capture The Flag
					else if (gameworld == MG1) cvar_set("hostname", "MG1-NQW: iCTF (Hybrid: FTE/QSSM ONLY)");
					// Custom Maps Capture The Flag
					else cvar_set("hostname", "CUSTOM-NQW: iCTF (Hybrid: FTE/QSSM ONLY)");
				}				
				else if (cvar("instagib") == INSTAGIB_RAILWARZ)
				{
					// iD1 Capture The Flag
					if (gameworld == ID1) cvar_set("hostname", "ID1-NQW: Railwarz CTF (Hybrid: FTE/QSSM ONLY)");
					// HIPNOTIC Capture The Flag	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "HIPNOTIC-NQW: Railwarz CTF (Hybrid: FTE/QSSM ONLY)");
					// ROGUE Capture The Flag
					else if (gameworld == ROGUE) cvar_set("hostname", "ROGUE-NQW: Railwarz CTF (Hybrid: FTE/QSSM ONLY)");
					// DOPA Capture The Flag
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA-NQW: Railwarz CTF (Hybrid: FTE/QSSM ONLY)");
					// MG1 Capture The Flag
					else if (gameworld == MG1) cvar_set("hostname", "MG1-NQW: Railwarz CTF (Hybrid: FTE/QSSM ONLY)");
					// Custom Maps Capture The Flag
					else cvar_set("hostname", "CUSTOM-NQW: Railwarz CTF (Hybrid: FTE/QSSM ONLY)");
				}				
			}				
			// One Flag CTF
			else if (!cvar("coop") && !cvar("horde") && cvar("deathmatch") == DM_OneFlagCTF)
			{
				if (!cvar("instagib"))
				{
					// iD1 One Flag CTF
					if (gameworld == ID1) cvar_set("hostname", "ID1-NQW: One Flag CTF (Hybrid: FTE/QSSM ONLY)");
					// HIPNOTIC One Flag CTF
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "HIPNOTIC-NQW: One Flag CTF (Hybrid: FTE/QSSM ONLY)");
					// ROGUE One Flag CTF
					else if (gameworld == ROGUE) cvar_set("hostname", "ROGUE-NQW: One Flag CTF (Hybrid: FTE/QSSM ONLY)");
					// DOPA One Flag CTF
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA-NQW: One Flag CTF (Hybrid: FTE/QSSM ONLY)");
					// MG1 One Flag CTF
					else if (gameworld == MG1) cvar_set("hostname", "MG1-NQW: One Flag CTF (Hybrid: FTE/QSSM ONLY)");
					// Custom Maps One Flag CTF
					else cvar_set("hostname", "CUSTOM-NQW: One Flag CTF (Hybrid: FTE/QSSM ONLY)");
				}
				else if (cvar("instagib") == INSTAGIB_ON)
				{
					// iD1 One Flag CTF
					if (gameworld == ID1) cvar_set("hostname", "ID1-NQW: One Flag iCTF (Hybrid: FTE/QSSM ONLY)");
					// HIPNOTIC One Flag CTF
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "HIPNOTIC-NQW: One Flag iCTF (Hybrid: FTE/QSSM ONLY)");
					// ROGUE One Flag CTF
					else if (gameworld == ROGUE) cvar_set("hostname", "ROGUE-NQW: One Flag iCTF (Hybrid: FTE/QSSM ONLY)");
					// DOPA One Flag CTF
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA-NQW: One Flag iCTF (Hybrid: FTE/QSSM ONLY)");
					// MG1 One Flag CTF
					else if (gameworld == MG1) cvar_set("hostname", "MG1-NQW: One Flag iCTF (Hybrid: FTE/QSSM ONLY)");
					// Custom Maps One Flag CTF
					else cvar_set("hostname", "CUSTOM-NQW: One Flag iCTF (Hybrid: FTE/QSSM ONLY)");
				}				
				else if (cvar("instagib") == INSTAGIB_RAILWARZ)
				{
					// iD1 One Flag CTF
					if (gameworld == ID1) cvar_set("hostname", "ID1-NQW: One Flag Railwarz CTF (Hybrid: FTE/QSSM ONLY)");
					// HIPNOTIC One Flag CTF
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "HIPNOTIC-NQW: One Flag Railwarz CTF (Hybrid: FTE/QSSM ONLY)");
					// ROGUE One Flag CTF
					else if (gameworld == ROGUE) cvar_set("hostname", "ROGUE-NQW: One Flag Railwarz CTF (Hybrid: FTE/QSSM ONLY)");
					// DOPA One Flag CTF
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA-NQW: One Flag Railwarz CTF (Hybrid: FTE/QSSM ONLY)");
					// MG1 One Flag CTF
					else if (gameworld == MG1) cvar_set("hostname", "MG1-NQW: One Flag Railwarz CTF (Hybrid: FTE/QSSM ONLY)");
					// Custom Maps One Flag CTF
					else cvar_set("hostname", "CUSTOM-NQW: One Flag Railwarz CTF (Hybrid: FTE/QSSM ONLY)");
				}				
			}				
			// Horde Mode
			else if (cvar("coop") <= 4 && cvar("horde") && !cvar("deathmatch") && !cvar("instagib"))
			{
				// MG1 Horde Mode
				if (gameworld == MG1) cvar_set("hostname", "MG1-NQW: Horde (Hybrid: FTE/QSSM ONLY)");
				// Custom Maps Horde Mode	
				else cvar_set("hostname", "CUSTOM-NQW: Horde (Hybrid: FTE/QSSM ONLY)");
			}
		}
		else cvar_set("hostname", "Unnamed LAN Server (Hybrid)");
	}
	else cvar_set("hostname", "NQW Co-Op Developer Server (Hybrid)");
};

// Sleeper: These needs to be thrown back into an actual config.
/*
====
Duel
====
*/
void() Gametype_Duel_Settings = 
{
	cvar_set ("cl_rollangle", "0");
	cvar_set ("noexit", "3");
	cvar_set ("samelevel", "1");
	cvar_set ("coop", "0");
	cvar_set ("customcoop", "0");
	cvar_set ("deathmatch", "1");
	cvar_set ("teamplay", "0");
	cvar_set ("timelimit", "7");
	cvar_set ("fraglimit", "0");
	cvar_set ("capturelimit", "0");
	cvar_set ("teamknockback", "0");
	cvar_set ("falldamage", "1");
	cvar_set ("use_offhand_hook", "0");
	cvar_set ("offhand_skyhook", "0");
	cvar_set ("offhand_hook_speed", "800");
	cvar_set ("offhand_hook_pullspeed", "1000");	
	cvar_set ("offhand_hook_anchor_timeout", "1");
	cvar_set ("offhand_hook_anchor_time", "5");
	cvar_set ("offhand_hook_enable_damage", "1");
	cvar_set ("offhand_hook_damage", "5");	
	cvar_set ("use_grappling_hook", "0");
	cvar_set ("grappling_skyhook", "0");
	cvar_set ("grappling_hook_speed", "800");
	cvar_set ("grappling_hook_pullspeed", "1000");	
	cvar_set ("grappling_hook_anchor_timeout", "1");
	cvar_set ("grappling_hook_anchor_time", "5");	
	cvar_set ("grappling_hook_enable_damage", "1");
	cvar_set ("grappling_hook_damage", "5");
	cvar_set ("capped_qw_physics", "0");
	cvar_set ("capped_qw_physics_speed", "700");
	cvar_set ("allow_bunnyhopping", "1");	
	cvar_set ("sv_nqplayerphysics", "0");	
	cvar_set("sudden_death", "1"); 
	cvar_set("sudden_death_style", "2");
	cvar_set("sudden_death_timelimit", "2");
	cvar_set("sudden_death_max_rounds", "10");
	cvar_set("warmup", "1");
	cvar_set("warmup_countdown_num", "15");
	cvar_set("instagib", "0");
	cvar_set("player_collision", "1");
	
	if (!cvar("developer"))
	{
		cvar_set ("maxclients", "2");
		cvar_set ("maxspectators", "16");
	}			
};

/*
============
Free For All
============
*/
void() Gametype_FFA_Settings =
{	
	cvar_set ("cl_rollangle", "0");
	cvar_set ("noexit", "3");
	cvar_set ("samelevel", "1");	
	cvar_set ("coop", "0");
	cvar_set ("customcoop", "0");
	cvar_set ("deathmatch", "2");
	cvar_set ("teamplay", "0");
	cvar_set ("timelimit", "15");
	cvar_set ("fraglimit", "50");
	cvar_set ("capturelimit", "0");
	cvar_set ("teamknockback", "0");
	cvar_set ("falldamage", "1");
	cvar_set ("use_offhand_hook", "0");
	cvar_set ("offhand_skyhook", "0");
	cvar_set ("offhand_hook_speed", "800");
	cvar_set ("offhand_hook_pullspeed", "1000");
	cvar_set ("offhand_hook_anchor_timeout", "1");
	cvar_set ("offhand_hook_anchor_time", "5");
	cvar_set ("offhand_hook_enable_damage", "1");
	cvar_set ("offhand_hook_damage", "5");		
	cvar_set ("use_grappling_hook", "0");
	cvar_set ("grappling_skyhook", "0");
	cvar_set ("grappling_hook_speed", "800");
	cvar_set ("grappling_hook_pullspeed", "1000");	
	cvar_set ("grappling_hook_anchor_timeout", "1");
	cvar_set ("grappling_hook_anchor_time", "5");	
	cvar_set ("grappling_hook_enable_damage", "1");
	cvar_set ("grappling_hook_damage", "5");		
	cvar_set ("qw_physics_capped", "0");
	cvar_set ("qw_physics_speedcap", "700");	
	cvar_set ("allow_bunnyhopping", "1");		
	cvar_set ("sv_nqplayerphysics", "0");
	cvar_set("sudden_death", "0"); 
	cvar_set("sudden_death_style", "0");
	cvar_set("sudden_death_timelimit", "0");
	cvar_set("sudden_death_max_rounds", "0");
	cvar_set("warmup", "0");
	cvar_set("warmup_countdown_num", "0");
	cvar_set("instagib", "0");
	cvar_set("player_collision", "1");
		
	if (!cvar("developer"))
	{		
		cvar_set ("maxclients", "16");
		cvar_set ("maxspectators", "16");	
	}				
};

void() Gametype_Instagib_FFA_Settings =
{	
	cvar_set ("cl_rollangle", "0");
	cvar_set ("noexit", "3");
	cvar_set ("samelevel", "1");	
	cvar_set ("coop", "0");
	cvar_set ("customcoop", "0");
	cvar_set ("deathmatch", "2");
	cvar_set ("teamplay", "0");
	cvar_set ("timelimit", "15");
	cvar_set ("fraglimit", "50");
	cvar_set ("capturelimit", "0");
	cvar_set ("teamknockback", "0");
	cvar_set ("falldamage", "0");
	cvar_set ("use_offhand_hook", "0");
	cvar_set ("offhand_skyhook", "0");
	cvar_set ("offhand_hook_speed", "800");
	cvar_set ("offhand_hook_pullspeed", "1000");
	cvar_set ("offhand_hook_anchor_timeout", "1");
	cvar_set ("offhand_hook_anchor_time", "5");
	cvar_set ("offhand_hook_enable_damage", "0");
	cvar_set ("offhand_hook_damage", "0");		
	cvar_set ("use_grappling_hook", "1");
	cvar_set ("grappling_skyhook", "1");
	cvar_set ("grappling_hook_speed", "800");
	cvar_set ("grappling_hook_pullspeed", "1000");	
	cvar_set ("grappling_hook_anchor_timeout", "1");
	cvar_set ("grappling_hook_anchor_time", "5");	
	cvar_set ("grappling_hook_enable_damage", "0");
	cvar_set ("grappling_hook_damage", "0");		
	cvar_set ("qw_physics_capped", "0");
	cvar_set ("qw_physics_speedcap", "700");	
	cvar_set ("allow_bunnyhopping", "1");		
	cvar_set ("sv_nqplayerphysics", "0");
	cvar_set("sudden_death", "0"); 
	cvar_set("sudden_death_style", "0");
	cvar_set("sudden_death_timelimit", "0");
	cvar_set("sudden_death_max_rounds", "0");
	cvar_set("warmup", "0");
	cvar_set("warmup_countdown_num", "0");
	cvar_set("instagib", "1");
	cvar_set("player_collision", "1");
		
	if (!cvar("developer"))
	{		
		cvar_set ("maxclients", "16");
		cvar_set ("maxspectators", "16");	
	}				
};

void() Gametype_Railwarz_FFA_Settings =
{	
	cvar_set ("cl_rollangle", "0");
	cvar_set ("noexit", "3");
	cvar_set ("samelevel", "1");	
	cvar_set ("coop", "0");
	cvar_set ("customcoop", "0");
	cvar_set ("deathmatch", "2");
	cvar_set ("teamplay", "0");
	cvar_set ("timelimit", "15");
	cvar_set ("fraglimit", "50");
	cvar_set ("capturelimit", "0");
	cvar_set ("teamknockback", "0");
	cvar_set ("falldamage", "0");
	cvar_set ("use_offhand_hook", "1");
	cvar_set ("offhand_skyhook", "1");
	cvar_set ("offhand_hook_speed", "1250");
	cvar_set ("offhand_hook_pullspeed", "1100");
	cvar_set ("offhand_hook_anchor_timeout", "1");
	cvar_set ("offhand_hook_anchor_time", "5");
	cvar_set ("offhand_hook_enable_damage", "0");
	cvar_set ("offhand_hook_damage", "0");		
	cvar_set ("use_grappling_hook", "1");
	cvar_set ("grappling_skyhook", "1");
	cvar_set ("grappling_hook_speed", "800");
	cvar_set ("grappling_hook_pullspeed", "1000");	
	cvar_set ("grappling_hook_anchor_timeout", "1");
	cvar_set ("grappling_hook_anchor_time", "5");	
	cvar_set ("grappling_hook_enable_damage", "0");
	cvar_set ("grappling_hook_damage", "0");		
	cvar_set ("qw_physics_capped", "0");
	cvar_set ("qw_physics_speedcap", "700");	
	cvar_set ("allow_bunnyhopping", "1");		
	cvar_set ("sv_nqplayerphysics", "0");
	cvar_set("sudden_death", "0"); 
	cvar_set("sudden_death_style", "0");
	cvar_set("sudden_death_timelimit", "0");
	cvar_set("sudden_death_max_rounds", "0");
	cvar_set("warmup", "0");
	cvar_set("warmup_countdown_num", "0");
	cvar_set("instagib", "2");
	cvar_set("player_collision", "1");
		
	if (!cvar("developer"))
	{		
		cvar_set ("maxclients", "16");
		cvar_set ("maxspectators", "16");	
	}				
};

/*
===============
Team Deathmatch
===============
*/
void() Gametype_TDM_Settings =
{
	cvar_set ("cl_rollangle", "0");
	cvar_set ("noexit", "3");
	cvar_set ("samelevel", "1");
	cvar_set ("coop", "0");
	cvar_set ("customcoop", "0");
	cvar_set ("deathmatch", "3");
	cvar_set ("teamplay", "2");
	cvar_set ("timelimit", "15");
	cvar_set ("fraglimit", "0");
	cvar_set ("capturelimit", "0");
	cvar_set ("teamknockback", "1");
	cvar_set ("falldamage", "1");
	cvar_set ("use_offhand_hook", "0");
	cvar_set ("offhand_skyhook", "0");
	cvar_set ("offhand_hook_speed", "800");
	cvar_set ("offhand_hook_pullspeed", "1000");
	cvar_set ("offhand_hook_anchor_timeout", "1");
	cvar_set ("offhand_hook_anchor_time", "5");
	cvar_set ("offhand_hook_enable_damage", "1");
	cvar_set ("offhand_hook_damage", "5");		
	cvar_set ("use_grappling_hook", "0");
	cvar_set ("grappling_skyhook", "0");
	cvar_set ("grappling_hook_speed", "800");
	cvar_set ("grappling_hook_pullspeed", "1000");	
	cvar_set ("grappling_hook_anchor_timeout", "1");
	cvar_set ("grappling_hook_anchor_time", "5");	
	cvar_set ("grappling_hook_enable_damage", "1");
	cvar_set ("grappling_hook_damage", "5");		
	cvar_set ("qw_physics_capped", "0");
	cvar_set ("qw_physics_speedcap", "700");
	cvar_set ("allow_bunnyhopping", "1");			
	cvar_set ("sv_nqplayerphysics", "0");
	cvar_set("sudden_death", "0"); 
	cvar_set("sudden_death_style", "0");
	cvar_set("sudden_death_timelimit", "0");
	cvar_set("sudden_death_max_rounds", "0");
	cvar_set("warmup", "1");
	cvar_set("warmup_countdown_num", "15");	
	cvar_set("instagib", "0");
	cvar_set("player_collision", "1");
	
	if (!cvar("developer"))
	{	
		cvar_set ("maxclients", "8");
		cvar_set ("maxspectators", "16");
	}		
};

/*
void() Gametype_Instagib_TDM_Settings =
{
	cvar_set ("cl_rollangle", "0");
	cvar_set ("noexit", "3");
	cvar_set ("samelevel", "1");
	cvar_set ("coop", "0");
	cvar_set ("customcoop", "0");
	cvar_set ("deathmatch", "3");
	cvar_set ("teamplay", "2");
	cvar_set ("timelimit", "15");
	cvar_set ("fraglimit", "0");
	cvar_set ("capturelimit", "0");
	cvar_set ("teamknockback", "0");
	cvar_set ("falldamage", "0");
	cvar_set ("use_offhand_hook", "0");
	cvar_set ("offhand_skyhook", "0");
	cvar_set ("offhand_hook_speed", "800");
	cvar_set ("offhand_hook_pullspeed", "1000");
	cvar_set ("offhand_hook_anchor_timeout", "1");
	cvar_set ("offhand_hook_anchor_time", "5");
	cvar_set ("offhand_hook_enable_damage", "0");
	cvar_set ("offhand_hook_damage", "0");		
	cvar_set ("use_grappling_hook", "0");
	cvar_set ("grappling_skyhook", "0");
	cvar_set ("grappling_hook_speed", "800");
	cvar_set ("grappling_hook_pullspeed", "1000");	
	cvar_set ("grappling_hook_anchor_timeout", "1");
	cvar_set ("grappling_hook_anchor_time", "5");	
	cvar_set ("grappling_hook_enable_damage", "0");
	cvar_set ("grappling_hook_damage", "0");		
	cvar_set ("qw_physics_capped", "0");
	cvar_set ("qw_physics_speedcap", "700");
	cvar_set ("allow_bunnyhopping", "1");			
	cvar_set ("sv_nqplayerphysics", "0");
	cvar_set("sudden_death", "0"); 
	cvar_set("sudden_death_style", "0");
	cvar_set("sudden_death_timelimit", "0");
	cvar_set("sudden_death_max_rounds", "0");
	cvar_set("warmup", "1");
	cvar_set("warmup_countdown_num", "15");	
	cvar_set("instagib", "1");
	cvar_set("player_collision", "1");
	
	if (!cvar("developer"))
	{	
		cvar_set ("maxclients", "16");
		cvar_set ("maxspectators", "16");
	}		
};
*/

/*
void() Gametype_Railwarz_TDM_Settings =
{
	cvar_set ("cl_rollangle", "0");
	cvar_set ("noexit", "3");
	cvar_set ("samelevel", "1");
	cvar_set ("coop", "0");
	cvar_set ("customcoop", "0");
	cvar_set ("deathmatch", "3");
	cvar_set ("teamplay", "2");
	cvar_set ("timelimit", "15");
	cvar_set ("fraglimit", "0");
	cvar_set ("capturelimit", "0");
	cvar_set ("teamknockback", "0");
	cvar_set ("falldamage", "0");
	cvar_set ("use_offhand_hook", "1");
	cvar_set ("offhand_skyhook", "1");
	cvar_set ("offhand_hook_speed", "1250");
	cvar_set ("offhand_hook_pullspeed", "1100");
	cvar_set ("offhand_hook_anchor_timeout", "1");
	cvar_set ("offhand_hook_anchor_time", "5");
	cvar_set ("offhand_hook_enable_damage", "0");
	cvar_set ("offhand_hook_damage", "0");		
	cvar_set ("use_grappling_hook", "0");
	cvar_set ("grappling_skyhook", "0");
	cvar_set ("grappling_hook_speed", "800");
	cvar_set ("grappling_hook_pullspeed", "1000");	
	cvar_set ("grappling_hook_anchor_timeout", "1");
	cvar_set ("grappling_hook_anchor_time", "5");	
	cvar_set ("grappling_hook_enable_damage", "1");
	cvar_set ("grappling_hook_damage", "5");		
	cvar_set ("qw_physics_capped", "0");
	cvar_set ("qw_physics_speedcap", "700");
	cvar_set ("allow_bunnyhopping", "1");			
	cvar_set ("sv_nqplayerphysics", "0");
	cvar_set("sudden_death", "0"); 
	cvar_set("sudden_death_style", "0");
	cvar_set("sudden_death_timelimit", "0");
	cvar_set("sudden_death_max_rounds", "0");
	cvar_set("warmup", "1");
	cvar_set("warmup_countdown_num", "15");	
	cvar_set("instagib", "2");
	cvar_set("player_collision", "1");
	
	if (!cvar("developer"))
	{	
		cvar_set ("maxclients", "16");
		cvar_set ("maxspectators", "16");
	}		
};
*/

/*
================
Capture The Flag
================
*/
void() Gametype_CTF_Settings =
{
	cvar_set ("cl_rollangle", "0");
	cvar_set ("noexit", "3");
	cvar_set ("samelevel", "1");
	cvar_set ("coop", "0");
	cvar_set ("customcoop", "0");
	cvar_set ("deathmatch", "4");
	cvar_set ("teamplay", "4");
	cvar_set ("timelimit", "10");
	cvar_set ("fraglimit", "0");
	cvar_set ("capturelimit", "10");
	cvar_set ("teamknockback", "0");
	cvar_set ("falldamage", "0");
	cvar_set ("use_offhand_hook", "0");
	cvar_set ("offhand_skyhook", "0");
	cvar_set ("offhand_hook_speed", "800");
	cvar_set ("offhand_hook_pullspeed", "1000");
	cvar_set ("offhand_hook_anchor_timeout", "1");
	cvar_set ("offhand_hook_anchor_time", "5");
	cvar_set ("offhand_hook_enable_damage", "0");
	cvar_set ("offhand_hook_damage", "5");		
	cvar_set ("use_grappling_hook", "1");
	cvar_set ("grappling_skyhook", "0");
	cvar_set ("grappling_hook_speed", "800");
	cvar_set ("grappling_hook_pullspeed", "1000");	
	cvar_set ("grappling_hook_anchor_timeout", "1");
	cvar_set ("grappling_hook_anchor_time", "5");	
	cvar_set ("grappling_hook_enable_damage", "1");
	cvar_set ("grappling_hook_damage", "5");	
	cvar_set ("qw_physics_capped", "0");
	cvar_set ("qw_physics_speedcap", "700");
	cvar_set ("allow_bunnyhopping", "1");		
	cvar_set ("sv_nqplayerphysics", "0");	
	cvar_set("sudden_death", "0"); 
	cvar_set("sudden_death_style", "0");
	cvar_set("sudden_death_timelimit", "0");
	cvar_set("sudden_death_max_rounds", "0");
	cvar_set("warmup", "1");
	cvar_set("warmup_countdown_num", "15");	
	cvar_set("instagib", "0");
	cvar_set("player_collision", "1");
	
	if (!cvar("developer"))
	{
		cvar_set ("maxclients", "8");
		cvar_set ("maxspectators", "16");
	}			
};

/*
void() Gametype_Instagib_CTF_Settings =
{
	cvar_set ("cl_rollangle", "0");
	cvar_set ("noexit", "3");
	cvar_set ("samelevel", "1");
	cvar_set ("coop", "0");
	cvar_set ("customcoop", "0");
	cvar_set ("deathmatch", "4");
	cvar_set ("teamplay", "4");
	cvar_set ("timelimit", "10");
	cvar_set ("fraglimit", "0");
	cvar_set ("capturelimit", "10");
	cvar_set ("teamknockback", "0");
	cvar_set ("falldamage", "0");
	cvar_set ("use_offhand_hook", "0");
	cvar_set ("offhand_skyhook", "0");
	cvar_set ("offhand_hook_speed", "800");
	cvar_set ("offhand_hook_pullspeed", "1000");
	cvar_set ("offhand_hook_anchor_timeout", "1");
	cvar_set ("offhand_hook_anchor_time", "5");
	cvar_set ("offhand_hook_enable_damage", "0");
	cvar_set ("offhand_hook_damage", "5");		
	cvar_set ("use_grappling_hook", "0");
	cvar_set ("grappling_skyhook", "0");
	cvar_set ("grappling_hook_speed", "800");
	cvar_set ("grappling_hook_pullspeed", "1000");	
	cvar_set ("grappling_hook_anchor_timeout", "1");
	cvar_set ("grappling_hook_anchor_time", "5");	
	cvar_set ("grappling_hook_enable_damage", "0");
	cvar_set ("grappling_hook_damage", "0");	
	cvar_set ("qw_physics_capped", "0");
	cvar_set ("qw_physics_speedcap", "700");
	cvar_set ("allow_bunnyhopping", "1");		
	cvar_set ("sv_nqplayerphysics", "0");	
	cvar_set("sudden_death", "0"); 
	cvar_set("sudden_death_style", "0");
	cvar_set("sudden_death_timelimit", "0");
	cvar_set("sudden_death_max_rounds", "0");
	cvar_set("warmup", "1");
	cvar_set("warmup_countdown_num", "15");	
	cvar_set("instagib", "1");
	cvar_set("player_collision", "1");
	
	if (!cvar("developer"))
	{
		cvar_set ("maxclients", "16");
		cvar_set ("maxspectators", "16");
	}						
};
*/

void() Gametype_Railwarz_CTF_Settings =
{
	cvar_set ("cl_rollangle", "0");
	cvar_set ("noexit", "3");
	cvar_set ("samelevel", "1");
	cvar_set ("coop", "0");
	cvar_set ("customcoop", "0");
	cvar_set ("deathmatch", "4");
	cvar_set ("teamplay", "4");
	cvar_set ("timelimit", "10");
	cvar_set ("fraglimit", "0");
	cvar_set ("capturelimit", "10");
	cvar_set ("teamknockback", "0");
	cvar_set ("falldamage", "0");
	cvar_set ("use_offhand_hook", "1");
	cvar_set ("offhand_skyhook", "1");
	cvar_set ("offhand_hook_speed", "1250");
	cvar_set ("offhand_hook_pullspeed", "1100");
	cvar_set ("offhand_hook_anchor_timeout", "1");
	cvar_set ("offhand_hook_anchor_time", "5");
	cvar_set ("offhand_hook_enable_damage", "0");
	cvar_set ("offhand_hook_damage", "0");		
	cvar_set ("use_grappling_hook", "1");
	cvar_set ("grappling_skyhook", "1");
	cvar_set ("grappling_hook_speed", "800");
	cvar_set ("grappling_hook_pullspeed", "1000");	
	cvar_set ("grappling_hook_anchor_timeout", "1");
	cvar_set ("grappling_hook_anchor_time", "5");	
	cvar_set ("grappling_hook_enable_damage", "0");
	cvar_set ("grappling_hook_damage", "0");	
	cvar_set ("qw_physics_capped", "0");
	cvar_set ("qw_physics_speedcap", "700");
	cvar_set ("allow_bunnyhopping", "1");		
	cvar_set ("sv_nqplayerphysics", "0");	
	cvar_set("sudden_death", "0"); 
	cvar_set("sudden_death_style", "0");
	cvar_set("sudden_death_timelimit", "0");
	cvar_set("sudden_death_max_rounds", "0");
	cvar_set("warmup", "1");
	cvar_set("warmup_countdown_num", "15");	
	cvar_set("instagib", "2");
	cvar_set("player_collision", "1");
	
	if (!cvar("developer"))
	{
		cvar_set ("maxclients", "16");
		cvar_set ("maxspectators", "16");
	}						
};

/*
=========================
One Flag Capture The Flag
=========================
*/
void() Gametype_OneFlagCTF_Settings =
{
	cvar_set ("cl_rollangle", "0");
	cvar_set ("noexit", "3");
	cvar_set ("samelevel", "1");
	cvar_set ("coop", "0");
	cvar_set ("customcoop", "0");
	cvar_set ("deathmatch", "5");
	cvar_set ("teamplay", "4");
	cvar_set ("timelimit", "10");
	cvar_set ("fraglimit", "0");
	cvar_set ("capturelimit", "15");
	cvar_set ("teamknockback", "0");
	cvar_set ("falldamage", "1");
	cvar_set ("use_offhand_hook", "0");
	cvar_set ("offhand_skyhook", "0");
	cvar_set ("offhand_hook_speed", "800");
	cvar_set ("offhand_hook_pullspeed", "1000");
	cvar_set ("offhand_hook_anchor_timeout", "1");
	cvar_set ("offhand_hook_anchor_time", "5");
	cvar_set ("offhand_hook_enable_damage", "1");
	cvar_set ("offhand_hook_damage", "5");		
	cvar_set ("use_grappling_hook", "1");
	cvar_set ("grappling_skyhook", "0");
	cvar_set ("grappling_hook_speed", "800");
	cvar_set ("grappling_hook_pullspeed", "1000");	
	cvar_set ("grappling_hook_anchor_timeout", "1");
	cvar_set ("grappling_hook_anchor_time", "5");	
	cvar_set ("grappling_hook_enable_damage", "1");
	cvar_set ("grappling_hook_damage", "5");	
	cvar_set ("qw_physics_capped", "0");
	cvar_set ("qw_physics_speedcap", "700");
	cvar_set ("allow_bunnyhopping", "1");	
	cvar_set ("sv_nqplayerphysics", "0");
	cvar_set("sudden_death", "0"); 
	cvar_set("sudden_death_style", "0");
	cvar_set("sudden_death_timelimit", "0");
	cvar_set("sudden_death_max_rounds", "0");
	cvar_set("warmup", "1");
	cvar_set("warmup_countdown_num", "15");	
	cvar_set("instagib", "0");
	cvar_set("player_collision", "1");
	
	if (!cvar("developer"))
	{				
		cvar_set ("maxclients", "16");
		cvar_set ("maxspectators", "16");
	}			
};

/*
void() Gametype_Instagib_OneFlagCTF_Settings =
{
	cvar_set ("cl_rollangle", "0");
	cvar_set ("noexit", "3");
	cvar_set ("samelevel", "1");
	cvar_set ("coop", "0");
	cvar_set ("customcoop", "0");
	cvar_set ("deathmatch", "5");
	cvar_set ("teamplay", "4");
	cvar_set ("timelimit", "10");
	cvar_set ("fraglimit", "0");
	cvar_set ("capturelimit", "15");
	cvar_set ("teamknockback", "0");
	cvar_set ("falldamage", "0");
	cvar_set ("use_offhand_hook", "1");
	cvar_set ("offhand_skyhook", "1");
	cvar_set ("offhand_hook_speed", "900");
	cvar_set ("offhand_hook_pullspeed", "1250");
	cvar_set ("offhand_hook_anchor_timeout", "1");
	cvar_set ("offhand_hook_anchor_time", "5");
	cvar_set ("offhand_hook_enable_damage", "0");
	cvar_set ("offhand_hook_damage", "0");		
	cvar_set ("use_grappling_hook", "0");
	cvar_set ("grappling_skyhook", "0");
	cvar_set ("grappling_hook_speed", "800");
	cvar_set ("grappling_hook_pullspeed", "1000");	
	cvar_set ("grappling_hook_anchor_timeout", "1");
	cvar_set ("grappling_hook_anchor_time", "5");	
	cvar_set ("grappling_hook_enable_damage", "0");
	cvar_set ("grappling_hook_damage", "0");	
	cvar_set ("qw_physics_capped", "0");
	cvar_set ("qw_physics_speedcap", "700");
	cvar_set ("allow_bunnyhopping", "1");	
	cvar_set ("sv_nqplayerphysics", "0");
	cvar_set("sudden_death", "0"); 
	cvar_set("sudden_death_style", "0");
	cvar_set("sudden_death_timelimit", "0");
	cvar_set("sudden_death_max_rounds", "0");
	cvar_set("warmup", "1");
	cvar_set("warmup_countdown_num", "15");	
	cvar_set("instagib", "1");
	cvar_set("player_collision", "1");
	
	if (!cvar("developer"))
	{				
		cvar_set ("maxclients", "16");
		cvar_set ("maxspectators", "16");
	}			
};
*/

void() Gametype_Railwarz_OneFlagCTF_Settings =
{
	cvar_set ("cl_rollangle", "0");
	cvar_set ("noexit", "3");
	cvar_set ("samelevel", "1");
	cvar_set ("coop", "0");
	cvar_set ("customcoop", "0");
	cvar_set ("deathmatch", "5");
	cvar_set ("teamplay", "4");
	cvar_set ("timelimit", "10");
	cvar_set ("fraglimit", "0");
	cvar_set ("capturelimit", "15");
	cvar_set ("teamknockback", "0");
	cvar_set ("falldamage", "0");
	cvar_set ("use_offhand_hook", "1");
	cvar_set ("offhand_skyhook", "1");
	cvar_set ("offhand_hook_speed", "1250");
	cvar_set ("offhand_hook_pullspeed", "1100");
	cvar_set ("offhand_hook_anchor_timeout", "1");
	cvar_set ("offhand_hook_anchor_time", "5");
	cvar_set ("offhand_hook_enable_damage", "0");
	cvar_set ("offhand_hook_damage", "0");		
	cvar_set ("use_grappling_hook", "1");
	cvar_set ("grappling_skyhook", "1");
	cvar_set ("grappling_hook_speed", "800");
	cvar_set ("grappling_hook_pullspeed", "1000");	
	cvar_set ("grappling_hook_anchor_timeout", "1");
	cvar_set ("grappling_hook_anchor_time", "5");	
	cvar_set ("grappling_hook_enable_damage", "0");
	cvar_set ("grappling_hook_damage", "0");	
	cvar_set ("qw_physics_capped", "0");
	cvar_set ("qw_physics_speedcap", "700");
	cvar_set ("allow_bunnyhopping", "1");	
	cvar_set ("sv_nqplayerphysics", "0");
	cvar_set("sudden_death", "0"); 
	cvar_set("sudden_death_style", "0");
	cvar_set("sudden_death_timelimit", "0");
	cvar_set("sudden_death_max_rounds", "0");
	cvar_set("warmup", "1");
	cvar_set("warmup_countdown_num", "15");	
	cvar_set("instagib", "2");
	cvar_set("player_collision", "1");
	
	if (!cvar("developer"))
	{				
		cvar_set ("maxclients", "16");
		cvar_set ("maxspectators", "16");
	}			
};

/*
======================
Reignited Co-Operative

The Reignited Coop experience
(Reignited item pickup system)
======================
*/
void() Gametype_Reignited_Coop_Settings =
{
	cvar_set ("cl_rollangle", "2");
	cvar_set ("noexit", "0");
	cvar_set ("samelevel", "0");
	cvar_set ("coop", "1");
	cvar_set ("deathmatch", "0");
	cvar_set ("teamplay", "3");
	cvar_set ("timelimit", "0");
	cvar_set ("fraglimit", "0");
	cvar_set ("capturelimit", "0");
	cvar_set ("teamknockback", "0");
	cvar_set ("falldamage", "1");
	cvar_set ("use_offhand_hook", "0");
	cvar_set ("offhand_skyhook", "0");
	cvar_set ("offhand_hook_speed", "800");
	cvar_set ("offhand_hook_pullspeed", "1000");
	cvar_set ("offhand_hook_anchor_timeout", "1");
	cvar_set ("offhand_hook_anchor_time", "5");
	cvar_set ("offhand_hook_enable_damage", "1");
	cvar_set ("offhand_hook_damage", "5");		
	cvar_set ("use_grappling_hook", "0");
	cvar_set ("grappling_skyhook", "0");
	cvar_set ("grappling_hook_speed", "800");
	cvar_set ("grappling_hook_pullspeed", "1000");	
	cvar_set ("grappling_hook_anchor_timeout", "1");
	cvar_set ("grappling_hook_anchor_time", "5");	
	cvar_set ("grappling_hook_enable_damage", "1");
	cvar_set ("grappling_hook_damage", "5");	
	cvar_set ("qw_physics_capped", "0");
	cvar_set ("qw_physics_speedcap", "700");
	cvar_set ("allow_bunnyhopping", "1");		
	cvar_set ("sv_nqplayerphysics", "1");
	cvar_set("sudden_death", "0"); 
	cvar_set("sudden_death_style", "0");
	cvar_set("sudden_death_timelimit", "0");
	cvar_set("sudden_death_max_rounds", "0");
	cvar_set("warmup", "0");
	cvar_set("warmup_countdown_num", "0");	
	cvar_set("instagib", "0");
	cvar_set("player_collision", "0");	
	
	if (!cvar("developer"))
	{				
		cvar_set ("maxclients", "16");
		cvar_set ("maxspectators", "16");
	}	
};

/*
====================
Classic Co-Operative

The original Coop experience
(Classic item pickup system)
====================
*/
void() Gametype_Classic_Coop_Settings =
{
	cvar_set ("cl_rollangle", "2");
	cvar_set ("noexit", "0");
	cvar_set ("samelevel", "0");	
	cvar_set ("coop", "2");
	cvar_set ("deathmatch", "0");
	cvar_set ("teamplay", "1");
	cvar_set ("timelimit", "0");
	cvar_set ("fraglimit", "0");
	cvar_set ("capturelimit", "0");
	cvar_set ("teamknockback", "1");
	cvar_set ("falldamage", "1");
	cvar_set ("use_offhand_hook", "0");
	cvar_set ("offhand_skyhook", "0");
	cvar_set ("offhand_hook_speed", "800");
	cvar_set ("offhand_hook_pullspeed", "1000");
	cvar_set ("offhand_hook_anchor_timeout", "1");
	cvar_set ("offhand_hook_anchor_time", "5");
	cvar_set ("offhand_hook_enable_damage", "1");
	cvar_set ("offhand_hook_damage", "5");		
	cvar_set ("use_grappling_hook", "0");
	cvar_set ("grappling_skyhook", "0");
	cvar_set ("grappling_hook_speed", "800");
	cvar_set ("grappling_hook_pullspeed", "1000");	
	cvar_set ("grappling_hook_anchor_timeout", "1");
	cvar_set ("grappling_hook_anchor_time", "5");	
	cvar_set ("grappling_hook_enable_damage", "1");
	cvar_set ("grappling_hook_damage", "5");		
	cvar_set ("qw_physics_capped", "0");
	cvar_set ("qw_physics_speedcap", "700");
	cvar_set ("allow_bunnyhopping", "1");	
	cvar_set ("sv_nqplayerphysics", "1");
	cvar_set("sudden_death", "0"); 
	cvar_set("sudden_death_style", "0");
	cvar_set("sudden_death_timelimit", "0");
	cvar_set("sudden_death_max_rounds", "0");
	cvar_set("warmup", "0");
	cvar_set("warmup_countdown_num", "0");	
	cvar_set("instagib", "0");
	cvar_set("player_collision", "1");	
	
	if (!cvar("developer"))
	{				
		cvar_set ("maxclients", "16");
		cvar_set ("maxspectators", "16");
	}	
};

/*
=====================
Enhanced Co-Operative

Enhancements to the Original Coop experience
(MG1 item pickup systems)
=====================
*/
void() Gametype_Enhanced_Coop_Settings =
{
	cvar_set ("cl_rollangle", "2");
	cvar_set ("noexit", "0");
	cvar_set ("samelevel", "1");	
	cvar_set ("coop", "4");
	cvar_set ("deathmatch", "0");
	cvar_set ("teamplay", "3");
	cvar_set ("timelimit", "0");
	cvar_set ("fraglimit", "0");
	cvar_set ("capturelimit", "0");
	cvar_set ("teamknockback", "0");
	cvar_set ("falldamage", "1");
	cvar_set ("use_offhand_hook", "0");
	cvar_set ("offhand_skyhook", "0");
	cvar_set ("offhand_hook_speed", "800");
	cvar_set ("offhand_hook_pullspeed", "1000");
	cvar_set ("offhand_hook_anchor_timeout", "1");
	cvar_set ("offhand_hook_anchor_time", "5");
	cvar_set ("offhand_hook_enable_damage", "1");
	cvar_set ("offhand_hook_damage", "5");		
	cvar_set ("use_grappling_hook", "0");
	cvar_set ("grappling_skyhook", "0");
	cvar_set ("grappling_hook_speed", "800");
	cvar_set ("grappling_hook_pullspeed", "1000");	
	cvar_set ("grappling_hook_anchor_timeout", "0");
	cvar_set ("grappling_hook_anchor_time", "5");	
	cvar_set ("grappling_hook_enable_damage", "1");
	cvar_set ("grappling_hook_damage", "5");		
	cvar_set ("qw_physics_capped", "0");
	cvar_set ("qw_physics_speedcap", "700");
	cvar_set ("allow_bunnyhopping", "1");			
	cvar_set ("sv_nqplayerphysics", "1");
	cvar_set("sudden_death", "0"); 
	cvar_set("sudden_death_style", "0");
	cvar_set("sudden_death_timelimit", "0");
	cvar_set("sudden_death_max_rounds", "0");
	cvar_set("warmup", "0");
	cvar_set("warmup_countdown_num", "0");	
	cvar_set("instagib", "0");
	cvar_set("player_collision", "0");	
	
	if (!cvar("developer"))
	{				
		cvar_set ("maxclients", "16");
		cvar_set ("maxspectators", "16");
	}		
};

/*
========================
Vadri'gar Territory Raid

8 Player Experience on maps made specifically 
for Co-Op with Destiny-like Raid mechanics.
Revival systems will be at play.
========================
*/
/*
void() Gametype_Raid_Settings =
{
	cvar_set ("cl_rollangle", "2");
	cvar_set ("noexit", "0");
	cvar_set ("samelevel", "0");
	cvar_set ("coop", "1");
	cvar_set ("deathmatch", "0");
	cvar_set ("teamplay", "3");
	cvar_set ("timelimit", "0");
	cvar_set ("fraglimit", "0");
	cvar_set ("capturelimit", "0");
	cvar_set ("teamknockback", "0");
	cvar_set ("falldamage", "1");
	cvar_set ("use_offhand_hook", "0");
	cvar_set ("offhand_skyhook", "0");
	cvar_set ("offhand_hook_speed", "800");
	cvar_set ("offhand_hook_pullspeed", "1000");
	cvar_set ("offhand_hook_anchor_timeout", "1");
	cvar_set ("offhand_hook_anchor_time", "5");
	cvar_set ("offhand_hook_enable_damage", "1");
	cvar_set ("offhand_hook_damage", "5");		
	cvar_set ("use_grappling_hook", "0");
	cvar_set ("grappling_skyhook", "0");
	cvar_set ("grappling_hook_speed", "800");
	cvar_set ("grappling_hook_pullspeed", "1000");	
	cvar_set ("grappling_hook_anchor_timeout", "1");
	cvar_set ("grappling_hook_anchor_time", "5");	
	cvar_set ("grappling_hook_enable_damage", "1");
	cvar_set ("grappling_hook_damage", "5");	
	cvar_set ("qw_physics_capped", "0");
	cvar_set ("qw_physics_speedcap", "700");
	cvar_set ("allow_bunnyhopping", "1");			
	cvar_set ("sv_nqplayerphysics", "1");
	cvar_set("sudden_death", "0"); 
	cvar_set("sudden_death_style", "0");
	cvar_set("sudden_death_timelimit", "0");
	cvar_set("sudden_death_max_rounds", "0");
	cvar_set("warmup", "0");
	cvar_set("warmup_countdown_num", "0");	
	cvar_set("instagib", "0");	
	
	if (!cvar("developer"))
	{				
		cvar_set ("maxclients", "8");
		cvar_set ("maxspectators", "16");
	}	
};
*/

/*
void() Gametype_4v4_PvEvP_Settings =
{
	cvar_set ("cl_rollangle", "2");
	cvar_set ("noexit", "3");
	cvar_set ("samelevel", "0");	
	cvar_set ("coop", "8");
	cvar_set ("deathmatch", "3");
	cvar_set ("teamplay", "4");
	cvar_set ("timelimit", "15");
	cvar_set ("fraglimit", "0");
	cvar_set ("capturelimit", "0");
	cvar_set ("teamknockback", "0");
	cvar_set ("falldamage", "1");
	cvar_set ("use_offhand_hook", "0");
	cvar_set ("offhand_skyhook", "0");
	cvar_set ("offhand_hook_speed", "800");
	cvar_set ("offhand_hook_pullspeed", "1000");
	cvar_set ("offhand_hook_anchor_timeout", "1");
	cvar_set ("offhand_hook_anchor_time", "5");
	cvar_set ("offhand_hook_enable_damage", "1");
	cvar_set ("offhand_hook_damage", "5");		
	cvar_set ("use_grappling_hook", "0");
	cvar_set ("grappling_skyhook", "0");
	cvar_set ("grappling_hook_speed", "800");
	cvar_set ("grappling_hook_pullspeed", "1000");	
	cvar_set ("grappling_hook_anchor_timeout", "1");
	cvar_set ("grappling_hook_anchor_time", "5");	
	cvar_set ("grappling_hook_enable_damage", "1");
	cvar_set ("grappling_hook_damage", "5");	
	cvar_set ("qw_physics_capped", "0");
	cvar_set ("qw_physics_speedcap", "700");	
	cvar_set ("allow_bunnyhopping", "1");		
	cvar_set ("sv_nqplayerphysics", "1");
	cvar_set("sudden_death", "0"); 
	cvar_set("sudden_death_style", "0");
	cvar_set("sudden_death_timelimit", "0");
	cvar_set("sudden_death_max_rounds", "0");
	cvar_set("warmup", "0");
	cvar_set("warmup_countdown_num", "0");	
	cvar_set("instagib", "0");	
	
	if (!cvar("developer"))
	{				
		cvar_set ("maxclients", "8");
		cvar_set ("maxspectators", "16");
	}				
};
*/

/*
void() Gametype_Duel_PvEvP_Settings =
{
	cvar_set ("cl_rollangle", "2");
	cvar_set ("noexit", "3");
	cvar_set ("samelevel", "0");	
	cvar_set ("coop", "8");
	cvar_set ("deathmatch", "3");
	 cvar_set ("teamplay", "4");
	cvar_set ("timelimit", "15");
	cvar_set ("fraglimit", "0");
	cvar_set ("capturelimit", "0");
	cvar_set ("teamknockback", "0");
	cvar_set ("falldamage", "1");
	cvar_set ("use_offhand_hook", "0");
	cvar_set ("offhand_skyhook", "0");
	cvar_set ("offhand_hook_speed", "800");
	cvar_set ("offhand_hook_pullspeed", "1000");
	cvar_set ("offhand_hook_anchor_timeout", "1");
	cvar_set ("offhand_hook_anchor_time", "5");
	cvar_set ("offhand_hook_enable_damage", "1");
	cvar_set ("offhand_hook_damage", "5");		
	cvar_set ("use_grappling_hook", "0");
	cvar_set ("grappling_skyhook", "0");
	cvar_set ("grappling_hook_speed", "800");
	cvar_set ("grappling_hook_pullspeed", "1000");	
	cvar_set ("grappling_hook_anchor_timeout", "1");
	cvar_set ("grappling_hook_anchor_time", "5");	
	cvar_set ("grappling_hook_enable_damage", "1");
	cvar_set ("grappling_hook_damage", "5");			
	cvar_set ("qw_physics_capped", "0");
	cvar_set ("qw_physics_speedcap", "700");
	cvar_set ("allow_bunnyhopping", "1");	
	cvar_set ("sv_nqplayerphysics", "1");
	cvar_set("sudden_death", "0"); 
	cvar_set("sudden_death_style", "0");
	cvar_set("sudden_death_timelimit", "0");
	cvar_set("sudden_death_max_rounds", "0");
	cvar_set("warmup", "0");
	cvar_set("warmup_countdown_num", "0");	
	cvar_set("instagib", "0");	
	
	if (!cvar("developer"))
	{				
		cvar_set ("maxclients", "2");
		cvar_set ("maxspectators", "16");
	}		
};
*/