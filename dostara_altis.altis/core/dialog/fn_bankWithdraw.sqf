#include "..\..\macro.h"
/*
	File: fn_bankDeposit.sqf
	Author: Bryan "Tonic" Boardwine
	Edit : J. `Kira` D.
	
	Description:
	Figure it out.
*/
private _val = parseNumber(ctrlText 2702);
if((time - life_action_delay) < 2.5) exitWith {hint "Vous ne pouvez pas faire d'actions aussi vite."};
life_action_delay = time;
if(_val > 999999) exitWith {hint localize "STR_ATM_WithdrawMax";};
if(_val < 0) exitwith {};
if(!([str(_val)] call life_fnc_isnumeric)) exitWith {hint localize "STR_ATM_notnumeric"};
if(_val > BANK) exitWith {hint localize "STR_ATM_NotEnoughFunds"};
if(_val < 100 && BANK > 20000000) exitWith {hint localize "STR_ATM_WithdrawMin"}; //Temp fix for something.
_taxe = 0;


_taxe = [1] call life_fnc_taxes;
_taxes = _val * _taxe;
_val = _val - _taxes;


CASH = CASH + _val;
BANK = BANK - _val;
call life_fnc_refreshAC;

hint format ["Vous venez de retirer %1€, %2€ de taxe ont été retiré.",[_val] call life_fnc_numberText,[_taxes] call life_fnc_numberText];
[] call life_fnc_atmMenu;
[] call SOCK_fnc_updateBanque;
[6] call SOCK_fnc_updatePartial;
[CASH,BANK,_val,_taxes,"Retrait"] remoteExecCall ["KIRA_fnc_taxes",2];
