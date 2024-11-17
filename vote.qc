string() votesneededtostring;
void() MapNotFound;
void() RemoveVote;
void() RemoveVote2;

void(entity te) dremove = 
{
	if (te == world)
	{
		dprint ("***BUG BUG BUG BUG BUG BUG BUG BUG BUG BUG***\n");
		dprint ("WORLD has nearly been removed. Don't worry.\n");
		dprint ("***BUG BUG BUG BUG BUG BUG BUG BUG BUG BUG***\n");
		return;
	}
	remove (te);
};

float allowvote_horde_flag;

void() voteyes = 
{
	if (votestarted == 0)
	{
		sprint (self, "\nA vote hasn't been casted. Type \"mapvote_info\" in console for mapvoting info\n");
		return;
	}
	if (self.has_voted == 1)
	{
		sprint (self, "\nYou've already voted!\n");
		return;
	}
	if (self.spectator == 1)
	{
		sprint (self, "\nYou must be in the game to agree on a vote!\n");
		return;
	}
/*	
	if (!cvar("developer"))
	{
		if (self.vote_wait > time)
		{
			sprint (self, "\nWait ", ftos(floor(self.vote_wait - time)), " seconds before casting a vote.\n");																																																																																		
			return;
		}
	}
*/
	else
	{
		themap = infokey (world, "themap");						
		if (infokey(world, "fteserver") == "1" || infokey(world, "fteserver") == "on")
			themap = strzone (themap);		
		
		if (themap == "Gametype: Duel")
			themap = "Duel";
		else if (themap == "Gametype: Free For All")
			themap = "Free For All";
		else if (themap == "Gametype: Team Deathmatch")
			themap = "Team Deathmatch";
		else if (themap == "Gametype: Capture The Flag")
			themap = "Capture The Flag";
		else if (themap == "Gametype: One Flag CTF")
			themap = "One Flag CTF";
		/*else if (themap == "Gametype: Instagib Duel")
			themap = "Instagib Duel";
		else if (themap == "Gametype: Instagib Free For All")
			themap = "Instagib Free For All";
		else if (themap == "Gametype: Railwarz Free For All")
			themap = "Railwarz Free For All";*/
					
		self.has_voted = 1;
				
		bprint ("\n", self.netname, " has agreed on ");
		if (themap == "id1" || themap == "hipnotic" || themap == "rogue" || themap == "dopa" || themap == "mg1") bprint ("Campaign ");
		else if (themap == "horde") bprint ("Horde Mode ");
		else if (themap == "Duel" || 
			 themap == "Free For All" || 
			 themap == "Team Deathmatch" || 
			 themap == "Capture The Flag" || 
			 themap == "One Flag CTF" /*||
			 themap == "Instagib Duel" || 
			 themap == "Instagib Free For All" || 
			 themap == "Railwarz Free For All"*/)
			bprint ("the Gametype ");
		else bprint ("the Map ");	
		bprint ("Vote\n");
		
		num_votes += 1;
		if (num_votes > (num_players * 0.5))
		{	
			initial_vote = 1;
			self.has_voted = 0;
							
			local entity head = nextent (world);
			while (head != world)
			{
				if (head.classname == "player") stuffcmd (head, "play misc/runekey.wav\n");
				head = nextent (head); 
			}
			
			if (themap == "Duel")
				Gametype_Duel_Settings ();
			else if (themap == "Free For All")
				Gametype_FFA_Settings ();
			else if (themap == "Team Deathmatch")
				Gametype_TDM_Settings ();
			else if (themap == "Capture The Flag")
				Gametype_CTF_Settings ();
			else if (themap == "One Flag CTF")
				Gametype_OneFlagCTF_Settings ();
//			else if (themap == "Instagib Duel")
//				Gametype_Instagib_Duel_Settings ();
//			else if (themap == "Instagib Free For All")
//				Gametype_Instagib_FFA_Settings ();
//			else if (themap == "Railwarz Free For All")
//				Gametype_Railwarz_FFA_Settings ();
			else if (themap == "Quake: The Offering Campaign" ||
			    themap == "Quake: Mission Pack #1: Scourge of Armagon Campaign" ||
			    themap == "Quake: Mission Pack #2: Dissolution of Eternity Campaign" || 
			    themap == "Quake: Mission Pack #3: Dimension Of The Past Campaign" || 
			    themap == "Quake: Mission Pack #4: Dimension Of The Machine Campaign") Gametype_Reignited_Coop_Settings ();			
			
			if (themap == "Quake: The Offering Campaign" ||
			    themap == "Quake: Mission Pack #1: Scourge of Armagon Campaign" ||
			    themap == "Quake: Mission Pack #2: Dissolution of Eternity Campaign" || 
			    themap == "Quake: Mission Pack #3: Dimension Of The Past Campaign" || 
			    themap == "Quake: Mission Pack #4: Dimension Of The Machine Campaign") bprint ("\nCampaign Vote Successful ");
			else if (themap == "Horde Mode") bprint ("\nHorde Mode Vote Successful ");
			
			else if (themap == "Duel" ||
				 themap == "Free For All" ||
				 themap == "Team Deathmatch" ||
				 themap == "Capture The Flag" ||
				 themap == "One Flag CTF" /* ||
				 themap == "Instagib Duel" ||
				 themap == "Instagib Free For All" ||
				 themap == "Railwarz Free For All"*/)
				 bprint ("Gametype Vote Successful ");
			
			else bprint ("\nMap Vote Successful ");
			
			if (themap == "Quake: The Offering Campaign" || 
			    themap == "Quake: Mission Pack #1: Scourge of Armagon Campaign" || 
			    themap == "Quake: Mission Pack #2: Dissolution of Eternity Campaign" || 
			    themap == "Quake: Mission Pack #3: Dimension Of The Past Campaign" || 
			    themap == "Quake: Mission Pack #4: Dimension Of The Machine Campaign") 
				bprint ("Launching the ", themap, "...\n");
			else if (themap == "Horde Mode") bprint ("Starting ", themap, "...\n");	
			
			else if (themap == "Duel" ||
				 themap == "Free For All" ||
				 themap == "Team Deathmatch" ||
				 themap == "Capture The Flag" ||
				 themap == "One Flag CTF" /* ||
				 themap == "Instagib Duel" ||
				 themap == "Instagib Free For All" ||
				 themap == "Railwarz Free For All"*/) bprint ("Changing Gametype to ", themap, "...\n");
						
			else bprint ("Changing map to ", themap, "...\n");
			bprint ("\n");
				
			if (themap == "Quake: The Offering Campaign") themap = "start";
			else if (themap == "Quake: Mission Pack #1: Scourge of Armagon Campaign") themap = "hipstart";
			else if (themap == "Quake: Mission Pack #2: Dissolution of Eternity Campaign") themap = "rstart";
			else if (themap == "Quake: Mission Pack #3: Dimension Of The Past Campaign") themap = "e5start";					
			else if (themap == "Quake: Mission Pack #4: Dimension Of The Machine Campaign") themap = "mgstart";
			else if (themap == "Horde Mode") themap = "horde1";
			
			else if (themap == "Duel") themap = "dm4";
			else if (themap == "Free For All") themap = "dm2";
			else if (themap == "Team Deathmatch") themap = "dm2";
			else if (themap == "Capture The Flag") themap = "ctf1";
			else if (themap == "One Flag CTF") themap = "ctf1";
			/*else if (themap == "Instagib Duel") themap = "dm4";
			else if (themap == "Instagib Free For All") themap = "dm7";
			else if (themap == "Railwarz Free For All") themap = "dm7";*/
				
//			changelevel (themap); // Changed for map error compatability reasons
			
//			Change_Settings (themap);

			localcmd ("changelevel ");
			localcmd (themap);
			localcmd ("\n");						
			newmis = spawn ();
			newmis.classname = "timer";
			newmis.nextthink = time + 2;
			newmis.think = MapNotFound;
			if (infokey(world, "fteserver") == "1" || infokey(world, "fteserver") == "on")
				strunzone (themap);							
			return;
		}
		local string votesneeded = votesneededtostring ();
		local string thecampaign;	
		if (votesneeded == "1") 
		{
			themap = infokey (world, "themap");
			
			if (themap == "Quake: The Offering Campaign") thecampaign = "id1";
			else if (themap == "Quake: Mission Pack #1: Scourge of Armagon Campaign") thecampaign = "hipnotic";
			else if (themap == "Quake: Mission Pack #2: Dissolution of Eternity Campaign") thecampaign = "rogue";
			else if (themap == "Quake: Mission Pack #3: Dimension Of The Past Campaign") thecampaign = "dopa";
			else if (themap == "Quake: Mission Pack #4: Dimension Of The Machine Campaign") thecampaign = "mg1";
			
			if (thecampaign) bprint ("", votesneeded, " more vote needed to launch ", thecampaign, "\n");
			else bprint ("", votesneeded, " more vote needed for ", themap, "\n");
		}			
		else 
		{
			themap = infokey (world, "themap");
			
			if (themap == "Quake: The Offering Campaign") thecampaign = "id1";
			else if (themap == "Quake: Mission Pack #1: Scourge of Armagon Campaign") thecampaign = "hipnotic";
			else if (themap == "Quake: Mission Pack #2: Dissolution of Eternity Campaign") thecampaign = "rogue";
			else if (themap == "Quake: Mission Pack #3: Dimension Of The Past Campaign") thecampaign = "dopa";
			else if (themap == "Quake: Mission Pack #4: Dimension Of The Machine Campaign") thecampaign = "mg1";
			
			if (thecampaign) bprint ("", votesneeded, " more votes needed to launch ", thecampaign, "\n");
			else bprint ("", votesneeded, " more votes needed for ", themap, "\n");
		}		
	}
};

void(string put) main_vote_start = 
{
	local string id1      = "id1",
		     hipnotic = "hipnotic",
		     rogue    = "rogue",
		     dopa     = "dopa",
		     mg1      = "mg1",
		     horde    = "horde";						  
		       
	if (self.has_voted == 1)
	{
		sprint (self, "\nYou've already voted!\n");
		return;
	}
	if (self.startedvote == 1)
	{
		sprint (self, "\nYou can only initiate one vote per game!\n");
		return;
	}
	if (!cvar("developer"))
	{
		if (self.vote_wait > time + 1)
		{
			sprint (self, "\nWait ", ftos(floor(self.vote_wait - time)), " seconds before casting a vote.\n");																																																																																		
			return;
		}
	}
	if (self.spectator == 1)
	{
		sprint (self, "\nYou must be in the game to vote!\n");
		return;
	}	
	if (votestarted == 1)
	{
		sprint (self, "A vote is already in progress. Type \"cmd voteyes\" in console or wait until the vote ends.\n");
		return;
	}
	if (!deathmatch) // Wall off campaign maps from being voted on, unless it's deathmatch.
	{
		if (put == "start" || put == "e1m1" || put == "e1m2" || put == "e1m3" || put == "e1m4" || put == "e1m5" || put == "e1m6" || put == "e1m7" || put == "e1m8" ||
		    put == "e2m1" || put == "e2m2" || put == "e2m3" || put == "e2m4" || put == "e2m4_qe" || put == "e2m5" || put == "e2m6" || put == "e2m6_qe" || put == "e2m7" ||
		    put == "e3m1" || put == "e3m2" || put == "e3m3" || put == "e3m4" || put == "e3m5" || put == "e3m6" || put == "e3m7" || 
		    put == "e4m1" || put == "e4m2" || put == "e4m3" || put == "e4m4" || put == "e4m5" || put == "e4m6" || put == "e4m7" ||  put == "e4m8" || 
		    put == "end" || put == "dm1sp" || put == "dm2sp" || put == "dm3sp" || put == "dm4sp" || put == "dm5sp" || put == "dm6sp" || put == "dm7sp" || put == "dm8sp" || 
		    put == "hipstart" || put == "hip1m1" || put == "hip1m2" || put == "hip1m3" || put == "hip1m4" || put == "hip1m5" ||
	            put == "hip2m1" || put == "hip2m2" || put == "hip2m3" || put == "hip2m4" || put == "hip2m5" || put == "hip2m6" ||
	            put == "hip3m1" || put == "hip3m2" || put == "hip3m3" || put == "hip3m4" || put == "hipend" || put == "hipdm1" || 
	            put == "rstart" || put == "r1m1" || put == "r1m2" || put == "r1m3" || put == "r1m4" || put == "r1m5" || put == "r1m6" || put == "r1m7" || 
	            put == "r2m1" || put == "r2m2" || put == "r2m3" || put == "r2m4" || put == "r2m5" || put == "r2m6" || put == "r2m7" || put == "rend" ||
	            put == "e5start" || put == "e5m1" || put == "e5m2" || put == "e5m3" || put == "e5m4" || put == "e5m5" || put == "e5m6" || put == "e5m7" || 
		    put == "e5end" || put == "e5sm1" || put == "e5sm2" ||
		    put == "mgstart" || put == "hub" || put == "mge1m1" || put == "mge1m2" || put == "mge1m3" ||
		    put == "mge2m1" || put == "mge2m2" || 
		    put == "mge3m1" || put == "mge3m2" ||
		    put == "mge4m1" || put == "mge4m2" || put == "mge4m2b" || put == "mge4arena" ||
		    put == "mge5m1" || put == "mge5m2" ||
		    put == "mgend")
		{
			sprint (self, "\nYou can't cast a Map Vote on a campaign map. Use \"cmd vote campaign [CAMPAIGNNAME]\" instead. (i.e.: id1, hipnotic, rogue, dopa, or mg1)\n");
			return;
		}
		if (put == "dm1" || put == "dm2" || put == "dm3" || put == "dm4" || put == "dm5" || put == "dm6" || put == "dm7" || put == "dm8" || put == "aerowalk")
		{
			sprint (self, "\nYou can't cast a Map Vote on a deathmatch map in campaign mode. Use \"cmd vote gametype [DEATHMATCHNAME]\" first. (i.e.: DUEL, FFA, TDM, CTF, OneFlagCTF)\n");
			return;
		}		
		if (!allowvote_horde_flag)
		{
			if (put == "horde1" || put == "horde2" || put == "horde3" || put == "horde4" || put == "horde5" || put == "horde6" || put == "horde7")
			{
				sprint (self, "\nYou can't cast a regular Map Vote on a horde map. Use \"cmd vote hordemap [HORDEMAPNAME]\" instead.\n");
				return;
			}
		}		
 	}	
	if (mapname == put)
	{
		sprint (self, "\nYou can't cast a Map Vote on the current map...\n");
		return;	
	}		
	else
	{
		string mapdispfix;
		votestarted = 1;
		themap = put;
		
		localcmd ("localinfo themap ");
		
		if (put == id1) localcmd ("\"Quake: The Offering Campaign\"");
		else if (put == hipnotic) localcmd ("\"Quake: Mission Pack #1: Scourge of Armagon Campaign\"");
		else if (put == rogue) localcmd ("\"Quake: Mission Pack #2: Dissolution of Eternity Campaign\"");	
		else if (put == dopa) localcmd ("\"Quake: Mission Pack #3: Dimension Of The Past Campaign\"");	
		else if (put == mg1) localcmd ("\"Quake: Mission Pack #4: Dimension Of The Machine Campaign\"");			
		else if (put == horde) localcmd ("\"Horde Mode\"");
		
		else if (put == "duel" || put == "1v1" || put == "tourney" || put == "tournament") localcmd ("\"Gametype: Duel\"");
		else if (put == "ffa" || put == "dm" || put == "deathmatch" || put == "free for all") localcmd ("\"Gametype: Free For All\"");
		else if (put == "tdm" || put == "team deathmatch") localcmd ("\"Gametype: Team Deathmatch\"");
		else if (put == "ctf" || put == "capture the flag") localcmd ("\"Gametype: Capture The Flag\"");
		else if (put == "oneflagctf" || put == "one flag ctf" || put == "one flag capture the flag" || put == "1 flag capture the flag" || put == "1flagctf" || put == "1fctf") localcmd ("\"Gametype: One Flag CTF\"");
		/*else if (put == "iduel" || put == "instagib duel" || put == "duel instagib" || put == "1v1 instagib" || put == "instagib 1v1" || put == "instagib tourney" || put == "tourney instagib" || put == "instagib tournament" || put == "tournament instagib") localcmd ("\"Gametype: Instagib Duel\"");
		else if (put == "iffa" || put == "instagib free for all" || put == "free for all instagib" || put == "idm" || put == "instagib deathmatch" || put == "deathmatch instagib") localcmd ("\"Gametype: Instagib Free For All\"");
		else if (put == "rwzffa" || put == "railwarz free for all" || put == "free for all railwarz" || put == "rwzdm" || put == "railwarz deathmatch" || put == "deathmatch railwarz") localcmd ("\"Gametype: Railwarz Free For All\"");*/
		
		else localcmd (put);		
		localcmd ("\n");
		
		if (put == id1 || put == hipnotic || put == rogue || put == dopa || put == mg1) bprint ("\n", self.netname, " casted a Campaign Vote to launch the ");
		else if (put == horde) bprint ("\n", self.netname, " casted a vote to start ");
		else if (put == "duel" || put == "1v1" || put == "tourney" || put == "tournament" ||
			 put == "ffa" || put == "dm" || put == "deathmatch" || put == "free for all" ||
			 put == "tdm" || put == "team deathmatch" || 
			 put == "ctf" || put == "capture the flag" ||
			 put == "oneflagctf" || put == "one flag ctf" || put == "one flag capture the flag" || put == "1 flag capture the flag" || put == "1flagctf" || put == "1fctf" /*||
			 put == "iduel" || put == "instagib duel" || put == "duel instagib" || put == "1v1 instagib" || put == "instagib 1v1" || put == "instagib tourney" || put == "tourney instagib" || put == "instagib tournament" || put == "tournament instagib" ||
			 put == "iffa" || put == "instagib free for all" || put == "free for all instagib" || put == "idm" || put == "instagib deathmatch" || put == "deathmatch instagib" ||
			 put == "rwzffa" || put == "railwarz free for all" || put == "free for all railwarz" || put == "rwzdm" || put == "railwarz deathmatch" || put == "deathmatch railwarz"*/)
			 bprint ("\n", self.netname, " casted a vote to play ");
	
		else bprint ("\n", self.netname, " casted a Map Vote for ");	
		 	
		if (put == id1) bprint ("Quake: The Offering Campaign");
		else if (put == hipnotic) bprint ("Quake: Mission Pack #1: Scourge of Armagon Campaign");
		else if (put == rogue) bprint ("Quake: Mission Pack #2: Dissolution of Eternity Campaign");
		else if (put == dopa) bprint ("Quake: Mission Pack #3: Dimension Of The Past Campaign");
		else if (put == mg1) bprint ("Quake: Mission Pack #4: Dimension Of The Machine Campaign");	
		else if (put == horde) bprint ("Horde Mode");
		
		else if (put == "duel" || put == "1v1" || put == "tourney" || put == "tournament") bprint ("Duel");
		else if (put == "ffa" || put == "dm" || put == "deathmatch" || put == "free for all") bprint ("Free For All");
		else if (put == "tdm" || put == "team deathmatch") bprint ("Team Deathmatch");
		else if (put == "ctf" || put == "capture the flag") bprint ("Capture The Flag");
		else if (put == "oneflagctf" || put == "one flag ctf" || put == "one flag capture the flag" || put == "1 flag capture the flag" || put == "1flagctf" || put == "1fctf") bprint ("One Flag CTF");
		/*else if (put == "iduel" || put == "instagib duel" || put == "duel instagib" || put == "1v1 instagib" || put == "instagib 1v1" || put == "instagib tourney" || put == "tourney instagib" || put == "instagib tournament" || put == "tournament instagib") bprint ("Instagib Duel");
		else if (put == "iffa" || put == "instagib free for all" || put == "free for all instagib" || put == "idm" || put == "instagib deathmatch" || put == "deathmatch instagib") bprint ("Instagib Free For All");
		else if (put == "rwzffa" || put == "railwarz free for all" || put == "free for all railwarz" || put == "rwzdm" || put == "railwarz deathmatch" || put == "deathmatch railwarz") bprint ("Railwarz Free For All");*/
			
		else bprint (put);
			
		if (put == id1) mapdispfix = "start";
		else if (put == hipnotic) mapdispfix = "hipstart";
		else if (put == rogue) mapdispfix = "rstart";
		else if (put == dopa) mapdispfix = "e5start";
		else if (put == mg1) mapdispfix = "mgstart";
		else if (put == horde) mapdispfix = "horde1";
		
		else if (put == "duel" || put == "1v1" || put == "tourney" || put == "tournament") mapdispfix = "dm4";
		else if (put == "ffa" || put == "dm" || put == "deathmatch" || put == "free for all") mapdispfix = "dm2";
		else if (put == "tdm" || put == "team deathmatch") mapdispfix = "dm2";
		else if (put == "ctf" || put == "capture the flag") mapdispfix = "ctf1";
		else if (put == "oneflagctf" || put == "one flag ctf" || put == "one flag capture the flag" || put == "1 flag capture the flag" || put == "1flagctf" || put == "1fctf") mapdispfix = "ctf1";
		/*else if (put == "iduel" || put == "instagib duel" || put == "duel instagib" || put == "1v1 instagib" || put == "instagib 1v1" || put == "instagib tourney" || put == "tourney instagib" || put == "instagib tournament" || put == "tournament instagib") mapdispfix = "dm4";
		else if (put == "iffa" || put == "instagib free for all" || put == "free for all instagib" || put == "idm" || put == "instagib deathmatch" || put == "deathmatch instagib") mapdispfix = "dm7";
		else if (put == "rwzffa" || put == "railwarz free for all" || put == "free for all railwarz" || put == "rwzdm" || put == "railwarz deathmatch" || put == "deathmatch railwarz") mapdispfix = "dm7";*/
		 
		else mapdispfix = put;
			
		if (num_players > 1) bprint (" - type \"cmd voteyes\" in console to agree. If more than 50% is not agreed before one minute, the vote will end.\n");
//		sound (world, 4, "misc/runekey.wav", 1, 0);
// Since the sound would not play for everyone in the game with the old sound code, I make it play the sound
// individually for all players
		local entity head = nextent (world);
		while (head != world)
		{
			if (head.classname == "player") stuffcmd (head, "play misc/runekey.wav\n");
			head = nextent (head); 
		}
		num_votes += 1;
		self.has_voted = 1;
//		self.startedvote = 1;
		self.vote_wait = time + 90;
		RemoveVote ();
		if (num_votes > num_players * 0.6)
		{
			self.has_voted = 0;
			
			if (put == "duel" || put == "1v1" || put == "tourney" || put == "tournament")
				Gametype_Duel_Settings ();
			else if (put == "ffa" || put == "dm" || put == "deathmatch" || put == "free for all")
				Gametype_FFA_Settings ();
			else if (put == "tdm" || put == "team deathmatch")
				Gametype_TDM_Settings ();
			else if (put == "ctf" || put == "capture the flag")
				Gametype_Duel_Settings ();
			else if (put == "oneflagctf" || put == "one flag ctf" || put == "one flag capture the flag" || put == "1 flag capture the flag" || put == "1flagctf" || put == "1fctf")
				Gametype_OneFlagCTF_Settings ();
			/*else if (put == "iduel" || put == "instagib duel" || put == "duel instagib" || put == "1v1 instagib" || put == "instagib 1v1" || put == "instagib tourney" || put == "tourney instagib" || put == "instagib tournament" || put == "tournament instagib")
				Gametype_Instagib_Duel_Settings ();
			else if (put == "iffa" || put == "instagib free for all" || put == "free for all instagib" || put == "idm" || put == "instagib deathmatch" || put == "deathmatch instagib")
				Gametype_Instagib_FFA_Settings ();
			else if (put == "rwzffa" || put == "railwarz free for all" || put == "free for all railwarz" || put == "rwzdm" || put == "railwarz deathmatch" || put == "deathmatch railwarz")
				Gametype_Railwarz_FFA_Settings ();*/
			else if (put == id1 || put == hipnotic || put == rogue || put == dopa || put == mg1 || put == horde) Gametype_Reignited_Coop_Settings ();
						
			bprint ("\n");
			if (put == id1 || put == hipnotic || put == rogue || put == dopa || put == mg1) 
				bprint ("\nCampaign Vote Successful ");
			else if (put == horde)
				bprint ("\nHorde Mode Vote Successful ");
			else if (put == "duel" || put == "1v1" || put == "tourney" || put == "tournament" || 
				 put == "ffa" || put == "dm" || put == "deathmatch" || put == "free for fall" || 
				 put == "tdm" || put == "team deathmatch" || 
				 put == "ctf" || put == "capture the flag" || 
				 put == "oneflagctf" || put == "one flag ctf" || put == "one flag capture the flag" || put == "1 flag capture the flag" || put == "1flagctf" || put == "1fctf" /* || 
				 put == "iduel" || put == "instagib duel" || put == "duel instagib" || put == "1v1 instagib" || put == "instagib 1v1" || put == "instagib tourney" || put == "tourney instagib" || put == "instagib tournament" || put == "tournament instagib" || 
				 put == "iffa" || put == "instagib free for all" || put == "free for all instagib" || put == "idm" || put == "instagib deathmatch" || put == "deathmatch instagib" || 
				 put == "rwzffa" || put == "railwarz free for all" || put == "free for all railwarz" || put == "rwzdm" || put == "railwarz deathmatch" || put == "deathmatch railwarz"*/)
				bprint ("\nGametype Vote Successful ");
			else bprint ("\nMap Vote Successful ");
			
			if (put == id1) 
				bprint ("Launching the Quake: The Offering Campaign...\n");
			else if (put == hipnotic)
				bprint ("Launching the Quake: Mission Pack #1: Scourge of Armagon Campaign...\n");
			else if (put == rogue)
				bprint ("Launching the Quake: Mission Pack #2: Dissolution of Eternity Campaign...\n");
			else if (put == dopa) 
				bprint ("Launching the Quake: Mission Pack #3: Dimension Of The Past Campaign...\n");
			else if (put == mg1) 
				bprint ("Launching the Quake: Mission Pack #4: Dimension Of The Machine Campaign...\n");
			else if (put == horde) 
				bprint ("\nStarting ", put, "...\n");
			
			else if (put == "duel" || put == "1v1" || put == "tourney" || put == "tournament" ||
				 put == "ffa" || put == "dm" || put == "deathmatch" || put == "free for all" ||
				 put == "tdm" || put == "team deathmatch" || 
				 put == "ctf" || put == "capture the flag" ||
				 put == "oneflagctf" || put == "one flag ctf" || put == "one flag capture the flag" || put == "1 flag capture the flag" || put == "1flagctf" || put == "1fctf" /* || 
				 put == "iduel" || put == "instagib duel" || put == "duel instagib" || put == "1v1 instagib" || put == "instagib 1v1" || put == "instagib tourney" || put == "tourney instagib" || put == "instagib tournament" || put == "tournament instagib" || 
				 put == "iffa" || put == "instagib free for all" || put == "free for all instagib" || put == "idm" || put == "instagib deathmatch" || put == "deathmatch instagib" ||
				 put == "rwzffa" || put == "railwarz free for all" || put == "free for all railwarz" || put == "rwzdm" || put == "railwarz deathmatch" || put == "deathmatch railwarz"*/)
				bprint ("Changing Gametype to ", put, "...\n");
							
			else bprint ("Changing map to ", put, "...\n");
			bprint ("\n");
						
						
//			changelevel (put); // just wasnt working after map fails for some reason..

			localcmd ("changelevel ");
			
			if (put == id1) localcmd ("start");
			else if (put == hipnotic) localcmd ("hipstart");
			else if (put == rogue) localcmd ("rstart");
			else if (put == dopa) localcmd ("e5start");
			else if (put == mg1) localcmd ("mgstart");	
			else if (put == horde) localcmd ("horde1");
			
			else if (put == "duel" || put == "1v1" || put == "tourney" || put == "tournament") localcmd ("dm4");
			else if (put == "ffa" || put == "dm" || put == "deathmatch" || put == "free for all") localcmd ("dm2");
			else if (put == "tdm" || put == "team deathmatch") localcmd ("dm2");
			else if (put == "ctf" || put == "capture the flag") localcmd ("ctf1");
			else if	(put == "oneflagctf" || put == "one flag ctf" || put == "one flag capture the flag" || put == "1 flag capture the flag" || put == "1flagctf" || put == "1fctf") localcmd ("ctf1");
			/*else if (put == "iduel" || put == "instagib duel" || put == "duel instagib" || put == "1v1 instagib" || put == "instagib 1v1" || put == "instagib tourney" || put == "tourney instagib" || put == "instagib tournament" ||  put == "tournament instagib") localcmd ("dm4");
			else if (put == "iffa" || put == "instagib free for all" || put == "free for all instagib" || put == "idm" || put == "instagib deathmatch" || put == "deathmatch instagib") localcmd ("dm7");
			else if (put == "rwzffa" || put == "railwarz free for all" || put == "free for all railwarz" || put == "rwzdm" || put == "railwarz deathmatch" || put == "deathmatch railwarz") localcmd ("dm7");*/
			
			else localcmd (put);
			localcmd ("\n");

			newmis = spawn ();
			newmis.classname = "timer";
			newmis.nextthink = time + 2;
			newmis.think = MapNotFound;
			return;
		}
		local string votesneeded = votesneededtostring ();
		if (put == horde) put = "Horde Mode";		
		if (put == id1 || put == hipnotic || put == rogue || put == dopa || put == mg1)
		{
			if (votesneeded == "1") bprint ("", votesneeded, " more vote needed to launch ", put, "\n");			
			else bprint ("", votesneeded, " more votes needed to launch ", put, "\n");
		}
		else
		{
			if (votesneeded == "1") bprint ("", votesneeded, " more vote needed for ", put, "\n");			
			else bprint ("", votesneeded, " more votes needed for ", put, "\n");
		}
		bprint ("\n");
	}
};

string() votesneededtostring =
{
	local float needed = (num_players * 0.5) - num_votes;

	// Can add as many as you want, but 32 players is usually the max any server should have.
	if (needed < 1) return ("1");
	if (needed < 2) return ("2");
	if (needed < 3) return ("3");
	if (needed < 4) return ("4");
	if (needed < 5) return ("5");
	if (needed < 6) return ("6");
	if (needed < 7) return ("7");
	if (needed < 8) return ("8");
	if (needed < 9) return ("9");
	if (needed < 10) return ("10");
	if (needed < 11) return ("11");
	if (needed < 12) return ("12");
	if (needed < 13) return ("13");
	if (needed < 14) return ("14");	
	if (needed < 15) return ("15");
	if (needed < 16) return ("16");	
	if (needed < 17) return ("17");	
	if (needed < 18) return ("18");	
	if (needed < 19) return ("19");
	if (needed < 20) return ("20");
	if (needed < 21) return ("21");	
	if (needed < 22) return ("22");	
	if (needed < 23) return ("23");	
	if (needed < 24) return ("24");
	if (needed < 25) return ("25");	
	if (needed < 26) return ("26");
	if (needed < 27) return ("27");	
	if (needed < 28) return ("28");
	if (needed < 29) return ("29");
	if (needed < 30) return ("30");	
	if (needed < 31) return ("31");	
	if (needed < 32) return ("32");																												
	if (needed >= 33) return ("over 32");
	return ("ERROR");
};

void() MapNotFound =
{
	localcmd ("say --  Map Not Found  --\n");
	nomap = 1;
	local entity finder_ent = find (world, classname, "VoteFailed");
	while (finder_ent)
	{
		if (finder_ent.classname == "VoteFailed") dremove (finder_ent);
		finder_ent = find (finder_ent, classname, "VoteFailed");
	}
	RemoveVote2 ();
	dremove (self);
};

void() RemoveVote =
{
	newmis = spawn ();
	newmis.classname = "VoteFailed";
//	newmis.classname = "timer"; // Changed to "VoteFailed"
	newmis.nextthink = time + 60;
	newmis.think = RemoveVote2;
	nomap = 0;
};

void() RemoveVote2 =
{
	localcmd ("say -- VOTE HAS FAILED --\n");

	votestarted = 0;
	num_votes = 0;
	self.startedvote = 0;
	self.vote_wait = time + 30;
	allowvote_horde_flag = 0;
	gametype_vote_style = string_null;

	local entity head = nextent (world);
	while (head != world)
	{
		if (head.classname == "player") head.has_voted = 0;
		head = nextent (head); 
	}
	return;
};

float(string mapstr) validatemap =
{
	mapstr = strcat ("maps/",mapstr);
	mapstr = strcat (mapstr,".bsp");
	
	return validatefile (mapstr);
};

void(string argument2, string cmd) Main_Vote_System = {main_vote_start (argument2);};

// This allows clients to send cmd based commands to the server.
// Useful for voting systems.
void(string cmd) SV_ParseClientCommand =
{
 	float  argc      = tokenize (cmd);
 	string command   = argv (0);
 	string argument1 = argv (1);
 	string argument2 = argv (2);
	string argument3 = argv (3); 
	string argument4 = argv (4);   
		
  	if (command == "vote") // Main voting system
 	{
 		allowvote_horde_flag = 0;
      		if (argument1 == "map") // Map Vote
      		{
			if (argument2) Main_Vote_System (argument2, cmd);
			else sprint (self, "\nTo cast a Map Vote, type \"cmd vote map [MAPNAME]\" in console. (Type mapvote_info in console for info)\n");	
		}
		else if (argument1 == "campaign") // Campaign Vote
 		{
 			gametype_vote_style = gametype_coop;
			if (argument2 == "id1" || argument2 == "hipnotic" || argument2 == "rogue" || argument2 == "dopa" || argument2 == "mg1")
				Main_Vote_System (argument2, cmd);
			else sprint (self, "\nTo cast a Campaign Vote, type \"cmd vote campaign [CAMPAIGNNAME]\" in console. (Type mapvote_info in console for info)\n");	
		}
		else if (argument1 == "hordemode") // Horde Mode Vote
		{
			allowvote_horde_flag = 1;
			if (!argument2) // Enter Horde Mode
			{
				argument2 = "horde";
				Main_Vote_System (argument2, cmd);
				argument2 = "";	
			}							
		}
		else if (argument1 == "hordemap") // Enter Horde Mode with a Map Vote
		{
			allowvote_horde_flag = 1;
			if (argument2) Main_Vote_System (argument2, cmd);
			else sprint (self, "\nTo cast a Map Vote for Horde Mode, type \"cmd vote hordemap [MAPNAME]\" in console. (Type mapvote_info in console for info)\n");	
		}
		else if (argument1 == "gametype")
		{
			if (argument2 == "duel" || argument2 == "1v1" || argument2 == "tournament" || argument2 == "tourney")
				Main_Vote_System (argument2, cmd);
			else if (argument2 == "ffa" || argument2 == "dm" || argument2 == "deathmatch" || argument2 == "free for all")	
				Main_Vote_System (argument2, cmd);
			else if (argument2 == "tdm" || argument2 == "team deathmatch")	
				Main_Vote_System (argument2, cmd);
			else if (argument2 == "ctf" || argument2 == "capture the flag")	
				Main_Vote_System (argument2, cmd);
			else if (argument2 == "oneflagctf" || argument2 == "one flag ctf" || argument2 == "one flag capture the flag" || argument2 == "1 flag capture the flag" || argument2 == "1flagctf" || argument2 == "1fctf")
				Main_Vote_System (argument2, cmd);
			/*else if (argument2 == "iduel" || argument2 == "instagib duel" || argument2 == "duel instagib" || argument2 == "1v1 instagib" || argument2 == "instagib 1v1" || argument2 == "instagib tourney" || argument2 == "tourney instagib" || argument2 == "instagib tournament" ||  argument2 == "tournament instagib")     
				Main_Vote_System (argument2, cmd);
			else if (argument2 == "iffa" || argument2 == "instagib free for all" || argument2 == "free for all instagib" || argument2 == "idm" || argument2 == "instagib deathmatch" || argument2 == "deathmatch instagib")
				Main_Vote_System (argument2, cmd);
			else if (argument2 == "itdm" || argument2 == "instagib team deathmatch" || argument2 == "team deathmatch instagib")	
				Main_Vote_System (argument2, cmd);	
			else if (argument2 == "ictf" || argument2 == "instagib capture the flag" || argument2 == "capture the flag instagib")	
				Main_Vote_System (argument2, cmd);
			else if (argument2 == "oneflagictf" || argument2 == "one flag ictf" || argument2 == "instagib one flag ctf" || argument2 == "one flag ctf instagib" || argument2 == "instagib one flag capture the flag" || argument2 == "one flag capture the flag instagib" || argument2 == "instagib 1 flag capture the flag" || argument2 == "1 flag capture the flag instagib" || argument2 == "1flagictf" || argument2 == "1fictf")
				Main_Vote_System (argument2, cmd);
			else if (argument2 == "rwzduel" || argument2 == "railwarz duel" || argument2 == "duel railwarz" || argument2 == "1v1 railwarz" || argument2 == "railwarz 1v1" || argument2 == "railwarz tourney" || argument2 == "tourney railwarz" || argument2 == "railwarz tournament" ||  argument2 == "tournament railwarz")     
				Main_Vote_System (argument2, cmd);
			else if (argument2 == "rwzffa" || argument2 == "railwarz free for all" || argument2 == "free for all railwarz" || argument2 == "rwzdm" || argument2 == "railwarz deathmatch" || argument2 == "deathmatch railwarz")
				Main_Vote_System (argument2, cmd);
			else if (argument2 == "rwztdm" || argument2 == "railwarz team deathmatch" || argument2 == "team deathmatch railwarz")	
				Main_Vote_System (argument2, cmd);	
			else if (argument2 == "rwzctf" || argument2 == "railwarz capture the flag" || argument2 == "capture the flag railwarz")	
				Main_Vote_System (argument2, cmd);
			else if (argument2 == "oneflagrwzctf" || argument2 == "one flag rwzctf" || argument2 == "railwarz one flag ctf" || argument2 == "one flag ctf railwarz" || argument2 == "railwarz one flag capture the flag" || argument2 == "one flag capture the flag railwarz" || argument2 == "railwarz 1 flag capture the flag" || argument2 == "1 flag capture the flag instagib" || argument2 == "1flagrwzctf" || argument2 == "1frwzctf")
				Main_Vote_System (argument2, cmd);*/														
			else sprint (self, "Invalid Gametype.\n");									
		}			
		else if (!argument1) // Missing arguments to a command
		{
			sprint (self, "\nTo cast a type of vote, you need to add one of the following to the command: \n");
			sprint (self, "\n");
			sprint (self, "* map\n* campaign\n* horde\n");
			sprint (self, "\n");
		}
		// Sleeper: Self note, this needs a "nextmap" vote for both Horde Mode and regular.
		
		// Disallowed arguments
		if (argument1 == "yes") sprint (self, "\nTo agree with a vote, type \"cmd voteyes\" in console\n");
		else if (argument1 == "no") sprint (self, "You can only agree to a vote or ignore a vote when a vote has been casted\n");
		else if (argument1 == "horde")
		{
			if (argument2) sprint (self, "\nTo enter Horde Mode, type \"cmd vote hordemode\" or type \"cmd vote hordemap [MAPNAME]\" in console.\n");
		}								
 	}
 	else if (command == "voteyes") voteyes (); // Agree to a vote 				
 	
  	// Disallowed commands
 	else if (command == "votemap") sprint (self, "\nTo cast a Map Vote, type \"cmd vote map [MAPNAME]\" in console. (Type mapvote_info in console for info)\n");
 	else if (command == "votecampaign" || command == "vote_campaign") sprint (self, "\nTo cast a Campaign Vote, type \"cmd vote campaign [CAMPAIGNNAME]\" in console. (Type mapvote_info in console for info)\n");
 	else if (command == "vote_yes" || command == "yes") sprint (self, "\nTo agree with a vote, type \"cmd voteyes\" in console\n");
 	else if (command == "voteno" || command == "vote_no" || command == "no") sprint (self, "You can only agree to a vote or ignore a vote when a vote has been casted\n");	
  	else if (command == "map") sprint (self, "Invalid Command.\n");	
 	else if (command == "campaign") sprint (self, "Invalid Command.\n");	
 	else if (command == "hordemode") sprint (self, "Invalid Command.\n");	
 	else if (command == "hordemap") sprint (self, "Invalid Command.\n");
 	else if (command == "gametype") sprint (self, "Invalid Command.\n");	
 	
	else // Send commands to the server
	{
		clientcommand (self, cmd);
		return;
	}
};	