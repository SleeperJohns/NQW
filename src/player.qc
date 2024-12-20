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


void() bubble_bob;

/*
==============================================================================

PLAYER

==============================================================================
*/

$cd id1/models/player_4
$origin 0 -6 24
$base base
$skin skin

//
// running
//
$frame axrun1 axrun2 axrun3 axrun4 axrun5 axrun6

$frame rockrun1 rockrun2 rockrun3 rockrun4 rockrun5 rockrun6

//
// standing
//
$frame stand1 stand2 stand3 stand4 stand5

$frame axstnd1 axstnd2 axstnd3 axstnd4 axstnd5 axstnd6
$frame axstnd7 axstnd8 axstnd9 axstnd10 axstnd11 axstnd12


//
// pain
//
$frame axpain1 axpain2 axpain3 axpain4 axpain5 axpain6

$frame pain1 pain2 pain3 pain4 pain5 pain6


//
// death
//

$frame axdeth1 axdeth2 axdeth3 axdeth4 axdeth5 axdeth6
$frame axdeth7 axdeth8 CORPSEFRAME_PLAYER_1

$frame deatha1 deatha2 deatha3 deatha4 deatha5 deatha6 deatha7 deatha8
$frame deatha9 deatha10 CORPSEFRAME_PLAYER_2

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame CORPSEFRAME_PLAYER_3

$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10 deathc11 deathc12 deathc13 deathc14 CORPSEFRAME_PLAYER_4

$frame deathd1 deathd2 deathd3 deathd4 deathd5 deathd6 deathd7
$frame deathd8 CORPSEFRAME_PLAYER_5

$frame deathe1 deathe2 deathe3 deathe4 deathe5 deathe6 deathe7
$frame deathe8 CORPSEFRAME_PLAYER_6

//
// attacks
//
$frame nailatt1 nailatt2

$frame light1 light2

$frame rockatt1 rockatt2 rockatt3 rockatt4 rockatt5 rockatt6

$frame shotatt1 shotatt2 shotatt3 shotatt4 shotatt5 shotatt6

$frame axatt1 axatt2 axatt3 axatt4 axatt5 axatt6

$frame axattb1 axattb2 axattb3 axattb4 axattb5 axattb6

$frame axattc1 axattc2 axattc3 axattc4 axattc5 axattc6

$frame axattd1 axattd2 axattd3 axattd4 axattd5 axattd6


/*
==============================================================================
PLAYER
==============================================================================
*/

void() player_run;

void() player_stand1 = [$axstnd1, player_stand1]
{
	self.weaponframe = 0;
	if (self.velocity_x || self.velocity_y)
	{
		self.walkframe = 0;
		player_run ();
		return;
	}

	if (self.weapon == IT_AXE)
	{
		if (self.walkframe >= 12) self.walkframe = 0;
		self.frame = $axstnd1 + self.walkframe;
	}
	else if (self.weapon == IT_MJOLNIR)
	{
		if (self.walkframe >= 12) self.walkframe = 0;
		self.frame = 6 + self.walkframe;
	}
	else
	{
		if (self.walkframe >= 5) self.walkframe = 0;
		self.frame = $stand1 + self.walkframe;
	}
	self.walkframe += 1;
};

void() player_run = [$rockrun1, player_run]
{
	self.weaponframe = 0;
	if (!self.velocity_x && !self.velocity_y)
	{
		self.walkframe = 0;
		player_stand1 ();
		return;
	}

	if (self.weapon == IT_AXE)
	{
		if (self.walkframe == 6) self.walkframe = 0;
		self.frame = $axrun1 + self.walkframe;
	}
	else if (self.weapon == IT_MJOLNIR)
	{
		if (self.walkframe == 6) self.walkframe = 0;
		self.frame = self.walkframe;
	}
	else
	{
		if (self.walkframe == 6) self.walkframe = 0;
		self.frame += self.walkframe;
	}
	if (footsteps == 1)
	{
		self.spawnsilent += vlen(self.origin - self.old_velocity);
		self.old_velocity = self.origin;
		if (self.flags & FL_ONGROUND)
		{
			if (self.spawnsilent > 95)
			{
				if (self.spawnsilent > 190) self.spawnsilent = 0;
				else self.spawnsilent = 0.5 * (self.spawnsilent - 95);
				
				local float r = random();
				if (r < 0.14) self.noise = "misc/foot1.wav";
				else if (r < 0.29) self.noise = "misc/foot2.wav";
				else if (r < 0.43) self.noise = "misc/foot3.wav";
				else if (r < 0.58) self.noise = "misc/foot4.wav";
				else if (r < 0.72) self.noise = "misc/foot5.wav";
				else if (r < 0.86) self.noise = "misc/foot6.wav";
				else self.noise = "misc/foot7.wav";
				sound (self, CHAN_BODY, self.noise, 0.5, ATTN_NORM);
			}
		}
	}
	self.walkframe += 1;
};


void() player_shot1 = [$shotatt1, player_shot2] 
{
	self.weaponframe = 1;
	self.effects |= EF_MUZZLEFLASH;
};
void()	player_shot2 =	[$shotatt2, player_shot3	] {self.weaponframe=2;};
void()	player_shot3 =	[$shotatt3, player_shot4	] {self.weaponframe=3;};
void()	player_shot4 =	[$shotatt4, player_shot5	] {self.weaponframe=4;};
void()	player_shot5 =	[$shotatt5, player_shot6	] {self.weaponframe=5;};
void()	player_shot6 =	[$shotatt6, player_run	] {self.weaponframe=6;};

void()	player_axe1 =	[$axatt1, player_axe2	] {self.weaponframe=1;};
void()	player_axe2 =	[$axatt2, player_axe3	] {self.weaponframe=2;};
void()	player_axe3 =	[$axatt3, player_axe4	] {self.weaponframe=3;W_FireAxe();};
void()	player_axe4 =	[$axatt4, player_run	] {self.weaponframe=4;};

void()	player_axeb1 =	[$axattb1, player_axeb2	] {self.weaponframe=5;};
void()	player_axeb2 =	[$axattb2, player_axeb3	] {self.weaponframe=6;};
void()	player_axeb3 =	[$axattb3, player_axeb4	] {self.weaponframe=7;W_FireAxe();};
void()	player_axeb4 =	[$axattb4, player_run	] {self.weaponframe=8;};

void()	player_axec1 =	[$axattc1, player_axec2	] {self.weaponframe=1;};
void()	player_axec2 =	[$axattc2, player_axec3	] {self.weaponframe=2;};
void()	player_axec3 =	[$axattc3, player_axec4	] {self.weaponframe=3;W_FireAxe();};
void()	player_axec4 =	[$axattc4, player_run	] {self.weaponframe=4;};

void()	player_axed1 =	[$axattd1, player_axed2	] {self.weaponframe=5;};
void()	player_axed2 =	[$axattd2, player_axed3	] {self.weaponframe=6;};
void()	player_axed3 =	[$axattd3, player_axed4	] {self.weaponframe=7;W_FireAxe();};
void()	player_axed4 =	[$axattd4, player_run	] {self.weaponframe=8;};


//============================================================================
//ZOID--
void() player_grapple3;
void() player_grapple4;
void() player_grapple5;

void()  player_grapple1 =  [$axattd1, player_grapple2 ] 
//	{ self.weaponframe=1; W_FireGrapple(); };
	{ self.weaponframe=2;};
void()  player_grapple2 =  [$axattd2, player_grapple3 ]
//	{ self.weaponframe=2;};
	{ self.weaponframe=3; W_FireGrapple ();};
void()  player_grapple3 =  [$axattd3, player_grapple3 ]
	{
		self.weaponframe = 3;
//		self.weaponframe = 2;

		if (!self.hook_out) 
		{
			player_grapple5();
			return;
		}
		/*
		if (vlen(self.hook.origin - self.origin) >= 50) 
		{
			if (self.on_hook) 
			{
				player_grapple4();
				return;
			}
		}
		*/
		if (vlen(self.velocity) >= 750)
		{
			if (time > self.ltime) //delay the flying animation,ie no belly flop on grapple hops
			{
				player_grapple4();
				return;
			}
		}		

	};
void() player_grapple4 =  [$deathc4, player_grapple4 ]
	{
		self.weaponframe=4;
//		self.weaponframe=2;

		if (!self.hook_out) 
		{
			player_grapple5();
			return;
		}
		/*
		if (vlen(self.hook.origin - self.origin) < 50 || !self.on_hook) 
		{
			player_grapple3();
			return;
		}
		*/
		if (vlen(self.velocity) < 750)
		{
			player_grapple3();
			return;
		}
		
	};
void()  player_grapple5 =  [$axattd4, player_run    ] 
	{self.weaponframe=5;};
//	{self.weaponframe=1;};
//--ZOID
//============================================================================

void() player_nail1   =[$nailatt1, player_nail2  ]
{
	self.effects |= EF_MUZZLEFLASH;

	if (!self.button0) {player_run ();return;}
	self.weaponframe += 1;
	if (self.weaponframe == 9) self.weaponframe = 1;
	SuperDamageSound ();
	W_FireSpikes (4);
//	self.attack_finished = time + 0.2;
	self.attack_finished = time + RuneApplyHell(0.2, self);
};
void() player_nail2   =[$nailatt2, player_nail1  ]
{
	self.effects |= EF_MUZZLEFLASH;

	if (!self.button0) {player_run ();return;}
	self.weaponframe += 1;
	if (self.weaponframe == 9) self.weaponframe = 1;
	SuperDamageSound ();
	W_FireSpikes (-4);
//	self.attack_finished = time + 0.2;
	self.attack_finished = time + RuneApplyHell(0.2, self);
};

//============================================================================

void(float ox) W_FireLavaSpikes;

void() player_lava_nail1   =[$nailatt1, player_lava_nail2  ] 
{
	self.effects |= EF_MUZZLEFLASH;

	if (!self.button0) {player_run ();return;}
	self.weaponframe += 1;
	if (self.weaponframe == 9) self.weaponframe = 1;
	SuperDamageSound ();
	W_FireLavaSpikes (4);
//	self.attack_finished = time + 0.2;
	self.attack_finished = time + RuneApplyHell(0.2, self);
};
void() player_lava_nail2   =[$nailatt2, player_lava_nail1  ]
{
	self.effects |= EF_MUZZLEFLASH;

	if (!self.button0) {player_run ();return;}
	self.weaponframe += 1;
	if (self.weaponframe == 9) self.weaponframe = 1;
	SuperDamageSound ();
	W_FireLavaSpikes (-4);
//	self.attack_finished = time + 0.2;
	self.attack_finished = time + RuneApplyHell(0.2, self);
};

//============================================================================
void() W_FirePlasma;

void() player_light1   =[$light1, player_light2  ]
{
	self.effects |= EF_MUZZLEFLASH;

	if (!self.button0) {player_run ();return;}
	self.weaponframe += 1;
	if (self.weaponframe == 5) self.weaponframe = 1;
	SuperDamageSound ();
	if (self.weapon == IT_LIGHTNING)
	{		
		W_FireLightning();
//		self.attack_finished = time + 0.2;
		self.attack_finished = time + RuneApplyHell(0.2, self);
	}
	else if (self.weapon == DOE_PLASMA_GUN)
	{
		W_FirePlasma (); 
		player_rocket1 ();
//		player_run ();
		return;
	}
};
void() player_light2   =[$light2, player_light1  ]
{
	self.effects |= EF_MUZZLEFLASH;

	if (!self.button0) {player_run ();return;}
	self.weaponframe += 1;
	if (self.weaponframe == 5) self.weaponframe = 1;
	SuperDamageSound ();
	W_FireLightning ();
//	self.attack_finished = time + 0.2;
	self.attack_finished = time + RuneApplyHell(0.2, self);
};

//MED 10/18/96 added HIPWEAPONS
//============================================================================

void()   player_hammer1 =  [32, player_hammer2   ] {self.weaponframe=1;};
void()   player_hammer2 =  [33, player_hammer3   ] {self.weaponframe=2;};
void()   player_hammer3 =  [34, player_hammer4   ] {self.weaponframe=3;};
void()   player_hammer4 =  [35, player_hammer5   ] {self.weaponframe=4;HIP_FireMjolnir();};
void()   player_hammer5 =  [36, player_hammer6   ] {self.weaponframe=4;};
void()   player_hammer6 =  [37, player_run ] {self.weaponframe=4;};

void()   player_mjolnir1 =  [38, player_mjolnir2   ] {self.weaponframe=1;};
void()   player_mjolnir2 =  [39, player_mjolnir3   ] {self.weaponframe=2;};
void()   player_mjolnir3 =  [40, player_mjolnir4   ] {self.weaponframe=3;};
void()   player_mjolnir4 =  [41, player_mjolnir5   ] {self.weaponframe=4;HIP_FireMjolnir();};
void()   player_mjolnir5 =  [42, player_mjolnir6   ] {self.weaponframe=4;};
void()   player_mjolnir6 =  [43, player_run ] {self.weaponframe=4;};

//============================================================================

//MED 10/18/96 added HIPSWEAPONS
//void() player_laser1   =[$nailatt1, player_laser2  ] {self.attack_finished = time + 0.1;self.weaponframe=1;self.nextthink = time + 0.09;HIP_FireLaser(0);};
//void() player_laser2   =[$nailatt2, player_laser4  ] {self.attack_finished = time + 0.1;self.weaponframe=2;self.nextthink = time + 0.09;};
//void() player_laser3   =[$nailatt1, player_laser4  ] {self.attack_finished = time + 0.1;self.weaponframe=3;self.nextthink = time + 0.09;};
//void() player_laser4   =[$nailatt2, player_laser5  ] {self.attack_finished = time + 0.1;self.weaponframe=4;self.nextthink = time + 0.09;HIP_FireLaser(1);};
//void() player_laser5   =[$nailatt1, player_laser1  ] {self.attack_finished = time + 0.1;self.weaponframe=5;self.nextthink = time + 0.09;};
//void() player_laser6   =[$nailatt2, player_laser1  ] {self.attack_finished = time + 0.1;self.weaponframe=6;self.nextthink = time + 0.09;};
void() player_laser1   =[$nailatt1, player_laser3  ] {self.attack_finished = time + 0.1;self.weaponframe=1;self.nextthink = time + 0.1;HIP_FireLaser(0);};
void() player_laser2   =[$nailatt2, player_laser3  ] {self.attack_finished = time + 0.1;self.weaponframe=2;self.nextthink = time + 0.1;};
void() player_laser3   =[$nailatt2, player_laser1  ] {self.attack_finished = time + 0.1;self.weaponframe=4;self.nextthink = time + 0.1;HIP_FireLaser(1);};
void() player_laser4   =[$nailatt1, player_laser1  ] {self.attack_finished = time + 0.1;self.weaponframe=5;self.nextthink = time + 0.1;};
//============================================================================


void() player_rocket1   =[$rockatt1, player_rocket2  ] {self.weaponframe=1;
self.effects = self.effects | EF_MUZZLEFLASH;};
void() player_rocket2   =[$rockatt2, player_rocket3  ] {self.weaponframe=2;};
void() player_rocket3   =[$rockatt3, player_rocket4  ] {self.weaponframe=3;};
void() player_rocket4   =[$rockatt4, player_rocket5  ] {self.weaponframe=4;};
void() player_rocket5   =[$rockatt5, player_rocket6  ] {self.weaponframe=5;};
void() player_rocket6   =[$rockatt6, player_run  ] {self.weaponframe=6;};
void(float num_bubbles) DeathBubbles;

void() PainSound =
{
	local float rs;

	if (self.health < 0) return;

	if (damage_attacker.classname == "teledeath")
	{
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}

// water pain sounds
	if (self.watertype == CONTENT_WATER && self.waterlevel == 3)
	{
		DeathBubbles(1);
		if (random() > 0.5) sound (self, CHAN_VOICE, self.nqwSndDrown1, 1, ATTN_NORM);
		else sound (self, CHAN_VOICE, self.nqwSndDrown2, 1, ATTN_NORM);
		return;
	}

// slime pain sounds
	if (self.watertype == CONTENT_SLIME)
	{
	// FIXME: put in some steam here
		if (random() > 0.5) sound (self, CHAN_VOICE, self.nqwSndBurn1, 1, ATTN_NORM);
		else sound (self, CHAN_VOICE, self.nqwSndBurn2, 1, ATTN_NORM);
		return;
	}

	if (self.watertype == CONTENT_LAVA)
	{
		if (random() > 0.5) sound (self, CHAN_VOICE, self.nqwSndBurn1, 1, ATTN_NORM);
		else sound (self, CHAN_VOICE, self.nqwSndBurn2, 1, ATTN_NORM);
		return;
	}

	if (self.pain_finished > time)
	{
		self.axhitme = 0;
		return;
	}
	self.pain_finished = time + 0.5;

// don't make multiple pain sounds right after each other

// ax pain sound
	if (self.axhitme == 1)
	{
		self.axhitme = 0;
		sound (self, CHAN_VOICE, self.nqwSndAxHit1, 1, ATTN_NORM);
		return;
	}


	self.noise = "";
	rs = rint((random() * 5) + 1);
		
	if (skill <= 4)
	{
		if (rs == 1) self.noise = self.nqwSndQ1Pain1;
		else if (rs == 2) self.noise = self.nqwSndQ1Pain2;
		else if (rs == 3) self.noise = self.nqwSndQ1Pain3;
		else if (rs == 4) self.noise = self.nqwSndQ1Pain4;
		else if (rs == 5) self.noise = self.nqwSndQ1Pain5;
		else self.noise = self.nqwSndQ1Pain6;
	}
	else
	{		
		if (self.health > 80)
		{
			if (random() > 0.5) self.noise = self.nqwSndQ2Pain1;
			else self.noise = self.nqwSndQ2Pain2;
		}
		else if (self.health > 50)
		{
			if (random() > 0.5) self.noise = self.nqwSndQ2Pain3;
			else self.noise = self.nqwSndQ2Pain4;
		}
		else if (self.health > 25)
		{
			if (random() > 0.5) self.noise = self.nqwSndQ2Pain5;
			else self.noise = self.nqwSndQ2Pain6;
		}
		else if (self.health > 0)
		{
			if (random() > 0.5) self.noise = self.nqwSndQ2Pain7;
			else self.noise = self.nqwSndQ2Pain8;
		}
	}

	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	return;
};

void()	player_pain1 =	[	$pain1,	player_pain2	] {PainSound();self.weaponframe=0;};
void()	player_pain2 =	[	$pain2,	player_pain3	] {};
void()	player_pain3 =	[	$pain3,	player_pain4	] {};
void()	player_pain4 =	[	$pain4,	player_pain5	] {};
void()	player_pain5 =	[	$pain5,	player_pain6	] {};
void()	player_pain6 =	[	$pain6,	player_run	] {};

void()	player_axpain1 =	[	$axpain1,	player_axpain2	] {PainSound();self.weaponframe=0;};
void()	player_axpain2 =	[	$axpain2,	player_axpain3	] {};
void()	player_axpain3 =	[	$axpain3,	player_axpain4	] {};
void()	player_axpain4 =	[	$axpain4,	player_axpain5	] {};
void()	player_axpain5 =	[	$axpain5,	player_axpain6	] {};
void()	player_axpain6 =	[	$axpain6,	player_run	] {};

void()   player_hampain1 =  [  18,   player_hampain2 ] {PainSound();self.weaponframe=0;};
void()   player_hampain2 =  [  19,   player_hampain3 ] {};
void()   player_hampain3 =  [  20,   player_hampain4 ] {};
void()   player_hampain4 =  [  21,   player_hampain5 ] {};
void()   player_hampain5 =  [  22,   player_hampain6 ] {};
void()   player_hampain6 =  [  23,   player_run  ] {};

void() player_pain =
{
	if (self.weaponframe) return;

	if (self.invisible_finished > time) return; // eyes don't have pain frames

	if (self.weapon == IT_AXE) player_axpain1 ();
	else if (self.weapon == IT_MJOLNIR) player_hampain1 ();
	else player_pain1 ();
};

void() player_diea1;
void() player_dieb1;
void() player_diec1;
void() player_died1;
void() player_diee1;
void() player_die_ax1;
void() player_die_ham1;

void() DeathBubblesSpawn =
{
	if (self.owner.waterlevel != 3) return;
	
	local entity bubble = spawn ();
	
	setmodel (bubble, "progs/s_bubble.spr");
	setorigin (bubble, self.owner.origin + '0 0 24');
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.classname = "bubble";
	bubble.frame = 0;
	bubble.cnt = 0;
	setsize (bubble, '-8 -8 -8', '8 8 8');
	self.nextthink = time + 0.1;
	self.think = DeathBubblesSpawn;
	self.air_finished = self.air_finished + 1;
	if (self.air_finished >= self.bubble_count) remove (self);
};

void(float num_bubbles) DeathBubbles =
{
	local entity bubble_spawner = spawn ();
	
	setorigin (bubble_spawner, self.origin);
	bubble_spawner.movetype = MOVETYPE_NONE;
	bubble_spawner.solid = SOLID_NOT;
	bubble_spawner.nextthink = time + 0.1;
	bubble_spawner.think = DeathBubblesSpawn;
	bubble_spawner.air_finished = 0;
	bubble_spawner.owner = self;
	bubble_spawner.bubble_count = num_bubbles;
	return;
};


void() DeathSound =
{
	// water death sounds
	if (self.waterlevel == 3)
	{
		DeathBubbles(20);
		sound (self, CHAN_VOICE, self.nqwSndH2oDeath, 1, ATTN_NONE);
		return;
	}

	local float rs = rint ((random() * 4) + 1);
	if (rs == 1) self.noise = self.nqwSndDeath1;
	if (rs == 2) self.noise = self.nqwSndDeath2;
	if (rs == 3) self.noise = self.nqwSndDeath3;
	if (rs == 4) self.noise = self.nqwSndDeath4;
	if (rs == 5) self.noise = self.nqwSndDeath5;

	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NONE);
	return;
};


void() PlayerDead =
{
	self.nextthink = -1;
// allow respawn after a certain time
	self.deadflag = DEAD_DEAD; 
};

vector(float dm) VelocityForDamage =
{
	local vector v;

	//MED 01/17/97
	if (vlen(damage_inflictor.velocity) > 0)
	{
		v = 0.2 * damage_inflictor.velocity;
		v += 25 * normalize(self.origin-damage_inflictor.origin);
		v_z = 100 + 100 * random();
		v_x += 50 * crandom();
		v_y += 50 * crandom();
	}
	else
	{
		v_x = 100 * crandom();
		v_y = 100 * crandom();
		v_z = 200 + 100 * random();
	}
	if (dm > -50)
	{
//  	  	dprint ("level 1\n");
		v *= 0.7;
	}
	else if (dm > -200)
	{
//   		dprint ("level 3\n");
		v *= 2;
	}
	else v *= 10;
	
	return v;
};

void(string gibname, float dm) ThrowGib =
{
	local entity new = spawn ();
	
	new.origin = self.origin;
	setmodel (new, gibname);
	setsize (new, '0 0 0', '0 0 0');
	new.velocity = VelocityForDamage (dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.avelocity_x = random() * 600;
	new.avelocity_y = random() * 600;
	new.avelocity_z = random() * 600;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + 10 + random() * 10;
	new.frame = 0;
	new.flags = 0;
};

//MED
void() HeadThink =
{
	// Sleeper Make fly sounds only if the Game World is Hipnotic and isn't Deathmatch (Fly sounds in Deathmatch could be annoying)
	if (deathmatch) return;
	
	self.nextthink = -1;
	if (world.worldtype != 2)
	{
		if (gameworld == HIPNOTIC)
		{     
			if (random() < 0.1)
			sound (self, 6, "misc/flys.wav", 0.7, ATTN_STATIC);
		}	 
	}
};

void() MonsterFade;

void(string gibname, float dm) ThrowHead =
{
	setmodel (self, gibname);
	self.frame = 0;
// 	self.nextthink = -1;
	// HIPNOTIC: MED
	self.nextthink = time + 1.5;
	self.movetype = MOVETYPE_BOUNCE;
	self.takedamage = DAMAGE_NO;
//	self.solid = SOLID_NOT;
	self.solid = SOLID_TRIGGER;
	self.view_ofs = '0 0 8';
	setsize (self, '-16 -16 0', '16 16 56');
	self.velocity = VelocityForDamage (dm);
	self.origin_z -= 24;
	self.flags -= self.flags & (FL_ONGROUND);
	self.avelocity = crandom() * '0 600 0';
	if (self.nqwGibSkins) self.skin = self.skin % self.nqwGibSkins;	
	// MED
	self.gorging = TRUE;
	self.think = HeadThink;
	
	// MG1: Yoder Sept24 2021, Horde Merge
	if (horde_ent)
	{
		// only monsters gibs should fade away 
		if (self.classname != "player")
		{
			self.think = MonsterFade;
			self.nextthink = time + 1;
		}
	}	
};

void() GibPlayer =
{
	ThrowHead (self.nqwCharGib, self.health);
	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);

	self.deadflag = DEAD_DEAD;

	if (damage_attacker.classname == "teledeath")
	{
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}

	if (damage_attacker.classname == "teledeath2")
	{
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}

	if (random() < 0.5) sound (self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NONE);
	else sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);
};

void() hip_powerup_touch;
void() newitems_touch;
void(float powerup) Powerup_Drop = 
{
	local entity new = spawn ();
		
	if (powerup == IT_INVULNERABILITY && self.invincible_finished > time) 
	{
		new.netname = "Pentagram of Protection";
		setmodel (new, "progs/invulner.mdl");
		new.noise = "items/protect.wav";
		new.items = IT_INVULNERABILITY;
		new.classname = "item_artifact_invulnerability";
		new.delay = self.invincible_finished - time;
		new.touch = powerup_touch;
		new.effects |= EF_RED;
	}
	else if (powerup == IT_QUAD && self.super_damage_finished > time) 
	{
		new.netname = "Quad Damage";
		setmodel (new, "progs/quaddama.mdl");
		new.noise = "items/damage.wav";
		new.items = IT_QUAD;
		new.classname = "item_artifact_super_damage";
		new.delay = self.super_damage_finished - time;
		new.touch = powerup_touch;
		new.effects |= EF_BLUE;
	}
	else if (powerup == IT_INVISIBILITY && self.invisible_finished > time) 
	{
		new.netname = "Ring of Shadows";
		setmodel (new, "progs/invisibl.mdl");
		new.noise = "items/inv1.wav";
		new.items = IT_INVISIBILITY;
		new.classname = "item_artifact_invisibility";
		new.delay = self.invisible_finished - time;
		new.touch = powerup_touch;
	}
	else if (powerup == IT_SUIT && self.radsuit_finished > time) 
	{
		new.netname = "Biosuit";
		setmodel (new, "progs/suit.mdl");
		new.noise = "items/suit.wav";
		new.items = IT_SUIT;
		new.classname = "item_artifact_invisibility";
		new.delay = self.radsuit_finished - time;
		new.touch = powerup_touch;
	}
	else if (powerup == HIP_IT_WETSUIT && self.wetsuit_finished > time) 
	{
		new.netname = "Wetsuit";
		setmodel (new, "progs/wetsuit.mdl");
		new.noise = "misc/weton.wav";
		new.expansionitems = HIP_IT_WETSUIT;
		new.classname = "item_artifact_wetsuit";
		new.delay = self.wetsuit_finished - time;
		new.touch = hip_powerup_touch;
	}
	else if (powerup == HIP_IT_EMPATHY_SHIELDS && self.empathy_finished > time) 
	{
		new.netname = "Empathy Shields";
		setmodel (new, "progs/empathy.mdl");
		new.noise = "hipitems/empathy.wav";
		new.expansionitems = HIP_IT_EMPATHY_SHIELDS;
		new.classname = "item_artifact_empathy_shields";
		new.delay = self.empathy_finished - time;
		new.touch = hip_powerup_touch;
	}		
	else if (powerup == DOE_SHIELD && self.shield_finished > time) 
	{
		new.netname = "Power Shield";
		setmodel (new, "progs/shield.mdl");
		new.noise = "shield/pickup.wav";
		new.expansionitems = DOE_SHIELD;
		new.classname = "item_powerup_shield";
		new.delay = self.shield_finished - time;
		new.touch = newitems_touch;
	}
	else if (powerup == DOE_ANTIGRAV && self.antigrav_finished > time) 
	{
		new.netname = "Anti-Grav Belt";
		setmodel (new, "progs/beltup.mdl");
		new.noise = "belt/pickup.wav";
		new.expansionitems = DOE_ANTIGRAV;
		new.classname = "item_powerup_belt";
		new.delay = self.antigrav_finished - time;
		new.touch = newitems_touch;
	}			
    
	new.droppable_item = TRUE;
	setsize (new, '-16 -16 -24', '16 16 32');
	setorigin (new, self.origin + '0 0 16');
	new.solid = SOLID_TRIGGER;
	new.flags = FL_ITEM;
	new.movetype = MOVETYPE_BOUNCE;
	new.think = SUB_Remove;
	new.nextthink = time + 30;
};

void() PlayerDie =
{
	// NQW --------------------------------------------
	// Drop powerups
	if ((coop == REIGNITED_COOP) || (coop == ENHANCED_COOP) || (deathmatch >= DM_FFA && deathmatch <= DM_OneFlagCTF))
	{
//		if (self.items & IT_INVULNERABILITY) Powerup_Drop (IT_INVULNERABILITY); // Sleeper: Yeeeeeah, I don't think so... Battle Suit has a better chance of being droppable.
		if (self.items & IT_QUAD) Powerup_Drop (IT_QUAD);
		if (self.items & IT_INVISIBILITY) Powerup_Drop (IT_INVISIBILITY);
//		if (self.items & IT_SUIT) Powerup_Drop (IT_SUIT); // Sleeper: Never needed since this a minor item, you can still keep grabbing the same one over and over again.
//		if (self.items & HIP_IT_WETSUIT) Powerup_Drop (HIP_IT_WETSUIT); // Sleeper: Never needed since this a minor item, you can still keep grabbing the same one over and over again.
		if (self.expansionitems & HIP_IT_EMPATHY_SHIELDS) Powerup_Drop (HIP_IT_EMPATHY_SHIELDS);
		if (self.expansionitems & DOE_SHIELD) Powerup_Drop (DOE_SHIELD);
		if (self.expansionitems & DOE_ANTIGRAV) Powerup_Drop (DOE_ANTIGRAV);
	}
	// ------------------------------------------------	  	
//	self.items -= self.items & (IT_INVISIBILITY);
	self.items -= self.items & (IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD);
	self.invisible_finished       = 0; // Don't die as eyes
	self.invincible_finished      = 0;
	self.super_damage_finished    = 0;
	self.radsuit_finished         = 0;
        self.effects                  = 0; // 1998-07-23 Glowing corpse of players which had quad/pentagram until respawn fix by Maddes
        self.modelindex 	      = modelindex_nqwplayer;   // Don't use eyes
        self.invincible_time          = 0;
        self.super_time               = 0;
        self.invisible_time           = 0;
        self.rad_time                 = 0;
	
	// HIPNOTIC: JIM
	self.wetsuit_finished = 0;
	self.gravity = 1.0;
	self.empathy_finished = 0;
	self.expansionitems -= self.expansionitems & (HIP_IT_EMPATHY_SHIELDS);	
	
	self.shield_finished = 0;
	self.antigrav_finished = 0;	

	// Sleeper: Removed Backpack from dropping in co-op and deathmatch, since we've pretty much eliminated any possibility of obtaining extra ammo with the exception of a 
	// disconnecting player. In case a new player joins, they can obtain all available weapons and ammo up to the current map from an pre-existing player. And since we're
	// saving inventory and weapons instead, players don't have to go around the map again for the ammo and all the weapons if they die. However, if they're the only player
	// in the server joining, they will need to go around the map to obtain the weapons and ammo.
	local float start_maps = (world.model == "maps/start.bsp" || world.model == "maps/hipstart.bsp" || world.model == "maps/rstart.bsp" || world.model == "maps/e5start.bsp" || world.model == "maps/mgstart.bsp" || world.model == "maps/hub.bsp" || world.worldtype == WORLDTYPE_HUB);
	if (deathmatch && !coop)
	{
//		DropBackpack (); // Sleeper: Not needed for players anymore.
		TossWeapon ();
		TeamDropFlagOfPlayer (self);
//		DropRune ();	
	}
	if (coop == CLASSIC_COOP && !deathmatch && world.model != Start_Maplist[StartMaps()]) DropBackpack (); // Sleeper: Because vanilla experience, remember? Also, not needed in start maps.
	if (self.rune) RuneRespawn (); // Sleeper: Support runes will now respawn at a dedicated spot when the player occupying that rune dies.
	
	if (self.ctf_killed == 2) self.ctf_killed = 0;
	else self.ctf_killed = 1;

	self.weaponmodel = "";
	self.view_ofs = '0 0 -8';
	self.deadflag = DEAD_DYING;
	self.solid = SOLID_NOT;
	self.flags -= self.flags & (FL_ONGROUND);
	self.movetype = MOVETYPE_TOSS;
	self.deathrespawn = time + 1.5;
	if (self.velocity_z < 10) self.velocity_z += random() * 300;

	if (self.health < -40)
	{
		GibPlayer ();
		return;
	}

	DeathSound ();

	self.angles_x = 0;
	self.angles_z = 0;

	if (self.weapon == IT_AXE)
	{
		player_die_ax1 ();
		return;
	}
        // HIPNOTIC: MED 12/04/96
        else if (self.weapon == IT_MJOLNIR)
        {
//		self.modelindex = modelindex_hammer; // use hammer model
//		player_die_ham1 ();
		player_die_ax1 ();
		return;
        }

	local float i = cvar("temp1");
	if (!i) i = 1 + floor(random() * 6);

	if (i == 1) player_diea1 ();
	else if (i == 2) player_dieb1 ();
	else if (i == 3) player_diec1 ();
	else if (i == 4) player_died1 ();
	else player_diee1 ();

};

void() set_suicide_frame =
{	
	// Used by kill command and diconnect command
	if (self.model != self.nqwCharGib) return; // allready gibbed
	
	self.frame = $CORPSEFRAME_PLAYER_2;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS;
	self.deadflag = DEAD_DEAD;
	self.nextthink = -1;
	self.modelindex = modelindex_nqwplayer;
};

void()	player_die_ax1	=	[	$axdeth1,	player_die_ax2	] {};
void()	player_die_ax2	=	[	$axdeth2,	player_die_ax3	] {};
void()	player_die_ax3	=	[	$axdeth3,	player_die_ax4	] {};
void()	player_die_ax4	=	[	$axdeth4,	player_die_ax5	] {};
void()	player_die_ax5	=	[	$axdeth5,	player_die_ax6	] {};
void()	player_die_ax6	=	[	$axdeth6,	player_die_ax7	] {};
void()	player_die_ax7	=	[	$axdeth7,	player_die_ax8	] {};
void()	player_die_ax8	=	[	$axdeth8,	player_die_ax9	] {};
void()	player_die_ax9	=	[	$CORPSEFRAME_PLAYER_1,	player_die_ax9	] {PlayerDead();};

void()	player_diea1	=	[	$deatha1,	player_diea2	] {};
void()	player_diea2	=	[	$deatha2,	player_diea3	] {};
void()	player_diea3	=	[	$deatha3,	player_diea4	] {};
void()	player_diea4	=	[	$deatha4,	player_diea5	] {};
void()	player_diea5	=	[	$deatha5,	player_diea6	] {};
void()	player_diea6	=	[	$deatha6,	player_diea7	] {};
void()	player_diea7	=	[	$deatha7,	player_diea8	] {};
void()	player_diea8	=	[	$deatha8,	player_diea9	] {};
void()	player_diea9	=	[	$deatha9,	player_diea10	] {};
void()	player_diea10	=	[	$deatha10,	player_diea11	] {};
void()	player_diea11	=	[	$CORPSEFRAME_PLAYER_2,	player_diea11 ] {PlayerDead();};

void()	player_dieb1	=	[	$deathb1,	player_dieb2	] {};
void()	player_dieb2	=	[	$deathb2,	player_dieb3	] {};
void()	player_dieb3	=	[	$deathb3,	player_dieb4	] {};
void()	player_dieb4	=	[	$deathb4,	player_dieb5	] {};
void()	player_dieb5	=	[	$deathb5,	player_dieb6	] {};
void()	player_dieb6	=	[	$deathb6,	player_dieb7	] {};
void()	player_dieb7	=	[	$deathb7,	player_dieb8	] {};
void()	player_dieb8	=	[	$deathb8,	player_dieb9	] {};
void()	player_dieb9	=	[	$CORPSEFRAME_PLAYER_3,	player_dieb9	] {PlayerDead();};

void()	player_diec1	=	[	$deathc1,	player_diec2	] {};
void()	player_diec2	=	[	$deathc2,	player_diec3	] {};
void()	player_diec3	=	[	$deathc3,	player_diec4	] {};
void()	player_diec4	=	[	$deathc4,	player_diec5	] {};
void()	player_diec5	=	[	$deathc5,	player_diec6	] {};
void()	player_diec6	=	[	$deathc6,	player_diec7	] {};
void()	player_diec7	=	[	$deathc7,	player_diec8	] {};
void()	player_diec8	=	[	$deathc8,	player_diec9	] {};
void()	player_diec9	=	[	$deathc9,	player_diec10	] {};
void()	player_diec10	=	[	$deathc10,	player_diec11	] {};
void()	player_diec11	=	[	$deathc11,	player_diec12	] {};
void()	player_diec12	=	[	$deathc12,	player_diec13	] {};
void()	player_diec13	=	[	$deathc13,	player_diec14	] {};
void()	player_diec14	=	[	$deathc14,	player_diec15	] {};
void()	player_diec15	=	[	$CORPSEFRAME_PLAYER_4,	player_diec15 ] {PlayerDead();};

void()	player_died1	=	[	$deathd1,	player_died2	] {};
void()	player_died2	=	[	$deathd2,	player_died3	] {};
void()	player_died3	=	[	$deathd3,	player_died4	] {};
void()	player_died4	=	[	$deathd4,	player_died5	] {};
void()	player_died5	=	[	$deathd5,	player_died6	] {};
void()	player_died6	=	[	$deathd6,	player_died7	] {};
void()	player_died7	=	[	$deathd7,	player_died8	] {};
void()	player_died8	=	[	$deathd8,	player_died9	] {};
void()	player_died9	=	[	$CORPSEFRAME_PLAYER_5,	player_died9	] {PlayerDead();};

void()	player_diee1	=	[	$deathe1,	player_diee2	] {};
void()	player_diee2	=	[	$deathe2,	player_diee3	] {};
void()	player_diee3	=	[	$deathe3,	player_diee4	] {};
void()	player_diee4	=	[	$deathe4,	player_diee5	] {};
void()	player_diee5	=	[	$deathe5,	player_diee6	] {};
void()	player_diee6	=	[	$deathe6,	player_diee7	] {};
void()	player_diee7	=	[	$deathe7,	player_diee8	] {};
void()	player_diee8	=	[	$deathe8,	player_diee9	] {};
void()	player_diee9	=	[	$CORPSEFRAME_PLAYER_6,	player_diee9	] {PlayerDead();};

void()   player_die_ham1 =  [ 24 ,   player_die_ham2 ] {};
void()   player_die_ham2 =  [ 25 ,   player_die_ham3 ] {};
void()   player_die_ham3 =  [ 26 ,   player_die_ham4 ] {};
void()   player_die_ham4 =  [ 27 ,   player_die_ham5 ] {};
void()   player_die_ham5 =  [ 28 ,   player_die_ham6 ] {};
void()   player_die_ham6 =  [ 29 ,   player_die_ham7 ] {};
void()   player_die_ham7 =  [ 30 ,   player_die_ham8 ] {};
void()   player_die_ham8 =  [ 31 ,   player_die_ham8 ] {PlayerDead();};

void(entity shieldOwner, vector dir) shield_spawn;

void() player_touch = 
{
	local vector vec;
	local float dot, doDamage;
			
	if (self.expansionitems & DOE_SHIELD)
	{
		if (other.classname == "player")
		{		
			makevectors (self.angles);
			vec = normalize (other.origin - self.origin);
			dot = vec * v_forward;
			if (dot < 0.3) return;
				
			makevectors (self.angles);
			if (deathmatch && other.steam != self.steam && self.team != other.team)
			{
				other.velocity = v_forward * 100;
				other.velocity_z = 30;
			}
			else if (coop && teamplay == 2)
			{
				other.velocity = v_forward * 100;
				other.velocity_z = 30;
			}
	
			doDamage = 1;		
			if (TeamArmorDam(other, self, self, 15))
			{
				if (deathmatch && other.steam != self.steam && self.team != other.team)
				{
					if (self.shield_death_time < time) doDamage = 1;
				}				
			}
			else if (TeamArmorDam(other, self, self, 0))
			{
				if (coop)
				{
					if (self.shield_death_time < time) doDamage = 1;
				}				
			}

			// if shield has timed out, respawn it.
			// don't do particles more than twice a second. 
			if (self.shield_death_time < time)
			{
				sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_NORM);
	
				WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
				WriteByte (MSG_BROADCAST, TE_EXPLOSION2);
				WriteCoord (MSG_BROADCAST, other.origin_x);
				WriteCoord (MSG_BROADCAST, other.origin_y);
				WriteCoord (MSG_BROADCAST, other.origin_z);
				WriteByte (MSG_BROADCAST, 230);
				WriteByte (MSG_BROADCAST, 5);

				shield_spawn (self, v_forward);
			}
			if (doDamage) 
			{
				
				if (coop) 
				{
					if (teamplay == COOP_FF_OFF || teamplay == COOP_FF_ALT) T_Damage (other, self.shield_entity, self.shield_entity, 0);
					if (teamplay == COOP_FF_ON) T_Damage (other, self.shield_entity, self.shield_entity, 15);
				}
				else if (deathmatch && other.steam != self.steam && self.team != other.team) T_Damage (other, self.shield_entity, self.shield_entity, 15); 
			}
//			self.shield_death_time = time + 0.5;
		}
	}	
};