/*******************************************************************************
* FILENAME :        simpleControllerVehicle.pwn
*
* DESCRIPTION :
*       Filterscript main archive.
*
* NOTES :
*       -
*
*
*/


/*
 * I N C L U D E S
 ******************************************************************************
 */
#include <a_samp>
#include <zcmd>

/*
 * D E F I N I T I O N S
 ******************************************************************************
 */

/**
* Macros Utilizados
*/
static stock stringF[256];

#if !defined isnull
    #define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

#if !defined SendClientMessageEx
	#define SendClientMessageEx(%0,%1,%2,%3) format(stringF, sizeof(stringF),%2,%3) && SendClientMessage(%0, %1, stringF)
#endif

const

	/**
	* Cores Utilizadas
	*/
	COLOR_RED		= 0xE84F33AA,
	COLOR_GREEN		= 0x9ACD32AA,

	/**
	* ID da Dialog utilizada.
	*/
	DIALOG_PAINEL   = 1;

/*
 * V A R I A B L E S
 ******************************************************************************
 */
static 

	/**
	* Variáveis para controle do veículo.
	*/
	engine, doors, lights, alarm, bonnet, boot,	objective;	

/*
 * N A T I V E 
 * C A L L B A C K S
 ******************************************************************************
 */

/**
 * Inicia o Filterscript.
 * 
 * @param                 Não possui parâmetros.
 * @return                1 caso verdadeiro.
 */
public OnFilterScriptInit()
{
	PrintSystemLoaded("simpleControllerVehicle");

	for(new i; i < MAX_VEHICLES; i++)
	{
    	if (!IsntACar(i))
    	{
        	GetVehicleParamsEx(i, engine, lights, alarm, doors, bonnet, boot, objective);
        	SetVehicleParamsEx(i, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, objective);
    	}
	}
	return 1;
}

/**
 * Aplica as funções de cada dialog selecionada.
 * 
 * @param playerid       ID do jogador.
 * @param dialogid       ID da caixa de diálogo.
 * @param response       Resposta da caixa de diálogo.
 * @param listitem       item de uma lista.
 * @param inputtext[]    Texto inserido.
 * @return               1 caso verdadeiro.
 */
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_PAINEL)
	{
		if(!response)
			return SendClientMessage(playerid, COLOR_RED, "<!>{FFFFFF}Você fechou o painel do veículo.");
					
		new vehid = GetPlayerVehicleID(playerid);

		GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective);

		switch(listitem)
		{
			case 0:
				SetVehicleParamsEx(vehid, ((engine == VEHICLE_PARAMS_OFF) ? (VEHICLE_PARAMS_ON) : (VEHICLE_PARAMS_OFF)), lights, alarm, doors, bonnet, boot, objective);

			case 1:
				SetVehicleParamsEx(vehid, engine, lights, alarm, ((doors == VEHICLE_PARAMS_OFF) ? (VEHICLE_PARAMS_ON) : (VEHICLE_PARAMS_OFF)), bonnet, boot, objective);

			case 2:
				SetVehicleParamsEx(vehid, engine, ((lights == VEHICLE_PARAMS_OFF) ? (VEHICLE_PARAMS_ON) : (VEHICLE_PARAMS_OFF)), alarm, doors, bonnet, boot, objective);

			case 3:
				SetVehicleParamsEx(vehid, engine, lights, ((alarm == VEHICLE_PARAMS_OFF) ? (VEHICLE_PARAMS_ON) : (VEHICLE_PARAMS_OFF)), doors, bonnet, boot, objective);

			case 4:
				SetVehicleParamsEx(vehid, engine, lights, alarm, doors, ((bonnet == VEHICLE_PARAMS_OFF) ? (VEHICLE_PARAMS_ON) : (VEHICLE_PARAMS_OFF)), boot, objective);

			case 5:
				SetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, ((boot == VEHICLE_PARAMS_OFF) ? (VEHICLE_PARAMS_ON) : (VEHICLE_PARAMS_OFF)), objective);
		}

		ShowPlayerVehiclePanel(playerid);
		return 1;
	}

	return 1;
}

/*
 * F U N C T I O N S
 ******************************************************************************
 */

/**
 * Verifica se o veículo é um carro inválido.
 * 
 * @param carid          ID do veículo.
 * @return               true se for um veículo inválido, false caso seja um veículo válido.
 */
static IsntACar(carid)
{
	carid = GetVehicleModel(carid);

	switch(carid)
	{
		case 448, 461, 462, 463, 468, 471, 481, 509, 510, 521, 522, 523, 581, 586,
			460, 476, 511, 512, 513, 519, 520, 553, 577, 592, 593, 430, 446, 452,
			453, 454, 472, 473, 484, 493, 595, 417, 425, 447, 469, 487, 488, 497, 548:
			return true;
	}

	return false;
}

/**
 * Mostra o painel do veículo a um jogador específico.
 * 
 * @param carid          ID do veículo.
 * @return               não retorna valores.
 */
static ShowPlayerVehiclePanel(playerid)
{
	new dialogPainel[184 + 1],
		vehid = GetPlayerVehicleID(playerid);

	GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective);

	format(dialogPainel, sizeof(dialogPainel),"Funções\tEstado\nMotor\t%s\nPortas\t%s\nFarol\t%s\nAlarme\t%s\nCapô\t%s\nPorta-malas\t%s\n",
		((engine == VEHICLE_PARAMS_ON) ? ("{3DA23B}ligado") : ("{8B0000}desligado")),
		((doors == VEHICLE_PARAMS_ON) ? ("{8B0000}trancadas") : ("{3DA23B}destrancadas")),
		((lights == VEHICLE_PARAMS_ON) ? ("{3DA23B}aceso") : ("{8B0000}apagado")),
		((alarm == VEHICLE_PARAMS_ON) ? ("{3DA23B}ativado") : ("{8B0000}desativado")),
		((bonnet == VEHICLE_PARAMS_ON) ? ("{3DA23B}aberto") : ("{8B0000}fechado")),
		((boot == VEHICLE_PARAMS_ON) ? ("{3DA23B}aberto") : ("{8B0000}fechado")));

	ShowPlayerDialog(playerid, DIALOG_PAINEL, DIALOG_STYLE_TABLIST_HEADERS, "Painel do veículo", dialogPainel, "Selecionar", "Cancelar");
}

/*
 * C O M P L E M E N T S
 ******************************************************************************
 */

/**
 * Printa no Console o aviso do sistema carregado.
 * 
 * @param systemName[]       nome do sistema.
 * @return                   não retorna valores.
 */
static PrintSystemLoaded(systemName[])
{
	new splitter[100], size, i;

	size = ((strlen(systemName) < 13) ? (13) : (strlen(systemName)));

	for(i = 0; i < size; i++)
		splitter[i] = '-';

	format(splitter, sizeof(splitter), "%s------", splitter);

	printf("\n---------------%s", splitter);
	printf("      > %s loaded", systemName);
	print("      > Developed by Vithinn");
	printf("---------------%s\n", splitter);
}

/*
 * C O M M A N D S
 ******************************************************************************
 */

/**
 * Comando para a abertura do painel de controle.
 * 
 * @param playerid           ID do jogador.
 * @return                   não retorna valores.
 */
CMD:painel(playerid)
{
	if(!IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, COLOR_RED,"<!>{FFFFFF}Você não está dentro de um veículo.");

	else if(IsntACar(GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, COLOR_RED,"<!>{FFFFFF}Você não está em um veículo com painel instalado.");

	else if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendClientMessage(playerid, COLOR_RED, "<!>{FFFFFF}Você não está dirigindo um veículo.");

	ShowPlayerVehiclePanel(playerid);
	return 1;
}