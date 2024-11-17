// This is a decompiled variant of qstats as the source isn't public. It will (hopefully) get cleaned, and be stripped of any garbage code that doesn't work.

// Sleeper: Note that this version of Qstats on private/Single Player and public servers will have an automatic rejection to SDA and speedrun.com!!!!
// You must get the REAL Qstats v1.8 Patch from SDA for runs to be valid! This version of Qstats is for Quake servers to host their own Leaderboards. 

// float WritingStuff;
float DisplayedExitMsg;
// float PrintComma;
// entity CallingThing;
void() GrenadeExplode;
float numlevels;
float totaltime;
float realnull;
float mlstage;

/*
void(float value) bprintftos =
{
	local float tmp;

	if ((value == rint(value)))
	{
		bprint(ftos(value));
	}
	else
	{
		tmp = floor(value);
		bprint(ftos(tmp));
		bprint(".");
		value = (TE_LAVASPLASH * (value - tmp));
		value = rint(value);
		bprint(ftos(value));
	}
};

string(entity what) NameOf =
{
	if (what.netname)
	{
		return (what.netname);
	}
	else
	{
		return (what.classname);
	}
};

void() StartWriting =
{
	WritingStuff = AS_STRAIGHT;
	bprint(NameOf(CallingThing));
	if (((CallingThing.wait > MSG_BROADCAST) && ((CallingThing.netname == "Trigger") || (CallingThing.netname == "Button"))))
	{
		bprint(" [Reset in ");
		bprintftos(CallingThing.wait);
		bprint("]: ");
	}
	else
	{
		bprint(": ");
	}
};

float(entity what) HasUse =
{
	if (what.use)
	{
		if ((what.use != SUB_Null))
		{
			return (AS_STRAIGHT);
		}
	}
	return (MSG_BROADCAST);
};

entity(entity start, string name) findcnt =
{
	local entity t;

	t = start;
	t = find(t, classname, name);
	while (find(t, classname, name))
	{
		if ((t.cnt == WritingStuff))
		{
			return (t);
		}
	}
	return (world);
};

void() StatUseTargets =
{
	local entity t;
	local entity stemp;
	local entity otemp;
	local entity act;
	local entity te;
	local entity te2;
	local float tmp;

	if (self.delay)
	{
		t = spawn();
		t.classname = "DelayedUse";
		t.netname = "Delayed event";
		t.nextthink = (time + self.delay);
		t.think = DelayThink;
		t.enemy = activator;
		t.message = self.message;
		t.killtarget = self.killtarget;
		t.target = self.target;
		if ((!CallingThing && (self.netname != "Teleporter")))
		{
			CallingThing = self;
			StartWriting();
			bprint("delay of ");
			bprintftos(self.delay);
			bprint("\n");
			CallingThing = world;
			WritingStuff = MSG_BROADCAST;
		}
		return;
	}
	if (((activator.classname == "player") && (self.message != "")))
	{
		centerprint(activator, self.message);
		if (!self.noise)
		{
			sound(activator, CHAN_VOICE, "misc/talk.wav", AS_STRAIGHT, ATTN_NORM);
		}
	}
	if (self.killtarget)
	{
		if (!CallingThing)
		{
			CallingThing = self;
		}
		t = world;
		do
		{
			t = find(t, targetname, self.killtarget);
			if (!t)
			{
				if ((CallingThing == self))
				{
					te = findcnt(world, "kill counter");
					while (findcnt(world, "kill counter"))
					{
						if (PrintComma)
						{
							bprint(", ");
						}
						else
						{
							PrintComma = AS_STRAIGHT;
						}
						te2 = te;
						te2 = findcnt(te2, "kill counter");
						while (findcnt(te2, "kill counter"))
						{
							if ((te2.count < te.count))
							{
								te = te2;
							}
						}
						if ((te.count > AS_STRAIGHT))
						{
							bprint(ftos(te.count));
							bprint(" ");
							bprint(te.netname);
							bprint("s");
						}
						else
						{
							bprint(te.netname);
						}
						remove(te);
					}
					CallingThing = world;
					WritingStuff = MSG_BROADCAST;
					if (PrintComma)
					{
						bprint("}");
					}
					PrintComma = MSG_BROADCAST;
					bprint("\n");
				}
				else
				{
					if ((WritingStuff && (self.netname == "Counter")))
					{
						tmp = MSG_BROADCAST;
						te = findcnt(world, "kill counter");
						while (findcnt(world, "kill counter"))
						{
							if (PrintComma)
							{
								bprint(", ");
							}
							else
							{
								PrintComma = AS_STRAIGHT;
							}
							if (!tmp)
							{
								bprint("Kill {");
								tmp = AS_STRAIGHT;
							}
							te2 = te;
							te2 = findcnt(te2, "kill counter");
							while (findcnt(te2, "kill counter"))
							{
								if ((te2.count < te.count))
								{
									te = te2;
								}
							}
							if ((te.count > AS_STRAIGHT))
							{
								bprint(ftos(te.count));
								bprint(" ");
								bprint(te.netname);
								bprint("s");
							}
							else
							{
								bprint(te.netname);
							}
							remove(te);
						}
						if ((tmp == AS_STRAIGHT))
						{
							bprint("}");
						}
						WritingStuff = (WritingStuff - AS_STRAIGHT);
						bprint("]");
					}
				}
				return;
			}
			tmp = MSG_BROADCAST;
			te = world;
			if (!WritingStuff)
			{
				StartWriting();
				if ((CallingThing == self))
				{
					bprint("Kill {");
				}
			}
			te = findcnt(te, "kill counter");
			while (((findcnt(te, "kill counter") != world) && !tmp))
			{
				if ((te.netname == NameOf(t)))
				{
					te.count = (te.count + AS_STRAIGHT);
					tmp = AS_STRAIGHT;
				}
			}
			if (!tmp)
			{
				te = spawn();
				te.classname = "kill counter";
				te.netname = NameOf(t);
				te.count = AS_STRAIGHT;
				te.cnt = WritingStuff;
			}
			remove(t);

		} while (AS_STRAIGHT);
	}
	if (self.target)
	{
		if (!CallingThing)
		{
			CallingThing = self;
		}
		act = activator;
		t = world;
		do
		{
			t = find(t, targetname, self.target);
			if (!t)
			{
				if (((CallingThing == self) || ((self.netname == "Counter") && (WritingStuff > AS_STRAIGHT))))
				{
					tmp = MSG_BROADCAST;
					te = findcnt(world, "stat delayed");
					while (findcnt(world, "stat delayed"))
					{
						if (PrintComma)
						{
							bprint(", ");
						}
						else
						{
							PrintComma = AS_STRAIGHT;
						}
						if (!tmp)
						{
							if (findcnt(te, "stat delayed"))
							{
								bprint("delayed events in [");
								tmp = AS_STRAIGHT;
							}
							else
							{
								bprint("delayed event in ");
							}
						}
						te2 = te;
						te2 = findcnt(te2, "stat delayed");
						while (findcnt(te2, "stat delayed"))
						{
							if ((te2.delay < te.delay))
							{
								te = te2;
							}
						}
						bprintftos(te.delay);
						remove(te);
					}
					if (tmp)
					{
						bprint("]");
					}
					te = findcnt(world, "stat counter");
					while (findcnt(world, "stat counter"))
					{
						if (PrintComma)
						{
							bprint(", ");
						}
						else
						{
							PrintComma = AS_STRAIGHT;
						}
						te2 = te;
						te2 = findcnt(te2, "stat counter");
						while (findcnt(te2, "stat counter"))
						{
							if ((te2.count < te.count))
							{
								te = te2;
							}
						}
						if ((te.count > AS_STRAIGHT))
						{
							bprint(ftos(te.count));
							bprint(" ");
							bprint(te.netname);
							bprint("s");
						}
						else
						{
							bprint(te.netname);
						}
						remove(te);
						te = world;
					}
					tmp = MSG_BROADCAST;
					te = findcnt(world, "kill counter");
					while (findcnt(world, "kill counter"))
					{
						if (PrintComma)
						{
							bprint(", ");
						}
						else
						{
							PrintComma = AS_STRAIGHT;
						}
						if (!tmp)
						{
							bprint("Kill {");
							tmp = AS_STRAIGHT;
						}
						te2 = te;
						te2 = findcnt(te2, "kill counter");
						while (findcnt(te2, "kill counter"))
						{
							if ((te2.count < te.count))
							{
								te = te2;
							}
						}
						if ((te.count > AS_STRAIGHT))
						{
							bprint(ftos(te.count));
							bprint(" ");
							bprint(te.netname);
							bprint("s");
						}
						else
						{
							bprint(te.netname);
						}
						remove(te);
					}
					if ((tmp == AS_STRAIGHT))
					{
						bprint("}");
					}
					if ((WritingStuff > AS_STRAIGHT))
					{
						bprint("]");
						WritingStuff = (WritingStuff - AS_STRAIGHT);
					}
					else
					{
						if ((WritingStuff == AS_STRAIGHT))
						{
							bprint("\n");
							WritingStuff = MSG_BROADCAST;
							PrintComma = MSG_BROADCAST;
						}
					}
				}
				if ((CallingThing == self))
				{
					CallingThing = world;
				}
				return;
			}
			if (HasUse(t))
			{
				if (((t.netname == "Trigger") && t.delay))
				{
					if (!WritingStuff)
					{
						StartWriting();
					}
					te = spawn();
					te.classname = "stat delayed";
					te.delay = t.delay;
					te.cnt = WritingStuff;
				}
				else
				{
					if ((t.classname == "trigger_counter"))
					{
						if ((t.count > MSG_BROADCAST))
						{
							if (!WritingStuff)
							{
								StartWriting();
							}
							if (PrintComma)
							{
								bprint(", ");
							}
							else
							{
								PrintComma = AS_STRAIGHT;
							}
							bprint("Counter [");
							tmp = (t.count - AS_STRAIGHT);
							if (tmp)
							{
								bprint(ftos(tmp));
								bprint(" to go]");
							}
							else
							{
								bprint("Activated: ");
								if (t.delay)
								{
									bprint("delay of ");
									bprintftos(t.delay);
									bprint("]");
								}
								else
								{
									if (!t.target)
									{
										bprint("]");
									}
									else
									{
										PrintComma = MSG_BROADCAST;
										WritingStuff = (WritingStuff + AS_STRAIGHT);
									}
								}
							}
						}
					}
					else
					{
						if ((t.netname != "Trigger"))
						{
							if (!WritingStuff)
							{
								StartWriting();
							}
							tmp = MSG_BROADCAST;
							te = world;
							te = findcnt(te, "stat counter");
							while (((findcnt(te, "stat counter") != world) && !tmp))
							{
								if ((te.netname == NameOf(t)))
								{
									te.count = (te.count + AS_STRAIGHT);
									tmp = AS_STRAIGHT;
								}
							}
							if (!tmp)
							{
								te = spawn();
								te.classname = "stat counter";
								te.netname = NameOf(t);
								te.count = AS_STRAIGHT;
								te.cnt = WritingStuff;
							}
						}
					}
				}
			}
			stemp = self;
			otemp = other;
			self = t;
			other = stemp;
			if (HasUse(self))
			{
				self.use();
			}
			self = stemp;
			other = otemp;
			activator = act;

		} while (AS_STRAIGHT);
	}
};

void() ResetPermParms =
{
	parm1 = (IT_AXE + IT_SHOTGUN);
	parm2 = 100;
	parm3 = MSG_BROADCAST;
	parm4 = 25;
	parm5 = MSG_BROADCAST;
	parm6 = MSG_BROADCAST;
	parm7 = MSG_BROADCAST;
	parm8 = IT_SHOTGUN;
	parm9 = MSG_BROADCAST;
};

void() SetPermParms =
{
	local float tmp;
	local string tmps;

	tmp = (parm8 - AS_STRAIGHT);
	if ((tmp == CONTENT_EMPTY))
	{
		tmp = TE_WIZSPIKE;
	}
	tmp = ((((AS_STRAIGHT + ((parm1 & 126) / AS_SLIDING)) + (IT_LIGHTNING * (100 - parm2))) + (3264 * parm3)) + (656064 * tmp));
	tmps = ftos(tmp);
	cvar_set("registered", tmps);
	tmp = (((parm4 - 25) + (76 * parm5)) + (15276 * parm6));
	tmps = ftos(tmp);
	cvar_set("sys_ticrate", tmps);
	tmp = (parm9 / SVC_INTERMISSION);
	tmp = ceil(tmp);
	tmp = (parm7 + (101 * tmp));
	tmps = ftos(tmp);
	cvar_set("temp1", tmps);
};

void(float open, float close) PrintBracket =
{
	if ((parm13 == open))
	{
		bprint("");
	}
	else
	{
		if ((parm13 == close))
		{
			bprint("");
		}
		else
		{
			bprint(" ");
		}
	}
};
*/

/*
void() PrintAllParms =
{
	cvar_set("con_notifytime", "60");
	PrintBracket(AS_STRAIGHT, SVC_INTERMISSION);
	bprint("Health:");
	bprint(ftos(parm2));
	PrintBracket(SVC_INTERMISSION, AS_STRAIGHT);
	PrintBracket(AS_SLIDING, SVC_INTERMISSION);
	bprint("Armor:");
	bprint(ftos(parm3));
	PrintBracket(SVC_INTERMISSION, AS_SLIDING);
	PrintBracket(AS_MELEE, SVC_INTERMISSION);
	if ((parm9 == 80))
	{
		bprint("Red");
	}
	else
	{
		if ((parm9 == 60))
		{
			bprint("Yellow");
		}
		else
		{
			if ((parm9 == SVC_INTERMISSION))
			{
				bprint("Green");
			}
			else
			{
				bprint("None");
			}
		}
	}
	PrintBracket(SVC_INTERMISSION, AS_MELEE);
	bprint("\n");
	PrintBracket(AS_MISSILE, SVC_INTERMISSION);
	bprint("Sh:");
	bprint(ftos(parm4));
	PrintBracket(SVC_INTERMISSION, AS_MISSILE);
	PrintBracket(TE_LIGHTNING1, SVC_INTERMISSION);
	bprint("Nl:");
	bprint(ftos(parm5));
	PrintBracket(SVC_INTERMISSION, TE_LIGHTNING1);
	PrintBracket(TE_LIGHTNING2, SVC_INTERMISSION);
	bprint("Rk:");
	bprint(ftos(parm6));
	PrintBracket(SVC_INTERMISSION, TE_LIGHTNING2);
	PrintBracket(TE_WIZSPIKE, SVC_INTERMISSION);
	bprint("Ce:");
	bprint(ftos(parm7));
	PrintBracket(SVC_INTERMISSION, TE_WIZSPIKE);
	bprint("\n 1 2");
	PrintBracket(WEAPON_BIG, SVC_INTERMISSION);
	if ((parm1 & IT_SUPER_SHOTGUN))
	{
		bprint("3");
	}
	else
	{
		bprint(" ");
	}
	PrintBracket(TE_LIGHTNING3, WEAPON_BIG);
	if ((parm1 & IT_NAILGUN))
	{
		bprint("4");
	}
	else
	{
		bprint(" ");
	}
	PrintBracket(TE_LAVASPLASH, TE_LIGHTNING3);
	if ((parm1 & IT_SUPER_NAILGUN))
	{
		bprint("5");
	}
	else
	{
		bprint(" ");
	}
	PrintBracket(TE_TELEPORT, TE_LAVASPLASH);
	if ((parm1 & IT_GRENADE_LAUNCHER))
	{
		bprint("6");
	}
	else
	{
		bprint(" ");
	}
	PrintBracket(12, TE_TELEPORT);
	if ((parm1 & IT_ROCKET_LAUNCHER))
	{
		bprint("7");
	}
	else
	{
		bprint(" ");
	}
	PrintBracket(13, 12);
	if ((parm1 & IT_LIGHTNING))
	{
		bprint("8");
	}
	else
	{
		bprint(" ");
	}
	PrintBracket(SVC_INTERMISSION, 13);
	PrintBracket(14, SVC_INTERMISSION);
	bprint("NOW");
	PrintBracket(SVC_INTERMISSION, 14);
	PrintBracket(15, SVC_INTERMISSION);
	bprint("SET");
	PrintBracket(SVC_INTERMISSION, 15);
	PrintBracket(SECRET_YES_SHOOT, SVC_INTERMISSION);
	bprint("RESET");
	PrintBracket(SVC_INTERMISSION, SECRET_YES_SHOOT);
	bprint("\n");
	PrintBracket(17, SVC_INTERMISSION);
	if ((parm8 == realnull))
	{
		bprint("ˠ             ");
	}
	else
	{
		if ((parm8 == AS_STRAIGHT))
		{
			bprint("  ˠ           ");
		}
		else
		{
			if ((parm8 == AS_SLIDING))
			{
				bprint("    ˠ         ");
			}
			else
			{
				if ((parm8 == AS_MELEE))
				{
					bprint("      ˠ       ");
				}
				else
				{
					if ((parm8 == AS_MISSILE))
					{
						bprint("        ˠ     ");
					}
					else
					{
						if ((parm8 == TE_LIGHTNING1))
						{
							bprint("          ˠ   ");
						}
						else
						{
							if ((parm8 == TE_LIGHTNING2))
							{
								bprint("            ˠ ");
							}
							else
							{
								if ((parm8 == TE_WIZSPIKE))
								{
									bprint("              ˢ);
								}
							}
						}
					}
				}
			}
		}
	}
	PrintBracket(SVC_INTERMISSION, 17);
	PrintBracket(18, SVC_INTERMISSION);
	bprint("HELP");
	PrintBracket(SVC_INTERMISSION, 18);
	PrintBracket(19, SVC_INTERMISSION);
	bprint("OFF");
	PrintBracket(SVC_INTERMISSION, 19);
	bprint("\n");
};
*/
/*
float(float number) WeaponFlag =
{
	if (!number)
	{
		return (IT_AXE);
	}
	else
	{
		if ((number == AS_STRAIGHT))
		{
			return (IT_SHOTGUN);
		}
		else
		{
			if ((number == AS_SLIDING))
			{
				return (IT_SUPER_SHOTGUN);
			}
			else
			{
				if ((number == AS_MELEE))
				{
					return (IT_NAILGUN);
				}
				else
				{
					if ((number == AS_MISSILE))
					{
						return (IT_SUPER_NAILGUN);
					}
					else
					{
						if ((number == TE_LIGHTNING1))
						{
							return (IT_GRENADE_LAUNCHER);
						}
						else
						{
							if ((number == TE_LIGHTNING2))
							{
								return (IT_ROCKET_LAUNCHER);
							}
							else
							{
								if ((number == TE_WIZSPIKE))
								{
									return (IT_LIGHTNING);
								}
							}
						}
					}
				}
			}
		}
	}
};

float(float number) AmmoForWeapon =
{
	if ((number < AS_MELEE))
	{
		return (AS_STRAIGHT);
	}
	if ((number < TE_LIGHTNING1))
	{
		return (parm5);
	}
	if ((number < TE_WIZSPIKE))
	{
		return (parm6);
	}
	return (parm7);
};

void(float flag) ChangeWeapon =
{
	if ((parm1 & flag))
	{
		parm1 = (parm1 - flag);
	}
	else
	{
		parm1 = (parm1 + flag);
	}
};

void(float delta) ChangeParm =
{
	if ((parm13 == AS_STRAIGHT))
	{
		parm2 = (parm2 + delta);
		if ((parm2 > 100))
		{
			parm2 = 100;
		}
		else
		{
			if ((parm2 < 50))
			{
				parm2 = 50;
			}
		}
	}
	else
	{
		if ((parm13 == AS_SLIDING))
		{
			parm3 = (parm3 + delta);
			if ((parm3 < realnull))
			{
				parm3 = realnull;
			}
			if ((parm3 == realnull))
			{
				parm9 = realnull;
			}
			else
			{
				if ((parm3 > 200))
				{
					parm3 = 200;
				}
			}
			if (((parm3 > realnull) && (parm9 == realnull)))
			{
				parm9 = SVC_INTERMISSION;
			}
			if (((parm3 > 100) && (parm9 == SVC_INTERMISSION)))
			{
				parm9 = 60;
			}
			if (((parm3 > 150) && (parm9 == 60)))
			{
				parm9 = 80;
			}
		}
		else
		{
			if ((parm13 == AS_MELEE))
			{
				if ((delta > realnull))
				{
					if ((parm9 == SVC_INTERMISSION))
					{
						parm9 = 60;
					}
					else
					{
						if ((parm9 == 60))
						{
							parm9 = 80;
						}
						else
						{
							parm9 = SVC_INTERMISSION;
						}
					}
				}
				else
				{
					if ((parm9 == 80))
					{
						parm9 = 60;
					}
					else
					{
						if ((parm9 == 60))
						{
							if ((parm3 < 101))
							{
								parm9 = SVC_INTERMISSION;
							}
							else
							{
								parm9 = 80;
							}
						}
						else
						{
							parm9 = 80;
						}
					}
				}
				if (((parm3 > realnull) && (parm9 == realnull)))
				{
					parm9 = SVC_INTERMISSION;
				}
				if (((parm3 > 100) && (parm9 == SVC_INTERMISSION)))
				{
					parm9 = 60;
				}
				if (((parm3 > 150) && (parm9 == 60)))
				{
					parm9 = 80;
				}
			}
			else
			{
				if ((parm13 == AS_MISSILE))
				{
					parm4 = (parm4 + delta);
					if ((parm4 > 100))
					{
						parm4 = 100;
					}
					else
					{
						if ((parm4 < 25))
						{
							parm4 = 25;
						}
					}
				}
				else
				{
					if ((parm13 == TE_LIGHTNING1))
					{
						parm5 = (parm5 + delta);
						if ((parm5 > 200))
						{
							parm5 = 200;
						}
						else
						{
							if ((parm5 < realnull))
							{
								parm5 = realnull;
							}
						}
					}
					else
					{
						if ((parm13 == TE_LIGHTNING2))
						{
							parm6 = (parm6 + delta);
							if ((parm6 > 100))
							{
								parm6 = 100;
							}
							else
							{
								if ((parm6 < realnull))
								{
									parm6 = realnull;
								}
							}
						}
						else
						{
							if ((parm13 == TE_WIZSPIKE))
							{
								parm7 = (parm7 + delta);
								if ((parm7 > 100))
								{
									parm7 = 100;
								}
								else
								{
									if ((parm7 < realnull))
									{
										parm7 = realnull;
									}
								}
							}
							else
							{
								if ((parm13 == WEAPON_BIG))
								{
									ChangeWeapon(IT_SUPER_SHOTGUN);
								}
								else
								{
									if ((parm13 == TE_LIGHTNING3))
									{
										ChangeWeapon(IT_NAILGUN);
									}
									else
									{
										if ((parm13 == TE_LAVASPLASH))
										{
											ChangeWeapon(IT_SUPER_NAILGUN);
										}
										else
										{
											if ((parm13 == TE_TELEPORT))
											{
												ChangeWeapon(IT_GRENADE_LAUNCHER);
											}
											else
											{
												if ((parm13 == 12))
												{
													ChangeWeapon(IT_ROCKET_LAUNCHER);
												}
												else
												{
													if ((parm13 == 13))
													{
														ChangeWeapon(IT_LIGHTNING);
													}
													else
													{
														if ((parm13 == 14))
														{
															parm1 = ((self.items - (self.items & 61567)) | (parm1 & 4223));
															DecodeLevelParms();
															W_SetCurrentAmmo();
															if ((parm9 == SVC_INTERMISSION))
															{
																self.items = (self.items + IT_ARMOR1);
															}
															else
															{
																if ((parm9 == 60))
																{
																	self.items = (self.items + IT_ARMOR2);
																}
																else
																{
																	if ((parm9 == 80))
																	{
																		self.items = (self.items + IT_ARMOR3);
																	}
																}
															}
														}
														else
														{
															if ((parm11 == 15))
															{
																self.cnt = self.items;
																SetChangeParms();
																self.items = self.cnt;
																if ((parm2 > 100))
																{
																	parm2 = 100;
																}
																else
																{
																	if ((parm2 < 50))
																	{
																		parm2 = 50;
																	}
																}
																if ((parm4 > 100))
																{
																	parm4 = 100;
																}
																else
																{
																	if ((parm4 < 25))
																	{
																		parm4 = 25;
																	}
																}
																if ((parm5 > 200))
																{
																	parm5 = 200;
																}
																else
																{
																	if ((parm5 < realnull))
																	{
																		parm5 = realnull;
																	}
																}
																if ((parm6 > 100))
																{
																	parm6 = 100;
																}
																else
																{
																	if ((parm6 < realnull))
																	{
																		parm6 = realnull;
																	}
																}
																if ((parm7 > 100))
																{
																	parm7 = 100;
																}
																else
																{
																	if ((parm7 < realnull))
																	{
																		parm7 = realnull;
																	}
																}
															}
															else
															{
																if ((parm13 == SECRET_YES_SHOOT))
																{
																	ResetPermParms();
																}
																else
																{
																	if ((parm13 == 17))
																	{
																		if ((delta == -10))
																		{
																			parm8 = realnull;
																		}
																		else
																		{
																			if ((delta == TE_LAVASPLASH))
																			{
																				parm8 = TE_WIZSPIKE;
																			}
																			else
																			{
																				if ((delta == CONTENT_EMPTY))
																				{
																					parm8 = (parm8 - AS_STRAIGHT);
																					if ((parm8 < realnull))
																					{
																						parm8 = TE_WIZSPIKE;
																					}
																				}
																				else
																				{
																					do
																					{
																						parm8 = (parm8 + AS_STRAIGHT);
																						if ((parm8 > TE_WIZSPIKE))
																						{
																							parm8 = realnull;
																						}

																					} while (!((parm1 & WeaponFlag(parm8)) && AmmoForWeapon(parm8)));
																				}
																			}
																		}
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	if ((!AmmoForWeapon(parm8) || !(parm1 & WeaponFlag(parm8))))
	{
		do
		{
			parm8 = (parm8 - AS_STRAIGHT);

		} while (!((parm1 & WeaponFlag(parm8)) && AmmoForWeapon(parm8)));
	}
//	PrintAllParms();
	SetPermParms();
	if ((parm13 == 18))
	{
		bprint("\nThis is the QdQ stats patch v1.8");
		bprint("\nFor instructions, see the *.txt file,");
		bprint("\nor for up to date info, consult");
		bprint("\nhttp://www.planetquake.com/qdq/stats.html\n");
	}
	else
	{
		if ((parm13 == 19))
		{
			bprint("\n\n\n\n");
			cvar_set("con_notifytime", "3");
			parm13 = realnull;
		}
	}
};

void() PreviousParm =
{
	parm13 = (parm13 - AS_STRAIGHT);
	if (((parm13 == AS_MELEE) && (!parm3 || (parm3 > 150))))
	{
		parm13 = AS_SLIDING;
	}
	if ((parm13 < realnull))
	{
		parm13 = 19;
	}
//	PrintAllParms();
};

void() NextParm =
{
	parm13 = (parm11 + AS_STRAIGHT);
	if (((parm13 == AS_MELEE) && (!parm3 || (parm3 > 150))))
	{
		parm13 = AS_MISSILE;
	}
	if ((parm13 > 19))
	{
		parm13 = realnull;
	}
//	PrintAllParms();
};

float(float val, float bit, float pos) NoCheatFlag =
{
	if (val)
	{
		if (pos)
		{
			return (realnull);
		}
		else
		{
			return (bit);
		}
	}
	else
	{
		if (pos)
		{
			return (bit);
		}
		else
		{
			return (realnull);
		}
	}
};

float(float msg) encode =
{
	local float code;
	local float two;
	local float four;
	local float eight;
	local float sixteen;
	local float n = 3937;

	two = (msg * msg);
	two = (two - (floor((two / n)) * n));
	four = (two * two);
	four = (four - (floor((four / n)) * n));
	eight = (four * four);
	eight = (eight - (floor((eight / n)) * n));
	sixteen = (eight * eight);
	sixteen = (sixteen - (floor((sixteen / n)) * n));
	code = (sixteen * two);
	code = (code - (floor((code / n)) * n));
	code = (code * msg);
	code = (code - (floor((code / n)) * n));
	return (code);
};

float(float code) print_code =
{
	local float m;

	m = (code & TE_WIZSPIKE);
	WriteByte(MSG_ALL, (48 + m));
	code = floor((code / WEAPON_BIG));
	return (code);
};

float() NoCheatBit =
{
	return (floor((random() * AS_SLIDING)));
};

void() NoCheatStamp =
{
	local float t_tens;
	local float t_units;
	local float t_tenths;
	local float tt_tens;
	local float tt_units;
	local float tt_tenths;
	local float num_tens;
	local float num_units;
	local float m;
	local float m1;
	local float m2;
	local float m3;
	local float m4;
	local float m5;
	local float i;

	msg_entity = self;
	WriteByte(MSG_ALL, TE_LIGHTNING3);
	WriteByte(MSG_ALL, 110);
	WriteByte(MSG_ALL, 101);
	WriteByte(MSG_ALL, 116);
	WriteByte(MSG_ALL, 95);
	WriteByte(MSG_ALL, 109);
	WriteByte(MSG_ALL, 101);
	WriteByte(MSG_ALL, 115);
	WriteByte(MSG_ALL, 115);
	WriteByte(MSG_ALL, 97);
	WriteByte(MSG_ALL, 103);
	WriteByte(MSG_ALL, 101);
	WriteByte(MSG_ALL, 116);
	WriteByte(MSG_ALL, 105);
	WriteByte(MSG_ALL, 109);
	WriteByte(MSG_ALL, 101);
	WriteByte(MSG_ALL, 111);
	WriteByte(MSG_ALL, 117);
	WriteByte(MSG_ALL, 116);
	WriteByte(MSG_ALL, DOOR_TOGGLE);
	t_tens = (time / TE_LAVASPLASH);
	t_tens = floor(t_tens);
	t_units = (floor(time) - (TE_LAVASPLASH * t_tens));
	t_tenths = (TE_LAVASPLASH * (time - floor(time)));
	t_tenths = floor(t_tenths);
	t_tens = (t_tens / TE_LAVASPLASH);
	t_tens = ((t_tens - floor(t_tens)) * TE_LAVASPLASH);
	t_tens = floor((t_tens + 0.1));
	tt_tens = (totaltime / TE_LAVASPLASH);
	tt_tens = floor(tt_tens);
	tt_units = (floor(totaltime) - (TE_LAVASPLASH * tt_tens));
	tt_tenths = (TE_LAVASPLASH * (totaltime - floor(totaltime)));
	tt_tenths = floor(tt_tenths);
	tt_tens = (tt_tens / TE_LAVASPLASH);
	tt_tens = ((tt_tens - floor(tt_tens)) * TE_LAVASPLASH);
	tt_tens = floor((tt_tens + 0.1));
	num_tens = (numlevels / TE_LAVASPLASH);
	num_tens = floor(num_tens);
	num_units = (floor(numlevels) - (TE_LAVASPLASH * num_tens));
	while ((num_tens > TE_LIGHTNING3))
	{
		num_tens = (num_tens - TE_LAVASPLASH);
	}
	m = (t_tens + (tt_tenths * TE_LAVASPLASH));
	m = (((m & 15) * AS_SLIDING) + ((m & 112) * WEAPON_BIG));
	m = (m + NoCheatFlag(NoCheatBit(), AS_STRAIGHT, realnull));
	m = (m + NoCheatFlag((parm10 & AS_MISSILE), DOOR_TOGGLE, AS_STRAIGHT));
	m = (m + NoCheatFlag((parm10 & IT_NAILS), IT_LIGHTNING, realnull));
	m = (m + NoCheatFlag(NoCheatBit(), IT_ROCKETS, realnull));
	m1 = encode(m);
	m = (num_tens + (t_units * TE_LAVASPLASH));
	m = (m + NoCheatFlag(NoCheatBit(), FL_NOTARGET, realnull));
	m = (m + NoCheatFlag((parm10 & IT_ARMOR2), IT_SHELLS, realnull));
	m = (m + NoCheatFlag(NoCheatBit(), IT_NAILS, realnull));
	m = (m + NoCheatFlag((parm10 & SECRET_YES_SHOOT), IT_ROCKETS, AS_STRAIGHT));
	m2 = encode(m);
	m = (t_tenths + (num_units * TE_LAVASPLASH));
	m = ((m & 15) + ((m & 112) * SECRET_YES_SHOOT));
	m = (m + NoCheatFlag((parm10 & IT_LIGHTNING), SECRET_YES_SHOOT, AS_STRAIGHT));
	m = (m + NoCheatFlag(NoCheatBit(), DOOR_TOGGLE, realnull));
	m = (m + NoCheatFlag(NoCheatBit(), IT_LIGHTNING, realnull));
	m = (m + NoCheatFlag((parm10 & IT_CELLS), FL_NOTARGET, realnull));
	m3 = encode(m);
	m = (tt_tens * SECRET_YES_SHOOT);
	m = (m + ((parm10 & AS_MELEE) * IT_SHELLS));
	m = (m + NoCheatFlag((parm10 & IT_ARMOR1), AS_STRAIGHT, realnull));
	m = (m + NoCheatFlag(NoCheatBit(), AS_SLIDING, realnull));
	m = (m + NoCheatFlag((parm10 & IT_ROCKETS), AS_MISSILE, AS_STRAIGHT));
	m = (m + NoCheatFlag((parm10 & IT_AXE), WEAPON_BIG, realnull));
	m = (m + NoCheatFlag(NoCheatBit(), IT_ROCKETS, realnull));
	m4 = encode(m);
	m = (tt_units * SECRET_YES_SHOOT);
	m = (m + NoCheatFlag((parm10 & IT_SHELLS), AS_STRAIGHT, AS_STRAIGHT));
	m = (m + NoCheatFlag(NoCheatBit(), AS_SLIDING, realnull));
	m = (m + NoCheatFlag(NoCheatBit(), AS_MISSILE, realnull));
	m = (m + NoCheatFlag((parm10 & WEAPON_BIG), WEAPON_BIG, realnull));
	m = (m + NoCheatFlag((parm10 & FL_NOTARGET), IT_SHELLS, AS_STRAIGHT));
	m = (m + NoCheatFlag(NoCheatBit(), IT_NAILS, realnull));
	m = (m + NoCheatFlag((parm10 & DOOR_TOGGLE), IT_ROCKETS, realnull));
	m5 = encode(m);
	i = realnull;
	do
	{
		m1 = print_code(m1);
		m2 = print_code(m2);
		m3 = print_code(m3);
		m4 = print_code(m4);
		m5 = print_code(m5);
		i = (i + AS_STRAIGHT);

	} while ((i != AS_MISSILE));
	WriteByte(MSG_ALL, TE_LAVASPLASH);
	WriteByte(MSG_ALL, realnull);
};
*/

void(float tt) PrintTime =
{
	local float t;
	local float p;

	t = (tt / 60);
	t = floor(t);
	if ((t > 999))
	{
		bprint("too damn high!");
	}
	else
	{
		if (t)
		{
			bprint(ftos(t));
			bprint(":");
			t = (tt - (60 * t));
			t = floor(t);
			if ((t < TE_LAVASPLASH))
			{
				bprint("0");
			}
		}
		else
		{
			t = floor(tt);
		}
		bprint(ftos(t));
		bprint(".");
		p = TE_LAVASPLASH;
		do
		{
			t = (p * (tt - floor(tt)));
			t = floor(t);
			t = (t / TE_LAVASPLASH);
			t = ((t - floor(t)) * TE_LAVASPLASH);
			t = floor((t + 0.1));
			bprint(ftos(t));
			p = (TE_LAVASPLASH * p);

		} while ((p < 100001));
	}
};

void() OCD_Mapname_Prints =
{
	// iD1 Start Map
	if (mapname == "start")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");
		bprint("Map(Start) : ");
		bprint("Introduction");
		bprint("\n");
		bprint("Map Author : ");
		bprint("John Romero");
	}	
	// Hipnotic Start Map
	if (mapname == "hipstart")
	{
		bprint("Game       : ");
		bprint("Hipnotic");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #1: Scourge of Armagon");
		bprint("\n");		
		bprint("Map(Start) : ");
		bprint("Command HQ");
		bprint("\n");
		bprint("Map Author : ");
		bprint("Hipnotic Software");
	}
	// Rogue Start Map
	if (mapname == "rstart")
	{
		bprint("Game       : ");
		bprint("Rogue");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #2: Dissolution Of Eternity");
		bprint("\n");			
		bprint("Map(Start) : ");
		bprint("Introduction");
		bprint("\n");
		bprint("Map Author : ");
		bprint("Rogue Entertainment");
	}
	// DOPA Start Map
	if (mapname == "e5start")
	{
		bprint("Game       : ");
		bprint("DOPA");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #3: Dimension Of The Past");
		bprint("\n");			
		bprint("Map(Start) : ");
		bprint("Dimension of the Past");
		bprint("\n");
		bprint("Map Author : ");
		bprint("Machine Games");
	}
	// MG1 Start Map
	if (mapname == "mgstart")
	{
		bprint("Game       : ");
		bprint("MG1");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #4: Dimension Of The Machine");
		bprint("\n");			
		bprint("Map(Start) : ");
		bprint("The Gateway");
		bprint("\n");
		bprint("Map Author : ");
		bprint("Machine Games");
	}
	// MG1 Hub Map
	if (mapname == "hub")
	{
		bprint("Game       : ");
		bprint("MG1");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #4: Dimension Of The Machine");
		bprint("\n");			
		bprint("Map(Hub)   : ");
		bprint("The Machine");
		bprint("\n");
		bprint("Map Author : ");
		bprint("Machine Games");
	}					
	
	// iD1 Episode 1
	if (mapname == "e1m1")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(1) : ");
		bprint("Dimension Of The Doomed");
		bprint("\n");
		bprint("Map(E1M1)  : ");
		bprint("The Slipgate Complex");
		bprint("\n");
		bprint("Map Author : ");
		bprint("John Romero");		
	}
	if (mapname == "e1m2")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(1) : ");
		bprint("Dimension Of The Doomed");
		bprint("\n");
		bprint("Map(E1M2)  : ");
		bprint("Castle Of The Damned");
		bprint("\n");
		bprint("Map Author : ");
		bprint("Tim Willits");		
	}
	if (mapname == "e1m3")	
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(1) : ");
		bprint("Dimension Of The Doomed");
		bprint("\n");		
		bprint("Map(E1M3)  : ");
		bprint("The Necropolis");
		bprint("\n");
		bprint("Map Author : ");
		bprint("Tim Willits");			
	}
	if (mapname == "e1m4")	
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(1) : ");
		bprint("Dimension Of The Doomed");	
		bprint("\n");	
		bprint("Map(E1M4)  : ");
		bprint("The Grizzly Grotto");
		bprint("\n");
		bprint("Map Author : ");
		bprint("Tim Willits");			
	}
	if (mapname == "e1m5")	
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");			
		bprint("Episode(1) : ");
		bprint("Dimension Of The Doomed");
		bprint("\n");		
		bprint("Map(E1M5)  : ");
		bprint("Gloom Keep");
		bprint("\n");
		bprint("Map Author : ");
		bprint("Tim Willits");			
	}
	if (mapname == "e1m6")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(1) : ");
		bprint("Dimension Of The Doomed");	
		bprint("\n");	
		bprint("Map(E1M6)  : ");
		bprint("The Door to Chthon");	
		bprint("\n");
		bprint("Map Author : ");
		bprint("American McGee");			
	}
	if (mapname == "e1m7")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(1) : ");
		bprint("Dimension Of The Doomed");	
		bprint("\n");	
		bprint("Map(E1M7)  : ");	
		bprint("The House Of Chthon");
		bprint("\n");
		bprint("Map Author : ");
		bprint("American McGee");		
	}
	if (mapname == "e1m8")	
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(1) : ");
		bprint("Dimension Of The Doomed");
		bprint("\n");			
		bprint("Map(E1M8)  : ");
		bprint("Ziggurat Vertigo");
		bprint("\n");
		bprint("Map Author : ");
		bprint("American McGee");		
	}
	
	// iD1 Episode 2
	if (mapname == "e2m1")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(2) : ");
		bprint("The Realm Of Black Magic");
		bprint("\n");		
		bprint("Map(E2M1)  : ");
		bprint("The Installation");
		bprint("\n");
		bprint("Map Author : ");
		bprint("John Romero");		
	}
	if (mapname == "e2m2")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(2) : ");
		bprint("The Realm Of Black Magic");
		bprint("\n");		
		bprint("Map(E2M2)  : ");
		bprint("The Ogre Citadel");
		bprint("\n");
		bprint("Map Author : ");
		bprint("John Romero");			
	}
	if (mapname == "e2m3")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(2) : ");
		bprint("The Realm Of Black Magic");	
		bprint("\n");	
		bprint("Map(E2M3)  : ");
		bprint("The Crypt of Decay");
		bprint("\n");
		bprint("Map Author : ");
		bprint("John Romero");		
	}
	if (mapname == "e2m4")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(2) : ");
		bprint("The Realm Of Black Magic");	
		bprint("\n");	
		bprint("Map(E2M4)  : ");
		bprint("The Ebon Fortress");
		bprint("\n");
		bprint("Map Author : ");
		bprint("John Romero");			
	}	
	if (mapname == "e2m5")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(2) : ");
		bprint("The Realm Of Black Magic");	
		bprint("\n");	
		bprint("Map(E2M5)  : ");
		bprint("The Wizard's Manse");
		bprint("\n");
		bprint("Map Author : ");
		bprint("John Romero");			
	}
	if (mapname == "e2m6")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(2) : ");
		bprint("The Realm Of Black Magic");
		bprint("\n");		
		bprint("Map(E2M6)  : ");
		bprint("The Dismal Oubliette");	
		bprint("\n");
		bprint("Map Author : ");
		bprint("John Romero");		
	}
	if (mapname == "e2m6_qe")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(2) : ");
		bprint("The Realm Of Black Magic");
		bprint("\n");		
		bprint("Map(E2M6)  : ");
		bprint("The Dismal Oubliette");	
		bprint("\n");
		bprint("Map Author : ");
		bprint("John Romero");		
	}	
	if (mapname == "e2m7")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(2) : ");
		bprint("The Realm Of Black Magic");
		bprint("\n");		
		bprint("Map(E2M7)  : ");
		bprint("The Underearth");
		bprint("\n");
		bprint("Map Author : ");
		bprint("Tim Willits");				
	}
	
	// iD1 Episode 3
	if (mapname == "e3m1")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(3) : ");
		bprint("The Netherworld");
		bprint("\n");		
		bprint("Map(E3M1)  : ");
		bprint("Termination Central");	
		bprint("\n");
		bprint("Map Author : ");
		bprint("John Romero");		
	}
	if (mapname == "e3m2")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(3) : ");
		bprint("The Netherworld");	
		bprint("\n");	
		bprint("Map(E3M2)  : ");
		bprint("Vaults of Zin");
		bprint("\n");
		bprint("Map Author : ");
		bprint("American McGee");	
	}
	if (mapname == "e3m3")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(3) : ");
		bprint("The Netherworld");
		bprint("\n");		
		bprint("Map(E3M3)  : ");
		bprint("The Tomb of Terror");
		bprint("\n");
		bprint("Map Author : ");
		bprint("American McGee");			
	}
	if (mapname == "e3m4")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(3) : ");
		bprint("The Netherworld");
		bprint("\n");		
		bprint("Map(E3M4)  : ");
		bprint("Satan's Dark Delight");
		bprint("\n");
		bprint("Map Author : ");
		bprint("American McGee");		
	}
	if (mapname == "e3m5")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(3) : ");
		bprint("The Netherworld");	
		bprint("\n");	
		bprint("Map(E3M5)  : ");
		bprint("Wind Tunnels");
		bprint("Map Author : ");
		bprint("Tim Willits");		
	}
	if (mapname == "e3m6")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(3) : ");
		bprint("The Netherworld");
		bprint("\n");		
		bprint("Map(E3M6)  : ");
		bprint("Chambers of Torment");	
		bprint("\n");		
		bprint("Map Author : ");
		bprint("American McGee & Tim Willits");		
	}
	if (mapname == "e3m7")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(3) : ");
		bprint("The Netherworld");
		bprint("\n");		
		bprint("Map(E3M7)  : ");
		bprint("The Haunted Halls");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("American McGee");		
	}
	
	// iD1 Episode 4
	if (mapname == "e4m1")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(4) : ");
		bprint("The Elder World");
		bprint("\n");		
		bprint("Map(E4M1)  : ");
		bprint("The Sewage System");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Tim Willits");			
	}
	if (mapname == "e4m2")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(4) : ");
		bprint("The Elder World");
		bprint("\n");		
		bprint("Map(E4M2)  : ");
		bprint("The Tower of Despair");	
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Sandy Petersen");		
	}
	if (mapname == "e4m3")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(4) : ");
		bprint("The Elder World");
		bprint("\n");		
		bprint("Map(E4M3)  : ");
		bprint("The Elder God Shrine");	
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Sandy Petersen");		
	}
	if (mapname == "e4m4")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(4) : ");
		bprint("The Elder World");
		bprint("\n");		
		bprint("Map(E4M4)  : ");
		bprint("The Palace of Hate");	
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Sandy Petersen");		
	}
	if (mapname == "e4m5")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(4) : ");
		bprint("The Elder World");	
		bprint("\n");	
		bprint("Map(E4M5)  : ");
		bprint("Hell's Atrium");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Sandy Petersen");			
	}
	if (mapname == "e4m6")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(4) : ");
		bprint("The Elder World");
		bprint("\n");		
		bprint("Map(E4M6)  : ");
		bprint("The Pain Maze");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Sandy Petersen");		
	}
	if (mapname == "e4m7")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(4) : ");
		bprint("The Elder World");
		bprint("\n");		
		bprint("Map(E4M7)  : ");
		bprint("Azure Agony");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Sandy Petersen");		
	}
	if (mapname == "e4m8")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Episode(4) : ");
		bprint("The Elder World");	
		bprint("\n");	
		bprint("Map(E4M8)  : ");
		bprint("The Nameless City");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Sandy Petersen");			
	}
	
	// Hipnotic Episode 1
	if (mapname == "hip1m1")
	{
		bprint("Game       : ");
		bprint("Hipnotic");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #1: Scourge of Armagon");
		bprint("\n");				
		bprint("Episode(1) : ");
		bprint("Fortress of the Dead");	
		bprint("\n");	
		bprint("Map(HIP1M1): ");
		bprint("The Pumping Station");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Hipnotic Software");			
	}
	if (mapname == "hip1m2")
	{
		bprint("Game       : ");
		bprint("Hipnotic");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #1: Scourge of Armagon");
		bprint("\n");				
		bprint("Episode(1) : ");
		bprint("Fortress of the Dead");	
		bprint("\n");	
		bprint("Map(HIP1M2): ");
		bprint("Storage Facility");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Hipnotic Software");			
	}
	if (mapname == "hip1m3")
	{
		bprint("Game       : ");
		bprint("Hipnotic");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #1: Scourge of Armagon");
		bprint("\n");				
		bprint("Episode(1) : ");
		bprint("Fortress of the Dead");	
		bprint("\n");	
		bprint("Map(HIP1M3): ");
		bprint("The Lost Mine");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Hipnotic Software");			
	}
	if (mapname == "hip1m4")
	{
		bprint("Game       : ");
		bprint("Hipnotic");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #1: Scourge of Armagon");
		bprint("\n");				
		bprint("Episode(1) : ");
		bprint("Fortress of the Dead");	
		bprint("\n");	
		bprint("Map(HIP1M4): ");
		bprint("Research Facility");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Hipnotic Software");			
	}
	if (mapname == "hip1m5")
	{
		bprint("Game       : ");
		bprint("Hipnotic");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #1: Scourge of Armagon");
		bprint("\n");				
		bprint("Episode(1) : ");
		bprint("Fortress of the Dead");	
		bprint("\n");	
		bprint("Map(HIP1M5): ");
		bprint("Military Complex");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Hipnotic Software");			
	}
	
	// Hipnotic Episode 2
	if (mapname == "hip2m1")
	{
		bprint("Game       : ");
		bprint("Hipnotic");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #1: Scourge of Armagon");
		bprint("\n");				
		bprint("Episode(2) : ");
		bprint("Dominion of Darkness");	
		bprint("\n");	
		bprint("Map(HIP2M1): ");
		bprint("Ancient Realms");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Hipnotic Software");			
	}
	if (mapname == "hip2m2")
	{
		bprint("Game       : ");
		bprint("Hipnotic");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #1: Scourge of Armagon");
		bprint("\n");				
		bprint("Episode(2) : ");
		bprint("Dominion of Darkness");	
		bprint("\n");	
		bprint("Map(HIP2M2): ");
		bprint("The Black Cathedral");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Hipnotic Software");			
	}
	if (mapname == "hip2m3")
	{
		bprint("Game       : ");
		bprint("Hipnotic");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #1: Scourge of Armagon");
		bprint("\n");				
		bprint("Episode(2) : ");
		bprint("Dominion of Darkness");	
		bprint("\n");	
		bprint("Map(HIP2M3): ");
		bprint("The Catacombs");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Hipnotic Software");			
	}
	if (mapname == "hip2m4")
	{
		bprint("Game       : ");
		bprint("Hipnotic");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #1: Scourge of Armagon");
		bprint("\n");				
		bprint("Episode(2) : ");
		bprint("Dominion of Darkness");	
		bprint("\n");	
		bprint("Map(HIP2M4): ");
		bprint("The Crypt");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Hipnotic Software");			
	}
	if (mapname == "hip2m5")
	{
		bprint("Game       : ");
		bprint("Hipnotic");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #1: Scourge of Armagon");
		bprint("\n");				
		bprint("Episode(2) : ");
		bprint("Dominion of Darkness");	
		bprint("\n");	
		bprint("Map(HIP2M5): ");
		bprint("Mortum's Keep");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Hipnotic Software");			
	}
	if (mapname == "hip2m6")
	{
		bprint("Game       : ");
		bprint("Hipnotic");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #1: Scourge of Armagon");
		bprint("\n");				
		bprint("Episode(2) : ");
		bprint("Dominion of Darkness");	
		bprint("\n");	
		bprint("Map(HIP2M6): ");
		bprint("The Gremlin's Domain");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Hipnotic Software");			
	}
	
	// Hipnotic Episode 3
	if (mapname == "hip3m1")
	{
		bprint("Game       : ");
		bprint("Hipnotic");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #1: Scourge of Armagon");
		bprint("\n");				
		bprint("Episode(3) : ");
		bprint("The Rift");	
		bprint("\n");	
		bprint("Map(HIP3M1): ");
		bprint("Tur Torment");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Hipnotic Software");			
	}
	if (mapname == "hip3m2")
	{
		bprint("Game       : ");
		bprint("Hipnotic");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #1: Scourge of Armagon");
		bprint("\n");				
		bprint("Episode(3) : ");
		bprint("The Rift");	
		bprint("\n");	
		bprint("Map(HIP3M2): ");
		bprint("Pandemonium");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Hipnotic Software");			
	}
	if (mapname == "hip3m3")
	{
		bprint("Game       : ");
		bprint("Hipnotic");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #1: Scourge of Armagon");
		bprint("\n");				
		bprint("Episode(3) : ");
		bprint("The Rift");	
		bprint("\n");	
		bprint("Map(HIP3M3): ");
		bprint("Limbo");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Hipnotic Software");			
	}
	if (mapname == "hip3m4")
	{
		bprint("Game       : ");
		bprint("Hipnotic");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #1: Scourge of Armagon");
		bprint("\n");				
		bprint("Episode(3) : ");
		bprint("The Rift");	
		bprint("\n");	
		bprint("Map(HIP3M4): ");
		bprint("Tur Torment");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Hipnotic Software");			
	}
	if (mapname == "hip3m5")
	{
		bprint("Game       : ");
		bprint("Hipnotic");
		bprint("\n");	
		bprint("Expansion  : ");
		bprint("Mission Pack #1: Scourge of Armagon");
		bprint("\n");			
		bprint("Episode(3) : ");
		bprint("The Rift");	
		bprint("\n");	
		bprint("Map(HIP3M5): ");
		bprint("The Gauntlet");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Hipnotic Software");			
	}
	
	// Rogue Episode 1
	if (mapname == "r1m1")
	{
		bprint("Game       : ");
		bprint("Rogue");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #2: Dissolution Of Eternity");
		bprint("\n");					
		bprint("Episode(1) : ");
		bprint("Hell's Fortress");	
		bprint("\n");	
		bprint("Map(R1M1)  : ");
		bprint("Deviant's Domain");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Rogue Entertainment");			
	}
	if (mapname == "r1m2")
	{
		bprint("Game       : ");
		bprint("Rogue");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #2: Dissolution Of Eternity");
		bprint("\n");					
		bprint("Episode(1) : ");
		bprint("Hell's Fortress");	
		bprint("\n");	
		bprint("Map(R1M2)  : ");
		bprint("Dread Portal");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Rogue Entertainment");			
	}
	if (mapname == "r1m3")
	{
		bprint("Game       : ");
		bprint("Rogue");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #2: Dissolution Of Eternity");
		bprint("\n");					
		bprint("Episode(1) : ");
		bprint("Hell's Fortress");	
		bprint("\n");	
		bprint("Map(R1M3)  : ");
		bprint("Judgment Call");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Rogue Entertainment");			
	}
	if (mapname == "r1m4")
	{
		bprint("Game       : ");
		bprint("Rogue");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #2: Dissolution Of Eternity");
		bprint("\n");					
		bprint("Episode(1) : ");
		bprint("Hell's Fortress");	
		bprint("\n");	
		bprint("Map(R1M4)  : ");
		bprint("Cave of Death");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Rogue Entertainment");			
	}
	if (mapname == "r1m5")
	{
		bprint("Game       : ");
		bprint("Rogue");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #2: Dissolution Of Eternity");
		bprint("\n");					
		bprint("Episode(1) : ");
		bprint("Hell's Fortress");	
		bprint("\n");	
		bprint("Map(R1M5)  : ");
		bprint("Towers of Wrath");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Rogue Entertainment");			
	}
	if (mapname == "r1m6")
	{
		bprint("Game       : ");
		bprint("Rogue");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #2: Dissolution Of Eternity");
		bprint("\n");					
		bprint("Episode(1) : ");
		bprint("Hell's Fortress");	
		bprint("\n");	
		bprint("Map(R1M6)  : ");
		bprint("Temple of Pain");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Rogue Entertainment");			
	}
	if (mapname == "r1m7")
	{
		bprint("Game       : ");
		bprint("Rogue");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #2: Dissolution Of Eternity");
		bprint("\n");					
		bprint("Episode(1) : ");
		bprint("Hell's Fortress");	
		bprint("\n");	
		bprint("Map(R1M7)  : ");
		bprint("Tomb of the Overlord");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Rogue Entertainment");			
	}
	// Rogue Episode 2
	if (mapname == "r2m1")
	{
		bprint("Game       : ");
		bprint("Rogue");
		bprint("\n");	
		bprint("Expansion  : ");
		bprint("Mission Pack #2: Dissolution Of Eternity");
		bprint("\n");				
		bprint("Episode(2) : ");
		bprint("The Corridors of Time");	
		bprint("\n");	
		bprint("Map(R2M1)  : ");
		bprint("Tempus Fugit");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Rogue Entertainment");			
	}
	if (mapname == "r2m2")
	{
		bprint("Game       : ");
		bprint("Rogue");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #2: Dissolution Of Eternity");
		bprint("\n");					
		bprint("Episode(2) : ");
		bprint("The Corridors of Time");	
		bprint("\n");	
		bprint("Map(R2M2)  : ");
		bprint("Elemental Fury I");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Rogue Entertainment");			
	}
	if (mapname == "r2m3")
	{
		bprint("Game       : ");
		bprint("Rogue");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #2: Dissolution Of Eternity");
		bprint("\n");					
		bprint("Episode(2) : ");
		bprint("The Corridors of Time");	
		bprint("\n");	
		bprint("Map(R2M2)  : ");
		bprint("Elemental Fury II");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Rogue Entertainment");			
	}
	if (mapname == "r2m4")
	{
		bprint("Game       : ");
		bprint("Rogue");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #2: Dissolution Of Eternity");
		bprint("\n");					
		bprint("Episode(2) : ");
		bprint("The Corridors of Time");	
		bprint("\n");	
		bprint("Map(R2M3)  : ");
		bprint("Curse of Osiris");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Rogue");			
	}
	if (mapname == "r2m5")
	{
		bprint("Game       : ");
		bprint("Rogue");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #2: Dissolution Of Eternity");
		bprint("\n");					
		bprint("Episode(2) : ");
		bprint("The Corridors of Time");	
		bprint("\n");	
		bprint("Map(R2M4)  : ");
		bprint("Wizard's Keep");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Rogue Entertainment");			
	}
	if (mapname == "r2m6")
	{
		bprint("Game       : ");
		bprint("Rogue");
		bprint("\n");	
		bprint("Expansion  : ");
		bprint("Mission Pack #2: Dissolution Of Eternity");
		bprint("\n");				
		bprint("Episode(2) : ");
		bprint("The Corridors of Time");	
		bprint("\n");	
		bprint("Map(R2M5)  : ");
		bprint("Blood Sacrifice");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Rogue Entertainment");			
	}
	if (mapname == "r2m7")
	{
		bprint("Game       : ");
		bprint("Rogue");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #2: Dissolution Of Eternity");
		bprint("\n");					
		bprint("Episode(2) : ");
		bprint("The Corridors of Time");	
		bprint("\n");	
		bprint("Map(R2M7)  : ");
		bprint("Last Bastion");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Rogue Entertainment");			
	}
	
	// DOPA Episode 5
	if (mapname == "e5m1")	
	{
		bprint("Game       : ");
		bprint("DOPA");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #3: Dimension Of The Past");
		bprint("\n");					
		bprint("Episode(5) : ");
		bprint("Dimension Of The Past");	
		bprint("\n");	
		bprint("Map(E5M1)  : ");
		bprint("The Military Base");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Machine Games");			
	}
	if (mapname == "e5m2")	
	{
		bprint("Game       : ");
		bprint("DOPA");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #3: Dimension Of The Past");
		bprint("\n");					
		bprint("Episode(5) : ");
		bprint("Dimension Of The Past");	
		bprint("\n");	
		bprint("Map(E5M2)  : ");
		bprint("The Power Supply");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Machine Games");			
	}
	if (mapname == "e5m3")	
	{
		bprint("Game       : ");
		bprint("DOPA");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #3: Dimension Of The Past");
		bprint("\n");					
		bprint("Episode(5) : ");
		bprint("Dimension Of The Past");	
		bprint("\n");	
		bprint("Map(E5M3)  : ");
		bprint("The Dark Days");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Machine Games");			
	}
	if (mapname == "e5m4")	
	{
		bprint("Game       : ");
		bprint("DOPA");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #3: Dimension Of The Past");
		bprint("\n");					
		bprint("Episode(5) : ");
		bprint("Dimension Of The Past");	
		bprint("\n");	
		bprint("Map(E5M4)  : ");
		bprint("The Catacombs");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Machine Games");			
	}
	if (mapname == "e5m5")	
	{
		bprint("Game       : ");
		bprint("DOPA");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #3: Dimension Of The Past");
		bprint("\n");					
		bprint("Episode(5) : ");
		bprint("Dimension Of The Past");	
		bprint("\n");	
		bprint("Map(E5M5)  : ");
		bprint("The Stronghold");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Machine Games");			
	}
	if (mapname == "e5m6")	
	{
		bprint("Game       : ");
		bprint("DOPA");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #3: Dimension Of The Past");
		bprint("\n");					
		bprint("Episode(5) : ");
		bprint("Dimension Of The Past");	
		bprint("\n");	
		bprint("Map(E5M6)  : ");
		bprint("The Underworld");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Machine Games");			
	}
	if (mapname == "e5m7")	
	{
		bprint("Game       : ");
		bprint("DOPA");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #3: Dimension Of The Past");
		bprint("\n");					
		bprint("Episode(5) : ");
		bprint("Dimension Of The Past");	
		bprint("\n");	
		bprint("Map(E5M7)  : ");
		bprint("The Otherworld");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Machine Games");			
	}
	if (mapname == "e5sm1")	
	{
		bprint("Game       : ");
		bprint("DOPA");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #3: Dimension Of The Past");
		bprint("\n");					
		bprint("Episode(5) : ");
		bprint("Dimension Of The Past");	
		bprint("\n");	
		bprint("Map(E5SM1) : ");
		bprint("The Forgotten Castle");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Machine Games");			
	}
	if (mapname == "e5sm2")	
	{
		bprint("Game       : ");
		bprint("DOPA");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #3: Dimension Of The Past");
		bprint("\n");					
		bprint("Episode(5) : ");
		bprint("Dimension Of The Past");	
		bprint("\n");	
		bprint("Map(E5SM2) : ");
		bprint("The House Of Doom");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Machine Games");			
	}
	
	// MG1 Episode 1 
	if (mapname == "mge1m1")	
	{
		bprint("Game       : ");
		bprint("MG1");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #4: Dimension Of The Machine");
		bprint("\n");					
		bprint("Episode(1) : ");
		bprint("The Realm Of Machinists");	
		bprint("\n");	
		bprint("Map(MGE1M1): ");
		bprint("The Pain Drain");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Machine Games");			
	}
	if (mapname == "mge1m2")	
	{
		bprint("Game       : ");
		bprint("MG1");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #4: Dimension Of The Machine");
		bprint("\n");					
		bprint("Episode(1) : ");
		bprint("The Realm Of Machinists");	
		bprint("\n");	
		bprint("Map(MGE1M2): ");
		bprint("The Wishing Well");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Machine Games");			
	}
	if (mapname == "mge1m3")	
	{
		bprint("Game       : ");
		bprint("MG1");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #4: Dimension Of The Machine");
		bprint("\n");					
		bprint("Episode(1) : ");
		bprint("The Realm Of Machinists");	
		bprint("\n");	
		bprint("Map(MGE1M3): ");
		bprint("Sandy's Room");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Machine Games");			
	}
	// MG1 Episode 2
	if (mapname == "mge2m1")	
	{
		bprint("Game       : ");
		bprint("MG1");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #4: Dimension Of The Machine");
		bprint("\n");					
		bprint("Episode(2) : ");
		bprint("The Realm Of Blacksmiths");	
		bprint("\n");	
		bprint("Map(MGE2M1): ");
		bprint("Acid Sancturay");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Machine Games");			
	}
	if (mapname == "mge2m2")	
	{
		bprint("Game       : ");
		bprint("MG1");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #4: Dimension Of The Machine");
		bprint("\n");					
		bprint("Episode(2) : ");
		bprint("The Realm Of Blacksmiths");	
		bprint("\n");	
		bprint("Map(MGE2M1): ");
		bprint("Fading Embers");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Machine Games");			
	}
	// MG1 Episode 3
	if (mapname == "mge3m1")	
	{
		bprint("Game       : ");
		bprint("MG1");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #4: Dimension Of The Machine");
		bprint("\n");					
		bprint("Episode(3) : ");
		bprint("The Realm Of Stonemasons");	
		bprint("\n");	
		bprint("Map(MGE3M1): ");
		bprint("Down the Waste");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Machine Games");			
	}
	if (mapname == "mge3m2")	
	{
		bprint("Game       : ");
		bprint("MG1");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #4: Dimension Of The Machine");
		bprint("\n");					
		bprint("Episode(3) : ");
		bprint("The Realm Of Stonemasons");	
		bprint("\n");	
		bprint("Map(MGE3M2): ");
		bprint("Hell or Dark Water");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Machine Games");			
	}
	// MG1 Episode 4
	if (mapname == "mge4m1")	
	{
		bprint("Game       : ");
		bprint("MG1");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #4: Dimension Of The Machine");
		bprint("\n");					
		bprint("Episode(4) : ");
		bprint("The Realm Of Cultists");	
		bprint("\n");	
		bprint("Map(MGE4M1): ");
		bprint("Grave Machine");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Machine Games");			
	}
	if (mapname == "mge4m2")	
	{
		bprint("Game       : ");
		bprint("MG1");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #4: Dimension Of The Machine");
		bprint("\n");					
		bprint("Episode(4) : ");
		bprint("The Realm Of Cultists");	
		bprint("\n");	
		bprint("Map(MGE4M2): ");
		bprint("A Grave Mistake");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Machine Games");			
	}
	// MG1 Episode 5
	if (mapname == "mge5m1")	
	{
		bprint("Game       : ");
		bprint("MG1");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #4: Dimension Of The Machine");
		bprint("\n");					
		bprint("Episode(5) : ");
		bprint("The Realm Of Astrologers");	
		bprint("\n");	
		bprint("Map(MGE5M1): ");
		bprint("Nazard Terminal");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Machine Games");			
	}
	if (mapname == "mge5m2")	
	{
		bprint("Game       : ");
		bprint("MG1");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #4: Dimension Of The Machine");
		bprint("\n");					
		bprint("Episode(5) : ");
		bprint("The Realm Of Astrologers");	
		bprint("\n");	
		bprint("Map(MGE5M1): ");
		bprint("Too Deep, Too Greedy");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Machine Games");			
	}																																																		
	
	// iD1 End Map
	if (mapname == "end")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Map(END)   : ");
		bprint("Shub Niggurath's Pit");
		bprint("\n");
		bprint("Map Author : ");
		bprint("John Romero");		
	}
	// Hipnotic End Map
	if (mapname == "hipend")
	{
		bprint("Game       : ");
		bprint("Hipnotic");
		bprint("\n");	
		bprint("Expansion  : ");
		bprint("Mission Pack #1: Scourge of Armagon");
		bprint("\n");				
		bprint("Episode(3) : ");
		bprint("The Rift");	
		bprint("\n");	
		bprint("Map(HIPEND): ");
		bprint("HIPEND: Armagon's Lair");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Hipnotic Software");			
	}
	// Rogue End Map
	if (mapname == "rend") // Renamed from R2M8
	{
		bprint("Game       : ");
		bprint("Rogue");
		bprint("\n");	
		bprint("Expansion  : ");
		bprint("Mission Pack #2: Dissolution Of Eternity");
		bprint("\n");	
		bprint("Episode(2) : ");
		bprint("The Corridors of Time");	
		bprint("\n");	
		bprint("Map(R2M8)  : ");
		bprint("Source of Evil");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Rogue Entertainment");			
	}
	// DOPA End Map
	if (mapname == "e5end")
	{
		bprint("Game       : ");
		bprint("DOPA");
		bprint("\n");	
		bprint("Expansion  : ");
		bprint("Mission Pack #3: Dimension Of The Past");
		bprint("\n");	
		bprint("Episode(5) : ");
		bprint("Dimension Of The Past");	
		bprint("\n");	
		bprint("Map(E5END)  : ");
		bprint("The Year Zero");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Machine Games");			
	}
	// MG1 End Map
	if (mapname == "mgend")
	{
		bprint("Game       : ");
		bprint("MG1");
		bprint("\n");	
		bprint("Expansion  : ");
		bprint("Mission Pack #4: Dimension Of The Machine");
		bprint("\n");	
		bprint("Episode(5) : ");
		bprint("Dimension Of The Machine");	
		bprint("\n");	
		bprint("Map(MGEND)  : ");
		bprint("Chthon's Vengeance");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Machine Games");			
	}					
	
	// Hipnotic Deathmatch Map
	if (mapname == "hipdm1")
	{
		bprint("Game       : ");
		bprint("Hipnotic");
		bprint("\n");
		bprint("Expansion  : ");
		bprint("Mission Pack #1: Scourge of Armagon");
		bprint("\n");
		bprint("Episode(3) : ");
		bprint("The Rift");	
		bprint("\n");						
		bprint("Map(HIPEND): ");
		bprint("Armagon's Lair");
		bprint("\n");
		bprint("Map Author : ");
		bprint("Hipnotic Software");		
	}
	
	// Deathmatch Single Player Maps (Bonus)
	if (mapname == "dm1sp")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Map(DM1SP) : ");
		bprint("Place of Two Deaths");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Tim Willits - Modified by Basil");		
	}
	if (mapname == "dm2sp")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Map(DM2SP) : ");
		bprint("Claustrophobopolis");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("American McGee - Modified by Basil");		
	}
	if (mapname == "dm3sp")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Map(DM3SP) : ");
		bprint("The Abandoned Base");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("John Romero - Modified by Basil");		
	}
	if (mapname == "dm4sp")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Map(DM4SP) : ");
		bprint("The Bad Place");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("American McGee - Modified by Basil");		
	}
	if (mapname == "dm5sp")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Map(DM5SP) : ");
		bprint("The Cistern");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Tim Willits - Modified by Basil");		
	}
	if (mapname == "dm6sp")
	{
		bprint("Game       : ");
		bprint("iD1");
		bprint("\n");		
		bprint("Map(DM6SP) : ");
		bprint("The Dark Zone");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("Tim Willits - Modified by Basil");		
	}
/* 	// They don't exist yet.		
	if (mapname == "dm7sp")
		bprint("DM7SP");
	if (mapname == "dm8sp")
	{
		bprint("Game       : ");
		bprint("ID1");
		bprint("\n");	
		bprint("DM8SP");
	}
*/	

	if (mapname == "100m")	
	{
		bprint("Game       : ");
		bprint("Custom");
		bprint("\n");		
		bprint("Map(100m)  : ");
		bprint("100m Run");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("N/A");		
	}
	if (mapname == "400m")	
	{
		bprint("Game       : ");
		bprint("Custom");
		bprint("\n");		
		bprint("Map(400m)  : ");
		bprint("N/A");
		bprint("\n");		
		bprint("Map Author : ");
		bprint("N/A");		
	}																											
};

void() ExitMessage =
{
	if (!cvar("sv_public")) return;
	
	DisplayedExitMsg = 1;
	bprint("\nQdQ Stats patch v1.8 (NQW Edition)\n");
	bprint("\n");
	bprint("=======================\n");
	if (mlstage == 2)
	{
		if (mapname != "start" || mapname != "hipstart" || mapname != "rstart" || mapname != "e5start" || mapname != "mgstart" || mapname != "hub")
		{
			if (numlevels == 1) totaltime = time;
			else totaltime = totaltime + time;
		}
		mlstage = 3;
	}
//	NoCheatStamp();
	OCD_Mapname_Prints();
	bprint("\n");
	if (mapname != "100m" && mapname != "400m") // Sleeper: Trick maps or bunnyhop maps don't really matter.
	{
		if (cvar("skill") == 0)
		{
			bprint("Skill(0)   : ");
			bprint("Easy");
		}
		else if (cvar("skill") == 1)
		{
			bprint("Skill(1)   : ");
			bprint("Normal");
		}
		else if (cvar("skill") == 2)
		{
			bprint("Skill(2)   : ");
			bprint("Hard");
		}
		else if (cvar("skill") == 3)
		{
			bprint("Skill(3)   : ");
			bprint("Classic Nightmare!");
		}
		else if (cvar("skill") == 4)
		{
			bprint("Skill(4)   : ");
			bprint("KEX Nightmare!");
		}
		else if (cvar("skill") == 5)
		{
			bprint("Skill(5)   : ");
			bprint("Sleeper Must Die!");	
		}
		else if (cvar("skill") > 5 || cvar("skill") < 0)
		{
			bprint("Skill(?)   : ");
			bprint("Unknown");	
		}
		bprint("\n");
	}								
	if (mapname == "start" || mapname == "hipstart" || mapname == "rstart" || mapname == "e5start" || mapname == "mgstart" || mapname == "hub")
	{
		bprint("Level Time : ");
		PrintTime(time);
		bprint("\n");
		bprint("Total Time : ");
		PrintTime(totaltime);
	}
	else
	{
		bprint("Level Time : ");
		PrintTime(time);
		bprint("\n");
		totaltime = totaltime + time;
		bprint("Total Time : ");
		PrintTime(totaltime);
	}
	bprint("\n");
	if (num_players <= 1) bprint("Runner     : ");
	else bprint("Runners    : ");
//	bprint(self.netname);	
	for (entity player = find (world, classname, "player"); player; player = find (player, classname, "player")) // Sleeper: Loop through all the players to get their names.
	{
		local float comma;
		bprint (player.netname);
		if (comma <= num_players) comma++;
		if (comma == num_players - 1) bprint (", "); // Sleeper: If there is more than one player, add a comma until the last player.											
	}
	bprint("\n");
	bprint("=======================\n");
	if (mapname == "start" || mapname == "hipstart" || mapname == "rstart" || mapname == "e5start" || mapname == "mgstart") bprint("(Start maps don't add time!)\n");
	else if (mapname == "hub") bprint("(Hub maps don't add time!)\n");
	bprint("\n");
};

/*
void() CheckNoCheat =
{
	if ((cvar("sv_accelerate") != TE_LAVASPLASH))
	{
		parm10 = (parm10 | AS_MISSILE);
	}
	if ((cvar("sv_aim") < 0.93))
	{
		parm10 = (parm10 | WEAPON_BIG);
	}
	if ((cvar("sv_friction") != AS_MISSILE))
	{
		parm10 = (parm10 | SECRET_YES_SHOOT);
	}
	if ((mapname == "e1m8"))
	{
		if ((cvar("sv_gravity") != 100))
		{
			parm10 = (parm10 | DOOR_TOGGLE);
		}
	}
	else
	{
		if ((cvar("sv_gravity") != 800))
		{
			parm10 = (parm10 | DOOR_TOGGLE);
		}
	}
	if ((cvar("sv_maxspeed") > 320))
	{
		parm10 = (parm10 | IT_LIGHTNING);
	}
	if ((cvar("edgefriction") != AS_SLIDING))
	{
		parm10 = (parm10 | FL_NOTARGET);
	}
	if ((self.flags & FL_GODMODE))
	{
		parm10 = (parm10 | IT_SHELLS);
	}
	if ((self.flags & FL_NOTARGET))
	{
		parm10 = (parm10 | IT_NAILS);
	}
	if (cvar("host_framerate"))
	{
		parm10 = (parm10 | IT_AXE);
	}
	if ((cvar("skill") != (parm10 & AS_MELEE)))
	{
		parm10 = (parm10 | IT_ARMOR1);
	}
	if (((self.movetype == MOVETYPE_NOCLIP) || (self.movetype == MOVETYPE_FLY)))
	{
		parm10 = (parm10 | IT_ARMOR2);
	}
};
*/
/*
void() ShowCoords =
{
	local string tmp;

	tmp = vtos(self.origin);
	sprint(self, tmp);
	sprint(self, "\n");
};


void() HideTriggers =
{
	local entity trig;
	local string t;

	trig = world;
	do
	{
		trig = nextent(trig);
		t = trig.classname;
		if ((((((((((t == "trigger_multiple") || (t == "trigger_once")) || (t == "trigger_secret")) || (t == "trigger_teleport")) || (t == "trigger_onlyregistered")) || (t == "trigger_changelevel")) || (t == "trigger_push")) || (t == "trigger_monsterjump")) || (t == "trigger_hurt")))
		{
			trig.modelindex = realnull;
		}

	} while (trig);
};

void() ShowTriggers =
{
	local entity trig;
	local string t;

	trig = world;
	do
	{
		trig = nextent(trig);
		t = trig.classname;
		if ((((t == "trigger_multiple") || (t == "trigger_once")) || (t == "trigger_secret")))
		{
			if (!(trig.spawnflags & AS_STRAIGHT))
			{
				setmodel(trig, trig.model);
			}
		}
		else
		{
			if (((((((t == "trigger_teleport") || (t == "trigger_onlyregistered")) || (t == "trigger_changelevel")) || (t == "trigger_push")) || (t == "trigger_monsterjump")) || (t == "trigger_hurt")))
			{
				setmodel(trig, trig.model);
			}
		}

	} while (trig);
};
*//*
void() Setp14 =
{
	local string tmp = ftos (parm14);
	cvar_set ("samelevel", tmp);
};

float genocide;

void() Genocide =
{
	local entity head;

	if (deathmatch)	return;
	
	bprint ("Genocide!\n");
	head = world;
	genocide = 1;
	
	head = nextent(head);
	while (nextent(head))
	{
		if ((head.health > 0) && (head.flags & FL_MONSTER)) T_Damage(head, world, world, head.health);
	}
	parm10 |= IT_ROCKETS;
};
*//*
void(float t, float ogre) PrintGCounter =
{
	local float a;

	msg_entity = self;
	WriteByte (MSG_ONE, 26);
	WriteByte (MSG_ONE, 71);
	WriteByte (MSG_ONE, 114);
	WriteByte (MSG_ONE, 101);
	WriteByte (MSG_ONE, 110);
	WriteByte (MSG_ONE, 97);
	WriteByte (MSG_ONE, 100);
	WriteByte (MSG_ONE, 101);
	WriteByte (MSG_ONE, 32);
	if (ogre) WriteByte (MSG_ONE, 79);
	if (t > 0)
	{
		WriteByte (MSG_ONE, 128);
		a = 0;
		a += 1;
		while ((a + 1) < 25)
		{
			if (a == t) WriteByte (MSG_ONE, 131);
			else WriteByte (MSG_ONE, 129);
		}
		WriteString (MSG_ONE, "q");
	}
	else WriteString (MSG_ONE, "                          ");
};

float() GrenadeCounter =
{
	local float a;
	local vector dist;
	local float bestd = 9999;
	local entity ent = world;
	
	ent = find (ent, classname, "grenade");
	while (find (ent, classname, "grenade"))
	{
		if (ent.owner == self)
		{
			dist = ent.origin - self.origin;
			if (vlen(dist) < bestd)
			{
				bestd = vlen (dist);
				if (ent.touch == SUB_Null) a = 0;
				else a = ent.nextthink - time;
			}
		}
	}
	if (bestd == 9999) return FALSE;
	
	a *= 10;
	a = floor(a);
	if (a >= 25) return FALSE;
	
	PrintGCounter (a, 0);
	return TRUE;
};
void() OgreGrenadeTouch;

void() OgreGrenadeCounter =
{
	local float a;
	local vector dist;
	local float bestd = 9999;
	local entity ent = world;
	
	ent = nextent (ent);
	while (nextent(ent))
	{
		if (ent.touch == OgreGrenadeTouch)
		{
			traceline (ent.origin, self.origin, 0, world);
			if (trace_fraction == 1)
			{
				dist = (ent.origin - self.origin);
				if (vlen(dist) < bestd)
				{
					bestd = vlen(dist);
					a = ent.nextthink - time;
				}
			}
		}
	}
	if (bestd == 9999) return;
	a *= 10;
	a = floor (a);
	if (a < 25) PrintGCounter (a, 1);
};

float(entity ent) GCBit =
{
	local float i = 4;
	local entity e = nextent (world);
	while (e != ent)
	{
		i *= 2;
		e = nextent (e);
	}
	return (i);
};

float(entity ent) OGCBit =
{
	return (256 * GCBit (ent));
};

void(entity ent) AddGC =
{
	parm14 |= GCBit (ent);
	Setp14 ();
};

void(entity ent) RemoveGC =
{
	local float i = GCBit (ent);
	if (parm14 & i) parm14 -= i;
	
	Setp14 ();
};

void(entity ent) AddOGC =
{
	parm14 |= OGCBit (ent);
	Setp14 ();
};

void(entity ent) RemoveOGC =
{
	local float i = OGCBit(ent);
	if (parm14 & i) parm14 -= i;
	
	Setp14 ();
};
*//*
void(entity ent) AddVelPrint =
{
	parm12 = (parm12 | GCBit(ent));
	Setp12();
};

void(entity ent) RemoveVelPrint =
{
	local float i;

	i = GCBit(ent);
	if (parm12 & i)
	{
		parm12 = parm12 - i;
	}
	Setp12();
};


void() DelayedRemove =
{
	if (saved1)
	{
		self.think = SUB_Remove;
		if (saved1 == 1)
		{
			self.nextthink = time + 60;
		}
		else
		{
			self.nextthink = time + 5;
		}
	}
};
*/

/*
void() CheckStatImpulses =
{
	if ((self.impulse == TE_LIGHTNING3))
	{
		parm10 = (parm10 | IT_ROCKETS);
	}
	else
	{
		if ((self.impulse == 90))
		{
			PreviousParm();
		}
		else
		{
			if ((self.impulse == 91))
			{
				NextParm();
			}
			else
			{
				if ((self.impulse == 92))
				{
					ChangeParm(-10);
				}
				else
				{
					if ((self.impulse == 93))
					{
						ChangeParm(CONTENT_EMPTY);
					}
					else
					{
						if ((self.impulse == 94))
						{
							ChangeParm(AS_STRAIGHT);
						}
						else
						{
							if ((self.impulse == 95))
							{
								ChangeParm(TE_LAVASPLASH);
							}
							else
							{
								if ((self.impulse == 98))
								{
									if ((self.style & AS_MISSILE))
									{
										self.style = (self.style - AS_MISSILE);
										centerprint(self, "Velocity printing turned off");
										RemoveVelPrint(self);
									}
									else
									{
										self.style = (self.style + AS_MISSILE);
										centerprint(self, "Velocity printing turned on");
										AddVelPrint(self);
									}
								}
								else
								{
									if ((self.impulse == 99))
									{
//										ShowCoords();
									}
									else
									{
										if ((self.impulse == 150))
										{
											centerprint(self, "Everything is normal");
											cvar_set("saved1", "0");
										}
										else
										{
											if ((self.impulse == 151))
											{
												centerprint(self, "Bodies disappear after one minute");
												cvar_set("saved1", "1");
											}
											else
											{
												if ((self.impulse == 152))
												{
													centerprint(self, "Bodies and gibs disappear\nafter five seconds");
													cvar_set("saved1", "2");
												}
												else
												{
													if ((self.impulse == 153))
													{
														centerprint(self, "Bodies disappear after\nfive seconds, no gibs");
														cvar_set("saved1", "3");
													}
													else
													{
														if ((self.impulse == 154))
														{
															centerprint(self, "Bodies disappear instantly, no gibs");
															cvar_set("saved1", "4");
														}
														else
														{
															if ((self.impulse == 155))
															{
																centerprint(self, "Invisible nails (coop only)");
																cvar_set("saved1", "5");
															}
															else
															{
																if ((self.impulse == 156))
																{
																	centerprint(self, "Inivisible nails and\nScrag/H.Knight fire.\nNo explosions (coop only)");
																	cvar_set("saved1", "6");
																}
																else
																{
																	if ((self.impulse == 205))
																	{
																		Genocide();
																	}
																	else
																	{
																		if ((self.impulse == 209))
																		{
																			if (self.style & 2)
																			{
																				self.style = (self.style - 2);
																				centerprint(self, "Ogre-Grenade Counter turned off");
																				RemoveOGC(self);
																			}
																			else
																			{
																				self.style = (self.style + 2);
																				centerprint(self, "Ogre-Grenade Counter turned on");
																				AddOGC(self);
																			}
																		}
																		else
																		{
																			if (self.impulse == 210)
																			{
																				if (self.style & 1)
																				{
																					self.style = (self.style - 1);
																					centerprint(self, "Grenade Counter turned off");
																					RemoveGC(self);
																				}
																				else
																				{
																					self.style = (self.style + 1);
																					centerprint(self, "Grenade Counter turned on");
																					AddGC(self);
																				}
																			}
																			else
																			{
																				if ((self.impulse == 211))
																				{
																					if ((parm12 & AS_SLIDING))
																					{
																						parm12 = (parm12 - AS_SLIDING);
																						centerprint(self, "Triggers now invisible");
//																						HideTriggers();
																					}
																					else
																					{
																						parm12 = (parm12 + AS_SLIDING);
																						centerprint(self, "Triggers now visible");
//																						ShowTriggers();	
																					}
																					Setp12();
																				}
																				else
																				{
																					if ((self.impulse == 212))
																					{
																						if ((parm12 & AS_STRAIGHT))
																						{
																							parm12 = (parm12 - AS_STRAIGHT);
																							centerprint(self, "Trigger info off");
																						}
																						else
																						{
																							parm12 = (parm12 + AS_STRAIGHT);
																							centerprint(self, "Trigger info on");
																						}
																						Setp12();
																					}
																					else
																					{
																						if ((self.impulse == 254))
																						{
																							parm10 = (parm10 | IT_CELLS);
																							self.super_time = AS_STRAIGHT;
																							self.super_damage_finished = 1000000000;
																							self.items = (self.items | IT_QUAD);
																							bprint("Permanent quad cheat\n");
																						}
																						else
																						{
																							if ((self.impulse == 255))
																							{
																								parm10 = (parm10 | IT_CELLS);
																							}
																						}
																					}
																				}
																			}
																		}
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
};
void() CheckStatImpulses =
{
	if (self.impulse == 210)
	{
		if (self.style & 1)
		{
			self.style -= 1;
			centerprint_all ("Grenade Counter turned off");
			RemoveGC (self);
		}
		else
		{
			self.style += 1;
			centerprint_all ("Grenade Counter turned on");
			AddGC (self);
		}
	}
};
*/
void() monster_corporal =
{
	remove(self);
};
