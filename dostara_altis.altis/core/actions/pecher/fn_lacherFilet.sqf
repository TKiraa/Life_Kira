/*
	File: fn_lacherFilet.sqf
	Author: J. `Kira` D.

	Description:
	flemme

	PARAMETRES:
	1. STRING(filet)

	RETURNS:
	NONE

	CALL:
	[STRING] call life_fnc_lacherFilet
*/
private _filet = param[0,"",[""]];
private _maxmin = [];
_boat = vehicle player;
if !(_boat isKindOf "Ship") exitWith {hint "Vous ne pouvez pas lacher vos filets car le vehicule n'est pas un bateau."};
if (speed _boat > 5)exitWith{hint "Vous devez être immobile pour lacher le filet."};
if !(isNil {_boat getVariable ["InUsefishing",nil]})exitWith{hint "Vous pechez déjà."};
_boat setVariable ["InUsefishing",getPlayerUID player,true];

_maxmin = switch (_filet) do { 
	case "filet_a" : {[1,10,6]};
	case "filet_p" : {[1,20,11]};
	case "filet_e" : {[1,30,21]};
};
_boat setVariable["poissons",[],true];
_action = _boat addAction ["Recuperer filet de pêche",life_fnc_recupereFilet,"",0,false,false,"",format["vehicle player == %1 && !(isNil {_boat getVariable ['InUsefishing',nil]})",_boat]];
_boat setVariable["idAction",_action,true];
[_boat,_maxmin] spawn life_fnc_pecher;