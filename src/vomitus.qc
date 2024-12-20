/*
==============================================================================

VOMITUS

==============================================================================
*/

$cd id1/models/vomitus
$origin 0 0 24
$base base        
$skin skin

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19
$frame walk20 walk21 walk22 walk23 walk24 walk25

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11 attack12 attack13

$frame pain1 pain2 pain3

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9
$frame death10 death11 death12 death13 death14 death15

//==========================================================================

// All other aspects have moved to the Vomitus monster entity has been moved to cutmonsterstuff.qc.

// The "Uber Zombie" Vomitus vomits chunks of meat.
void(float no) Vomit_Meat =
{
    local   vector  org, dir, err;
    local   float   side, up;
    

    err = '0 0 0';
    if (no)
    {
        if (random() < no)
            return;
        err_x = 10;
    }
    side = crandom() * 3;
    up = random() * 300;
    makevectors (self.angles);
    org = self.origin + v_forward*20 + v_right*side - v_up*6;
    dir = Maim_Toss (org, self.enemy.origin, 800, up, world, err);
    up = random();
    self.classname = "monster_vomit"; // Comes from this monster.
    Meat_Launch (org, dir);
    if (up < 0.2)
        setmodel (newmis, "progs/gib1.mdl");
    else
    {   // Bigger gibs...  
    newmis.dmg = random() * 15 + 15;  
        if (up < 0.4)
            setmodel (newmis, "progs/h_zombie.mdl");
        else if (up < 0.7)
            setmodel (newmis, "progs/gib2.mdl");
        else
            setmodel (newmis, "progs/gib3.mdl");
    }
    setsize (newmis, '0 0 0', '0 0 0');
};

// Sleeper: On skill 5, this mechanic might get overwhelming as enemies don't react to taking damage.
// It gets even worse when you don't know it that one of these Vomitus are spewing tarbabies at
// other enemies. So good luck with that. I know I hate it, and I won't be capping the amount of
// tarbabies the "Spawn Mother" give birth to. Unless the Spawn Mother exists in other skill levels.
// :)

// The "Spawn Mother" Vomitus vomits tarbabies.
void() Vomitus_Tarbaby =
{
    local   entity  parent;

    parent 	    = self;

    self 	    = spawn();
    self.flags      = 0;
    // Owner set to vomitus so the tarbaby can pass through it if necessary.
    self.owner      = self.master   = parent;
    setorigin (self, parent.origin);
    self.spawned    = TRUE;
    self.spawnflags = parent.spawnflags;
    self.classname  = "monster_birthed_tarbaby";
    self.health	    = 80;     
    // Monster is spew out of parent's yaw, so face away.
    self.angles_x   = 0;
    self.angles_y   = parent.angles_y;
    self.angles_z   = 0;
// The monster shall appear now.
    monster_tarbaby ();

// Yaw may change during tarbaby ai, change yaw back.
    self.angles_y   = parent.angles_y;
    self.fixangle   = TRUE;
// Override normal ai with flying ai, since it is launched out of vomitus.
    self.enemy      = parent.enemy;
//  tbaby_birth ();
    tbaby_bounce ();

// Pet counter, used to enforce limits.
    self.xfl 	    |= XFL_PET;
    parent.pets     += 1;     

// Successfully spawned a new creature.
    self = parent; 
    
    // Sleeper: Update the total monster count so it doesn't get screwed.	
    WriteByte (MSG_BROADCAST, SVC_UPDATESTAT);
    WriteByte (MSG_BROADCAST, STAT_TOTALMONSTERS);
    WriteLong (MSG_BROADCAST, total_monsters);    
};

void(float dist) vomit_run  =
{
    ai_run(dist);
};


//==========================================================================

// STAND - - - - - - - - - - - - - - - -
void() vom_stand1 =[ $walk1, vom_stand2 ] {ai_stand();};
void() vom_stand2 =[ $walk2, vom_stand3 ] {ai_stand();};
void() vom_stand3 =[ $walk3, vom_stand4 ] {ai_stand();};
void() vom_stand4 =[ $walk4, vom_stand5 ] {ai_stand();};
void() vom_stand5 =[ $walk5, vom_stand6 ] {ai_stand();};
void() vom_stand6 =[ $walk4, vom_stand7 ] {ai_stand();};
void() vom_stand7 =[ $walk3, vom_stand8 ] {ai_stand();};
void() vom_stand8 =[ $walk2, vom_stand1 ] {ai_stand();};

// WALK - - - - - - - - - - - - - - - -
void() vom_idle_sfx =
{
// Yes, use attn_norm instead of attn_idle.
    sound (self, CHAN_VOICE, "vomitus/plop.wav", 1, ATTN_NORM);
};
void() vom_walk1  =[ $walk1,  vom_walk2  ] {
    if (random() < 0.5)
        vom_idle_sfx();
    ai_walk(2);
};   // 3
void() vom_walk2  =[ $walk2,  vom_walk3  ] {ai_walk(2);};
void() vom_walk3  =[ $walk3,  vom_walk4  ] {ai_walk(2);};
void() vom_walk4  =[ $walk4,  vom_walk5  ] {ai_walk(2);};
void() vom_walk5  =[ $walk5,  vom_walk6  ] {ai_walk(2);};
void() vom_walk6  =[ $walk6,  vom_walk7  ] {ai_walk(2);};   // 2
void() vom_walk7  =[ $walk7,  vom_walk8  ] {ai_walk(2);};
void() vom_walk8  =[ $walk8,  vom_walk9  ] {ai_walk(2);};
void() vom_walk9  =[ $walk9,  vom_walk10 ] {ai_walk(2);};
void() vom_walk10 =[ $walk10, vom_walk11 ] {ai_walk(2);};   // 1
void() vom_walk11 =[ $walk11, vom_walk12 ] {ai_walk(2);};
void() vom_walk12 =[ $walk12, vom_walk13 ] {ai_walk(2);};
void() vom_walk13 =[ $walk13, vom_walk14 ] {ai_walk(2);};
void() vom_walk14 =[ $walk14, vom_walk15 ] {ai_walk(2);};
void() vom_walk15 =[ $walk15, vom_walk16 ] {ai_walk(2);};
void() vom_walk16 =[ $walk16, vom_walk17 ] {ai_turn();};
void() vom_walk17 =[ $walk17, vom_walk18 ] {ai_turn();};
void() vom_walk18 =[ $walk18, vom_walk19 ] {ai_turn();};
void() vom_walk19 =[ $walk19, vom_walk20 ] {ai_turn();};
void() vom_walk20 =[ $walk20, vom_walk21 ] {ai_turn();};
void() vom_walk21 =[ $walk21, vom_walk22 ] {ai_turn();};
void() vom_walk22 =[ $walk22, vom_walk23 ] {ai_turn();};
void() vom_walk23 =[ $walk23, vom_walk24 ] {ai_turn();};
void() vom_walk24 =[ $walk24, vom_walk25 ] {ai_turn();};
void() vom_walk25 =[ $walk25, vom_walk1  ] {ai_turn();};

// RUN - - - - - - - - - - - - - - - - -
void() vom_run1  =[ $run1,  vom_run2  ] {
    if (random() < 0.2)
        vom_idle_sfx();
    ai_run(4);
};
void() vom_run2  =[ $run2,  vom_run3  ] {ai_run(4);};
void() vom_run3  =[ $run3,  vom_run4  ] {ai_run(4);};
void() vom_run4  =[ $run4,  vom_run5  ] {ai_run(4);};
void() vom_run5  =[ $run5,  vom_run6  ] {ai_run(4);};
void() vom_run6  =[ $run6,  vom_run7  ] {ai_run(4);};
void() vom_run7  =[ $run7,  vom_run8  ] {ai_run(4);};
void() vom_run8  =[ $run8,  vom_run1  ] {ai_run(4);};

// ATTACK - - - - - - - - - - - - - - -
void() vom_end1 =[ $attack11, vom_end2     ] {ai_face();};
void() vom_end2 =[ $attack12, vom_end3     ] {ai_face();};
void() vom_end3 =[ $attack13, vom_run1     ] {ai_face();};

void() vom_attack1  =[ $attack1,  vom_attack2  ] {
    if (skill >= 5)	
	self.pain_finished = time + 1.2;    // Ignore pain during attack.
	
    sound (self, CHAN_WEAPON, "vomitus/vomit1.wav", 1, ATTN_NORM);
    ai_face();
};
void() vom_attack2  =[ $attack2,  vom_attack3  ] {ai_face();};
void() vom_attack3  =[ $attack3,  vom_attack4  ] {ai_face();};
void() vom_attack4  =[ $attack4,  vom_attack5  ] {ai_face();};
void() vom_attack5  =[ $attack5,  vom_attack6  ] {ai_face();};
void() vom_attack6  =[ $attack6,  vom_attack7  ] {ai_face();};
void() vom_attack7  =[ $attack7,  vom_attack8  ] {ai_face();};
void() vom_attack8  =[ $attack8,  vom_attack9  ] {ai_face();};
void() vom_attack9  =[ $attack9,  vom_attack10 ] {ai_face();};
void() vom_attack10 =[ $attack10, vom_attack11 ] 
{
    ai_face(); 
          
    if (self.skin)
        Vomit_Meat(0);
    else
    {
        Vomitus_Tarbaby();
        self.think = vom_end1;
    }
};
void() vom_attack11 =[ $attack11, vom_attack12 ] {ai_face(); Vomit_Meat(0.5);};
void() vom_attack12 =[ $attack12, vom_attack13 ] {ai_face(); Vomit_Meat(0.5);};
void() vom_attack13 =[ $attack13, vom_run1     ] {ai_face(); Vomit_Meat(0.5);};
void() vom_attack =
{	
    local   float   stop;

    stop = FALSE;
    if (enemy_range == RANGE_MELEE)
        if (random() < 0.5)     // Don't auto-vomit all the time.
            stop = TRUE;
    
// FIXME:  Let blue vomitus spit vermis-like spores.  Low priority though.
    if (stop)
        ai_charge (4);      // Cannot vomit anymore for now.
    else
        vom_attack1 ();     // Cough up a tarbaby.
};

// PAIN - - - - - - - - - - - - - - - -
void() vom_pain1  =[ $pain1,  vom_pain2  ] {};
void() vom_pain2  =[ $pain2,  vom_pain3  ] {};
void() vom_pain3  =[ $pain3,  vom_pain4  ] {};
void() vom_pain4  =[ $pain2,  vom_pain5  ] {};
void() vom_pain5  =[ $pain1,  vom_run1   ] {};

void(entity attacker, float damage) vom_pain =
{
// don't make multiple pain sounds right after each other
    if (self.pain_finished > time)
        return;

    self.pain_finished = time + 2;
    sound (self, CHAN_VOICE, "vomitus/pain.wav", 1, ATTN_NORM);        
    
    if (cvar("skill") <= 4)
	vom_pain1 ();
    attacker = attacker;  damage = damage;      // Appease FrikQcc.
};

void() vom_die1  =[ $death1,  vom_die2    ] {};
void() vom_die2  =[ $death2,  vom_die3    ] {};
void() vom_die3  =[ $death3,  vom_die4    ] 
{
	self.solid = SOLID_NOT;
	sound (self, CHAN_VOICE, "vomitus/death.wav", 1, ATTN_NORM);
	if (saved1 >= 4)
		remove(self);
};
void() vom_die4  =[ $death4,  vom_die5    ] {};
void() vom_die5  =[ $death5,  vom_die6    ] {};
void() vom_die6  =[ $death6,  vom_die7    ] {};
void() vom_die7  =[ $death7,  vom_die8    ] {};
void() vom_die8  =[ $death8,  vom_die9    ] {};
void() vom_die9  =[ $death9,  vom_die10   ] {};
void() vom_die10 =[ $death10, vom_die11   ] {};
void() vom_die11 =[ $death11, vom_die12   ] {};
void() vom_die12 =[ $death12, vom_die13   ] {};
void() vom_die13 =[ $death13, vom_die14   ] {};
void() vom_die14 =[ $death14, vom_die15   ] {};
void() vom_die15 =[ $death15, vom_die16   ] {};
void() vom_die16 =[ $death15, SUB_Null ] 
{
//	DelayedRemove();
};

void() vom_die = {vom_die1 ();};

// Sleeper: Resurrected Enemy that was cut from Quake's development.
// Vanilla-fied as much as possible coming from the Drake mod.
//==========================================================================
// --> QUAKED monster_vomit/monster_vomitus (1 0 0) (-32 -32 -24) (32 32 24)
// Bbox should be '-40 40 -24' to '40 40 24', but then it would need
// multiple bboxs.
//==========================================================================

// "Spawn Mother" Vomitus?
void() monster_vomitus =
{
	self.netname = "Spawn Mother";
	if (cvar("customcoop"))
	{
		// Vomitus Precache
		precache_model ("progs/vomitus.mdl");
		precache_sound ("vomitus/plop.wav");
		precache_sound ("vomitus/sight1.wav");
		precache_sound ("vomitus/vomit1.wav");
		precache_sound ("vomitus/pain.wav");
		precache_sound ("vomitus/death.wav");
		
		// Birthed Tarbaby Precache	
		precache_model("progs/tarbaby.mdl");
		precache_sound("blob/hit1.wav");
		precache_sound("blob/land1.wav");
		precache_sound("blob/sight1.wav");
		precache_sound ("blob/death1.wav");        
		
		self.solid = SOLID_SLIDEBOX;
		self.movetype = MOVETYPE_STEP;
		setmodel(self, "progs/vomitus.mdl");
		self.classname = "monster_vomit"; // Sleeper: Just to be safe that both Vomitus' classnames don't attack each other.
		setsize(self, '-32 -32 -24', '32 32 40');
		self.health = 125;
		self.takedamage = DAMAGE_AIM;
		self.th_stand = vom_stand1;
		self.th_walk = vom_walk1;
		self.th_run = vom_run1;
		self.th_melee = vom_attack1;
		self.th_die = vom_die1;
		self.th_missile = vom_attack1;
		self.th_pain = vom_pain;
		walkmonster_start();	
	}
	else
	{		
		// Vomitus Precache
		precache_model ("progs/vomitus.mdl");
		precache_sound ("vomitus/plop.wav");
		precache_sound ("vomitus/sight1.wav");
		precache_sound ("vomitus/vomit1.wav");
		precache_sound ("vomitus/pain.wav");
		precache_sound ("vomitus/death.wav");
		
		// Birthed Tarbaby Precache	
		precache_model("progs/tarbaby.mdl");
		precache_sound("blob/hit1.wav");
		precache_sound("blob/land1.wav");
		precache_sound("blob/sight1.wav");
		precache_sound ("blob/death1.wav");  

		self.classname = "monster_vomit"; // Sleeper: Just to be safe that both Vomitus' classnames don't attack each other.    	
		self.health = 125;
		self.takedamage = DAMAGE_AIM;
		self.th_stand = vom_stand1;
		self.th_walk = vom_walk1;
		self.th_run = vom_run1;
		self.th_melee = vom_attack1;
		self.th_die = vom_die1;
		self.th_missile = vom_attack1;
		self.th_pain = vom_pain;
		    
		InitMonster("progs/vomitus.mdl", MONSTER_TYPE_WALK, MONSTER_SIZE_LARGE);  
	}	
};               	
/*
void() monster_vomitus =
{
	// Filter out of Deathmatch
	if (deathmatch)
	{
		remove(self);
		return;
	}		
	// Vomitus Precache
        precache_model ("progs/vomitus.mdl");
        precache_sound ("vomitus/plop.wav");
        precache_sound ("vomitus/sight1.wav");
        precache_sound ("vomitus/vomit1.wav");
        precache_sound ("vomitus/pain.wav");
        precache_sound ("vomitus/death.wav");
        
        // Birthed Tarbaby Precache	
        precache_model("progs/tarbaby.mdl");
        precache_sound("blob/hit1.wav");
        precache_sound("blob/land1.wav");
        precache_sound("blob/sight1.wav");
        precache_sound ("blob/death1.wav");        
        
        self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/vomitus.mdl");
	self.classname = "monster_vomit"; // Sleeper: Just to be safe that both Vomitus' classnames don't attack each other.
	setsize(self, '-32 -32 -24', '32 32 40');
	self.health = 125;
	self.takedamage = DAMAGE_AIM;
	self.th_stand = vom_stand1;
	self.th_walk = vom_walk1;
	self.th_run = vom_run1;
	self.th_melee = vom_attack1;
	self.th_die = vom_die1;
	self.th_missile = vom_attack1;
	self.th_pain = vom_pain;
	walkmonster_start();	
};
*/

// "Uber Zombie" Vomitus?
void() monster_vomit =
{
    self.netname = "Vomitus";
    if (cvar("customcoop"))
    {
	// Vomitus Precache
	precache_model ("progs/vomitus.mdl");
	precache_sound ("vomitus/plop.wav");
	precache_sound ("vomitus/sight1.wav");
	precache_sound ("vomitus/vomit1.wav");
	precache_sound ("vomitus/pain.wav");
	precache_sound ("vomitus/death.wav");
        
	// Precaches for Vomitus'... vomit projectiles.
	precache_model ("progs/zom_gib.mdl");
	precache_model ("progs/h_zombie.mdl");
	precache_sound ("zombie/z_miss.wav");
	precache_sound ("zombie/z_hit.wav");     
     
	self.skin = 1; // Change Skin to a Meatwad    
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/vomitus.mdl");
	self.classname = "monster_vomitus"; // Sleeper: Just to be safe that both Vomitus' classnames don't attack each other.
	setsize(self, '-32 -32 -24', '32 32 40');
	self.health = 250;
	self.takedamage = DAMAGE_AIM;
	self.th_stand = vom_stand1;
	self.th_walk = vom_walk1;
	self.th_run = vom_run1;
	self.th_melee = vom_attack1;
	self.th_die = vom_die1;
	self.th_missile = vom_attack1;
	self.th_pain = vom_pain;
	walkmonster_start();  
    }  	
    else
    {
	// Vomitus Precache
	precache_model ("progs/vomitus.mdl");
	precache_sound ("vomitus/plop.wav");
	precache_sound ("vomitus/sight1.wav");
	precache_sound ("vomitus/vomit1.wav");
	precache_sound ("vomitus/pain.wav");
	precache_sound ("vomitus/death.wav");
    
	// Precaches for Vomitus'... vomit projectiles.
	precache_model ("progs/zom_gib.mdl");
	precache_model ("progs/h_zombie.mdl");
	precache_sound ("zombie/z_miss.wav");
	precache_sound ("zombie/z_hit.wav");
    
	self.skin = 1; // Change Skin to a Meatwad    
	self.classname = "monster_vomitus"; // Sleeper: Just to be safe that both Vomitus' classnames don't attack each other.    	
	self.health = 250;
	self.takedamage = DAMAGE_AIM;
	self.th_stand = vom_stand1;
	self.th_walk = vom_walk1;
	self.th_run = vom_run1;
	self.th_melee = vom_attack1;
	self.th_die = vom_die1;
	self.th_missile = vom_attack1;
	self.th_pain = vom_pain;
    
	InitMonster("progs/vomitus.mdl", MONSTER_TYPE_WALK, MONSTER_SIZE_LARGE);
    }
};

/*
// "Uber Zombie" Vomitus?
void() monster_vomit =
{
    // Filter out of Deathmatch
    if (deathmatch)
    {
	remove(self);
	return;
    }
    // Vomitus Precache
    precache_model ("progs/vomitus.mdl");
    precache_sound ("vomitus/plop.wav");
    precache_sound ("vomitus/sight1.wav");
    precache_sound ("vomitus/vomit1.wav");
    precache_sound ("vomitus/pain.wav");
    precache_sound ("vomitus/death.wav");
        
    // Precaches for Vomitus'... vomit projectiles.
    precache_model ("progs/zom_gib.mdl");
    precache_model ("progs/h_zombie.mdl");
    precache_sound ("zombie/z_miss.wav");
    precache_sound ("zombie/z_hit.wav");     
     
    self.skin = 1; // Change Skin to a Meatwad    
    self.solid = SOLID_SLIDEBOX;
    self.movetype = MOVETYPE_STEP;
    setmodel(self, "progs/vomitus.mdl");
    self.classname = "monster_vomitus"; // Sleeper: Just to be safe that both Vomitus' classnames don't attack each other.
    setsize(self, '-32 -32 -24', '32 32 40');
    self.health = 250;
    self.takedamage = DAMAGE_AIM;
    self.th_stand = vom_stand1;
    self.th_walk = vom_walk1;
    self.th_run = vom_run1;
    self.th_melee = vom_attack1;
    self.th_die = vom_die1;
    self.th_missile = vom_attack1;
    self.th_pain = vom_pain;
    walkmonster_start();	    
};
*/

// Sleeper: As a trend, the Vomitus and Spawns are treated as the same species (or the same monster entity), so they don't attack each other. Like a happy family!