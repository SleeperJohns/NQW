//Decompiled code. Please respect the original copyright.

void() finale_4 =
{
	local vector oldo;
	local float x;
	local float y;
	local float z;
	local float r;
	local entity n;
	local entity pl;

	sound(self, CHAN_VOICE, "boss2/pop2.wav", AS_STRAIGHT, ATTN_NORM);
	oldo = self.origin;
	z = SECRET_YES_SHOOT;
	while ((z <= 144))
	{
		x = -64;
		while ((x <= IT_LIGHTNING))
		{
			y = -64;
			while ((y <= IT_LIGHTNING))
			{
				self.origin_x = (oldo_x + x);
				self.origin_y = (oldo_y + y);
				self.origin_z = (oldo_z + z);
				r = random();
				if ((r < 0.3))
				{
					ThrowGib("progs/gib1.mdl", -999);
				}
				else
				{
					if ((r < 0.6))
					{
						ThrowGib("progs/gib2.mdl", -999);
					}
					else
					{
						ThrowGib("progs/gib3.mdl", -999);
					}
				}
				y = (y + DOOR_TOGGLE);
			}
			x = (x + DOOR_TOGGLE);
		}
		z = (z + 96);
	}
	
	/*
	if (coop && (cvar("skill") <= 4) && num_players == 2)
	{
		killed_monsters = (killed_monsters + AS_STRAIGHT);
		WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
		WriteByte(MSG_ALL, SVC_FINALE);
		WriteString(MSG_ALL, "Congratulations and well done! You and\n your ally have beaten the hideous\n Shub-Niggurath, and her hundreds of\n ugly changelings and monsters. You and\n your ally have proven that both of\n yours and their skills and cunning are\n greater than all the powers of\n Quake.\n\n You are masters now.\n\n Id Software\n &\n The Quake Community salute you.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue\n\n Scourge of Armagon!");
	}
	else if (coop && (cvar("skill") <= 4) && num_players >= 3)
	{
		killed_monsters = (killed_monsters + AS_STRAIGHT);
		WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
		WriteByte(MSG_ALL, SVC_FINALE);
		WriteString(MSG_ALL, "Congratulations and well done! You and\n your allies have beaten the hideous\n Shub-Niggurath, and her hundreds of\n ugly changelings and monsters. You and\n your allies have proven that both of\n yours and their skills and cunning are\n greater than all the powers of\n Quake.\n\n You are masters now.\n\n Id Software\n &\n The Quake Community salute you.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue to\n\n Scourge of Armagon!");
	}	
	else if (coop && (cvar("skill") == 5) && num_players == 2)
	{
		killed_monsters = (killed_monsters + AS_STRAIGHT);
		WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
		WriteByte(MSG_ALL, SVC_FINALE);
		WriteString(MSG_ALL, "Congratulations and well done! You and\n your ally have beaten the hideous\n Shub-Niggurath, and her hundreds of\n ugly changelings and monsters. You and\n your ally have proven that both of\n yours and their skills and cunning are\n greater than all the powers of\n Quake.\n\n You are Grandmasters now.\n\n Id Software\n &\n The Quake Community salute you.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue\n\n Scourge of Armagon!");
	}
	else if (coop && (cvar("skill") == 5) && num_players >= 3)
	{
		killed_monsters = (killed_monsters + AS_STRAIGHT);
		WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
		WriteByte(MSG_ALL, SVC_FINALE);
		WriteString(MSG_ALL, "Congratulations and well done! You and\n your allies have beaten the hideous\n Shub-Niggurath, and her hundreds of\n ugly changelings and monsters. You and\n your allies have proven that both of\n yours and their skills and cunning are\n greater than all the powers of\n Quake.\n\n You are Grandmasters now.\n\n Id Software\n &\n The Quake Community salute you.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue\n\n Scourge of Armagon!");
	}	
	else if (coop && (cvar("skill") <= 4) && num_players <= 1)
	{
		killed_monsters = (killed_monsters + AS_STRAIGHT);
		WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
		WriteByte(MSG_ALL, SVC_FINALE);
		WriteString(MSG_ALL, "Congratulations and well done! You have\nbeaten the hideous Shub-Niggurath, and\nher hundreds of ugly changelings and\nmonsters. You have proven that your\nskill and your cunning are greater than\nall the powers of Quake. You are the\nmaster now. Id Software salute you.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue\n\n Scourge of Armagon!\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue\n\n Scourge of Armagon!");
	}
	else if (coop && (cvar("skill") == 5) && num_players <= 1)
	{
		killed_monsters = (killed_monsters + AS_STRAIGHT);
		WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
		WriteByte(MSG_ALL, SVC_FINALE);
		WriteString(MSG_ALL, "Congratulations and well done! You have\nbeaten the hideous Shub-Niggurath, and\nher hundreds of ugly changelings and\nmonsters. You have proven that your\nskill and your cunning are greater than\nall the powers of Quake.\n\n You are the Grandmaster now.\n\n Id Software\n &\n The Quake Community salutes you\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue\n\n Scourge of Armagon!");
	}
	else if (cvar("skill") == 5)
	{
		killed_monsters = (killed_monsters + AS_STRAIGHT);
		WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
		WriteByte(MSG_ALL, SVC_FINALE);
		WriteString(MSG_ALL, "Congratulations and well done! You have\nbeaten the hideous Shub-Niggurath, and\nher hundreds of ugly changelings and\nmonsters. You have proven that your\nskill and your cunning are greater than\nall the powers of Quake. You are the\nGrandmaster now. Id Software salutes you.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue\n\n Scourge of Armagon!");
	}		
	else
	{
		killed_monsters = (killed_monsters + AS_STRAIGHT);
		WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
		WriteByte(MSG_ALL, SVC_FINALE);
		WriteString(MSG_ALL, "Congratulations and well done! You have\nbeaten the hideous Shub-Niggurath, and\nher hundreds of ugly changelings and\nmonsters. You have proven that your\nskill and your cunning are greater than\nall the powers of Quake. You are the\nmaster now. Id Software salutes you.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n JUMP or ATTACK to continue\n\n Scourge of Armagon!");
	}
	*/
	
	ExitIntermission ();

	// put a player model down
	pl = find (world, classname, "player");
	vector shub_origin = oldo;
	vector dummy_origin;
	vector dummy_angle;
//	float z_offset;
	float x_offset;
	float y_offset;
	while (pl) {
	    n = spawn();    
	    setmodel(n, "progs/player.mdl");
	    
	    // NQW Model & Skin Indexes ==================================================
	    n.modelindex = pl.modelindex_nqwplayer;
	    n.skin = pl.skin;
	    // ===========================================================================    
	    
	    if (pl.nqwSpeakShubKill != string_null) sound (pl, CHAN_VOICE, pl.nqwSpeakShubKill, 1, ATTN_NORM);	
            // Sleeper: Offset the real origin based by the amount of players in the server	
            
            serverflags = 0; // Sleeper: Reset serverflags immediately after killing Shub Nigguarth.	
            	
	    if (num_players == 1)
	    {	
		dummy_origin = (shub_origin - '32 264 0');
	    }
	    else if (num_players == 2)
	    {
		dummy_origin = (shub_origin - '44 264 0');
	    }
	    else if (num_players == 3)
	    {
		dummy_origin = (shub_origin - '64 264 0');
	    }
	    else if (num_players == 4)
	    {
		dummy_origin = (shub_origin - '80 264 0');
	    }
	    else if (num_players == 5)
	    {
		dummy_origin = (shub_origin - '100 264 0');
	    }
	    else if (num_players == 6)
	    {
		dummy_origin = (shub_origin - '68 264 0');
	    }
	    else if (num_players == 7)
	    {
		dummy_origin = (shub_origin - '32 264 0');
	    }	    	    	    	    
	    else if (num_players >= 8)
	    {
		dummy_origin = (shub_origin - '0 264 0');
	    }
	    
	    // Sleeper: Offset the dummy's origins based by the amount of players in the server
	    dummy_origin_x += x_offset;
	    // dummy_origin_y += y_offset;
	    // dummy_origin_z += z_offset;
	    if (num_players <= 5)
	    {
		    if (x_offset <= 105)
		    {
			x_offset += 35;
		    }
		    else
		    {
			x_offset -= 245;
		    }  
            }  
 	    else if (num_players == 6)
	    {
		    if (x_offset <= 105)
		    {
			x_offset += 35;
		    }
		    else
		    {
			x_offset -= 175;
		    }  
            } 
 	    else if (num_players == 7)
	    {
		    if (x_offset <= 105)
		    {
			x_offset += 35;
		    }
		    else
		    {
			x_offset -= 205;
	            }
	    }
 	    else if (num_players >= 8)
	    {
		    if (x_offset <= 105)
		    {
			x_offset += 35;
		    }
		    else
		    {
			x_offset -= 245;
	            }
	    } 	                	           	
	   // dummy_origin_z += z_offset;
	   // z_offset += 56; // Sleeper: I see you wish you get stacked. Lol
	    setorigin(n, dummy_origin);
	    if (num_players == 1)
	    {
		dummy_angle = '0 290 0';
	    }
	    else if (num_players == 2)
	    {
		dummy_angle = '0 290 0';
	    }
	    else if (num_players == 3)
	    {
		dummy_angle = '0 310 0';
	    }	
	    else if (num_players == 4)
	    {
		dummy_angle = '0 320 0';
	    }
	    else if (num_players == 5)
	    {
		dummy_angle = '0 290 0';
	    }
	    else if (num_players == 6)
	    {
		dummy_angle = '0 290 0';
	    }
	    else if (num_players == 7)
	    {
		dummy_angle = '0 290 0';
	    }
	    else if (num_players == 8)
	    {
		dummy_angle = '0 290 0';
	    }	    	    	    	    	    
	    n.angles = (dummy_angle);
	    n.angles_y += y_offset;
	    if (num_players == 2)
	    {
		y_offset -= 37;
	    }
	    else if (num_players == 3)
	    {
		y_offset -= 37;
	    }	    
	    else if (num_players == 4)
	    {
		y_offset -= 33;	
	    }	    		    	    		    	    
	    // ===========================================================================
	    // Sleeper: If we're walking through the final teleport holding the Axe, the dummy holds the Axe. If we're holding the gun, the dummy holds the gun.
	    if (pl.weapon == IT_AXE)
	    {
		n.frame = 17;
	    }
	    else
	    {
		n.frame = 12;
	    }
	    n.nextthink = time + 0.1;
	    n.think = standin_idle; // Sleeper: Animate the dummy when Shub Niggurath dies.
	    // ===========================================================================
	    pl = find(pl, classname, "player") ;
	} // Sleeper: Thanks bmFbr for adding most of the bits of code in this loop that I wasn't able to understand -- I appreciate it. 
	
	remove(self);
	/*
	nextmap = "hipstart";
	WriteByte(MSG_ALL, SVC_CDTRACK);
	WriteByte(MSG_ALL, 2); // Sleeper: Play Quake Theme instead of Aftermath when beating Shub Niggurath.
	WriteByte(MSG_ALL, 3);
	*/
	lightstyle(realnull, "m");
};

// Sleeper: Animate the dummy after a player walks through the final teleport and telefrags Shub Niggurath
void() standin_idle =
{
	// Axe idle animation
	if (self.walkframe == 4 && self.frame == 16)
	{
		self.walkframe = 0;
		self.frame = 12;
	}
	
	// Weapon idle animation
	if (self.walkframe == 9 && self.frame == 26)
	{
		self.walkframe = 0;
		self.frame = 17;
	}
	
	// Increment the frame and walkframe	
	self.walkframe = self.walkframe + 1;
	self.frame = self.frame + 1;
	self.nextthink = time + 0.1;
};


void() old_idle1 = [ 0, old_idle2 ]
{
};

void() old_idle2 = [ 1, old_idle3 ]
{
};

void() old_idle3 = [ 2, old_idle4 ]
{
};

void() old_idle4 = [ 3, old_idle5 ]
{
};

void() old_idle5 = [ 4, old_idle6 ]
{
};

void() old_idle6 = [ 5, old_idle7 ]
{
};

void() old_idle7 = [ 6, old_idle8 ]
{
};

void() old_idle8 = [ 7, old_idle9 ]
{
};

void() old_idle9 = [ 8, old_idle10 ]
{
};

void() old_idle10 = [ 9, old_idle11 ]
{
};

void() old_idle11 = [ 10, old_idle12 ]
{
};

void() old_idle12 = [ 11, old_idle13 ]
{
};

void() old_idle13 = [ 12, old_idle14 ]
{
};

void() old_idle14 = [ 13, old_idle15 ]
{
};

void() old_idle15 = [ 14, old_idle16 ]
{
};

void() old_idle16 = [ 15, old_idle17 ]
{
};

void() old_idle17 = [ 16, old_idle18 ]
{
};

void() old_idle18 = [ 17, old_idle19 ]
{
};

void() old_idle19 = [ 18, old_idle20 ]
{
};

void() old_idle20 = [ 19, old_idle21 ]
{
};

void() old_idle21 = [ 20, old_idle22 ]
{
};

void() old_idle22 = [ 21, old_idle23 ]
{
};

void() old_idle23 = [ 22, old_idle24 ]
{
};

void() old_idle24 = [ 23, old_idle25 ]
{
};

void() old_idle25 = [ 24, old_idle26 ]
{
};

void() old_idle26 = [ 25, old_idle27 ]
{
};

void() old_idle27 = [ 26, old_idle28 ]
{
};

void() old_idle28 = [ 27, old_idle29 ]
{
};

void() old_idle29 = [ 28, old_idle30 ]
{
};

void() old_idle30 = [ 29, old_idle31 ]
{
};

void() old_idle31 = [ 30, old_idle32 ]
{
};

void() old_idle32 = [ 31, old_idle33 ]
{
};

void() old_idle33 = [ 32, old_idle34 ]
{
};

void() old_idle34 = [ 33, old_idle35 ]
{
};

void() old_idle35 = [ 34, old_idle36 ]
{
};

void() old_idle36 = [ 35, old_idle37 ]
{
};

void() old_idle37 = [ 36, old_idle38 ]
{
};

void() old_idle38 = [ 37, old_idle39 ]
{
};

void() old_idle39 = [ 38, old_idle40 ]
{
};

void() old_idle40 = [ 39, old_idle41 ]
{
};

void() old_idle41 = [ 40, old_idle42 ]
{
};

void() old_idle42 = [ 41, old_idle43 ]
{
};

void() old_idle43 = [ 42, old_idle44 ]
{
};

void() old_idle44 = [ 43, old_idle45 ]
{
};

void() old_idle45 = [ 44, old_idle46 ]
{
};

void() old_idle46 = [ 45, old_idle1 ]
{
};

/*
void() old_search = [1, old_search] 
{
    local entity pl;

    pl = find (world, classname, "player");
    while (pl != world)
    {
        traceline(self.origin, pl.origin, 1, self);
        if (trace_fraction == 1)
        {
            if (pl.qccChampion == QCC_DUKENUKEM)
            {
                sound(pl, CHAN_VOICE, "duke/quake.wav", 1, ATTN_NORM);
                pl.qccTauntTimer = time + 6;
                self.think = old_idle1;
                self.nextthink = 0.1;
                return;
            }
            if (self.qccTauntTimer < time)
            {
                sound(self, CHAN_VOICE, "boss2/sight.wav", 1, ATTN_NONE);
                self.qccTauntTimer = time + 60;
            }
        }
        pl = find (pl, classname, "player");
    }
    self.walkframe = self.walkframe + 1;
    if (self.walkframe > 45)
        self.walkframe = 0;
    self.frame = self.walkframe;
};
*/

void() old_search = [0, old_search] 
{
	local entity pl = find (world, classname, "player");
	while (pl != world)
	{
		traceline (self.origin, pl.origin, 1, self);
		if (trace_fraction == 1)
		{  
			if (pl.nqwSpeakShubGreet != string_null) 
			{
				sound (pl, CHAN_VOICE, pl.nqwSpeakShubGreet, 1, ATTN_NORM);
				pl.nqwTauntTimer = time + 10;
			}					  		
			if (self.nqwTauntTimer < time)
			{
				sound (self, CHAN_VOICE, "boss2/sight.wav", 1, ATTN_NONE);
				self.think = old_idle1; 				
				self.nqwTauntTimer = time + 60;							
			}  						       
		}
		pl = find (pl, classname, "player");
	}
	self.walkframe += 1;
	if (self.walkframe > 45) self.walkframe = 0;
	self.frame = self.walkframe;
};

void() old_thrash1 = [ 46, old_thrash2 ]
{
	lightstyle(realnull, "m");
};

void() old_thrash2 = [ 47, old_thrash3 ]
{
	lightstyle(realnull, "k");
};

void() old_thrash3 = [ 48, old_thrash4 ]
{
	lightstyle(realnull, "k");
};

void() old_thrash4 = [ 49, old_thrash5 ]
{
	lightstyle(realnull, "i");
};

void() old_thrash5 = [ 50, old_thrash6 ]
{
	lightstyle(realnull, "g");
};

void() old_thrash6 = [ 51, old_thrash7 ]
{
	lightstyle(realnull, "e");
};

void() old_thrash7 = [ 52, old_thrash8 ]
{
	lightstyle(realnull, "c");
};

void() old_thrash8 = [ 53, old_thrash9 ]
{
	lightstyle(realnull, "a");
};

void() old_thrash9 = [ 54, old_thrash10 ]
{
	lightstyle(realnull, "c");
};

void() old_thrash10 = [ 55, old_thrash11 ]
{
	lightstyle(realnull, "e");
};

void() old_thrash11 = [ 56, old_thrash12 ]
{
	lightstyle(realnull, "g");
};

void() old_thrash12 = [ 57, old_thrash13 ]
{
	lightstyle(realnull, "i");
};

void() old_thrash13 = [ 59, old_thrash14 ]
{
	lightstyle(realnull, "k");
};

void() old_thrash14 = [ 60, old_thrash15 ]
{
	lightstyle(realnull, "m");
};

void() old_thrash15 = [ 61, old_thrash16 ]
{
	lightstyle(realnull, "m");
	self.cnt = (self.cnt + AS_STRAIGHT);
	if ((self.cnt != AS_MELEE))
	{
		self.think = old_thrash1;
	}
};

void() old_thrash16 = [ 62, old_thrash17 ]
{
	lightstyle(realnull, "g");
};

void() old_thrash17 = [ 63, old_thrash18 ]
{
	lightstyle(realnull, "c");
};

void() old_thrash18 = [ 64, old_thrash19 ]
{
	lightstyle(realnull, "b");
};

void() old_thrash19 = [ 65, old_thrash20 ]
{
	lightstyle(realnull, "a");
};

void() old_thrash20 = [ 66, old_thrash20 ]
{
	finale_4();
};

void() finale_3 =
{
	self.owner.think = old_thrash1;
	sound(self.owner, CHAN_VOICE, "boss2/death.wav", AS_STRAIGHT, ATTN_NORM);
	lightstyle(realnull, "abcdefghijklmlkjihgfedcb");
	remove(self);
};

void() finale_2 =
{
	local vector o;
	
	o = (self.owner.origin - '0 100 0');
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_TELEPORT);
	WriteCoord(MSG_BROADCAST, o_x);
	WriteCoord(MSG_BROADCAST, o_y);
	WriteCoord(MSG_BROADCAST, o_z);
	sound(self.owner, CHAN_VOICE, "misc/r_tele1.wav", AS_STRAIGHT, ATTN_NORM);
	self.nextthink = (time + AS_SLIDING);
	self.think = finale_3;
};

void() finale_1 =
{
	local entity pos;
	local entity pl;
	local entity timer;

//	intermission_exittime = time + 1;
//	intermission_running = 1;
	
	pos = find (world, classname, "info_intermission");
	if (!pos) error ("no info_intermission");
	
	pl = find (world, classname, "misc_teleporttrain");
	if (!pl) error ("no teleporttrain");
	
	remove (pl);
	
//	WriteByte (MSG_ALL, SVC_FINALE);
//	WriteString (MSG_ALL, "");
	
	ExitIntermission ();
	
	pl = find(world, classname, "player");
	while (pl != world)
	{
		pl.view_ofs = VEC_ORIGIN;
		other.v_angle = pos.mangle;
		pl.angles = pos.mangle;
		pl.fixangle = TRUE;
		pl.map = self.map;
		pl.nextthink = (time + 0.5);
		pl.takedamage = DAMAGE_NO;
		pl.solid = SOLID_NOT;
		pl.movetype = MOVETYPE_NONE;
		pl.modelindex = realnull;
		setorigin(pl, pos.origin);
		pl = find (pl, classname, "player");
		
		timer = spawn();
		timer.nextthink = time + 0.1;
		timer.think = finale_2;
		timer.owner = self;
	}
};

void() nopain =
{
	self.max_health = 40000;
};

void() monster_oldone =
{
	if (deathmatch)
	{
		remove (self);
		return;
	}

	precache_model2 ("progs/oldone.mdl");

	precache_sound2 ("boss2/death.wav");
	precache_sound2 ("boss2/idle.wav");
	precache_sound2 ("boss2/sight.wav");
	precache_sound2 ("boss2/pop2.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
	setmodel (self, "progs/oldone.mdl");
	/*
	if (ExtSupported("EX_SPRINT")) 
	{
		self.netname = "$qc_shub";
		self.killstring = "$qc_ks_shub";
	}
	else 
	{
		self.netname = "Shub-Niggurath";
		self.killstring = " became one with Shub-Niggurath\n";
	}
	*/
	
	setsize (self, '-160 -128 -24', '160 128 256');

	self.health = 40000;		// kill by telefrag
	self.max_health = 40000;	// kill by telefrag
     // self.think = old_idle1;
	self.think = old_search; // NQW: used for Character response upon sight
     //	self.flags |= FL_MONSTER; // NQW: needed for monster interactions
	self.nextthink = time + 0.1;	
	self.takedamage = DAMAGE_YES;
	self.th_pain = SUB_NullPain;
	self.th_die = finale_1;
     // shub = self;
	
	total_monsters = total_monsters + 1;
	self.netname = "Shub-Niggurath";
};

/*
void() monster_oldone =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2("progs/oldone.mdl");
	precache_sound2("boss2/death.wav");
	precache_sound2("boss2/idle.wav");
	precache_sound2("boss2/sight.wav");
	precache_sound2("boss2/pop2.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/oldone.mdl");
	setsize(self, '-160 -128 -24', '160 128 256');
	self.health = 40000;
	self.max_health = 40000;
     // self.think = old_idle1;
	self.think = old_search;
	self.nextthink = time + 0.1;
	self.takedamage = DAMAGE_YES;
	self.th_pain = nopain;
	self.th_die = finale_1;
	total_monsters = total_monsters + 1;
	self.netname = "Shub Niggurath";
};
*/
