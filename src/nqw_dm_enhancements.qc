/* Some transcending elements from Quake III: Arena/Team Arena, Quake IV, and Quake Champions for Deathmatch Modes. */

void(string soundToPlay) countdown_sounds = 
{
	local entity speaker;
	
	if (speaker) remove (speaker); // no multiple sounds  
	
	speaker = spawn ();
	speaker.noise = soundToPlay;
	speaker.nextthink = time + 0.0001;
	speaker.think = playsnd;
};

void() Player_Countdown_Sounds =
{
	if (warmup_engaged && warmup_counttime < time && !initiate_matchtime) 
	{
		if (warmup_countdown >= 2 && warmup_countdown <= 4) countdown_sounds ("buttons/switch04.wav");
	}

	if (matchtime >= 2 && matchtime <= 4 && initiate_matchtime && matchtime_timer < time) countdown_sounds ("buttons/switch04.wav");	
};

string() Warmup_Count =
{	
	if (warmup_counttime < time && warmup_countdown >= -1 && warmup_countdown <= cvar("warmup_countdown_num") + 1) warmup_countdown -= 1;
				
	return ftos(warmup_countdown);
};

/*
================
Warmup_Rules

Called via CheckRules.
Give a countdown before starting a Deathmatch Match.
================
*/
.float client_spawned;
void() Warmup_Rules =
{
	local entity player;	
							
	if (warmup_engaged == TRUE && warmup_counttime < time) 
	{	
		for (float num = 0; num <= 1; num++) // Sleeper: Pitch this to everyone once.
		{			
			for (player = find (world, classname, "player"); player; player = find (player, classname, "player")) 
			{				
				loophack2++;
				if (loophack2 == 1) warmup_countdown = cvar("warmup_countdown_num") + 1;
				
				if (warmup_countdown >= 1 && warmup_countdown <= cvar("warmup_countdown_num") + 1) 
				{
					if (deathmatch == DM_DUEL || deathmatch == DM_FFA) id1_centerprint (player, "Prepare To Fight!\n\n\n", Warmup_Count(), "\n");
					else if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF) id1_centerprint (player, "Prepare Your Team!\n\n\n", Warmup_Count(), "\n");
					warmup_counttime = time + 1;
				}
				else // Sleeper: Match has begun.
				{
					initiate_matchtime = TRUE;
					warmup_engaged = FALSE;
					warmup_counttime = 0;
					id1_centerprint (player, "Fight!\n");
				}
					
				// Sleeper: Nobody fires for the last moments before a forced respawn.
				if (warmup_countdown >= 0 && warmup_countdown <= 6)
				{	
					if (warmup_engaged) player.attack_finished = time + 99999;	
					else 
					{
						if (!player.client_spawned) // Sleeper: Prevent a looping telefrag by respawning everyone once.
						{
							//self.modelindex = self.modelindex_nqwplayer;
							player.client_spawned = TRUE;
							player.attack_finished = time;
//							PutClientInServer ();
							player.think = PutClientInServer;
							player.nextthink = time + 0.0001;
						}
					}
				}
			}
		}
	}	
};

/*
================
SuddenDeath_Rules

Called via CheckRules.
Grants overtime to a match, if teams/players are tied.
(FTE Only Cvar) sudden_death_style = 0 (Default; Off), sudden_death_style = 1 (Quake III: Arena/Team Arena, Quake Champions), sudden_death_style = 2 (Quake Live)
================
*/
void() SuddenDeath_Rules =
{
	local entity leadingplayer, losingplayer;

	if (cvar("sudden_death_style") == 1) // Sleeper: Continue match until one player unbalances the score.
	{
		if (sudden_death_engaged == TRUE) // Sleeper: End game on frag/score or when overtime rounds reach it's max.
		{
			for (leadingplayer = find (world, classname, "player"); leadingplayer; leadingplayer = find (leadingplayer, classname, "player")) // Self
			{
				for (losingplayer = find (world, classname, "player"); losingplayer; losingplayer = find (losingplayer, classname, "player")) // Other
				{	
					if (leadingplayer != losingplayer)
					{
						if (loophack <= 0) loophack++;
						else loophack = 0;
						
						if (sudden_death_round_count <= cvar("sudden_death_max_rounds"))
						{
							if (deathmatch == DM_DUEL || deathmatch == DM_FFA)
							{											
								if (leadingplayer.frags > losingplayer.frags)
								{
									sudden_death_engaged = FALSE;
									endgame = TRUE;
									bprint ("Sudden Death Expired. ", leadingplayer.netname, " wins!\n");
								}																														
								else 
								{
									if (sudden_death_timelimit < time)
									{
										if (loophack == 1) // Sleeper: Only spit this out once.
										{
											sudden_death_round_count++;
											if (sudden_death_round_count <= cvar("sudden_death_max_rounds")) 
											{
												if (sudden_death_round_count < cvar("sudden_death_max_rounds")) bprint ("Sudden Death! (Round ", ftos(sudden_death_round_count), ")\n");
												else bprint ("Sudden Death! (Final Round)\n");
											}
										}
										sudden_death_timelimit = time + (cvar("sudden_death_timelimit") * 60);
									}
								}
							}
							else if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF) 
							{											
								if (TeamScore[TEAM_RED_4] > TeamScore[TEAM_BLUE_13])
								{
									sudden_death_engaged = FALSE;
									endgame = TRUE;
									bprint ("Sudden Death Expired. Red Team wins!\n");
								}
								else if (TeamScore[TEAM_BLUE_13] > TeamScore[TEAM_RED_4])
								{
									sudden_death_engaged = FALSE;
									endgame = TRUE;
									bprint ("Sudden Death Expired. Blue Team wins!\n");
								}																																							
								else
								{
									if (sudden_death_timelimit < time)
									{
										if (loophack == 1) // Sleeper: Only spit this out once.
										{
											sudden_death_round_count++;
											if (sudden_death_round_count <= cvar("sudden_death_max_rounds")) 
											{
												if (sudden_death_round_count < cvar("sudden_death_max_rounds")) bprint ("Sudden Death! (Round ", ftos(sudden_death_round_count), ")\n");
												else bprint ("Sudden Death! (Final Round)\n");
											}
										}
										sudden_death_timelimit = time + (cvar("sudden_death_timelimit") * 60);
									}
								}
							}																	
						}
						else // Sleeper: Everybody was pussyfooting around or didn't play aggressive enough to break the tie.
						{
							sudden_death_engaged = FALSE;
							endgame = TRUE;
							if (deathmatch == DM_DUEL || deathmatch == DM_FFA) bprint ("Sudden Death Expired. Match Is Tied!\n");
							else if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF) bprint ("Sudden Death Expired. Teams Are Tied!\n");
						}
					}					
				}
			}				
		}
	}
			
	if (cvar("sudden_death_style") == 2) // Sleeper: Continue match until a player gets the higher frags until the overtime runs out.
	{
		if (sudden_death_engaged == TRUE && sudden_death_timelimit < time) // Sleeper: End game when frags/score is unbalanced by the time overtime expires, or when max overtime rounds are reached.
		{
			for (leadingplayer = find (world, classname, "player"); leadingplayer; leadingplayer = find (leadingplayer, classname, "player")) // Self
			{
				for (losingplayer = find (world, classname, "player"); losingplayer; losingplayer = find (losingplayer, classname, "player")) // Other
				{	
					if (leadingplayer != losingplayer)
					{
						if (loophack <= 0) loophack++;
						else loophack = 0;
							
						if (sudden_death_round_count <= cvar("sudden_death_max_rounds"))
						{
							if (deathmatch == DM_DUEL || deathmatch == DM_FFA)
							{											
								if (leadingplayer.frags > losingplayer.frags)
								{
									sudden_death_engaged = FALSE;
									endgame = TRUE;
									bprint ("Sudden Death Expired. ", leadingplayer.netname, " wins!\n");
								}																														
								else 
								{
									if (loophack == 1) // Sleeper: Only spit this out once.
									{
										sudden_death_round_count++;
										if (sudden_death_round_count <= cvar("sudden_death_max_rounds")) 
										{
											if (sudden_death_round_count < cvar("sudden_death_max_rounds")) bprint ("Sudden Death! (Round ", ftos(sudden_death_round_count), ")\n");
											else bprint ("Sudden Death! (Final Round)\n");
										}
									}
									sudden_death_timelimit = time + (cvar("sudden_death_timelimit") * 60);
								}
							}
							else if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF) 
							{											
								if (TeamScore[TEAM_RED_4] > TeamScore[TEAM_BLUE_13])
								{
									sudden_death_engaged = FALSE;
									endgame = TRUE;
									bprint ("Sudden Death Expired. ", leadingplayer.netname, " wins!\n");
								}
								else if (TeamScore[TEAM_BLUE_13] > TeamScore[TEAM_RED_4])
								{
									sudden_death_engaged = FALSE;
									endgame = TRUE;
									bprint ("Sudden Death Expired. ", leadingplayer.netname, " wins!\n");
								}																																							
								else
								{
									if (loophack == 1) // Sleeper: Only spit this out once.
									{
										sudden_death_round_count++;
										if (sudden_death_round_count <= cvar("sudden_death_max_rounds")) 
										{
											if (sudden_death_round_count < cvar("sudden_death_max_rounds")) bprint ("Sudden Death! (Round ", ftos(sudden_death_round_count), ")\n");
											else bprint ("Sudden Death! (Final Round)\n");
										}
									}
									sudden_death_timelimit = time + (cvar("sudden_death_timelimit") * 60);
								}
							}									
						}
						else // Sleeper: Everybody was pussy footing around or didn't play aggressive enough to break the tie.
						{
							sudden_death_engaged = FALSE;
							endgame = TRUE;
							if (deathmatch == DM_DUEL || deathmatch == DM_FFA) bprint ("Sudden Death Expired. Match Is Tied!\n");
							else if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF) bprint ("Sudden Death Expired. Teams Are Tied!\n");
						}
					}					
				}
			}				
		}
	}
};	