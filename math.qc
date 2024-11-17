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

float(float v, float m) mod =
{	
	if (m == 0) objerror( "Illegal op: mod(x, 0)!");
	if (fabs(v) < m) return v;
	if (v == m) return 0;
	float r = floor(v / m) * m;
    
	return v - r;
};

///////////////////////////////////////////////////////////
// Sine

float(float angle) sin =
{
	vector a = {0, angle, 0};
	makevectors (a);
    
	return v_forward_y;
};

///////////////////////////////////////////////////////////
// Cosine

float(float angle) cos =
{
	vector a = {0, angle, 0};
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

/*
// Copper ---------------------------------------------------------------
float BAD_THETA = -666;

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
	vector temp = SinCos (num);
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
// -----------------------------------------------------------------------
*/