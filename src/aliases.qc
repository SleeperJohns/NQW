/*
===========
Aliases

Called to send aliases to connecting clients
============
*/

// Aliases for Co-Op
void() Send_Coop_Aliases =
{
	// Single Player & Cooperative
	if (coop >= 0 && !deathmatch)
	{
		stuffcmd(self, "alias setskill5 impulse 55\n");
		stuffcmd(self, "alias setskill4 impulse 54\n");
		stuffcmd(self, "alias setskill3 impulse 53\n");
		stuffcmd(self, "alias setskill2 impulse 52\n");
		stuffcmd(self, "alias setskill1 impulse 51\n");
		stuffcmd(self, "alias setskill0 impulse 50\n");
		stuffcmd(self, "color 1 6\n"); // Force base palette
	}		
};

// Aliases for Deathmatch & Teamplay
void() Send_DM_Aliases =
{
	if (!coop)
	{
		if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF)
		{
			stuffcmd(self, "alias teamred impulse 138\n");
			stuffcmd(self, "alias teamblue impulse 139\n");
			if (self.team == TEAM1) stuffcmd(self, "color 4 4\n");   // Force team red
			if (self.team == TEAM2) stuffcmd(self, "color 13 13\n");  // Force team blue
		}	
		if (deathmatch == DM_DUEL || deathmatch == DM_FFA)
		{
			stuffcmd(self, "color 1 6\n");  // Force base palette
		}
	}			
};

// General Aliases
void() Send_General_Aliases =
{
	// FTE Spectator Functions
	stuffcmd(self, "alias join cmd join\n"); // To exit FTE spectator mode and join the game. If user is using a QuakeWorld Client, this will be rewritten to something else, as QW-Clients have their own observer aliases built-in.	
	stuffcmd(self, "alias observe cmd observe\n"); // To go into FTE spectator mode. If user is using a QuakeWorld Client, this will be rewritten to something else, as QW-Clients have their own observer aliases built-in.
	
	// Aliases for the Information Menus
	stuffcmd(self, "alias server-help impulse 92\n");
	if (deathmatch >= DM_CTF && deathmatch <= DM_OneFlagCTF && !coop) 
	{
		stuffcmd(self, "alias check_teamknockback impulse 91\n");
		stuffcmd(self, "alias check_friendlyfire impulse 90\n");
	}
	if (coop >= REIGNITED_COOP && !deathmatch)
	{
		stuffcmd(self, "alias check_allyknockback impulse 91\n");
		stuffcmd(self, "alias check_selfdamage impulse 90\n");	
	}
	stuffcmd(self, "alias check_playerphysics impulse 89\n");
	stuffcmd(self, "alias check_skill impulse 88\n");
	stuffcmd(self, "alias check_gametype impulse 87\n");
	stuffcmd(self, "alias avail_gametype impulse 86 \n");
	stuffcmd(self, "alias troubleshoot_info impulse 85\n");
	stuffcmd(self, "alias speedrunning_info impulse 84\n");
	stuffcmd(self, "alias mapvote_info impulse 83\n");
	stuffcmd(self, "alias avail_skill impulse 82\n");
	stuffcmd(self, "alias skill_info impulse 81\n");
	stuffcmd(self, "alias cosmetic_info impulse 80\n");
	stuffcmd(self, "alias change_model impulse 100\n");
	stuffcmd(self, "alias change_skin impulse 137\n");
	stuffcmd(self, "alias taunt impulse 40\n");
	stuffcmd(self, "alias change_playerphysics impulse 59\n");
	stuffcmd(self, "alias +hook impulse 38\n");
	stuffcmd(self, "alias -hook impulse 39\n");
	if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF && !coop)
	{
		stuffcmd(self, "alias health_protect_disable_friendlyfire impulse 101\n");
		stuffcmd(self, "alias enable_friendlyfire impulse 102\n");
		stuffcmd(self, "alias armor_protect_enable_friendlyfire impulse 103\n");
		stuffcmd(self, "alias all_disable_friendlyfire impulse 104\n");
		stuffcmd(self, "alias enable_teamknockback impulse 105\n");
		stuffcmd(self, "alias disable_teamknockback impulse 106\n");
	}
	if (coop >= REIGNITED_COOP && !deathmatch)
	{
		stuffcmd(self, "alias disable_selfdamage impulse 101\n");
		stuffcmd(self, "alias teamkiller_friendlyfire impulse 102\n");
		stuffcmd(self, "alias enable_selfdamage impulse 103\n");
		stuffcmd(self, "alias disable_allyknockback impulse 105\n");
		stuffcmd(self, "alias enable_allyknockback impulse 106\n");
	}			
};

void() Send_Enforced_Settings =
{
	// Sleeper: Enforce so people can get into the server
	if (self.client == FTEQW_CLIENT) stuffcmd(self, "setinfo cl_nopext 1\n");
	if (self.client == FTEQW_CLIENT) stuffcmd(self, "cl_nopext 1\n");
	
	if (self.client == QSSM_CLIENT) stuffcmd(self, "setinfo cl_nopext 0\n");
	if (self.client == QSSM_CLIENT) stuffcmd(self, "cl_nopext 0\n");	

	// Sleeper: ezQuake version of above
	if (self.client == EzQ_CLIENT) stuffcmd(self, "setinfo cl_pext 0\n");
	if (self.client == EzQ_CLIENT) stuffcmd(self, "cl_pext 0\n");
	
	// Sleeper: Disable autotrack so FTE spectator mode can attach to a intermission camera
	if (self.client == FTEQW_CLIENT) stuffcmd(self, "cl_autotrack 0\n");
	
	// Sleeper: Similiar to above, but for teammates with the same pants color
	if (self.client == FTEQW_CLIENT) stuffcmd(self, "cl_autotrack_team 0\n");

	// Sleeper: Disable fog for NQ source ports
	stuffcmd(self, "setinfo fog 0\n");

	// Sleeper: Disable fog for QW source ports
	stuffcmd(self, "setinfo gl_fog 0\n");

	// Sleeper: For Qrack, disable fog
	stuffcmd(self, "setinfo gl_fogenable 0\n");

	// Sleeper: Water fog is cool
	stuffcmd(self, "setinfo gl_waterfog 1\n");

	// Sleeper: You limit your vertical view reach
	stuffcmd(self, "setinfo minpitch -71.47\n");

	// Sleeper: Same as the previous
	stuffcmd(self, "setinfo cl_minpitch -71.47\n");
	
	// Sleeper: Enforce 150 netfps
	if (self.client == FTEQW_CLIENT) stuffcmd(self, "setinfo cl_netfps 150\n");

	// Sleeper: For Ironwail to use the a custom HUD
	stuffcmd(self, "setinfo hudstyle 2\n");

	// Sleeper: Force a faster print speed
	stuffcmd(self, "setinfo scr_printspeed 32\n");
	
	// Sleeper: Enforce downloads to be enabled
	stuffcmd(self, "setinfo auto_download 1\n");	
	
	// Sleeper: Enforce protocol
	stuffcmd(self, "setinfo sv_protocol 999\n");
	
	// Sleeper: Enforce Net Quake protocol
	stuffcmd(self, "setinfo sv_protocol_nq 999\n");
};