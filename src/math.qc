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

///////////////////////////////////////////////////////////
// Math related functions
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
// Modulus

float(float value, float minValue, float maxValue) clamp = 
{
	if (value > maxValue) return maxValue;
	else if (value < minValue) return minValue;

	return value;
};

float(float v, float m) mod =
{	
	if (m == 0) objerror("Illegal op: mod(x, 0)!");
	if (fabs(v) < m) return v;
	if (v == m) return 0;
	local float r = floor(v / m) * m;
    
	return v - r;
};

///////////////////////////////////////////////////////////
// Sine

float(float angle) sin =
{
	local vector a = {0, angle, 0};
	makevectors (a);
    
	return v_forward_y;
};

///////////////////////////////////////////////////////////
// Cosine

float(float angle) cos =
{
	local vector a = {0, angle, 0};
	makevectors (a);
    
	return v_forward_x;
};

/*
================
Bitshift emulation
================
*/

float(float num, float bits) SUB_LeftShift =
{
	bits = floor(bits);
	while (bits > 0)
	{
		num *= 2;
		bits--;
	}
	
	return num;
};

float(float num, float bits) SUB_RightShift =
{
	bits = floor(bits);
	while (bits > 0)
	{
		num /= 2;
		bits--;
	}
	
	return num;
};

// Copper ---------------------------------------------------------------
float BAD_THETA = -666;

float(float a, float b) min = {if (a <= b) return a; return b;}
float(float a, float b) max = {if (a >= b) return a; return b;}

float(float a, float b) not = {return a - (a & b);};

vector(float x, float y, float z) Vector =
{
	local vector swiz;
	
	swiz_x = x;
	swiz_y = y;
	swiz_z = z;
	
	return swiz;
};

vector(float num) SinCos =
{
	local vector angle, vf, vu, vr, result;
	
	vf = v_forward;
	vu = v_up;
	vr = v_right;
	
	angle = '0 1 0' * num;
	makevectors(angle);
	result = Vector (v_forward_y, v_forward_x, 0);
	
	v_forward = vf;
	v_up = vu;
	v_right = vr;
	
	return result;
};

float(float num) tan =
{
	local vector temp = SinCos (num);
	if (temp_y == 0) return A_SHITLOAD;	// to infinity and beyond
	
	return temp_x / temp_y;
};
 
float(float y, float x) atan2 =
{
	local vector ang = '0 0 0';  // Temporary used to calculate trig values
	ang_x = x;
	ang_y = y;
	
	return vectoyaw (ang);
};

/*
============
traceline2

A more robust wrapper for traceline() that can ignore a wider array of entities.
Performs one or more staggered traceline()s until the trace_ent isn't something we 
actually want to ignore, so what would be one trace can turn into several.
============
*/
void(vector start, vector end, entity ignore, float traceflags) traceline2 =
{
	local entity ig = ignore;
	// entity lastent = world;
	local vector src = start;
	local vector lastend = start;
	local float traces = 0;
	local float nomonsters = 0;
	
	if (traceflags & 1) nomonsters = TRUE;
	
	local float t_allsolid = 2;
	local float t_startsolid = -1;
	local float t_inopen = -1;
	local float t_inwater = -1;

/*
	if (trace_debug)
	{
		dprint("tracing from ");
		dprint_vector(src);
		dprint( " to ");
		dprint_vector(end);
		dprint("\n");
	}
*/

	// check for trace-through cases and repeat
	do 
	{
		/*
		if (trace_debug)
		{
			dprint("  trace ");
			dprint_vector(src);
			dprint( " to ");
			dprint_vector(end);
			dprint("\n");
		}
		*/
		
		traceline (src, end, nomonsters, ig);
		if (traces == 0)
		{
			if ((traceflags & 1) == 0 && (trace_fraction == 1.0 || trace_ent == world)) return;
		}
		
		// preserve the accuracy of the trace result flags
		if (t_startsolid == -1) t_startsolid = trace_startsolid;
		if (!trace_startsolid)
		{		
			t_allsolid = min(t_allsolid, trace_allsolid);
			t_inopen = max(t_inopen, trace_inopen);
			t_inwater = max(t_inwater, trace_inwater);
			
			if (trace_ent.deadflag == DEAD_DYING || 	// don't let guys in death frames who aren't nonsolid yet act like solid walls to bullets
				trace_ent == ignore || 					// always ignore the original ignore ent on future loops
				trace_ent.movetype == MOVETYPE_NOCLIP /*|| // don't shoot noclipping players
				invis_miss_check(trace_ent, start, end - start) || */
				/*trace_ent.notrace*/)						// flag to make things game-functionally nonsolid (monsterclip/etc)
			{
				// if two entities that are both to be ignored are touching, the trace will
				// fail with a distance of zero once 'ig' changes, so nudge forward one unit
				// to make sure the point of origin isn't touching the old ig
				lastend = trace_endpos;
				src = trace_endpos + normalize(end - start);
				ig = trace_ent;
//				if (trace_debug) dprint3("    hit ", trace_ent.classname, ", trying again\n");
			}
			else ig = world;
		}
		else
		{
			// if the nudge forward put the trace start in a solid, the last trace should 
			// have been the end. this can happen when a notrace surface and a legit solid 
			// surface are coincident in the path of the trace2, and the notrace one is the 
			// one quake 'sees' first.
//			if (trace_debug) dprint("  trace started solid!\n");
			trace_endpos = lastend;
			ig = world;
		}
		traces++;
	} while (ig != world);	// true if we hit a wall or hit nothing
	
//	if (trace_debug) dprint3("trace complete after ", ftos(traces), " traces \n");
	
	// unify global trace results so the calling function can pretend it only made one trace
	local float lastfrac = vlen(start - trace_endpos) / vlen(start - end);
	local entity lastent = trace_ent;
	if (traceflags & (1|2) == 2)
	{
		// thanks to a structural oddity in SV_ClipToLinks (world.c), a traceline() without nomonsters
		// doesn't properly populate the open/inwater trace flags, so we have to do another nomonsters
		// traceline2 over the path of the last one to catch the case of crossing water contents.
		
		// we can't just check pointcontents at start and end because it doesn't catch when mappers do
		// wacky things with water volumes (ie the E4 entry in the original start.bsp), and it can't be
		// a singular traceline() because a monster might be looking through a notrace bmodel into water.
		//dprint(" tracing again with nomonsters to get trace flags right\n");
		traceline2 (start, trace_endpos, ignore, 1);
	}
	else
	{
		trace_startsolid = t_startsolid;
		trace_allsolid = t_allsolid;
		trace_inopen = t_inopen;
		trace_inwater = t_inwater;
	}
	trace_fraction = lastfrac;
	trace_ent = lastent;
	
	/*
	if (trace_debug) 
	{
		if (trace_ent) dprint3("  entity: ", trace_ent.classname, "\n");
		
		dprint3("  end: ", vtos(trace_endpos), "\n");
		dprint3("  fraction: ", ftos(trace_fraction*100), "%\n");
		dprint3("  startsolid: ", ftos(trace_startsolid), "\n");
		dprint3("  allsolid: ", ftos(trace_allsolid), "\n");
		dprint3("  inopen: ", ftos(trace_inopen), "\n");
		dprint("----------\n");
	//	dprint3("  inwater: ", ftos(trace_inwater), "\n----------\n");
	}
	*/
}
// -----------------------------------------------------------------------