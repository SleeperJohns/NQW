// New entity fields
.entity hook; // this is my hook
.float on_hook; // we're on it
.float hook_out; // it's out

// prototypes for WEAPONS.QC functions
float() crandom;
void(vector org, vector vel, float damage) SpawnBlood;

/************\
* BreakChain *
\************/

void(entity Head) BreakChain =
{

        local entity link = Head.goalentity;
        while (link != world)
        {
                Head = link.goalentity;
                remove (link);
                link = Head;
        }
};

/*********\
* LinkPos *
\*********/

void() LinkPos =
{
        makevectors (self.enemy.angles);
        setorigin (self, self.owner.origin + (((self.enemy.origin + (v_up * 16 * (!self.enemy.button2)) + (v_forward * 16)) - self.owner.origin) * (self.weapon)));
        self.nextthink = time + 0.1;
};

/***********\
* MakeChain *
\***********/

entity(entity head, entity tail, float num) MakeChain =
{
        local entity link, prevlink;

        local float linknum = num;
        num += 1;
        prevlink = world;
        while (linknum > 0)
        {
                link = spawn();

                link.goalentity = prevlink;
                prevlink = link;

                link.owner = head;
                link.enemy = tail;
                link.weapon = linknum / num;
                link.movetype = MOVETYPE_NOCLIP;
                link.solid = SOLID_NOT;
                link.angles_z = 51 * linknum;
                link.angles_y = 41 * linknum;
                link.angles_x = 31 * linknum;
                link.avelocity = '310 410 510';
//		if (teamplay & TEAM_CAPTURE_CUSTOM)
//			setmodel (link, "progs/bit.mdl");
//		else
				setmodel (link, "progs/s_spike.mdl");
                setsize (link, '0 0 0', '0 0 0');
                makevectors (tail.angles);
                setorigin (link, head.origin + (((tail.origin + (v_up * 16 * (!tail.button2)) + (v_forward * 16)) - head.origin) * (link.weapon)));
                link.nextthink = time + 0.1;
                link.think = LinkPos;
                linknum -= 1;
        }
        return link;
};


/************\
* HookVanish *
\************/

void() HookVanish =
{
        self.owner.hook_out = FALSE;
/*
        if (self.enemy.classname == "player")
                self.enemy.attack_finished = time + 0.1;
*/
//	if (teamplay & TEAM_CAPTURE_CUSTOM)
//		sound (self.owner, CHAN_WEAPON, "weapons/bounce2.wav", 1, ATTN_NORM);
        BreakChain (self);
        remove (self);
};

void() UnHookPlayer =
{
	if (self.hook_out) 
	{
		local entity oself = self;
		self = self.goalentity;
		HookVanish ();
		self = oself;
	}
};

/**********\
* HookPull *
\**********/

void() HookPull =
{
        local vector vel, spray;
        local float v, dorg;

	if ((!self.owner.button0) || (self.owner.teleport_time > time ) || self.owner.deadflag) 
	{
		HookVanish();
		return;
	} 
	else 
	{
		 if (self.enemy.takedamage) 
		 {
			// don't hurt teammates
			if (self.enemy.classname != "player" || !teamplay || self.enemy.steam != self.owner.steam) 
			{
				// 4.1, if we can't see our enemy, unlock
				if (!CanDamage(self.enemy, self.owner)) 
				{
					HookVanish();
					return;
				}

				sound (self, CHAN_WEAPON, "blob/land1.wav", 1, ATTN_NORM);
				T_Damage (self.enemy, self, self.owner, 1);
				makevectors (self.v_angle);
				spray_x = 100 * crandom();
				spray_y = 100 * crandom();
				spray_z = 100 * crandom() + 50;
				SpawnBlood (self.origin, spray, 20);
			}
			if (self.enemy.solid == SOLID_SLIDEBOX) 
			{
				self.velocity = '0 0 0';
				setorigin (self, self.enemy.origin + self.enemy.mins + (self.enemy.size * 0.5));
			} 
			else self.velocity = self.enemy.velocity;
		} 
		else self.velocity = self.enemy.velocity;
		
		if (self.enemy.solid == SOLID_NOT)
		{
			HookVanish();
			return;
		}
		makevectors (self.owner.angles);
		vel = self.origin - (self.owner.origin + (v_up * 16 * (!self.owner.button2)) + (v_forward * 16));
		v = vlen (vel);
		if (v <= 100) vel = normalize(vel) * v * 10;
		if (v > 100) vel = normalize(vel) * 1000;

//		if (teamplay & TEAM_CAPTURE_CUSTOM) 
		{
			dorg = vlen(self.owner.origin - self.dest);
			if (dorg > 10 && self.style == 3) 
			{
//				sound (self.owner, CHAN_WEAPON, "weapons/chain2.wav", 1, ATTN_NORM);
				self.style = 2;
			}
			if (dorg < 10 && self.style == 2) 
			{
//				sound (self.owner, CHAN_WEAPON, "weapons/chain3.wav", 1, ATTN_NORM);
				self.style = 3;
			}
		}

		self.owner.velocity = vel;
		self.dest = self.owner.origin;
		self.nextthink = time + 0.1;
	}
};

/**************\
* T_ChainTouch *
\**************/

void() T_ChainTouch =
{
	if (other == self.owner) return; // don't attach to owner

	if (pointcontents(self.origin) == CONTENT_SKY) 
	{
         HookVanish();
         return;
	}

	if (other.classname == "player" && teamplay && other.team == self.owner.steam)
		return; // just pass through teammates

	if (other.takedamage) 
	{
		// don't damage teammates
		if (other.classname == "player") other.axhitme = 1; // make axe noise
		else sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		T_Damage (other, self, self.owner, 10);
		SpawnBlood (self.origin, self.velocity, 10);
	} 
	else 
	{
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		self.avelocity = '0 0 0';
	}

	if (!self.owner.button0) 
	{
		HookVanish();
		return;
	}
	else
	{
		if (other.solid == SOLID_SLIDEBOX) 
		{
			setorigin (self, other.origin + other.mins + (other.size * 0.5));
			self.velocity = '0 0 0';
		} 
		else self.velocity = other.velocity;
		self.weapon = other.nextthink - time;
//		if (teamplay & TEAM_CAPTURE_CUSTOM)
			sound (self.owner, CHAN_WEAPON, "weapons/chain2.wav", 1, ATTN_NORM);

		self.style = 2;
		self.enemy = other;
		self.nextthink = time + 0.1;
		self.think = HookPull;
		self.touch = SUB_Null;
	}
};

/*************\
* W_FireChain *
\*************/

void() W_FireChain =
{
        self.hook_out = TRUE;
        local entity hook = spawn ();
        hook.owner = self;
		self.goalentity = hook;
        hook.movetype = MOVETYPE_FLY;
        hook.solid = SOLID_BBOX;

// set hook speed

        makevectors (self.v_angle);
        hook.velocity = aim(self, 1000);
        hook.velocity = hook.velocity * 800;
        hook.angles = vectoangles (hook.velocity);
        hook.avelocity = '0 0 -500';

        hook.touch = T_ChainTouch;

// set hook sound
        hook.nextthink = time + 5;
        hook.think = HookVanish;

//	if (teamplay & TEAM_CAPTURE_CUSTOM)
//		setmodel (hook, "progs/star.mdl");
//	else
		setmodel (hook, "progs/v_spike.mdl");
        setsize (hook, '0 0 0', '0 0 0');
        setorigin (hook, self.origin + (v_forward*16) + '0 0 16' );

//	if (teamplay & TEAM_CAPTURE_CUSTOM)
//		sound (self, CHAN_WEAPON, "weapons/chain1.wav", 1, ATTN_NORM);
//	else
		sound (self, CHAN_WEAPON, "hknight/hit.wav", 1, ATTN_NORM);

        hook.goalentity = MakeChain (hook, self, 3);
};