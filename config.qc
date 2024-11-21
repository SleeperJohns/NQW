// What version are we on? (Major, Minor, Patches)
string NQW_Version = "NQWVer 1.13.2";

float Version_To_Startframe_Traffic;

string() Campaign_Name =
{
	if (!cvar("deathmatch"))
	{
		if (gameworld == UNKNOWN) return "GameWorld UNKNOWN";
		if (gameworld == CUSTOM) return "GameWorld Custom";
		if (gameworld == ID1) return "GameWorld ID1";
		if (gameworld == HIPNOTIC) return "GameWorld HIPNOTIC";
		if (gameworld == ROGUE) return "GameWorld ROGUE";
		if (gameworld == DOPA) return "GameWorld DOPA";
		if (gameworld == MG1) return "GameWorld MG1";
		if (gameworld == APOTHEOSIS) return "GameWorld APOTHEOSIS";
	}
	if (cvar("deathmatch")) return "GameWorld QuakeWorld";
	return "GameWorld Unknown";
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
};

void() Change_New_Cvars =
{
	if (update_serverinfo > time) return;
	
	// Custom Coop
	localcmd ("serverinfo customcoop ");
	localcmd (ftos(cvar("customcoop")));
	localcmd ("\n");
		
	// Teamknockback		
	localcmd ("serverinfo teamknockback ");
	localcmd (ftos(cvar("teamknockback")));
	localcmd ("\n");						
	
	// Falling Damage				
	localcmd ("serverinfo falldamage ");
	localcmd (ftos(cvar("falldamage")));
	localcmd ("\n");					
	
	// Offhand Hook		
	localcmd ("serverinfo use_offhand_hook ");
	localcmd (ftos(cvar("use_offhand_hook")));
	localcmd ("\n");			
			
	localcmd ("serverinfo offhand_hook_speed ");
	localcmd (ftos(cvar("offhand_hook_speed")));
	localcmd ("\n");
			
	localcmd ("serverinfo offhand_hook_pullspeed ");
	localcmd (ftos(cvar("offhand_hook_pullspeed")));
	localcmd ("\n");
	
	localcmd ("serverinfo offhand_hook_anchor_time ");
	localcmd (ftos(cvar("offhand_hook_anchor_time")));
	localcmd ("\n");
	
	localcmd ("serverinfo offhand_hook_anchor_timeout ");
	localcmd (ftos(cvar("offhand_hook_anchor_timeout")));
	localcmd ("\n");
	
	localcmd ("serverinfo offhand_hook_enable_damage ");
	localcmd (ftos(cvar("offhand_hook_enable_damage")));
	localcmd ("\n");
	
	localcmd ("serverinfo offhand_hook_damage ");
	localcmd (ftos(cvar("offhand_hook_damage")));
	localcmd ("\n");
	
	localcmd ("serverinfo offhand_skyhook ");		
	localcmd (ftos(cvar("offhand_skyhook")));
	localcmd ("\n");
		
	// Grappling Hook
	localcmd ("serverinfo use_grappling_hook ");
	localcmd (ftos(cvar("use_grappling_hook")));
	localcmd ("\n");	
	
	localcmd ("serverinfo grappling_hook_speed ");
	localcmd (ftos(cvar("grappling_hook_speed")));
	localcmd ("\n");
			
	localcmd ("serverinfo grappling_hook_pullspeed ");
	localcmd (ftos(cvar("grappling_hook_pullspeed")));
	localcmd ("\n");
	
	localcmd ("serverinfo grappling_hook_anchor_time ");
	localcmd (ftos(cvar("grappling_hook_anchor_time")));
	localcmd ("\n");
	
	localcmd ("serverinfo grappling_hook_anchor_timeout ");
	localcmd (ftos(cvar("grappling_hook_anchor_timeout")));
	localcmd ("\n");
	
	localcmd ("serverinfo grappling_hook_enable_damage ");
	localcmd (ftos(cvar("grappling_hook_enable_damage")));
	localcmd ("\n");
	
	localcmd ("serverinfo grappling_hook_damage ");
	localcmd (ftos(cvar("grappling_hook_damage")));
	localcmd ("\n");
	
	localcmd ("serverinfo grappling_skyhook ");		
	localcmd (ftos(cvar("grappling_skyhook")));
	localcmd ("\n");			
	
	// Bunnies
	localcmd ("serverinfo qw_physics_capped ");
	localcmd (ftos(cvar("qw_physics_capped")));
	localcmd ("\n");	
	
	localcmd ("serverinfo qw_physics_speedcap ");
	localcmd (ftos(cvar("qw_physics_speedcap")));
	localcmd ("\n");
	
	localcmd ("serverinfo allow_bunnyhopping ");
	localcmd (ftos(cvar("allow_bunnyhopping")));
	localcmd ("\n");	
	
	// Capturelimit	
	localcmd ("serverinfo capturelimit ");
	localcmd (ftos(cvar("capturelimit")));
	localcmd ("\n");
	
	// Warmup
	localcmd ("serverinfo warmup ");
	localcmd (ftos(cvar("warmup")));
	localcmd ("\n");
	
	localcmd ("serverinfo warmup_countdown_num ");
	localcmd (ftos(cvar("warmup_countdown_num")));
	localcmd ("\n");	
	
	// Instagib
	localcmd ("serverinfo instagib ");
	localcmd (ftos(cvar("instagib")));
	localcmd ("\n");	
		
	update_serverinfo = time + 60;						
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
				if (gameworld == ID1) cvar_set("hostname", "iD1 | NQW Co-Op +cosmetics (Hybrid)");
				// HIPNOTIC Cooperative
				else if (gameworld == HIPNOTIC)	cvar_set("hostname", "SoA | NQW Co-Op +cosmetics (Hybrid)");
				// ROGUE Cooperative
				else if (gameworld == ROGUE) cvar_set("hostname", "DoE | NQW Co-Op +cosmetics (Hybrid)");
				// DOPA Cooperative
				else if (gameworld == DOPA) cvar_set("hostname", "DOPA | NQW Co-Op +cosmetics (Hybrid)");
				// MG1 Cooperative
				else if (gameworld == MG1) cvar_set("hostname", "MG1 | NQW Co-Op +cosmetics (Hybrid)");	
				// Custom Maps Cooperative
				else cvar_set("hostname", "Custom | NQW Co-Op +cosmetics (Hybrid)");
			}
			// Cooperative Speedrun
			else if (cvar("coop") == CLASSIC_COOP && !cvar("horde") && !cvar("deathmatch") && !cvar("instagib"))
			{
				// iD1 Cooperative Speedrun
				if (gameworld == ID1) cvar_set("hostname", "iD1 | NQW Co-Op Speedrunning +cosmetics (Hybrid)");
				// HIPNOTIC Cooperative Speedrun	
				else if (gameworld == HIPNOTIC) cvar_set("hostname", "SoA | NQW Co-Op Speedrunning +cosmetics (Hybrid)");
				// ROGUE Cooperative Speedrun
				else if (gameworld == ROGUE) cvar_set("hostname", "DoE | NQW Co-Op Speedrunning +cosmetics (Hybrid)");
				// DOPA Cooperative Speedrun
				else if (gameworld == DOPA) cvar_set("hostname", "DOPA | NQW Co-Op Speedrunning +cosmetics (Hybrid)");
				// MG1 Cooperative Speedrun
				else if (gameworld == MG1) cvar_set("hostname", "MG1 | NQW Co-Op Speedrunning +cosmetics (Hybrid)");
				// Custom Maps Cooperative Speedrun
				else cvar_set("hostname", "Custom | NQW Co-Op Speedrunning +cosmetics (Hybrid)");
			}
			// Single Player Speedrun
			else if (!cvar("coop") && !cvar("horde") && !cvar("deathmatch") && !cvar("instagib"))
			{
				// iD1 Single Player Speedrun
				if (gameworld == ID1) cvar_set("hostname", "iD1 | NQW Speedrunning +cosmetics (Hybrid)");
				// HIPNOTIC Single Player Speedrun
				else if (gameworld == HIPNOTIC)	cvar_set("hostname", "SoA | NQW Speedrunning +cosmetics (Hybrid)");
				// ROGUE Single Player Speedrun
				else if (gameworld == ROGUE) cvar_set("hostname", "DoE | NQW Speedrunning +cosmetics (Hybrid)");
				// DOPA Single Player Speedrun	
				else if (gameworld == DOPA) cvar_set("hostname", "DOPA | NQW Speedrunning +cosmetics (Hybrid)");
				// MG1 Single Player Speedrun
				else if (gameworld == MG1) cvar_set("hostname", "MG1 | NQW Speedrunning +cosmetics (Hybrid)");
				// Custom Maps Single Player Speedrun	
				else cvar_set("hostname", "Custom | NQW Speedrunning +cosmetics (Hybrid)");
			}
			// Duel
			else if (!cvar("coop") && !cvar("horde") && cvar("deathmatch") == DM_DUEL && !cvar("instagib"))
			{
				// iD1 Duel
				if (gameworld == ID1) cvar_set("hostname", "iD1 | NQW Duel +cosmetics (Hybrid)");
				// HIPNOTIC Duel
				else if (gameworld == HIPNOTIC)	cvar_set("hostname", "SoA | NQW Duel +cosmetics (Hybrid)");
				// ROGUE Duel
				else if (gameworld == ROGUE) cvar_set("hostname", "DoE | NQW Duel +cosmetics (Hybrid)");
				// DOPA Duel	
				else if (gameworld == DOPA) cvar_set("hostname", "DOPA | NQW Duel +cosmetics (Hybrid)");
				// MG1 Duel
				else if (gameworld == MG1) cvar_set("hostname", "MG1 | NQW Duel +cosmetics (Hybrid)");
				// Custom Maps Duel	
				else cvar_set("hostname", "Custom | NQW Duel +cosmetics (Hybrid)");
			}
			// Free For All
			else if (!cvar("coop") && !cvar("horde") && cvar("deathmatch") == DM_FFA)
			{
				if (!cvar("instagib"))
				{
					// iD1 Free For All
					if (gameworld == ID1) cvar_set("hostname", "iD1 | NQW FFA +cosmetics (Hybrid)");
					// HIPNOTIC Free For All	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "SoA | NQW FFA +cosmetics (Hybrid)");
					// ROGUE Free For All
					else if (gameworld == ROGUE) cvar_set("hostname", "DoE | NQW FFA +cosmetics (Hybrid)");
					// DOPA Free For All	
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA | NQW FFA +cosmetics (Hybrid)");
					// MG1 Free For All
					else if (gameworld == MG1) cvar_set("hostname", "MG1 | NQW FFA +cosmetics (Hybrid)");
					// Custom Maps Free For All	
					else cvar_set("hostname", "Custom | NQW FFA +cosmetics (Hybrid)");
				}
				else if (cvar("instagib") == INSTAGIB_ON)
				{
					// iD1 Free For All
					if (gameworld == ID1) cvar_set("hostname", "iD1 | NQW iFFA +cosmetics (Hybrid)");
					// HIPNOTIC Free For All	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "SoA | NQW iFFA +cosmetics (Hybrid)");
					// ROGUE Free For All
					else if (gameworld == ROGUE) cvar_set("hostname", "DoE | NQW iFFA +cosmetics (Hybrid)");
					// DOPA Free For All	
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA | NQW iFFA +cosmetics (Hybrid)");
					// MG1 Free For All
					else if (gameworld == MG1) cvar_set("hostname", "MG1 | NQW iFFA +cosmetics (Hybrid)");
					// Custom Maps Free For All	
					else cvar_set("hostname", "Custom | NQW iFFA +cosmetics (Hybrid)");
				}
				else if (cvar("instagib") == INSTAGIB_RAILWARZ)
				{
					// iD1 Free For All
					if (gameworld == ID1) cvar_set("hostname", "iD1 | NQW Railwarz FFA +cosmetics (Hybrid)");
					// HIPNOTIC Free For All	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "SoA | NQW Railwarz FFA +cosmetics (Hybrid)");
					// ROGUE Free For All
					else if (gameworld == ROGUE) cvar_set("hostname", "DoE | NQW Railwarz FFA +cosmetics (Hybrid)");
					// DOPA Free For All	
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA | NQW Railwarz FFA +cosmetics (Hybrid)");
					// MG1 Free For All
					else if (gameworld == MG1) cvar_set("hostname", "MG1 | NQW Railwarz FFA +cosmetics (Hybrid)");
					// Custom Maps Free For All	
					else cvar_set("hostname", "Custom | NQW Railwarz FFA +cosmetics (Hybrid)");
				}												
			}
			// Team Deathmatch
			else if (!cvar("coop") && !cvar("horde") && cvar("deathmatch") == DM_TDM)
			{
				if (!cvar("instagib"))
				{
					// iD1 Team Deathmatch
					if (gameworld == ID1) cvar_set("hostname", "iD1 | NQW TDM +cosmetics (Hybrid)");
					// HIPNOTIC Team Deathmatch	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "SoA | NQW TDM +cosmetics (Hybrid)");
					// ROGUE Team Deathmatch
					else if (gameworld == ROGUE) cvar_set("hostname", "DoE | NQW TDM +cosmetics (Hybrid)");
					// DOPA Team Deathmatch
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA | NQW TDM +cosmetics (Hybrid)");
					// MG1 Team Deathmatch
					else if (gameworld == MG1) cvar_set("hostname", "MG1 | NQW TDM +cosmetics (Hybrid)");
					// Custom Maps Team Deathmatch	
					else cvar_set("hostname", "Custom | NQW TDM +cosmetics (Hybrid)");
				}
				else if (cvar("instagib") == INSTAGIB_ON)
				{
					// iD1 Team Deathmatch
					if (gameworld == ID1) cvar_set("hostname", "iD1 | NQW iTDM +cosmetics (Hybrid)");
					// HIPNOTIC Team Deathmatch	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "SoA | NQW iTDM +cosmetics (Hybrid)");
					// ROGUE Team Deathmatch
					else if (gameworld == ROGUE) cvar_set("hostname", "DoE | NQW iTDM +cosmetics (Hybrid)");
					// DOPA Team Deathmatch
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA | NQW iTDM +cosmetics (Hybrid)");
					// MG1 Team Deathmatch
					else if (gameworld == MG1) cvar_set("hostname", "MG1 | NQW iTDM +cosmetics (Hybrid)");
					// Custom Maps Team Deathmatch	
					else cvar_set("hostname", "Custom | NQW iTDM +cosmetics (Hybrid)");
				}				
				else if (cvar("instagib") == INSTAGIB_RAILWARZ)
				{
					// iD1 Team Deathmatch
					if (gameworld == ID1) cvar_set("hostname", "iD1 | NQW Railwarz TDM +cosmetics (Hybrid)");
					// HIPNOTIC Team Deathmatch	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "SoA | NQW Railwarz TDM +cosmetics (Hybrid)");
					// ROGUE Team Deathmatch
					else if (gameworld == ROGUE) cvar_set("hostname", "DoE | NQW Railwarz TDM +cosmetics (Hybrid)");
					// DOPA Team Deathmatch
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA | NQW Railwarz TDM +cosmetics (Hybrid)");
					// MG1 Team Deathmatch
					else if (gameworld == MG1) cvar_set("hostname", "MG1 | NQW Railwarz TDM +cosmetics (Hybrid)");
					// Custom Maps Team Deathmatch	
					else cvar_set("hostname", "Custom | NQW Railwarz TDM +cosmetics (Hybrid)");
				}				
			}
			// Capture The Flag
			else if (!cvar("coop") && !cvar("horde") && cvar("deathmatch") == DM_CTF)
			{
				if (!cvar("instagib"))
				{
					// iD1 Capture The Flag
					if (gameworld == ID1) cvar_set("hostname", "iD1 | NQW CTF +cosmetics (Hybrid)");
					// HIPNOTIC Capture The Flag	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "SoA | NQW CTF +cosmetics (Hybrid)");
					// ROGUE Capture The Flag
					else if (gameworld == ROGUE) cvar_set("hostname", "DoE | NQW CTF +cosmetics (Hybrid)");
					// DOPA Capture The Flag
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA | NQW CTF +cosmetics (Hybrid)");
					// MG1 Capture The Flag
					else if (gameworld == MG1) cvar_set("hostname", "MG1 | NQW CTF +cosmetics (Hybrid)");
					// Custom Maps Capture The Flag
					else cvar_set("hostname", "Custom | NQW CTF +cosmetics (Hybrid)");
				}
				else if (cvar("instagib") == INSTAGIB_ON)
				{
					// iD1 Capture The Flag
					if (gameworld == ID1) cvar_set("hostname", "iD1 | NQW iCTF +cosmetics (Hybrid)");
					// HIPNOTIC Capture The Flag	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "SoA | NQW iCTF +cosmetics (Hybrid)");
					// ROGUE Capture The Flag
					else if (gameworld == ROGUE) cvar_set("hostname", "DoE | NQW iCTF +cosmetics (Hybrid)");
					// DOPA Capture The Flag
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA | NQW iCTF +cosmetics (Hybrid)");
					// MG1 Capture The Flag
					else if (gameworld == MG1) cvar_set("hostname", "MG1 | NQW iCTF +cosmetics (Hybrid)");
					// Custom Maps Capture The Flag
					else cvar_set("hostname", "Custom | NQW iCTF +cosmetics (Hybrid)");
				}				
				else if (cvar("instagib") == INSTAGIB_RAILWARZ)
				{
					// iD1 Capture The Flag
					if (gameworld == ID1) cvar_set("hostname", "iD1 | NQW Railwarz CTF +cosmetics (Hybrid)");
					// HIPNOTIC Capture The Flag	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "SoA | NQW Railwarz CTF +cosmetics (Hybrid)");
					// ROGUE Capture The Flag
					else if (gameworld == ROGUE) cvar_set("hostname", "DoE | NQW Railwarz CTF +cosmetics (Hybrid)");
					// DOPA Capture The Flag
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA | NQW Railwarz CTF +cosmetics (Hybrid)");
					// MG1 Capture The Flag
					else if (gameworld == MG1) cvar_set("hostname", "MG1 | NQW Railwarz CTF +cosmetics (Hybrid)");
					// Custom Maps Capture The Flag
					else cvar_set("hostname", "Custom | NQW Railwarz CTF +cosmetics (Hybrid)");
				}				
			}				
			// One Flag CTF
			else if (!cvar("coop") && !cvar("horde") && cvar("deathmatch") == DM_OneFlagCTF)
			{
				if (!cvar("instagib"))
				{
					// iD1 One Flag CTF
					if (gameworld == ID1) cvar_set("hostname", "iD1 | NQW One Flag CTF +cosmetics (Hybrid)");
					// HIPNOTIC One Flag CTF
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "SoA | NQW One Flag CTF +cosmetics (Hybrid)");
					// ROGUE One Flag CTF
					else if (gameworld == ROGUE) cvar_set("hostname", "DoE | NQW One Flag CTF +cosmetics (Hybrid)");
					// DOPA One Flag CTF
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA | NQW One Flag CTF +cosmetics (Hybrid)");
					// MG1 One Flag CTF
					else if (gameworld == MG1) cvar_set("hostname", "MG1 | NQW One Flag CTF +cosmetics (Hybrid)");
					// Custom Maps One Flag CTF
					else cvar_set("hostname", "Custom | NQW One Flag CTF +cosmetics (Hybrid)");
				}
				else if (cvar("instagib") == INSTAGIB_ON)
				{
					// iD1 One Flag CTF
					if (gameworld == ID1) cvar_set("hostname", "iD1 | NQW One Flag iCTF +cosmetics (Hybrid)");
					// HIPNOTIC One Flag CTF
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "SoA | NQW One Flag iCTF +cosmetics (Hybrid)");
					// ROGUE One Flag CTF
					else if (gameworld == ROGUE) cvar_set("hostname", "DoE | NQW One Flag iCTF +cosmetics (Hybrid)");
					// DOPA One Flag CTF
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA | NQW One Flag iCTF +cosmetics (Hybrid)");
					// MG1 One Flag CTF
					else if (gameworld == MG1) cvar_set("hostname", "MG1 | NQW One Flag iCTF +cosmetics (Hybrid)");
					// Custom Maps One Flag CTF
					else cvar_set("hostname", "Custom | NQW One Flag iCTF +cosmetics (Hybrid)");
				}				
				else if (cvar("instagib") == INSTAGIB_RAILWARZ)
				{
					// iD1 One Flag CTF
					if (gameworld == ID1) cvar_set("hostname", "iD1 | NQW One Flag iCTF +cosmetics (Hybrid)");
					// HIPNOTIC One Flag CTF
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "SoA | NQW One Flag Railwarz CTF +cosmetics (Hybrid)");
					// ROGUE One Flag CTF
					else if (gameworld == ROGUE) cvar_set("hostname", "DoE | NQW One Flag Railwarz CTF +cosmetics (Hybrid)");
					// DOPA One Flag CTF
					else if (gameworld == DOPA) cvar_set("hostname", "DOPA | NQW One Flag Railwarz CTF +cosmetics (Hybrid)");
					// MG1 One Flag CTF
					else if (gameworld == MG1) cvar_set("hostname", "MG1 | NQW One Flag Railwarz CTF +cosmetics (Hybrid)");
					// Custom Maps One Flag CTF
					else cvar_set("hostname", "Custom | NQW One Flag Railwarz CTF +cosmetics (Hybrid)");
				}				
			}				
			// Horde Mode
			else if (cvar("coop") <= 4 && cvar("horde") && !cvar("deathmatch") && !cvar("instagib"))
			{
				// MG1 Horde Mode
				if (gameworld == MG1) cvar_set("hostname", "MG1 | NQW Horde +cosmetics (Hybrid)");
				// Custom Maps Horde Mode	
				else cvar_set("hostname", "Custom | NQW Horde +cosmetics (Hybrid)");
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
	cvar_set("warmup", "0");
	cvar_set("warmup_countdown_num", "0");
	cvar_set("instagib", "1");
		
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
	cvar_set("warmup", "0");
	cvar_set("warmup_countdown_num", "0");
	cvar_set("instagib", "2");
		
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
	cvar_set ("falldamage", "1");
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
	cvar_set("instagib", "2");
	
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
	cvar_set("instagib", "2");
	
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