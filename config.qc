// What version are we on?
string NQW_Version = "NQWVer v1.13b";

float Version_To_Startframe_Traffic;

string() Campaign_Name =
{
	if (!cvar("deathmatch"))
	{
		if (gameworld == UNKNOWN) return "GameWorld UNKNOWN";
		if (gameworld == ID1) return "GameWorld ID1";
		if (gameworld == HIPNOTIC) return "GameWorld HIPNOTIC";
		if (gameworld == ROGUE) return "GameWorld ROGUE";
		if (gameworld == DOPA) return "GameWorld DOPA";
		if (gameworld == MG1) return "GameWorld MG1";
		if (gameworld == CUSTOM) return "GameWorld Custom";
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
//	speedrunning_mode = cvar("speedrunning_mode"); // Sleeper: Clamps everything needed down to what would be considered legal in a real speedrun. 0 = Default (Off), 1 = NQ Single Player, 2 = QW Single Player, 3 = NQ Co-Operative, 4 = QW Co-Operative.
		
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
	
	// Sudden Death (Overtime) Cvars
//	sudden_death = cvar("sudden_death"); 
//	sudden_death_style = cvar("sudden_death_style");
//	sudden_death_timelimit = cvar("sudden_death_timelimit");
//	sudden_death_max_rounds = cvar("sudden_death_max_rounds");
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
	
	// Sudden Death (Overtime)
	localcmd ("serverinfo sudden_death ");
	localcmd (ftos(cvar("sudden_death")));
	localcmd ("\n");
	
	localcmd ("serverinfo sudden_death_style ");
	localcmd (ftos(cvar("sudden_death_style")));
	localcmd ("\n");
	
	localcmd ("serverinfo sudden_death_timelimit ");
	localcmd (ftos(cvar("sudden_death_timelimit")));
	localcmd ("\n");
	
	localcmd ("serverinfo sudden_death_max_rounds ");
	localcmd (ftos(cvar("sudden_death_max_rounds")));
	localcmd ("\n");
	
	// Warmup
	localcmd ("serverinfo warmup ");
	localcmd (ftos(cvar("warmup")));
	localcmd ("\n");
	
	localcmd ("serverinfo warmup_countdown_num ");
	localcmd (ftos(cvar("warmup_countdown_num")));
	localcmd ("\n");	
	
	// Instagib
//	localcmd ("serverinfo instagib ");
//	localcmd (ftos(cvar("instagib")));
//	localcmd ("\n");
		
	update_serverinfo = time + 60;						
};

// New Hostname Format:
// [MODNAME]-[GAMEWORLD NAME]: [MODE] +cosmetics [NQ, QW, DP, OR HYBRID]

// New Template for Co-Op: 
// NQW-iD1: Co-Op +cosmetics (Hybrid)
// NQW-HIPNOTIC: Co-Op +cosmetics (Hybrid)
// NQW-ROGUE: Co-Op +cosmetics (Hybrid)
// NQW-DOPA: Co-Op +cosmetics (Hybrid)
// NQW-MG1: Co-Op +cosmetics (Hybrid)
// NQW-DOPA: Co-Op +cosmetics (Hybrid)
// NQW-CUSTOM: Co-Op +cosmetics (Hybrid)

// New Template for Horde:
// NQW-iD1: Horde +cosmetics (Hybrid)
// NQW-HIPNOTIC: Horde +cosmetics (Hybrid)
// NQW-ROGUE: Horde +cosmetics (Hybrid)
// NQW-DOPA: Horde +cosmetics (Hybrid)
// NQW-MG1: Horde +cosmetics (Hybrid)
// NQW-DOPA: Horde +cosmetics (Hybrid)
// NQW-CUSTOM: Horde +cosmetics (Hybrid)
// NQW-MG1: Horde +cosmetics (Hybrid)

// New Template for FFA: 
// NQW-iD1: Duel +cosmetics (Hybrid)
// NQW-HIPNOTIC: Duel +cosmetics (Hybrid)
// NQW-ROGUE: Duel +cosmetics (Hybrid)
// NQW-DOPA: Duel +cosmetics (Hybrid)
// NQW-MG1: Duel +cosmetics (Hybrid)
// NQW-DOPA: Duel +cosmetics (Hybrid)
// NQW-CUSTOM: Duel +cosmetics (Hybrid)

// New Template for FFA: 
// NQW-iD1: FFA +cosmetics (Hybrid)
// NQW-HIPNOTIC: FFA +cosmetics (Hybrid)
// NQW-ROGUE: FFA +cosmetics (Hybrid)
// NQW-DOPA: FFA +cosmetics (Hybrid)
// NQW-MG1: FFA +cosmetics (Hybrid)
// NQW-DOPA: FFA +cosmetics (Hybrid)
// NQW-CUSTOM: FFA +cosmetics (Hybrid)

// New Template for TDM: 
// NQW-iD1: TDM +cosmetics (Hybrid)
// NQW-HIPNOTIC: TDM +cosmetics (Hybrid)
// NQW-ROGUE: TDM +cosmetics (Hybrid)
// NQW-DOPA: TDM +cosmetics (Hybrid)
// NQW-MG1: TDM +cosmetics (Hybrid)
// NQW-DOPA: TDM +cosmetics (Hybrid)
// NQW-CUSTOM: TDM +cosmetics (Hybrid)

// New Template for CTF: 
// NQW-iD1: CTF +cosmetics (Hybrid)
// NQW-HIPNOTIC: CTF +cosmetics (Hybrid)
// NQW-ROGUE: CTF +cosmetics (Hybrid)
// NQW-DOPA: CTF +cosmetics (Hybrid)
// NQW-MG1: CTF +cosmetics (Hybrid)
// NQW-DOPA: CTF +cosmetics (Hybrid)
// NQW-CUSTOM: CTF +cosmetics (Hybrid)

// New Template for One Flag CTF: 
// NQW-iD1: One Flag CTF +cosmetics (Hybrid)
// NQW-HIPNOTIC: One Flag CTF +cosmetics (Hybrid)
// NQW-ROGUE: One Flag CTF +cosmetics (Hybrid)
// NQW-DOPA: One Flag CTF +cosmetics (Hybrid)
// NQW-MG1: One Flag CTF +cosmetics (Hybrid)
// NQW-DOPA: One Flag CTF +cosmetics (Hybrid)
// NQW-CUSTOM: One Flag CTF +cosmetics (Hybrid)

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
			if (cvar("coop") == REIGNITED_COOP && !cvar("horde") && !cvar("deathmatch")/* && !cvar("instagib")*/)
			{
				// iD1 Cooperative
				if (gameworld == ID1) cvar_set("hostname", "NQW-iD1: Co-Op +cosmetics (Hybrid)");
				// HIPNOTIC Cooperative
				else if (gameworld == HIPNOTIC)	cvar_set("hostname", "NQW-HIPNOTIC: Co-Op +cosmetics (Hybrid)");
				// ROGUE Cooperative
				else if (gameworld == ROGUE) cvar_set("hostname", "NQW-ROGUE: Co-Op +cosmetics (Hybrid)");
				// DOPA Cooperative
				else if (gameworld == DOPA) cvar_set("hostname", "NQW-DOPA: Co-Op +cosmetics (Hybrid)");
				// MG1 Cooperative
				else if (gameworld == MG1) cvar_set("hostname", "NQW-MG1: Co-Op +cosmetics (Hybrid)");	
				// Apotheosis Cooperative
				else if (gameworld == APOTHEOSIS) cvar_set("hostname", "NQW-APOTHEOSIS: Co-Op +cosmetics (Hybrid)");
				// Custom Maps Cooperative
				else cvar_set("hostname", "NQW-CUSTOM: Co-Op +cosmetics (Hybrid)");
			}
			// Cooperative Speedrun
			else if (cvar("coop") == CLASSIC_COOP && !cvar("horde") && !cvar("deathmatch")/* && !cvar("instagib")*/)
			{
				// iD1 Cooperative Speedrun
				if (gameworld == ID1) cvar_set("hostname", "NQW-iD1: Co-Op Speedrunning +cosmetics (Hybrid)");
				// HIPNOTIC Cooperative Speedrun	
				else if (gameworld == HIPNOTIC) cvar_set("hostname", "NQW-HIPNOTIC: Co-Op Speedrunning +cosmetics (Hybrid)");
				// ROGUE Cooperative Speedrun
				else if (gameworld == ROGUE) cvar_set("hostname", "NQW-ROGUE: Co-Op Speedrunning +cosmetics (Hybrid)");
				// DOPA Cooperative Speedrun
				else if (gameworld == DOPA) cvar_set("hostname", "NQW-DOPA: Co-Op Speedrunning +cosmetics (Hybrid)");
				// MG1 Cooperative Speedrun
				else if (gameworld == MG1) cvar_set("hostname", "NQW-MG1: Co-Op Speedrunning +cosmetics (Hybrid)");
				// Apotheosis Speedrun
				else if (gameworld == APOTHEOSIS) cvar_set("hostname", "NQW-APOTHEOSIS: Co-Op Speedrunning +cosmetics (Hybrid)");				
				// Custom Maps Cooperative Speedrun
				else cvar_set("hostname", "NQW-CUSTOM: Co-Op Speedrunning +cosmetics (Hybrid)");
			}
			// Single Player Speedrun
			else if (!cvar("coop") && !cvar("horde") && !cvar("deathmatch")/* && !cvar("instagib")*/)
			{
				// iD1 Single Player Speedrun
				if (gameworld == ID1) cvar_set("hostname", "NQW-iD1: Solo Speedrunning +cosmetics (Hybrid)");
				// HIPNOTIC Single Player Speedrun
				else if (gameworld == HIPNOTIC)	cvar_set("hostname", "NQW-HIPNOTIC: Solo Speedrunning +cosmetics (Hybrid)");
				// ROGUE Single Player Speedrun
				else if (gameworld == ROGUE) cvar_set("hostname", "NQW-ROGUE: Solo Speedrunning +cosmetics (Hybrid)");
				// DOPA Single Player Speedrun	
				else if (gameworld == DOPA) cvar_set("hostname", "NQW-DOPA: Solo Speedrunning +cosmetics (Hybrid)");
				// MG1 Single Player Speedrun
				else if (gameworld == MG1) cvar_set("hostname", "NQW-MG1: Solo Speedrunning +cosmetics (Hybrid)");
				// Apotheosis Single Player Speedrun
				else if (gameworld == APOTHEOSIS) cvar_set("hostname", "NQW-APOTHEOSIS: Solo Speedrunning +cosmetics (Hybrid)");				
				// Custom Maps Single Player Speedrun	
				else cvar_set("hostname", "NQW-CUSTOM: Solo Speedrunning +cosmetics (Hybrid)");
			}
			// Duel
			else if (!cvar("coop") && !cvar("horde") && cvar("deathmatch") == DM_DUEL)
			{
//				if (!cvar("instagib"))
//				{
					// iD1 Duel
					if (gameworld == ID1) cvar_set("hostname", "NQW-iD1: Duel +cosmetics (Hybrid)");
					// HIPNOTIC Duel
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "NQW-HIPNOTIC: Duel +cosmetics (Hybrid)");
					// ROGUE Duel
					else if (gameworld == ROGUE) cvar_set("hostname", "NQW-ROGUE: Duel +cosmetics (Hybrid)");
					// DOPA Duel	
					else if (gameworld == DOPA) cvar_set("hostname", "NQW-DOPA: Duel +cosmetics (Hybrid)");
					// MG1 Duel
					else if (gameworld == MG1) cvar_set("hostname", "NQW-MG1: Duel +cosmetics (Hybrid)");
					// Apotheosis Duel
					else if (gameworld == APOTHEOSIS) cvar_set("hostname", "NQW-APOTHEOSIS: Duel +cosmetics (Hybrid)");				
					// Custom Maps Duel	
					else cvar_set("hostname", "NQW-CUSTOM: Duel +cosmetics (Hybrid)");
/*				}
				else
				{
					// iD1 Duel
					if (gameworld == ID1) cvar_set("hostname", "NQW-iD1: Duel Instagib +cosmetics (Hybrid)");
					// HIPNOTIC Duel
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "NQW-HIPNOTIC: Duel Instagib +cosmetics (Hybrid)");
					// ROGUE Duel
					else if (gameworld == ROGUE) cvar_set("hostname", "NQW-ROGUE: Duel Instagib +cosmetics (Hybrid)");
					// DOPA Duel	
					else if (gameworld == DOPA) cvar_set("hostname", "NQW-DOPA: Duel Instagib +cosmetics (Hybrid)");
					// MG1 Duel
					else if (gameworld == MG1) cvar_set("hostname", "NQW-MG1: Duel Instagib +cosmetics (Hybrid)");
					// Apotheosis Duel
					else if (gameworld == APOTHEOSIS) cvar_set("hostname", "NQW-APOTHEOSIS: Duel Instagib +cosmetics (Hybrid)");				
					// Custom Maps Duel	
					else cvar_set("hostname", "NQW-CUSTOM: Duel Instagib +cosmetics (Hybrid)");
				}*/				
			}
			// Free For All
			else if (!cvar("coop") && !cvar("horde") && cvar("deathmatch") == DM_FFA)
			{
//				if (!cvar("instagib"))
//				{
					// iD1 Free For All
					if (gameworld == ID1) cvar_set("hostname", "NQW-iD1: FFA +cosmetics (Hybrid)");
					// HIPNOTIC Free For All	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "NQW-HIPNOTIC: FFA +cosmetics (Hybrid)");
					// ROGUE Free For All
					else if (gameworld == ROGUE) cvar_set("hostname", "NQW-ROGUE: FFA +cosmetics (Hybrid)");
					// DOPA Free For All	
					else if (gameworld == DOPA) cvar_set("hostname", "NQW-DOPA: FFA +cosmetics (Hybrid)");
					// MG1 Free For All
					else if (gameworld == MG1) cvar_set("hostname", "NQW-MG1: FFA +cosmetics (Hybrid)");
					// Apotheosis Free For All
					else if (gameworld == APOTHEOSIS) cvar_set("hostname", "NQW-APOTHEOSIS: FFA +cosmetics (Hybrid)");				
					// Custom Maps Free For All	
					else cvar_set("hostname", "NQW-CUSTOM: FFA +cosmetics (Hybrid)");
/*				}
				else
				{
					if (cvar("instagib") == 1)
					{
						// iD1 Free For All
						if (gameworld == ID1) cvar_set("hostname", "NQW-iD1: FFA Instagib +cosmetics (Hybrid)");
						// HIPNOTIC Free For All	
						else if (gameworld == HIPNOTIC)	cvar_set("hostname", "NQW-HIPNOTIC: FFA Instagib +cosmetics (Hybrid)");
						// ROGUE Free For All
						else if (gameworld == ROGUE) cvar_set("hostname", "NQW-ROGUE: FFA Instagib +cosmetics (Hybrid)");
						// DOPA Free For All	
						else if (gameworld == DOPA) cvar_set("hostname", "NQW-DOPA: FFA Instagib +cosmetics (Hybrid)");
						// MG1 Free For All
						else if (gameworld == MG1) cvar_set("hostname", "NQW-MG1: FFA Instagib +cosmetics (Hybrid)");
						// Apotheosis Free For All
						else if (gameworld == APOTHEOSIS) cvar_set("hostname", "NQW-APOTHEOSIS: FFA Instagib +cosmetics (Hybrid)");				
						// Custom Maps Free For All	
						else cvar_set("hostname", "NQW-CUSTOM: FFA Instagib +cosmetics (Hybrid)");
					}
					if (cvar("instagib") == 2)
					{
						// iD1 Free For All
						if (gameworld == ID1) cvar_set("hostname", "NQW-iD1: Railwarz FFA +cosmetics (Hybrid)");
						// HIPNOTIC Free For All	
						else if (gameworld == HIPNOTIC)	cvar_set("hostname", "NQW-HIPNOTIC: Railwarz FFA +cosmetics (Hybrid)");
						// ROGUE Free For All
						else if (gameworld == ROGUE) cvar_set("hostname", "NQW-ROGUE: Railwarz FFA +cosmetics (Hybrid)");
						// DOPA Free For All	
						else if (gameworld == DOPA) cvar_set("hostname", "NQW-DOPA: Railwarz FFA +cosmetics (Hybrid)");
						// MG1 Free For All
						else if (gameworld == MG1) cvar_set("hostname", "NQW-MG1: Railwarz FFA +cosmetics (Hybrid)");
						// Apotheosis Free For All
						else if (gameworld == APOTHEOSIS) cvar_set("hostname", "NQW-APOTHEOSIS: Railwarz FFA +cosmetics (Hybrid)");				
						// Custom Maps Free For All	
						else cvar_set("hostname", "NQW-CUSTOM: Railwarz FFA +cosmetics (Hybrid)");
					}					
				}*/		
			}
			// Team Deathmatch
			else if (!cvar("coop") && !cvar("horde") && cvar("deathmatch") == DM_TDM)
			{
//				if (!cvar("instagib"))
//				{
					// iD1 Team Deathmatch
					if (gameworld == ID1) cvar_set("hostname", "NQW-iD1: TDM +cosmetics (Hybrid)");
					// HIPNOTIC Team Deathmatch	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "NQW-HIPNOTIC: TDM +cosmetics (Hybrid)");
					// ROGUE Team Deathmatch
					else if (gameworld == ROGUE) cvar_set("hostname", "NQW-ROGUE: TDM +cosmetics (Hybrid)");
					// DOPA Team Deathmatch
					else if (gameworld == DOPA) cvar_set("hostname", "NQW-iD1: TDM +cosmetics (Hybrid)");
					// MG1 Team Deathmatch
					else if (gameworld == MG1) cvar_set("hostname", "NQW-MG1: TDM +cosmetics (Hybrid)");
					// Apotheosis Team Deathmatch
					else if (gameworld == APOTHEOSIS) cvar_set("hostname", "NQW-APOTHEOSIS: TDM +cosmetics (Hybrid)");				
					// Custom Maps Team Deathmatch	
					else cvar_set("hostname", "Custom | NQW TDM +cosmetics (Hybrid)");
/*				}
				else	
				{
					// iD1 Team Deathmatch
					if (gameworld == ID1) cvar_set("hostname", "NQW-iD1: TDM Instagib +cosmetics (Hybrid)");
					// HIPNOTIC Team Deathmatch	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "NQW-HIPNOTIC: TDM Instagib +cosmetics (Hybrid)");
					// ROGUE Team Deathmatch
					else if (gameworld == ROGUE) cvar_set("hostname", "NQW-ROGUE: TDM Instagib +cosmetics (Hybrid)");
					// DOPA Team Deathmatch
					else if (gameworld == DOPA) cvar_set("hostname", "NQW-iD1: TDM Instagib +cosmetics (Hybrid)");
					// MG1 Team Deathmatch
					else if (gameworld == MG1) cvar_set("hostname", "NQW-MG1: TDM Instagib +cosmetics (Hybrid)");
					// Apotheosis Team Deathmatch
					else if (gameworld == APOTHEOSIS) cvar_set("hostname", "NQW-APOTHEOSIS: TDM Instagib +cosmetics (Hybrid)");				
					// Custom Maps Team Deathmatch	
					else cvar_set("hostname", "Custom | NQW TDM Instagib +cosmetics (Hybrid)");
				}*/
			}
			// Capture The Flag
			else if (!cvar("coop") && !cvar("horde") && cvar("deathmatch") == DM_CTF)
			{
//				if (!cvar("instagib"))
//				{
					// iD1 Capture The Flag
					if (gameworld == ID1) cvar_set("hostname", "NQW-iD1: CTF +cosmetics (Hybrid)");
					// HIPNOTIC Capture The Flag	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "NQW-HIPNOTIC: CTF +cosmetics (Hybrid)");
					// ROGUE Capture The Flag
					else if (gameworld == ROGUE) cvar_set("hostname", "NQW-ROGUE: CTF +cosmetics (Hybrid)");
					// DOPA Capture The Flag
					else if (gameworld == DOPA) cvar_set("hostname", "NQW-DOPA: CTF +cosmetics (Hybrid)");
					// MG1 Capture The Flag
					else if (gameworld == MG1) cvar_set("hostname", "NQW-MG1: CTF +cosmetics (Hybrid))");
					// Apotheosis Capture The Flag
					else if (gameworld == APOTHEOSIS) cvar_set("hostname", "NQW-APOTHEOSIS: CTF +cosmetics (Hybrid)");				
					// Custom Maps Capture The Flag
					else cvar_set("hostname", "NQW-CUSTOM: CTF +cosmetics (Hybrid)");
/*				}
				else
				{
					// iD1 Capture The Flag
					if (gameworld == ID1) cvar_set("hostname", "NQW-iD1: CTF Instagib +cosmetics (Hybrid)");
					// HIPNOTIC Capture The Flag	
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "NQW-HIPNOTIC: CTF Instagib +cosmetics (Hybrid)");
					// ROGUE Capture The Flag
					else if (gameworld == ROGUE) cvar_set("hostname", "NQW-ROGUE: CTF Instagib +cosmetics (Hybrid)");
					// DOPA Capture The Flag
					else if (gameworld == DOPA) cvar_set("hostname", "NQW-DOPA: CTF Instagib +cosmetics (Hybrid)");
					// MG1 Capture The Flag
					else if (gameworld == MG1) cvar_set("hostname", "NQW-MG1: CTF Instagib +cosmetics (Hybrid))");
					// Apotheosis Capture The Flag
					else if (gameworld == APOTHEOSIS) cvar_set("hostname", "NQW-APOTHEOSIS: CTF Instagib +cosmetics (Hybrid)");				
					// Custom Maps Capture The Flag
					else cvar_set("hostname", "NQW-CUSTOM: CTF Instagib +cosmetics (Hybrid)");
				}	*/			
			}				
			// One Flag CTF
			else if (!cvar("coop") && !cvar("horde") && cvar("deathmatch") == DM_OneFlagCTF)
			{
//				if (!cvar("instagib"))
//				{
					// iD1 One Flag CTF
					if (gameworld == ID1) cvar_set("hostname", "NQW-iD1: One Flag CTF +cosmetics (Hybrid)");
					// HIPNOTIC One Flag CTF
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "NQW-HIPNOTIC: One Flag CTF +cosmetics (Hybrid)");
					// ROGUE One Flag CTF
					else if (gameworld == ROGUE) cvar_set("hostname", "NQW-ROGUE: One Flag CTF +cosmetics (Hybrid)");
					// DOPA One Flag CTF
					else if (gameworld == DOPA) cvar_set("hostname", "NQW-DOPA: One Flag CTF +cosmetics (Hybrid)");
					// MG1 One Flag CTF
					else if (gameworld == MG1) cvar_set("hostname", "NQW-MG1: One Flag CTF +cosmetics (Hybrid)");
					// Apotheosis One Flag CTF
					else if (gameworld == APOTHEOSIS) cvar_set("hostname", "NQW-APOTHEOSIS: One Flag CTF +cosmetics (Hybrid)");				
					// Custom Maps One Flag CTF
					else cvar_set("hostname", "NQW-CUSTOM: One Flag CTF +cosmetics (Hybrid))");
/*				}
				else
				{
					// iD1 One Flag CTF
					if (gameworld == ID1) cvar_set("hostname", "NQW-iD1: One Flag CTF Instagib +cosmetics (Hybrid)");
					// HIPNOTIC One Flag CTF
					else if (gameworld == HIPNOTIC)	cvar_set("hostname", "NQW-HIPNOTIC: One Flag CTF Instagib +cosmetics (Hybrid)");
					// ROGUE One Flag CTF
					else if (gameworld == ROGUE) cvar_set("hostname", "NQW-ROGUE: One Flag CTF Instagib +cosmetics (Hybrid)");
					// DOPA One Flag CTF
					else if (gameworld == DOPA) cvar_set("hostname", "NQW-DOPA: One Flag CTF Instagib +cosmetics (Hybrid)");
					// MG1 One Flag CTF
					else if (gameworld == MG1) cvar_set("hostname", "NQW-MG1: One Flag CTF Instagib +cosmetics (Hybrid)");
					// Apotheosis One Flag CTF
					else if (gameworld == APOTHEOSIS) cvar_set("hostname", "NQW-APOTHEOSIS: One Flag CTF Instagib +cosmetics (Hybrid)");				
					// Custom Maps One Flag CTF
					else cvar_set("hostname", "NQW-CUSTOM: One Flag CTF Instagib +cosmetics (Hybrid))");
				}*/				
			}																				
			// Horde Mode
			else if (cvar("coop") >= 0 && cvar("horde") && !cvar("deathmatch")/* && !cvar("instagib")*/)
			{
				// iD1 Horde Mode
				if (gameworld == ID1) cvar_set("hostname", "NQW-iD1: Horde +cosmetics (Hybrid)");
				// HIPNOTIC Horde Mode
				else if (gameworld == HIPNOTIC) cvar_set("hostname", "NQW-HIPNOTIC: Horde +cosmetics (Hybrid)");
				// ROGUE Horde Mode
				else if (gameworld == ROGUE) cvar_set("hostname", "NQW-ROGUE: Horde +cosmetics (Hybrid)");
				// DOPA Horde Mode
				else if (gameworld == DOPA) cvar_set("hostname", "NQW-DOPA: Horde +cosmetics (Hybrid)");
				// MG1 Horde Mode
				else if (gameworld == MG1) cvar_set("hostname", "NQW-MG1: Horde +cosmetics (Hybrid)");
				// Apotheosis Horde Mode
				else if (gameworld == APOTHEOSIS) cvar_set("hostname", "NQW-APOTHEOSIS: Horde +cosmetics (Hybrid)");				
				// Custom Maps Horde Mode	
				else cvar_set("hostname", "NQW-CUSTOM: Horde +cosmetics (Hybrid)");
			}
		}
		else cvar_set("hostname", "Unnamed LAN Server +cosmetics (Hybrid)");
	}
	else cvar_set("hostname", "NQW-DEV: Developer +cosmetics (Hybrid)");
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
void() Gametype_Instagib_Duel_Settings = 
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
	cvar_set ("falldamage", "0");
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
	cvar_set("instagib", "1");
	
	if (!cvar("developer"))
	{
		cvar_set ("maxclients", "2");
		cvar_set ("maxspectators", "16");
	}			
};
*/

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
	cvar_set("instagib", "1");
	
	if (!cvar("developer"))
	{		
		cvar_set ("maxclients", "16");
		cvar_set ("maxspectators", "32");	
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
	cvar_set ("offhand_skyhook", "0");
	cvar_set ("offhand_hook_speed", "900");
	cvar_set ("offhand_hook_pullspeed", "1200");
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
	cvar_set ("teamknockback", "1");
	cvar_set ("falldamage", "0");
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
	cvar_set("instagib", "1");
	
	if (!cvar("developer"))
	{	
		cvar_set ("maxclients", "8");
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
	cvar_set("instagib", "0");
	
	if (!cvar("developer"))
	{
		cvar_set ("maxclients", "16");
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
	cvar_set ("offhand_hook_speed", "1250");
	cvar_set ("offhand_hook_pullspeed", "1100");
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

void() Gametype_Instagib_OneFlagCTF_Settings =
{
	cvar_set ("cl_rollangle", "0");
	cvar_set ("noexit", "3");
	cvar_set ("samelevel", "1");
	cvar_set ("coop", "0");
	cvar_set ("customcoop", "0");
	cvar_set ("deathmatch", "10");
	cvar_set ("teamplay", "4");
	cvar_set ("timelimit", "10");
	cvar_set ("fraglimit", "0");
	cvar_set ("capturelimit", "15");
	cvar_set ("teamknockback", "0");
	cvar_set ("falldamage", "0");
	cvar_set ("use_offhand_hook", "0");
	cvar_set ("offhand_skyhook", "0");
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
	cvar_set("instagib", "1");
	
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