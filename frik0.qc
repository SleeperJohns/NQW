//Decompiled code. Please respect the original copyright.
float WritingStuff;
float DisplayedExitMsg;
float PrintComma;
entity CallingThing;
void() GrenadeExplode;
float numlevels;
float totaltime;
float realnull;
float mlstage;

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
	if ((parm11 == open))
	{
		bprint("ê");
	}
	else
	{
		if ((parm11 == close))
		{
			bprint("ë");
		}
		else
		{
			bprint(" ");
		}
	}
};

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
		bprint("ã              ");
	}
	else
	{
		if ((parm8 == AS_STRAIGHT))
		{
			bprint("  ã            ");
		}
		else
		{
			if ((parm8 == AS_SLIDING))
			{
				bprint("    ã          ");
			}
			else
			{
				if ((parm8 == AS_MELEE))
				{
					bprint("      ã        ");
				}
				else
				{
					if ((parm8 == AS_MISSILE))
					{
						bprint("        ã      ");
					}
					else
					{
						if ((parm8 == TE_LIGHTNING1))
						{
							bprint("          ã    ");
						}
						else
						{
							if ((parm8 == TE_LIGHTNING2))
							{
								bprint("            ã  ");
							}
							else
							{
								if ((parm8 == TE_WIZSPIKE))
								{
									bprint("              ã");
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
	if ((parm11 == AS_STRAIGHT))
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
		if ((parm11 == AS_SLIDING))
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
			if ((parm11 == AS_MELEE))
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
				if ((parm11 == AS_MISSILE))
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
					if ((parm11 == TE_LIGHTNING1))
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
						if ((parm11 == TE_LIGHTNING2))
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
							if ((parm11 == TE_WIZSPIKE))
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
								if ((parm11 == WEAPON_BIG))
								{
									ChangeWeapon(IT_SUPER_SHOTGUN);
								}
								else
								{
									if ((parm11 == TE_LIGHTNING3))
									{
										ChangeWeapon(IT_NAILGUN);
									}
									else
									{
										if ((parm11 == TE_LAVASPLASH))
										{
											ChangeWeapon(IT_SUPER_NAILGUN);
										}
										else
										{
											if ((parm11 == TE_TELEPORT))
											{
												ChangeWeapon(IT_GRENADE_LAUNCHER);
											}
											else
											{
												if ((parm11 == 12))
												{
													ChangeWeapon(IT_ROCKET_LAUNCHER);
												}
												else
												{
													if ((parm11 == 13))
													{
														ChangeWeapon(IT_LIGHTNING);
													}
													else
													{
														if ((parm11 == 14))
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
																if ((parm11 == SECRET_YES_SHOOT))
																{
																	ResetPermParms();
																}
																else
																{
																	if ((parm11 == 17))
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
	PrintAllParms();
	SetPermParms();
	if ((parm11 == 18))
	{
		bprint("\nThis is the QdQ stats patch v1.8");
		bprint("\nFor instructions, see the *.txt file,");
		bprint("\nor for up to date info, consult");
		bprint("\nhttp://www.planetquake.com/qdq/stats.html\n");
	}
	else
	{
		if ((parm11 == 19))
		{
			bprint("\n\n\n\n");
			cvar_set("con_notifytime", "3");
			parm11 = realnull;
		}
	}
};

void() PreviousParm =
{
	parm11 = (parm11 - AS_STRAIGHT);
	if (((parm11 == AS_MELEE) && (!parm3 || (parm3 > 150))))
	{
		parm11 = AS_SLIDING;
	}
	if ((parm11 < realnull))
	{
		parm11 = 19;
	}
	PrintAllParms();
};

void() NextParm =
{
	parm11 = (parm11 + AS_STRAIGHT);
	if (((parm11 == AS_MELEE) && (!parm3 || (parm3 > 150))))
	{
		parm11 = AS_MISSILE;
	}
	if ((parm11 > 19))
	{
		parm11 = realnull;
	}
	PrintAllParms();
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

void() ExitMessage =
{
	DisplayedExitMsg = AS_STRAIGHT;
	if ((mlstage == AS_SLIDING))
	{
		if ((mapname != "start"))
		{
			if ((numlevels == AS_STRAIGHT))
			{
				totaltime = time;
			}
			else
			{
				totaltime = (totaltime + time);
			}
		}
		mlstage = AS_MELEE;
	}
	bprint("\nQdQ Stats patch v1.8\nThe recorded time was ");
	NoCheatStamp();
	PrintTime(time);
	bprint("\n");
	if ((numlevels > AS_STRAIGHT))
	{
		if ((mapname == "start"))
		{
			bprint("(does not count for total time)\n");
		}
		else
		{
			bprint("level ");
			bprint(ftos(numlevels));
			bprint(" in the recording\ntotal time is ");
			PrintTime(totaltime);
			bprint("\n");
		}
	}
	bprint("\n");
};

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

void() Setp16 =
{
	local string tmp;

	tmp = ftos(parm16);
	cvar_set("samelevel", tmp);
};
float genocide;

void() Genocide =
{
	local entity head;

	if (deathmatch)
	{
		return;
	}
	bprint("Genocide!\n");
	head = world;
	genocide = AS_STRAIGHT;
	head = nextent(head);
	while (nextent(head))
	{
		if (((head.health > realnull) && (head.flags & FL_MONSTER)))
		{
			T_Damage(head, world, world, head.health);
		}
	}
	parm10 = (parm10 | IT_ROCKETS);
};

void(float t, float ogre) PrintGCounter =
{
	local float a;

	msg_entity = self;
	WriteByte(MSG_ONE, 26);
	WriteByte(MSG_ONE, 71);
	WriteByte(MSG_ONE, 114);
	WriteByte(MSG_ONE, 101);
	WriteByte(MSG_ONE, 110);
	WriteByte(MSG_ONE, 97);
	WriteByte(MSG_ONE, 100);
	WriteByte(MSG_ONE, 101);
	WriteByte(MSG_ONE, DOOR_TOGGLE);
	if (ogre)
	{
		WriteByte(MSG_ONE, 79);
	}
	if ((t > realnull))
	{
		WriteByte(MSG_ONE, FL_NOTARGET);
		a = realnull;
		a = (a + AS_STRAIGHT);
		while (((a + AS_STRAIGHT) < 25))
		{
			if ((a == t))
			{
				WriteByte(MSG_ONE, 131);
			}
			else
			{
				WriteByte(MSG_ONE, 129);
			}
		}
		WriteString(MSG_ONE, "Ç");
	}
	else
	{
		WriteString(MSG_ONE, "                          ");
	}
};

float() GrenadeCounter =
{
	local entity ent;
	local float a;
	local float bestd;
	local vector dist;

	bestd = 9999;
	ent = world;
	ent = find(ent, classname, "grenade");
	while (find(ent, classname, "grenade"))
	{
		if ((ent.owner == self))
		{
			dist = (ent.origin - self.origin);
			if ((vlen(dist) < bestd))
			{
				bestd = vlen(dist);
				if ((ent.touch == SUB_Null))
				{
					a = realnull;
				}
				else
				{
					a = (ent.nextthink - time);
				}
			}
		}
	}
	if ((bestd == 9999))
	{
		return (realnull);
	}
	a = (a * TE_LAVASPLASH);
	a = floor(a);
	if ((a >= 25))
	{
		return (realnull);
	}
	PrintGCounter(a, realnull);
	return (AS_STRAIGHT);
};
void() OgreGrenadeTouch;

void() OgreGrenadeCounter =
{
	local entity ent;
	local float a;
	local float bestd;
	local vector dist;

	bestd = 9999;
	ent = world;
	ent = nextent(ent);
	while (nextent(ent))
	{
		if ((ent.touch == OgreGrenadeTouch))
		{
			traceline(ent.origin, self.origin, realnull, world);
			if ((trace_fraction == AS_STRAIGHT))
			{
				dist = (ent.origin - self.origin);
				if ((vlen(dist) < bestd))
				{
					bestd = vlen(dist);
					a = (ent.nextthink - time);
				}
			}
		}
	}
	if ((bestd == 9999))
	{
		return;
	}
	a = (a * TE_LAVASPLASH);
	a = floor(a);
	if ((a < 25))
	{
		PrintGCounter(a, AS_STRAIGHT);
	}
};

float(entity ent) GCBit =
{
	local float i;
	local entity e;

	i = AS_MISSILE;
	e = nextent(world);
	while ((e != ent))
	{
		i = (i * AS_SLIDING);
		e = nextent(e);
	}
	return (i);
};

float(entity ent) OGCBit =
{
	return ((IT_SHELLS * GCBit(ent)));
};

void(entity ent) AddGC =
{
	parm16 = (parm16 | GCBit(ent));
	Setp16();
};

void(entity ent) RemoveGC =
{
	local float i;

	i = GCBit(ent);
	if ((parm16 & i))
	{
		parm16 = (parm16 - i);
	}
	Setp16();
};

void(entity ent) AddOGC =
{
	parm16 = (parm16 | OGCBit(ent));
	Setp16();
};

void(entity ent) RemoveOGC =
{
	local float i;

	i = OGCBit(ent);
	if ((parm16 & i))
	{
		parm16 = (parm16 - i);
	}
	Setp16();
};
/*
void(entity ent) AddVelPrint =
{
	parm16 = (parm16 | (IT_SUPERHEALTH * GCBit(ent)));
	Setp16();
};

void(entity ent) RemoveVelPrint =
{
	local float i;

	i = (IT_SUPERHEALTH * GCBit(ent));
	if ((parm16 & i))
	{
		parm16 = (parm16 - i);
	}
	Setp16();
};
*/
void() DelayedRemove =
{
	if (saved1)
	{
		self.think = SUB_Remove;
		if ((saved1 == AS_STRAIGHT))
		{
			self.nextthink = (time + 60);
		}
		else
		{
			self.nextthink = (time + TE_LIGHTNING1);
		}
	}
};

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
									//	RemoveVelPrint(self);
									}
									else
									{
										self.style = (self.style + AS_MISSILE);
										centerprint(self, "Velocity printing turned on");
									//	AddVelPrint(self);
									}
								}
								else
								{
									if ((self.impulse == 99))
									{
										ShowCoords();
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
																			if ((self.style & AS_SLIDING))
																			{
																				self.style = (self.style - AS_SLIDING);
																				centerprint(self, "Ogre-Grenade Counter turned off");
																				RemoveOGC(self);
																			}
																			else
																			{
																				self.style = (self.style + AS_SLIDING);
																				centerprint(self, "Ogre-Grenade Counter turned on");
																				AddOGC(self);
																			}
																		}
																		else
																		{
																			if ((self.impulse == 210))
																			{
																				if ((self.style & AS_STRAIGHT))
																				{
																					self.style = (self.style - AS_STRAIGHT);
																					centerprint(self, "Grenade Counter turned off");
																					RemoveGC(self);
																				}
																				else
																				{
																					self.style = (self.style + AS_STRAIGHT);
																					centerprint(self, "Grenade Counter turned on");
																					AddGC(self);
																				}
																			}
																			else
																			{
																				if ((self.impulse == 211))
																				{
																					if ((parm16 & AS_SLIDING))
																					{
																						parm16 = (parm16 - AS_SLIDING);
																						centerprint(self, "Triggers now invisible");
																						HideTriggers();
																					}
																					else
																					{
																						parm16 = (parm16 + AS_SLIDING);
																						centerprint(self, "Triggers now visible");
																						ShowTriggers();
																					}
																					Setp16();
																				}
																				else
																				{
																					if ((self.impulse == 212))
																					{
																						if ((parm16 & AS_STRAIGHT))
																						{
																							parm16 = (parm16 - AS_STRAIGHT);
																							centerprint(self, "Trigger info off");
																						}
																						else
																						{
																							parm16 = (parm16 + AS_STRAIGHT);
																							centerprint(self, "Trigger info on");
																						}
																						Setp16();
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

void() monster_corporal =
{
	remove(self);
};
