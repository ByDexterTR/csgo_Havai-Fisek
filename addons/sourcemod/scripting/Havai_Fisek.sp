#include <sourcemod>
#include <emitsoundany>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "Havai Fisek", 
	author = "ByDexter", 
	description = "Round Sonunda rastgele yerlerde havai fişek patlar, ses efektleri mevcuttur.", 
	version = "1.0", 
	url = "https://steamcommunity.com/id/ByDexterTR - ByDexter#5494"
};

public void OnPluginStart()
{
	HookEvent("round_end", RoundEnd, EventHookMode_PostNoCopy);
}

public void OnMapStart()
{
	PrecacheSoundAny("weapons/party_horn_01.wav");
}

public Action RoundEnd(Event event, const char[] name, bool dontBroadcast)
{
	int CTSansli = GetRandomPlayer(3);
	int TSansli = GetRandomPlayer(2);
	CreateParticle(CTSansli, "weapon_confetti_balloons", 5.0);
	CreateParticle(TSansli, "weapon_confetti_balloons", 5.0);
	EmitSoundToAllAny("weapons/party_horn_01.wav");
}

stock void CreateParticle(int ent, char[] particleType, float time)
{
	int particle = CreateEntityByName("info_particle_system");
	char name[64];
	if (IsValidEdict(particle))
	{
		float position[3];
		GetEntPropVector(ent, Prop_Send, "m_vecOrigin", position);
		TeleportEntity(particle, position, NULL_VECTOR, NULL_VECTOR);
		GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));
		DispatchKeyValue(particle, "targetname", "tf2particle");
		DispatchKeyValue(particle, "parentname", name);
		DispatchKeyValue(particle, "effect_name", particleType);
		DispatchSpawn(particle);
		SetVariantString(name);
		AcceptEntityInput(particle, "SetParent", particle, particle, 0);
		ActivateEntity(particle);
		AcceptEntityInput(particle, "start");
		CreateTimer(time, DeleteParticle, particle);
	}
}

stock int GetRandomPlayer(int team)
{
	int[] clients = new int[MaxClients];
	int clientCount;
	for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i) && GetClientTeam(i) == team)
		clients[clientCount++] = i;
	return (clientCount == 0) ? -1 : clients[GetRandomInt(0, clientCount - 1)];
}

public Action DeleteParticle(Handle timer, any particle)
{
	if (IsValidEntity(particle))
	{
		char classN[64];
		GetEdictClassname(particle, classN, sizeof(classN));
		if (StrEqual(classN, "info_particle_system", false))
		{
			RemoveEntity(particle);
		}
	}
} 