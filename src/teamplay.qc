/*  Copyright (C) 1996-2022 id Software LLC

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    See file, 'COPYING', for details.
*/

// Rogue Teamplay Variants
// Jan'97 by ZOID <zoid@threewave.com>
// Under contract to id software for Rogue Entertainment

void(entity targ, entity inflictor, entity attacker, float damage) T_Damage;

// New entity fields
.float steam;		// selected team
.float suicide_count; // how many times has this player done something silly?
.float ctf_flags; // various flags for CTF
.float ctf_killed;	// used for base spawning
.float ctf_flagsince;	// when we picked up the flag
.float ctf_lasthurtcarrier; // when we last hurt the carrier
.float ctf_lastreturnedflag; // when we returned the flag
.float ctf_lastfraggedcarrier; // when we last fragged the carrier

// Team numbers for Coop and Single Player
float TEAM_MONSTERS   = 665; // The neighbor of the beast.
float TEAM_HUMANS_TOP = 2;   // Shirt Color
float TEAM_HUMANS     = 7;   // Pants Color

// Team numbers for Deathmatch modes
float TEAM1 	      = 5;   // color of team1 (red), note that this is self.team which is one more than the color setting, so 'color 4' is red.
float TEAM2 	      = 14;  // color of team2 (blue), note that this is self.team which is one more than the color setting, so 'color 13' is blue.
float TEAM3 	      = 1;  // color of team3 (grey) in alt CTF

entity team1_lastspawn;  // last spawn spot for team1
entity team2_lastspawn;  // last spawn spot for team2
float nextteamupdtime; // next time for a broadcast update

float CTF_CAPTURE_POINTS = 1;
float CTF_CAPTURE_BONUS = 10; // what you get for capture (Sleeper: Default is 15)
float CTF_TEAM_BONUS = 10; // what your team gets for capture
float CTF_ALT_CAPTURE_BONUS = 8; // what you get for capture
float CTF_ALT_TEAM_BONUS = 4; // what your team gets for capture
float CTF_RECOVERY_BONUS = 1; // what you get for recovery
float CTF_FLAG_BONUS = 0; // what you get for picking up enemy flag
float CTF_FRAG_CARRIER_BONUS = 2; // what you get for fragging enemy flag carrier
float CTF_FLAG_RETURN_TIME = 15; // seconds until auto return (Sleeper: For some reason this is delayed)
float CTF_CARRIER_DANGER_PROTECT_BONUS = 2; // bonus for fraggin someone
	// who has recently hurt your flag carrier
float CTF_CARRIER_PROTECT_BONUS = 5; // bonus for fraggin someone while (Sleeper: Default is 1)
	// either you or your target are near your flag carrier
float CTF_FLAG_DEFENSE_BONUS = 5; // bonus for fraggin someone while (Sleeper: Default is 1)
	// either you or your target are near your flag
float CTF_RETURN_FLAG_ASSIST_BONUS = 5; // awarded for returning a flag that causes a (Sleeper: Default is 1)
	// capture to happen almost immediately
float CTF_FRAG_CARRIER_ASSIST_BONUS = 5; // award for fragging a flag carrier if a (Sleeper: Default is 2)
	// capture happens almost immediately
float CTF_TARGET_PROTECT_RADIUS = 400; // the radius around an object being
	// defended where a target will be worth extra frags
float CTF_ATTACKER_PROTECT_RADIUS = 400; // the radius around an object being
	// defended where an attacker will get extra frags when making kills
float CTF_CARRIER_DANGER_PROTECT_TIMEOUT = 4;
float CTF_CARRIER_FLAG_SINCE_TIMEOUT = 2;
float CTF_FRAG_CARRIER_ASSIST_TIMEOUT = 6;
float CTF_RETURN_FLAG_ASSIST_TIMEOUT = 4;
float CTF_UPDATE_TIME = 120;

// CTF flags
float CTF_FLAG_FLAG	   = 1;	// player has flag in one flag mode
float CTF_FLAG_TEAM1	   = 1;	// player has team1's flag
float CTF_FLAG_TEAM2	   = 2;	// player has team2's flag
float CTF_FLAG_STUFF_COLOR = 4;	// gotta stuff his color

// flag status used in cnt field of flag
float FLAG_AT_BASE = 0;
float FLAG_CARRIED = 1;
float FLAG_DROPPED = 2;

// Prototypes
float() W_BestWeapon;
void() W_SetCurrentAmmo;
void() bound_other_ammo;
void(float o, float n) Deathmatch_Weapon;
void() BackpackTouch;
void(entity comboOwner) EnableComboWeapons;

// Return a name for the color of a team
string(float Team) GetTeamColor =
{
	     if (Team == 1)  return ("White");
	else if (Team == 2)  return ("Brown");
	else if (Team == 3)  return ("Light blue");
	else if (Team == 4)  return ("Green");
	else if (Team == 5)  return ("Red");
	else if (Team == 6)  return ("Olive");
	else if (Team == 7)  return ("Orange");
	else if (Team == 8)  return ("Peech");
	else if (Team == 9)  return ("Purple");
	else if (Team == 10) return ("Majenta");
	else if (Team == 11) return ("Grey");
	else if (Team == 12) return ("Aqua");
	else if (Team == 13) return ("Yellow");
	else if (Team == 14) return ("Blue");
	return "Unknown";
};

string(float Team) GetCTFTeam =
{
	if (cvar("deathmatch") >= DM_TDM && cvar("deathmatch") <= DM_OneFlagCTF && !cvar("coop")) // Playing with Teammates
	{
		     if (Team == TEAM1) return "RED";
		else if (Team == TEAM2) return "BLUE";
		else if (Team == TEAM3) return "GREY";
	}
	if (cvar("coop") && !cvar("deathmatch")) // Playing Co-operative
	{
		     if (Team == TEAM_HUMANS)   return "HUMANS";
		else if (Team == TEAM_MONSTERS) return "MONSTERS";
	}
	if (!cvar("coop") && !cvar("deathmatch")) // Playing Single Player
	{
		if (Team == TEAM_HUMANS) return "RANGER";
	}	
	return "UNKNOWN";
};

/*
================
TeamArmorDam

Return TRUE if the target's armor can take damage from this attacker.
================
*/

float(entity targ, entity inflictor, entity attacker, float damage) TeamArmorDam =
{
	if (teamplay <= TEAM_FF_DISABLED) return TRUE;	// PGM bug? fix
	
	if (teamplay == TEAM_FF_NO_ARMOR_DMG || teamplay == TEAM_FF_NO_HEALTH_ARMOR_DMG)
	{
		// Armor is protected
		if (attacker.steam == targ.steam && attacker != targ) return FALSE;
	}	
/*
	// teamplay modes 4,5,6 protect armor
	if ((teamplay == TEAM_CTF || teamplay == TEAM_CTF_ONEFLAG || teamplay == TEAM_CTF_ALT) && attacker.steam == targ.steam && attacker != targ && !(cvar("gamecfg") & GAMECFG_TEAM_ARMOR_DMG)) 
	{
		// Armor is protected
		return FALSE;
	}
*/		
	return TRUE;
};

/*
================
TeamHealthDam

Return TRUE if the target can take health damage from this attacker.
================
*/

float(entity targ, entity inflictor, entity attacker, float damage) TeamHealthDam =
{
	if (teamplay <= TEAM_FF_DISABLED) return TRUE;
	
	if (teamplay == TEAM_FF_OFF || teamplay == TEAM_FF_NO_HEALTH_ARMOR_DMG)
	{
		// Health is protected
		if (attacker.steam == targ.steam && attacker != targ) return FALSE;
	}
/*
	// teamplay modes 4,5,6 protect health
	if ((teamplay == TEAM_CTF || teamplay == TEAM_CTF_ONEFLAG || teamplay == TEAM_CTF_ALT) && attacker.steam == targ.steam && attacker != targ && !(cvar("gamecfg") & GAMECFG_TEAM_HEALTH_DMG)) 
	{
		// Health is protected
		return FALSE;
	}
*/
	return TRUE;
};

void(entity who) TeamResetCarrier = 
{
	// When the flag carrier dies, reset the last_hurt_carrier field in
	// all players on the opposite team from the flag carrier.  The carrier
	// has been killed, so there is no longer a reason to award points for
	// killing off his assailants
	/*
	if (deathmatch >= DM_CTF && (who.ctf_flags & (CTF_FLAG_TEAM1 | CTF_FLAG_TEAM2))) 
	{
		local entity head = find (world, classname, "player");
		while (head != world) 
		{	
			if (deathmatch == DM_OneFlagCTF || ((who.ctf_flags & CTF_FLAG_TEAM1) && head.steam == TEAM1) || ((who.ctf_flags & CTF_FLAG_TEAM2) && head.steam == TEAM2)) head.ctf_lasthurtcarrier = -10;
			head = find (head, classname, "player");
		}
	}
	*/
	if (deathmatch == DM_CTF || deathmatch == DM_OneFlagCTF)
	{
		if (who.ctf_flags & (CTF_FLAG_TEAM1 | CTF_FLAG_TEAM2))
		{
			local entity head = find (world, classname, "player");
			while (head != world) 
			{	
				if (deathmatch == DM_OneFlagCTF || ((who.ctf_flags & CTF_FLAG_TEAM1) && head.steam == TEAM1) || ((who.ctf_flags & CTF_FLAG_TEAM2) && head.steam == TEAM2)) head.ctf_lasthurtcarrier = -10;
				head = find (head, classname, "player");
			}
		}
	}	
};

void(entity targ, entity attacker) TeamAssists =
{
	local float flag_radius;
	local float flag_carrier_radius;
	local string s;
	local entity head;

	if ((targ.ctf_flags & (CTF_FLAG_TEAM1 | CTF_FLAG_TEAM2)) && targ.steam != attacker.steam)
	{
		//ZOID: one team fragged the other team's flag carrier
		// Mark the attacker with the time at which he killed the flag
		// carrier, for awarding assist points
		attacker.ctf_lastfraggedcarrier = time;

		// give player only the normal amount of frags
		// if the carrier has only had the flag for a few seconds, to
		// prevent ppl intentionally allowing enemies to grab the flag,
		// then immediately fragging them
		if (targ.ctf_flagsince + CTF_CARRIER_FLAG_SINCE_TIMEOUT > time) sprint (attacker, "Enemy flag carrier killed, no bonus\n");
		else 
		{
//			attacker.frags += CTF_FRAG_CARRIER_BONUS;
			add_frag (attacker, CTF_FRAG_CARRIER_BONUS);
			s = ftos (CTF_FRAG_CARRIER_BONUS);
			sprint (attacker, s, " bonus frags\n");
		}
	}
	
	// This code checks for all game-critical kills OTHER THAN fragging the enemy
	// flag carrier, like killing players who are trying to kill your flag carrier
	// or trying to grab your flag, and hands out bonus frags.

	// The two variables below track whether special bonus frags have already
	// been awarded for the attacker or target being near the flag or flag carrier.  

	flag_radius = 0;
	flag_carrier_radius = 0;

	// get a string for the attacker's team now, for later announcements
	s = GetCTFTeam (attacker.steam);

	if ((targ.ctf_lasthurtcarrier + CTF_CARRIER_DANGER_PROTECT_TIMEOUT > time) && !(attacker.ctf_flags & (CTF_FLAG_TEAM1 | CTF_FLAG_TEAM2))) 
	{
		// a player on the same team as the flag carrier killed 
		// someone who recently shot the flag carrier
//		attacker.frags += CTF_CARRIER_DANGER_PROTECT_BONUS;
		add_frag (attacker, CTF_CARRIER_DANGER_PROTECT_BONUS);
		flag_carrier_radius = 1;
		// NOTE: getting CARRIER_DANGER_PROTECT_BONUS precludes getting
		// other kinds of bonuses for defending the flag carrier, since
		// it's worth more points	
		bprint (attacker.netname, " defends ", s, "'s flag carrier against an agressive enemy\n");
	}

	// Bonusus for defending the flag carrier or the flag itself.
	// Extra frags are awarded if either the attacker or the target are
	// 1. within 40 feet of a flag carrier on the same team as the attacker
	// 2. within 40 feet of the attacker's flag
	// These bonuses are cumulative with respect to defending both the
	// flag and the flag carrier at the same time, but not cumulative with
	// respect to both the target and attacker being near the object being defended

	// find flags or flag carriers within a radius of the attacker
	head = findradius (attacker.origin, CTF_ATTACKER_PROTECT_RADIUS);

	while (head) 
	{
		if (head.classname == "player") 
		{
			if ((head.steam == attacker.steam) &&
				 (head.ctf_flags & (CTF_FLAG_TEAM1 | CTF_FLAG_TEAM2)) &&
				 (head != attacker) && // self defense
				 (!flag_carrier_radius))
			{ 
				// attacker was near his own flag carrier
//				attacker.frags += CTF_CARRIER_PROTECT_BONUS;
				add_frag (attacker, CTF_CARRIER_PROTECT_BONUS);
				flag_carrier_radius = 1;			
				bprint (attacker.netname, " defends ", s, "'s flag carrier\n");
			}
		}
		if ((attacker.steam == TEAM1 && head.classname == "item_flag_team1") ||
			(attacker.steam == TEAM2 && head.classname == "item_flag_team2") ||
			head.classname == "item_flag") 
		{  	// one flag mode
			// attacker was near his own flag
//			attacker.frags += CTF_FLAG_DEFENSE_BONUS;
			add_frag (attacker, CTF_FLAG_DEFENSE_BONUS);
			flag_radius = 1; 
			bprint (attacker.netname);
			bprint (" defends the");
			if (deathmatch != DM_OneFlagCTF)
			{
				bprint (" ");
				bprint (s);
			}
			bprint (" flag\n");
			
			if (deathmatch != DM_OneFlagCTF) bprint (attacker.netname, " defends the", s, " flag\n");
			else bprint (attacker.netname, " defends the", s, " flag\n");
		}		
		head = head.chain;
	}

	// find flags or flag carriers within a radius from the target
	head = findradius (targ.origin, CTF_TARGET_PROTECT_RADIUS);
	while (head) 
	{
		if (head.classname == "player") 
		{
			if ((head.steam == attacker.steam) &&
				 (head.ctf_flags & (CTF_FLAG_TEAM1 | CTF_FLAG_TEAM2)) &&
				 (head != attacker) &&
				 (!flag_carrier_radius)) 
			{	// prevents redundant points awarded
				// target was near attacker's flag carrier
//				attacker.frags += CTF_CARRIER_PROTECT_BONUS;
				add_frag (attacker, CTF_CARRIER_PROTECT_BONUS);
				flag_carrier_radius = 1;
				bprint (attacker.netname, " defends the", s, " flag\n");
			}
		}
		if ((attacker.steam == TEAM1 && head.classname == "item_flag_team1") ||
			(attacker.steam == TEAM2 && head.classname == "item_flag_team2") ||
			head.classname == "item_flag" &&  // one flag mode
			(!flag_radius)) 
		{ 	// prevents redundant points awarded
			// target was near attacker's flag
//			attacker.frags += CTF_FLAG_DEFENSE_BONUS;
			add_frag (attacker, CTF_FLAG_DEFENSE_BONUS);
			flag_radius = 1;
			if (deathmatch != DM_OneFlagCTF) bprint (attacker.netname, " defends the", s, " flag\n");
			else bprint (attacker.netname, " defends the", s, " flag\n");
		}
		head = head.chain;
	}
};
 
/*
==================
TeamColorIsLegal

Return TRUE if the indicated color is legal
==================
*/
float(float color) TeamColorIsLegal =
{
	// All colors are legal if deathmatch is not team based
	if (cvar("deathmatch") >= DM_TDM && cvar("deathmatch") <= DM_OneFlagCTF && !cvar("coop"))
	{
		if (color == TEAM1 || color == TEAM2) return TRUE;
		else return FALSE;
	}
	else if (cvar("coop") && !cvar("deathmatch"))
	{
		if (color == TEAM_HUMANS) return TRUE;
		else return FALSE;
	}
	else if (!cvar("coop") && !cvar("deathmatch"))
	{
		if (color == TEAM_HUMANS) return TRUE;
		else return FALSE;
	}	
	
	/*
		// In regular CTF and CTF_ONEFLAG, only two colors are legal
		if (cvar("deathmatch") == DM_CTF || cvar("deathmatch") == DM_OneFlagCTF)
		{
			if (color == TEAM1 || color == TEAM2) return TRUE;
			else return FALSE;
		}
	*/

/*
		// In ALT CTF, three colors are legal
		if (deathmatch == DM_CTF_ALT)
		{
			if (color == TEAM1 || color == TEAM2) return TRUE;
			else return FALSE;
		}
*/

	// dunno what teamplay we're in, let'em all be ok
	return TRUE;
};

.float nqwSkin;

/* TeamSetSkin - set the skin of the player model to the
   apropriate skin based on team and teamplay settings.
*/
void() TeamSetSkin =
{
	if (cvar("deathmatch") >= DM_TDM && cvar("deathmatch") <= DM_OneFlagCTF && !cvar("coop"))
	{
		if (self.team == TEAM1)
		{
			stuffcmd(self, "color 4 4\n");
			self.steam = 5;
			self.skin = 1;
		}
		
		if (self.team == TEAM2)
		{
			stuffcmd(self, "color 13 13\n");
			self.steam = 14;
			self.skin = 2;
		}
	}
	if (cvar("coop") && !cvar("deathmatch"))
	{
		if (self.team == TEAM_HUMANS)
		{
			stuffcmd(self, "color 1 6\n");
			self.steam = 7;
//			self.skin = 0;
		}
	}			
};

/*
==================
TeamCheckTeam

Check if the team self is on is legal, and put self in a legal team if not.
==================
*/
void() TeamCheckTeam =
{
	local float newcolor;
	local float t;
	local string n; 

	if ((cvar("coop") && !cvar("deathmatch")) || (self.steam >= 0) || (cvar("deathmatch") >= DM_TDM && cvar("deathmatch") <= DM_OneFlagCTF)) 
	{
		if (TeamColorIsLegal(self.steam)) 
		{
			self.steam = self.team;
			TeamSetSkin ();
			return;
		}
	}
	
	local float team1count 	  = 0;
	local float team2count 	  = 0;
	local float team3count 	  = 0;
	local float teamcoopcount = 0;

	local entity p = find (world, classname, "player");
	while (p) 
	{
		if (p != self) 
		{
			if (cvar("deathmatch") >= DM_TDM && cvar("deathmatch") <= DM_OneFlagCTF && !cvar("coop"))
			{
				     if (p.steam == TEAM1) team1count += 1;
				else if (p.steam == TEAM2) team2count += 1;
				else if (p.steam == TEAM3) team3count += 1;
			}
			
			if (cvar("coop") && !cvar("deathmatch"))
			{
				if (p.steam == TEAM_HUMANS) teamcoopcount += 1;
			}
		}
		p = find (p, classname, "player");
	}
	
	if (cvar("coop") && !cvar("deathmatch"))
	{
		newcolor = TEAM_HUMANS;
		t = teamcoopcount;
	}
		
	if (cvar("deathmatch") >= DM_TDM && cvar("deathmatch") <= DM_OneFlagCTF && !cvar("coop"))
	{
		// Find the team with the least players.
		newcolor = TEAM1;
		t = team1count;	
		if (team2count < t || (team2count == t && random() < 0.5)) 
		{
			newcolor = TEAM2;
			t = team2count;
		}
	}
	
	// In CTF_ALT, there's three teams
//	team3count *= 2; // grey team only gets half as many players
/*	
	if (deathmatch == DM_CTF_ALT && team3count < t) 
	{
		newcolor = TEAM3;
		t = team3count;
	}
*/
	// Put the player on a the new team.
	if (cvar("coop") && !cvar("deathmatch"))
	{
//		n = GetCTFTeam (newcolor);	
//		sprint (self, "You have been assigned to ", n, " team\n");
//		self.ctf_flags |= CTF_FLAG_STUFF_COLOR;
		self.steam = newcolor;      // Remember what team we're on
		self.team = newcolor;
	}	
		
	if (cvar("deathmatch") >= DM_TDM && cvar("deathmatch") <= DM_OneFlagCTF && !cvar("coop"))
	{
		self.ctf_flags |= CTF_FLAG_STUFF_COLOR;
		n = GetCTFTeam (newcolor);	
		sprint (self, "You have been assigned to ", n, " team\n");
		self.steam = newcolor;      // Remember what team we're on
		self.team = newcolor;
		
		if (self.team == TEAM1 && self.steam == TEAM1) bprint (self.netname, " joined Team RED\n");
		if (self.team == TEAM2 && self.steam == TEAM2) bprint (self.netname, " joined Team BLUE\n");
		if (self.team == TEAM3 && self.steam == TEAM3) bprint (self.netname, " joined Team GREY\n");
	}
	
	TeamSetSkin ();
};

.float changecolorwarning;
// .float alreadyassigned;
/* Check for team changing and perform whatever actions are neccessary.  */
void() TeamCheckLock =
{
	local float n;
	local string s;
/*
	if (!deathmatch || deathmatch < DM_CTF) 
	{
		// all colors are legal, no force
		self.steam = self.team;
		return;
	}
*//*
	if (cvar("deathmatch") != DM_TDM && cvar("deathmatch") != DM_CTF && cvar("deathmatch") != DM_OneFlagCTF) 
	{
		// all colors are legal, no force
		self.steam = self.team;
		return;
	}
*/
	if (self.ctf_flags & CTF_FLAG_STUFF_COLOR) 
	{
		self.ctf_flags -= CTF_FLAG_STUFF_COLOR;
		stuffcmd (self, "color ");
		n = self.steam - 1;
		s = ftos(n);
		stuffcmd (self, s);
		stuffcmd (self, "\n");
		TeamSetSkin();
		return;
	}

	if (!TeamColorIsLegal(self.team) && self.team == self.steam) self.steam = -1; // Full reset

	// Check to see if the player has changed colors
	if (self.team != self.steam) 
	{
		if (self.steam >= 0) 
		{
			if (TeamColorIsLegal(self.steam))
			{
				// changing teams sucks, warning him
				// if he has tried to change teams several
				// times, kick him off the server.
				if ((cvar("coop")) || (cvar("deathmatch") == DM_DUEL || cvar("deathmatch") == DM_FFA))
				{
					stuffcmd (self, "color 1 6\n");		
					self.steam = self.team; // Sleeper: Not sure why flipping it this way prevents a spam in developer mode, but okay.
				}
				else
				{
					self.changecolorwarning += 1;						
					if (self.changecolorwarning > 3) stuffcmd (self, "disconnect\n");
					if (self.changecolorwarning < 4) sprint (self, "You cannot change colors to change teams ");
					if (self.changecolorwarning < 3) 
					{
						sprint (self, "(warning #");
						sprint (self, ftos(self.changecolorwarning));
						sprint (self, ")\n");
					}
					if (self.changecolorwarning == 3) sprint (self, "(Final warning)\n");
					if (self.changecolorwarning >= 4) 
					{
						bprint (self.netname, " has bad color sense\n");
						sprint (self, "You were warned not to change colors. Go play color games somewhere else.\n");
					}						
					stuffcmd (self, "color ");
					n = self.steam - 1;
					s = ftos(n);
					stuffcmd (self, s);
					stuffcmd (self, "\n");
					self.team = self.steam;
				}
				return;				
			} 
			else 
			{
				// If we're on an illegal team, force a change.
				self.steam = -50;
			}
		}

		if (self.steam > 0) 
		{
			// Case base respawn
			if (self.ctf_killed != 1) self.ctf_killed = 2;
			T_Damage(self, self, self, 1000);  // Kill the player
		}
		if (cvar("deathmatch") >= DM_TDM && cvar("deathmatch") <= DM_OneFlagCTF && !cvar("coop")) self.frags = 0;                 // Zero out frags
		TeamCheckTeam(); // Re-assignment
	}
};

/* Toss out a backpack containing some ammo from your current weapon,
and any weapons you don't have.
*/
/*
// Sleeper: Hasn't been fully thought out yet, but the idea is mirror what Quake II is doing, but using
// Team_weapon_touch as a base.
void() TossBackpack_Touch =
{
	.float cnt_shells, cnt_nails, cnt_rockets, cnt_cells, cnt_lava_nails, cnt_multi_rockets, cnt_plasma;

	if (!(other.flags & FL_CLIENT)) return;
	// Don't let the owner pick up his own weapon for a second.
	if (cvar("deathmatch") && !cvar("coop"))
	{
		if ((other == self.owner) && ((self.nextthink - time) > 59)) return;
	}
	else
	{
		if ((other == self.owner) && ((self.nextthink - time) > 119)) return;
	}
	
	self.cnt_shells = 20;
	self.cnt_nails = 25;
	self.cnt_rockets = 5;
	self.cnt_cells = 6;
	self.cnt_lava_nails = 25;
	self.cnt_multi_rockets = 5;
	self.cnt_plasma = 6;
	
	// See if you have the Shotgun or Super Shotgun on
	if ((self.weapon == IT_SHOTGUN) || (self.weapon == IT_SUPER_SHOTGUN)) 
	{
		if (other.ammo_shells1 >= 20) 
		{
			self.ammo_shells1 = 20;
			other.ammo_shells1 -= 20;
		}
		else
		{
			self.ammo_shells1 = other.ammo_shells1;
			other.ammo_shells1 = 0;
		}
	}		
	
	// See if you have neither the Shotgun or Super Shotgun
	if (!(self.items & IT_SHOTGUN) && !(self.items & IT_SUPER_SHOTGUN)) 
	{
		if (other.ammo_shells1 >= 20) 
		{
			self.ammo_shells1 = 20;
			other.ammo_shells1 -= 20;
		} 
		else 
		{
			self.ammo_shells1 = other.ammo_shells1;
			other.ammo_shells1 = 0;
		}
	}		
	
	// See if we are using a nailgun
	if ((self.weapon == IT_NAILGUN) || (self.weapon == IT_SUPER_NAILGUN)) 
	{
		if (other.ammo_nails1 >= 25) 
		{
			self.ammo_nails1 = 25;
			other.ammo_nails1 -= 25;
		} 
		else 
		{
			self.ammo_nails1 = other.ammo_nails1;
			other.ammo_nails1 = 0;
		}
	}	

	// See if we are using the lava nailguns
	if ((self.weapon == DOE_LAVA_NAILGUN) || (self.weapon == DOE_LAVA_SUPER_NAILGUN)) 
	{
		if (other.ammo_lava_nails >= 25) 
		{
			self.ammo_lava_nails = 25;
			other.ammo_lava_nails -= 25;
		} 
		else 
		{
			self.ammo_lava_nails = other.ammo_lava_nails;
			other.ammo_lava_nails = 0;
		}
	}	

	// Check to see if we have neither nailgun
	if (!(self.items & IT_NAILGUN) && !(self.items & IT_SUPER_NAILGUN)) 
	{
		// put both regular and lava nails in
		if (other.ammo_nails1 >= 25) 
		{
			self.ammo_nails1 = 25;
			other.ammo_nails1 -= 25;
		} 
		else 
		{
			self.ammo_nails1 = other.ammo_nails1;
			other.ammo_nails1 = 0;
		}
		if (other.ammo_lava_nails >= 25)
		{
			self.ammo_lava_nails = 25;
			other.ammo_lava_nails -= 25;
		} 
		else 
		{
			self.ammo_lava_nails = other.ammo_lava_nails;
			other.ammo_lava_nails = 0;
		}
	}	
	
	// See if we are using a grenade or rocket launcher
	if ((self.weapon == IT_GRENADE_LAUNCHER) || (self.weapon == IT_ROCKET_LAUNCHER)) 
	{
		if (other.ammo_rockets1 >= 5) 
		{
			self.ammo_rockets1 = 5;
			other.ammo_rockets1 -= 5;
		} 
		else 
		{
			self.ammo_rockets1 = other.ammo_rockets1;
			other.ammo_rockets1 = 0;
		}
	}

	// See if we are using the multi grenade or rocket launcher
	if ((self.weapon == DOE_MULTI_GRENADE) || (self.weapon == DOE_MULTI_ROCKET)) 
	{
		if (other.ammo_multi_rockets >= 5) 
		{
			self.ammo_multi_rockets = 5;
			other.ammo_multi_rockets -= 5;
		} 
		else
		{
			self.ammo_multi_rockets = other.ammo_multi_rockets;
			other.ammo_multi_rockets = 0;
		}
	}

	// See if we have neither the Grenade or rocket launcher
	if (!(self.items & IT_GRENADE_LAUNCHER) && !(self.items & IT_ROCKET_LAUNCHER)) 
	{
		if (other.ammo_rockets1 >= 5) 
		{
			self.ammo_rockets1 = 5;
			other.ammo_rockets1 -= 5;
		} 
		else 
		{
			self.ammo_rockets1 = other.ammo_rockets1;
			other.ammo_rockets1 = 0;
		}
		if (other.ammo_multi_rockets >= 5) 
		{
			self.ammo_multi_rockets = 5;
			other.ammo_multi_rockets -= 5;
		} 
		else 
		{
			self.ammo_multi_rockets = other.ammo_multi_rockets;
			other.ammo_multi_rockets = 0;
		}
	}

	// See if we're using the lightning gun
	if (self.weapon == IT_LIGHTNING) 
	{	
		if (other.ammo_cells1 >= 6) 
		{
			self.ammo_cells1 = 6;
			other.ammo_cells1 -= 6;
		} 
		else 
		{
			self.ammo_cells1 = other.ammo_cells1;
			other.ammo_cells1 = 0;
		}
	}

	// see if we are using the plasma gun
	if (self.weapon == DOE_PLASMA_GUN) 
	{	
		if (other.ammo_plasma >= 6) 
		{
			item.ammo_plasma = 6;
			other.ammo_plasma -= 6;
		} 
		else 
		{
			self.ammo_plasma = other.ammo_plasma;
			other.ammo_plasma = 0;
		}
	}

	// see if we don't have the lightning gun
	if (!(self.items & IT_LIGHTNING)) 
	{	
		if (other.ammo_cells1 >= 6)
		{
			self.ammo_cells1 = 6;
			other.ammo_cells1 -= 6;
		} 
		else
		{
			self.ammo_cells1 = other.ammo_cells1;
			other.ammo_cells1 = 0;
		}
		if (self.ammo_plasma >= 6) 
		{
			self.ammo_plasma = 6;
			other.ammo_plasma -= 6;
		} 
		else 
		{
			self.ammo_plasma = other.ammo_plasma;
			other.ammo_plasma = 0;
		}
	}
	 
	if (self.ammo_shells1 + self.ammo_nails1 + self.ammo_lava_nails + self.ammo_rockets1 + self.ammo_multi_rockets + self.ammo_cells1 + self.ammo_plasma == 0) 
	{
		sprint (self, "", "No ammo available!\n");
		remove (item);
		return;
	}	
};
*/
void() TossBackpack =
{
	// If we don't have any ammo, return
	if (self.currentammo <= 0) return;

	// only valid in teamplay modes
//	if (teamplay < 1) return;
	if (!cvar("coop") && cvar("coop") != CLASSIC_COOP && !cvar("deathmatch")) return;

	local entity item = spawn();

	// See if you have the Shotgun or Super Shotgun on
	if ((self.weapon == IT_SHOTGUN) || (self.weapon == IT_SUPER_SHOTGUN)) 
	{
		if (self.ammo_shells1 >= 20) 
		{
			item.ammo_shells1 = 20;
			self.ammo_shells1 -= 20;
		}
		else
		{
			item.ammo_shells1 = self.ammo_shells1;
			self.ammo_shells1 = 0;
		}
	}		
	
	// See if you have neither the Shotgun or Super Shotgun
	if (!(self.items & IT_SHOTGUN) && !(self.items & IT_SUPER_SHOTGUN)) 
	{
		if (self.ammo_shells1 >= 20) 
		{
			item.ammo_shells1 = 20;
			self.ammo_shells1 -= 20;
		} 
		else 
		{
			item.ammo_shells1 = self.ammo_shells1;
			self.ammo_shells1 = 0;
		}
	}		
	
	// See if we are using a nailgun
	if ((self.weapon == IT_NAILGUN) || (self.weapon == IT_SUPER_NAILGUN)) 
	{
		if (self.ammo_nails1 >= 20) 
		{
			item.ammo_nails1 = 20;
			self.ammo_nails1 -= 20;
		} 
		else 
		{
			item.ammo_nails1 = self.ammo_nails1;
			self.ammo_nails1 = 0;
		}
	}	

	// See if we are using the lava nailguns
	if ((self.weapon == DOE_LAVA_NAILGUN) || (self.weapon == DOE_LAVA_SUPER_NAILGUN)) 
	{
		if (self.ammo_lava_nails >= 20) 
		{
			item.ammo_lava_nails = 20;
			self.ammo_lava_nails -= 20;
		} 
		else 
		{
			item.ammo_lava_nails = self.ammo_lava_nails;
			self.ammo_lava_nails = 0;
		}
	}	

	// Check to see if we have neither nailgun
	if (!(self.items & IT_NAILGUN) && !(self.items & IT_SUPER_NAILGUN)) 
	{
		// put both regular and lava nails in
		if (self.ammo_nails1 >= 20) 
		{
			item.ammo_nails1 = 20;
			self.ammo_nails1 -= 20;
		} 
		else 
		{
			item.ammo_nails1 = self.ammo_nails1;
			self.ammo_nails1 = 0;
		}
		if (self.ammo_lava_nails >= 20)
		{
			item.ammo_lava_nails = 20;
			self.ammo_lava_nails -= 20;
		} 
		else 
		{
			item.ammo_lava_nails = self.ammo_lava_nails;
			self.ammo_lava_nails = 0;
		}
	}	
	
	// See if we are using a grenade or rocket launcher
	if ((self.weapon == IT_GRENADE_LAUNCHER) || (self.weapon == IT_ROCKET_LAUNCHER)) 
	{
		if (self.ammo_rockets1 >= 10) 
		{
			item.ammo_rockets1 = 10;
			self.ammo_rockets1 -= 10;
		} 
		else 
		{
			item.ammo_rockets1 = self.ammo_rockets1;
			self.ammo_rockets1 = 0;
		}
	}

	// See if we are using the multi grenade or rocket launcher
	if ((self.weapon == DOE_MULTI_GRENADE) || (self.weapon == DOE_MULTI_ROCKET)) 
	{
		if (self.ammo_multi_rockets >= 10) 
		{
			item.ammo_multi_rockets = 10;
			self.ammo_multi_rockets -= 10;
		} 
		else
		{
			item.ammo_multi_rockets = self.ammo_multi_rockets;
			self.ammo_multi_rockets = 0;
		}
	}

	// See if we have neither the Grenade or rocket launcher
	if (!(self.items & IT_GRENADE_LAUNCHER) && !(self.items & IT_ROCKET_LAUNCHER)) 
	{
		if (self.ammo_rockets1 >= 10) 
		{
			item.ammo_rockets1 = 10;
			self.ammo_rockets1 -= 10;
		} 
		else 
		{
			item.ammo_rockets1 = self.ammo_rockets1;
			self.ammo_rockets1 = 0;
		}
		if (self.ammo_multi_rockets >= 10) 
		{
			item.ammo_multi_rockets = 10;
			self.ammo_multi_rockets -= 10;
		} 
		else 
		{
			item.ammo_multi_rockets = self.ammo_multi_rockets;
			self.ammo_multi_rockets = 0;
		}
	}

	// See if we're using the lightning gun
	if (self.weapon == IT_LIGHTNING) 
	{	
		if (self.ammo_cells1 >= 20) 
		{
			item.ammo_cells1 = 20;
			self.ammo_cells1 -= 20;
		} 
		else 
		{
			item.ammo_cells1 = self.ammo_cells1;
			self.ammo_cells1 = 0;
		}
	}

	// see if we are using the plasma gun
	if (self.weapon == DOE_PLASMA_GUN) 
	{	
		if (self.ammo_plasma >= 10) 
		{
			item.ammo_plasma = 10;
			self.ammo_plasma -= 10;
		} 
		else 
		{
			item.ammo_plasma = self.ammo_plasma;
			self.ammo_plasma = 0;
		}
	}

	// see if we don't have the lightning gun
	if (!(self.items & IT_LIGHTNING)) 
	{	
		if (self.ammo_cells1 >= 20)
		{
			item.ammo_cells1 = 20;
			self.ammo_cells1 -= 20;
		} 
		else
		{
			item.ammo_cells1 = self.ammo_cells1;
			self.ammo_cells1 = 0;
		}
		if (self.ammo_plasma >= 10) 
		{
			item.ammo_plasma = 10;
			self.ammo_plasma -= 10;
		} 
		else 
		{
			item.ammo_plasma = self.ammo_plasma;
			self.ammo_plasma = 0;
		}
	}
	 
	if (item.ammo_shells1 + item.ammo_nails1 + item.ammo_lava_nails + item.ammo_rockets1 + item.ammo_multi_rockets + item.ammo_cells1 + item.ammo_plasma == 0) 
	{
		sprint (self, "", "No ammo available!\n");
		remove (item);
		return;
	}	
	 
	item.owner = self;
	makevectors (self.v_angle);
	setorigin (item, self.origin + '0 0 48');
	item.velocity = aim (self, 950);
	item.velocity *= 420;
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_BOUNCE;
	setmodel (item, "progs/backpack.mdl");
	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;
	
	if (cvar("deathmatch") && !cvar("coop")) item.nextthink = time + 60; // remove after a minutes
	else item.nextthink = time + 120; 	    // remove after 2 minutes
	
	item.think = SUB_Remove;
	W_SetCurrentAmmo();
};

void() Team_weapon_touch =
{
	local float best, new, new2, old;
	local entity stemp;
	
	if (other.health <= 0) return;
	if (!(other.flags & FL_CLIENT)) return;
	
	// Don't let the owner pick up his own weapon for a second.
	if ((cvar("deathmatch")) || (cvar("coop") != CLASSIC_COOP))
	{
		if ((other == self.owner) && ((self.nextthink - time) > 19)) return;
	}

// if the player was using his best weapon, change up to the new one if better		
	stemp = self;
	self = other;
	best = W_BestWeapon ();
	self = stemp;

	if (self.classname == "weapon_nailgun")
	{
		new = IT_NAILGUN; 
		new2 = DOE_LAVA_NAILGUN;
		other.ammo_nails1 += self.cnt;
	}
	else if (self.classname == "weapon_supernailgun")
	{
		new = IT_SUPER_NAILGUN; 
		new2 = DOE_LAVA_SUPER_NAILGUN;
		other.ammo_nails1 += self.cnt;
	}
	else if (self.classname == "weapon_supershotgun")
	{
		new = IT_SUPER_SHOTGUN;
		other.ammo_shells1 += self.cnt;
	}
	else if (self.classname == "weapon_rocketlauncher")
	{
		new = IT_ROCKET_LAUNCHER;
		new2 = DOE_MULTI_ROCKET;
		other.ammo_rockets1 += self.cnt;
	}
	else if (self.classname == "weapon_grenadelauncher")
	{
		new = IT_GRENADE_LAUNCHER;
		new2 = DOE_MULTI_GRENADE;
		other.ammo_rockets1 += self.cnt;
	}
	else if (self.classname == "weapon_proximity_gun")
	{
		new2 = IT_PROXIMITY_GUN;
		other.ammo_rockets1 += self.cnt;
	}
	else if (self.classname == "weapon_laser_gun")
	{
		new2 = IT_LASER_CANNON;
		other.ammo_cells1 += self.cnt;
	}	
	else if (self.classname == "weapon_mjolnir")
	{
		new2 = IT_MJOLNIR;
		other.ammo_cells1 += self.cnt;
	}		
	else if (self.classname == "weapon_lightning")
	{
		new = IT_LIGHTNING;
		new2 = DOE_PLASMA_GUN;
		other.ammo_cells1 += self.cnt;
	}
	else objerror ("Team_weapon_touch: unknown classname");

	sprint (other, "", "You got the ", self.netname, "\n");
// weapon touch sound
	sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	bound_other_ammo ();

// change to the weapon
	old = other.items;
	// Sleeper: Only put ID weapons into .items field, so we don't screw up the HUD. And then just add both base and expansion weapons to the .weapons field.
	// If we add more .weapons# fields, create a new, float then add those weapons to the desired .weapons field.
	other.items |= new;
	other.weapons |= new | new2;
		
	remove (self);
	self = other;

//	if (!cvar("deathmatch")) self.weapon = new;
//	else Deathmatch_Weapon (old, new);

	EnableComboWeapons (self);
	UpdateAmmoCounts (self);

	W_SetCurrentAmmo ();

	// dropped weapon doesn't target, so no need to call UseTargets
};
        
void() TossWeapon =
{
//	if (deathmatch != DM_DUEL) return; // only in deathmatch 1

	// only valid in teamplay modes
//	if (teamplay < 1) return;
	if (!coop && !deathmatch && coop != CLASSIC_COOP) return;

	if ((self.weapon == IT_AXE) || (self.weapon == IT_SHOTGUN) || (self.weapon == DOE_GRAPPLE) || (self.weapon == NQW_IT_COILGUN)) return;
		
	local entity item = spawn ();
	item.owner = self;
	makevectors (self.v_angle);
	item.weapon = 0;

	setorigin (item, self.origin + '0 0 -16');
	item.velocity = aim (self, 950);
	item.velocity *= 320;
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_BOUNCE;
	
	if (self.weapon == IT_SUPER_SHOTGUN)
	{
		setmodel (item, "progs/g_shot.mdl");
		item.weapon = IT_SUPER_SHOTGUN;
		item.netname = "Double-Barreled Shotgun";
		item.classname = "weapon_supershotgun";
		if (self.health <= 0) item.cnt = 5;
		self.items -= self.items & (IT_SUPER_SHOTGUN);
		self.weapons -= self.weapons & (IT_SUPER_SHOTGUN);
	}

	if (self.weapon == IT_NAILGUN || self.weapon == DOE_LAVA_NAILGUN)
	{
		setmodel (item, "progs/g_nail.mdl");
		item.weapon = IT_NAILGUN;
		item.netname = "Nailgun";
		item.classname = "weapon_nailgun";
		if (self.health <= 0) item.cnt = 25;
		self.items -= self.items & (IT_NAILGUN);
		self.weapons -= self.weapons & (IT_NAILGUN | DOE_LAVA_NAILGUN);
	}
		
	if (self.weapon == IT_SUPER_NAILGUN || self.weapon == DOE_LAVA_SUPER_NAILGUN)
	{
		setmodel (item, "progs/g_nail2.mdl");
		item.weapon = IT_SUPER_NAILGUN;
		item.netname = "Super Nailgun";
		item.classname = "weapon_supernailgun";
		if (self.health <= 0)item.cnt = 25;
		self.items -= self.items & (IT_SUPER_NAILGUN);
		self.weapons -= self.weapons & (IT_SUPER_NAILGUN | DOE_LAVA_SUPER_NAILGUN);
	}
	
	if (self.weapon == IT_GRENADE_LAUNCHER || self.weapon == DOE_MULTI_GRENADE)
	{
		setmodel (item, "progs/g_rock.mdl");
		item.weapon = IT_GRENADE_LAUNCHER;
		item.netname = "Grenade Launcher";
		item.classname = "weapon_grenadelauncher";
		if (self.health <= 0) item.cnt = 5;
		self.items -= self.items & (IT_GRENADE_LAUNCHER);
		self.weapons -= self.weapons & (IT_GRENADE_LAUNCHER | DOE_MULTI_GRENADE);
	}

	if (self.weapon == IT_PROXIMITY_GUN)
	{
		setmodel (item, "progs/g_prox.mdl");
		item.weapon = IT_PROXIMITY_GUN;
		item.netname = "Proximity Gun";
		item.classname = "weapon_proximity_gun";
		if (self.health <= 0) item.cnt = 5;
//		self.items -= self.items & (IT_PROXIMITY_GUN);
		self.weapons -= self.weapons & (IT_PROXIMITY_GUN);
	}
	
	if (self.weapon == IT_LASER_CANNON)
	{
		setmodel (item, "progs/g_laserg.mdl");
		item.weapon = IT_LASER_CANNON;
		item.netname = "Laser Cannon";
		item.classname = "weapon_laser_gun";
		if (self.health <= 0) item.cnt = 30;
//		self.items -= self.items & (IT_LASER_CANNON);
		self.weapons -= self.weapons & (IT_LASER_CANNON);
	}	
	
	if (self.weapon == IT_MJOLNIR)
	{
		setmodel (item, "progs/g_hammer.mdl");
		item.weapon = IT_MJOLNIR;
		item.netname = "Mjolnir";
		item.classname = "weapon_mjolnir";
		if (self.health <= 0) item.cnt = 30;
//		self.items -= self.items & (IT_MJOLNIR);
		self.weapons -= self.weapons & (IT_MJOLNIR);
	}	
	
	if (self.weapon == IT_ROCKET_LAUNCHER || self.weapon == DOE_MULTI_ROCKET)
	{
		setmodel (item, "progs/g_rock2.mdl");
		item.weapon = IT_ROCKET_LAUNCHER;
		item.netname = "Rocket Launcher";
		item.classname = "weapon_rocketlauncher";
		if (self.health <= 0) item.cnt = 5;
		self.items -= self.items & (IT_ROCKET_LAUNCHER);
		self.weapons -= self.weapons & (IT_ROCKET_LAUNCHER | DOE_MULTI_ROCKET);
	}
	
	if (self.weapon == IT_LIGHTNING || self.weapon == DOE_PLASMA_GUN)
	{
		setmodel (item, "progs/g_light.mdl");
		item.weapon = IT_LIGHTNING;
		item.netname = "Thunderbolt";
		item.classname = "weapon_lightning";
		if (self.health <= 0) item.cnt = 15;
		self.items -= self.items & (IT_LIGHTNING);
		self.weapons -= self.weapons & (IT_LIGHTNING | DOE_PLASMA_GUN);
	}
	
	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = Team_weapon_touch;
	item.think = SUB_Remove;
	item.nextthink = time + 20;	
	self.weapon = W_BestWeapon ();
	W_SetCurrentAmmo ();
};

void(entity flg) RegenFlag =
{
	flg.movetype = MOVETYPE_TOSS;
	flg.solid = SOLID_TRIGGER;
	sound (flg, CHAN_VOICE, self.noise1, 1, ATTN_NONE);	// play respawn sound
	setorigin (flg, flg.oldorigin);
	flg.angles = flg.mangle;
	flg.cnt = FLAG_AT_BASE; // it's at home base
	flg.owner = world;
};

void(entity flg) TeamReturnFlag =
{
	RegenFlag (flg);

	local entity p = find(world, classname, "player");
	/*
	while (p != world) 
	{
		if (deathmatch == DM_OneFlagCTF) // one flag mode?
		{
			sprint (p, "The flag has been returned...\n");
			id1_centerprint (p, "The flag has been returned!\n");
		}
		else 
		{
			if (deathmatch == DM_CTF_ALT) 
			{
				if (flg.team == TEAM1) id1_centerprint (p, "RED flag has been returned to base!\n");
				else if (flg.team == TEAM2) id1_centerprint (p, "BLUE flag has been returned to base!\n");
				else id1_centerprint (p, "Some flag has been returned to base!\n");
			} 
			else 
			{
				if (p.steam != flg.team)
				{
					sprint(p, "Enemy flag has been returned...\n");
					id1_centerprint (p, "Enemy flag has been returned to base!\n");
				}
				else if (p.steam == flg.team)
				{
					sprint(p, "Your flag has been returned...\n");
					id1_centerprint (p, "Your flag has been returned to base!\n");
				}
			}
		}
		p = find (p, classname, "player");
	}
	*/
	while (p != world) 
	{
		if (deathmatch == DM_OneFlagCTF) // one flag mode?
		{
			sprint (p, "The flag has been returned...\n");
			id1_centerprint (p, "The flag has been returned!\n");
		}
		else 
		{
			if (p.steam != flg.team)
			{
				sprint(p, "Enemy flag has been returned...\n");
				id1_centerprint (p, "Enemy flag has been returned to base!\n");
			}
			else if (p.steam == flg.team)
			{
				sprint(p, "Your flag has been returned...\n");
				id1_centerprint (p, "Your flag has been returned to base!\n");
			}
		}
		p = find (p, classname, "player");
	}	
};

void() TeamRegenFlags =
{
	local entity f;

	if (deathmatch == DM_OneFlagCTF) 
	{
		f = find (world, classname, "item_flag");
		if (f != world) RegenFlag (f);
		return;
	}
	
	f = find(world, classname, "item_flag_team1");
	if (f != world) RegenFlag (f);
	f = find(world, classname, "item_flag_team2");
	if (f != world) RegenFlag (f);
};

void(entity flg) TeamDropFlag =
{
	local entity p = flg.owner;

	if (cvar("deathmatch") == DM_CTF)
	{
		if (flg.team == TEAM1) bprint ("BLUE ", p.netname, " lost the RED flag!\n"); // red
		if (flg.team == TEAM2) bprint ("RED ", p.netname, " lost the BLUE flag!\n"); // blue	
	}
	if (cvar("deathmatch") == DM_OneFlagCTF)
	{
		if (flg.team == TEAM1) bprint ("BLUE ", p.netname, " lost the flag!\n");
		if (flg.team == TEAM2) bprint ("RED ", p.netname, " lost the flag!\n");
	}

	setorigin(flg, p.origin - '0 0 24');
	flg.cnt = FLAG_DROPPED;
	flg.velocity_z = 300;
	flg.velocity_x = 0;
	flg.velocity_y = 0;
	flg.flags |= FL_OBJECTIVE;
	flg.solid = SOLID_TRIGGER;
	flg.movetype = MOVETYPE_TOSS;
	setsize(flg, '-16 -16 0', '16 16 74');
	// return it after so long
	flg.super_time = time + CTF_FLAG_RETURN_TIME;
};

void(entity player) TeamDropFlagOfPlayer =
{
	local string kn;
	local entity e;

	if (deathmatch == DM_OneFlagCTF && (player.ctf_flags & CTF_FLAG_FLAG)) kn = "item_flag";
	else if (player.ctf_flags & CTF_FLAG_TEAM1) kn = "item_flag_team1";
	else if (player.ctf_flags & CTF_FLAG_TEAM2) kn = "item_flag_team2";
	else return; // doesn't have a flg
		
	if (player.health <= 0)
	{
		if (player.steam == TEAM1) player.items -= player.items & (IT_KEY1);
		else player.items -= player.items & (IT_KEY2);
	}		
	player.ctf_flags -= player.ctf_flags & (CTF_FLAG_FLAG | CTF_FLAG_TEAM1 | CTF_FLAG_TEAM2);
	e = find(world, classname, kn);
	if (e != world) TeamDropFlag(e);
};

// A flag was touched.  In one flag mode, the player always just picks it up
// (the flagbase models at each base will cause the score).  In two flag mode,
// it could be the guy returning his flag, or the guy getting the enemy flag
// Three team mode gets more complicated as the third team touches the 
// flagbase to score
void() TeamFlagTouch =
{
	local entity p;

	if (other.classname != "player") return;
	if (other.health <= 0) return;
	if (initiate_matchtime == FALSE && cvar("deathmatch")) return;	

//	if (other.team != other.steam) return; // something is fishy, somebody is playing with colors

	if (self.cnt == FLAG_CARRIED) return; // huh?

	// Ok, first up, let's do it for one flag mode
	if (deathmatch == DM_OneFlagCTF) 
	{
		// in one flag mode, we always pick up the flag.  The touch of the
		// flagbase entities does the scoring
		if (other.steam == TEAM1) bprint("RED ");
		else if (other.steam == TEAM2) bprint("BLUE ");
		bprint(other.netname, " has the flag!\n");
//		if (CTF_FLAG_BONUS) other.frags += CTF_FLAG_BONUS;
		if (CTF_FLAG_BONUS) add_frag (other, CTF_FLAG_BONUS);
		id1_centerprint (other, "YOU have the flag!\n");

		sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);

		other.ctf_flags |= CTF_FLAG_FLAG;
		other.items |= self.items;
		other.ctf_flagsince = time;

		// pick up the flag
		self.cnt = FLAG_CARRIED;
		self.movetype = MOVETYPE_NOCLIP;
		self.solid = SOLID_NOT;
		self.owner = other;

		p = find (world, classname, "player");
		while (p != world) 
		{
			if (p != other) id1_centerprint (p, "The flag has been taken!");
			p = find (p, classname, "player");
		}
		return;
	}

	// Regular and Alt CTF mode
//	if (deathmatch != DM_CTF && deathmatch != DM_CTF_ALT) return; // odd, but ignore it
	if (deathmatch != DM_CTF) return;

	if (self.team == other.steam) 
	{
		// same team, if the flag is *not* at the base, return
		// it to base.  we overload the 'cnt' field for this
		if (self.cnt == FLAG_AT_BASE) 
		{
			// the flag is at home base.  if the player has the enemy
			// flag, he's just won!
			if ((self.team == TEAM1 && (other.ctf_flags & CTF_FLAG_TEAM2)) ||
			    (self.team == TEAM2 && (other.ctf_flags & CTF_FLAG_TEAM1))) 
			{
				if (other.steam == TEAM1)
				{
//					other.captures += CTF_CAPTURE_POINTS;
					add_score (other, CTF_CAPTURE_POINTS);
					bprint("RED SCORES ", other.netname, " captured the BLUE flag!\n"); // blue
				}
				else if (other.steam == TEAM2)
				{
//					other.captures += CTF_CAPTURE_POINTS;
					add_score (other, CTF_CAPTURE_POINTS);
					bprint("BLUE SCORES ", other.netname, " captured the RED flag!\n"); // red
				}
				other.items -= other.items & (IT_KEY1 | IT_KEY2);

				sound (other, CHAN_VOICE, "misc/flagcap.wav", 1, ATTN_NONE);

				// other gets another 10 frag bonus
//				other.frags += CTF_CAPTURE_BONUS;
				add_frag (other, CTF_CAPTURE_BONUS);

				// Ok, let's do the player loop, hand out the bonuses
				p = find (world, classname, "player");
				while (p != world) 
				{
					self = p;
					if (self.team == other.team && self != other) self.frags += CTF_TEAM_BONUS;
					if (self.team != other.team) 
					{
						if (self.team == TEAM3) 
						{
							if (other.team == TEAM1) id1_centerprint (self, "BLUE flag was captured!\n");
							else id1_centerprint (self, "RED flag was captured!\n");
						} 
						else id1_centerprint (self, "Your flag was captured!\n");
						
						// reset the last_hurt_carrier variable in all enemy players, so that you don't get
						// bonuses for defending the flag carrier if the flag carrier has already
						// completed a capture
						self.ctf_lasthurtcarrier = -5;
					} 
					else if (self.team == other.team)
					{
						// done to all players on the capturing team
						id1_centerprint (self, "You captured the enemy's flag!");
						// award extra points for capture assists
						if (self.ctf_lastreturnedflag + CTF_RETURN_FLAG_ASSIST_TIMEOUT > time) 
						{
							bprint (self.netname);
							if (self.team == TEAM1) bprint (" gets an assist for returning the RED flag!\n");
							else bprint (" gets an assist for returning the BLUE flag!\n");
							self.frags += CTF_RETURN_FLAG_ASSIST_BONUS;
						}
						if (self.ctf_lastfraggedcarrier + CTF_FRAG_CARRIER_ASSIST_TIMEOUT > time) 
						{
							bprint (self.netname);
							bprint (" gets an assist for fragging the flag carrier!\n");
							self.frags += CTF_FRAG_CARRIER_ASSIST_BONUS;
						}
					}
					self.ctf_flags -= self.ctf_flags & (CTF_FLAG_TEAM1 | CTF_FLAG_TEAM2);
					p = find(p, classname, "player");
				}
				// respawn flags
				TeamRegenFlags();
				return;
			}
			return; // its at home base already
		}	
		// hey, its not home.  return it by teleporting it back
		if (other.steam == TEAM1) bprint ("RED", other.netname, " returned the RED flag!\n"); // red
		if (other.steam == TEAM2) bprint ("BLUE", other.netname, " returned the BLUE flag!\n"); // blue
//		other.frags += CTF_RECOVERY_BONUS;
		add_frag (other, CTF_RECOVERY_BONUS);
		other.ctf_lastreturnedflag = time;
		sound (other, CHAN_ITEM, self.noise1, 1, ATTN_NORM);
		TeamReturnFlag(self);
		return;
	}

	// if we have any flags, leave now
	if (other.ctf_flags & (CTF_FLAG_TEAM1 | CTF_FLAG_TEAM2)) return;

	// hey, its not our flag, pick it up
	if (self.team == TEAM1)
	{
		id1_centerprint (other, "YOU have the flag!\n");
		bprint ("BLUE ", other.netname, " has the RED flag!\n"); // red
	}
	else if (self.team == TEAM2)
	{
		id1_centerprint (other, "YOU have the flag!\n");
		bprint ("RED ", other.netname, " has the BLUE flag!\n"); // blue
		
	}
//	other.frags += CTF_FLAG_BONUS;
	add_frag (other, CTF_FLAG_BONUS);

/*
	// if in three team, messages are a little different
	if (other.team == TEAM3)
	{
//		centerprint (other, "$qc_got_flag_other");
		id1_centerprint (other, "YOU have the Enemy Flag!\n");
	} 
	else 
	{
//		centerprint (other, "$qc_got_flag_return_base");
		id1_centerprint (other, "YOU have the Enemy Flag!\n");
	}
*/
	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);

	if (self.team == TEAM1) other.ctf_flags |= CTF_FLAG_TEAM1;
	else other.ctf_flags |= CTF_FLAG_TEAM2;
	other.items |= self.items;

	other.ctf_flagsince = time;

	// pick up the flag
	self.cnt = FLAG_CARRIED;
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	self.owner = other;

	// PGM Fix - 03/06/97 Made it work right in three team. 
	p = find(world, classname, "player");
	while (p != world) 
	{
		if (p != other) 
		{
			if (p.team == self.team) id1_centerprint (p, "Your flag has been taken!\n");
			else if (p.team == other.team)
			{
				if (self.team == TEAM1) id1_centerprint (p, "Your team has the RED flag!\n");	// Red Flag
				else if (self.team == TEAM2) id1_centerprint (p, "Your team has the BLUE flag!\n");	// Blue Flag
			}
			/*
			else
			{
				if (self.team == TEAM1)
				{
					if (other.team == TEAM2) id1_centerprint (p, "BLUE team has the RED flag!\n"); // Blue has red
					else id1_centerprint (p, "GREY team has the RED flag!\n"); // grey has red
				}
				else if (self.team == TEAM2)
				{
					if (other.seam == TEAM1) id1_centerprint (p, "RED team has the BLUE flag!\n"); // red has blue
					else id1_centerprint (p, "GREY team has the BLUE flag!\n");// grey has blue
				}
			}
			*/
		}
		p = find (p, classname, "player");
	}
};

// A flagbase was touched.  In one flag mode, this is how a capture is made.
// in three team mode, only team3 touches this.  In regular CTF, this is
// ignored
void() TeamFlagBaseTouch =
{
	local entity p, f;

	if (other.classname != "player") return;
	if (other.health <= 0) return;
//	if (other.team != other.steam) return; // something is fishy, somebody is playing with colors

	// Ok, first up, let's do it for one flag mode
	if (deathmatch == DM_OneFlagCTF) 
	{
		// ok, if they guy touching it has the flag and this is his
		// base, capture!
		if (((self.team == TEAM1 && other.steam == TEAM2) || 
		     (self.team == TEAM2 && other.steam == TEAM1)) && 
		     (other.ctf_flags & CTF_FLAG_FLAG)) 
		{
			// he just touched enemy base, capture it
			if (self.team == TEAM1 && other.steam == TEAM2)
			{
//				other.captures += CTF_CAPTURE_POINTS;
				add_score (other, CTF_CAPTURE_POINTS);
				bprint ("BLUE SCORES ");
			}
			else if (self.team == TEAM2 && other.steam == TEAM1)
			{
//				other.captures += CTF_CAPTURE_POINTS;
				add_score (other, CTF_CAPTURE_POINTS);
				bprint ("RED SCORES ");
			}
			bprint (other.netname, " captured the flag!\n"); // blue
			id1_centerprint (other, "YOU captured the flag!\n");
			other.items -= other.items & (IT_KEY1 | IT_KEY2);
			sound (other, CHAN_VOICE, "misc/flagcap.wav", 1, ATTN_NONE);

			// other gets another 10 frag bonus
//			other.frags += CTF_CAPTURE_BONUS;
			add_frag (other, CTF_CAPTURE_BONUS);

			// Ok, let's do the player loop, hand out the bonuses
			p = find (world, classname, "player");
			while (p != world) 
			{
				self = p;
//				if (self.team == other.team && self != other) self.frags += CTF_TEAM_BONUS;
				if (self.team == other.team && self != other) add_score (self, CTF_TEAM_BONUS);
				if (self.team != other.team) self.ctf_lasthurtcarrier = -5;
				else if (self.team == other.team) 
				{
					// award extra points for capture assists
					if (self.ctf_lastfraggedcarrier + CTF_FRAG_CARRIER_ASSIST_TIMEOUT > time) 
					{
						bprint (self.netname);
						bprint (" gets an assist for fragging the flag carrier!\n");
//						self.frags += CTF_FRAG_CARRIER_ASSIST_BONUS;
						add_score (self, CTF_FRAG_CARRIER_ASSIST_BONUS);
					}
				}
				self.ctf_flags -= self.ctf_flags & (CTF_FLAG_FLAG);
				p = find (p, classname, "player");
			}
			// respawn flags
			TeamRegenFlags();
			return;
		}
	}

	// in three team mode (TEAM_CTF_ALT) and we're on team3, see if we capture
//	if (deathmatch != TEAM_CTF_ALT || other.steam != TEAM3) return;
	if (other.steam != TEAM3) return;

	if (((other.ctf_flags & CTF_FLAG_TEAM1) && (self.team == TEAM2)) ||
	    ((other.ctf_flags & CTF_FLAG_TEAM2) && (self.team == TEAM1))) 
	{
		// third team captured

		if (self.team == TEAM1)
		{
//			other.captures += CTF_CAPTURE_POINTS;
			add_score (other, CTF_CAPTURE_POINTS);
			bprint ("RED", other.netname, " captured the BLUE flag!\n"); // blue
		}
		else
		{
//			other.captures += CTF_CAPTURE_POINTS;
			add_score (other, CTF_CAPTURE_POINTS);
			bprint ("BLUE", other.netname, " captured the BLUE flag!\n");  // red
		}
		other.items -= other.items & (IT_KEY1 | IT_KEY2);

		sound (other, CHAN_VOICE, "misc/flagcap.wav", 1, ATTN_NONE);

		// other gets another 10 frag bonus
//		other.frags += CTF_ALT_CAPTURE_BONUS;
		add_frag (other, CTF_ALT_CAPTURE_BONUS);

		// Ok, let's do the player loop, hand out the bonuses
		p = find(world, classname, "player");
		while (p != world) 
		{
			self = p;
//			if (self.team == other.team && self != other) self.frags += CTF_ALT_TEAM_BONUS;
			if (self.team == other.team && self != other) add_score (self, CTF_ALT_TEAM_BONUS);
			if (self.team != other.team) 
			{
				if ((other.ctf_flags & CTF_FLAG_TEAM1) && self.team == TEAM1) id1_centerprint (self, "Your flag was captured!\n");
				else if ((other.ctf_flags & CTF_FLAG_TEAM2) && self.team == TEAM2) id1_centerprint (self, "The enemy flag was captured!\n");
				// reset the last_hurt_carrier variable in all enemy players, so that you don't get
				// bonuses for defending the flag carrier if the flag carrier has already
				// completed a capture
				self.ctf_lasthurtcarrier = -5;
			}
			else if (self.team == other.team)
			{
				// done to all players on the capturing team
				id1_centerprint (self, "Your team captured the flag!\n");
			}
			p = find (p, classname, "player");
		}
		// respawn flags
		if (other.ctf_flags & CTF_FLAG_TEAM1)
		{
			f = find (world, classname, "item_flag_team1");
			if (f != world) RegenFlag(f);
		} 
		else 
		{ 
			// must be flag2
			f = find(world, classname, "item_flag_team2");
			if (f != world) RegenFlag(f);
		}
		other.ctf_flags -= other.ctf_flags & (CTF_FLAG_TEAM1 | CTF_FLAG_TEAM2);
		return;
	}
};


void() TeamFlagThink =
{
	local entity e;
	local vector v;
	local float f;

	self.nextthink = time + 0.1;

	if (self.cnt == FLAG_AT_BASE) return; // just sitting around waiting to be picked up

	if (self.cnt == FLAG_DROPPED) 
	{
		if (time - self.super_time > CTF_FLAG_RETURN_TIME) TeamReturnFlag (self);
		return;
	}

	if (self.cnt != FLAG_CARRIED) objerror ("Flag in invalid state\n");

	e = self.owner;
	if (e.classname != "player" || e.deadflag) 
	{
		TeamDropFlag (self);
		return;
	}

	if (deathmatch == DM_OneFlagCTF && !(e.ctf_flags & CTF_FLAG_FLAG)) 
	{
		TeamDropFlag (self);
		return;
	}
	// must be TEAM_CTF or TEAM_CTF_ALT
	if ((!(e.ctf_flags & CTF_FLAG_TEAM1) && self.team == TEAM1) ||
	    (!(e.ctf_flags & CTF_FLAG_TEAM2) && self.team == TEAM2)) 
	{
		TeamDropFlag (self);
		return;
	}

	makevectors (e.angles);
	v = v_forward;
	v_z = (-1) * v_z; // reverse z component

	f = 14;
	if (self.owner.frame >= 29 && self.owner.frame <= 40) 
	{
		if (self.owner.frame >= 29 && self.owner.frame <= 34) 
		{ 	
			// axpain
			if (self.owner.frame == 29) f += 2; 
			else if (self.owner.frame == 30) f += 8;
			else if (self.owner.frame == 31) f += 12;
			else if (self.owner.frame == 32) f += 11;
			else if (self.owner.frame == 33) f += 10;
			else if (self.owner.frame == 34) f += 4;
		} 
		else if (self.owner.frame >= 35 && self.owner.frame <= 40) 
		{ 	// pain
			if (self.owner.frame == 35) f += 2; 
			else if (self.owner.frame == 36) f += 10;
			else if (self.owner.frame == 37) f += 10;
			else if (self.owner.frame == 38) f += 8;
			else if (self.owner.frame == 39) f += 4;
			else if (self.owner.frame == 40) f += 2;
		}
	} 
	else if (self.owner.frame >= 103 && self.owner.frame <= 118) 
	{
		if (self.owner.frame >= 103 && self.owner.frame <= 104) f += 6;  // nailattack
		else if (self.owner.frame >= 105 && self.owner.frame <= 106) f += 6;  // light 
		else if (self.owner.frame >= 107 && self.owner.frame <= 112) f += 7;  // rocketattack
		else if (self.owner.frame >= 112 && self.owner.frame <= 118) f += 7;  // shotattack
	}
	self.origin = e.origin + '0 0 -16' - f * v + v_right * 22;
	self.angles = e.angles + '0 0 -45';
	setorigin (self, self.origin);
	self.nextthink = time + 0.01;
};

void() TeamFlagStatusReport =
{
	local entity flag1, flag2, p;
	local string n;

	if (!deathmatch) return;

	if (deathmatch != DM_CTF && deathmatch != DM_OneFlagCTF) 
	{
		sprint(self, "Capture the Flag is not enabled.\n");
		return;
	}

	if (deathmatch == DM_OneFlagCTF)
	{
		flag1 = find (world, classname, "item_flag");
		if (flag1 == world) sprint (self, "The flag is missing!\n");
		else if (flag1.cnt == FLAG_AT_BASE) sprint (self, "The flag is at base!\n");
		else if (flag1.cnt == FLAG_DROPPED) sprint (self, "The flag is lying about!\n");
		else if (flag1.cnt == FLAG_CARRIED) 
		{
			if (flag1.owner == self) sprint (self, "You have the flag!\n");
			else 
			{
				sprint (self, flag1.owner.netname);
				n = GetCTFTeam (flag1.owner.steam);
				sprint (self, " of the ");
				sprint (self, n);
				sprint (self, " team has the flag!\n");
			}
		} 
		else sprint (self, "The flag is screwed up!\n");
		return;
	}

	// normal CTF
	if (deathmatch == DM_CTF)
	{
		// Find the flags at home base
		flag1 = find (world,classname, "item_flag_team1");
		flag2 = find (world,classname, "item_flag_team2");

		// If on team 2 switch meanings of flags
		if (self.team != TEAM1) 
		{
			p = flag1;
			flag1 = flag2;
			flag2 = p;
		}

		if (flag1 != world && flag1.cnt == FLAG_CARRIED) 
		{
			sprint (self, flag1.owner.netname);
			sprint (self, " has your flag. ");
		} 
		else 
		{
			sprint (self, "Your flag is ");
			if (flag1 == world) sprint (self, "missing!\n");
			if (flag1.cnt == FLAG_AT_BASE) sprint (self, "in your base.\n");
			else if (flag1.cnt == FLAG_DROPPED) sprint (self, "lying about.\n");
			else sprint (self, " corrupt.\n");
		}

		if (flag2 != world && flag2.cnt == FLAG_CARRIED) 
		{
			if (self == flag2.owner) sprint (self, "You have the enemy flag.\n");
			else 
			{
				sprint (self, flag2.owner.netname);
				sprint (self, " has the enemy flag.\n");
			}
		}
		else 
		{
			sprint (self, "The enemy flag is ");
			if (flag2 == world) sprint(self, "missing!\n");
			if (flag2.cnt == FLAG_AT_BASE) sprint (self, "in their base.\n");
			else if (flag2.cnt == FLAG_DROPPED) sprint (self, "lying about.\n");
			else sprint (self, " corrupt.\n");
		}
	}

/*
	// three team CTF
	if (teamplay == TEAM_CTF_ALT) 
	{
		// Find the flags at home base
		flag1 = find (world,classname, "item_flag_team1");
		flag2 = find (world,classname, "item_flag_team2");

		if (flag1 != world && flag1.cnt == FLAG_CARRIED) 
		{
			if (flag1.owner == self) sprint (self, "You have the RED flag!\n");
			else 
			{
				sprint (self, flag1.owner.netname);
				n = GetCTFTeam(flag1.owner.steam);
				sprint (self, " of the ");
				sprint (self, n);
				sprint (self, " team has the RED flag.\n");
			}
		} 
		else 
		{
			if (self.steam == flag1.team) sprint (self, "Your flag is ");
			else sprint(self, "RED flag is ");
			if (flag1 == world) sprint (self, "missing!\n");
			if (flag1.cnt == FLAG_AT_BASE) sprint (self, "at base.\n");
			else if (flag1.cnt == FLAG_DROPPED) sprint (self, "lying about.\n");
			else sprint (self, " corrupt.\n");
		}

		if (flag2 != world && flag2.cnt == FLAG_CARRIED) 
		{
			if (flag2.owner == self) sprint (self, "You have the BLUE flag.\n");
			else 
			{
				sprint (self, flag2.owner.netname);
				n = GetCTFTeam(flag2.owner.steam);
				sprint (self, " of the ");
				sprint (self, n);
				sprint (self, " team has the BLUE flag.\n");
			}
		} 
		else 
		{
			if (self.steam == flag1.team) sprint (self, "Your flag is ");
			else sprint (self, "BLUE flag is ");
			if (flag2 == world) sprint (self, "missing!\n");
			if (flag2.cnt == FLAG_AT_BASE) sprint (self, "at base.\n");
			else if (flag2.cnt == FLAG_DROPPED) sprint (self, "lying about.\n");
			else sprint (self, " corrupt.\n");
		}
	}
*/
};

/////////////////////////////////////////////////////////////////////////

$cd id1/models/flag
$base base
$skin skin

void() place_flag = 
{
	if (!deathmatch)
	{
		remove(self);
		return;
	}
	self.mdl = self.model;						// so it can be restored on respawn
	self.flags |= FL_OBJECTIVE;	// make extra wide
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;	
	self.velocity = '0 0 0';
	self.origin_z = self.origin_z + 6;
	self.think = TeamFlagThink;
	self.touch = TeamFlagTouch;
	self.nextthink = time + 0.1;
	self.cnt = FLAG_AT_BASE;
	self.mangle = self.angles;
//	self.effects |= EF_DIMLIGHT;
	if (self.team == TEAM1) self.effects |= EF_RED;
	if (self.team == TEAM2) self.effects |= EF_BLUE;
	self.effects |= EF_DIMLIGHT;
	if (!droptofloor())
	{
		dprint ("Flag fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
		return;
	}
	self.oldorigin = self.origin; // save for flag return
};

void(entity flg, string cname) place_flagbase = 
{
	if (!deathmatch) 
	{
		remove(self);
		return;
	}
		
	local entity oself = self;
	
	self = spawn();
	self.classname = cname;
	setorigin(self, flg.origin);
	self.angles = flg.angles;
	precache_model ("progs/ctfbase.mdl");
	setmodel (self, "progs/ctfbase.mdl");
	self.skin = flg.skin;
	self.team = flg.team;
//	setsize(self, '-8 -8 -4', '8 8 4');
	setsize(self, '-8 -8 0', '8 8 8');
	self.flags = FL_ITEM;		// make extra wide
	self.movetype = MOVETYPE_TOSS;	
	self.velocity = '0 0 0';
	self.origin_z = self.origin_z + 6;
	if (deathmatch == DM_OneFlagCTF)
	{
		self.solid = SOLID_TRIGGER;
		self.touch = TeamFlagBaseTouch;
	} 
	else self.solid = SOLID_NOT;
	if (!droptofloor()) 
	{
		dprint ("Flagbase fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
		self = oself;
		return;
	}
	self = oself;
};

// ZOID Capture the flag
/*QUAKED item_flag_team1 (0 .5 .8) (-8 -8 -32) (8 8 24)
red team flag
Only appears in CTF teamplay

The flag waves 90 degrees off from the entity angle. If
you want the flag to point at 180, set then entity angle
to 90.
*/
void() item_flag_team1 =
{
	if (!deathmatch) 
	{
		remove(self);
		return;
	}

	if (deathmatch == DM_OneFlagCTF) 
	{
		precache_sound ("misc/flagtk.wav");		// flag taken
		precache_sound ("misc/flagcap.wav");	// flag capture
		self.skin = 0;
		self.team = TEAM1;
		place_flagbase (self, "item_flagbase_team1");
		remove (self);
		return;
	}

	if (deathmatch == DM_CTF)
	{
		self.team = TEAM1;
		self.items = IT_KEY2;
		precache_model ("progs/ctfmodel.mdl");
		setmodel (self, "progs/ctfmodel.mdl");
		self.skin = 0;
		precache_sound ("misc/flagtk.wav");		// flag taken
		precache_sound ("misc/flagcap.wav");	// flag capture
		precache_sound ("misc/flagret.wav");	// flag return
		self.noise = "misc/flagtk.wav";
		self.noise1 = "misc/flagret.wav";
		setsize (self, '-16 -16 0', '16 16 74');
		self.nextthink = time + 0.2;	// items start after other solids
		self.think = place_flag;
		place_flagbase (self, "item_flagbase_team1");
	} 
	else remove(self); // not teamplay or deathmatch
};

/*QUAKED item_flag_team2 (0 .5 .8) (-8 -8 -32) (8 8 24)
blue team flag
Only appears in CTF teamplay

The flag waves 90 degrees off from the entity angle. If
you want the flag to point at 180, set then entity angle
to 90.
*/
void() item_flag_team2 =
{
	if (!deathmatch) 
	{
		remove (self);
		return;
	}
	
	if (deathmatch == DM_OneFlagCTF)
	{
		precache_sound ("misc/flagtk.wav");	// flag taken
		precache_sound ("misc/flagcap.wav");	// flag capture
		self.team = TEAM2;
		self.skin = 1;
		place_flagbase (self, "item_flagbase_team2");
		remove (self);
		return;
	}
	if (deathmatch == DM_CTF)
	{
		self.team = TEAM2;
		self.items = IT_KEY1;
		precache_model ("progs/ctfmodel.mdl");
		setmodel (self, "progs/ctfmodel.mdl");
		self.skin = 1;
		precache_sound ("misc/flagtk.wav");	// flag taken
		precache_sound ("misc/flagcap.wav");	// flag capture
		precache_sound ("misc/flagret.wav");	// flag return
		self.noise = "misc/flagtk.wav";
		self.noise1 = "misc/flagret.wav";
		setsize(self, '-16 -16 0', '16 16 74');
		self.nextthink = time + 0.2;		// items start after other solids
		self.think = place_flag;
		place_flagbase (self, "item_flagbase_team2");
	} 
	else remove (self); // not teamplay or deathmatch
};

/*QUAKED item_flag (0 .5 .8) (-8 -8 -32) (8 8 24)
flag for OneTeam play.
Only appears in CTF teamplay

The flag waves 90 degrees off from the entity angle. If
you want the flag to point at 180, set then entity angle
to 90.
*/
void() item_flag = 
{
	if (!deathmatch) 
	{
		remove(self);
		return;
	}
	if (deathmatch != DM_OneFlagCTF)
	{
		remove (self);
		return;
	}
	
	self.team = 0; // no team
	self.items = IT_KEY1 | IT_KEY2;
//	precache_model ("progs/flag.mdl");
//	setmodel (self, "progs/flag.mdl");
	precache_model ("progs/ctfmodel.mdl");		// PGM 01/18/97
	setmodel (self, "progs/ctfmodel.mdl");		// PGM 01/18/97
	self.skin = 2;
	
	// ROGUE ------------------------------------------------------
	precache_sound ("misc/flagtk.wav");		// flag taken
	precache_sound ("misc/flagcap.wav");		// flag capture
	precache_sound ("misc/flagret.wav");		// flag return
	// ThreeWave CTF ----------------------------------------------	
//	precache_sound ("misc/flagtk_3wave.wav");
//	precache_sound ("misc/flagcap_3wave.wav");
//	precache_sound ("misc/flagret_3wave.wav");
	// ------------------------------------------------------------
	
	self.noise = "misc/flagtk.wav";
	self.noise1 = "misc/flagret.wav";
	setsize (self, '-16 -16 0', '16 16 74');
	self.nextthink = time + 0.2;			// items start after other solids
	self.think = place_flag;
	place_flagbase (self, "item_flagbase");
};

/*QUAKED info_player_team1 (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for CTF games team 1.
*/
void() info_player_team1 = {};

/*QUAKED info_player_team2 (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for CTF games team 2.
*/
void() info_player_team2 = {};

void() TeamSetUpdate = {nextteamupdtime = time + CTF_UPDATE_TIME;};

// void() TeamSetUpdate = {nextteamupdtime = time + 1;}; // Testing

// Track score. (FIXME: Sleeper: Would be easier in CSQC.)
void() TeamCheckScoreUpdate =
{
	local string s, ts1, ts2, ts3;

	if (nextteamupdtime > time) return;
	
	TeamSetUpdate();
	
	ts1 = GetCTFTeam(TEAM1);
	ts2 = GetCTFTeam(TEAM2);
	ts3 = GetCTFTeam(TEAM3);
	
	if (deathmatch == DM_TDM) // Track frags between teams in TDM
	{
		if (TeamScore[TEAM_RED_4] > TeamScore[TEAM_BLUE_13]) 
		{
			bprint (ts1);
			bprint (" team is leading by ");
			s = ftos(TeamScore[TEAM_RED_4] - TeamScore[TEAM_BLUE_13]);
			bprint (s);
			if (s != "1") bprint (" frags!\n");
			else bprint (" frag!\n");
		} 
		else if (TeamScore[TEAM_RED_4] < TeamScore[TEAM_BLUE_13]) 
		{
			bprint(ts2);
			bprint (" team is leading by ");
			s = ftos(TeamScore[TEAM_BLUE_13] - TeamScore[TEAM_RED_4]);
			bprint (s);
			if (s != "1") bprint (" frags!\n");
			else bprint (" frag!\n");
		} 
		else 
		{
			bprint (ts1);
			bprint (" and ");
			bprint (ts2);
			bprint (" teams are tied with ");
			s = ftos(TeamScore[TEAM_RED_4]);
			bprint (s);
			if (s != "1") bprint (" frags!\n");
			else bprint (" frag!\n");
		}
	} 
	
	if (deathmatch == DM_CTF || deathmatch == DM_OneFlagCTF) // Track captures between teams in CTF & One Flag CTF
	{		
		if (TeamScore[TEAM_RED_4] > TeamScore[TEAM_BLUE_13]) 
		{
			bprint (ts1);
			bprint (" team is leading by ");
			s = ftos(TeamScore[TEAM_RED_4] - TeamScore[TEAM_BLUE_13]);
			bprint (s);
			if (s != "1") bprint (" captures!\n");
			else bprint (" capture!\n");
		} 
		else if (TeamScore[TEAM_RED_4] < TeamScore[TEAM_BLUE_13]) 
		{
			bprint(ts2);
			bprint (" team is leading by ");
			s = ftos(TeamScore[TEAM_BLUE_13] - TeamScore[TEAM_RED_4]);
			bprint (s);
			if (s != "1") bprint (" captures!\n");
			else bprint (" capture!\n");
		} 
		else 
		{
			bprint (ts1);
			bprint (" and ");
			bprint (ts2);
			bprint (" teams are tied with ");
			s = ftos(TeamScore[TEAM_RED_4]);
			bprint (s);
			if (s != "1") bprint (" captures!\n");
			else bprint (" capture!\n");
		}
	}
};

/*QUAKED func_ctf_wall (0 .5 .8) ?
This is just a solid wall if not inhibitted
Only appears in CTF teamplay
*/
void() func_ctf_wall =
{
	if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF && !coop)
	{
		self.angles = '0 0 0';
		self.movetype = MOVETYPE_PUSH;	// So it doesn't get pushed by anything.
		self.solid = SOLID_BSP;
		setmodel (self, self.model);
	} 
	else remove(self);
};