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

void(entity temp_player) horde_set_keys; // yoder sept24
void() GibMonster;
float() HordeGetPlayersAlive;
void() SetSpecParms;
void() SetNewCoopParms;

// prototypes
void() W_WeaponFrame;
void() W_SetCurrentAmmo;
void() player_pain;
void() player_stand1;
void(vector org) spawn_tfog;
void(vector org, entity death_owner) spawn_tdeath;

float modelindex_eyes, modelindex_hammer;

const float NO_INTERMISSION = 1;

// Unused Vanilla Parms
// parm10
// parm14
// parm16

// Unused FTE Parms
// parm18 to parm62 unused.	

/*
=============================================================================

			LEVEL CHANGING / INTERMISSION

=============================================================================
*/

float intermission_running;
float intermission_exittime;

/*QUAKED info_intermission (1 0.5 0.5) (-16 -16 -16) (16 16 16)
This is the camera point for the intermission.
Use mangle instead of angle, so you can set pitch or roll as well as yaw.  'pitch roll yaw'
*/
void() info_intermission = {};
 
// MG1 ===============================================
void(entity e) intermission_clear_powerups =
{
	e.gravity = 1.0;

	// Remove ID1 powerups
	e.items (-) IT_QUAD | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT;
	e.super_damage_finished = 0;
	e.super_time = 0;
	e.invisible_finished = 0;
	e.invisible_time = 0;
	e.invincible_finished = 0;
	e.invincible_time = 0;
	e.radsuit_finished = 0;
	e.rad_time = 0;
	
	// Remove HIP powerups
	e.expansionitems (-) HIP_IT_WETSUIT | HIP_IT_EMPATHY_SHIELDS;
	e.wetsuit_finished = 0;
	e.wetsuit_time = 0;
	e.empathy_finished = 0;
	e.empathy_time = 0;
		
	// Remove ROGUE powerups
	e.expansionitems (-) DOE_ANTIGRAV | DOE_SHIELD;
	e.antigrav_finished = 0;
	e.antigrav_time = 0;
	e.shield_finished = 0;
	e.shield_time = 0;	
};
// ===================================================


// Sleeper: Save inventory for respawn in Cooperative.
void() SetRespawnParms =
{
	// Remove power ups
	self.items -= self.items & (IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD);
	self.expansionitems -= self.expansionitems & (HIP_IT_WETSUIT | HIP_IT_EMPATHY_SHIELDS | DOE_ANTIGRAV | DOE_SHIELD);
	
	// Gravity
	self.gravity = 1.0;
	
	// Sleeper: Dafuq you need Respawn Parms for?
//	if ((world.model == "maps/start.bsp") || (world.model == "maps/hipstart.bsp") || (world.model == "maps/rstart.bsp") ||
//	    (world.model == "maps/e5start.bsp") || (world.model == "maps/mgstart.bsp" || world.model == "maps/hub.bsp" || world.worldtype == WORLDTYPE_HUB))
	if (world.model == Start_Maplist[StartMaps()])
	{
		parm1 = parm15 = IT_SHOTGUN | IT_AXE;
		
		if (cvar("skill") == 4) parm2 = 50;
		else if (cvar("skill") == 5) parm2 = 125;
		else if (cvar("skill") <= 3) parm2 = 100;	
			
		parm3 = 0;
		parm4 = 25;
		parm5 = encodeparms (0, 0, 0);
		parm6 = encodeparms (0, 0, 0);	
		parm7 = 0;
		parm8 = IT_SHOTGUN;
		parm9 = 0;
		parm11 = 0;
		parm12 = self.steam;	// Save the current team of the player		
		parm17 = self.client_tags;
		parm63 = self.nqwSkin;
		parm64 = self.nqwCharacter;
		return;
	}
		
	parm1 = self.items;
	
	if (!cvar("customcoop") && !cvar("deathmatch"))
	{	
		// Co-Operative Health
		if (cvar("coop") == REIGNITED_COOP || cvar("coop") == ENHANCED_COOP)
		{
			// Health
			if (cvar("skill") == 4)
			{
				if (!cvar("horde")) parm2 = 50;
				else parm2 = 76; 
			}
			else if (cvar("skill") == 5)
			{
				if (!cvar("horde")) parm2 = 125;
				else parm2 = 151;
			}
			else if (cvar("skill") <= 3)	
			{
				if (!cvar("horde")) parm2 = 100;
				else parm2 = 126;
			}					
		}
		else if (cvar("coop") == CLASSIC_COOP)
		{
			// Health
			if (cvar("skill") == 4) parm2 = 50;
			else if (cvar("skill") == 5) parm2 = 125;
			else if (cvar("skill") <= 3) parm2 = 100;				
		}
		// Ammo restock		
		if (self.ammo_shells1 < 25) self.ammo_shells1 = 25;		
	}
	else if (cvar("customcoop") && !cvar("horde") && !cvar("deathmatch"))
	{
		if (cvar("coop") == REIGNITED_COOP)
		{
			// Health
			if (cvar("skill") == 4) parm2 = 76;
			else if (cvar("skill") == 5) parm2 = 151;
			else if (cvar("skill") <= 3) parm2 = 126;
			
			// Ammo restock	
			if (cvar("skill") <= 4)
			{			
				if (self.ammo_shells1 < 50) self.ammo_shells1 = 50;
				if (self.ammo_nails1 < 50) self.ammo_nails1 = 50;
			}
			else if (cvar("skill") == 5)
			{			
				if (self.ammo_shells1 < 25) self.ammo_shells1 = 25;
				if (self.ammo_nails1 < 30) self.ammo_nails1 = 30;
			}		
		}
		else if (cvar("coop") == CLASSIC_COOP || cvar("coop") == ENHANCED_COOP)
		{
			// Health
			if (cvar("skill") == 4) parm2 = 50;
			else if (cvar("skill") == 5) parm2 = 125;
			else if (cvar("skill") <= 3) parm2 = 100;
			
			// Ammo restock				
			if (self.ammo_shells1 < 25) self.ammo_shells1 = 25;	
		}								
	}
					
	parm3 = self.armorvalue;		
	parm4 = self.ammo_shells1;		
	parm5 = encodeparms (self.ammo_nails1, self.ammo_rockets1, self.ammo_cells1);
	parm6 = encodeparms (self.ammo_lava_nails, self.ammo_multi_rockets, self.ammo_plasma);	
	parm7 = self.expansionitems;
	parm8 = self.weapon;
	parm9 = self.armortype * 100;
        parm11 = self.ammo_slugs;
	parm12 = self.steam;	// Save the current team of the player	
	parm15 = self.weapons;
	parm17 = self.client_tags;
	parm63 = self.nqwSkin;
	parm64 = self.nqwCharacter;
};

// Sleeper: Inherit weapons and ammo from an existing player on the server when a brand new player connects to the server. Called in ClientConnect.
void() InheritParms =
{
	if (!cvar("campaign")) return;
	if (!cvar("coop")) return; // Sleeper: Inheriting inventory can only be used in Co-Op.
	if (world.model == "maps/start.bsp" || world.model == "maps/hipstart.bsp" || world.model == "maps/rstart.bsp" || world.model == "maps/e5start.bsp" || world.model == "maps/mgstart.bsp" || world.model == "maps/hub.bsp" || world.worldtype == WORLDTYPE_HUB)
		return; // Sleeper: Don't inherit inventory if a startmap.			
	if ((world.model == "maps/e1m1.bsp" || world.model == "maps/e2m1.bsp" || world.model == "maps/e3m1.bsp" || world.model == "maps/e4m1.bsp" || world.model == "maps/end.bsp") ||
	    (world.model == "maps/hip1m1.bsp" || world.model == "maps/hip2m1.bsp" || world.model == "maps/hip3m1.bsp") ||
	    (world.model == "maps/r1m1.bsp" || world.model == "maps/r2m1.bsp") ||
	    (world.model == "maps/e5m1.bsp") ||
	    (world.model == "maps/mge1m1.bsp" || world.model == "maps/mge2m1.bsp" || world.model == "maps/mge3m1.bsp" || world.model == "maps/mge4m1.bsp" || world.model == "maps/mge5m1.bsp" || world.model == "maps/mgend.bsp") ||
	    (world.model == "maps/dm1sp.bsp")) return; // Sleeper: Don't inherit inventory if the first map of any epsiode.
	    
	// Gravity
	self.gravity = 1.0;	    
		
	// Sleeper: Every brand new player entering the server will inherit inventory from the first player that entered the server.
	local entity new_player = find (world, classname, "player");
	if (cvar("campaign") >= ID1 && !cvar("deathmatch"))
	{
		while (new_player != world)
		{
			if (new_player != self)
			{
				// Sleeper: Copy only the weapons and ammo from an already existing player
				self.items |= new_player.items & ~(IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3 | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD);
				self.expansionitems |= new_player.expansionitems & ~(HIP_IT_WETSUIT | HIP_IT_EMPATHY_SHIELDS | DOE_ANTIGRAV | DOE_SHIELD);
				self.weapons |= new_player.weapons;
				self.keytaker = new_player.keytaker;
				parm1 = self.items;
						
				if (cvar("skill") == 4)
				{
					if (!cvar("horde")) parm2 = 50;
					else parm2 = 76;
				}
				else if (cvar("skill") == 5)
				{
					if (!cvar("horde")) parm2 = 125;
					else parm2 = 151; 
				}
				else if (cvar("skill") <= 3)	
				{
					if (!cvar("horde")) parm2 = 100;
					else parm2 = 126; 
				}

				parm3 = self.armorvalue;
					
				// Sleeper: Copy whatever ammo in the already existing player's inventory to the brand new player's inventory.
				if (cvar("skill") <= 4)
				{		
					self.ammo_shells1 = new_player.ammo_shells1;											
					self.ammo_nails1 = new_player.ammo_nails1;
					self.ammo_rockets1 =  new_player.ammo_rockets1;
					self.ammo_cells1 = new_player.ammo_cells1;
					self.ammo_lava_nails = new_player.ammo_lava_nails;
					self.ammo_multi_rockets = new_player.ammo_multi_rockets;
					self.ammo_plasma = new_player.ammo_plasma;
				}
				else if (cvar("skill") == 5) // Copy only half ammo from the already existing player's inventory to the brand new player's inventory.
				{
					self.ammo_shells1 = new_player.ammo_shells1 / 2;											
					self.ammo_nails1 = new_player.ammo_nails1 / 2;
					self.ammo_rockets1 = new_player.ammo_rockets1 / 2;
					self.ammo_cells1 = new_player.ammo_cells1 / 2;
					self.ammo_lava_nails = new_player.ammo_lava_nails / 2;
					self.ammo_multi_rockets = new_player.ammo_multi_rockets / 2;
					self.ammo_plasma = new_player.ammo_plasma / 2;
				}
				if (self.ammo_shells1 < 25) self.ammo_shells1 = 25; // Sleeper: Replenish shells.
										
				parm4 = self.ammo_shells1;							       // Shells	
				parm5 = encodeparms (self.ammo_nails1, self.ammo_rockets1, self.ammo_cells1);          // Nails, Rockets, Cells
				parm6 = encodeparms (self.ammo_lava_nails, self.ammo_multi_rockets, self.ammo_plasma); // Lava Nails, Multi-Rockets, Plasma-Rockets
				parm7 = self.expansionitems;                                                           // Mission Pack inventory
				parm8 = self.weapon = IT_SHOTGUN; 						       // Sleeper: Shotgun must be out when connecting to the server for the first time.
				parm9 = self.armortype * 100;
//				parm10 = 0;
				parm11 = self.ammo_slugs;				
				parm12 = -1; 									       // Selected Team				
				parm15 = self.weapons;
				parm17 = self.client_tags; 							       // Are we a brand new player anymore?
				dprint (self.netname, " inherited ", new_player.netname, "'s inventory\n");
				return;
			}
			new_player = find (new_player, classname, "player");
		}
	}
};

float reset_flag;

void() SetChangeParms =
{
	local float official_startmaps_pool	      = ((world.model == "maps/start.bsp") || (world.model == "maps/hipstart.bsp") || (world.model == "maps/rstart.bsp") ||
						         (world.model == "maps/e5start.bsp") || (world.model == "maps/mgstart.bsp" || world.worldtype == WORLDTYPE_HUB));
		                      
	local float official_endmaps_pool	      = ((world.model == "maps/end.bsp") || (world.model == "maps/hipend.bsp") || (world.model == "maps/rend.bsp") || (world.model == "maps/e5end.bsp") || (world.model == "maps/mgend.bsp"));
	
	local float official_mg1_finalepisodemap_pool = ((world.model == "maps/mge1m2.bsp" || world.model == "maps/mge2m2.bsp" || world.model == "maps/mge3m2.bsp" || world.model == "maps/mge4m2.bsp" || world.model == "maps/mge5m2.bsp"));

	if (reset_flag)
	{ 	
		setspawnparms (self);
		parm63 = self.nqwSkin;
//		parm64 = self.nqwCharacter;
		return;
	}	

	if (self.health <= 0 || deathmatch)
	{
		SetNewParms ();
//		parm10 = self.MOTDstay;
		if (parm17 & NEW_PLAYER_MOTD) parm17 -= parm17 & (NEW_PLAYER_MOTD);
		parm12 = self.steam;	// Save the current team of the player
		parm63 = self.nqwSkin;
		parm64 = self.nqwCharacter;
		return;
	}
	if (world.worldtype == WORLDTYPE_HUB)
	{
//		SetNewParms ();		// Resetting inventory in SetChangeParms so we don't reset our skins & player models when the map changes
//		parm10 = self.MOTDstay;
		if (parm17 & NEW_PLAYER_MOTD) parm17 -= parm17 & (NEW_PLAYER_MOTD);
		parm12 = self.steam;	// Save the current team of the player
		parm63 = self.nqwSkin;
		parm64 = self.nqwCharacter;		
		return;
	}
	
	self.items -= self.items & (IT_KEY1 | IT_KEY2 | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD);
	self.expansionitems -= self.expansionitems & (HIP_IT_WETSUIT | HIP_IT_EMPATHY_SHIELDS | DOE_ANTIGRAV | DOE_SHIELD);
	
	// Gravity
	self.gravity = 1.0;
	
	// Cap Health --------------------------------------------------------------------------------------------------------------------------------
	if (cvar("coop") >= 0 && !cvar("deathmatch"))
	{	
		// Sleeper: Force (all) player's/players health back up to their max health when leaving start maps, as long as the 
		// game type doesn't involve speedrunning.
		if (cvar("coop") != CLASSIC_COOP && !cvar("coop")) 
		{		
			if (official_startmaps_pool)
			{    	 
				if (cvar("sv_public") == 1 || !cvar("sv_public")) // Public Server
					self.health = self.max_health;
			}
		}
		else
		{
			if (self.health > self.max_health)		  	  // Reset Health back to the skill's Max Health if exceeded during changelevel
				self.health = self.max_health;	
			if (!cvar("horde"))
			{		
				if (cvar("skill") <= 4)				  // Skill 4 and below gets only one minimum health
				{
					if (self.health < self.max_health / 2)	  // Minimum Health
						self.health = self.max_health / 2;
				}
				else if (cvar("skill") == 5)			  // Skill 5 gets two minimum health
				{
					if (self.health > 25 && self.health < 50) // First Minimum Health
						self.health = 50;
					if (self.health < 25)			  // Second Minimum Health
						self.health = 25;
				}
			}
		}
	}
	// --------------------------------------------------------------------------------------------------------------------------------------------
	
	// Sleeper: Reset all essential stats so we don't reset our skins & player models using "changelevel".
	if (official_startmaps_pool || official_endmaps_pool || official_mg1_finalepisodemap_pool)
	{
		if (!cvar("horde") && !cvar("deathmatch"))
		{
			self.items = IT_SHOTGUN | IT_AXE;
			self.weapons = IT_SHOTGUN | IT_AXE;	
			self.armorvalue = 0;
			self.ammo_shells1 = 25;
			self.ammo_nails1 = 0;
			self.ammo_rockets1 = 0;
			self.ammo_cells1 = 0;
			self.ammo_lava_nails = 0;
			self.ammo_multi_rockets = 0;
			self.ammo_plasma = 0;
			self.ammo_slugs = 0;			
			self.expansionitems = 0;
			self.weapon = IT_SHOTGUN;
			self.armortype = 0;
			if (self.client_tags & NEW_PLAYER_MOTD) self.client_tags -= self.client_tags & (NEW_PLAYER_MOTD);
//			self.MOTDstay = 0;
		}
	}
	if (cvar("deathmatch"))
	{
		self.items = IT_SHOTGUN | IT_AXE;	
		self.weapons = IT_SHOTGUN | IT_AXE;	
		self.armorvalue = 0;
		self.max_health = 100;
		self.health = 126;
		self.ammo_shells1 = 25;
		self.ammo_nails1 = 0;
		self.ammo_rockets1 = 0;
		self.ammo_cells1 = 0;
		self.ammo_lava_nails = 0;
		self.ammo_multi_rockets = 0;
		self.ammo_plasma = 0;
		self.ammo_slugs = 0;
		self.expansionitems = 0;
		self.weapon = IT_SHOTGUN;
		self.armortype = 0;
		if (self.client_tags & NEW_PLAYER_MOTD) self.client_tags -= self.client_tags & (NEW_PLAYER_MOTD);
//		self.MOTDstay = 0;
	}		
	if (cvar("customcoop") && !cvar("deathmatch") && !cvar("horde"))
	{	
		if (cvar("coop") == REIGNITED_COOP || cvar("coop") == ENHANCED_COOP)
		{
//			self.items = IT_SHOTGUN | IT_AXE;
//			self.weapons = IT_SHOTGUN | IT_AXE;	
//			self.armorvalue = 0;
			self.ammo_shells1 = 50;
			self.ammo_nails1 = 50;
			self.ammo_rockets1 = 0;
			self.ammo_cells1 = 0;
			self.ammo_lava_nails = 0;
			self.ammo_multi_rockets = 0;
			self.ammo_plasma = 0;
			self.ammo_slugs = 0;
			self.expansionitems = 0;
			if (self.client_tags & NEW_PLAYER_MOTD) self.client_tags -= self.client_tags & (NEW_PLAYER_MOTD);
//			self.weapon = IT_SHOTGUN;
//			self.armortype = 0;
//			self.MOTDstay = 0;
		}
		if (cvar("coop") == CLASSIC_COOP)
		{
			self.items = IT_SHOTGUN | IT_AXE;	
			self.weapons = IT_SHOTGUN | IT_AXE;
			self.armorvalue = 0;
			self.ammo_shells1 = 25;
			self.ammo_nails1 = 0;
			self.ammo_rockets1 = 0;
			self.ammo_cells1 = 0;
			self.ammo_lava_nails = 0;
			self.ammo_multi_rockets = 0;
			self.ammo_plasma = 0;
			self.ammo_slugs = 0;
			self.expansionitems = 0;
			self.weapon = IT_SHOTGUN;
			self.armortype = 0;
			if (self.client_tags & NEW_PLAYER_MOTD) self.client_tags -= self.client_tags & (NEW_PLAYER_MOTD);
//			self.MOTDstay = 0;
		}
		if (gameworld >= ID1 && gameworld <= APOTHEOSIS) // Sleeper: Not sure why I gotta do this, but it's better to remove anything necessary before going back to the campaign maps while custom coop was still active.
		{
			self.items = IT_SHOTGUN | IT_AXE;
			self.weapons = IT_SHOTGUN | IT_AXE;	
			self.armorvalue = 0;
			self.ammo_shells1 = 25;
			self.ammo_nails1 = 0;
			self.ammo_rockets1 = 0;
			self.ammo_cells1 = 0;
			self.ammo_lava_nails = 0;
			self.ammo_multi_rockets = 0;
			self.ammo_plasma = 0;
			self.ammo_slugs = 0;
			self.expansionitems = 0;
			self.weapon = IT_SHOTGUN;
			self.armortype = 0;
			if (self.client_tags & NEW_PLAYER_MOTD) self.client_tags -= self.client_tags & (NEW_PLAYER_MOTD);
//			self.MOTDstay = 0;
		}
		if (cvar("deathmatch"))
		{
			self.items = IT_SHOTGUN | IT_AXE;	
			self.weapons = IT_SHOTGUN | IT_AXE;	
			self.armorvalue = 0;
			self.max_health = 100;
			self.health = 126;
			self.ammo_shells1 = 25;
			self.ammo_nails1 = 0;
			self.ammo_rockets1 = 0;
			self.ammo_cells1 = 0;
			self.ammo_lava_nails = 0;
			self.ammo_multi_rockets = 0;
			self.ammo_plasma = 0;
			self.ammo_slugs = 0;
			self.expansionitems = 0;
			self.weapon = IT_SHOTGUN;
			self.armortype = 0;
			if (self.client_tags & NEW_PLAYER_MOTD) self.client_tags -= self.client_tags & (NEW_PLAYER_MOTD);
//			self.MOTDstay = 0;
		}		
	}					
			
	teamplay = cvar("teamplay");
	if (cvar("deathmatch")) SetNewParms (); // don't carry items between levels in CTF
	else 
	{	
		parm1 = self.items;
		parm2 = self.health;
		parm3 = self.armorvalue;
		
		// Restock ammo
		if (!cvar("customcoop") && !cvar("deathmatch") && cvar("coop") >= 0)
		{
			if (self.ammo_shells1 < 25) self.ammo_shells1 = 25;
		}
		else if (cvar("customcoop") && !cvar("deathmatch"))
		{
			if (cvar("coop") == REIGNITED_COOP)
			{
				if (cvar("skill") <= 4)
				{
					if (self.ammo_shells1 < 50) self.ammo_shells1 = 50;
					if (self.ammo_nails1 < 50) self.ammo_nails1 = 50;
				}
				else if (cvar("skill") == 5)
				{
					if (self.ammo_shells1 < 25) self.ammo_shells1 = 25;
					if (self.ammo_nails1 < 30) self.ammo_nails1 = 30;
				}				
			}
			else if (cvar("coop") == CLASSIC_COOP || cvar("coop") == ENHANCED_COOP)
			{
				if (self.ammo_shells1 < 25) self.ammo_shells1 = 25;
			}
		}		
		
		parm4 = self.ammo_shells1;		
		parm5 = encodeparms (self.ammo_nails1, self.ammo_rockets1, self.ammo_cells1);
		parm6 = encodeparms (self.ammo_lava_nails, self.ammo_multi_rockets, self.ammo_plasma);
		parm7 = self.expansionitems;
		parm8 = self.weapon;
		parm9 = self.armortype * 100;
		
		// MOTD sound and greetings
//		parm10 = self.MOTDstay;
                parm11 = self.ammo_slugs;	
		//ZOID--		
		parm12 = self.steam;	// Save the current team of the player
		//--ZOID
		
		// For the speedrunning gametype(s) to keep track of time
		if (!cvar("coop") || cvar("coop") == CLASSIC_COOP)
		{
			if (!cvar("deathmatch") && cvar("sv_public") == 1) parm13 = totaltime;
		}
		
		parm15 = self.weapons;
		parm17 = self.client_tags;
		
		// NQW Parms
		parm63 = self.nqwSkin;
		parm64 = self.nqwCharacter;
	}
};

void() SetNewParms =
{
	if (cvar("deathmatch") >= DM_CTF && cvar("deathmatch") <= DM_OneFlagCTF && !cvar("coop")) 
	{
		if (world.model == "maps/ctf1.bsp") // Sleeper: Some maps have added protection. Thanks Rogue.
		{
			parm1  = IT_SHOTGUN | IT_AXE | IT_ARMOR1;	
			parm3  = 50;
			parm4  = 25;						// Shells
			parm8  = IT_SHOTGUN;
			parm15 = IT_SHOTGUN | IT_AXE;	
			parm9  = 30;
			parm11 = 0;						// Uranium Slugs
		}
		else
		{
			parm1 = parm15 = IT_SHOTGUN | IT_AXE;
			parm3 = 0;
			parm4 = 25;						// Shells
			parm8 = IT_SHOTGUN;
			parm9 = 0;
			parm11 = 0;						// Uranium Slugs
		}
	}
	else if (cvar("instagib") && !cvar("coop"))
	{
		parm1 = 0;
		parm3 = 0;
		parm4 = 0;						// Shells
		parm8 = parm15 = NQW_IT_COILGUN;
		parm9 = 0;
/*		if (cvar("instagib") == 2) parm11 = 666;						// Uranium Slugs
		else*/ parm11 = 100;		
	}
	else
	{
		parm1 = parm15 = IT_SHOTGUN | IT_AXE;
		parm3 = 0;
		parm4 = 25;						// Shells
		parm8 = IT_SHOTGUN;
		parm9 = 0;
		parm11 = 0;						// Uranium Slugs
	}
	
	// Deathmatch Health	
	if (cvar("deathmatch") && !cvar("coop")) parm2 = 126;	// Similar to Quake 3
	else 
	{
		// Single Player & Co-Operative Health
		if (!cvar("customcoop") && !cvar("deathmatch"))
		{	
			if (cvar("coop") <= REIGNITED_COOP || cvar("coop") == ENHANCED_COOP)
			{
				if (cvar("skill") == 4)
				{
					if (!cvar("horde")) parm2 = 50;
					else parm2 = 76;
				}
				else if (cvar("skill") == 5)
				{
					if (!cvar("horde")) parm2 = 125;
					else parm2 = 151; 
				}
				else if (cvar("skill") <= 3)	
				{
					if (!cvar("horde")) parm2 = 100;
					else parm2 = 126; 
				}					
			}
			else if (cvar("coop") == CLASSIC_COOP)
			{	
				if (cvar("skill") == 4) parm2 = 50;
				else if (cvar("skill") == 5) parm2 = 125;
				else if (cvar("skill") <= 3) parm2 = 100;				
			}	
		}
	}
	
	parm5 = encodeparms (0, 0, 0); 				// Nails, Rockets, Cells
	parm6 = encodeparms (0, 0, 0); 			        // Lava Nails, Multi-Rockets, Plasma Rockets
	parm7 = 0;
//	parm10 = 1;
	//ZOID--
	parm12 = -1; 						// Reset current team selection	
	//--ZOID
	
/*	if (!cvar("deathmatch") && cvar("sv_public") == 1)
	{
		if (!cvar("coop") || cvar("coop") == CLASSIC_COOP) parm13 = cvar("samelevel");
	}
*/		
	parm17 = NEW_PLAYER_INIT | DETECT_NEW_CLIENT | CLIENT_PLAYER | CLIENT_ENTERED | CLIENT_JOINED | NEW_PLAYER_MOTD;	
};

// New Episode Parms
void() SetNewCoopParms =
{
	if (cvar("deathmatch")) return;

	parm15 = self.weapons | IT_SHOTGUN | IT_AXE;
	parm1  = self.items   | IT_SHOTGUN | IT_AXE; // Sleeper: Start episode with Axe and Shotgun, and keep items after dying.
	
	// Single Player & Co-Operative Health
	if (cvar("coop") <= REIGNITED_COOP || cvar("coop") == ENHANCED_COOP)
	{
		if (cvar("skill") == 4)      // KEX's Nightmare! skill (Skill 3 with a 50 health handicap and less aggressive monsters)
		{
			if (!cvar("horde")) parm2 = 50;
			else parm2 = 76;  // Deflatable health for Horde Mode.
		}
		else if (cvar("skill") == 5) // Sleeper Must Die! skill (Higher monster density, +25 standard max health, and Quake II style armors with armor rot).
		{
			if (!cvar("horde")) parm2 = 125;
			else parm2 = 151; // Deflatable health for Horde Mode.
		}
		else if (cvar("skill") <= 3) // Standard Skills.	
		{
			if (!cvar("horde")) parm2 = 100;
			else parm2 = 126; // Deflatable health for Horde Mode.
		}					
	}
	else if (cvar("coop") == CLASSIC_COOP)
	{
		if (cvar("skill") == 4) parm2 = 50;
		else if (cvar("skill") == 5) parm2 = 125;
		else if (cvar("skill") <= 3) parm2 = 100;				
	}	
				
	parm3 = self.armorvalue;
	
	// Restock shells.		
	if (self.ammo_shells1 < 25) self.ammo_shells1 = 25;
		
	parm4 = self.ammo_shells1;		
	parm5 = encodeparms (self.ammo_nails1, self.ammo_rockets1, self.ammo_cells1);	
	parm6 = encodeparms (self.ammo_lava_nails, self.ammo_multi_rockets, self.ammo_plasma);	
	parm7 = self.expansionitems;	
	parm8 = self.weapon;
	parm9 = self.armortype * 100;
//	parm10 = 0;
        parm11 = self.ammo_slugs;	
	parm12 = self.steam;	// Save the current team of the player
	parm17 = DETECT_NEW_CLIENT | CLIENT_PLAYER | CLIENT_ENTERED | CLIENT_JOINED;
	
/*	if (!cvar("deathmatch") && cvar("sv_public") == 1)
	{
		if (!cvar("coop") || cvar("coop") == 2) parm13 = cvar("samelevel");
	}
*/	
};

// Custom Map Coop Parms
void() SetNewCustomCoopParms =
{
	if (cvar("coop") == REIGNITED_COOP) // Reignited Custom Coop
	{	
		// Sleeper: Starter armor.
		if (cvar("skill") == 0)
		{
			if (self.items & (IT_ARMOR2 | IT_ARMOR3))
			{
				if (self.armorvalue < 75) // Restock armor with a starter.
				{
					self.items -= self.items & (IT_ARMOR2 | IT_ARMOR3);
					self.items |= IT_ARMOR1;
					parm3 = 75;	
					parm9 = self.armortype * 30;
				}
			}
			else
			{
				self.items |= IT_ARMOR1;
				if (self.armorvalue <= 75) parm3 = 75; // Restock armor with a starter.	
				parm9 = self.armortype * 30;		
			}				
		}
		else if (cvar("skill") == 1 || cvar("skill") == 4)
		{
			if (self.items & (IT_ARMOR2 | IT_ARMOR3)) // Restock armor with a starter.
			{
				if (self.armorvalue < 50)
				{
					self.items -= self.items & (IT_ARMOR2 | IT_ARMOR3);
					self.items |= IT_ARMOR1;
					parm3 = 50;
					parm9 = self.armortype * 30;
				}
			}
			else
			{
				self.items |= IT_ARMOR1;
				if (self.armorvalue < 50) parm3 = 50;	// Restock armor with a starter.
				parm9 = self.armortype * 30;	
			}			
		}
		else if (cvar("skill") == 2 || cvar("skill") == 3)
		{
			if (self.items & (IT_ARMOR2 | IT_ARMOR3)) // Restock armor with a starter.
			{
				if (self.armorvalue < 25)
				{
					self.items -= self.items & (IT_ARMOR2 | IT_ARMOR3);
					self.items |= IT_ARMOR1;
					parm3 = 25;	
					parm9 = self.armortype * 30;
				}
			}
			else
			{
				self.items |= IT_ARMOR1;
				if (self.armorvalue < 25) parm3 = 25; // Restock armor with a starter.
				parm9 = self.armortype * 30;
			}							
		}		
		
		// Custom Coop weapon loadout	
		self.items   |= IT_NAILGUN | IT_SUPER_SHOTGUN | IT_SHOTGUN | IT_AXE;
		self.weapons |= IT_NAILGUN | IT_SUPER_SHOTGUN | IT_SHOTGUN | IT_AXE;				
						
		// Add spawn protection to a player when they spawn/respawn
		self.spawn_protection_finished = time + 5;
		self.spawn_protection_time = 1;							
								
		// Deflatable health
		if (cvar("skill") <= 3) parm2 = 126;	
		else if (cvar("skill") == 4) parm2 = 76;
		else if (cvar("skill") == 5) parm2 = 151;
		
		// Restock ammo
		if (cvar("skill") >= 0 && cvar("skill") <= 4)
		{
			if (self.ammo_shells1 < 50) self.ammo_shells1 = 50; 				
			if (self.ammo_nails1 < 50) self.ammo_nails1 = 50;
		}
		else if (cvar("skill") == 5)
		{
			if (self.ammo_shells1 < 25) self.ammo_shells1 = 25;
			if (self.ammo_nails1 < 30) self.ammo_nails1 = 30;
		}   
	}
	else if (!cvar("coop") || cvar("coop") == CLASSIC_COOP || cvar("coop") == ENHANCED_COOP) // Classic Custom Coop/Single Player
	{	
		// Shotgun Start + Keep inventory if you die
		self.items   |= IT_SHOTGUN | IT_AXE;
		self.weapons |= IT_SHOTGUN | IT_AXE;
		
		// Starter Health		
		if (cvar("skill") <= 3) parm2 = 100;	
		else if (cvar("skill") == 4) parm2 = 50;
		else if (cvar("skill") == 5) parm2 = 125;
			
		// Restock ammo	
		if (self.ammo_shells1 < 25) self.ammo_shells1 = 25;
		parm9 = self.armortype * 100;								
	}	
	
	// Sleeper: Inherit keys if any were taken from the world.
	local entity all_players = find (world, classname, "player");
	while (all_players != world)
	{
		if (all_players != self)
		{
			if (all_players.items & IT_KEY1 && (!(self.items & IT_KEY1))) self.items |= IT_KEY1;
			if (all_players.items & IT_KEY2 && (!(self.items & IT_KEY2))) self.items |= IT_KEY2;
		}
		all_players = find (all_players, classname, "player");
	}	
	
	parm1 = self.items;	
//	parm2 = self.health;			
//	parm3 = self.armorvalue;			
	parm4 = self.ammo_shells1;			
	parm5 = encodeparms (self.ammo_nails1, self.ammo_rockets1, self.ammo_cells1);	
	parm6 = encodeparms (self.ammo_lava_nails, self.ammo_multi_rockets, self.ammo_plasma);	
	parm7 = self.expansionitems;	
	parm8 = self.weapon;
//	parm10 = 0;
        parm11 = self.ammo_slugs;	
	parm12 = self.steam;	// Save the current team of the player	
	parm15 = self.weapons;
	parm17 = DETECT_NEW_CLIENT | CLIENT_PLAYER | CLIENT_ENTERED | CLIENT_JOINED;
	
/*	if (!cvar("deathmatch") && cvar("sv_public") == 1)
	{
		if (!cvar("coop") || cvar("coop") == CLASSIC_COOP) parm13 = cvar("samelevel");
	}	
*/		
};

// New Episode Parms
void() SetSpecParms =
{
	parm1 = 0;
	parm2 = 1;			
	parm3 = 0;	
	parm4 = 0;		
	parm5 = encodeparms (0, 0, 0);	
	parm6 = encodeparms (0, 0, 0);	
	parm7 = 0;	
	parm8 = 0;
	parm9 = 0;
	parm11 = 0;	
	parm12 = -1;	// Save the current team of the player
	parm15 = 0;
	parm17 = DETECT_NEW_CLIENT | CLIENT_SPECTATOR | CLIENT_SPECTATOR_ENTERED | CLIENT_SPECTATOR_JOINED;	
};

void() DecodeLevelParms =
{
	local float firstlevelmaps = ((world.model == "maps/e1m1.bsp" || world.model == "maps/e2m1.bsp" || world.model == "maps/e3m1.bsp" || world.model == "maps/e4m1.bsp" || world.model == "maps/end.bsp") ||
				      (world.model == "maps/hip1m1.bsp" || world.model == "maps/hip2m1.bsp" || world.model == "maps/hip3m1.bsp") || 
				      (world.model == "maps/r1m1.bsp" || world.model == "maps/r2m1.bsp") ||
				      (world.model == "maps/e5m1.bsp") ||
		                      (world.model == "maps/mge1m1.bsp" || world.model == "maps/mge2m1.bsp" || world.model == "maps/mge3m1.bsp" || world.model == "maps/mge4m1.bsp" || world.model == "maps/mge5m1.bsp" || world.model == "maps/mgend.bsp"));                 
	
	// iD1 / HIPNOTIC / ROGUE / DOPA / MG1 Start Maps ----------------------------------------------------------------------------------------------------------------		
	if (/*serverflags && */!customcoop_flags && !deathmatch && !cvar("horde"))
	{	
		if (world.model == Start_Maplist[StartMaps()] || world.worldtype == WORLDTYPE_HUB) SetNewParms ();		 // Take away all stuff on start maps	
	}	  
	// iD1 / HIPNOTIC / ROGUE / DOPA / MG1 Episodes Maps -------------------------------------------------------------------------------------------------------------                   
	if (firstlevelmaps && !deathmatch && !customcoop_flags && !cvar("horde"))
	{
		if (coop == REIGNITED_COOP || coop == ENHANCED_COOP) SetNewCoopParms (); // Take away all stuff on starting new episode, but also keep items & ammo you pick up in co-op after respawning
		else SetNewParms ();   	    	     			       		 // Take away all stuff on starting new episode
	}	
	// Custom Coop ---------------------------------------------------------------------------------------------------------------------------------------------------	
	if (customcoop_flags && !deathmatch && world.model != Start_Maplist[StartMaps()] && !firstlevelmaps && !cvar("horde"))
	{	
		if (coop == REIGNITED_COOP || coop == ENHANCED_COOP)
		{
			if (cvar("sv_public") == 1) SetNewCustomCoopParms ();		 // Start any custom map with a loadout	
			else SetNewCoopParms ();	 				 // Take away all stuff on starting new episode, but also keep items & ammo you pick up in co-op after respawning	
		}
		else SetNewParms ();
	}	
	// ---------------------------------------------------------------------------------------------------------------------------------------------------------------	

	// MG1: Yoder Oct25, reset weapons between map loads
	if (cvar("horde"))
	{
		if (coop == REIGNITED_COOP || coop == ENHANCED_COOP) SetNewCoopParms (); // Take away all stuff on starting new episode, but also keep items & ammo you pick up in co-op after respawning	
		else SetNewParms ();							 // Take away all stuff on starting new map
	}
	
	self.items = parm1;		
	self.health = parm2;			
	self.armorvalue = parm3;
	
	// Ammo ------------------------------------------- Type ----------- Pak ---		
	self.ammo_shells1 = parm4;			  // Shells	    (iD1)
	self.ammo_nails1 = decodeparms (parm5, 1);	  // Nails	    (iD1)
	self.ammo_rockets1 = decodeparms (parm5, 2);	  // Rockets	    (iD1)
	self.ammo_cells1 = decodeparms (parm5, 3);	  // Cells	    (iD1)
	self.ammo_lava_nails = decodeparms (parm6, 1);	  // Lava Nails    (ROGUE)
	self.ammo_multi_rockets = decodeparms (parm6, 2); // Multi-Rockets (ROGUE)
	self.ammo_plasma = decodeparms (parm6, 3);	  // Plasma	   (ROGUE)
	self.ammo_slugs = parm11;			  // Uranium Slugs (BASEQ2)
	// -------------------------------------------------------------------------
	
	self.expansionitems = parm7;
	
	// cute bug, if grapple was selected, it still will be on level change
	if (parm8 == DOE_GRAPPLE && deathmatch) self.weapon = IT_SHOTGUN; 
	else self.weapon = parm8;
//	self.weapon = parm8;

	self.armortype = parm9 * 0.01;
//	self.MOTDstay = parm10;	
	
	//ZOID--
	if (TeamColorIsLegal(parm12)) 
	{
		self.steam = parm12;
		TeamSetSkin ();
	}
	//--ZOID
			
	// For the speedrunning gametypes to keep track of time
	if (!cvar("deathmatch") && cvar("sv_public") == 1)
	{
		if (!cvar("coop") || cvar("coop") == CLASSIC_COOP)
		{
			if (mlstage == 0)
			{
				totaltime = parm13;
				numlevels = cvar("ambient_fade");
				if (numlevels == 100) numlevels = 0;
				mlstage = 1;
			}
			cvar_set ("ambient_fade", "100");
		}
	}
	
	self.weapons = parm15;
	self.client_tags = parm17;
		
	// NQW parms	
	self.nqwSkin = parm63;
	if (!(self.modelindex_nqwplayer))
	{
		self.nqwCharacter = parm64;
		self.nqwNextCharacter = parm64;
	}	
}; 
/*
============
FindIntermission

Returns the entity to view from
============
*/
entity() FindIntermission =
{
	local entity spot;
	local float cyc;

	// Look for info_intermission first
	spot = find (world, classname, "info_intermission");
	if (spot)
	{	
		// Pick a random one
		cyc = random() * 4;
		while (cyc > 1)
		{
			spot = find (spot, classname, "info_intermission");
			if (!spot) spot = find (spot, classname, "info_intermission");
			cyc -= 1;
		}
		
		return spot;
	}

	// Then look for the start position
	spot = find (world, classname, "info_player_start");
	if (spot) return spot;

	// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot) return spot;

	objerror ("FindIntermission: no spot");
	return world;
};

/*
MG1 ========
HORDE random map pick

added Aug31, 2021
============
*/
string() HordeRandomMap =
{
	local float cur;
	
	// Find the index of the current map
	for (; cur < RandomHordeMode_MapsList.length; ++cur)
	{
		if (world.model == RandomHordeMode_MapsList[cur]) break; 
	}

	// If the current map isn't in the list, pick any of them
	if (cur == RandomHordeMode_MapsList.length) return RandomHordeMode_MapsList[rint(random() * (RandomHordeMode_MapsList.length - 1))];

	// Offset from the current map with a min of 1 and a max of length -1 so that it'll never pick the current map
	cur = (cur + rint(random() * (RandomHordeMode_MapsList.length - 2)) + 1) % RandomHordeMode_MapsList.length;	
	return RandomHordeMode_MapsList[cur];
};

/*
string() HordeRandomMap =
{
	local string next_random_map = string_null;

	for (float loops = 0; loops < 8; loops++) // Sleeper: Loop a thousand times or more if the same map comes up twice.
	{	
		next_random_map = RandomHordeMode_MapsList[random() * RandomHordeMode_MapsList.length];	
		if (mapname != next_random_map) break; // Sleeper: If we didn't get the same map twice, break loop and use the new map.
	}	

	bprint (next_random_map, "\n");	
	return next_random_map;
};
*/

/*
string() CustomCoopRandomMaps =
{
	local string next_random_map = string_null;

	for (float loops = 0; loops < 161; loops++) // Sleeper: Loop a thousand times or more if the same map comes up twice.
	{	
		next_random_map = RandomCustomCoop_MapsList[random() * RandomCustomCoop_MapsList.length];
		if (mapname != next_random_map) break; // Sleeper: If we didn't get the same map twice, break loop and use the new map.
	}

	dprint ("choosing a random map from the Co-Op map pool\n");
	return next_random_map;
};
*/

string nextmap;
void() GotoNextMap =
{	
	// NQW ===================================================================================================================================
	// Redirect the next map to the Quake Enhanced version of E2M4 & E2M6 with the cut intro instead of the original E2M6
	// QUAKE ENHANCED (KEX) ------------------------------------------------------------------------------------------------------------------
	if (cvar("coop") <= ENHANCED_COOP && !cvar("deathmatch") && !cvar("sv_public")) 	     // Private Server/Single Player
	{
		if (mapname == "e2m3" && nextmap == "e2m4") changelevel ("e2m4_qe"); // E2M3 has secret map entrance, which would introduce confusion if you entered that teleporter and find yourself at the KEX version of E2M4 instead of the secret map
		if (world.model == "maps/e2m7.bsp") changelevel ("e2m4_qe"); // If we're in the secret map, our next map should be the KEX version of E2M4
		if (world.model == "maps/e2m5.bsp") changelevel ("e2m6_qe");
	}
	else if (cvar("coop") == REIGNITED_COOP || cvar("coop") == ENHANCED_COOP)
	{
		if (!cvar("deathmatch") && cvar("sv_public") == 1) // Public Server
		{
			if (mapname == "e2m3" && nextmap == "e2m4") changelevel ("e2m4_qe"); // E2M3 has secret map entrance, which would introduce confusion if you entered that teleporter and find yourself at the KEX version of E2M4 instead of the secret map
			if (world.model == "maps/e2m7.bsp") changelevel ("e2m4_qe"); // If we're in the secret map, our next map should be the KEX version of E2M4	
			if (world.model == "maps/e2m5.bsp") changelevel ("e2m6_qe");
		}
	}
	// ---------------------------------------------------------------------------------------------------------------------------------------
	// =======================================================================================================================================		
	
	if (cvar("samelevel")) changelevel (mapname); // if samelevel is set, stay on same level
	else if (cvar("horde")) changelevel (HordeRandomMap()); // MG1
	else if (cvar("customcoop")) changelevel (CustomCoopRandomMaps()); // NQW
	else changelevel (nextmap);	
};

.string endtext;
string intermissiontext;
float select_soundtrack_2;
float select_soundtrack_3;

void() ExitIntermission =
{
	local float official_maps = ((world.model == "maps/e5end.bsp") || 
				     (world.model == "maps/mge1m2.bsp" || world.model == "maps/mge2m2.bsp" || 
			              world.model == "maps/mge3m2.bsp" || world.model == "maps/mge4m2.bsp" || 
				      world.model == "maps/mge5m2.bsp" || world.model == "maps/mgend.bsp"));
		
	if (official_maps)
	{
		select_soundtrack_2 = 2;
		select_soundtrack_3 = 3;
	}

	if (deathmatch)
	{
		GotoNextMap();
		return;
	}		
	
	intermission_exittime = time + 1;
	intermission_running += 1;
	if (intermission_running == 2)
	{
		// iD1 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
		if (world.model == "maps/e1m7.bsp")
		{
			WriteByte(MSG_ALL, SVC_CDTRACK);
			WriteByte(MSG_ALL, 2);
			WriteByte(MSG_ALL, 3);
			if (!cvar("registered"))
			{
				WriteByte(MSG_ALL, SVC_FINALE);
				WriteString(MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task in the other three\nhaunted lands of Quake. Or are you? If\nyou don't register Quake, you'll never\nknow what awaits you in the Realm of\nBlack Magic, the Netherworld, and the\nElder World!\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue");
			}
			else
			{
				WriteByte(MSG_ALL, SVC_FINALE);
				WriteString(MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task. A Rune of magic\npower lies at the end of each haunted\nland of Quake. Go forth, seek the\ntotality of the four Runes!\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue");
			}
			return;
		}        // iD1's Original Map		   // iD1's KEX Map
		else if (world.model == "maps/e2m6.bsp" || world.model == "maps/e2m6_qe.bsp") // Sleeper: Added the version of E2M6 that has the cut intro that came with Quake Enhanced from 2021. Should be used when not in a speedrunning Game Type.
		{
			WriteByte(MSG_ALL, SVC_CDTRACK);
			WriteByte(MSG_ALL, 2);
			WriteByte(MSG_ALL, 3);
			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "The Rune of Black Magic throbs evilly in\nyour hand and whispers dark thoughts\ninto your brain. You learn the inmost\nlore of the Hell-Mother; Shub-Niggurath!\nYou now know that she is behind all the\nterrible plotting which has led to so\nmuch death and horror. But she is not\ninviolate! Armed with this Rune, you\nrealize that once all four Runes are\ncombined, the gate to Shub-Niggurath's\nPit will open, and you can face the\nWitch-Goddess herself in her frightful\notherworld cathedral.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue");
			return;
		}		
		else if (world.model == "maps/e3m6.bsp")
		{
			WriteByte(MSG_ALL, SVC_CDTRACK);
			WriteByte(MSG_ALL, 2);
			WriteByte(MSG_ALL, 3);
			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "The charred viscera of diabolic horrors\nbubble viscously as you seize the Rune\nof Hell Magic. Its heat scorches your\nhand, and its terrible secrets blight\nyour mind. Gathering the shreds of your\ncourage, you shake the devil's shackles\nfrom your soul, and become ever more\nhard and determined to destroy the\nhideous creatures whose mere existence\nthreatens the souls and psyches of all\nthe population of Earth.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue");
			return;
		}
		else if (world.model == "maps/e4m7.bsp")
		{
			WriteByte(MSG_ALL, SVC_CDTRACK);
			WriteByte(MSG_ALL, 2);
			WriteByte(MSG_ALL, 3);
			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "Despite the awful might of the Elder\nWorld, you have achieved the Rune of\nElder Magic, capstone of all types of\narcane wisdom. Beyond good and evil,\nbeyond life and death, the Rune\npulsates, heavy with import. Patient and\npotent, the Elder Being Shub-Niggurath\nweaves her dire plans to clear off all\nlife from the Earth, and bring her own\nfoul offspring to our world! For all the\ndwellers in these nightmare dimensions\nare her descendants! Once all Runes of\nmagic power are united, the energy\nbehind them will blast open the Gateway\nto Shub-Niggurath, and you can travel\nthere to foil the Hell-Mother's plots\nin person.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue");
			return;
		}
		// HIPNOTIC ------------------------------------------------------------------------------------------------------------------------------------------------------------------
		else if (world.model == "maps/hip1m4.bsp")
		{
			WriteByte(MSG_ALL, SVC_CDTRACK);
			WriteByte(MSG_ALL, 16);
			WriteByte(MSG_ALL, 13);
			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "Deep within the bowels of the\nResearch Facility, you discover the\npassage that the followers of Quake\nhave used to enter our world.\nThe bastards used some type of\ngigantic teleporter to overload\none of our own slipgates!  As long as\nthis portal exists, Earth will never\nbe safe from Quake's cruel minions.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue");
			return;
		}
		else if (world.model == "maps/hip2m5.bsp")
		{
			WriteByte(MSG_ALL, SVC_CDTRACK);
			WriteByte(MSG_ALL, 16);
			WriteByte(MSG_ALL, 13);
			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "After destroying the power generator,\nyou pass beyond the gate of Mortum's\nKeep.  A wave of nausea suddenly flows\nover you and you find yourself cast\nout into a liquid void.  You float\nlifelessly, yet aware, in a lavender\nsea of energy.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue");
			return;
		}
		else if (world.model == "maps/hipend.bsp")
		{
			WriteByte(MSG_ALL, SVC_CDTRACK);
			WriteByte(MSG_ALL, 12);
			WriteByte(MSG_ALL, 13);
			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "After the last echoes of Armagon's\ndeath yell fade away, you breathe a\nheavy sigh of relief.  With the loss\nof his magic, Armagon's fortress\nbegins to collapse.  The rift he\ncreated to send his grisly troops\nthrough time slowly closes and seals\nitself forever.  In the chaos that\nensues, a wall collapses, revealing\none remaining time portal.  With your\nchances to escape rapidly growing\nslim, you race for the portal,\nmindless of your destination.  In a\nflash of light, you find yourself\nback at Command HQ, safe and sound.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue");
			return;
		}
		// ROGUE ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
		else if (world.model == "maps/r1m7.bsp")
		{
			WriteByte(MSG_ALL, SVC_CDTRACK); // Added
			WriteByte(MSG_ALL, 22);
			WriteByte(MSG_ALL, 23);
			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "Victory! The Overlord's mangled\nremains are the evidence.  His evil\nWrath army?  Cast out to wander\naimlessly throughout time.\n\nAs the Slipgate fog surrounds you,\nthoughts rage into your consciousness:\nHas Quake's oppressive reign ended?\nIs it Salvation, or Damnation, which\nwaits beyond the Vortex?\n\nAnother thought, not quite your own,\nrazors through the haze.  \"Forgiveness\ncan yet be granted; Our Master remains\nto absolve your sins against his Chosen.\nFall down upon your knees-pray for\nQuake's mercy.\"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK\n to continue to Episode 2.");
			return;
		}
		// DOPA / MG1 ----------------------------------------------------------------------------------------------------------------------------------------------------------------
		else if (world.endtext) intermissiontext = world.endtext;
		if (intermissiontext)
		{
			if (world.model == "maps/e5end.bsp") nextmap = "mgstart";
			if (world.model == "maps/mgend.bsp") nextmap = "start";
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, select_soundtrack_2);
			WriteByte (MSG_ALL, select_soundtrack_3);
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, intermissiontext);
			intermissiontext = string_null;
			return;
		}
		// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------		
		GotoNextMap ();
	}
	if (intermission_running == 3)
	{
		// iD1 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
		if (!cvar("registered"))
		{
			// Shareware episode has been completed, go to sell screen
			WriteByte(MSG_ALL, SVC_SELLSCREEN);
			return;
		}   // iD1's Final Map of Ep. 1       // iD1's Final Map of Ep. 2       // iD1's KEX Final Map of Ep. 2	     // iD1's Final Map of Ep. 3       // iD1's Final Map of Ep. 4
		if (world.model == "maps/e1m7.bsp" || world.model == "maps/e2m6.bsp" || world.model == "maps/e2m6_qe.bsp" || world.model == "maps/e3m6.bsp" || world.model == "maps/e4m7.bsp")
		{
			if ((serverflags & 15) == 15)
			{
				WriteByte(MSG_ALL, SVC_FINALE);
				WriteString(MSG_ALL, "Now, you have all four Runes. You sense\ntremendous invisible forces moving to\nunseal ancient barriers. Shub-Niggurath\nhad hoped to use the Runes Herself to\nclear off the Earth, but now instead,\nyou will use them to enter her home and\nconfront her as an avatar of avenging\nEarth-life. If you defeat her, you will\nbe remembered forever as the savior of\nthe planet. If she conquers, it will be\nas if you had never been born.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue");
				return;
			}
		}	
		// HIPNOTIC ------------------------------------------------------------------------------------------------------------------------------------------------------------------
		else if (world.model == "maps/hip1m4.bsp")
		{
			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "If you can find the source of the\nportal's power, you can shut it\ndown--possibly forever!  With only a\nmoment's consideration for your own\nsafety, you re-enter the dark domain,\nknowing Hell would be a better fate\nthan experiencing the reign of Quake.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK\n to continue to Episode 2.");
			return;
		}
		else if (world.model == "maps/hip2m5.bsp")
		{
			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "After what seems like an eternity,\nyou feel the presence of a diabolical\nintelligence.  You are held helpless\nfor a moment as your mind is open to\nthat of Armagon--Quake's General and\nmaster of this realm.  Recognizing\nyou as the one who foiled his\nattempt to conquer Earth, a hellish\nhowl fills your mind and blots out\nall consciousness.  When you awake,\nyou find yourself on the shores of\nreality, but in a time and place\nunknown to you.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK\n to continue to Episode 3.");
			return;
		}
		else if (world.model == "maps/hipend.bsp")
		{
			nextmap = "rstart";
			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "Congratulations!  You are victorious!\nThe minions of Quake have once again\nfallen before your mighty hand.\nIs this the last you will see of\nQuake's hellions?\n\nOnly time will tell... \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue to...\n\n Dissolution of Eternity!\n");
			return;
		}
		// MG1 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		if ((serverflags & SIGIL_ALL) == SIGIL_ALL) 
		{
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "With all six runes in your possession\n you can feel their power surge\n through time and space.\n\n Ancient seals are broken as the path\n to your final challenge unlocks.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue.");
			return;
		}
		// ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	}
	GotoNextMap ();
};

/*
============
IntermissionThink

When the player presses attack or jump, change to the next level
============
*/
void() IntermissionThink =
{
	// Do QStats Patch v1.8 stuff
	if (!cvar("coop") || cvar("coop") == CLASSIC_COOP)
	{
		if (!deathmatch && cvar("sv_public") == 1)
		{
			if (!DisplayedExitMsg) ExitMessage(); // Display a recorded time down to the hundred thousandth of a second for speedrunning
		}
	}	

	if (time < intermission_exittime) return;
	if (!self.button0 && !self.button1 && !self.button2) return;

	ExitIntermission ();
};

void() execute_changelevel =
{
	local entity pos;
	
	intermission_running = 1;	
	if (deathmatch) intermission_exittime = time + 5;
	else intermission_exittime = time + 2;
	
	// Assign the soundtrack to the end of a level in the appropriate Game World
	WriteByte (MSG_ALL, SVC_CDTRACK);
	if (gameworld == HIPNOTIC)   // Scourge Of Armagon soundtrack
	{
		WriteByte (MSG_ALL, 19);
		WriteByte (MSG_ALL, 13);
	}
	else if (gameworld == ROGUE) // Dissolution Of Eternity soundtrack
	{
		WriteByte (MSG_ALL, 23);
		WriteByte (MSG_ALL, 23);
	}
	else 			     // The Offering soundtrack
	{
		WriteByte (MSG_ALL, 3);
		WriteByte (MSG_ALL, 3);
	}
		
	pos = FindIntermission ();
	other = find (world, classname, "player");
	while (other != world)
	{
		other.view_ofs = VEC_ORIGIN;
		other.v_angle = pos.mangle;
		other.angles = pos.mangle;
		other.fixangle = TRUE;
		other.nextthink = time + 0.5;
		other.takedamage = DAMAGE_NO;
		other.solid = SOLID_NOT;
		other.movetype = MOVETYPE_NONE;
		other.modelindex = FALSE;
		setorigin (other, pos.origin);
		other = find (other, classname, "player");
	}
	WriteByte (MSG_ALL, SVC_INTERMISSION);	
	
	// Yoder merge Horde sept24 2021
	if (horde_ent)
	{
		horde_ent.think = SUB_Null;
		horde_ent.nextthink = -1;
		
		other = find (world, category, CATEGORY_MONSTER);
		while (other != world)
		{
			//void(entity targ, entity inflictor, entity attacker, float damage)
			//T_Damage(other, world, world, 4000);
			other.think = GibMonster;
			other.nextthink = time + 0.2 + random() * 1.8;
			other = find (other, category, CATEGORY_MONSTER);
		}
	}

	if (self.spawnflags & NO_INTERMISSION) ExitIntermission (); // Go directly to intermission text.
};

/* // Sleeper: Just messing around with a trigger that would make you connect to a different server, when the changelevel trigger was touched. Just make sure to reset other.leaving_client to 0.
.float leaving_client;
void() Connect_To_Different_Server = 
{
	if (!other.leaving_client)
	{
		other.leaving_client = TRUE;
		stuffcmd (other, "connect nqw.quakelegacy.com:26000");
		bprint (other.netname, " has entered the Dimension Of The Doomed!\n");	
	}
};
*/

void() changelevel_touch =
{
	local entity pos;
			
	if (other.classname != "player") return;
		
	if (cvar("noexit") == 1 || cvar("noexit") == 2)
	{
		if (mapname != "start")
		{
			T_Damage (other, self, self, 50000);
			return;
		}
	}
	if (cvar("noexit") == 3) return;
			
	     if (coop && !deathmatch) bprint (other.netname, " exited the level\n");		
	else if (deathmatch && !coop) bprint (other.netname, " exited the arena\n");
	else if (!coop && !deathmatch && cvar("sv_public") == 1) bprint (other.netname, " cleared ", mapname, "\n");
				
	nextmap = self.map;
	
	// Sleeper: Moved DOPA's & MG1's endtexts to QuakeC instead of within the .ent file of the maps for more customization. (Probably will make a coop variant endtexts.)
	// DOPA --------------------------------------------
	if (mapname == "e5end") // DOPA | Episode 5 end text
	{
		self.endtext = "Congratulations and Well Done!\nYou have shown excellent skill,\ntravelling from one realm to another,\ndefeating vicious monsters and beasts.\nYou are a True Ranger.\nWe salute you.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue to...\n\n The Dimension Of The Machine!";
		intermissiontext = self.endtext;
	}
	// MG1 ---------------------------------------------
	if (mapname == "mge1m2") // MG1 | Episode 1 end text
	{
		self.endtext = "The Rune of the Machinists rends\n your mind with inscrutable patterns,\n blueprints of Chthon's design.\n\n Traveling beyond echoes of gears\n and chains, beyond the labyrinthine\n halls of the engine of pain,\n you awaken once again in\n The Machine\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue.";
		intermissiontext = self.endtext;
	}
	if (mapname == "mge2m2") // MG1 | Episode 2 end text
	{
		self.endtext = "With the heat of the Rune\n of Blacksmiths in your hand,\n you leave the smoldering ruins\n of this cursed realm behind you.\n\n The doomed denizens remaining will\n be fighting over the scraps of this\n dying world for some time yet.\n\n You hope that by collecting all\n the arcane runes you may return\n home, and save yourself from\n a similar fate.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue.";
		intermissiontext = self.endtext;
	}
	if (mapname == "mge3m2") // MG1 | Episode 3 end text
	{
		self.endtext = "As you make it out of the\n trap-filled and hellish underearth\n alive, you grab a firm hold of the\n Rune of the Stonemasons and bring it\n back to The Machine.\n\n You have conquered one of the most\n heavily guarded and monster-infested\n military fortifications of the\n entire dimension and you are now\n ready for any new challenge that\n Quake manages to throw your way!\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue.";
		intermissiontext = self.endtext;
	}
	if (mapname == "mge4m2" || mapname == "mge4m2b" || mapname == "mge4arena") // MG1 | Episode 4 end text
	{
		self.endtext = "From familiar halls and twisting\n geometry you have seen the world\n being turned on it's head.\n\n Leaving this realm of foul worship\n behind, you feel the bloodlust\n run through you, like a\n tremor in your soul.\n\n Yet again, being a cog in The Machine.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue.";
		intermissiontext = self.endtext;	
	}
	if (mapname == "mge5m2") // MG1 | Episode 5 end text
	{
		self.endtext = "Exalted Warrior from the Machine, you\n succeeded where the expedition failed.\n They came from beyind the stars on\n a black ship powered by captured suns.\n They found the oldest planet,\n filled their ship with the inhabitants.\n\n You delivered them vengeance.\n\n They dug out the ground at the holy\n site, not knowing how close they came.\n\n You hold the Rune of Astrologers,\n return to the machine.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue.";
		intermissiontext = self.endtext;
	}		
	if (mapname == "mgend") // MG1 | Ending Map end text
	{
		self.endtext = "Congratulations and Well Done!\n Once again you have defeated Chthon,\n the demon of fire and darkness,\n and the master of the underworld.\n You have shown great skill in\n taking down military death squads and\n hundreds of other ferocious monsters.\n\n You are more powerful than any threat\n Quake can manage to summon.\n You are the master now.\n\n We salute you.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue.";
		intermissiontext = self.endtext;
	}
	if ((mapname == "end" || gameworld >= HIPNOTIC && gameworld <= DOPA) || (mapname == "mgstart" || mapname == "mgend") || (cvar("customcoop"))) serverflags = 0; // Sleeper: Clear runes if required.
				
	if (self.spawnflags & (NO_INTERMISSION) && !deathmatch && self.endtext == string_null) // MG1 added endtext condition
	{
		GotoNextMap ();
		return;
	}	
	// -------------------------------------------------	
		
	SUB_UseTargets();
	
	if ((self.spawnflags & 1) && !deathmatch)
	{
		// Do QStats Patch v1.8 stuff
		if (coop == 0 || coop == CLASSIC_COOP)
		{
			if (!deathmatch && cvar("sv_public") == 1)
			{
				if (mapname == "start" || mapname == "hipstart" || mapname == "rstart" || mapname == "e5start" || mapname == "mgstart" || mapname == "hub")
				{
					if (!DisplayedExitMsg)
					{
						if (mapname == "start" || mapname == "hipstart" || mapname == "rstart" || mapname == "e5start" || mapname == "mgstart" || mapname == "hub")
						{	
							bprint ("\nQdQ Stats patch v1.8 (NQW Edition)\n");
							bprint ("\n");
							bprint ("=======================\n");
							OCD_Mapname_Prints ();
							bprint ("\n");
							if (cvar("skill") == 0)
							{
								bprint ("Skill(0)   : ");
								bprint ("Easy");
							}
							else if (cvar("skill") == 1)
							{
								bprint ("Skill(1)   : ");
								bprint ("Normal");
							}
							else if (cvar("skill") == 2)
							{ 
								bprint ("Skill(2)   : ");
								bprint ("Hard");
							}
							else if (cvar("skill") == 3)
							{
								bprint ("Skill(3)   : ");
								bprint ("Classic Nightmare!");
							}
							else if (cvar("skill") == 4)
							{
								bprint ("Skill(4)   : ");
								bprint ("KEX Nightmare!");
							}
							else if (cvar("skill") == 5)
							{
								bprint ("Skill(5)   : ");
								bprint ("Sleeper Must Die!");	
							}
							else if (cvar("skill") > 5 || cvar("skill") < 0)
							{
								bprint ("Skill(?)   : ");
								bprint ("Unknown");	
							}								
							bprint ("\n");								
							bprint ("Level Time : ");
							bprint ("0.00000"); // No need to display a time as start maps don't count.
							bprint ("\n");
							bprint ("Total Time : ");
							PrintTime (totaltime);
							bprint ("\n");
							bprint ("Runner     : ");
							bprint (other.netname);
							bprint ("\n");
							bprint ("=======================\n");
							if (mapname == "start" || mapname == "hipstart" || mapname == "rstart" || mapname == "e5start" || mapname == "mgstart") bprint("(Start maps don't add time!)\n");
							else if (mapname == "hub") bprint("(Hub maps don't add time!)\n");
							bprint ("\n");
						}
						else
						{
							pos = self;
							self = other;
							ExitMessage ();
							other = self;
							self = pos;
						}
					}
				}
			}
		}
		GotoNextMap();
		return;
	}
	
	self.touch = SUB_Null;
	self.think = execute_changelevel;
	self.nextthink = time + 0.1;
};

/*QUAKED trigger_changelevel (0.5 0.5 0.5) ? NO_INTERMISSION
When the player touches this, he gets sent to the map listed in the "map" variable.  Unless the NO_INTERMISSION flag is set, the view will go to the info_intermission spot and display stats.
*/
void() trigger_changelevel =
{
	if (!self.map) objerror ("changelevel trigger doesn't have map");

	InitTrigger ();
	
//	if (mapname == "test_hubmap") self.touch = Connect_To_Different_Server;
//	else
	self.touch = changelevel_touch;
};

/*
=============================================================================

				PLAYER GAME EDGE FUNCTIONS

=============================================================================
*/

void() LoadGame =
{
	dprint ("\n\nLoadGame: self.classname = ");
	dprint (self.classname);
	dprint ("\n\n");

	// For each player...
	local entity cl = find (world, classname, "player");
	while (cl)
	{
		if (cl.fog_density) SetFog (cl, cl.fog_density, cl.fog_color, 0.0); // Restore fog
		cl = find (cl, classname, "player");
	}
};

void() set_suicide_frame;

// Called by ClientKill and DeadThink
void() respawn =
{
	self.velocity = '0 0 0';
	if (coop)
	{
		// Make a copy of the dead body for appearances sake
		CopyToBodyQue (self);
		// Store and save parms to keep your weapons, ammo, and inventory
		if (cvar("coop") == REIGNITED_COOP || cvar("coop") == ENHANCED_COOP) SetRespawnParms ();
		// Set default spawn parms
		if (cvar("coop") == CLASSIC_COOP) SetNewParms ();
		// Respawn
		PutClientInServer ();
		// Same team
		TeamSetSkin ();	
	}
	else if (deathmatch)
	{
		self.modelindex = modelindex_nqwplayer;
		// Make a copy of the dead body for appearances sake
		CopyToBodyQue (self);
		// Set default spawn parms
		SetNewParms ();
		// Respawn
		PutClientInServer ();
		// Set the skin correctly.
		if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF) TeamSetSkin ();
	}		
	else
	{
		// Put serverflags back to map's initial setting
		serverflags = startingserverflags;
		// Request a reset to the parms
		reset_flag = TRUE;
		// Restart the entire server
		localcmd ("restart\n");		
	}		
};

// Yoder, Sept24, 2021
// when in horde coop, respawn a dead teammate with this:
void() horde_respawn_teammate =
{
	CopyToBodyQue (self);
	// setspawnparms (self);
	// SetNewParms (); 
	PutClientInServer ();
};

// Yoder, Sept24, 2021
// when in horde (coop or solo), respawn all by restarting the server:
void() horde_respawn_all =
{
	// restart the entire server
	// put serverflags back to map's initial setting
	serverflags = startingserverflags;
	// request a reset to the parms
	reset_flag = TRUE;
	// restart the entire server
	localcmd ("restart\n");
};

void() GibPlayer;
/*
============
ClientKill

Player entered the suicide command
============
*/
void() ClientKill =
{
	if ((intermission_running == 1) || (warmup_countdown >= 0 && warmup_countdown <= 6 && warmup_engaged && deathmatch)) return; // R00k	
	
	if (self.spectator) return; // Sleeper: Almost broke the server man, be careful!
		
	// Tune for Server Availability and if the server is Co-Op, Solo Speedrun, Co-Op Speedrun or Deathmatch	
	if (coop == 0 || coop == CLASSIC_COOP || coop == ENHANCED_COOP)
	{
		if (!deathmatch && cvar("sv_public") == 1) bprint (self.netname, " suicides\n"); // Public Server w/ Speedrunning gametype
	}	
		
	if (coop == REIGNITED_COOP && !deathmatch && cvar("sv_public") == 1) bprint (self.netname, " regrets nothing\n"); // Public Server w/ Co-Op	
		
	if (!coop && deathmatch && cvar("sv_public") == 1) // Public Server w/ Deathmatch gametypes
	{
		if (self.suicide_count < 4) bprint (self.netname, " regrets nothing\n");	
	}
	if (coop == REIGNITED_COOP || coop == CLASSIC_COOP)
	{
		if (!deathmatch && cvar("sv_public") == 0) bprint (self.netname, " regrets nothing\n"); // Private Server w/ Co-Op	
	}
		
	if (!coop && deathmatch && cvar("sv_public") == 0) // Private Server w/ Deathmatch gametypes	
	{
		if (self.suicide_count < 4) bprint (self.netname, " regrets nothing\n");	
	}
		
	if (!coop && !deathmatch && cvar("sv_public") == 0) bprint (self.netname, " suicides\n"); // Single Player	
	
	if (deathmatch && !coop && !warmup_engaged)
	{	
		if (self.suicide_count < 4) add_frag (self, -2);
		if (self.suicide_count > 3)
		{
			sprint (self, "You have committed suicide too much already.\n");
			return;
		}	
		self.suicide_count += 1;	
	}														
	
// ZOID--
	TeamDropFlagOfPlayer (self);
// --ZOID
/*
	if (tag_token_owner == self)
	{
		self.health = 0;
		self.solid = SOLID_NOT;
		tag_token_drop ();
	}
*/
	if (self.expansionitems & DOE_V_SPHERE)
	{
		local entity vSphere = find (world, classname, "Vengeance");
		while (vSphere)
		{
			if (vSphere.owner == self) remove (vSphere);
			vSphere = find (vSphere, classname, "Vengeance");
		}
	}		
		
	self.takedamage = DAMAGE_NO;
        self.touch = SUB_Null;
	if (cvar("horde")) // horde mode behavior
	{
		PlayerDie ();
		self.health = 0;
	}
	else
	{        
		self.health = -999;
  		self.th_die (); // Reset powerups and drop Backpack when appropriate
		set_suicide_frame ();
		self.modelindex = modelindex_nqwplayer;
		self.think = respawn;
		self.nextthink = time + 1.2;
	}
};

float(vector v) CheckSpawnPoint = {return FALSE;};

// MG1 =====================================================
float IDEAL_DIST_FROM_DM_SPAWN_POINT = 384;
float MIN_DIST_FROM_DM_SPAWN_POINT = 84;
float MIN_DIST_FROM_HORDE_SPAWN_POINT = 72;
float(entity e) predicate_is_active_spawnpoint = {return (e.state == COOP_SPAWN_ACTIVE);};
// ==========================================================

/*
============
PlayerVisibleToSpawnPoint

Returns true if player can see this point
============
*/
float(entity point) PlayerVisibleToSpawnPoint 
{
	local vector spot1, spot2;
	local entity player = find (world, classname, "player");
	while (player) 
	{
		if (player.health > 0) 
		{
			spot1 = point.origin + player.view_ofs;
			spot2 = player.origin + player.view_ofs;

			traceline (spot1, spot2, TRUE, point);
			if (trace_fraction >= 1.0f) return TRUE;
		}
		player = find (player, classname, "player");
	}
	
	return FALSE;
};

entity(float forceSpawn) SelectSpawnPointEX =
{
	local entity spot, thing, spots, hordeSpawn, startedAt = lastspawn, startspot;
	local float pcount, numspots = 0, totalspots = 0, t;

	// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot) return spot;
	
	// MG1 ---------------------------------------------------------------------------------
	if (cvar("horde") && !cvar("deathmatch")) 
	{ 
		// Run simpler logic for horde - just need a spot with noone on top of it...
		hordeSpawn = find (world, classname, "info_player_coop");
		while (hordeSpawn) 
		{
			thing = findradius (hordeSpawn.origin, MIN_DIST_FROM_HORDE_SPAWN_POINT);
			pcount = 0;
			while (thing) 
			{
				if (thing.classname == "player" && thing.health > 0) pcount++;                      
				thing = thing.chain;      
			}
			if (pcount == 0) return hordeSpawn;
			// Get the next spot in the chain
			hordeSpawn = find (hordeSpawn, classname, "info_player_coop");
		}
		if (coop) return world; // Didn't find anything.... fix for singleplayer
	}	
	// --------------------------------------------------------------------------------------
	
	if (cvar("coop") && !cvar("deathmatch"))
	{	
		/*	
		// Sleeper: Spawning logic for MG1 maps only.
		if (gameworld == MG1)
		{
			// MG1 -------------------------------------------------------------
			// Choose a info_player_coop point that is active
			lastspawn = find (lastspawn, classname, "info_player_coop");
			while (lastspawn.state != COOP_SPAWN_ACTIVE) 
			{
				if (lastspawn == startedAt) break;
				lastspawn = find (lastspawn, classname, "info_player_coop");
			}			
			if (lastspawn != world) return lastspawn; 
			// -----------------------------------------------------------------
		}
		
		// Sleeper: The traditional coop spawn logic.
		lastspawn = find (lastspawn, classname, "info_player_coop");
		if (lastspawn == world) lastspawn = find (lastspawn, classname, "info_player_start");		
		if (lastspawn != world) return lastspawn;
		*/
		
		// Choose a info_player_coop point that is active
		lastspawn = find (lastspawn, classname, "info_player_coop");
		while (lastspawn.state != COOP_SPAWN_ACTIVE) 
		{
			if (lastspawn == startedAt) break;
			lastspawn = find (lastspawn, classname, "info_player_coop");
		}			
		if (lastspawn != world) return lastspawn; 		
	}
	
	if (cvar("deathmatch") && !cvar("coop"))
	{
		if (cvar("deathmatch") >= DM_TDM && cvar("deathmatch") <= DM_OneFlagCTF)
		{
			startspot = spot = lastspawn;
			t = 0;
			if (!self.ctf_killed)
			{
				if (self.steam == TEAM1)
				{
					startspot = spot = team1_lastspawn;
					t = TEAM1;
				} 
				else if (self.steam == TEAM2)
				{
					startspot = spot = team2_lastspawn;
					t = TEAM2;
				}
			}
			
			while (TRUE)
			{
				if (t == TEAM1) spot = find (spot, classname, "info_player_team1");
				else if (t == TEAM2) spot = find (spot, classname, "info_player_team2");
				else spot = find (spot, classname, "info_player_deathmatch");

				if (spot != world)
				{
					if (spot == startspot) return startspot;
					pcount = 0;
					thing = findradius (spot.origin, 32);
					while (thing)
					{
						if (thing.classname == "player") pcount += 1;
						thing = thing.chain;
					}
					if (pcount == 0)
					{
						if (t == TEAM1) team1_lastspawn = spot;
						else if (t == TEAM2) team2_lastspawn = spot;
						else lastspawn = spot;
						return spot;
					}
				}
				else t = 0;
				// pgm fix for ctf in levels w/o ctf support
			}
		}
		else
		{
			// Find all spots that don't have visible players nearby
			spots = world;
			spot = find (world, classname, "info_player_deathmatch");       
			while (spot) 
			{
				totalspots += 1;
				thing = findradius (spot.origin, IDEAL_DIST_FROM_DM_SPAWN_POINT);
				pcount = 0;               
				while (thing) 
				{
					if (thing.classname == "player" && thing.health > 0) pcount += 1;                      
					thing = thing.chain;      
				}
				if (pcount == 0) 
				{
					if (PlayerVisibleToSpawnPoint(spot)) pcount += 1;
				}
				if (pcount == 0) 
				{ 
					// Good spot!
					spot.goalentity = spots;
					spots = spot;
					numspots += 1;
				}
				// Get the next spot in the chain
				spot = find (spot, classname, "info_player_deathmatch");                
			}
			totalspots -= 1;

			// On small maps with few spawn points, our "ideal" spawn conditions may not be possible to meet
			// so fallback to just trying to pick a point without a player on top of it, so we don't start
			// a spawn frag loop
			if (numspots == 0) 
			{
				spot = find (world, classname, "info_player_deathmatch");
				while (spot) 
				{
					thing = findradius (spot.origin, MIN_DIST_FROM_DM_SPAWN_POINT);
					pcount = 0;               
					while (thing)
					{
						if (thing.classname == "player" && thing.health > 0) pcount += 1;                      
						thing = thing.chain;      
					}
					if (pcount == 0) 
					{ 
						// Good spot!
						spot.goalentity = spots;
						spots = spot;
						numspots += 1;
					}
					// Get the next spot in the chain
					spot = find (spot, classname, "info_player_deathmatch");                
				}             
			}

			// Uncomment to force a deferred spawn
			// if (forceSpawn == FALSE) return world;
			if (!numspots) 
			{
				if (forceSpawn == FALSE) return world; 
				// No spots available so just pick one at random
				totalspots = rint (random() * totalspots);
				spot = find (world, classname, "info_player_deathmatch");       
				while (totalspots > 0)
				{
					totalspots -= 1;
					spot = find (spot, classname, "info_player_deathmatch");
				}
					
				return spot;
			}
				
			// Generate a random number between 1 and numspots
			numspots -= 1;	
			numspots = rint (random() * numspots);
			spot = spots;
			while (numspots > 0) 
			{
				spot = spot.goalentity;
				numspots -= 1;
			}
					
			return spot;
		}
	}	

	if (serverflags)
	{	
		// MG1 ----------------------------------------------------
		// Return with a rune to start
		local float lastPickup = sigil_getLastPickup ();
		if (lastPickup)
		{
			string spname = string_null;
			     if (lastPickup & SIGIL_E1) spname = "start_1";
			else if (lastPickup & SIGIL_E2) spname = "start_2";
			else if (lastPickup & SIGIL_E3) spname = "start_3";
			else if (lastPickup & SIGIL_E4) spname = "start_4";
			else if (lastPickup & SIGIL_E5) spname = "start_5";
			else if (lastPickup & SIGIL_E6) spname = "start_6";
			if (spname)
			{
				spot = find (world, netname, spname);
				if (spot)
				{
					if (spot.classname == "info_player_start_hub")
					{
						sigil_clearLastPickup ();
						return spot;
					}
				}
			}
		}
		// --------------------------------------------------------
		spot = find (world, classname, "info_player_start2");
		if (spot) return spot;
	}	
	spot = find (world, classname, "info_player_start");
	if (!spot) error ("PutClientInServer: no info_player_start on level");
	
	return spot;
};

/*
entity(string cname) SelectSpawnPointNudge =
{
	local float n, f, rnum;
	local entity spot, e;

	while (n < 32768) // Just some number of times...
	{
		lastspawn = find (lastspawn, classname, cname);
		spot = lastspawn;
		f = 0;
		// Check for telefrag
		if (spot != world)
		{
			e = findradius (spot.origin, 84);
			while (e)
			{
				if ((e.netname != "[overseer]-BOT") && (e.classname == "player") && (e != self) && (e.health > 0))
				{
					self.solid = SOLID_NOT; // This will unstick players at spawn
					makevectors (e.v_angle);
					if (world.model == "maps/e1m8.bsp") // Sleeper: Don't shoved players into the lava
					{
						rnum = random();
						e.velocity = e.velocity_x + e.velocity_y + e.velocity_z;
						if (rnum > 0.4) e.velocity_x = 320;  // Sleeper: Nudge them to the left
						else e.velocity_x = -320; // Sleeper: Nudge them to the right	
						e.velocity_y = 0;	     // Sleeper: Do nothing
						e.velocity_z = 0;	     // Sleeper: Do nothing
					}
					else e.velocity = v_forward * (320); // R00k: Nudge them forward
					self.deferspawn = 1; // Don't spawn come back in a second
					e = world; // Break out of the while loop (FIXME: should we continue to check for other players too?)
//					f = 1; // But don't return just yet
				}
				else e = e.chain; // Findradius creates a link-list of e.chain
			}
		}
		if (f == 0) // Spot is not world, and we didnt find anyone near the spawnpoint
		{
			lastspawn = spot;
			return (spot);
		}
	}
	n += 1;
	
	return lastspawn;
};
*/

/* // Sleeper: This does nothing.
entity() SelectSpawnPoint =
{
	// Use the original rogue spawn logic in rogue maps.
	if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF) return SelectSpawnPointRogue();
	else return SelectSpawnPointEX();
};
*/

/*
============
SelectSpawnPoint

Returns the entity to spawn at
============
*/
entity(float forceSpawn) SelectSpawnPoint = {return SelectSpawnPointEX (forceSpawn);}; // Sleeper: Merged Rogue's CTF spawn logic into the KEX spawn logic directly.
/*
===========
PutClientInServer

called each time a player is spawned
============
*/
void() DecodeLevelParms;
void() PlayerDie;

// MG1 ===========================================================
void() RunPostPutClientInServer =
{
	entity oself = self;
	self = self.owner;
	entity spot = oself.enemy;
	
	// Yoder Sept24, 2021
	horde_set_keys (self); // reset player's key count accordingly

	// Fog settings sometimes (?) need to be set a frame after the client has spawned.
	// Not sure why, or why it sometimes works on the same frame.
	if (!FogPushSettingsFrom(self, spot, 0)) FogPushSettingsFrom (self, world, 0);

	remove (oself);
};
// ================================================================


void() SpectatorFirstConnect;
void() info_player_coop;
void() player_touch;

// .float defertime;
#define redify(s) strconv(0,2,2,s)
void() Detect_Client;

void() PutClientInServer =
{
	local entity spot;	

//	spot = SelectSpawnPoint ();

/*		
	if (mapname == "dm1sp" || mapname == "dm2sp" || mapname == "dm3sp" || mapname == "dm4sp" || mapname == "dm5sp" || mapname == "dm6sp" || mapname == "hip3m2" || mapname == "e5m1" || mapname == "e5m2") 
	{
		spot = SelectSpawnPointGeneral ();
		// Make checks if other players are out of the way before letting them spawn.
		if (cvar("coop"))
		{
			if (!(intermission_running))
			{
	//			if (mapname == "dm1sp" || mapname == "dm2sp" || mapname == "dm3sp" || mapname == "dm4sp" || mapname == "dm5sp" || mapname == "dm6sp" || mapname == "hip3m2" || mapname == "e5m1" || mapname == "e5m2" || cvar("customcoop"))
	//				spot = SelectSpawnPointNudge("info_player_start"); // Sleeper: If the map doesn't have a coop spawn, we use the start spawn instead until we can spawn new coop spawns with spawnfunctions.
	//			else spot = SelectSpawnPointNudge("info_player_coop");								
				
//				if (mapname == "mexx5")	spot = SelectSpawnPointNudge ("info_player_coop"); // Apparently info_player_start isn't correctly set.
				if (!(SelectSpawnPointNudge("info_player_coop"))) spot = SelectSpawnPointNudge ("info_player_start");
				else spot = SelectSpawnPointNudge ("info_player_coop");	

				if (self.deferspawn == 1) // This will stagger spawning players in coop one second apart (or so), to reduce the chance of telefragging or sticking together.
				{
					id1_centerprint (self, "Searching for available respawn points...\n"); // Let the player know they're in a loop until another player moves out of the way.
					self.think = PutClientInServer;
					self.nextthink = time + 1;
					self.deferspawn = 0;
					return;
				}
				self.solid = SOLID_SLIDEBOX; // Reset this in case they were deferred...
				self.oldorigin = self.origin = spot.origin + '0 0 1'; // R00k: Update oldorigin so we don't respawn where we died.			
				self.angles = self.v_angle = spot.angles; // R00k: Update v_angle too.			
				self.fixangle = 1; // Turn this way immediately.
			}
		}
	}
*/	
//	DecodeLevelParms ();

	// Full Health         
	if (cvar("coop") && !cvar("deathmatch") && cvar("skill") == 4) // KEX's Nightmare! skill (Skill 3 with a 50 health handicap and less aggressive monsters)
	{
		if (!cvar("horde")) self.health = 50;
		else self.health = 76; // Deflatable Health
	}
	if (cvar("coop") && !cvar("deathmatch") && cvar("skill") == 5) // Sleeper Must Die! skill
	{
		if (!cvar("horde")) self.health = 125;
		else self.health = 151; // Deflatable Health
	}
	if (cvar("coop") && !cvar("deathmatch") && cvar("skill") <= 3) // Classic Nightmare! skill and below
	{
		if (!cvar("horde")) self.health = 100;
		else self.health = 126; // Deflatable Health
	}
	if (cvar("deathmatch") && !cvar("coop") && !cvar("customcoop")) self.health = 126; // Deathmatch Deflatable Health (Similar to Quake 3)						
		
	self.classname = "player";	
	
	if (self.netname == "[overseer]-BOT") self.solid = SOLID_NOT;	
	else self.solid = SOLID_SLIDEBOX;

//	self.dimension_solid = 1;
//	self.dimension_hit = 1;
//	self.dimension_see = 1;
//	self.dimension_seen = 1;
//	self.dimension_ghost = 0;
//	self.dimension_ghost_alpha = 0;	
	
//	self.solid = SOLID_SLIDEBOX;	
	self.movetype = MOVETYPE_WALK;
	self.show_hostile = 0;
	
	// Max Health
	if (cvar("coop") && !cvar("deathmatch") && cvar("skill") == 4) self.max_health = 50;       		      // KEX's Nightmare! skill Max Health	
	if (cvar("coop") && !cvar("deathmatch") && cvar("skill") == 5) self.max_health = 125; 		      // Sleeper Must Die! skill Max Health
	if (cvar("coop") && !cvar("deathmatch") && cvar("skill") <= 3) self.max_health = 100; 		      // Classic Nightmare! skill and below Max Health
	if (cvar("deathmatch") && !cvar("coop") && !cvar("customcoop")) self.max_health = 100;      // Deathmatch Max Health (Similar to Quake 3)	
			
	self.flags = FL_CLIENT;	
	self.takedamage = DAMAGE_AIM;

	if (self.netname == "[overseer]-BOT") self.takedamage = DAMAGE_NO;
	else self.takedamage = DAMAGE_AIM;
	
	self.air_finished = time + 12;
	self.dmg = 2;   						        // Initial water damage
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.effects = 0;
	self.invincible_time = 0;
	self.healthtime = 0;
	self.armorrottime = 0;	
	self.health_overstacked = 0; // Overstack flag
	self.spawn_protection_finished = 0; // Spawn Protection primarily for custom coop
	self.spawn_protection_time = 0;
	self.guard = 0; // Rune of Guard to adjust max health to 200 and armorvalue to 200
	
	//JIM
	self.wetsuit_finished = 0;
	//MED
	self.empathy_finished = 0;
	//MED
	self.expansionitems = 0;
	
	self.shield_finished = 0;
	self.antigrav_finished = 0;
		
	//ZOID--
	self.ctf_lastreturnedflag = -10;
	self.ctf_lastfraggedcarrier = -10;
	self.ctf_flagsince = -10;
	self.ctf_lasthurtcarrier = -10;
	//--ZOID	
	self.gravity = 1.0;
		
	DecodeLevelParms ();	

	W_SetCurrentAmmo ();
	
	self.attack_finished = time;
	self.playerjump_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;
	
	self.deadflag = DEAD_NO;
	self.pausetime = 0; // Pausetime is set by teleporters to keep the player from moving a while
	self.spectator = 0; // Remove from spectator mode
	self.falling = 0;   // Not falling
		
	local float shouldTelefrag;
	if (self.spawn_deferred > 0 && time >= self.spawn_deferred)
	{
		dprint ("Forcing telefrag on this spawnpoint...\n");
		shouldTelefrag = TRUE;
	} 
	else shouldTelefrag = FALSE;

	spot = SelectSpawnPoint (shouldTelefrag);	
	if (spot == world) 
	{
		self.takedamage = DAMAGE_NO;
		self.solid = SOLID_NOT;
		self.movetype = MOVETYPE_NONE;
		self.deadflag = DEAD_DEAD;
		setmodel (self, "");
		self.view_ofs = '0 0 1'; // not 0 because PlayerPreThink would return out
		self.velocity = '0 0 0';
				
		if (self.spawn_deferred == 0) 
		{
			dprint ("No spawns available! Deferring spawnpoint...\n");
			id1_centerprint (self, "Searching for available respawn points...\n"); // Let the player know they're in a loop until another player moves out of the way.
			self.spawn_deferred = time + 5;
		}
				
		spot = FindIntermission ();
		self.angles = self.v_angle = spot.mangle;
		self.fixangle = TRUE;
		self.origin = spot.origin;
		self.weaponmodel = "";
		self.weaponframe = 0;
		self.weapon = 0;
		return;
	}
	self.spawn_deferred = 0;	
		
//	spot = SelectSpawnPoint ();
	self.oldorigin = self.origin = spot.origin + '0 0 1'; // R00k: update oldorigin so we dont respawn where we died. 
	self.angles = spot.angles;
	self.fixangle = TRUE;		// turn this way immediately
	
	if (cvar("coop") && !cvar("deathmatch"))
	{	
		self.attack_finished = time + 0.3;     // Sleeper: Don't fire immediately after level load.
		self.playerjump_finished = time + 0.4; // Sleeper: Don't jump immediately after level load.
		self.pausetime = time + 0.3;	       // Sleeper: Don't move immediately after level load.
	}
	
	if (!cvar("coop") && !cvar("deathmatch"))
	{	
		self.attack_finished = time + 0.1;     // Sleeper: Don't fire immediately after level load.
		self.playerjump_finished = time + 0.1; // Sleeper: Don't jump immediately after level load.
		self.pausetime = time + 0.1;	       // Sleeper: Don't move immediately after level load.
	}	
	
	// MG1
	#ifdef COOP_RESPAWN_KEEP_WEAPONS
	if (cvar("coop") == CLASSIC_COOP) 
	{ 
		// In coop we want to give back the players the weapons they progressed with
		self.items |= spot.items & (IT_ALL_WEAPONS);
		if (self.items & (IT_NAILGUN | IT_SUPER_NAILGUN) && self.ammo_nails < 50) self.ammo_nails = 50;
		if (self.items & (IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER) && self.ammo_rockets < 10) self.ammo_rockets = 10;
		if (self.items & (IT_LIGHTNING | IT_EXTRA_WEAPON) && self.ammo_cells < 50) self.ammo_cells = 50;
	}
	#endif	
	
	self.touch = player_touch;

	// oh, this is a hack!
	setmodel (self, "progs/playham.mdl");
	modelindex_hammer = self.modelindex;
 
	setmodel (self, "progs/eyes.mdl");
	modelindex_eyes = self.modelindex;	
	/* 
	// Replacing with NQW code =====================================================
	setmodel (self, "progs/player.mdl");
	modelindex_player = self.modelindex;

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	
	self.view_ofs = '0 0 22';

	player_stand1 ();
	// =============================================================================
	*/
	if (cvar("deathmatch") >= DM_TDM && cvar("deathmatch") <= DM_OneFlagCTF && !cvar("coop"))
	{
		if (self.steam == TEAM1) self.nqwSkin = 1;
		if (self.steam == TEAM2) self.nqwSkin = 2;
	}

	NQW_SpawnCharacter ();	
//	tracebox (self.origin, VEC_HULL_MIN, VEC_HULL_MAX, self.origin, 0, self);
		
	if (deathmatch || coop)
	{
//		makevectors (self.angles);
		makevectorsfixed (self.angles);
		spawn_tfog (self.origin + v_forward * 20);
	}
	
	// Grapple stuff
	self.on_hook = 0;
	self.hook_out = 0;
	self.fire_hook = 0;	

	spawn_tdeath (self.origin, self);  
	
	// MG1 ----------------------------------------
	entity postSpawn = spawn ();
	postSpawn.owner = self;
	postSpawn.enemy = spot;
	postSpawn.think = RunPostPutClientInServer;
	postSpawn.nextthink = time + 0.05;
	// --------------------------------------------	
	
	/////////////////////////////////////////////////////
	if (cvar("skill") == 0) stuffcmd (self, "skill 0\n"); // If a client connects to the server,			
	if (cvar("skill") == 1)	stuffcmd (self, "skill 1\n"); // the client's skill level will also		
	if (cvar("skill") == 2)	stuffcmd (self, "skill 2\n"); // change depending on what the server
	if (cvar("skill") == 3)	stuffcmd (self, "skill 3\n"); // skill is setting to. Useful to know																			
	if (cvar("skill") == 4)	stuffcmd (self, "skill 4\n"); // to check the difficulty on the fly										
	if (cvar("skill") == 5) stuffcmd (self, "skill 5\n"); // without having to check the MOTD text.					
	/////////////////////////////////////////////////////	
	
	stuffcmd (self, "-jump\n");
	stuffcmd (self, "-attack\n");
	
	/*
        msg_entity = self;
        WriteByte (MSG_ONE, SVC_SETVIEWPORT);
        WriteEntity (MSG_ONE, self);  
        setorigin (self, spot.origin);
        */		
};


/*
=============================================================================

				QUAKED FUNCTIONS

=============================================================================
*/


/*QUAKED info_player_start (1 0 0) (-16 -16 -24) (16 16 24)
The normal starting point for a level.
*/
void() info_player_start = {self.netname = "info_player_start";}; // For bot nav support.

/*QUAKED info_player_start2 (1 0 0) (-16 -16 -24) (16 16 24)
Only used on start map for the return point from an episode.
*/
void() info_player_start2 = {self.netname = "info_player_start2";}; // For bot nav support.

/*QUAKED info_player_start_hub (1 0 0) (-16 -16 -24) (16 16 24)
Only used on start map for the return point from an episode.
*/
void() info_player_start_hub = {self.netname = "info_player_start_hub";}; // For bot nav support.

/*Saved out by quaked in region mode
*/
void() testplayerstart = {};

/*QUAKED info_player_deathmatch (1 0 1) (-16 -16 -24) (16 16 24)
Potential spawning position for deathmatch games
*/
void() info_player_deathmatch = 
{
	if (!deathmatch) {remove (self); return;}
	self.netname = "info_player_deathmatch"; // For bot nav support.
	/*
	if (cvar("deathmatch"))
	{
		if (cvar("gamecfg") == GAMECFG_ORIGINAL_RUNES || cvar("gamecfg") == GAMECFG_NQW_RUNES) SpawnRunes ();
	}
	*/
};

//////////////////////////////////////////////////////////////////////////

// MG1
void() trigger_activate_coop_spawns_use =
{
	local float it = 0;
	local entity coop_spawn;

	if (cvar("coop") == CLASSIC_COOP)
	{
		#ifdef COOP_RESPAWN_KEEP_WEAPONS
		local entity p = find (world, classname, "player");
		while (p != world) 
		{
			it |= p.items;
			p = find (p, classname, "player");
		}	
		it &= ALL_WEAPONS;

		dprint ("Activating coop spawn \"");
		dprint (self.target);
		dprint ("\": Collected ");
		dprint (ftos(it));
		dprint (" from players.\n");
		#endif

		coop_spawn = find (world, classname, "info_player_coop");
		while (coop_spawn) 
		{
			if (coop_spawn.targetname == self.target) 
			{
				coop_spawn.state = COOP_SPAWN_ACTIVE;
				coop_spawn.items = it;
			}
			else 
			{
				coop_spawn.state = 0;
				coop_spawn.items = 0;
			}
			coop_spawn = find (coop_spawn, classname, "info_player_coop");
		}
	}
	else
	{
		dprint ("Activating coop spawn \"");
		dprint (self.target);
		dprint ("\n");
		coop_spawn = find (world, classname, "info_player_coop");
		while (coop_spawn)
		{
			if (coop_spawn.targetname == self.target) coop_spawn.state = COOP_SPAWN_ACTIVE;
			else coop_spawn.state = 0;
			coop_spawn = find (coop_spawn, classname, "info_player_coop");
		}
	}		
};

/*QUAKED trigger_activate_coop_spawns (1 0 1) (-8 -8 -8) (8 8 8)
Activates a set of coop spawnpoints.
*/
void() trigger_activate_coop_spawns =
{
	if (!coop) {remove (self); return;}
	self.use = trigger_activate_coop_spawns_use;
};

const float COOP_SPAWN_START_ACTIVE = 1;

/*QUAKED info_player_coop (1 0 1) (-16 -16 -24) (16 16 24)
Potential spawning position for coop games
*/
void() info_player_coop = 
{
	if (!coop) {remove (self); return;}
	self.netname = "info_player_coop"; // for bot nav support.
	if (!self.targetname || self.spawnflags & COOP_SPAWN_START_ACTIVE) self.state = COOP_SPAWN_ACTIVE;
};

/*
===============================================================================

RULES

===============================================================================
*/

/*
Go to the next level for deathmatch.
Only called if a time or frag limit has expired.
*/
void() NextLevel =
{
	local entity o;
	
	if (!deathmatch) return;
				
	// iD1 ----------------------------------------	
	if (mapname == "start")
	{
		if (!cvar("registered")) mapname = "e1m1";		
		else if (!(serverflags & 1))
		{
			mapname = "e1m1";
			serverflags |= 1;
		}
		else if (!(serverflags & 2))
		{
			mapname = "e2m1";
			serverflags |= 2;
		}
		else if (!(serverflags & 4))
		{
			mapname = "e3m1";
			serverflags |= 4;
		}
		else if (!(serverflags & 8))
		{
			mapname = "e4m1";
			serverflags -= 7;
		}		
		o = spawn ();
		o.map = mapname;	
	}								
	// HIPNOTIC -----------------------------------
	else if (mapname == "hipstart")
	{
		mapname = "hip1m1";
		o = spawn ();
		o.map = mapname;	
	}		
	// ROGUE --------------------------------------
	else if (mapname == "rstart")
	{
		// PGM 03/02/97 - make it always go to rogue level1 when in our progs
		mapname = "r1m1";
		o = spawn ();
		o.map = mapname;
	}
	// MG1 ----------------------------------------
	else if (world.model == "maps/mgdm1.bsp")
	{
		o = spawn ();
		o.map = "mgdm2";
	}
	else if (world.model == "maps/mgdm2.bsp")
	{
		o = spawn ();
		o.map = "mgdm3";
	}
	else if (world.model == "maps/mgdm3.bsp")
	{
		o = spawn ();
		o.map = "mgdm4";
	}
	else if (world.model == "maps/mgdm4.bsp")
	{
		o = spawn ();
		o.map = "mgdm1";
	}
	// --------------------------------------------	
	else
	{
		// find a trigger changelevel
		o = find (world, classname, "trigger_changelevel");
		// go back to start if no trigger_changelevel
		if (!o)
		{
			mapname = "start";
			o = spawn ();
			o.map = mapname;
		}
        }

	nextmap = o.map;
	gameover = TRUE;

	if (o.nextthink < time)
	{
		o.think = execute_changelevel;
		o.nextthink = time + 0.1;
	}
};

/*
============
CheckRules

Exit deathmatch games upon conditions
============
*/
// Exit deathmatch games upon conditions
float justonce;
void() CheckRules = 
{
	local entity leadingplayer, losingplayer; // Sleeper: Since we lost the ability to use the self entity, so we loop through all the players instead.
		
	if ((gameover) || (!deathmatch)) return; // Someone else quit the game already
		
	timelimit = cvar("timelimit") * 60;	
	fraglimit = cvar("fraglimit");	     // Duel, FFA, TDM
	capturelimit = cvar("capturelimit"); // CTF, One Flag CTF	
			
	if (!cvar("warmup")) initiate_matchtime = TRUE; // Sleeper: Warmups off, initiate matchtime by default.
	
	if (cvar("warmup")) // Sleeper: When in Warmup Mode, 2 players must be in the server in order to initiate warmups.
	{		
		if (num_players >= 2) start_warmup = TRUE;
		if (start_warmup == TRUE && !initiate_matchtime) warmup_engaged = TRUE;
		if (warmup_engaged == TRUE) Warmup_Rules ();
	}
	
	if (initiate_matchtime == TRUE) // Sleeper: Timelimit is only active when the match is initiated.
	{
		if (!justonce) // Sleeper: Not a fucking word, Bell...
		{
			matchtime = timelimit + 1; // Sleeper: Match time becomes the timelimit.
			matchtime_timer = time + 1;
			justonce = TRUE;
		}

		if (matchtime_timer < time) // Sleeper: Match time ticks down instead of up.
		{
			matchtime -= 1;
			matchtime_timer = time + 1;
		}				
	}
	
//	if (timelimit & timelimit >= time)	
	if (matchtime <= 0 && sudden_death_engaged == FALSE && warmup_engaged == FALSE && num_players >= 1)
	{
		if (deathmatch == DM_DUEL || deathmatch == DM_FFA) 
		{
			for (leadingplayer = find (world, classname, "player"); leadingplayer; leadingplayer = find (leadingplayer, classname, "player")) // Self
			{
				for (losingplayer = find (world, classname, "player"); losingplayer; losingplayer = find (losingplayer, classname, "player")) // Other
				{
					if (leadingplayer != losingplayer && num_players >= 2) 
					{
						if (leadingplayer.frags > losingplayer.frags) // Sleeper: Somebody won.
						{
							endgame = TRUE;							
							bprint ("Timelimit Hit. ", leadingplayer.netname, " wins!\n");
						}
						else // Sleeper: Sudden Death!
						{
							if (!cvar("sudden_death"))
							{
								if (loophack <= 1) loophack++;
								endgame = TRUE;
								if (loophack == 1) bprint ("Timelimit Hit.\n");
							}
							else sudden_death_engaged = TRUE; // Sleeper: Put match in overtime.																										
						}					
					}											
				}										
			}			
		}	
		else if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF) 
		{
			if (num_players >= 2)
			{
				// Sleeper: Compare scores between teams.
				if (TeamScore[TEAM_RED_4] > TeamScore[TEAM_BLUE_13]) 
				{
					endgame = TRUE;
					bprint ("Timelimit Hit. Red Team Wins!\n");
				}	
				else if (TeamScore[TEAM_BLUE_13] > TeamScore[TEAM_RED_4]) 
				{
					endgame = TRUE;
					bprint ("Timelimit Hit. Blue Team Wins!\n");
				}
				else 
				{
					if (!cvar("sudden_death")) 
					{
						if (loophack <= 1) loophack++;
						endgame = TRUE;
						if (loophack == 1) bprint ("Timelimit Hit. Teams Are Tied!\n");
					}
					else sudden_death_engaged = TRUE; // Sleeper: Put match in overtime.						
				}
			}
		}
	}		
	
	if (capturelimit) 
	{
		for (leadingplayer = find (world, classname, "player"); leadingplayer; leadingplayer = find (leadingplayer, classname, "player"))
		{
			if (TeamScore[leadingplayer.team] >= capturelimit)
			{
				endgame = TRUE;
				if (leadingplayer.team == TEAM_RED_4) bprint ("Capturelimit Hit. Red Team Wins!\n");
				else if (leadingplayer.team == TEAM_BLUE_13) bprint ("Capturelimit Hit. Blue Team Wins!\n");
				else bprint ("Capturelimit Hit.\n");
			}
		}
	}		
	
	if (fraglimit) 
	{
		for (leadingplayer = find (world, classname, "player"); leadingplayer; leadingplayer = find (leadingplayer, classname, "player")) // Sleeper: Loop through all the players.
		{
			if (cvar("deathmatch") == DM_DUEL || cvar("deathmatch") == DM_FFA)
			{
				if (leadingplayer.frags >= fraglimit) 
				{
					endgame = TRUE;
					bprint ("Fraglimit Hit. ", leadingplayer.netname, " wins!\n");
				}
			}
			else if (cvar("deathmatch") == DM_TDM || cvar("deathmatch") == DM_CTF || cvar("deathmatch") == DM_OneFlagCTF) 
			{
				if (TeamScore[leadingplayer.team] >= fraglimit)
				{
					endgame = TRUE;
					if (leadingplayer.team == TEAM_RED_4) bprint ("Fraglimit Hit. Red Team Wins!\n");
					else if (leadingplayer.team == TEAM_BLUE_13) bprint ("Fraglimit Hit. Blue Team Wins!\n");
					else bprint ("Fraglimit Hit.\n");
				}
			}
		}
	}
	
	// Sleeper: If players/teams are tied when timelimit expires, enter Overtime mode with Sudden Death rules. May the best player/team win!
	if (cvar("sudden_death")) SuddenDeath_Rules ();						
			
	// Update team scores? 
	if (cvar("deathmatch") == DM_TDM || cvar("deathmatch") == DM_CTF || cvar("deathmatch") == DM_OneFlagCTF) TeamCheckScoreUpdate (); // TDM, CTF, One Flag CTF		
	
	if (!endgame) return;		
	NextLevel();
};

// Use this function when adding or subtracting player frags.
void(entity fragger, float new_frags) add_frag = 
{
	if (initiate_matchtime == FALSE && cvar("deathmatch")) return;

	// Add frags
	fragger.frags += new_frags;
	if (cvar("deathmatch") == DM_TDM) 
	{
		if (fragger.classname == "player" && fragger.steam >= TEAM_WHITE_0 && fragger.steam <= TEAM_BLUE_13) TeamScore[fragger.steam] += new_frags;
	}
};

// Use this function for capturing flags.
void(entity scorer, float new_score) add_score = 
{
	if (initiate_matchtime == FALSE && cvar("deathmatch")) return;

	if (cvar("deathmatch") == DM_CTF || cvar("deathmatch") == DM_OneFlagCTF) 
	{
		scorer.captures += new_score;
		if (scorer.classname == "player" && scorer.steam >= TEAM_WHITE_0 && scorer.steam <= TEAM_BLUE_13) TeamScore[scorer.steam] += new_score;
	}
};

.float deathrespawn;
void() PlayerDeathThink =
{
	local float forward;

	if (self.flags & FL_ONGROUND)
	{
		forward = vlen (self.velocity);
		forward -= 20;
		if (forward <= 0) self.velocity = '0 0 0';
		else self.velocity = forward * normalize (self.velocity);
	}
	
	if (self.spawn_deferred)
	{		
		local entity spot = SelectSpawnPoint (FALSE);
	     // dprint ("time {} >= self.spawn_deferred {}\n", ftos(time), ftos(self.spawn_deferred));
		if (spot != world || time >= self.spawn_deferred) respawn ();
		return;
	}	

	// Wait for all buttons released
	if (self.deadflag == DEAD_DEAD)
	{
		if (self.button2 || self.button1 || self.button0) return;
		if (self.deathrespawn < time) self.deadflag = DEAD_RESPAWNABLE;
		return;
	}

	// Wait for any button down
	if (!self.button2 && !self.button1 && !self.button0) return;

	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;
	
	// MG1: Yoder Sept24, 2021
	if (horde_ent)
	{
		if ((coop && HordeGetPlayersAlive() <= 0) || (!coop)) horde_respawn_all ();
		return;
	}
		
	respawn ();
};

void() PlayerJump =
{
	if (self.flags & FL_WATERJUMP || self.playerjump_finished > time) return;
	
	if (self.waterlevel >= 2)
	{
		if (self.watertype == CONTENT_WATER) self.velocity_z = 100;
		else if (self.watertype == CONTENT_SLIME) self.velocity_z = 80;
		else self.velocity_z = 50;

		// Play swiming sound
		if (self.swim_flag < time)
		{
			self.swim_flag = time + 1;
			if (random() < 0.5) sound (self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);
			else sound (self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
		}
		return;
	}

	if (!(self.flags & FL_ONGROUND)) return;
	if (!(self.flags & FL_JUMPRELEASED)) return; // Don't pogo stick
	self.flags -= self.flags & (FL_JUMPRELEASED);
	self.flags -= FL_ONGROUND; // Don't stairwalk	
	self.button2 = 0;
	
	// Player jumping sound
	sound (self, CHAN_BODY, self.nqwSndJump, 1, ATTN_NORM);
	self.velocity_z += 270;
};

/*
===========
WaterMove

============
*/
.float	dmgtime;

void() WaterMove =
{
     // dprint (ftos(self.waterlevel));
	if (self.movetype == MOVETYPE_NOCLIP) return;
	if (self.health < 0) return;

	if (self.waterlevel != 3)
	{
		if (self.air_finished < time) sound (self, CHAN_VOICE, self.nqwSndGasp2, 1, ATTN_NORM);
		else if (self.air_finished < time + 9) sound (self, CHAN_VOICE, self.nqwSndGasp1, 1, ATTN_NORM);
		self.air_finished = time + 12;
		self.dmg = 2;
	}
	else if (self.air_finished < time)
	{	
		// Drown!
		if (self.pain_finished < time)
		{
			self.dmg = self.dmg + 2;
			if (self.dmg > 15) self.dmg = 10;
			T_Damage (self, world, world, self.dmg);
			self.pain_finished = time + 1;
		}
	}
	
	if (!self.waterlevel)
	{
		if (self.flags & FL_INWATER)
		{	
			// Play leave water sound
			sound (self, CHAN_BODY, "misc/outwater.wav", 1, ATTN_NORM);
			self.flags -= FL_INWATER;
		}
		return;
	}

	if (self.watertype == CONTENT_LAVA)
	{	
		// Do damage
		if (self.dmgtime < time)
		{
			if (self.radsuit_finished > time) self.dmgtime = time + 1;
			else self.dmgtime = time + 0.2;
			T_Damage (self, world, world, 10 * self.waterlevel);
		}
	}
	else if (self.watertype == CONTENT_SLIME)
	{	
		// Do damage
		if (self.dmgtime < time && self.radsuit_finished < time)
		{
			self.dmgtime = time + 1;
			T_Damage (self, world, world, 4 * self.waterlevel);
		}
	}
	
	if (!(self.flags & FL_INWATER))
	{	
		// Player enter water sound
		if (self.watertype == CONTENT_LAVA) sound (self, CHAN_BODY, "player/inlava.wav", 1, ATTN_NORM);
		if (self.watertype == CONTENT_WATER) sound (self, CHAN_BODY, "player/inh2o.wav", 1, ATTN_NORM);
		if (self.watertype == CONTENT_SLIME) sound (self, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM);

		self.flags += FL_INWATER;
		self.dmgtime = 0;
	}
	
	if (!(self.flags & FL_WATERJUMP))
	{
		// A set of hacks to make swimming with QuakeWorld physics roughly as fast as Net Quake physics (might bug like Quake 2 does coming out of the water so quickly).
		if (!cvar("sv_nqplayerphysics"))
		{
			if (self.wetsuit_finished > time)
			{
				if (self.waterlevel == 3) self.velocity -= -15 * self.waterlevel * frametime * self.velocity * 0.25;
			}
			else
			{
				if (self.waterlevel <= 2) self.velocity -= 0.8 * self.waterlevel * frametime * self.velocity;
				else if (self.waterlevel == 3) self.velocity -= -1 * self.waterlevel * frametime * self.velocity;
			}
		}
		else self.velocity -= 0.8 * self.waterlevel * frametime * self.velocity;
	}
};

void() CheckWaterJump =
{
	// Check for a jump-out-of-water
	makevectors (self.angles);
	local vector start = self.origin;
	start_z += 8; 
	v_forward_z = 0;
	normalize (v_forward);
	local vector end = start + v_forward * 24;
	traceline (start, end, 1, self);
	if (trace_fraction < 1)
	{	
		// Solid at waist
		start_z += self.maxs_z - 8;
		end = start + v_forward * 24;
		self.movedir = trace_plane_normal * -50;
		traceline (start, end, 1, self);
		if (trace_fraction == 1)
		{	
			// Open at eye level
			self.flags |= FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags -= self.flags & (FL_JUMPRELEASED);
			self.teleport_time = time + 2;	// Safety net
			return;
		}
	}
};

// Sleeper: Taken from Runner's Delight.
void() KillTheBunny =
{
	local vector vel;
	local float v;
	
	if (cvar("allow_bunnyhopping")) return; // Sleeper: The custom cvar is enabled, don't "Kill The Bunny".
		
	if (!cvar("sv_nqplayerphysics")) // Sleeper: This is QuakeWorld physics, set Net Quake physics on.
	{
		cvar_set ("sv_nqplayerphysics", "1");
		return;
	}	

	if (self.flags & FL_DAMAGEBOOSTED) // Sleeper: Ignore if we're rocket/grenade jumping.
	{
		self.flags -= FL_DAMAGEBOOSTED;
		return;
	}
	
	if ((!(self.flags & FL_ONGROUND) && (self.flags & FL_JUMPRELEASED)) || (self.velocity_z < 0)) return;
	
	vel_x = self.velocity_x;
	vel_y = self.velocity_y;
	v = vlen(vel);
	
	if (v <= 320 || v <= self.speed) return;
	
	self.origin_x = self.oldorigin_x + (320 * (self.origin_x - self.oldorigin_x) / v);
	self.origin_y = self.oldorigin_y + (320 * (self.origin_y - self.oldorigin_y) / v);
	self.velocity_x = (self.velocity_x * 320) / v;
	self.velocity_y = (self.velocity_y * 320) / v;
};

// Sleeper: Cap QuakeWorld Physics Speed (It won't be used for QuakeWorld speedrunning, or deathmatch by default).
void() QWSpeedCap =
{
	if (!cvar("qw_physics_capped")) return; // Sleeper: The custom cvar is disabled, don't cap speed.
	if (cvar("sv_nqplayerphysics")) return; // Sleeper: This Net Quake physics, don't cap speed.
	
//	local vector hvel = [self.velocity_x, self.velocity_y, 0];
	local vector hvel = [self.velocity_x, self.velocity_y];
	local float MAX_QWSPEED = cvar("qw_physics_speedcap");  // Sleeper: Written in console/command shell, 700 is default.
	
	if (self.flags & FL_DAMAGEBOOSTED) // Sleeper: Ignore cap if we're rocket/grenade jumping. 
	{
		self.flags -= FL_DAMAGEBOOSTED;
		return;
	}
		
	if (self.flags & FL_ONGROUND && self.speed > MAX_QWSPEED)
	{
		self.speed -= 30; // Sleeper: Apply artificial friction.
		if (self.speed < MAX_QWSPEED) self.speed = MAX_QWSPEED; // Sleeper: Don't over reduce speed.
		hvel = normalize(hvel) * self.speed;
	}
	
	self.velocity_x = hvel_x;
	self.velocity_y = hvel_y;			
};

/*
================
PlayerPreThink

Called every frame before physics are run
================
*/
// MED 01/17/97
void(float num_bubbles) DeathBubbles;
void() PlayerPreThink =
{
	if (intermission_running)
	{
		earthquake_prethink ();
		IntermissionThink ();   // Otherwise a button could be missed between the think tics
		return;
	}

	if (self.view_ofs == '0 0 0') return; // Intermission or finale
		
	if (earthquake_active)
	{
		if (self.flags & FL_ONGROUND)
		{
			self.velocity_x += (random() * earthquake_intensity * 2) - earthquake_intensity;
			self.velocity_y += (random() * earthquake_intensity * 2) - earthquake_intensity;
			self.velocity_z += (random() * earthquake_intensity * 2) - earthquake_intensity;
		}
	}		

	// HIPNOTIC: JIM
	// Kill player on Edge of Oblivion
	if ((self.origin_z < -1300) && (world.model == "maps/hipdm1.bsp") && (self.health > 0))
	{
		self.deathtype = "void";
		if (self.invincible_finished >= time)
		{
			self.invincible_finished = 0;
			self.items -= self.items & (IT_INVULNERABILITY);
			self.invincible_time = 0;
			self.invincible_finished = 0;
			self.effects -= self.effects & (EF_RED);
		}
		T_Damage (self, self, world, self.health + 1000);
	}

	if (self.nqwCharacter == NQW_RANGER)
	{
		if ((self.origin_z < 50) && (world.model == "maps/hipdm1.bsp") && (self.health > 0))
		{
			self.deathtype = "void";
			if (!self.falling) // Sleeper: So it doesn't repeat.
			{
				sound (self, CHAN_VOICE, "ranger/falling.wav", 1, ATTN_NORM);
				self.falling = 1;
			}
		}
	}

	// HIPNOTIC: JIM
     /* if (!deathmatch)*/ earthquake_prethink ();

	makevectors (self.v_angle);		// Is this still used?
	
	if (self.deathtype) self.deathtype = "";	// QIP
	
/*	if (!cvar("deathmatch") && cvar("sv_public") == 1)
	{
		if (!cvar("coop") || cvar("coop") == 2)
		{
			if (self.style & 1) // Sleeper: This is suppose to initiate a grenade counter whenever an ogre shoots their grenade, if host was listen only. Not a good idea when dedicated.
			{
				if (!GrenadeCounter() && (self.style & 2)) OgreGrenadeCounter ();
			}
			else if (self.style & 2) OgreGrenadeCounter ();
		}
	}	
*/
	TeamCheckLock (); // TeamCheckLock performs all necessary teamlock checking, and performs all actions needed
//	CheckRules ();   // Sleeper: Moved to StartFrame.
	WaterMove ();	
	
	// HIPNOTIC: JIM
	// WETSUIT
	if (self.wetsuit_finished > time)
	{
		if (self.waterlevel == 2) self.velocity *= 1.25;
		if (self.waterlevel == 3) self.velocity *= 1.5;
		if (self.waterlevel >= 2)
		{
			// Play scuba sound
			if (self.swim_flag < time)
			{
				self.swim_flag = time + 7;
				sound (self, CHAN_BODY, "misc/wetsuit.wav", 1, ATTN_NORM);
			}
			// HIPNOTIC: MED 01/17/97
			else
			{
				if (fabs(self.swim_flag - time - 6) < 0.04) DeathBubbles (1);
				else if (fabs(self.swim_flag - time - 5.5) < 0.04) DeathBubbles (1);
				else if (fabs(self.swim_flag - time - 5) < 0.04) DeathBubbles (1);
			}
		}
	}	
				
	if (self.waterlevel == 2) CheckWaterJump ();

	if (self.deadflag >= DEAD_DEAD)
	{
		PlayerDeathThink ();
		return;
	}
	
	if (self.deadflag == DEAD_DYING)
	{
		self.modelindex = self.modelindex_nqwplayer;
		return;	// Dying, so do nothing
	}
	
	QWSpeedCap (); // Sleeper: Bring down QW-Physics to what's humanly possible for NQ-Physics.
	
	if (self.button2) PlayerJump ();
	else self.flags |= FL_JUMPRELEASED;

	// Teleporters can force a non-moving pause time
	if (time < self.pausetime) self.velocity = '0 0 0';
		
	if (self.expansionitems & DOE_ANTIGRAV)
	{
		if (time > self.AGping)
		{
			sound (self, CHAN_AUTO, "belt/use.wav", 0.4, ATTN_NORM);
			self.AGping = time + 3;
			if (self.AGping >= (self.antigrav_finished - 3)) self.AGping = self.antigrav_finished + 3;
		}
	}

	RuneApplyElder (self); // Regeneration rune 
	
	Use_Grappling_Hooks (); // Sleeper: Offhanded and Weapon Based Grappling Hooks.
	
	if (time > self.attack_finished && self.currentammo == 0 && self.weapon != IT_AXE && self.weapon != IT_MJOLNIR && self.weapon != DOE_GRAPPLE)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
	}	
	
	KillTheBunny (); // Runner's Delight: KILL THE BUNNY!	
	
	Player_Countdown_Sounds (); // For Deathmatch Warmups.
		
	// Sleeper: I can never get player collision to work right utilizing tracebox or traceline. ._.
//	player_collision ();	
//	Player_Collision (self);

//	Player_Collision_Controller ();
};

/*
================
CheckPowerups

Check for turning off powerups
================
*/
void() CheckPowerups =
{
	if (self.health <= 0) return;

	// Invisibility
	if (self.invisible_finished)
	{
		// Sound and screen flash when items starts to run out
		if (self.invisible_sound < time)
		{
			sound (self, CHAN_AUTO, "items/inv3.wav", 0.5, ATTN_IDLE);
			self.invisible_sound = time + ((random() * 3) + 1);
		}


		if (self.invisible_finished < time + 3)
		{
			if (self.invisible_time == 1)
			{
				if (cvar("skill") <= 4) sprint(self, "", "The Ring of Shadows' magic is fading...\n");
				else if (cvar("skill") == 5) sprint(self, "", "The Ring of Shadows' magic begins to fade away...\n");
				
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/inv2.wav", 1, ATTN_NORM);
				self.invisible_time = time + 1;
			}
			if (self.invisible_time < time)
			{
				self.invisible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}
		if (self.invisible_finished < time)
		{	
			// Just stopped
			self.items -= IT_INVISIBILITY;
			self.invisible_finished = 0;
			self.invisible_time = 0;
		}
		// Use the eyes
		self.frame = 0;
		self.modelindex = modelindex_eyes;
	}
	// HIPNOTIC: MED 12/04/96 added mjolnir stuff
	else if (self.weapon == IT_MJOLNIR) self.modelindex = modelindex_hammer;   // Don't use eyes
	else self.modelindex = self.modelindex_nqwplayer;			   // Don't use eyes

	// Invincibility
	if (self.invincible_finished)
	{											
		// Sound and screen flash when items starts to run out
		if (self.invincible_finished < time + 3)
		{
			if (self.invincible_time == 1)
			{
				if (cvar("skill") <= 4) sprint(self, "", "The Pentragram's Protection is almost burned out...\n");
				else if (cvar("skill") == 5) sprint(self, "", "The unholy ward is burning out...\n");
				
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
				self.invincible_time = time + 1;
			}
			if (self.invincible_time < time)
			{
				self.invincible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}
		if (self.invincible_finished < time)
		{	
			// Just stopped
			self.items -= IT_INVULNERABILITY;
			self.invincible_time = 0;
			self.invincible_finished = 0;	
		}
		if (self.invincible_finished > time)
		{
			self.effects |= EF_RED;
			self.effects |= EF_DIMLIGHT;
		}
		else
		{
			self.effects -= self.effects & (EF_RED);
			self.effects -= self.effects & (EF_DIMLIGHT);
		}
	}
	
	// Spawn protection
	if (self.spawn_protection_finished)
	{
		// Sound and screen flash when items starts to run out
		if (self.spawn_protection_finished < time + 3)
		{
			if (self.spawn_protection_time == 1)
			{				
				sprint(self, "Spawn Protection is waning...\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
				self.spawn_protection_time = time + 1;
			}
			if (self.spawn_protection_time < time)
			{
				self.spawn_protection_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}
		if (self.spawn_protection_finished < time)
		{	
			// Just stopped
			sprint(self, "Spawn Protection desolved...\n");
			self.spawn_protection_time = 0;
			self.spawn_protection_finished = 0;
		}
		if (self.spawn_protection_finished > time)
		{
			self.effects |= EF_RED;
			self.effects |= EF_BRIGHTFIELD;
			self.effects |= EF_DIMLIGHT;
		}
		else
		{
			self.effects -= self.effects & (EF_BRIGHTFIELD);
			self.effects -= self.effects & (EF_RED);
			self.effects -= self.effects & (EF_DIMLIGHT);
		}
	}	

	// Super damage
	if (self.super_damage_finished)
	{
		// Sound and screen flash when items starts to run out
		if (self.super_damage_finished < time + 3)
		{
			if (self.super_time == 1)
			{
				if (cvar("skill") <= 4) sprint(self, "", "Quad Damage is wearing off...\n");
				else if (cvar("skill") == 5) sprint (self, "Quad damage's power weakens...\n");
				
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
				self.super_time = time + 1;
			}

			if (self.super_time < time)
			{
				self.super_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}
		if (self.super_damage_finished < time)
		{	
		        // Just stopped
			self.items -= IT_QUAD;
			self.super_damage_finished = 0;
			self.super_time = 0;
		}
		if (self.super_damage_finished > time)
		{
			self.effects |= EF_BLUE;
			self.effects |= EF_DIMLIGHT;
		}
		else
		{
			self.effects -= self.effects & (EF_BLUE);
			self.effects -= self.effects & (EF_DIMLIGHT);
		}	
	}
	
	// Suit
	if (self.radsuit_finished)
	{
		self.air_finished = time + 12; // Don't drown
		// Sound and screen flash when items starts to run out
		if (self.radsuit_finished < time + 3)
		{
			if (self.rad_time == 1)
			{
				if (cvar("skill") <= 4) sprint(self, "", "The Air Supply in your Biosuit is expiring...\n");
				else if (cvar("skill") == 5) sprint(self, "", "The Air Supply in your Biosuit is running dry...\n");
				
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.rad_time = time + 1;
			}

			if (self.rad_time < time)
			{
				self.rad_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}
		if (self.radsuit_finished < time)
		{	
			// Just stopped
			self.items -= IT_SUIT;
			self.rad_time = 0;
			self.radsuit_finished = 0;
		}
	}
	// HIPNOTIC: JIM
	// Wetsuit
	if (self.wetsuit_finished)
	{
		self.air_finished = time + 12; // Don't drown
		// Sound and screen flash when items starts to run out
		if (self.wetsuit_finished < time + 3)
		{
			if (self.wetsuit_time == 1)
			{
				if (cvar("skill") <= 4) sprint (self, "", "The Air Supply in your Wetsuit is running out...\n");
				else if (cvar("skill") == 5) sprint (self, "", "The Air Supply in your Wetsuit is running dry...\n");
				
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.wetsuit_time = time + 1;
			}

			if (self.wetsuit_time < time)
			{
				self.wetsuit_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}
		if (self.wetsuit_finished < time)
		{	
			// Just stopped
			// HIPNOTIC: MED
			self.expansionitems -= HIP_IT_WETSUIT;
			self.wetsuit_time = 0;
			self.wetsuit_finished = 0;
		}
	}
	// HIPNOTIC: MED
	// Empathy Shields
	if (self.empathy_finished)
	{
		// Sound and screen flash when items starts to run out
		if (self.empathy_finished < time + 3)
		{
			if (self.empathy_time == 1)
			{
				if (cvar("skill") <= 4) sprint (self, "", "Empathy Shields are running out...\n");
				else if (cvar("skill") == 5) sprint (self, "", "Empathy Shields is turning to dust...\n");
				
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.empathy_time = time + 1;
			}
			if (self.empathy_time < time)
			{
				self.empathy_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}
		if (self.empathy_finished < time)
		{	
			// Just stopped
			// HIPNOTIC: MED
			self.expansionitems -= HIP_IT_EMPATHY_SHIELDS;
			self.empathy_time = 0;
			self.empathy_finished = 0;
		}
		// HIPNOTIC: MED
		if (self.empathy_finished > time) self.effects |= EF_DIMLIGHT;
		else self.effects -= self.effects & (EF_DIMLIGHT);
	}
	// Power Shield
	if (self.shield_finished)
	{
		if (self.shield_finished < time + 3)
		{
			if (self.shield_time == 1)
			{
				if (cvar("skill") <= 4) sprint (self, "", "The Power Shield is failing...\n");
				else if (cvar("skill") == 5) sprint (self, "", "The Power Shield is falling apart...\n");
				
				sound (self, CHAN_AUTO, "shield/fadeout.wav", 1, ATTN_NORM);
				self.shield_time = 0;
			}
			if (self.shield_time < time)
			{
				self.shield_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}		
		if (self.shield_finished < time)
		{
			if (cvar("skill") <= 4) sprint (self, "", "Power Shield Lost...\n");
			else if (cvar("skill") == 5) sprint (self, "", "The Power Shield disintegrates...\n");
			
			self.shield_finished = 0;
			self.expansionitems -= DOE_SHIELD;
		}
	}
	// Anti-Grav Belt
	if (self.antigrav_finished)
	{
		if (self.antigrav_finished < time + 3)
		{
			if (self.antigrav_time == 1)
			{
				if (cvar("skill") <= 4) sprint (self, "", "The Anti-Grav Belt is failing...\n");
				else if (cvar("skill") == 5) sprint (self, "", "The Anti-Grav Belt's batteries are almost depleted...\n");
				
				self.antigrav_time = 0;
				sound (self, CHAN_AUTO, "belt/fadeout.wav", 1, ATTN_NORM);
			}
			if (self.antigrav_time < time)
			{
				self.antigrav_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}	
		if (self.antigrav_finished < time)
		{
			if (cvar("skill") <= 4) sprint (self, "", "Anti-Grav Belt Lost...\n");
			else if (cvar("skill") == 5) sprint (self, "", "The Anti-Grav Belt's batteries have reached 0%...\n");
			
			self.antigrav_finished = 0;
			self.expansionitems -= DOE_ANTIGRAV;
			self.gravity = 1.0;
		}
	}
};

void() xpackEnding;
// .float hook_saveout;
/*
================
PlayerPostThink

Called every frame after physics are run
================
*/
void() PlayerPostThink =
{
	if (self.view_ofs == '0 0 0')
	{
		earthquake_postthink ();
		return;     // intermission or finale
	}

	// HIPNOTIC: JIM
	// WETSUIT
	if (self.wetsuit_finished > time)
	{
		if (self.waterlevel == 2) self.velocity *= 0.8;					
		if (self.waterlevel == 3) self.velocity *= 0.66;
	}
			
	earthquake_postthink ();

	if (self.deadflag) return;
		
	if (cutscene_running) xpackEnding ();
				
	// Do weapon stuff
	W_WeaponFrame ();

	// Do rot stuff (Health, Armor)
	Item_Rot_Systems ();
	
//	self.total_teamscore_red = TeamScore[TEAM_RED_4];
//	self.total_teamscore_blue = TeamScore[TEAM_BLUE_13];
//	PlayerScore[self.colormap] = self.frags;
	
	// Check to see if player landed and play landing sound
	if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) && (self.health > 0))
	{
		if (self.watertype == CONTENT_WATER) sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
		else if (self.jump_flag < -650)
		{
			if (self.health <= 5) self.deathtype = "falling"; // Sleeper: Moved up to allow the bprint to work properly the first time.
			if (cvar("falldamage")) T_Damage (self, world, world, 5);
			if (self.health <= 0) sound (self, CHAN_VOICE, self.nqwSndFallDeath, 1, ATTN_NONE);
			else sound (self, CHAN_VOICE, self.nqwSndLand2, 1, ATTN_NORM);
		}
		else sound (self, CHAN_VOICE, self.nqwSndLand1, 1, ATTN_NORM);
		self.jump_flag = 0;
	}

	if (!(self.flags & FL_ONGROUND)) self.jump_flag = self.velocity_z;
		
	// Sleeper: Modified to have certain monsters reward greater or less points.	
	// AY 11 Nov 2021, check killspree end
	local float score, streak;
	if ((self.killspree > 0) && (time > self.killtime))
	{
		dprint ("killspree ended.\n");
		score = ceil (self.killtotal);
		streak = ceil (self.killspree);
		if (self.killspree > 1) sprint (self, "Streak Ended with ", ftos(streak), " Monster Frags (+", ftos(score), " Points)\n"); // Sleeper: Only print something to the player when they have 2 or more in a killing spree.
//		self.frags += score;	
		add_frag (self, score);
		self.killspree = 0; // Reset killspree
		self.killcount = 0; // Reset killcount
		self.killtotal = 0; // Reset killtotal
	}		
		
	CheckPowerups ();
	
	// Displays if server is public and is coop, DM or TDM.
	Send_MOTD ();	
	
	// Runner's Delight: get player speed
	local vector v;
	v_x = self.velocity_x;
	v_y = self.velocity_y;
	self.speed = vlen(v);
		
//	Player_Collision (self);
//	Player_Collision_Controller ();
};

// Sleeper: Detect if we're playing on a QuakeWorld client or a Net Quake client.
void() Detect_Client =
{
        // Identify/advertise the player's client in use.
        local string myClient;
        local string text = "";   
        
        myClient = string_null;      
        myClient = infokey (self, "*ver");                              // FTE and QSS
        
        if (myClient != "")
        {
		if (substring(myClient, 0, 5) == "QSS-M") self.client = QSSM_CLIENT;
		if (substring(myClient, 0, 3) == "FTE") self.client = FTEQW_CLIENT;                                
        }		
	else
	{	
		myClient = infokey (self, "*client");                   // ezQuake
		if (myClient != "") self.client = EzQ_CLIENT;
		else
		{
			myClient = "Vanilla/Unknown Quake";
			self.client = VANILLA_CLIENT;	
		}
        }
        
        text = sprintf (" using %s.\n", myClient);                
        local string red_text = sprintf ("%s has connected%s", self.netname, text);      
	bprint (redify(red_text)); // Sleeper: Only print something on the first connect.
	
	/*
	// Sleeper: Warn players they must download the assets.
	sprint (self, "\nIf you are downloading assets, there are somethings required in order to play on this server. What is also required  is a source port that has a high engine limit such as FTE QuakeWorld or QS/QSS/QSS-M. Protocol 999 is recommended due to the server having all assets from the base game, mission packs and deathmatch game modes all at once as the server is meant to be played in any official mode (Single Player, Co-Op, Custom Co-Op (Nu-Coop Influenced), Duel, FFA, TDM, CTF, OneFlagCTF, Arena (Clan, Rocket), etc). After when downloading assets are complete, you may switch FTE  Extensions back on. Otherwise, you're free to disconnect.\n");
	sprint (self, "\n");
	sprint (self, "Assets are as follows:\n");
	sprint (self, "\n");
	sprint (self, "* Custom Player Models\n");
	sprint (self, "* Custom Player Sounds\n");
	sprint (self, "* Custom Weapon Models\n");
	sprint (self, "* All Mission Pack Content (I, II, DOPA & MG1)\n");
	sprint (self, "* Deathmatch Content (CTF)\n");
	sprint (self, "* Custom Maps (Deathmatch & Co-Op)\n");
	sprint (self, "\n");
	sprint (self, "A download link for direct download is unavailable at this time, but will be given once server is fully developered. Otherwise, disconnect or have fun. (Note that you will need to install the mission pack content yourself, 'cuz that would be piracy if the server allowed players to download that!)\n\n");
	*/
};

/*
void() new_key_owners =
{
	local entity all_players = find (world, classname, "player");
	while (all_players != world)
	{
		if (all_players.items & (IT_KEY1 | IT_KEY2) && !(self.items & (IT_KEY1 | IT_KEY2))) 
		{
			self.keytaker = all_players.keytaker;
			return;
		}
		all_players = find (all_players, classname, "player");
	}
};
*/
	
/*
===========
ClientConnect

Called when a player connects to a server
============
*/
void() ClientConnect =
{	
	Detect_Client (); // Sleeper: What client is the player using?
	
	// Put everyone that first connected into FTE Spectator mode.	
	if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF) SpectatorFirstConnect ();		
			
	// Aliases	
	Send_Coop_Aliases(); // Send Co-Op aliases when playing Co-Op.
	Send_DM_Aliases(); // Send Deathmatch aliases when playing Deathmatch.		
	Send_General_Aliases(); // Send commands, information, etc.
	Send_Enforced_Settings(); // Send enforced settings.			      
	MOTD_Skill(); // Display the current skill that the server is being played on.   
	MOTD_Sounds(); // Make greeting sounds.	
	
//	new_key_owners ();	
	// Keep MOTD displayed if client is a new player.
	if (parm17 & NEW_PLAYER_MOTD) 
	{
		self.greet = ENABLE_MOTD;
		parm17 -= parm17 & (NEW_PLAYER_MOTD);
	}
					
	// Sleeper: Inherit weapons and ammo from an existing player on the server in coop.
	if (cvar("coop") == REIGNITED_COOP || cvar("coop") == ENHANCED_COOP)
	{	
		if (!cvar("deathmatch") && !cvar("horde"))
		{
			if (parm17 & NEW_PLAYER_INIT) 
			{
				InheritParms ();
				parm17 -= parm17 & (NEW_PLAYER_INIT);
			}
		}
	}
	
	// Sleeper: Equip the Shotgun on the first spawn in Custom Coop.
	if (cvar("customcoop") && cvar("coop") && !cvar("deathmatch")) self.weapon = IT_SHOTGUN;								
										 
	if (parm17 & CLIENT_ENTERED)
	{
		// Cooperative & Single Player
		if ((coop >= 0 && cvar("sv_public") == 1) || (coop >= REIGNITED_COOP && !cvar("sv_public")))
		{
			if (!deathmatch)
			{
				// iD1 Game World
				if (gameworld == ID1)
				{
					if (cvar("skill") <= 4) bprint (self.netname, " entered the game\n");
					else bprint (self.netname, " entered the game with a Deathwish!\n");
				}
				// Hipnotic Game World
				else if (gameworld == HIPNOTIC)	
				{
					if (cvar("skill") <= 4) bprint (self.netname, " entered the game\n");
					else bprint (self.netname, " entered the game with Slickness!\n");
				}
				// Rogue Game World
				else if (gameworld == ROGUE)
				{
					if (cvar("skill") <= 4) bprint (self.netname, " entered the game\n");
					else bprint (self.netname, " has gone Rogue!\n");	
				}
				// DOPA Game World
				else if (gameworld == DOPA)
				{
					if (cvar("skill") <= 4) bprint (self.netname, " entered the game\n");
					else bprint (self.netname, " entered an Otherworldly place!\n");	
				}
				// MG1 Game World
				else if (gameworld == MG1)
				{
					if (cvar("skill") <= 4) bprint (self.netname, " entered the game\n");
					else bprint (self.netname, " entered The Machine!\n");	
				}
				// Default
				else bprint (self.netname, " entered the game\n");
			}		
		}
		// Free For All & Duels
		else if (deathmatch == DM_DUEL || deathmatch == DM_FFA) bprint (self.netname, " entered the arena eternal\n");		
		parm17 -= parm17 & (CLIENT_ENTERED);
	}	
						
	//ZOID--
	self.suicide_count = 0;
	self.ctf_killed = 0;
	
 	// If this is our first connection, parm9 is < 0
 	// Set lastteam negative.
 	if (deathmatch == DM_DUEL || deathmatch == DM_FFA)
 	{
		if (!coop) self.steam = -1;
	}
 	if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF)
 	{
		if (parm12 < 0 && teamplay > 0)
		{
			self.steam = -50; // always reassign	
			TeamSetSkin ();	
			TeamCheckLock ();
		}
	}
	if (coop)
	{
		if (parm12 < 0 && teamplay > 0)
		{
			self.steam = -50; // always reassign	
			TeamSetSkin ();	
			TeamCheckLock ();	
		}
	}									
	//--ZOID			
	
	// Increment player count when a player connects
	if (self.netname != "[overseer]-BOT") num_players++;
	if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF)
	{
		if (self.team == TEAM1) redteam++;
		if (self.team == TEAM2) blueteam++;
		if (self.team == TEAM3) greyteam++;
	}
		
	self.vote_wait = time + 30;	
	self.ltime = time;

	if (cvar("customcoop") && num_players >= 2 && cvar("skill") <= 2)
	{
		Skill_Scaled ();
		cvar_set ("skill", "3");	
	}
	if (cvar("customcoop") && num_players <= 1)
	{
		if (cvar("skill") <= 1 || cvar("skill") == 3)
		{
			Skill_Scaled ();
			cvar_set ("skill", "2");	
		}
	}	
		
	// No bot support yet.	
	if (self.flags & FL_ISBOT)
	{
		self.nqwNextCharacter = rint(random() * 32768) % NQW_CHARCS_MAX;
		self.nqwCharacter = self.nqwNextCharacter;
		parm64 = self.nqwCharacter;
		self.nqwSkin = rint(random() * 32768);
		parm63 = self.nqwSkin;
	}
		
	// A client connecting during an intermission can cause problems
	if (intermission_running) ExitIntermission ();
};


/*
============
ClientDisconnect

Called when a player disconnects from a server
============
*/
void() ClientDisconnect =
{
	local float intro_maps = (world.model == "maps/start.bsp" || world.model == "maps/hipstart.bsp" || world.model == "maps/rstart.bsp" || world.model == "maps/e5start.bsp" || world.model == "maps/mgstart.bsp" || world.model == "maps/hub.bsp" || world.worldtype == WORLDTYPE_HUB);
	
	// If the level end trigger has been activated, just return
	// since they aren't *really* leaving.							
	if (gameover) return;
	
//	self.leaving_client = FALSE;
		
	if (self.netname != "[overseer]-BOT") num_players--; // Subtract when a player disconnect.

	if (self.has_voted == 1) num_votes -= 1;
	
	// Stop MVD demos automatically when the server holds less than 3 players.	
	if (num_players <= 2) localcmd ("stop\n");
	
	if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF && !coop)
	{
		if (self.team == TEAM1) redteam--;
		if (self.team == TEAM2) blueteam--;
		if (self.team == TEAM3) greyteam--;
	}	
	
//	if (parm17 & CLIENT_SPECTATOR) return;
	
	// Single Player and Co-Op Prints
	if (coop >= 0 && !deathmatch) bprint (self.netname, " left the game with ", ftos(self.frags), " frags\n");
	
	// Deathmatch Prints
	if (deathmatch == DM_DUEL || deathmatch == DM_FFA) 
	{
		if (!coop) bprint (self.netname, " left the arena eternal with ", ftos(self.frags), " frags\n");
	}
				
//	if (self.spectator == 0 && self.in_game == 0) bprint (self.netname, " left the arena eternal with ", ftos(self.frags), " frags\n");	
	if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF && !coop) 
	{
		if (parm17 & CLIENT_JOINED) bprint (self.netname, " left the arena eternal with ", ftos(self.frags), " frags\n");
	}
						
	// yoder oct13, horde fix for dc-ing players
	if (cvar("horde") && coop >= 0 && !deathmatch)
	{
		dprint ("horde mode, player disconnect\n");
		bprint (self.netname, " vanished with ", ftos(self.frags), " frags\n");
		self.health = 0;
	}
	
	sound (self, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE);	
	
	if (cvar("customcoop") && num_players <= 1)
	{
		if (cvar("skill") <= 1 || cvar("skill") == 3) cvar_set("skill", "2");
	}
							
	sphere_remove (self);
//	if (tag_token_owner == self) tag_token_drop ();	
//ZOID--
	TeamDropFlagOfPlayer (self);
//	self.steam = -50;
//	self.team = 0;
//--ZOID		
	set_suicide_frame ();
	
	// Sleeper: No free ammo and weapons from disconnected players in Deathmatch or on start maps when playing Cooperative
	// unless it's Classic Coop or Single Player, but still exclude start maps.
	if ((!intro_maps) && !cvar("deathmatch"))
	{
		if (cvar("coop") == CLASSIC_COOP || !cvar("coop")) DropBackpack ();
	}
			
	// Sleeper: Return keys back to the world if there are no existing players.
	if (self.items & (IT_KEY1 | IT_KEY2)) respawn_keys ();	
	
	if (parm17 & CLIENT_JOINED) parm17 -= parm17 & (CLIENT_JOINED);
};

void() SpectatorFirstConnect = {stuffcmd (self, "observe\n"); parm17 |= CLIENT_SPECTATOR;};

/*
================
SpectatorConnect

Called when a spectator connects to the server
================
*/
void() SpectatorConnect =
{	
	SetSpecParms();
	DecodeLevelParms ();
		
	spectating_players++;
	self.spectator = 1;
	self.in_game = 0;
	stuffcmd (self, "color 0\n"); // Sleeper: Spectator colors.
	if (spectating_players != 1) string s = "s";	
	
	if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF && !coop)
	{
		if (self.steam == TEAM1) redteam--;
		if (self.steam == TEAM2) blueteam--;
		if (self.steam == TEAM3) greyteam--;
	}	
	
	dprint ("\nThere is ");
	dprint (ftos(spectating_players), " spectating player", s, "\n");	
	
	self.goalentity = find (self.goalentity, classname, "info_intermission");
	
	setorigin (self, self.goalentity.origin);		
	self.angles = self.goalentity.mangle;
	self.fixangle = 1; // Turn this way immediately
	
	if (parm17 & CLIENT_SPECTATOR_MOVED) 
	{
		bprint (self.netname, " has moved to the sidelines\n");
		parm17 -= parm17 & CLIENT_SPECTATOR_MOVED;
		return;
	}
	
	if (parm17 & CLIENT_SPECTATOR_ENTERED) 
	{
		bprint (self.netname, " has joined the spectators\n");
		parm17 -= parm17 & CLIENT_SPECTATOR_ENTERED;
	}	
};

/*
================
SpectatorDisconnect

Called when a spectator disconnects from the server
================
*/
void() SpectatorDisconnect =
{
	bprint (self.netname, " has left the sidelines\n");
	
	spectating_players--;
	self.spectator = 0;
	self.in_game = 1;
	
	if (spectating_players != 1) string s = "s";
	
	dprint ("\nThere is ");
	dprint (ftos(spectating_players), " spectating player", s, "\n");	
};

void() Spectator_Join =
{
	if (cvar("deathmatch") >= DM_TDM && cvar("deathmatch") <= DM_OneFlagCTF) id1_centerprint (self, "", "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nPress JUMP to be auto-assigned\n to a team.\n");
	if (self.button2) stuffcmd (self, "-jump ; join \n");	
};

/*
==============
SpectatorThink

Called every frame after physics run
==============
*/
void() SpectatorThink =
{
	// self.origin, etc. contains spectator position, so you could
	// do some neat stuff here.
//	if (self.impulse == 1) SpectatorImpulseCommand ();
	
	Spectator_Join ();
};

/*
==============
ClientObituary

Called when a player dies
==============
*/
void(entity targ, entity attacker) ClientObituary =
{
	// From GPL QW source	
//	local float attackerteam = attacker.team, targteam = targ.team;
	local float rnum = random();		
	if (coop && customcoop_flags) // Sleeper: For Custom Coop.
	{
		if (attacker.owner != other) attacker.owner = other;
		if (targ.flags & FL_MONSTER) // Any monster
		{
			if (attacker.classname == "teledeath")
			{
				if (attacker.owner.classname == "player") bprint (targ.netname, " was telefragged by ", attacker.owner.netname, "\n");	
			}
			if (attacker.classname == "teledeath2") bprint ("Satan's power deflects ", targ.netname, "'s telefrag\n");
			if (attacker.classname == "player") // A player
			{	
				// Melee kills
				if (attacker.weapon == IT_AXE)
				{
					bprint (targ.netname);
					// Quadded Melee kills
					if (attacker.super_damage_finished > time) // Added
					{
						rnum = random ();
						if (rnum < 0.3) bprint (" got his block knocked off by ");
						else if (rnum < 0.6) bprint (" was sent to God, thanks to ");
						else bprint (" was split in two by ");
						bprint (attacker.netname, "\n");
					}
					// Unquadded Melee Kills
					else if (attacker.nqwCharacter == NQW_DOOMGUY) bprint (" was fisted by ", attacker.netname, "\n"); 	  // Added
					else if (attacker.nqwCharacter == NQW_SCALEBEARER) bprint (" was pummeled by ", attacker.netname, "\n");  // Added
					else if (attacker.nqwCharacter == NQW_SORLAG) bprint (" was clawed by ", attacker.netname, "\n");         // Added
					else if (attacker.nqwCharacter == NQW_DUKENUKEM) bprint (" ate ", attacker.netname, "'s size 13 boot\n"); // Added
					else if (attacker.nqwCharacter == NQW_DUSKDUDE) bprint (" was reaped by ", attacker.netname, "\n");       // Added
					else bprint (" was ax-murdered by ", attacker.netname, "\n");
				}
				// Off-hand grappling hook kills
				if (targ.dmg_inflictor.classname == "hook")
				{
					bprint (targ.netname);
					if (rnum < 0.4) bprint (" was grappled by ");
					else bprint (" was hooked by ");
					bprint (attacker.netname, "\n");
				}
				// Shotgun kills								
				if (attacker.weapon == IT_SHOTGUN)
				{
					if (attacker.super_damage_finished > time) bprint (targ.netname, " was lead poisoned by ", attacker.netname, "\n");
					else bprint (targ.netname, " chewed on ", attacker.netname, "'s boomstick\n");
				}
				// Super Shotgun kills
				if (attacker.weapon == IT_SUPER_SHOTGUN)
				{
					if (attacker.super_damage_finished > time) bprint (targ.netname, " ate 8 loads of ", attacker.netname, "'s buckshot\n");
					else bprint (targ.netname, " ate on 2 loads of ", attacker.netname, "'s buckshot\n");
				}
				// Nailgun kills
				if (attacker.weapon == IT_NAILGUN)
				{
					if (attacker.super_damage_finished > time) bprint (targ.netname, " was body pierced by ", attacker.netname, "\n");
					else bprint (targ.netname, " was nailed by ", attacker.netname, "\n");
				}	
				// Super Nailgun kills					
				if (attacker.weapon == IT_SUPER_NAILGUN)
				{
					if (attacker.super_damage_finished > time) bprint (targ.netname, " was ventilated by ", attacker.netname, "\n"); // Added
					else bprint (targ.netname, " was punctured by ", attacker.netname, "\n");
				}
				// Grenade Launcher kills
				if (attacker.weapon == IT_GRENADE_LAUNCHER)
				{
					if (targ.classname == "monster_ogre" || targ.classname == "monster_demon1") 
					{
						if (targ.health < -80) bprint (targ.netname, " was gibbed by ", attacker.netname, "'s grenade\n");
						else bprint (targ.netname, " eats ", attacker.netname, "'s pineapple\n");
					}
					else if (targ.classname == "monster_shalrath")
					{
						if (targ.health < -90) bprint (targ.netname, " was gibbed by ", attacker.netname, "'s grenade\n");
						else bprint (targ.netname, " eats ", attacker.netname, "'s pineapple\n");
					}
					else if (targ.classname == "monster_shambler")
					{
						if (targ.health < -60) bprint (targ.netname, " was gibbed by ", attacker.netname, "'s grenade\n");
						else bprint (targ.netname, " eats ", attacker.netname, "'s pineapple\n");
					}
					else if (targ.classname == "monster_army" || targ.classname == "monster_dog" || targ.classname == "monster_enforcer" || targ.classname == "monster_scourge")
					{
						if (targ.health < -35) bprint (targ.netname, " was gibbed by ", attacker.netname, "'s grenade\n");
						else bprint (targ.netname, " eats ", attacker.netname, "'s pineapple\n");						
					}
					else if (targ.classname == "monster_zombie" || targ.classname == "monster_mummy") bprint (targ.netname, " was gibbed by ", attacker.netname, "'s grenade\n");
					else if (targ.classname == "monster_vomit" || targ.classname == "monster_vomitus" || targ.classname == "monster_tarbaby" ||
						 targ.classname == "monster_sword" || targ.classname == "monster_lava_man" || targ.classname == "monster_wrath" || targ.classname == "monster_super_wrath" || targ.classname == "monster_morph" || targ.classname == "monster_dragon") 
						bprint (targ.netname, " eats ", attacker.netname, "'s pineapple\n");
					else if (targ.classname == "monster_fish") 
					{
						if (targ.health < -20) bprint (targ.netname, " was gibbed by ", attacker.netname, "'s grenade\n");
						else bprint (targ.netname, " eats ", attacker.netname, "'s pineapple\n");
					}
					else if (targ.classname == "monster_eel")
					{
						if (targ.health < -12) bprint (targ.netname, " was gibbed by ", attacker.netname, "'s grenade\n");
						else bprint (targ.netname, " eats ", attacker.netname, "'s pineapple\n");
					}
					else
					{
						if (targ.health < -40) bprint (targ.netname, " was gibbed by ", attacker.netname, "'s grenade\n");
						else bprint (targ.netname, " eats ", attacker.netname, "'s pineapple\n");
					}
				}
				// Rocket Launcher kills
				if (attacker.weapon == IT_ROCKET_LAUNCHER)
				{
					// Quadded Rocket Launcher kills
					if (attacker.super_damage_finished > time) // Added
					{
						rnum = random ();
						if (rnum < 0.3) bprint (targ.netname, " was brutalized by ", attacker.netname, "'s quad rocket\n");
						else if (rnum < 0.6) bprint (targ.netname, " was smeared by ", attacker.netname, "'s quad rocket\n");
						else bprint (attacker.netname, " rips ", targ.netname, " a new one\n");
					}
					// Unquadded Rocket Launcher kills
					else
					{
						if (targ.classname == "monster_ogre" || targ.classname == "monster_demon1") 
						{
							if (targ.health < -80) bprint (targ.netname, " was gibbed by ", attacker.netname, "'s rocket\n");
							else bprint (targ.netname, " rides ", attacker.netname, "'s rocket\n");
						}
						else if (targ.classname == "monster_shalrath")
						{
							if (targ.health < -90) bprint (targ.netname, " was gibbed by ", attacker.netname, "'s rocket\n");
							else bprint (targ.netname, " rides ", attacker.netname, "'s rocket\n");
						}
						else if (targ.classname == "monster_shambler")
						{
							if (targ.health < -60) bprint (targ.netname, " was gibbed by ", attacker.netname, "'s rocket\n");
							else bprint (targ.netname, " rides ", attacker.netname, "'s rocket\n");
						}
						else if (targ.classname == "monster_army" || targ.classname == "monster_dog" || targ.classname == "monster_enforcer" || targ.classname == "monster_scourge")
						{
							if (targ.health < -35) bprint (targ.netname, " was gibbed by ", attacker.netname, "'s rocket\n");
							else bprint (targ.netname, " rides ", attacker.netname, "'s rocket\n");						
						}
						else if (targ.classname == "monster_zombie" || targ.classname == "monster_mummy") bprint (targ.netname, " was gibbed by ", attacker.netname, "'s rocket\n");
						else if (targ.classname == "monster_vomit" || targ.classname == "monster_vomitus" || targ.classname == "monster_tarbaby" ||
							 targ.classname == "monster_armagon" ||
							 targ.classname == "monster_sword" || targ.classname == "monster_lava_man" || targ.classname == "monster_wrath" || targ.classname == "monster_super_wrath" || targ.classname == "monster_morph" || targ.classname == "monster_dragon") 
							bprint (targ.netname, " rides ", attacker.netname, "'s rocket\n");
						else if (targ.classname == "monster_fish") 
						{
							if (targ.health < -20) bprint (targ.netname, " was gibbed by ", attacker.netname, "'s rocket\n");
							else bprint (targ.netname, " rides ", attacker.netname, "'s rocket\n");
						}
						else if (targ.classname == "monster_eel")
						{
							if (targ.health < -12) bprint (targ.netname, " was gibbed by ", attacker.netname, "'s rocket\n");
							else bprint (targ.netname, " rides ", attacker.netname, "'s rocket\n");
						}
						else
						{
							if (targ.health < -40) bprint (targ.netname, " was gibbed by ", attacker.netname, "'s rocket\n");
							else bprint (targ.netname, " rides ", attacker.netname, "'s rocket\n");
						}					
					}
				}
				// Empathy Shield kills
				if (empathyused == 1)
				{
					bprint (targ.netname);
					if (random() < 0.5) bprint (" shares ");
					else bprint (" feels ");
					bprint (attacker.netname, "'s pain\n");
				}
				// Proximity Gun kills
				if (targ.dmg_inflictor.classname == "proximity_grenade")
				{
					bprint (targ.netname);
					if (random() < 0.5) bprint (" got too friendly with ");
					else bprint (" did the rhumba with ");
					bprint (attacker.netname, "'s bomb\n");
				}
				// Thunderbolt kills							
				if (attacker.weapon == IT_LIGHTNING)
				{
					bprint (targ.netname);
					if (attacker.super_damage_finished > time && attacker.waterlevel > 1) bprint (" gets a natural disaster from ", attacker.netname, "\n");
					else
					{
						if (attacker.waterlevel > 1) bprint (" accepts ", attacker.netname, "'s discharge\n");
						else bprint (" accepts ", attacker.netname, "'s shaft\n");
					}
				}
				// Laser Cannon kills
				if (attacker.weapon == IT_LASER_CANNON)
				{
					if (random() < 0.5) bprint(targ.netname, " was toasted by ", attacker.netname, "'s laser\n");
					else bprint(targ.netname, " was radiated ", attacker.netname, "'s laser\n");
				}
				// Thor's Hammer kills
				if (attacker.weapon == IT_MJOLNIR) bprint (targ.netname, " was slammed by ", attacker.netname, "'s hammer\n");
				// Lava Nail kills
				if (attacker.weapon == DOE_LAVA_NAILGUN || attacker.weapon == DOE_LAVA_SUPER_NAILGUN) bprint (targ.netname, " was burned by ", attacker.netname, "\n");
				// Multi-Rocket kills
				if (attacker.weapon == DOE_MULTI_GRENADE || attacker.weapon == DOE_MULTI_ROCKET) bprint (targ.netname, " was blasted to bits by ", attacker.netname, "\n");
				// Plasma kills
				if (attacker.weapon == DOE_PLASMA_GUN) bprint (targ.netname, " was fused by ", attacker.netname, "\n");			
			}			
			if (targ.classname == "trap_spike_mine") bprint ("A homing ", targ.netname, " has been vanquished\n");	
			// Sleeper: Chthon as a Vadri'gar is being handled it's .qc.													
			if (targ.classname == "monster_goroth") bprint ("Vadri'gar Goroth was defeated by ", attacker.netname, "!\n");
			if (targ.classname == "monster_volkerh") bprint ("Vadri'gar Volkerh was defeated by ", attacker.netname, "!\n");	
			return;
		}
	}
		
	if (targ.classname == "player")
	{
// ZOID--
		TeamResetCarrier(targ);
// --ZOID	
		if (attacker.classname == "teledeath")
		{
			// Cooperative 
			if (coop && !deathmatch && targ.classname == "player" && attacker.owner.classname == "player" && targ != attacker.owner) // Co-Operative
			{
				// Team Player telefragging allies
				if (num_players <= 2)
				{
					if (rnum > 0.4) bprint (attacker.owner.netname, " perforated their ally\n");
					else bprint (attacker.owner.netname, " telefragged their ally\n");
				}
				else
				{	
					if (rnum > 0.4) bprint (attacker.owner.netname, " perforated an ally\n");
					else bprint (attacker.owner.netname, " telefragged an ally\n");
				}	
				if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp")
					add_frag (attacker.owner, -1);
//					attacker.owner.frags -= 1; // Deduct a frag from the team killer				
			}
			// Team Deathmatch, Capture The Flag, One Flag CTF
			else if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF && !coop) // Targ was killed by a teammate player in Team Deathmatch
			{
				if (targ.steam == attacker.owner.steam)
				{
					// Team Player telefragging teammates
					if (rnum > 0.4) bprint (attacker.owner.netname, " perforated their teammate\n");
					else bprint (attacker.owner.netname, " telefragged their teammate\n");	
					add_frag (attacker.owner, -1);				
//					attacker.owner.frags -= 1; // Deduct a frag from the team killer
				}
				else
				{
					// Team Player telefragging Enemy Player
					if (rnum > 0.4) bprint (targ.netname, " was perforated by ", attacker.owner.netname, "\n");
					else bprint (targ.netname, " was telefragged by ", attacker.owner.netname, "\n");
					add_frag (attacker.owner, 1);				
//					attacker.owner.frags += 1; // Deduct a frag from the team killer
				}
			}			
			// Duel, Free For All
			else if (deathmatch == DM_DUEL || deathmatch == DM_FFA)
			{
				if (!coop)
				{
					// Player telefragging enemy players
					if (rnum > 0.4) bprint (targ.netname, " was perforated by ", attacker.owner.netname, "\n");
					else bprint (targ.netname, " was telefragged by ", attacker.owner.netname, "\n");
					add_frag (attacker.owner, 1);				
//					attacker.owner.frags += 1; // Reward a frag to killer
				}	
			}			
//			add_frags (attacker.owner, 1);
			return;
		}

		if (attacker.classname == "teledeath2")
		{
			attacker.owner = other;	// Sleeper: attacker.owner doesn't know who has the pentagram.
			// Cooperative
			if (coop && !deathmatch && targ.classname == "player" && attacker.owner.classname == "player" && targ != attacker.owner) // Co-Operative
			{
				if (num_players <= 2)
				{
					if (rnum > 0.4) bprint (targ.netname, " was protected from their ally's perforation\n");
					else bprint (targ.netname, " was protected from their ally's telefrag\n");			
				}
				else
				{
					if (rnum > 0.4) bprint (targ.netname, " was protected from an ally's perforation\n");
					else bprint (targ.netname, " was protected from an ally's telefrag\n");		
				}
				if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp")
					add_frag (attacker.owner, -1);
//					attacker.owner.frags -= 1; // Deduct a frag from the team killer		
			}
			// Team Deathmatch, Capture The Flag, One Flag CTF
			else if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF && !coop) // Targ was killed by a teammate player in Team Deathmatch
			{	
				if (targ.steam == attacker.owner.steam)
				{	
					bprint ("Satan's power deflects a telefrag from ", attacker.owner.netname, "'s teammate\n");
					add_frag (targ, -1);
//					attacker.owner.frags -= 1; // Deduct a frag from the teammate
				}
				else
				{
					bprint ("Satan's power deflects ", targ.netname, "'s telefrag\n");
					add_frag (attacker.owner, 1);
//					attacker.owner.frags -= 1; // Deduct a frag from the teammate
				}					
			}		
			else if (deathmatch == DM_DUEL || deathmatch == DM_FFA)
			{
				if (!coop)
				{
					// Player telefragging enemy players
					bprint ("Satan's power deflects ", targ.netname, "'s telefrag\n");
					add_frag (attacker.owner, 1);			
//					attacker.owner.frags += 1; // Reward a frag to killer
				}	
			}		
//			add_frags (targ, -1);
			return;
		}
		// QIP Pentagram telefrag fix ZOID/Maddes
		// double 666 telefrag
		// (can happen often in deathmatch 4 and levels with more than one pentagram)
		if (attacker.classname == "teledeath3")
		{
			attacker.owner = other;	// Sleeper: attacker.owner doesn't know who has the second pentagram.
			// Cooperative
			if (coop && !deathmatch && targ.classname == "player" && attacker.owner.classname == "player" && targ != attacker.owner) // Co-Operative
			{			
				bprint ("Satan had a conflict of interest with ", attacker.owner, "'s ally\n");	
				if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp")
					add_frag (attacker.owner, -1);
//					attacker.owner.frags -= 1; // Deduct a frag from the team killer		
			}
			// Team Deathmatch, Capture The Flag, One Flag CTF
			else if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF && !coop) // Targ was killed by a teammate player in Team Deathmatch
			{	
				if (targ.steam == attacker.owner.steam)
				{		
					bprint ("Satan had a conflict of interest with ", attacker.owner, "'s ally\n");
					add_frag (attacker.owner, -1);
//					attacker.owner.frags -= 1; // Deduct a frag from the teammate
				}
				else
				{
					bprint (targ.netname, " was telefragged by ", attacker.owner.netname, "'s Satan's power\n");
					add_frag (attacker.owner, 1);
//					attacker.owner.frags -= 1; // Deduct a frag from the teammate
				}					
			}		
			else if (deathmatch == DM_DUEL || deathmatch == DM_FFA)
			{
				if (!coop)
				{
					// Player telefragging enemy players
					bprint (targ.netname, " was telefragged by ", attacker.owner.netname, "'s Satan's power\n");
					add_frag (attacker.owner, 1);			
//					attacker.owner.frags += 1; // Reward a frag to killer
				}	
			}			
			// QIP only telefrag player on spot by Maddes
//			add_frags (targ, -1);
			return;
		}
		// QIP obit fix ZOID start
		if (targ.deathtype == "squish")
		{
			if (deathmatch && teamplay && targ.steam == attacker.steam && targ != attacker || coop && attacker.classname == "player" && targ != attacker)
			{
				add_frag (attacker, -1);
				bprint (attacker.netname, " squished a teammate\n");
			}
			else if (attacker.classname == "player" && targ != attacker)
			{
				bprint (attacker.netname, " squishes ", targ.netname, "\n");
				add_frag (attacker, 1);
			}
			else
			{
				add_frag (targ, -1);            // killed self
				bprint (targ.netname, " was squished\n");
			}
			return;
		}
		// QIP end				

		// Suicide kills
		if (attacker.classname == "player")
		{
			if (targ == attacker)
			{
				if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp" && !deathmatch || deathmatch)
					add_frag (targ, -1);
//					targ.frags -= 1; // Deduct a frag to the player that kills themselves
				bprint (targ.netname);			
				// Discharging in liquids with the Thunderbolt
				if (targ.weapon == IT_LIGHTNING && targ.waterlevel > 1)
				{
					if (self.watertype == CONTENT_WATER) // Replaced
					{
						rnum = random ();
						if (rnum < 0.4) bprint (" discharges into the water\n");
						else bprint (" heats up the water\n"); // Added
					}
					else if (self.watertype == CONTENT_SLIME) bprint (" discharges into the slime\n"); // Added
					else if (self.watertype == CONTENT_LAVA) bprint (" discharges into the lava\n");   // Added
				}
				// Discharging in liquids with Mjolnir
				else if (targ.weapon == IT_MJOLNIR && targ.waterlevel > 1) // Added
				{
					if (self.watertype == CONTENT_WATER)
					{
						rnum = random ();
						if (rnum < 0.4) bprint (" is unworthy of wielding Mjolnir in water\n");
						else bprint (" quaked himself in the water\n");
					}
					else if (self.watertype == CONTENT_SLIME) bprint (" is unworthy of wielding Mjolnir in slime\n");
					else if (self.watertype == CONTENT_LAVA) bprint (" is unworthy of wielding Mjolnir in lava\n");	
				}
				// Discharging in liquids with the Plasma Gun
				else if (targ.weapon == DOE_PLASMA_GUN && targ.waterlevel > 1) // Added
				{
					rnum = random ();
					if (rnum < 0.3) bprint (" becomes bored with life\n");
					else if (rnum < 0.6) bprint (" checks if his weapon is loaded\n");
					else bprint (" discovers blast radius\n");
				}	
				// Suicide with a Grenade Launcher											
				else if (targ.weapon == IT_GRENADE_LAUNCHER || targ.weapon == IT_PROXIMITY_GUN) bprint (" tries to put the pin back in\n");
				else if (targ.weapon == IT_ROCKET_LAUNCHER && self.super_damage_finished > 0) // Added
				{
					if (rnum < 0.25) bprint (" thought his own quad rocket was a toy\n");
					else if (rnum < 0.50) bprint (" regrets nothing\n");
					else if (rnum < 0.75) bprint (" had one burrito too many\n"); // Sleeper: It's gonna be there forever, now.
					else bprint (" is on a suicidal pursuit\n");
				}				
				// Suicide with a Unquadded Rocket Launcher
				else
				{	
					rnum = random ();
					if (targ.weapon == IT_ROCKET_LAUNCHER || targ.weapon == DOE_PLASMA_GUN)
					{
						if (rnum < 0.3) bprint (" becomes bored with life\n");
						else if (rnum < 0.6) bprint (" checks if his weapon is loaded\n");
						else bprint (" discovers blast radius\n"); // Added
					}
					else bprint (" becomes bored with life\n");
				}
				return;
			}	
			// Cooperative with Friendly Fire
			else if (coop && !deathmatch && targ.classname == "player" && attacker.classname == "player" && targ != attacker)
			{
				// Team Player killed an ally
				if (num_players <= 2)
				{	
					if (rnum < 0.25) bprint (attacker.netname, " mows down their ally\n");
					else if (rnum < 0.50) bprint (attacker.netname, " checks his glasses\n");
					else if (rnum < 0.75) bprint (attacker.netname, " is a traitor!\n");
					else bprint (attacker.netname, " loses their ally\n");	
				}
				else
				{
					if (rnum < 0.25) bprint (attacker.netname, " mows down an ally\n");
					else if (rnum < 0.50) bprint (attacker.netname, " checks his glasses\n");
					else if (rnum < 0.75) bprint (attacker.netname, " is a traitor!\n");
					else bprint (attacker.netname, " loses another one of his allies\n");	
				}
				if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp")	
					add_frag (attacker, -1);
//					attacker.frags -= 1; // Deduct score from ally killer	
				return;				
			}
			// Team Deathmatch with Friendly Fire
			else if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF && targ.steam == attacker.steam && targ.team == attacker.team && !coop)
			{
				// Team Player killed a teammate
				if (rnum < 0.25) bprint (attacker.netname, " mows down a teammate\n");
				else if (rnum < 0.50) bprint (attacker.netname, " checks his glasses\n");
				else if (rnum < 0.75) bprint (attacker.netname, " gets a frag for the other team\n");
				else bprint (attacker.netname, " loses another friend\n");	
				add_frag (attacker, -1);						
//				attacker.frags -= 1; // Deduct a frag team killer
				return;
			}
			else
			{			
//				attacker.frags += 1; // Award a frag to the attacking player
				add_frag (attacker, 1);
				// Empathy Shield kills
				if (empathyused == 1)
				{
					bprint (targ.netname);
					if (random() < 0.5) bprint (" shares ");
					else bprint (" feels ");
					bprint (attacker.netname, "'s pain\n");					
					return;
				}
				// Proximity Gun kills
				if (targ.dmg_inflictor.classname == "proximity_grenade")
				{
					bprint (targ.netname);
					if (random() < 0.5) bprint (" got too friendly with ");
					else bprint (" did the rhumba with ");
					bprint (attacker.netname, "'s bomb\n");					
					return;
				}
				rnum = attacker.weapon;
			}
			// QIP obit fix start
			if (targ.deathtype == "nail")
			{
				if (attacker.super_damage_finished > time) bprint (targ.netname, " was body pierced by ", attacker.netname, "\n"); // Added
				else bprint (targ.netname, " was nailed by ", attacker.netname, "\n");
			}
			else if (targ.deathtype == "super_nail")
			{
				if (attacker.super_damage_finished > time) bprint (targ.netname, " was ventilated by ", attacker.netname, "\n"); // Added
				else bprint (targ.netname, " was punctured by ", attacker.netname, "\n");
			}
			else if (targ.deathtype == "grenade")
			{
				if (targ.health < -40) bprint (targ.netname, " was gibbed by ", attacker.netname, "'s grenade\n");
				else bprint (targ.netname, " eats ", attacker.netname, "'s pineapple\n");
			}
			else if (targ.deathtype == "rocket")
			{
				// Quadded Rocket Launcher kills
				if (attacker.super_damage_finished > time) // Added
				{
					rnum = random ();
					if (rnum < 0.3) bprint (targ.netname, " was brutalized by ", attacker.netname, "'s quad rocket\n");
					else if (rnum < 0.6) bprint (targ.netname, " was smeared by ", attacker.netname, "'s quad rocket\n");
					else bprint (attacker.netname, " rips ", targ.netname, " a new one\n");
				}
				// Unquadded Rocket Launcher kills
				else
				{
					if (targ.health < -40) bprint (targ.netname, " was gibbed by ", attacker.netname, "'s rocket\n");
					else bprint (targ.netname, " rides ", attacker.netname, "'s rocket\n");
				}
			}
			else if (targ.deathtype == "laser_spike")
			{
				if (random() < 0.5) bprint (targ.netname, " was toasted by ", attacker.netname, "'s laser\n");
				else bprint (targ.netname, " was radiated ", attacker.netname, "'s laser\n");
			}
			else if (targ.deathtype == "lava_nail" || targ.deathtype == "super_lava_nail") bprint (targ.netname, " was burned by ", attacker.netname, "\n");
			else if (targ.deathtype == "plasma_rocket") bprint (targ.netname, " was fused by ", attacker.netname, "\n");
			else if (targ.deathtype == "multi_grenade" || targ.deathtype == "multi_rocket") bprint (targ.netname, " was blasted to bits by ", attacker.netname, "\n");													
			// Axe kills
			else if (rnum == IT_AXE)
			{
				bprint (targ.netname);
				// Quadded Melee kills
				if (attacker.super_damage_finished > time) // Added
				{
					rnum = random ();
					if (rnum < 0.3) bprint (" got his block knocked off by ");
					else if (rnum < 0.6) bprint (" was sent to God, thanks to ");
					else bprint (" was split in two by ");
					bprint (attacker.netname, "\n");
				}
				// Unquadded Melee Kills
				else if (attacker.nqwCharacter == NQW_DOOMGUY) bprint (" was fisted by ", attacker.netname, "\n"); 	  // Added
				else if (attacker.nqwCharacter == NQW_SCALEBEARER) bprint (" was pummeled by ", attacker.netname, "\n");  // Added
				else if (attacker.nqwCharacter == NQW_SORLAG) bprint (" was clawed by ", attacker.netname, "\n");         // Added
				else if (attacker.nqwCharacter == NQW_DUKENUKEM) bprint (" ate ", attacker.netname, "'s size 13 boot\n"); // Added
				else if (attacker.nqwCharacter == NQW_DUSKDUDE) bprint (" was reaped by ", attacker.netname, "\n");       // Added
				else bprint (" was ax-murdered by ", attacker.netname, "\n");
			}
//ZOID--
/*			
			else if (rnum == IT_GRAPPLE)
			{
				bprint (targ.netname, " was grappled by ", attacker.netname, "\n");
				return;
			}
*/
			else if (targ.dmg_inflictor.classname == "hook") // Sleeper: Replacing the grappling hook for now.
			{
				bprint (targ.netname);
				if (rnum < 0.4) bprint (" was grappled by ");
				else bprint (" was hooked by ");
				bprint (attacker.netname, "\n");
				return;
			}
//--ZOID					
			// Shotgun kills
			else if (rnum == IT_SHOTGUN)
			{
				if (attacker.super_damage_finished > time) bprint (targ.netname, " was lead poisoned by ", attacker.netname, "\n");
				else bprint (targ.netname, " chewed on ", attacker.netname, "'s boomstick\n");
			}
			// Double-Barrelled Shotgun kills
			else if (rnum == IT_SUPER_SHOTGUN)
			{
				if (attacker.super_damage_finished > time) bprint (targ.netname, " ate 8 loads of ", attacker.netname, "'s buckshot\n"); // Added
				else bprint (targ.netname, " ate 2 loads of ", attacker.netname, "'s buckshot\n");
			}			
			// Thunderbolt kills							
			else if (rnum == IT_LIGHTNING)
			{
				if (attacker.super_damage_finished > time && attacker.waterlevel > 1) bprint (targ.netname, " gets a natural disaster from ", attacker.netname, "\n");
				else
				{
					if (attacker.waterlevel > 1) bprint (targ.netname, " accepts ", attacker.netname, "'s discharge\n");
					else bprint (targ.netname, " accepts ", attacker.netname, "'s shaft\n");
				}
			}
			// Thor's Hammer kills
			else if (rnum == IT_MJOLNIR) bprint (targ.netname, " was slammed by ", attacker.netname, "'s hammer\n");
			// Coilgun kills
			else if (rnum == NQW_IT_COILGUN)
			{
				if (random() < 0.4) bprint (targ.netname, " was railed by ", attacker.netname, "\n");
				else bprint (targ.netname, " was corkscrewed by ", attacker.netname, "\n");
			}
			return;
		}
		else
		{
			/*
//			rnum = targ.watertype;
			if (attacker.deathtype)
			{
				bprint (targ.netname, " ", attacker.deathtype, "\n");
				if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp" && !deathmatch || deathmatch)
					add_frag (targ, -1);
//					targ.frags -= 1; // Deduct a frag to the player that kills themselves
				return;
			}
			*/
			if (attacker.flags & FL_MONSTER)
			{
				bprint (targ.netname);
				// iD Software Enemies ------------------------------------------------------------------------
				if (attacker.classname == "monster_army") bprint (" was shot by a Grunt\n");
				if (attacker.classname == "monster_demon1") bprint (" was eviscerated by a Fiend\n");
				if (attacker.classname == "monster_dog") bprint (" was mauled by a Rottweiler\n");
				if (attacker.classname == "monster_enforcer") bprint (" was blasted by an Enforcer\n");
				if (attacker.classname == "monster_fish") bprint (" was fed to the Rotfish\n");
				if (attacker.classname == "monster_hell_knight") bprint (" was slain by a Death Knight\n");
				if (attacker.classname == "monster_knight") bprint (" was slashed by a Knight\n");			
				if (attacker.classname == "monster_ogre" && (!(attacker.spawnflags & OGRE_BOSS))) bprint (" was destroyed by an Ogre\n");
			     // if (attacker.classname == "monster_oldone") bprint (" became one with Shub-Niggurath\n"); // Sleeper: She doesn't have anything to attack the player with anyway... but maybe one day she will get one.
				if (attacker.classname == "monster_shalrath") bprint (" was exploded by a Vore\n");
				if (attacker.classname == "monster_shambler") bprint (" was smashed by a Shambler\n");
				if (attacker.classname == "monster_tarbaby") bprint (" was slimed by a Spawn\n");
				if (attacker.classname == "monster_wizard") bprint (" was scragged by a Scrag\n");
				if (attacker.classname == "monster_zombie") bprint (" joins the Zombies\n");
				// Hipnotic Enemies ---------------------------------------------------------------------------
				if (attacker.classname == "monster_gremlin") bprint (" was outsmarted by a Gremlin\n");
				if (attacker.classname == "trap_spike_mine") bprint (" was blasted by a Spike Mine\n");					
				if (attacker.classname == "monster_scourge") bprint (" was stung by a Centroid\n");
				if (attacker.classname == "monster_armagon") bprint (" was outgunned by Armagon\n");
				// Rogue Enemies ------------------------------------------------------------------------------
				if (attacker.classname == "monster_ogre" && attacker.spawnflags & OGRE_BOSS) bprint (" was destroyed by a Multi-Grenade Ogre\n");
				if (attacker.classname == "monster_dragon") bprint (" was annihilated by the Dragon\n");
				if (attacker.classname == "monster_dragon_dead") bprint (" was squashed by the Dragon\n"); // Part of monster_dragon
				if (attacker.classname == "monster_eel") bprint (" was electrified by an Eel\n");
				if (attacker.classname == "monster_wrath") bprint (" was disintegrated by a Wrath\n");
				if (attacker.classname == "monster_super_wrath") bprint (" was obliterated by an Overlord\n");
				if (attacker.classname == "monster_sword") bprint (" was slit open by a Phantom Swordsman\n");
				if (attacker.classname == "monster_lava_man") bprint (" fries in Hephaestus' fury\n");
				if (attacker.classname == "monster_morph") bprint (" was crushed by a Guardian\n");
				if (attacker.classname == "monster_mummy") bprint (" was Mummified\n");							
				// (Net QuakeWorld) Qtest Enemies -------------------------------------------------------------
			     // if (attacker.classname == "monster_original_dragon") bprint (" was fried by a Dragon\n"); // A Qtest Monster Coming soon.
			     // if (attacker.classname == "monster_original_dragon_dead") bprint (" was flatten by a Dragon's corpse\n"); // Part of an upcoming Qtest Monster if not gibbed.
			     // if (attacker.classname == "monster_original_shalrath") bprint (" was exploded by a Shalrath\n"); // A Qtest Monster Coming soon.
			     // if (attacker.classname == "monster_serpent")  bprint (" ???\n"); // A Qtest Monster Coming soon. // Sleeper: Not sure what to put here yet as I don't know what it's attacks are. No model with a texture and usable .qc is found.									
				if (attacker.classname == "monster_birthed_tarbaby") bprint (" was slimed by a Spawn Mother's child\n"); // Part of the blue variant of the Vomitus.				
				if (attacker.classname == "monster_vomit") bprint (" was vomited on by a Vomitus\n");
				// (Net QuakeWorld) Quake Prerelease Enemies --------------------------------------------------	
			     // if (attacker.classname == "monster_axe_ogre") bprint (" was pissed on by an ax-murdering Ogre); // A Prerelease Monster Coming soon.
				// Quake Champions Classic Bosses -------------------------------------------------------------
				if (attacker.classname == "monster_goroth") bprint (" was dominated by Vadri'gar Goroth\n");
				if (attacker.classname == "monster_volkerh") bprint ("'s blood was feasted upon by Vadri'gar Volkerh\n");
				// --------------------------------------------------------------------------------------------	
				add_frag (targ, -1);
//				targ.frags -= 1; // Deduct a frag to the player that kills themselves		
				return;
			}					
			if (attacker.classname == "explo_box")
			{
				bprint (targ.netname, " blew up\n");
				if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp" && !deathmatch || deathmatch)
					add_frag (targ, -1);
//					targ.frags -= 1; // Deduct a frag to the player that kills themselves
				return;
			}			
			/*
			if (attacker.solid == SOLID_BSP && attacker != world)
			{
				bprint (targ.netname, " was squished\n");
				if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp" && !deathmatch || deathmatch)
					add_frag (targ, -1);
//					targ.frags -= 1; // Deduct a frag to the player that kills themselves
				return;
			}
			*/
			if (targ.deathtype == "falling")
			{
				bprint (targ.netname);
				targ.deathtype = "";
				rnum = random ();
				if (rnum < 0.4) bprint (" fell to his death\n");
				else bprint (" cratered\n");
				if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp" && !deathmatch || deathmatch)
					add_frag (targ, -1);
//					targ.frags -= 1; // Deduct a frag to the player that kills themselves
				return;
			}
			if (targ.deathtype == "void")
			{
				bprint (targ.netname);
				targ.deathtype = "";
				rnum = random ();
				if (rnum < 0.4) bprint (" was in the wrong place\n");
				else bprint (" is lost to the void\n");
				if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp" && !deathmatch || deathmatch)
					add_frag (targ, -1);
//					targ.frags -= 1; // Deduct a frag to the player that kills themselves
				return;
			}
			/*			
			if (attacker.classname == "trap_shooter" || attacker.classname == "trap_spikeshooter")
			{
				bprint (targ.netname, " was spiked\n");
				if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp" && !deathmatch || deathmatch)
					add_frag (targ, -1);
//					targ.frags -= 1; // Deduct a frag to the player that kills themselves
				return;
			}
			*/
			// QIP obit fix start
			if (targ.deathtype == "nail" || targ.deathtype == "super_nail" || targ.deathtype == "super_lava_nail")
			{
				bprint (targ.netname, " was spiked\n");
				add_frag (targ, -1);
				return;
			}
			if (targ.deathtype == "laser")
			{
				bprint (targ.netname, " was zapped\n");
				add_frag (targ, -1);
				return;
			}			
			// QIP end			
			if (attacker.classname == "fireball")
			{
				bprint (targ.netname);
				bprint (" ate a lavaball\n");
				if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp" && !deathmatch || deathmatch)
					add_frag (targ, -1);
//					targ.frags -= 1; // Deduct a frag to the player that kills themselves
				return;
			}
			if (attacker.classname == "trigger_changelevel")
			{
				bprint (targ.netname);
				// Sleeper: Stop trying to leave and play the damn game! Lol
				if (deathmatch) bprint (" tried to leave the arena\n");
				else bprint (" tried to leave the level\n");
				return;
			}
			if (attacker.classname == "ltrail_start" || attacker.classname == "ltrail_relay")
			{
				bprint (targ.netname, " rode the lightning\n");
				if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp" && !deathmatch || deathmatch)
					add_frag (targ, -1);
//					targ.frags -= 1; // Deduct a frag to the player that kills themselves
				return;
			}
			if (attacker.classname == "pendulum")
			{
				bprint (targ.netname, " was cleaved in two\n");
				if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp" && !deathmatch || deathmatch)
					add_frag (targ, -1);
//					targ.frags -= 1; // Deduct a frag to the player that kills themselves
				return;
			}
			if (attacker.classname == "buzzsaw")
			{
				bprint (targ.netname, " was sliced to pieces\n");
				if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp" && !deathmatch || deathmatch)
					add_frag (targ, -1);
//					targ.frags -= 1; // Deduct a frag to the player that kills themselves
				return;
			}
			if (attacker.classname == "plasma")
			{
				bprint (targ.netname, " was turned to plasma\n");
				if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp" && !deathmatch || deathmatch)
					add_frag (targ, -1);
//					targ.frags -= 1; // Deduct a frag to the player that kills themselves
				return;
			}
			if (attacker.classname == "Vengeance")
			{
				if (coop && !deathmatch && targ.classname == "player" && attacker.owner.classname == "player" && targ != attacker.owner) // Co-Operative
				{
					bprint (targ.netname, " was purged by his ally's Vengeance Sphere\n");
					if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp")
						add_frag (attacker.owner, -1);
//						attacker.owner.frags -= 1; // Deduct a frag to the player that killed their teammate
				}
				else if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF && !coop) // Team Deathmatach, Capture The Flag, One Flag CTF
				{
					if (targ.steam == attacker.owner.steam && targ.team == attacker.owner.team)
					{ 
						bprint (targ.netname, " was purged by his teammate's Vengeance Sphere\n");
						add_frag (attacker.owner, -1);
//						attacker.owner.frags -= 1; // Deduct a frag to the player that killed their teammate
					}
					else 
					{
						bprint (targ.netname, " was purged by ", attacker.owner.netname, "'s Vengeance Sphere\n");
						add_frag (attacker.owner, 1);
//						attacker.owner.frags += 1; // Add a frag to the player that killed an enemy player
					}
					TeamAssists (targ, attacker.owner);
				}
				else if (deathmatch == DM_DUEL || deathmatch == DM_FFA) // Duel, Free For All
				{
					if (!coop)
					{
						bprint (targ.netname, " was purged by ", attacker.owner.netname, "'s Vengeance Sphere\n");
						add_frag (attacker.owner, 1);
//						attacker.owner.frags += 1; // Add a frag to the player that killed an enemy player
					}
				}		
				return;				
			}
			if (attacker.classname == "power_shield")
			{
				if (coop && !deathmatch && targ.classname == "player" && attacker.owner.classname == "player" && targ != attacker.owner) // Co-Operative
				{
					bprint (attacker.owner.netname, " smashed his ally with his power shield\n");
					if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp")
						add_frag (attacker.owner, -1);
//						attacker.owner.frags -= 1; // Deduct a frag to the player that killed their teammate
				}
				else if (deathmatch >= DM_TDM && deathmatch <= DM_OneFlagCTF && !coop) // Team Deathmatach, Capture The Flag, One Flag CTF
				{
					if (targ.steam == attacker.owner.steam && targ.team == attacker.owner.team)
					{ 
						bprint (attacker.owner.netname, " smashed his teammate with his power shield\n");
						add_frag (attacker.owner, -1);
//						attacker.owner.frags -= 1; // Deduct a frag to the player that killed their teammate
					}
					else 
					{
						bprint (targ.netname, " was smashed by ", attacker.owner.netname, "'s power shield\n");
						add_frag (attacker.owner, 1);
//						attacker.owner.frags += 1; // Add a frag to the player that killed an enemy player
					}
					TeamAssists (targ, attacker.owner);
				}
				else if (deathmatch == DM_DUEL || deathmatch == DM_FFA) // Duel, Free For All
				{
					if (!coop)
					{
						bprint (targ.netname, " was smashed by ", attacker.owner.netname, "'s power shield\n");
						add_frag (attacker.owner, 1);
//						attacker.owner.frags += 1; // Add a frag to the player that killed an enemy player
					}
				}		
				return;
			}			
			if (attacker.classname == "monster_boss") // Added
			{
				bprint (targ.netname, " was incinerated by Vadri'gar Chthon\n");
				add_frag (targ, -1);
//				targ.frags -= 1; // Deduct a frag to the player that kills themselves
				return;
			}
			rnum = targ.watertype;
			if (rnum == CONTENT_WATER && !(attacker.flags & (FL_MONSTER)))
			{
				bprint (targ.netname);
				if (random() < 0.5) bprint (" sleeps with the fishes\n");
				else bprint (" sucks it down\n");
				if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp" && !deathmatch || deathmatch)
					add_frag (targ, -1);
//					targ.frags -= 1; // Deduct a frag to the player that kills themselves
				return;
			}
			else if (rnum == CONTENT_SLIME && !(attacker.flags & (FL_MONSTER)))
			{
				bprint (targ.netname);
				if (random() < 0.5) bprint (" gulped a load of slime\n");
				else bprint (" can't exist on slime alone\n");
				if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp" && !deathmatch || deathmatch)
					add_frag (targ, -1);
//					targ.frags -= 1; // Deduct a frag to the player that kills themselves
				return;
			}
			else if (rnum == CONTENT_LAVA && !(attacker.flags & (FL_MONSTER)))
			{
				bprint (targ.netname);
				if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp" && !deathmatch || deathmatch)
					add_frag (targ, -1);
//					targ.frags -= 1; // Deduct a frag to the player that kills themselves				
				if (targ.health < -15)
				{
					bprint (" burst into flames\n");					
					return;
				}
				if (random() < 0.5) bprint (" turned into hot slag\n");
				else bprint (" visits the Volcano God\n");
				return;
			}
			else
			{
				bprint (targ.netname, " died\n"); // Hell if I know; he's just dead!!!
				if (world.model != "maps/start.bsp" && world.model != "maps/hipstart.bsp" && world.model != "maps/rstart.bsp" && world.model != "maps/e5start.bsp" && world.model != "maps/mgstart.bsp" && world.model != "maps/hub.bsp" && !deathmatch || deathmatch)
					add_frag (targ, -1);
//					targ.frags -= 1; // Deduct a frag to the player that kills themselves
			}
		}
	}
};