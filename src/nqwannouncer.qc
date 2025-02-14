/*
===================================================================
NQW: ANNOUNCER
===================================================================
*/
void() NQW_AnnouncerPlayback = 
{
	string snd;	
	float delay = 0.1;
	
	// find the next sound in the queue
	if (nqw_announcer.nqw_queue_index == 1) 
	{
		if (nqw_announcer.noise1 != string_null) 
		{
			snd = nqw_announcer.noise1;
			nqw_announcer.noise1 = string_null;
			delay = nqw_announcer.delay1;
		}
		else nqw_announcer.nqw_queue_index++;
	}
	else if (nqw_announcer.nqw_queue_index == 2) 
	{
		if (nqw_announcer.noise2 != string_null) 
		{
			snd = nqw_announcer.noise2;
			nqw_announcer.noise2 = string_null;
			delay = nqw_announcer.delay2;
		}
		else nqw_announcer.nqw_queue_index++;
	}
	else if (nqw_announcer.nqw_queue_index == 3) 
	{
		if (nqw_announcer.noise3 != string_null) 
		{
			snd = nqw_announcer.noise3;
			nqw_announcer.noise3 = string_null;
			delay = nqw_announcer.delay3;
		}
		else nqw_announcer.nqw_queue_index++;
	}
	else if (nqw_announcer.nqw_queue_index == 4) 
	{
		if (nqw_announcer.noise4 != string_null)
		{
			snd = nqw_announcer.noise4;
			nqw_announcer.noise = string_null;
			delay = nqw_announcer.delay4;
		}
		else nqw_announcer.nqw_queue_index++;
	}
	
	nqw_announcer.nqw_queue_index++;
	if (nqw_announcer.nqw_queue_index > 4) nqw_announcer.nqw_queue_index = 1;
		
	if (snd) sound (nqw_announcer, CHAN_ANNOUNCER, snd, 1, ATTN_NONE);

	nqw_announcer.nextthink = time + delay;
};

void(string snd, float delay) NQW_Announce = 
{
	if (!deathmatch) return;
	
	if (nqw_announcer.noise1 == string_null) 
	{
		nqw_announcer.noise1 = snd;
		nqw_announcer.delay1 = delay;
	}
	else if (nqw_announcer.noise2 == string_null) 
	{
		nqw_announcer.noise2 = snd;
		nqw_announcer.delay2 = delay;
	}
	else if (nqw_announcer.noise3 == string_null) 
	{
		nqw_announcer.noise3 = snd;
		nqw_announcer.delay3 = delay;
	}
	else if (nqw_announcer.noise4 == string_null)
	{
		nqw_announcer.noise4 = snd;
		nqw_announcer.delay4 = delay;
	}
};