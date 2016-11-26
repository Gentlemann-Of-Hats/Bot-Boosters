#pragma semicolon 1
#include <sourcemod>
#include <tf2>
#include <tf2_stocks>

#define PLUGIN_VERSION "1.0.0"

new Handle:acc_version = INVALID_HANDLE;
new Handle:acc_givebotspower = INVALID_HANDLE;

public Plugin:myinfo =
{
	name = "AutomaticConditionAdder",
	author = "Gentlemann Of Hats",
	description = "Crits on Spawn gives red team crits and healing power on spawn",
	version = PLUGIN_VERSION,
	url = "www.null.com"
}
public OnPluginStart()
{
	acc_version = CreateConVar("acc_version", PLUGIN_VERSION, "Crits On spawn version", FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
	acc_givebotspower = CreateConVar("acc_givebotspower", "1.0", "Sets whether to give bots crits on spawn", _, true, 0.0, true, 1.0);
	AutoExecConfig(true, "plugin.AutomaticConditionAdder");
	HookEventEx("player_spawn", HookPlayerSpawn, EventHookMode_Post);
	HookEventEx("player_changeclass", HookPlayerClass, EventHookMode_Post);
}
public Action:HookPlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new userid = GetEventInt(event, "userid");
	new client = GetClientOfUserId(userid);
	new TFTeam:iTFteam = TF2_GetClientTeam(client);
	if (iTFteam != TFTeam_Red)
		return Plugin_Continue;
	CreateTimer(0.25, Addcond_Timer, any:client);
	return Plugin_Continue;
}
public Action:HookPlayerClass(Handle:event, const String:name[], bool:dontBroadcast)
{
	new userid = GetEventInt(event, "userid");
	new client = GetClientOfUserId(userid);
	new TFTeam:iTFteam = TF2_GetClientTeam(client);
	if (iTFteam != TFTeam_Red)
		return Plugin_Continue;
	CreateTimer(0.25, Addcond_Timer, any:client);
	return Plugin_Continue;
}
public Action:Addcond_Timer(Handle:timer, any:client)
{
	new Float:iBotPower = GetConVarFloat(acc_givebotspower);
	if !IsFakeClient(client) *then
	{
		 TF2_AddCondition(client, TFCond_CritCanteen, TFCondDuration_Infinite, 0);
		 TF2_AddCondition(client, TFCond_RegenBuffed, TFCondDuration_Infinite, 0);
	}
	if iBotPower == 1.0 *then
	{
		TF2_AddCondition(client, TFCond_CritCanteen, TFCondDuration_Infinite, 0);
		TF2_AddCondition(client, TFCond_RegenBuffed, TFCondDuration_Infinite, 0);
	}
	return Plugin_Continue;
}