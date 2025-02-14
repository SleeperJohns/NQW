//Decompiled code. Please respect the original copyright.
void() bubble_bob;
float(entity targ, entity inflictor) CanDamage;
void(entity targ, entity attacker) ClientObituary;
void() DecodeLevelParms;
float() DemonCheckAttack;
void() Demon_JumpTouch;
float() DogCheckAttack;
void() Dog_JumpTouch;
void() fd_secret_done;
void() hknight_char_a1;
void() knight_atk1;
void() knight_runatk1;
void(vector org, vector vec) LaunchLaser;
void() monster_death_use;
void() PlayerDie;
void() player_axeb1;
void() player_axec1;
void() player_axed1;
void() player_axe1;
void() player_light1;
void() player_nail1;
void() player_pain;
void() player_rocket1;
void() player_run;
void() player_shot1;
void() player_stand1;
void() set_suicide_frame;
void() sham_swingr1;
void(vector org, entity death_owner) spawn_tdeath;
void(vector org) spawn_tfog;
void() SUB_UseTargets;
void() train_next;
void(entity targ, entity inflictor, entity attacker, float damage) T_Damage;
float (entity targ) visible;
float (entity targ, float ignore_water) visible_sk5;
float() WizardCheckAttack;
float() W_BestWeapon;
void() W_SetCurrentAmmo;
float saved1;



// void() StatUseTargets;
void() SUB_Null = {};

// MG1 ==========================================================
const float MESSAGE_ALL_PLAYERS = 2097152;
float(...) SUB_True = {return TRUE;};
void(entity attacker, float damage) SUB_NullPain = {};
// ===============================================================

void() SUB_Remove = {remove(self);};

/*
=============
SUB_ChangeModel

size changes after a model change, use this to preserve it
===============
*/
void(entity ent, string mdl) SUB_ChangeModel =
{
	local vector sz, smin, smax;
	sz = ent.size;
	smin = ent.mins;
	smax = ent.maxs;
	
	setmodel (ent, mdl);
	
	if (sz == VEC_ORIGIN) setsize (ent, VEC_ORIGIN, VEC_ORIGIN);
	else setsize (ent, smin, smax);
};

void(entity ent, void() initialize_call) SUB_CallAsSelf =
{
	local entity oldself = self;
	
	self = ent;
	initialize_call ();
	self = oldself;
};

/*
QuakeEd only writes a single float for angles (bad idea), so up and down are
just constant angles.
*/
void() SetMovedir =
{			  		  
	// MG1 ---------------------
	if (self.movedir)
	{
		self.angles = '0 0 0';
		return;
	}
	// -------------------------

	if (self.angles == '0 -1 0') self.movedir = '0 0 1';
	else if (self.angles == '0 -2 0') self.movedir = '0 0 -1';
	else
	{
		makevectors (self.angles);
		self.movedir = v_forward;
	}
	
	self.angles = '0 0 0';
};

/*
================
RemovedOutsideCoop
Removes self if COOP_ONLY spawnflag is set and we're not in coop.
Returns TRUE if it was removed.
================
*/
float() RemovedOutsideCoop =
{
	if (!coop && (self.spawnflags & COOP_ONLY))
	{
		remove(self);
		return TRUE;
	}
	
	return FALSE;
};

/*
================
InitTrigger
================
*/
void() InitTrigger =
{
// Trigger angles are used for one-way touches.  An angle of 0 is assumed
// to mean no restrictions, so use a yaw of 360 instead.
	if (RemovedOutsideCoop()) return; // MG1
	
	if (self.angles != '0 0 0') SetMovedir ();
	
	self.solid = SOLID_TRIGGER;
	setmodel (self, self.model);	// set size and link into world
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
};

/*
=============
SUB_CalcMove

Calculate self.velocity and self.nextthink to reach dest from
self.origin traveling at speed
===============
*/
void(entity ent, vector tdest, float tspeed, void() func) SUB_CalcMoveEnt =
{
	local entity stemp;
	
	stemp = self;
	self = ent;

	SUB_CalcMove (tdest, tspeed, func);
	self = stemp;
};

void(vector tdest, float tspeed, void() func) SUB_CalcMove =
{
	local vector vdestdelta;
	local float len, traveltime;

	if (!tspeed) objerror("No speed is defined!");

	self.think1 = func;
	self.finaldest = tdest;
	self.think = SUB_CalcMoveDone;

	if (tdest == self.origin)
	{
		self.velocity = '0 0 0';
		self.nextthink = self.ltime + 0.1;
		return;
	}
		
// Set destdelta to the vector needed to move
	vdestdelta = tdest - self.origin;
	
// Calculate length of vector
	len = vlen(vdestdelta);
	
// Divide by speed to get time to reach dest
	traveltime = len / tspeed;

	if (traveltime < 0.1)
	{
		self.velocity = '0 0 0';
		self.nextthink = self.ltime + 0.1;
		return;
	}
	
// Set nextthink to trigger a think when dest is reached
	self.nextthink = self.ltime + traveltime;

// Scale the destdelta vector by the time spent traveling to get velocity
	self.velocity = vdestdelta * (1 / traveltime);	// qcc won't take vec/float	
};

/*
============
After moving, set origin to exact final destination
============
*/
void()  SUB_CalcMoveDone =
{
	setorigin (self, self.finaldest);
	self.velocity = '0 0 0';
	self.nextthink = -1;
	
	if (self.think1) self.think1();
};


/*
=============
SUB_CalcAngleMove

Calculate self.avelocity and self.nextthink to reach destangle from
self.angles rotating 

The calling function should make sure self.think is valid
===============
*/
void(entity ent, vector destangle, float tspeed, void() func) SUB_CalcAngleMoveEnt =
{
	local entity stemp = self;
	
	self = ent;
	SUB_CalcAngleMove (destangle, tspeed, func);
	self = stemp;
};

void(vector destangle, float tspeed, void() func) SUB_CalcAngleMove =
{
	local vector destdelta;
	local float len, traveltime;

	if (!tspeed) objerror("No speed is defined!");
		
	// Set destdelta to the vector needed to move
	destdelta = destangle - self.angles;
	
	// Calculate length of vector
	len = vlen (destdelta);
	
	// Divide by speed to get time to reach dest
	traveltime = len / tspeed;

	// Set nextthink to trigger a think when dest is reached
	self.nextthink = self.ltime + traveltime;

	// Scale the destdelta vector by the time spent traveling to get velocity
	self.avelocity = destdelta * (1 / traveltime);
	
	self.think1 = func;
	self.finalangle = destangle;
	self.think = SUB_CalcAngleMoveDone;
};

/*
============
After rotating, set angle to exact final angle
============
*/
void() SUB_CalcAngleMoveDone =
{
	self.angles = self.finalangle;
	self.avelocity = '0 0 0';
	self.nextthink = -1;
	
	if (self.think1) self.think1 ();
};

//=============================================================================

void() DelayThink =
{
	activator = self.enemy;
	SUB_UseTargets ();
	remove (self);
};

/*
==============================
SUB_UseTargets

The global "activator" should be set to the entity that initiated the firing.

If self.delay is set, a DelayedUse entity will be created that will actually
do the SUB_UseTargets after that many seconds have passed.

Centerprints any self.message to the activator.

Removes all entities with a targetname that match self.killtarget,
and removes them, so some events can remove other triggers.

Search for (string)targetname in all entities that
match (string)self.target and call their .use function

==============================
*/
/*
void() SUB_UseTargets =
{
	local entity t, stemp, otemp, act;
//
// Check for a delay
//
	if (self.delay)
	{
		// create a temp object to fire at a later time
		t = spawn ();
		t.classname = "DelayedUse";
		t.nextthink = time + self.delay;
		t.think = DelayThink;
		t.enemy = activator;
		t.message = self.message;
		t.killtarget = self.killtarget;
		t.target = self.target;
		return;
	}
	
	
//
// Print the message
//
	if (activator.classname == "player" && self.message != "")
	{
		centerprint (activator, self.message);
		if (!self.noise) sound (activator, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
	}

//
// Kill the killtagets
//
	if (self.killtarget)
	{
		t = world;
		do
		{
			t = find (t, targetname, self.killtarget);
			if (!t) return;
			remove (t);
		} 
		while (TRUE);
	}
	
//
// Fire targets
//
	if (self.target)
	{
		act = activator;
		t = world;
		do
		{
			t = find (t, targetname, self.target);
			if (!t) return;
			stemp = self;
			otemp = other;
			self = t;
			other = stemp;
			if (self.use != SUB_Null)
			{
				if (self.use) self.use ();
			}
			self = stemp;
			other = otemp;
			activator = act;
		} 
		while (TRUE);
	}
	

};
*/

void() key_touch;
void() SUB_regen;

void() SUB_UseTargets =
{
	local entity t, stemp, otemp, act;

	// Sleeper: A hack to keep Chthon from going back into the lava in MG1's final map when players pick up or run over the LG.
	if (mapname == "mgend" && self.classname == "weapon_lightning" && self.target == "boss_relay" && self.cnt_trig == 1)
		return;		
		
	// Check for a delay
	if (self.delay)
	{
		// Create a temp object to fire at a later time
		t = spawn ();
		t.classname = "DelayedUse";
		t.nextthink = time + self.delay;
		t.think = DelayThink;
		t.enemy = activator;
		t.message = self.message;
		t.killtarget = self.killtarget;
		t.target = self.target;
		// MG1 ====================================================
		t.spawnflags = self.spawnflags & MESSAGE_ALL_PLAYERS;
#ifdef ALLOW_DELAYED_THINK_CANCEL
		t.targetname = self.targetname;
		t.use = SUB_Null;
#endif
		// =========================================================
		return;
	}
	
	// Print the message
	if (activator.classname == "player" && self.message != "")
	{
// 		id1_centerprint (activator, self.message);
		// MG1 ===============================================================
		if (self.spawnflags & MESSAGE_ALL_PLAYERS) centerprint_all (other, self.message, self.message); // In-game message, localized
		else id1_centerprint (activator, self.message); // In-game message, localized
		// ====================================================================
		if (!self.noise) sound (activator, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);	
		if (self.special_noise) // NQW
		{
			if (self.special_spawned_pickup_sound == 1)  sound (activator, CHAN_VOICE, "misc/secret.wav", 1, ATTN_NORM);
			else sound (activator, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);					
		}					
	}
	
	// Kill the killtargets
	if (self.killtarget)
	{
		t = find (world, targetname, self.killtarget);		
		while (t)
		{
			remove (t);
			t = find (t, targetname, self.killtarget);
		}
	}

	// Fire targets
	if (self.target)
	{
		act = activator;
		t = find (world, targetname, self.target);
		while (t)
		{
			stemp = self;
			otemp = other;
			self = t;
			other = stemp;
			if (self.use != SUB_Null)
			{
				if (self.use) self.use ();
			}
			self = stemp;
			other = otemp;
			activator = act;
			t = find (t, targetname, self.target);
		}
	}
};

/*
In "Nightmare!", and "Sleeper Must Die!", all attack_finished
times become 0 some monsters refire twice automatically.
*/
float(entity targ) HasInvisible;
float(entity targ, float ignore_water) visible_sk5;

/*
in nightmare mode, all attack_finished times become 0
some monsters refire twice automatically
*/
/*
void(float normal, float nightmare, float ignore_invis) SUB_AttackFinished =
{
	if (cvar("skill") == 3) self.attack_finished = time + nightmare;
	else self.attack_finished = time + normal;
	
	if (!ignore_invis && self.attack_finished < time + 3)
	{
		if (HasInvisible(self.enemy)) self.attack_finished = time + 3;
	}
};

void(float normal, float nightmare) SUB_PainFinished =
{
	if (cvar("skill") == 3) self.pain_finished = time + nightmare;
	else self.pain_finished = time + normal;
};

float (entity targ, float ignore_water) visible;

void(void() thinkst) SUB_CheckRefire =
{
	if (c(cvar("skill") != 3 && cvar("skill") != 5) || (self.cnt >= 1) || (self.enemy.health <= 0))
	{
		self.cnt = 0;
		return;
	}
	
	local float novis = HasInvisible(self.enemy);
	if (!novis) novis |= !visible(self.enemy, FALSE);
	if (novis)
	{
		self.cnt = 0;
		return;
	}
	
	if (self.th_checkrefire)
	{
		if (!self.th_checkrefire())
		{
			self.cnt = 0;
			return;
		}
	}
	
	self.cnt = 1;
	self.think = thinkst;
};
*/

void(float normal) SUB_AttackFinished =
{
	self.cnt = 0;		// Refire count for nightmare
	if (cvar("skill") != 3 && cvar("skill") != 5) self.attack_finished = time + normal;
};

float(entity targ) visible;

void(void() thinkst) SUB_CheckRefire =
{
	if ((self.cnt >= 1 || self.enemy.health <= 0) && cvar("skill") == 5)
	{
		self.cnt = 0;
		return;
	}

	if (cvar("skill") != 3 && cvar("skill") != 5) return;
	if (self.cnt == 1) return;
	
	if (cvar("skill") <= 4)
	{	
		if (!visible (self.enemy)) return;
	}
	
	if (cvar("skill") == 5)
	{
		local float novis = HasInvisible (self.enemy);
		if (!novis) novis |= !visible_sk5 (self.enemy, FALSE);
		if (novis)
		{
			self.cnt = 0;
			return;
		}			
	}
	
	self.cnt = 1;
	self.think = thinkst;
};

/*
================
SUB_SwitchTargets
================
*/
void(.string field, string oldtarget, string newtarget) SUB_SwitchTargets =
{
	local entity e = find (world, targetname, oldtarget);
	while (e)
	{
		e.field = newtarget;
		e = find (e, targetname, oldtarget);
	}
};

/*
================
SUB_FindWithPredicate
================
*/
entity SUB_FindWithPredicate(entity start, .string field, string search, float(entity e) predicate = (float(entity e))SUB_True)
{
	local entity t = find (start, field, search);
	
	while (t && !predicate(t)) t = find (t, field, search);
	
	return t;
};

/*
================
SUB_CountTargets
================
*/
float(entity e, float(entity e) predicate = (float(entity e))SUB_True) SUB_CountTargets =
{
	local float cnt = 0;
	local entity t = SUB_FindWithPredicate (world, targetname, e.target, predicate);
	
	while (t)
	{
		cnt++;
		t = SUB_FindWithPredicate (t, targetname, e.target, predicate);
	}
	
	return cnt;
};

/*
================
SUB_RandomTarget
================
*/
entity(entity e, float(entity e) predicate = (float(entity e))SUB_True) SUB_RandomTarget =
{
	local float cnt = SUB_CountTargets (e, predicate);
	
	if (cnt == 0) return world;
	
	cnt = floor(cnt * random());
	
	local entity t = SUB_FindWithPredicate (world, targetname, e.target, predicate);
	while (cnt--)
	{
		t = SUB_FindWithPredicate (t, targetname, e.target, predicate);
	}
	
	return t;
};

/*
================
SUB_SetWorldType
================
*/
void() SUB_SetWorldtype =
{
	if (self.worldtype) self.worldtype--;
	else self.worldtype = world.worldtype;
};
