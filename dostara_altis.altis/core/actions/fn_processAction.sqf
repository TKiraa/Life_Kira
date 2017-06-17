/*
	File: fn_processAction.sqf
	Author: Bryan "Tonic" Boardwine

	Description:
	Master handling for processing an item.
*/
private["_vendor","_type","_itemInfo","_oldItem","_newItem","_cost","_upp","_hasLicense","_itemName","_oldVal","_ui","_progress","_pgText","_cP"];
_vendor = [_this,0,ObjNull,[ObjNull]] call BIS_fnc_param;
_type = [_this,3,"",[""]] call BIS_fnc_param;
//Error check
if(isNull _vendor OR _type == "" OR (player distance _vendor > 10)) exitWith {};

//unprocessed item,processed item, cost if no license,Text to display (I.e Processing  (percent) ..."
_itemInfo = switch (_type) do
{
	case "oil": {["oilu","oilp",false,1200,(localize "STR_Process_Oil")];};
	case "diamond": {["diamond","diamondc","sand",1350,(localize "STR_Process_Diamond")];};
	case "heroin": {["heroinu","heroinp",false,1750,(localize "STR_Process_Heroin")];};
	case "copper": {["copperore","copper_r",false,750,(localize "STR_Process_Copper")];};
	case "iron": {["ironore","iron_r",false,1120,(localize "STR_Process_Iron")];};
	case "sand": {["sand","glass",false,650,(localize "STR_Process_Sand")];};
	case "salt": {["salt","salt_r",false,450,(localize "STR_Process_Salt")];};
	case "cocaine": {["cocaine","cocainep",false,1500,(localize "STR_Process_Cocaine")];};
	case "marijuana": {["cannabis","marijuana",false,500,(localize "STR_Process_Marijuana")];};
	case "opium": {["opiumn","opium",false,900,(localize "STR_Process_Opium")];};
	case "cement": {["rock","cement",false,350,(localize "STR_Process_Cement")];};
	case "cidre": {["apple","cidre",false,200,(localize "STR_Process_Cidre")];};
	case "wine": {["vinu","vin",false,200,(localize "STR_Process_Wine")];};
	default {[];};
};

//Error checking
if(count _itemInfo == 0) exitWith {};

//Setup vars.
_oldItem = _itemInfo select 0;
_newItem = _itemInfo select 1;
_multiple = _itemInfo select 2;
_cost = _itemInfo select 3;
_upp = _itemInfo select 4;

if (typeName _multiple == "STRING") then {
    _multipleTra = true;
    _multipleVal = missionNamespace getVariable ([_multiple,0] call life_fnc_varHandle);

    diag_log format ["%2 | %1",typeName _multiple,_multiple];
    diag_log format ["%2 | %1",typeName _multipleVal,_multipleVal];
    diag_log format ["%2 | %1",typeName _multipleTra,_multipleTra];
    _cost = _cost * _multipleVal;
    if(_multipleVal == 0) exitWith {};
};

_hasLicense = missionNamespace getVariable (([_type,0] call life_fnc_licenseType) select 0);

_itemName = [([_newItem,0] call life_fnc_varHandle)] call life_fnc_varToStr;
_oldVal = missionNamespace getVariable ([_oldItem,0] call life_fnc_varHandle);

_cost = _cost * _oldVal;
//Some more checks
if(_oldVal == 0) exitWith {};

//Setup our progress bar.
disableSerialization;
5 cutRsc ["life_progress","PLAIN"];
_ui = uiNameSpace getVariable "life_progress";
_progress = _ui displayCtrl 38201;
_pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format["%2 (1%1)...","%",_upp];
_progress progressSetPosition 0.01;
_cP = 0.01;

life_is_processing = true;

if(_hasLicense) then
{
	while{true} do
	{
		sleep  0.3;
		_cP = _cP + 0.01;
		_progress progressSetPosition _cP;
		_pgText ctrlSetText format["%3 (%1%2)...",round(_cP * 100),"%",_upp];
		if(_cP >= 1) exitWith {};
		if(player distance _vendor > 10) exitWith {};
	};

	if(player distance _vendor > 10) exitWith {hint localize "STR_Process_Stay"; 5 cutText ["","PLAIN"]; life_is_processing = false;};

    if(_multipleTra) then {
        if(!([false,_multiple,_multipleVal] call life_fnc_handleInv)) exitWith {5 cutText ["","PLAIN"]; life_is_processing = false;};
    	if(!([false,_oldItem,_oldVal] call life_fnc_handleInv)) exitWith {5 cutText ["","PLAIN"]; life_is_processing = false;};
    	if(!([true,_newItem,_oldVal] call life_fnc_handleInv)) exitWith {5 cutText ["","PLAIN"]; [true,_oldItem,_oldVal] call life_fnc_handleInv; life_is_processing = false;};
        if(!([true,_newItem,_oldVal] call life_fnc_handleInv)) exitWith {5 cutText ["","PLAIN"]; [true,_multiple,_multipleVal] call life_fnc_handleInv; life_is_processing = false;};
    }else{
    	if(!([false,_oldItem,_oldVal] call life_fnc_handleInv)) exitWith {5 cutText ["","PLAIN"]; life_is_processing = false;};
    	if(!([true,_newItem,_oldVal] call life_fnc_handleInv)) exitWith {5 cutText ["","PLAIN"]; [true,_oldItem,_oldVal] call life_fnc_handleInv; life_is_processing = false;};
    };

	5 cutText ["","PLAIN"];
	titleText[format[localize "STR_Process_Processed",_oldVal,_itemName],"PLAIN"];
	life_is_processing = false;
}
	else
{
	if(life_cash < _cost) exitWith {hint format[localize "STR_Process_License",[_cost] call life_fnc_numberText]; 5 cutText ["","PLAIN"]; life_is_processing = false;};

	while{true} do
	{
		sleep  0.9;
		_cP = _cP + 0.01;
		_progress progressSetPosition _cP;
		_pgText ctrlSetText format["%3 (%1%2)...",round(_cP * 100),"%",_upp];
		if(_cP >= 1) exitWith {};
		if(player distance _vendor > 10) exitWith {};
	};

	if(player distance _vendor > 10) exitWith {hint localize "STR_Process_Stay"; 5 cutText ["","PLAIN"]; life_is_processing = false;};
	if(life_cash < _cost) exitWith {hint format[localize "STR_Process_License",[_cost] call life_fnc_numberText]; 5 cutText ["","PLAIN"]; life_is_processing = false;};

    if(_multipleTra) then {
        if(!([false,_multiple,_multipleVal] call life_fnc_handleInv)) exitWith {5 cutText ["","PLAIN"]; life_is_processing = false;};
    	if(!([false,_oldItem,_oldVal] call life_fnc_handleInv)) exitWith {5 cutText ["","PLAIN"]; life_is_processing = false;};
    	if(!([true,_newItem,_oldVal] call life_fnc_handleInv)) exitWith {5 cutText ["","PLAIN"]; [true,_oldItem,_oldVal] call life_fnc_handleInv; life_is_processing = false;};
        if(!([true,_newItem,_oldVal] call life_fnc_handleInv)) exitWith {5 cutText ["","PLAIN"]; [true,_multiple,_multipleVal] call life_fnc_handleInv; life_is_processing = false;};
    }else{
    	if(!([false,_oldItem,_oldVal] call life_fnc_handleInv)) exitWith {5 cutText ["","PLAIN"]; life_is_processing = false;};
    	if(!([true,_newItem,_oldVal] call life_fnc_handleInv)) exitWith {5 cutText ["","PLAIN"]; [true,_oldItem,_oldVal] call life_fnc_handleInv; life_is_processing = false;};
    };

    5 cutText ["","PLAIN"];
	titleText[format[localize "STR_Process_Processed2",_oldVal,_itemName,[_cost] call life_fnc_numberText],"PLAIN"];
	life_cash = life_cash - _cost;
	life_is_processing = false;
};

_nameOld = [([_oldItem,0] call life_fnc_varHandle)] call life_fnc_varToStr;
[getPlayerUID player, civilian, [name player, _oldVal, _nameOld, _itemName],39] remoteExecCall ["DB_fnc_logs",2];