// Sleeper: Some of this stuff needs to be deleted and reworked.

/*
==============================================================================

Start of VOMITUS Section

==============================================================================
*/

.float      xfl/*, xf2*/;   // Extra flags without C code connections.
.entity     master;     // Like owner, without the C code bondage.
.float      dmg;        // damage done by door when hit  (PM:  Also drowning.)
.float	    dmgtime, gravity;
.float      pets;       // Number of pets owned.  Used by nightshade and necro.
.float      spawned;    // TRUE if created/summoned after a level load.

// Constants
float   SHOT_TIME_TOSS      = 5;
float   SHOT_TIME_BOUNCE    = 2.5;      // Assuming grenades.
float   SMARTBALL           = -1;   // Used instead of a movetype to do hack.
float   FLx_NOT_FALLING     =  515;     // Fly + Swim + Onground
float   XFL_PET         = 524288;   // Use to decrement pet counter.
float   SQRT2   = 1.4142;   // The square root of 2.

float(entity ent) IsFalling =
{
    // Not falling if flying, swimming, or already on the ground.
    if (ent.flags & FLx_NOT_FALLING)
        return FALSE;

    // Flying or ethereal targets cannot fall.
    if (ent.movetype == MOVETYPE_FLY)
        return FALSE;
    if (ent.movetype == MOVETYPE_NOCLIP)
        return FALSE;
    if (ent.movetype == MOVETYPE_FLYMISSILE)
        return FALSE;

    // Target is falling.
    return TRUE;
};

float(vector p1, vector p2, float sped) Aim_TossUp =
{
    local   float   gforce;     // Target gravity.
    local   float   up;         // Add to z.

    if (sped <= 0)
        return 0;   // Avoid division by zero.

    gforce = cvar("sv_gravity");
    p2 = p2 - p1;

    up = 0.5 * gforce / sped;
    up = vlen(p2) * up;
    return up;
};

float(vector p1, vector vel, float nomon, entity ignore, float fuse, vector spot, float mtype) TraceBallistic =
{
    local   float   fps, tpf;   // Frame Per Second, Time Per Frame.
    local   float   g, minv, maxv;
    local   float   t, dist, best;

// The closer time per frame is to hosttime, the more accurate the trace is.
// However, try to keep the number of traceline calls to a minimum.  Thus,
// 20 fps is a good compromise between accuracy and efficiency.
    fps = 20;       // Don't use zero or negative number.
    tpf = 1 / fps;
// Note:  If you really want to work more for more accuracy, use the
// following two lines instead.  Warning:  frametimes on a fast computer
// can approach a frametime of 0.01, meaning about 100 calls.  That's
// A LOT of traceline calling!
//    tpf = frametime;
//    fps = 1 / tpf;

    best = 20000;   // More than 8000 * 2.
    t = 0;
    fuse = floor(fuse * fps);
    g = cvar("sv_gravity") * tpf;
    maxv = cvar("sv_maxvelocity");
    minv = 0 - maxv;
//- - - - - - - - -
    // Velocity check
    if (vel_x > maxv)       vel_x = maxv;
    else if (vel_x < minv)  vel_x = minv;
    if (vel_y > maxv)       vel_y = maxv;
    else if (vel_y < minv)  vel_y = minv;
    if (vel_z > maxv)       vel_z = maxv;
    // Lower bound for z done in loop.
//- - - - - - - - -
    while (t < fuse)
    {
        if (vel_z < minv)   // Velocity check.
            vel_z = minv;   // Note:  Don't bother with reverse gravity.
        vel_z = vel_z - g;
        traceline (p1, p1 + (vel * tpf), nomon, ignore);
        p1 = trace_endpos;
    //- - - - - - - - -
        dist = vlen(p1 - spot);
        if (dist < best)
            best = dist;
    //- - - - - - - - -
        if (trace_fraction < 1)
        {
            if ((mtype != MOVETYPE_BOUNCE) || (trace_ent.takedamage == DAMAGE_AIM))
                fuse = 0;   // Got a hit -- break the loop!
            else
            {   // Rebound.  Emulate C physics code.
                // overbounce = 1.5, stop_epsilon = 0.1, as per C code.
//                vel = Vec_Reflect (vel, trace_plane_normal, 1.5, 0.1);
                if (vel == '0 0 0')
                    fuse = 0;   // Stopped.
                else
                {
                    trace_ent = world;      // Bounced off the guy.
                    trace_fraction = 1;
                }
            }
        }
        t = t + 1;
    }
    return best;        //return t * tpf;
};


// Returns a vector where x = cosine and y = sine of 'theta'.
vector(float theta) CoSine =
{
    local   vector  tx, ty, tz, vec;

    tx = v_forward;  ty = v_right;  tz = v_up;  // Save old makevectors.
    vec = '0 1 0' * theta;
    makevectors (vec);

    vec_x = v_forward_x;    // cos
    vec_y = v_forward_y;    // sin
    vec_z = 0;

    v_forward = tx;  v_right = ty;  v_up = tz;  // Restore old makevectors.
    return vec;
};

// Returns a vector where x = cosine, y = sine, and z = tangent of 'theta'.
vector(float theta) CoST =
{
    local   vector  vec;
    local   float   inf, qcsin, qccos;

    vec = CoSine (theta);

// 'inf' represents infinity.  Since a finite number is needed, set 'inf'
// to the highest possible value allowed to be returned.  The value chosen
// is one million.  I could go for broke by using ten million or even
// 16777215, the latter is all 24 bits on, instead.  However doing so
// causes rollover problems if a result of 'inf' that high gets added
// or multiplied by other numbers higher than one.  One million is
// sufficiently high and allows for some wiggle room.
    inf = 1000000;
    qccos = vec_x * inf;
    qcsin = vec_y * inf;
    if (fabs(qccos) < 1)
    {   // Avoid division by zero.
        if (qccos < 0)
            qccos = -1;
        else
            qccos = 1;
    }
    vec_z = qcsin / qccos;    // tan

    return vec;
};
// Trigonometric functions.
// Note:  Should use builtin when available.
float(float t) SUB_cos = {local vector v;  v = CoSine(t);  return v_x;};
float(float t) SUB_sin = {local vector v;  v = CoSine(t);  return v_y;};
float(float t) SUB_tan = {local vector v;  v = CoST(t);  return v_z;};

vector(vector dir) Vangles =
{
    dir   = vectoangles(dir);
    dir_x = anglemod(0 - dir_x);  // 'vectoangles' reverses pitch -- fix it!
    return dir;
};

vector(vector dir, vector vtan) Aim_Tangent =
{
    local   vector  vang;
    local   float   mx;

    // Combine the tangent side vector to the old directional vector.
    mx = vlen (dir);
    dir = normalize (dir);
    vang = Vangles (dir);
    makevectors (vang);
    dir = dir + (vtan_x * v_right) + (vtan_y * v_up);
    dir = normalize (dir);

    return (dir * mx);
};

vector(vector p1, vector p2, float sped, entity targ) Aim_Lead =
{
    if (!targ)
        return p2;     // No target.
    if (targ.movetype == MOVETYPE_NONE)
        return p2;     // Can't move, ignore velocity.
    if (targ.movetype == MOVETYPE_STEP)
        if (targ.flags & FLx_NOT_FALLING)
            return p2;     // Target velocity is not accurate.
    // Removed invisibility checks -- done elsewhere.
    if (!sped)
        return p2;     // Avoid division by zero.

    // Now find the spot.
    local   float   mx;
    local   float   loop;
    local   float   airtime;
    local   float   xyz;    // TRUE = Use all three dimensions.
    local   float   wired;  // TRUE = Riding a grapple cable.
    local   vector  lead;
    local   vector  tv;

//- - - - - - - - -
// Update 7/31/09:  Check if target is riding on a grappling wire.
// Note:  Applies only to attackers using the grappler to move,
// not creatures hooked and drawn toward the grappler.  However,
// since pulling hooked monsters is rare enough and does not apply
// to players, I'm not adding another field and more code just to
// make the case of aiming at hooked monsters pulled by players work.
    wired = FALSE;
//    if (targ.hook.state)    // Should be 0 if targ.hook == world.
//        if (Grapple_Pull_Who (targ) == targ)
            wired = TRUE;
//- - - - - - - - -
    tv = targ.velocity;
// Check if target's vertical velocity should be ignored.
    xyz = TRUE;

// Calculate the time it takes for a missile to reach a given spot,
// then calculate where the moving target will be after that amount of time.
// However, after predicting where the target will be, it may take more or
// less time for the missile to reach that spot.  Therefore, we ought to
// recalculate the time needed to reach the real spot.  Each recalcuation
// reduces the margin of error.  Idea is similar to a power series.
// Yes, brute force may be ugly, but it gets the job done.
//    mx = Aim_SpeedMod (targ);
    loop = 5;       // Make sure the number is odd.
    lead = p2;
    while (loop > 0)
    {
        airtime = vlen(lead - p1) / sped;
        lead = p2 + (tv * mx) * airtime;
        loop -= 1;
    }
//- - - - - - - - -

// Check for gravity.  For better accuracy, this check should be done in
// the above loop, but since this has much more code, just do this once,
// even if accuracy isn't perfect.
    if (xyz)
        if (IsFalling (targ))
    {
        local   float   fell;       // Distance fallen.
        local   float   gforce;     // Target gravity.

        gforce = cvar("sv_gravity");
        if (targ.gravity)
            gforce *= targ.gravity;

        fell = 0.5 * gforce * airtime * airtime;    // 1/2 gt^2.
        lead_z = lead_z - fell;

        // Check if the path to the spot is clear.
        traceline (p1, lead, TRUE, targ);
        if (trace_fraction < 1)
        {
            if (fell)
            {
                // Projected spot was blocked.  Check if the spot was blocked
                // due to the floor or ceiling alone.  If so, aim at the
                // surface.
                local   vector  spot;

                spot   = lead;
                spot_z = p2_z;

                traceline (spot, lead, TRUE, targ);
                lead = trace_endpos;
                if (fell > 0)
                    lead_z -= targ.mins_z;      // floor
                else
                    lead_z -= targ.maxs_z;      // ceiling
            }
        }
    }

// Our work here is done.
    return lead;
};

vector(vector p1, vector p2, float sped, float up, entity targ, float ex, float fuse, float mtype) Aim_Ballistic =
{
    if (!sped)
        return '0 0 0';     // Avoid divison by zero.

    local   vector  dir, vel, v1, v2, vup;
    local   float   d1, d2;
    local   float   toss, mx;

    vup = '0 0 0';
    vup_z = up;

// Locate the point we want to aim at.
    if (targ)
    {
        dir = Aim_Lead (p1, p2, sped, targ);
        if (ex < 1)
            dir = p2 + ((dir - p2) * ex);   // Partial leading.
        // Check if the path to the projected endpoint is clear.
        // NOTE:  This does not check if monsters are in the way.
        traceline (p1, dir, TRUE, self);
        if (trace_fraction == 1)
            p2 = dir;   // Success.
    }
    self.dest = p2;

// Get first vector:  Direction in the xy-plane only, eliminate z-axis.
// This is closest, albeit not identical, to id's old aiming code.
    dir = normalize(p2 - p1);
    vel = dir * sped;
    vel_z = vel_z + up;

    v1 = v2 = dir;
    v1_z = 0;
    v1 = normalize (v1);

// Get second vector:  Direction needed to hit opponent.  Does not account
// for obstacles in the way.
    // Determine the extra vertical speed needed to hit the target point.
    toss = Aim_TossUp (p1, p2, sped);
    vel = dir * sped;
    vel_z = vel_z + toss - up;
    //- - - - - - - - -
    // At this point, the upward speed returned would let the monster hit the
    // target point with perfect accuracy.  However, that is cheating since
    // the player cannot do that trick, especially if it lets the monster hit
    // at ranges longer than the player could hit if using the same attack
    // (for example, grenades).
    //
    // For the sake of efficiency, allow this sort of cheating only if the
    // resulting speed is slower than normal, which lets the monster drop
    // grenades from above without overshooting the target point.
    //- - - - - - - - -
    mx = vlen(vel) / sped;
    vel = normalize (vel);
    if (mx < 1)     // Yes, we may return a shorter-than-unit vector.
        vel = vel * mx;
    v2 = vel;

//- - - - - - - - -
    if (mtype == SMARTBALL)
        return v2;      // Smartball hack.
//- - - - - - - - -
// Project flight paths from the given two vectors.  If either hit the enemy,
// return the direction.  In case both vectors can hit, select the first
// forward-only vector, since it is the closest to the old monster aim code.
    if (self.enemy)
    {   // Check if we can hit our intended target.
        local   entity  vic;    // VICtim.
        local   entity  oown;   // Old OWNer, placeholder for swapping.

        vic = self.enemy;       // The target the trace needs to hit.
        oown = self.enemy.owner;    // See below in target spawn section.
        if (targ)
        {   // Shot leading on.
            // Note:  Leading shots to targ, so use targ, regardless of
            // self.enemy.  FWIW, targ is usually, if not always, self.enemy.
            if (p2 != targ.origin)
            {
                vic = spawn();   // Definitely NOT self.enemy or world.
                vic.owner = targ;
                vic.solid = targ.solid;
                vic.takedamage = targ.takedamage;
                setorigin (vic, p2);
                setsize (vic, targ.mins, targ.maxs);
                // Setting the enemy's owner to self lets traceline ignore
                // the enemy, if it ignores self.
                self.enemy.owner = self;
            }
        }
    // One
        d1 = TraceBallistic (p1, v1*sped + vup, FALSE, self, fuse, p2, mtype);
        if (trace_ent == vic)
        {   if (vic != self.enemy)
                {self.enemy.owner = oown;  remove (vic);}
            return v1;      // ONE!
        }
    // Two
        d2 = TraceBallistic (p1, v2*sped + vup, FALSE, self, fuse, p2, mtype);
        if (trace_ent == vic)
        {   if (vic != self.enemy)
                {self.enemy.owner = oown;  remove (vic);}
            return v2;      // TWO!
        }
        // If we didn't eliminate the dummy target yet, remove it now.
        if (vic != self.enemy)
            {self.enemy.owner = oown;  remove (vic);}
    }
    else
    {   // No target to hit, so simply aim at the given point.
        d1 = TraceBallistic (p1, v1*sped + vup, FALSE, self, fuse, p2, mtype);
        d2 = TraceBallistic (p1, v2*sped + vup, FALSE, self, fuse, p2, mtype);
    }

// Neither projections could hit the enemy, so pick the one that reached
// the closest to the enemy.
    if (d2 < d1)
        return v2;      // 3D Ballistic
    return v1;      // 2D Forward
};


vector(vector dir, vector spread) Maim_Scatter =
{
    local   float   r;

    if (self.enemy.invisible_finished)
    {
        r = random() * 4;   // Monsters have 25% chance to guess right.
        r = floor(r) * 5;   // Aim up to 15 degrees to either side.
        if (random() < 0.5)
            r = 0 - r;
    }
    else
        r = 0;

    // Randomize the angles before converting them into tangents.
    if (!spread_z)
        {spread_x = crandom() * spread_x;  spread_y = crandom() * spread_y;}
    spread_x = SUB_tan (spread_x + r);  spread_y = SUB_tan (spread_y);

    // Combine the tangent side vector to the old directional vector.
    return Aim_Tangent (dir, spread);
};

vector(vector p1, vector p2, float sped, float up, entity targ, vector spread) Maim_Toss =
{
    p2 = Aim_Ballistic (p1, p2, sped, up, targ, 1, SHOT_TIME_TOSS, MOVETYPE_TOSS);
    p2 = Maim_Scatter (p2, spread);
    return p2;
};

// Sleeper: This melee system doesn't make sense for vanilla Quake. It needs an animation.
/*
float(float def_range) InMeleeRange =
{
    local   float   dist;

    if (!self.enemy.modelindex)
        if (self.enemy.solid == SOLID_NOT)
            return FALSE;       // Phased out of the level.

    dist = vlen(self.enemy.origin - self.origin);
    if (dist > def_range)
        if ( dist > ((self.maxs_x + self.enemy.maxs_x) * SQRT2 + 10) )
            return FALSE;
            
    return TRUE;    // Within range.
};
*/

void(entity e, string s, vector v1, vector v2, vector org) setall =
{
    setmodel (e, s);        // May resize hullbox after this is called.
    setsize (e, v1, v2);    // Must do *after* setmodel.
    setorigin (e, org);     // Updates links immediately, so do last.
};

void() Meat_Touch =
{
    	
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove (self); return;}
        
    if (other.takedamage)
    {
	if (!self.dmg)
	{
		if (other.classname == "monster_tarbaby" || other.classname == "monster_birthed_tarbaby")
		    return;
		else
		    self.dmg = 10;
	}
	
        self.touch = SUB_Null;      // Stack overflow prevention.
        
	if (other.health) // Sleeper: Don't need unneccesary conflict. May revert when I fix the immune Spawn bug.
        {
		 if (other.classname == "monster_tarbaby" || other.classname == "monster_birthed_tarbaby")
			return; // This will make meat bounce off selected enemies.
		 else
			T_Damage (other, self, self.master, self.dmg);
	}    
        sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
        remove (self);
        return;
    }
    sound (self, CHAN_WEAPON, "zombie/z_miss.wav", 1, ATTN_NORM);    // bounce sound
    self.velocity = self.avelocity = '0 0 0';
    self.touch = SUB_Remove;
};

void(vector start, vector dir) Meat_Launch =
{	
    newmis 		= spawn ();
    newmis.master       = newmis.owner     = self;
    newmis.movetype     = MOVETYPE_BOUNCE;
    newmis.solid        = SOLID_BBOX;
//  newmis.classname    = "meat";
// set missile speed
    newmis.speed        = 600;
    newmis.velocity     = dir * 600;
    newmis.velocity_z  += 200;  // Used to be 200 only.
    newmis.avelocity    = '3000 1000 2000';
// set missile damage
    newmis.dmg          = 10;
// set missile duration
    newmis.touch        = Meat_Touch;
    newmis.nextthink    = time + 2.5;
    newmis.think        = SUB_Remove;

    setall (newmis, "progs/zom_gib.mdl", '0 0 0', '0 0 0', start);
};

/*
==============================================================================

End of VOMITUS Section

==============================================================================
*/