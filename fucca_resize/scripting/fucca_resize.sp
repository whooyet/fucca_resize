#include <sdkhooks>
#include <tf2attributes>
#include <tf2_stocks>
#include <friendly>

public Plugin:myinfo = 
{
	name = "[TF2] Simple Resize",
	author = "뿌까",
	description = "ㅎㅎ",
	version = "1.0",
	url = ""
}

new Handle:CvarHead = INVALID_HANDLE;
new Handle:CvarWeapon = INVALID_HANDLE;
new Handle:CvarBody = INVALID_HANDLE;
new Handle:CvarVoice = INVALID_HANDLE;
new Handle:CvarTaunt = INVALID_HANDLE;

new String:g_head[24];
new String:g_weapon[24];
new String:g_body[24];
new String:g_voice[24];
new String:g_taunt[24];


public OnPluginStart()
{
	RegConsoleCmd("sm_hd", Command_Head);
	RegConsoleCmd("sm_ws", Command_Weapon);
	RegConsoleCmd("sm_ws2", Command_Weapon2);
	RegConsoleCmd("sm_bs", Command_Body);
	RegConsoleCmd("sm_bs2", Command_Body2);
	RegConsoleCmd("sm_vs", Command_Voice);
	RegConsoleCmd("sm_ts", Command_Taunt);
	RegConsoleCmd("sm_reset", Command_Reset);
	
	CvarBody = CreateConVar("sm_resize_body", "0.1 ~ 2.0", "작성법 : '최소값 ~ 최대값' 으로 작성해야 작동함");
	CvarHead = CreateConVar("sm_resize_head", "0.1 ~ 2.0", "예를들면 sm_resize_weapon 5라 적을 시");
	CvarTaunt = CreateConVar("sm_resize_taunt", "0.1 ~ 2.0", "플러그인이 제대로 작동 안할 거임");
	CvarVoice = CreateConVar("sm_resize_voice", "0.1 ~ 2.0", "인 게임에서 바꿀땐 쌍따옴표 필수");
	CvarWeapon = CreateConVar("sm_resize_weapon", "0.1 ~ 2.0", "올바른 예) sm_resize_weapon 0.1 ~ 2.0");
	
	GetConVarString(CvarHead, g_head, sizeof(g_head));
	GetConVarString(CvarWeapon, g_weapon, sizeof(g_weapon));
	GetConVarString(CvarBody, g_body, sizeof(g_body));
	GetConVarString(CvarVoice, g_voice, sizeof(g_voice));
	GetConVarString(CvarTaunt, g_taunt, sizeof(g_taunt));
	
	HookConVarChange(CvarHead, ConVarChanged);
	HookConVarChange(CvarWeapon, ConVarChanged2);
	HookConVarChange(CvarBody, ConVarChanged3);
	HookConVarChange(CvarVoice, ConVarChanged4);
	HookConVarChange(CvarTaunt, ConVarChanged5);
	
	AutoExecConfig(true, "fucca_resize");
	
	for(new i = 1; i <= MaxClients; i++) if(PlayerCheck(i)) SDKHook(i, SDKHook_PostThinkPost, OnPostThinkPost);
}

public ConVarChanged(Handle:cvar, const String:oldVal[], const String:newVal[]) GetConVarString(cvar, g_head, sizeof(g_head));
public ConVarChanged2(Handle:cvar, const String:oldVal[], const String:newVal[]) GetConVarString(cvar, g_weapon, sizeof(g_weapon));
public ConVarChanged3(Handle:cvar, const String:oldVal[], const String:newVal[]) GetConVarString(cvar, g_body, sizeof(g_body));
public ConVarChanged4(Handle:cvar, const String:oldVal[], const String:newVal[]) GetConVarString(cvar, g_voice, sizeof(g_voice));
public ConVarChanged5(Handle:cvar, const String:oldVal[], const String:newVal[]) GetConVarString(cvar, g_taunt, sizeof(g_taunt));

public OnClientPutInServer(client) SDKHook(client, SDKHook_PostThinkPost, OnPostThinkPost);

public Action:Command_Head(client, args)
{
	new String:temp[256];
	Format(temp, sizeof(temp), "\x03!hd < %s >", g_head);
	SetSize(client, 444, g_head, temp, args, false);
	return Plugin_Handled;	
}

public Action:Command_Weapon(client, args)
{
	new String:temp[256];
	Format(temp, sizeof(temp), "\x03!ws < %s >", g_weapon);
	SetSize(client, 699, g_weapon, temp, args, false);
	return Plugin_Handled;	
}

public Action:Command_Weapon2(client, args)
{
	new String:temp[256];
	Format(temp, sizeof(temp), "\x03!ws2 < %s >", g_weapon);
	SetSize(client, 699, g_weapon, temp, args);
	return Plugin_Handled;	
}

public Action:Command_Body(client, args)
{
	new String:temp[256];
	Format(temp, sizeof(temp), "\x03!bs < %s >", g_body);
	SetSize(client, 620, g_body, temp, args, false);
	return Plugin_Handled;	
}

public Action:Command_Body2(client, args)
{
	new String:temp[256];
	Format(temp, sizeof(temp), "\x03!bs2 < %s >", g_body);
	SetSize(client, 620, g_body, temp, args);
	return Plugin_Handled;	
}

public Action:Command_Voice(client, args)
{
	new String:temp[256];
	Format(temp, sizeof(temp), "\x03!vs < %s >", g_voice);
	SetSize(client, 2048, g_voice, temp, args);
	return Plugin_Handled;	
}

public Action:Command_Taunt(client, args)
{
	new String:temp[256];
	Format(temp, sizeof(temp), "\x03!ts < %s >", g_taunt);
	SetSize(client, 201, g_taunt, temp, args);
	return Plugin_Handled;	
}

public Action:Command_Reset(client, args)
{
	TF2Attrib_RemoveByDefIndex(client, 620);
	TF2Attrib_RemoveByDefIndex(client, 444);
	TF2Attrib_RemoveByDefIndex(client, 2048);
	TF2Attrib_RemoveByDefIndex(client, 699);
	PrintToChat(client, "\x03초기화 되었습니다."); 
	return Plugin_Handled;	
}

public OnPostThinkPost(client)
{
	if(TF2_GetPlayerClass(client) == TFClassType:TFClass_Sniper)
	{
		NoSniper(client, 444);
		NoSniper(client, 620);
		NoSniper(client, 699);
	}
}

stock NoSniper(client, index)
{
	new Address:pAttrib = TF2Attrib_GetByDefIndex(client, index);
	if(IsValidAddress(Address:pAttrib))
	{
		new idx = TF2Attrib_GetDefIndex(pAttrib);
		if(idx == index) TF2Attrib_RemoveByDefIndex(client, index);
	}
}

stock SetSize(client, index, String:cv[], String:RePly[], args, bool:minus = false)
{
	if(!TF2Friendly_IsFriendly(client))
	{
		ReplyToCommand(client, "\x03무적 후 사용가능 합니다.");
		return;
	}
	if(TF2_GetPlayerClass(client) == TFClassType:TFClass_Sniper)
	{
		ReplyToCommand(client, "\x03스나이퍼는 사용할 수 없습니다.");
		return;
	}
	
	if(args != 1) 
	{
		ReplyToCommand(client, RePly);
		return;
	}

	decl String:num[12], Float:value, String:aa[2][64];
	ExplodeString(cv, " ~ ", aa, 2, 64);

	GetCmdArg(1, num, sizeof(num));
	value = StringToFloat(num);
		
	if(value < StringToFloat(aa[0]) || value > StringToFloat(aa[1]))
	{
		ReplyToCommand(client, RePly);
		return;
	}
		
	if(minus) TF2Attrib_SetByDefIndex(client, index, -value);
	else TF2Attrib_SetByDefIndex(client, index, value);
	
	ReplyToCommand(client, "\x04%.1f 적용 완료", value);
}

stock bool IsValidAddress(Address pAddress)
{
	static Address Address_MinimumValid = view_as<Address>(0x10000);
	if (pAddress == Address_Null)
		return false;
	return unsigned_compare(view_as<int>(pAddress), view_as<int>(Address_MinimumValid)) >= 0;
}
stock int unsigned_compare(int a, int b) {
	if (a == b)
		return 0;
	if ((a >>> 31) == (b >>> 31))
		return ((a & 0x7FFFFFFF) > (b & 0x7FFFFFFF)) ? 1 : -1;
	return ((a >>> 31) > (b >>> 31)) ? 1 : -1;
}

stock bool:PlayerCheck(client, bool:fake = true)
{
	if(client <= 0 || client > MaxClients) return false;
	if(!IsClientInGame(client)) return false;
	if(IsClientSourceTV(client) || IsClientReplay(client)) return false;
	if(fake) if(IsFakeClient(client)) return false;
	return true;
}