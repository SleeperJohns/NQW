// Empty Mask
float EMPTYMASK   	    = 0;

// Entity Masks
float PLAYERMASK  	    = 1;
float MONSTERMASK 	    = 2;

// Hittable Mask
float PROJECTILE 	    = 4;

// Team Masks
float TEAMRED4_PLAYERMASK   = 8;
float TEAMBLUE13_PLAYERMASK = 16;

// Preset Masks
// PvE -----------------------------------------------
// Sleeper: See all projectiles, monsters, and players and collide with them.
float PVE_BOTH_ENTITY_MASKS = PLAYERMASK + MONSTERMASK;

// Sleeper: See all projectiles, monsters, and players. Players will only collide with monsters and their projectiles. Players freely passthrough each other.
float PVE_MONSTER_ONLY = MONSTERMASK + PROJECTILE;
float PVE_GENERAL = PLAYERMASK + MONSTERMASK + PROJECTILE;

// Duel/FFA PvP ---------------------------------------
// Sleeper: No need for anti-collision in Duels or FFA.
float PvP_DM = PLAYERMASK + PROJECTILE;

// TDM/CTF/One Flag CTF PvP ---------------------------
// See all friendly and enemy players and projectiles. Friendly players can freely passthrough each other and their projectiles, but will collide with enemy players and enemy projectiles.
float PvP_BOTH_CLIENT_TEAMS = TEAMRED4_PLAYERMASK + TEAMBLUE13_PLAYERMASK;
float PvP_REDTEAM_STUFF = TEAMRED4_PLAYERMASK + PROJECTILE;
float PvP_BLUETEAM_STUFF = TEAMBLUE13_PLAYERMASK + PROJECTILE;
float PvP_TEAMS_ALL = TEAMRED4_PLAYERMASK + TEAMBLUE13_PLAYERMASK + PROJECTILE;

void(entity ent, float solid_bitmask, float hit_bitmask, float see_bitmask, float seen_bitmask, float ghost_bitmask, float ghost_alpha) entity_collision =
{
	ent.dimension_solid = solid_bitmask;
	ent.dimension_hit = hit_bitmask;
	ent.dimension_see = see_bitmask;
	ent.dimension_seen = seen_bitmask;
	ent.dimension_ghost = ghost_bitmask;
	ent.dimension_ghost_alpha = ghost_alpha;
};