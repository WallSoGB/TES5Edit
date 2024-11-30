{******************************************************************************

  This Source Code Form is subject to the terms of the Mozilla Public License, 
  v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain 
  one at https://mozilla.org/MPL/2.0/.

*******************************************************************************}

unit wbDefinitionsFO3;

{$I wbDefines.inc}

interface

procedure DefineFO3;

implementation

uses
  Classes,
  Math,
  SysUtils,
  Variants,
  wbDefinitionsCommon,
  wbDefinitionsSignatures,
  wbHelpers,
  wbInterface;

var
  wbConditionParameters: array of IwbValueDef;
  wbConditionVATSValueParameters: array of IwbValueDef;
  wbConditionBaseObjects: TwbSignatures;

  wbFormTypeEnum: IwbEnumDef;
  wbMiscStatEnum: IwbEnumDef;
  wbObjectTypeEnum: IwbEnumDef;
  wbPlayerActionEnum: IwbEnumDef;
  wbSkillEnum: IwbEnumDef;
  wbSoundLevelEnum: IwbEnumDef;
  wbVatsActionEnum: IwbEnumDef;
  wbVatsValueFunctionEnum: IwbEnumDef;
  wbWeaponAnimTypeEnum: IwbEnumDef;

  wbActorValue: IwbIntegerDef;

  wbAIDT: IwbRecordMemberDef;
  wbBIPL: IwbRecordMemberDef;
  wbBMDT: IwbRecordMemberDef;
  wbCNTOs: IwbRecordMemberDef;
  wbCOED: IwbRecordMemberDef;
  wbConditions: IwbRecordMemberDef;
  wbDESC: IwbRecordMemberDef;
  wbDESCReq: IwbRecordMemberDef;
  wbDEST: IwbRecordMemberDef;
  wbDODT: IwbRecordMemberDef;
  wbEDID: IwbRecordMemberDef;
  wbEDIDReq: IwbRecordMemberDef;
  wbEDIDReqKC: IwbRecordMemberDef;
  wbEffects: IwbRecordMemberDef;
  wbEffectsReq: IwbRecordMemberDef;
  wbEFID: IwbRecordMemberDef;
  wbEFIT: IwbRecordMemberDef;
  wbEITM: IwbRecordMemberDef;
  wbEmbeddedScript: IwbRecordMemberDef;
  wbEmbeddedScriptReq: IwbRecordMemberDef;
  wbETYP: IwbRecordMemberDef;
  wbETYPReq: IwbRecordMemberDef;
  wbFaceGen: IwbRecordMemberDef;
  wbFULL: IwbRecordMemberDef;
  wbFULLReq: IwbRecordMemberDef;
  wbICON: IwbRecordMemberDef;
  wbICONReq: IwbRecordMemberDef;
  wbMODD: IwbRecordMemberDef;
  wbMODS: IwbRecordMemberDef;
  wbMOSD: IwbRecordMemberDef;
  wbMO2S: IwbRecordMemberDef;
  wbMO3S: IwbRecordMemberDef;
  wbMO4S: IwbRecordMemberDef;
  wbREPL: IwbRecordMemberDef;
  wbSCHRReq: IwbRecordMemberDef;
  wbSCRI: IwbRecordMemberDef;
  wbSCROs: IwbRecordMemberDef;
  wbSLSD: IwbRecordMemberDef;
  wbSPLOs: IwbRecordMemberDef;
  wbXESP: IwbRecordMemberDef;
  wbXLCM: IwbRecordMemberDef;
  wbXSCL: IwbRecordMemberDef;
  wbYNAM: IwbRecordMemberDef;
  wbZNAM: IwbRecordMemberDef;

type
  TConditionParameterType = (
    //Misc
	  {1}  ptNone,
    {2}  ptInteger,
	  {3}  ptQuestStage,
    {4}  ptVariableName,
	  {5}  ptVATSValueParam,

	  //Enums
	  {6}  ptActorValue,        //wbActorValueEnum
	  {7}  ptAlignment,         //wbAlignmentEnum
	  {8}  ptAxis,              //wbAxisEnum
	  {9}  ptBodyLocation,      //wbBodyLocationEnum
	  {10} ptCreatureType,      //wbCreatureTypeEnum
	  {11} ptCrimeType,         //wbCrimeTypeEnum
	  {12} ptCriticalStage,     //wbCriticalStageEnum
	  {13} ptEquipType,         //wbEquipTypeEnum
	  {14} ptFormType,          //wbFormTypeEnum
	  {15} ptMenuMode,          //wbMenuModeEnum
	  {16} ptMiscStat,          //wbMiscStatEnum
	  {17} ptPlayerAction,      //PlayerActionEnum
    {18} ptSex,               //wbSexEnum
	  {19} ptVATSValueFunction, //wbVATSValueFunctionEnum

    //FormIDs
	  {20} ptActor,           //ACHR, ACRE
	  {21} ptActorBase,       //NPC_, CREA
	  {22} ptBaseEffect,      //MGEF
    {23} ptBaseObject,      //ACTI, ALCH, AMMO, ARMA, ARMO, ASPC, BOOK, CONT, CREA, DOOR, FLST, FURN, GRAS, IDLM, KEYM, LIGH, LVLC, LVLN, MISC, MSTT, NOTE, NPC_, PROJ, PWAT, SCOL, SOUN, STAT, TACT, TERM, TREE, WEAP
	  {24} ptCell,            //CELL
	  {25} ptClass,           //CLAS
	  {26} ptEffectItem,      //SPEL
	  {27} ptEncounterZone,   //ECZN
	  {28} ptFaction,         //FACT
	  {29} ptFormList,        //FLST
	  {30} ptFurniture,       //FLST, FURN
	  {31} ptGlobal,          //GLOB
	  {32} ptIdleForm,        //IDLE
	  {33} ptInventoryObject, //ALCH, AMMO, ARMA, ARMO, BOOK, KEYM, MISC, NOTE, WEAP
	  {34} ptNote,            //NOTE
	  {35} ptOwner,           //FACT, NPC_
	  {36} ptPackage,         //PACK
	  {37} ptPerk,            //PERK
	  {38} ptQuest,           //QUST
	  {39} ptRace,            //RACE
	  {40} ptReference,       //ACHR, ACRE, PGRE, REFR
    {41} ptVoiceType,       //VTYP
    {42} ptWeapon,          //WEAP
    {43} ptWeather,         //WTHR
    {44} ptWorldspace       //WRLD
  );

  PConditionFunction = ^TConditionFunction;
  TConditionFunction = record
    Index: Integer;
    Name: string;
    ParamType1: TConditionParameterType;
    ParamType2: TConditionParameterType;
  end;

const
  wbConditionFunctions : array[0..243] of TConditionFunction = (
    // Added by Fallout 3
    (Index:   1; Name: 'GetDistance'; ParamType1: ptReference),
    (Index:   5; Name: 'GetLocked'),
    (Index:   6; Name: 'GetPos'; ParamType1: ptAxis),
    (Index:   8; Name: 'GetAngle'; ParamType1: ptAxis),
    (Index:  10; Name: 'GetStartingPos'; ParamType1: ptAxis),
    (Index:  11; Name: 'GetStartingAngle'; ParamType1: ptAxis),
    (Index:  12; Name: 'GetSecondsPassed'),
    (Index:  14; Name: 'GetActorValue'; ParamType1: ptActorValue),
    (Index:  18; Name: 'GetCurrentTime'),
    (Index:  24; Name: 'GetScale'),
    (Index:  25; Name: 'IsMoving'),
    (Index:  26; Name: 'IsTurning'),
    (Index:  27; Name: 'GetLineOfSight'; ParamType1: ptReference),
    (Index:  32; Name: 'GetInSameCell'; ParamType1: ptReference),
    (Index:  35; Name: 'GetDisabled'),
    (Index:  36; Name: 'MenuMode'; ParamType1: ptMenuMode),
    (Index:  39; Name: 'GetDisease'),
    (Index:  40; Name: 'GetVampire'),
    (Index:  41; Name: 'GetClothingValue'),
    (Index:  42; Name: 'SameFaction'; ParamType1: ptActor),
    (Index:  43; Name: 'SameRace'; ParamType1: ptActor),
    (Index:  44; Name: 'SameSex'; ParamType1: ptActor),
    (Index:  45; Name: 'GetDetected'; ParamType1: ptActor),
    (Index:  46; Name: 'GetDead'),
    (Index:  47; Name: 'GetItemCount'; ParamType1: ptInventoryObject),
    (Index:  48; Name: 'GetGold'),
    (Index:  49; Name: 'GetSleeping'),
    (Index:  50; Name: 'GetTalkedToPC'),
    (Index:  53; Name: 'GetScriptVariable'; ParamType1: ptReference; ParamType2: ptVariableName),
    (Index:  56; Name: 'GetQuestRunning'; ParamType1: ptQuest),
    (Index:  58; Name: 'GetStage'; ParamType1: ptQuest),
    (Index:  59; Name: 'GetStageDone'; ParamType1: ptQuest; ParamType2: ptQuestStage),
    (Index:  60; Name: 'GetFactionRankDifference'; ParamType1: ptFaction; ParamType2: ptActor),
    (Index:  61; Name: 'GetAlarmed'),
    (Index:  62; Name: 'IsRaining'),
    (Index:  63; Name: 'GetAttacked'),
    (Index:  64; Name: 'GetIsCreature'),
    (Index:  65; Name: 'GetLockLevel'),
    (Index:  66; Name: 'GetShouldAttack'; ParamType1: ptActor),
    (Index:  67; Name: 'GetInCell'; ParamType1: ptCell),
    (Index:  68; Name: 'GetIsClass'; ParamType1: ptClass),
    (Index:  69; Name: 'GetIsRace'; ParamType1: ptRace),
    (Index:  70; Name: 'GetIsSex'; ParamType1: ptSex),
    (Index:  71; Name: 'GetInFaction'; ParamType1: ptFaction),
    (Index:  72; Name: 'GetIsID'; ParamType1: ptBaseObject),
    (Index:  73; Name: 'GetFactionRank'; ParamType1: ptFaction),
    (Index:  74; Name: 'GetGlobalValue'; ParamType1: ptGlobal),
    (Index:  75; Name: 'IsSnowing'),
    (Index:  76; Name: 'GetDisposition'; ParamType1: ptActor),
    (Index:  77; Name: 'GetRandomPercent'),
    (Index:  79; Name: 'GetQuestVariable'; ParamType1: ptQuest; ParamType2: ptVariableName),
    (Index:  80; Name: 'GetLevel'),
    (Index:  81; Name: 'GetArmorRating'),
    (Index:  84; Name: 'GetDeadCount'; ParamType1: ptActorBase),
    (Index:  91; Name: 'GetIsAlerted'),
    (Index:  98; Name: 'GetPlayerControlsDisabled'; ParamType1: ptInteger; ParamType2: ptInteger{; ParamType3: ptInteger; ParamType4: ptInteger; ParamType5: ptInteger; ParamType6: ptInteger; ParamType7: ptInteger}),
    (Index:  99; Name: 'GetHeadingAngle'; ParamType1: ptReference),
    (Index: 101; Name: 'IsWeaponOut'),
    (Index: 102; Name: 'IsTorchOut'),
    (Index: 103; Name: 'IsShieldOut'),
    (Index: 106; Name: 'IsFacingUp'),
    (Index: 107; Name: 'GetKnockedState'),
    (Index: 108; Name: 'GetWeaponAnimType'),
    (Index: 109; Name: 'IsWeaponSkillType'; ParamType1: ptActorValue),
    (Index: 110; Name: 'GetCurrentAIPackage'),
    (Index: 111; Name: 'IsWaiting'),
    (Index: 112; Name: 'IsIdlePlaying'),
    (Index: 116; Name: 'GetMinorCrimeCount'),
    (Index: 117; Name: 'GetMajorCrimeCount'),
    (Index: 118; Name: 'GetActorAggroRadiusViolated'),
    (Index: 122; Name: 'GetCrime'; ParamType1: ptActor; ParamType2: ptCrimeType),
    (Index: 123; Name: 'IsGreetingPlayer'),
    (Index: 125; Name: 'IsGuard'),
    (Index: 127; Name: 'HasBeenEaten'),
    (Index: 128; Name: 'GetFatiguePercentage'),
    (Index: 129; Name: 'GetPCIsClass'; ParamType1: ptClass),
    (Index: 130; Name: 'GetPCIsRace'; ParamType1: ptRace),
    (Index: 131; Name: 'GetPCIsSex'; ParamType1: ptSex),
    (Index: 132; Name: 'GetPCInFaction'; ParamType1: ptFaction),
    (Index: 133; Name: 'SameFactionAsPC'),
    (Index: 134; Name: 'SameRaceAsPC'),
    (Index: 135; Name: 'SameSexAsPC'),
    (Index: 136; Name: 'GetIsReference'; ParamType1: ptReference),
    (Index: 141; Name: 'IsTalking'),
    (Index: 142; Name: 'GetWalkSpeed'),
    (Index: 143; Name: 'GetCurrentAIProcedure'),
    (Index: 144; Name: 'GetTrespassWarningLevel'),
    (Index: 145; Name: 'IsTrespassing'),
    (Index: 146; Name: 'IsInMyOwnedCell'),
    (Index: 147; Name: 'GetWindSpeed'),
    (Index: 148; Name: 'GetCurrentWeatherPercent'),
    (Index: 149; Name: 'GetIsCurrentWeather'; ParamType1: ptWeather),
    (Index: 150; Name: 'IsContinuingPackagePCNear'),
    (Index: 153; Name: 'CanHaveFlames'),
    (Index: 154; Name: 'HasFlames'),
    (Index: 157; Name: 'GetOpenState'),
    (Index: 159; Name: 'GetSitting'),
    (Index: 160; Name: 'GetFurnitureMarkerID'),
    (Index: 161; Name: 'GetIsCurrentPackage'; ParamType1: ptPackage),
    (Index: 162; Name: 'IsCurrentFurnitureRef'; ParamType1: ptReference),
    (Index: 163; Name: 'IsCurrentFurnitureObj'; ParamType1: ptFurniture),
    (Index: 170; Name: 'GetDayOfWeek'),
    (Index: 172; Name: 'GetTalkedToPCParam'; ParamType1: ptActor),
    (Index: 175; Name: 'IsPCSleeping'),
    (Index: 176; Name: 'IsPCAMurderer'),
    (Index: 180; Name: 'GetDetectionLevel'; ParamType1: ptActor),
    (Index: 182; Name: 'GetEquipped'; ParamType1: ptInventoryObject),
    (Index: 185; Name: 'IsSwimming'),
    (Index: 190; Name: 'GetAmountSoldStolen'),
    (Index: 192; Name: 'GetIgnoreCrime'),
    (Index: 193; Name: 'GetPCExpelled'; ParamType1: ptFaction),
    (Index: 195; Name: 'GetPCFactionMurder'; ParamType1: ptFaction),
    (Index: 197; Name: 'GetPCEnemyofFaction'; ParamType1: ptFaction),
    (Index: 199; Name: 'GetPCFactionAttack'; ParamType1: ptFaction),
    (Index: 203; Name: 'GetDestroyed'),
    (Index: 214; Name: 'HasMagicEffect'; ParamType1: ptBaseEffect),
    (Index: 215; Name: 'GetDefaultOpen'),
    (Index: 219; Name: 'GetAnimAction'),
    (Index: 223; Name: 'IsSpellTarget'; ParamType1: ptEffectItem),
    (Index: 224; Name: 'GetVATSMode'),
    (Index: 225; Name: 'GetPersuasionNumber'),
    (Index: 226; Name: 'GetSandman'),
    (Index: 227; Name: 'GetCannibal'),
    (Index: 228; Name: 'GetIsClassDefault'; ParamType1: ptClass),
    (Index: 229; Name: 'GetClassDefaultMatch'),
    (Index: 230; Name: 'GetInCellParam'; ParamType1: ptCell; ParamType2: ptReference),
    (Index: 235; Name: 'GetVatsTargetHeight'),
    (Index: 237; Name: 'GetIsGhost'),
    (Index: 242; Name: 'GetUnconscious'),
    (Index: 244; Name: 'GetRestrained'),
    (Index: 246; Name: 'GetIsUsedItem'; ParamType1: ptBaseObject),
    (Index: 247; Name: 'GetIsUsedItemType'; ParamType1: ptFormType),
    (Index: 254; Name: 'GetIsPlayableRace'),
    (Index: 255; Name: 'GetOffersServicesNow'),
    (Index: 258; Name: 'GetUsedItemLevel'),
    (Index: 259; Name: 'GetUsedItemActivate'),
    (Index: 264; Name: 'GetBarterGold'),
    (Index: 265; Name: 'IsTimePassing'),
    (Index: 266; Name: 'IsPleasant'),
    (Index: 267; Name: 'IsCloudy'),
    (Index: 274; Name: 'GetArmorRatingUpperBody'),
    (Index: 277; Name: 'GetBaseActorValue'; ParamType1: ptActorValue),
    (Index: 278; Name: 'IsOwner'; ParamType1: ptOwner),
    (Index: 280; Name: 'IsCellOwner'; ParamType1: ptCell; ParamType2: ptOwner),
    (Index: 282; Name: 'IsHorseStolen'),
    (Index: 285; Name: 'IsLeftUp'),
    (Index: 286; Name: 'IsSneaking'),
    (Index: 287; Name: 'IsRunning'),
    (Index: 288; Name: 'GetFriendHit'),
    (Index: 289; Name: 'IsInCombat'),
    (Index: 300; Name: 'IsInInterior'),
    (Index: 304; Name: 'IsWaterObject'),
    (Index: 306; Name: 'IsActorUsingATorch'),
    (Index: 309; Name: 'IsXBox'),
    (Index: 310; Name: 'GetInWorldspace'; ParamType1: ptWorldSpace),
    (Index: 312; Name: 'GetPCMiscStat'; ParamType1: ptMiscStat),
    (Index: 313; Name: 'IsActorEvil'),
    (Index: 314; Name: 'IsActorAVictim'),
    (Index: 315; Name: 'GetTotalPersuasionNumber'),
    (Index: 318; Name: 'GetIdleDoneOnce'),
    (Index: 320; Name: 'GetNoRumors'),
    (Index: 323; Name: 'WhichServiceMenu'),
    (Index: 327; Name: 'IsRidingHorse'),
    (Index: 332; Name: 'IsInDangerousWater'),
    (Index: 338; Name: 'GetIgnoreFriendlyHits'),
    (Index: 339; Name: 'IsPlayersLastRiddenHorse'),
    (Index: 353; Name: 'IsActor'),
    (Index: 354; Name: 'IsEssential'),
    (Index: 358; Name: 'IsPlayerMovingIntoNewSpace'),
    (Index: 361; Name: 'GetTimeDead'),
    (Index: 362; Name: 'GetPlayerHasLastRiddenHorse'),
    (Index: 365; Name: 'IsChild'),
    (Index: 367; Name: 'GetLastPlayerAction'),
    (Index: 368; Name: 'IsPlayerActionActive'; ParamType1: ptPlayerAction),
    (Index: 370; Name: 'IsTalkingActivatorActor'; ParamType1: ptActor),
    (Index: 372; Name: 'IsInList'; ParamType1: ptFormList),
    (Index: 382; Name: 'GetHasNote'; ParamType1: ptNote),
    (Index: 391; Name: 'GetHitLocation'),
    (Index: 392; Name: 'IsPC1stPerson'),
    (Index: 397; Name: 'GetCauseofDeath'),
    (Index: 398; Name: 'IsLimbGone'; ParamType1: ptBodyLocation),
    (Index: 399; Name: 'IsWeaponInList'; ParamType1: ptFormList),
    (Index: 403; Name: 'HasFriendDisposition'),
    (Index: 408; Name: 'GetVATSValue'; ParamType1: ptVATSValueFunction; ParamType2: ptVATSValueParam),
    (Index: 409; Name: 'IsKiller'; ParamType1: ptActor),
    (Index: 410; Name: 'IsKillerObject'; ParamType1: ptFormList),
    (Index: 411; Name: 'GetFactionCombatReaction'; ParamType1: ptFaction; ParamType2: ptFaction),
    (Index: 415; Name: 'Exists'; ParamType1: ptReference),
    (Index: 416; Name: 'GetGroupMemberCount'),
    (Index: 417; Name: 'GetGroupTargetCount'),
    (Index: 427; Name: 'GetIsVoiceType'; ParamType1: ptVoiceType),
    (Index: 428; Name: 'GetPlantedExplosive'),
    (Index: 430; Name: 'IsActorTalkingThroughActivator'),
    (Index: 431; Name: 'GetHealthPercentage'),
    (Index: 433; Name: 'GetIsObjectType'; ParamType1: ptFormType),
    (Index: 435; Name: 'GetDialogueEmotion'),
    (Index: 436; Name: 'GetDialogueEmotionValue'),
    (Index: 438; Name: 'GetIsCreatureType'; ParamType1: ptCreatureType),
    (Index: 446; Name: 'GetInZone'; ParamType1: ptEncounterZone),
    (Index: 449; Name: 'HasPerk'; ParamType1: ptPerk),
    (Index: 450; Name: 'GetFactionRelation'; ParamType1: ptActor),
    (Index: 451; Name: 'IsLastIdlePlayed'; ParamType1: ptIdleForm),
    (Index: 454; Name: 'GetPlayerTeammate'),
    (Index: 455; Name: 'GetPlayerTeammateCount'),
    (Index: 459; Name: 'GetActorCrimePlayerEnemy'),
    (Index: 460; Name: 'GetActorFactionPlayerEnemy'),
    (Index: 464; Name: 'IsPlayerGrabbedRef'; ParamType1: ptReference),
    (Index: 471; Name: 'GetDestructionStage'),
    (Index: 474; Name: 'GetIsAlignment'; ParamType1: ptAlignment),
    (Index: 478; Name: 'GetThreatRatio'; ParamType1: ptActor),
    (Index: 480; Name: 'GetIsUsedItemEquipType'; ParamType1: ptEquipType),
    (Index: 489; Name: 'GetConcussed'),
    (Index: 492; Name: 'GetMapMarkerVisible'),
    (Index: 495; Name: 'GetPermanentActorValue'; ParamType1: ptActorValue),
    (Index: 496; Name: 'GetKillingBlowLimb'),
    (Index: 500; Name: 'GetWeaponHealthPerc'),
    (Index: 503; Name: 'GetRadiationLevel'),
    (Index: 510; Name: 'GetLastHitCritical'),
    (Index: 515; Name: 'IsCombatTarget'; ParamType1: ptActor),
    (Index: 518; Name: 'GetVATSRightAreaFree'; ParamType1: ptReference),
    (Index: 519; Name: 'GetVATSLeftAreaFree'; ParamType1: ptReference),
    (Index: 520; Name: 'GetVATSBackAreaFree'; ParamType1: ptReference),
    (Index: 521; Name: 'GetVATSFrontAreaFree'; ParamType1: ptReference),
    (Index: 522; Name: 'GetIsLockBroken'),
    (Index: 523; Name: 'IsPS3'),
    (Index: 524; Name: 'IsWin32'),
    (Index: 525; Name: 'GetVATSRightTargetVisible'; ParamType1: ptReference),
    (Index: 526; Name: 'GetVATSLeftTargetVisible'; ParamType1: ptReference),
    (Index: 527; Name: 'GetVATSBackTargetVisible'; ParamType1: ptReference),
    (Index: 528; Name: 'GetVATSFrontTargetVisible'; ParamType1: ptReference),
    (Index: 531; Name: 'IsInCriticalStage'; ParamType1: ptCriticalStage),
    (Index: 533; Name: 'GetXPForNextLevel'),
    (Index: 546; Name: 'GetQuestCompleted'; ParamType1: ptQuest),
    (Index: 550; Name: 'IsGoreDisabled'),
    (Index: 555; Name: 'GetSpellUsageNum'; ParamType1: ptEffectItem),
    (Index: 557; Name: 'GetActorsInHigh'),
    (Index: 558; Name: 'HasLoaded3D'),

    // Added by FOSE:
    (Index: 1024; Name: 'GetFOSEVersion'; ),
    (Index: 1025; Name: 'GetFOSERevision'; ),
    (Index: 1028; Name: 'GetWeight'; ParamType1: ptInventoryObject; ),
    (Index: 1082; Name: 'IsKeyPressed'; ParamType1: ptInteger;),
    (Index: 1165; Name: 'GetWeaponHasScope'; ParamType1: ptInventoryObject; ),
    (Index: 1166; Name: 'IsControlPressed'; ParamType1: ptInteger; ),
    (Index: 1213; Name: 'GetFOSEBeta'; )
  );

function wbConditionDescFromIndex(aIndex: Integer): PConditionFunction;
begin
  Result := nil;

  var L := Low(wbConditionFunctions);
  var H := High(wbConditionFunctions);
  while L <= H do begin
    var I := (L + H) shr 1;
    var C := CmpW32(wbConditionFunctions[I].Index, aIndex);
    if C < 0 then
      L := I + 1
    else begin
      H := I - 1;
      if C = 0 then begin
        L := I;
        Result := @wbConditionFunctions[L];
      end;
    end;
  end;
end;

function wbConditionFunctionToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  wbConditionFunctionEditInfo: string;
begin
  Result := '';

  var Desc := wbConditionDescFromIndex(aInt);

  case aType of
    ctToStr, ctToSummary, ctToEditValue: begin
      if Assigned(Desc) then
        Result := Desc.Name
      else if aType in [ctToSummary, ctToEditValue] then
        Result := aInt.ToString
      else
        Result := '<Unknown: '+aInt.ToString+'>';
    end;

    ctToSortKey: Result := IntToHex(aInt, 8);

    ctCheck: begin
      if Assigned(Desc) then
        Result := ''
      else
        Result := '<Unknown: '+aInt.ToString+'>';
    end;
    ctEditType: Result := 'ComboBox';

    ctEditInfo: begin
      if wbConditionFunctionEditInfo = '' then begin
        with TStringList.Create do try
          for var i := Low(wbConditionFunctions) to High(wbConditionFunctions) do
            Add(wbConditionFunctions[i].Name);
          Sort;
          wbConditionFunctionEditInfo := CommaText;
        finally
          Free;
        end;
      end;
      Result := wbConditionFunctionEditInfo;
    end;
  end;
end;

function wbConditionFunctionToInt(const aString: string; const aElement: IwbElement): Int64;
begin
  for var i := Low(wbConditionFunctions) to High(wbConditionFunctions) do
    with wbConditionFunctions[i] do
      if SameText(Name, aString) then
        Exit(Index);

  Result := StrToInt64(aString);
end;

function wbConditionParam1Decider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container: IwbContainer;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  var Desc := wbConditionDescFromIndex(Container.ElementByName['Function'].NativeValue);
  if Assigned(Desc) then
    Result := Succ(Integer(Desc.ParamType1));
end;

function wbConditionParam2Decider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container: IwbContainer;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  var Desc := wbConditionDescFromIndex(Container.ElementByName['Function'].NativeValue);
  if Assigned(Desc) then
    Result := Succ(Integer(Desc.ParamType2));
end;

function wbConditionQuestStageToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Container  : IwbContainerElementRef;
  MainRecord : IwbMainRecord;
  EditInfos  : TStringList;
  Stages     : IwbContainerElementRef;
  Stage      : IwbContainerElementRef;
begin
  case aType of
    ctToEditValue, ctToSummary: Result := aInt.ToString;
    ctToStr: Result := aInt.ToString + ' <Warning: Could not resolve Parameter 1>';
    ctToSortKey: Exit(IntToHex64(aInt, 8));
    ctCheck: Result := '<Warning: Could not resolve Parameter 1>';
    ctEditInfo, ctEditType: Result := '';
  end;

  if not wbTryGetContainerRefFromUnionOrValue(aElement, Container) then
    Exit;

  if not wbTryGetMainRecord(Container.ElementByName['Parameter #1'], MainRecord) then
    Exit;

  MainRecord := MainRecord.WinningOverride;
  if MainRecord.Signature <> QUST then begin
    case aType of
      ctToStr: Result := aInt.ToString + ' <Warning: "' + MainRecord.ShortName + '" is not a Quest Record>';
      ctCheck: Result := '<Warning: "'+MainRecord.ShortName+'" is not a Quest record>';
    end;
    Exit;
  end;

  case aType of
    ctEditType: Exit('ComboBox');
    ctEditInfo: EditInfos := TStringList.Create;
  else
    EditInfos := nil;
  end;

  try
    if Supports(MainRecord.ElementByName['Stages'], IwbContainerElementRef, Stages) then begin
      for var i := 0 to Pred(Stages.ElementCount) do
        if Supports(Stages.Elements[i], IwbContainerElementRef, Stage) then begin
          var j := Stage.ElementNativeValues['INDX'];
          var s := Trim(Stage.ElementValues['Log Entries\Log Entry\CNAM']);
          var t := IntToStr(j);
          while Length(t) < 3 do
            t := '0' + t;
          if s <> '' then
            t := t + ' ' + s;
          if Assigned(EditInfos) then
            EditInfos.AddObject(t, TObject(Integer(j)))
          else if j = aInt then begin
            case aType of
              ctToStr, ctToSummary, ctToEditValue: Result := t;
              ctCheck: Result := '';
            end;
            Exit;
          end;
        end;
    end;

    case aType of
      ctToStr: Result := aInt.ToString + ' <Warning: Quest Stage not found in "' + MainRecord.Name + '">';
      ctCheck: Result := '<Warning: Quest Stage not found in "' + MainRecord.Name + '">';
      ctEditInfo: begin
        EditInfos.Sort;
        Result := EditInfos.CommaText;
      end;
    end;
  finally
    FreeAndNil(EditInfos);
  end;
end;

function wbConditionVariableNameToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Container  : IwbContainerElementRef;
  MainRecord : IwbMainRecord;
  Script     : IwbMainRecord;
  Variables  : TStringList;
  LocalVars  : IwbContainerElementRef;
  LocalVar   : IwbContainerElementRef;
begin
  case aType of
    ctToEditValue, ctToSummary: Result := aInt.ToString;
    ctToStr: Result := aInt.ToString + ' <Warning: Could not resolve Parameter 1>';
    ctToSortKey: Exit(IntToHex64(aInt, 8));
    ctCheck: Result := '<Warning: Could not resolve Parameter 1>';
    ctEditInfo, ctEditType: Result := '';
  end;

  if not wbTryGetContainerRefFromUnionOrValue(aElement, Container) then
    Exit;

  if not wbTryGetMainRecord(Container.ElementByName['Parameter #1'], MainRecord) then
    Exit;

  var BaseRecord := MainRecord.BaseRecord;
  if Assigned(BaseRecord) then
    MainRecord := BaseRecord;

  MainRecord := MainRecord.WinningOverride;

  var ScriptRef := MainRecord.RecordBySignature['SCRI'];
  if not Assigned(ScriptRef) then begin
    case aType of
      ctToStr: Result := aInt.ToString + ' <Warning: "' + MainRecord.ShortName + '" does not contain a SCRI Sub-Record>';
      ctCheck: Result := '<Warning: "'+MainRecord.ShortName+'" does not contain a SCRI subrecord>';
    end;
    Exit;
  end;

  if not Supports(ScriptRef.LinksTo, IwbMainRecord, Script) then begin
    case aType of
      ctToStr: Result := aInt.ToString + ' <Warning: "' + MainRecord.ShortName + '" does not have a valid script>';
      ctCheck: Result := '<Warning: "'+MainRecord.ShortName+'" does not have a valid script>';
    end;
    Exit;
  end;

  Script := Script.HighestOverrideOrSelf[aElement._File.LoadOrder];

  case aType of
    ctEditType: Exit('ComboBox');
    ctEditInfo: Variables := TStringList.Create;
  else
    Variables := nil;
  end;

  try
    if Supports(Script.ElementByName['Local Variables'], IwbContainerElementRef, LocalVars) then begin
      for var i := 0 to Pred(LocalVars.ElementCount) do
        if Supports(LocalVars.Elements[i], IwbContainerElementRef, LocalVar) then begin
          var j := LocalVar.ElementNativeValues['SLSD\Index'];
          var s := LocalVar.ElementNativeValues['SCVR'];
          if Assigned(Variables) then
            Variables.AddObject(s, TObject(Integer(j)))
          else if j = aInt then begin
            case aType of
              ctToStr, ctToSummary, ctToEditValue: Result := s;
              ctCheck: Result := '';
            end;
            Exit;
          end;
        end;
    end;

    case aType of
      ctToStr: Result := aInt.ToString + ' <Warning: Variable Index not found in "' + Script.Name + '">';
      ctCheck: Result := '<Warning: Variable Index not found in "' + Script.Name + '">';
      ctEditInfo: begin
        Variables.Sort;
        Result := Variables.CommaText;
      end;
    end;
  finally
    FreeAndNil(Variables);
  end;
end;

function wbConditionVariableNameToInt(const aString: string; const aElement: IwbElement): Int64;
var
  MainRecord : IwbMainRecord;
  Script     : IwbMainRecord;
  LocalVars  : IwbContainerElementRef;
  LocalVar   : IwbContainerElementRef;
begin
  Result := StrToInt64Def(aString, Low(Cardinal));
  if Result <> Low(Cardinal) then
    Exit;

  if not Assigned(aElement) then
    raise Exception.Create('aElement not specified');

  var Container := GetContainerRefFromUnionOrValue(aElement);
  if not Assigned(Container) then
    raise Exception.Create('Container not assigned');

  var Param1 := Container.ElementByName['Parameter #1'];
  if not Assigned(Param1) then
    raise Exception.Create('Could not find "Parameter #1"');

  if not Supports(Param1.LinksTo, IwbMainRecord, MainRecord) then
    raise Exception.Create('"Parameter #1" does not reference a valid main record');

  var BaseRecord := MainRecord.BaseRecord;
  if Assigned(BaseRecord) then
    MainRecord := BaseRecord;

  MainRecord := MainRecord.WinningOverride;

  var ScriptRef := MainRecord.RecordBySignature['SCRI'];
    if not Assigned(ScriptRef) then
    raise Exception.Create('"'+MainRecord.ShortName+'" does not contain a SCRI subrecord');

  if not Supports(ScriptRef.LinksTo, IwbMainRecord, Script) then
    raise Exception.Create('"'+MainRecord.ShortName+'" does not have a valid script');

  Script := Script.HighestOverrideOrSelf[aElement._File.LoadOrder];

  if Supports(Script.ElementByName['Local Variables'], IwbContainerElementRef, LocalVars) then begin
    for var i := 0 to Pred(LocalVars.ElementCount) do
      if Supports(LocalVars.Elements[i], IwbContainerElementRef, LocalVar) then begin
        var j := LocalVar.ElementNativeValues['SLSD\Index'];
        var s := LocalVar.ElementNativeValues['SCVR'];
        if SameText(s, Trim(aString)) then
          Exit(j)
      end;
  end;

  raise Exception.Create('Variable "'+aString+'" was not found in "'+MainRecord.ShortName+'"');
end;

function wbConditionVATSValueParam(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container : IwbContainer;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  Result := Container.ElementByName['Parameter #1'].NativeValue;
end;

procedure wbConditionsfterLoad(const aElement: IwbElement);
var
  Container  : IwbContainerElementRef;
begin
  if wbBeginInternalEdit then try
    if not Supports(aElement, IwbContainerElementRef, Container) then
      Exit;

    if Container.ElementCount < 1 then
      Exit;

    var TypeFlags := Container.ElementNativeValues['Type'];
    if (TypeFlags and 2) <> 0 then begin
      if Container.DataSize = 20 then
        Container.DataSize := 28;
      Container.ElementNativeValues['Type'] := TypeFlags and not 2;
      Container.ElementEditValues['Run On'] := 'Target';
    end;
  finally
    wbEndInternalEdit;
  end;
end;

function wbGenericModel(aRequired: Boolean = False; aDontShow: TwbDontShowCallback = nil): IwbRecordMemberDef;
begin
  Result :=
    wbRStructSK([0], 'Model', [
      wbString(MODL, 'Model FileName').SetRequired,
      wbByteArray(MODB, 'Unknown', 4, cpIgnore),
      wbMODT,
      wbMODS,
      wbMODD
    ], [], cpNormal, aRequired, aDontShow, True)
    .SetSummaryKey([0])
    .IncludeFlag(dfSummaryMembersNoName)
    .IncludeFlag(dfSummaryNoSortKey)
    .IncludeFlag(dfCollapsed, wbCollapseModels);
end;

function wbEPFDActorValueToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  AsCardinal : Cardinal;
  AsFloat    : Single;
begin
  AsCardinal := aInt;
  AsFloat := PSingle(@AsCardinal)^;
  aInt := Round(AsFloat);
  case aType of
    ctToStr, ctToSummary: Result := wbActorValueEnum.ToString(aInt, aElement, aType = ctToSummary);
    ctToSortKey: Result := wbActorValueEnum.ToSortKey(aInt, aElement);
    ctCheck: Result := wbActorValueEnum.Check(aInt, aElement);
    ctToEditValue: Result := wbActorValueEnum.ToEditValue(aInt, aElement);
    ctEditType: Result := 'ComboBox';
    ctEditInfo: Result := wbActorValueEnum.EditInfo[aElement].ToCommaText;
  end;
end;

function wbEPFDActorValueToInt(const aString: string; const aElement: IwbElement): Int64;
var
  AsCardinal : Cardinal;
  AsFloat    : Single;
begin
  AsFloat := wbActorValueEnum.FromEditValue(aString, aElement);
  PSingle(@AsCardinal)^ := AsFloat;
  Result := AsCardinal;
end;

function wbPerkDATAQuestStageToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Container  : IwbContainerElementRef;
  Param1     : IwbElement;
  MainRecord : IwbMainRecord;
  EditInfos  : TStringList;
  Stages     : IwbContainerElementRef;
  Stage      : IwbContainerElementRef;
  i, j       : Integer;
  s, t       : string;
begin
  case aType of
    ctToStr, ctToSummary: begin
      Result := aInt.ToString;
      if aType = ctToStr then
        Result := Result + ' <Warning: Could not resolve Quest>';
    end;
    ctToEditValue: Result := aInt.ToString;
    ctToSortKey: begin
      Result := IntToHex64(aInt, 8);
      Exit;
    end;
    ctCheck: Result := '<Warning: Could not resolve Quest>';
    ctEditType: Result := '';
    ctEditInfo: Result := '';
  end;

  if not wbTryGetContainerRefFromUnionOrValue(aElement, Container) then
    Exit;

  Param1 := Container.ElementByName['Quest'];
  if not wbTryGetMainRecord(Param1, MainRecord) then
    Exit;

  MainRecord := MainRecord.WinningOverride;

  if MainRecord.Signature <> QUST then begin
    case aType of
      ctToStr, ctToSummary: begin
        Result := aInt.ToString;
        if aType = ctToStr then
          Result := Result + ' <Warning: "'+MainRecord.ShortName+'" is not a Quest record>';
      end;
      ctCheck: Result := '<Warning: "'+MainRecord.ShortName+'" is not a Quest record>';
    end;
    Exit;
  end;

  case aType of
    ctEditType: begin
      Result := 'ComboBox';
      Exit;
    end;
    ctEditInfo:
      EditInfos := TStringList.Create;
  else
    EditInfos := nil;
  end;
  try
    if Supports(MainRecord.ElementByName['Stages'], IwbContainerElementRef, Stages) then begin
      for i := 0 to Pred(Stages.ElementCount) do
        if Supports(Stages.Elements[i], IwbContainerElementRef, Stage) then begin
          j := Stage.ElementNativeValues['INDX'];
          s := Trim(Stage.ElementValues['Log Entries\Log Entry\CNAM']);
          t := IntToStr(j);
          while Length(t) < 3 do
            t := '0' + t;
          if s <> '' then
            t := t + ' ' + s;
          if Assigned(EditInfos) then
            EditInfos.AddObject(t, TObject(j))
          else if j = aInt then begin
            case aType of
              ctToStr, ctToSummary, ctToEditValue: Result := t;
              ctCheck: Result := '';
            end;
            Exit;
          end;
        end;
    end;

    case aType of
      ctToStr, ctToSummary: begin
        Result := aInt.ToString;
        if aType = ctToStr then
          Result := Result + ' <Warning: Quest Stage not found in "' + MainRecord.Name + '">';
      end;
      ctCheck: Result := '<Warning: Quest Stage not found in "' + MainRecord.Name + '">';
      ctEditInfo: begin
        EditInfos.Sort;
        Result := EditInfos.CommaText;
      end;
    end;
  finally
    FreeAndNil(EditInfos);
  end;
end;

function wbStringToInt(const aString: string; const aElement: IwbElement): Int64;
begin
  Result := StrToIntDef(aString, 0);
end;

procedure wbHeadPartsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  Container : IwbContainerElementRef;
begin
  if wbBeginInternalEdit(True) then try
    if Supports(aElement, IwbContainerElementRef, Container) then
      if (Container.Elements[0].NativeValue = 1) and (Container.ElementCount > 2) then
        Container.RemoveElement(1);
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbMESGDNAMAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  OldValue, NewValue : Integer;
  Container          : IwbContainerElementRef;
begin
  if VarSameValue(aOldValue, aNewValue) then
    Exit;

  if not Supports(aElement.Container, IwbContainerElementRef, Container) then
    Exit;

  OldValue := Integer(aOldValue) and 1;
  NewValue := Integer(aNewValue) and 1;

  if NewValue = OldValue then
    Exit;

  if NewValue = 1 then
    Container.RemoveElement('TNAM')
  else
    Container.Add('TNAM', True);
end;

procedure wbGMSTEDIDAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  OldValue, NewValue : string;
  Container          : IwbContainerElementRef;
begin
  if VarSameValue(aOldValue, aNewValue) then
    Exit;

  if not Supports(aElement.Container, IwbContainerElementRef, Container) then
    Exit;

  OldValue := aOldValue;
  NewValue := aNewValue;

  if (Length(OldValue) < 1) or (Length(OldValue) < 1) or (OldValue[1] <> NewValue[1]) then begin
    Container.RemoveElement('DATA');
    Container.Add('DATA', True);
  end;
end;

procedure wbFLSTEDIDAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  OldValue, NewValue     : string;
  OldOrdered, NewOrdered : Boolean;
  Container              : IwbContainerElementRef;
const
  OrderedList = 'OrderedList';
begin
  if VarSameValue(aOldValue, aNewValue) then
    Exit;

  if not Supports(aElement.Container, IwbContainerElementRef, Container) then
    Exit;

  OldValue := aOldValue;
  NewValue := aNewValue;

  if Length(OldValue) > Length(OrderedList) then
    Delete(OldValue, 1, Length(OldValue)-Length(OrderedList));

  if Length(NewValue) > Length(OrderedList) then
    Delete(NewValue, 1, Length(NewValue)-Length(OrderedList));

  OldOrdered := SameText(OldValue, OrderedList);
  NewOrdered := SameText(NewValue, OrderedList);

  if OldOrdered <> NewOrdered then
    Container.RemoveElement('FormIDs');
end;

function wbIdleAnam(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
begin
  Result := '';
  case aType of
    ctToStr, ctToSummary: begin
      case aInt and not $C0 of
        0: Result := 'Idle';
        1: Result := 'Movement';
        2: Result := 'Left Arm';
        3: Result := 'Left Hand';
        4: Result := 'Weapon';
        5: Result := 'Weapon Up';
        6: Result := 'Weapon Down';
        7: Result := 'Special Idle';
       20: Result := 'Whole Body';
       21: Result := 'Upper Body';
      else
        Result := '<Unknown: '+IntToStr(aInt and not $C0)+'>';
      end;

      if (aInt and $80) = 0 then
        Result := Result + ', Must return a file';
      if (aInt and $40) = 1 then
        Result := Result + ', Unknown Flag';
    end;
    ctToSortKey: begin
      Result := IntToHex64(aInt, 2);
    end;
    ctCheck: begin
      case aInt and not $C0 of
        0..7, 20, 21: Result := '';
      else
        Result := '<Unknown: '+IntToStr(aInt and not $C0)+'>';
      end;
    end;
  end;
end;

function wbNOTETNAMDecide(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  rDATA: IwbRecord;
begin
  Result := 0;
  if not Assigned(aElement) then
    Exit;
  rDATA := aElement.Container.RecordBySignature[DATA];
  if Assigned(rDATA) then
    if rDATA.NativeValue = 3 then //Voice
      Result := 1;
end;

function wbNOTESNAMDecide(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  rDATA: IwbRecord;
begin
  Result := 0;
  if not Assigned(aElement) then
    Exit;
  rDATA := aElement.Container.RecordBySignature[DATA];
  if Assigned(rDATA) then
    if rDATA.NativeValue = 3 then //Voice
      Result := 1;
end;

function wbIPDSDATACount(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  if Assigned(aBasePtr) and Assigned(aEndPtr) then
    Result := (NativeUInt(aBasePtr) - NativeUInt(aBasePtr)) div 4
  else
    Result := 12;
end;

function wbNAVINAVMGetCount1(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  DataContainer : IwbDataContainer;
begin
  Result := 0;

  if Supports(aElement, IwbDataContainer, DataContainer) then begin
    if DataContainer.ElementType = etArray then
      if not Supports(DataContainer.Container, IwbDataContainer, DataContainer) then
        Exit;
    Assert(DataContainer.Name = 'Data');
    Result := PWord(NativeUInt(DataContainer.DataBasePtr) + 3*3*4)^;
  end;
end;

function wbNAVINAVMGetCount2(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  DataContainer : IwbDataContainer;
begin
  Result := 0;

  if Supports(aElement, IwbDataContainer, DataContainer) then begin
    if DataContainer.ElementType = etArray then
      if not Supports(DataContainer.Container, IwbDataContainer, DataContainer) then
        Exit;
    Assert(DataContainer.Name = 'Data');
    Result := PWord(NativeUInt(DataContainer.DataBasePtr) + 3*3*4 + 2)^;
  end;
end;

function wbMGEFFAssocItemDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container     : IwbContainer;
  Archtype      : Variant;
  DataContainer : IwbDataContainer;
  Element       : IwbElement;
const
  OffsetArchtype = 56;

begin
  Result := 1;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  VarClear(ArchType);
  Element := Container.ElementByName['Archtype'];

  if Assigned(Element) then
    ArchType := Element.NativeValue
  else if Supports(Container, IwbDataContainer, DataContainer) and
          DataContainer.IsValidOffset(aBasePtr, aEndPtr, OffsetArchtype) then begin // we are part a proper structure
      aBasePtr := PByte(aBasePtr) + OffsetArchtype;
      ArchType := PCardinal(aBasePtr)^;
    end;

  if VarIsEmpty(ArchType) then
    Exit;

  case Integer(ArchType) of
    01: Result := 2;//Script
    18: Result := 3;//Bound Item
    19: Result := 4;//Summon Creature
  else
    Result := 0;
  end;
end;

procedure wbMGEFAssocItemAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  Container : IwbContainer;
  Element   : IwbElement;
begin
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  if not (aNewValue <> 0) then
    Exit;

  Element := Container.ElementByName['Archtype'];
  if Assigned(Element) and Element.NativeValue = 0 then
      Element.NativeValue := $FF; // Signals ArchType that it should not mess with us on the next change!
end;

procedure wbMGEFArchtypeAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  Container: IwbContainerElementRef;
begin
  if VarSameValue(aOldValue, aNewValue) then
    Exit;

  if not Supports(aElement, IwbContainerElementRef, Container) then
    Exit;

  if (aNewValue < $FF) and (aOldValue < $FF) then begin
    Container.ElementNativeValues['..\Assoc. Item'] := 0;
    case Integer(aNewValue) of
      11: Container.ElementNativeValues['..\Actor Value'] := 48;//Invisibility
      12: Container.ElementNativeValues['..\Actor Value'] := 49;//Chameleon
      24: Container.ElementNativeValues['..\Actor Value'] := 47;//Paralysis
    else
      Container.ElementNativeValues['..\Actor Value'] := -1;
    end;
  end;
end;

procedure wbCounterEffectsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterByPathAfterSet('DATA - Data\Counter effect count', aElement);
end;

procedure wbMGEFAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterContainerByPathAfterSet('DATA - Data\Counter effect count', 'Counter Effects', aElement);
end;

function wbNAVINVMIDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container     : IwbContainer;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  case Integer(Container.ElementNativeValues['Type']) of
    $00: Result :=1;
    $20: Result :=2;
    $30: Result :=3;
  end;
end;

function wbCreaLevelDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container: IwbContainer;
  i: Int64;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  i := Container.ElementByName['Flags'].NativeValue;
  if i and $00000080 <> 0 then
    Result := 1;
end;

function wbFLSTLNAMIsSorted(const aContainer: IwbContainer): Boolean;
var
  rEDID      : IwbRecord;
  s          : string;
  _File      : IwbFile;
  MainRecord : IwbMainRecord;
const
  OrderedList = 'OrderedList';
begin
  Result := wbSortFLST; {>>> Should not be sorted according to Arthmoor and JustinOther, left as sorted for compatibility <<<}
  if Result then begin
    rEDID := aContainer.RecordBySignature[EDID];
    if Assigned(rEDID) then begin
      s := rEDID.Value;
      if Length(s) > Length(OrderedList) then
        Delete(s, 1, Length(s)-Length(OrderedList));

      if SameText(s, OrderedList) then
        Result := False;
    end;
  end;
  if Result then begin
    MainRecord := aContainer.ContainingMainRecord;
    if not Assigned(MainRecord) then
      Exit;
    MainRecord := MainRecord.MasterOrSelf;
    if not Assigned(MainRecord) then
      Exit;
    _File := MainRecord._File;
    if not Assigned(_File) then
      Exit;
    if not SameText(_File.FileName, 'WeaponModKits.esp') then
      Exit;
    case MainRecord.FormID.ObjectID of
      $0130EB, $0130ED, $01522D, $01522E, $0158D5, $0158D6, $0158D7, $0158D8, $0158D9, $0158DA, $0158DC, $0158DD, $018E20:
        Result := False;
    end;
  end;
end;

function wbPerkDATADecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  rPRKE: IwbRecord;
  eType: IwbElement;
begin
  Result := 0;
  if not Assigned(aElement) then
    Exit;
  rPRKE := aElement.Container.RecordBySignature[PRKE];
  if not Assigned(rPRKE) then
    Exit;

  eType := rPRKE.ElementByName['Type'];
  if not Assigned(eType) then
    Exit;

  Result := eType.NativeValue;
end;

function wbEPFDDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container: IwbContainerElementRef;
begin
  Result := 0;
  if not Assigned(aElement) then
    Exit;

  if not Supports(aElement.Container, IwbContainerElementRef, Container) then
    Exit;

  Result := Container.ElementNativeValues['EPFT'];

  if Result = 2 then
    if Integer(Container.ElementNativeValues['..\DATA\Entry Point\Function']) = 5 then
      Result := 5;
end;

type
  TPERKEntryPointConditionType = (
    epcDefault,
    epcItem,
    epcWeapon,
    epcWeaponTarget,
    epcTarget,
    epcAttacker,
    epcAttackerAttackee,
    epcAttackerAttackerWeapon
  );

  TPERKEntryPointFunctionType = (
    epfFloat,
    epfLeveledItem,
    epfScript,
    epfUnknown
  );

  TPERKEntryPointFunctionParamType = (
    epfpNone,
    epfpFloat,
    epfpFloatFloat,
    epfpLeveledItem,
    epfpScript
  );

  PPERKEntryPoint = ^TPERKEntryPoint;
  TPERKEntryPoint = record
    Name         : string;
    Condition   : TPERKEntryPointConditionType;
    FunctionType : TPERKEntryPointFunctionType;
  end;

  PPERKCondition = ^TPERKCondition;
  TPERKCondition = record
    Count    : Integer;
    Caption1 : string;
    Caption2 : string;
    Caption3 : string;
  end;

  PPERKFunction = ^TPERKFunction;
  TPERKFunction = record
    Name         : string;
    FunctionType : TPERKEntryPointFunctionType;
    ParamType    : TPERKEntryPointFunctionParamType;
  end;

const
  wbPERKCondition : array[TPERKEntryPointConditionType] of TPERKCondition = (
    (Count: 1; Caption1: 'Perk Owner'),
    (Count: 2; Caption1: 'Perk Owner'; Caption2: 'Item'),
    (Count: 2; Caption1: 'Perk Owner'; Caption2: 'Weapon'),
    (Count: 3; Caption1: 'Perk Owner'; Caption2: 'Weapon'; Caption3: 'Target'),
    (Count: 2; Caption1: 'Perk Owner'; Caption2: 'Target'),
    (Count: 2; Caption1: 'Perk Owner'; Caption2: 'Attacker'),
    (Count: 3; Caption1: 'Perk Owner'; Caption2: 'Attacker'; Caption3: 'Attackee'),
    (Count: 3; Caption1: 'Perk Owner'; Caption2: 'Attacker'; Caption3: 'Attacker Weapon')
  );

  wbPERKFunctions : array[0..9] of TPERKFunction = (
    (Name: ''; FunctionType: epfUnknown; ParamType: epfpNone),
    (Name: 'Set Value'; FunctionType: epfFloat; ParamType: epfpFloat),
    (Name: 'Add Value'; FunctionType: epfFloat; ParamType: epfpFloat),
    (Name: 'Multiply Value'; FunctionType: epfFloat; ParamType: epfpFloat),
    (Name: 'Add Range To Value'; FunctionType: epfFloat; ParamType: epfpFloatFloat),
    (Name: 'Add Actor Value Mult'; FunctionType: epfFloat; ParamType: epfpFloatFloat),
    (Name: ''; FunctionType: epfUnknown; ParamType: epfpNone),
    (Name: ''; FunctionType: epfUnknown; ParamType: epfpNone),
    (Name: 'Add Leveled List'; FunctionType: epfLeveledItem; ParamType: epfpLeveledItem),
    (Name: 'Add Activate Choice'; FunctionType: epfScript; ParamType: epfpScript)
  );

  wbPERKEntryPoints : array[0..36] of TPERKEntryPoint = (
    (Name: 'Calculate Weapon Damage'; Condition: epcWeaponTarget),
    (Name: 'Calculate My Critical Hit Chance'; Condition: epcWeaponTarget),
    (Name: 'Calculate My Critical Hit Damage'; Condition: epcWeaponTarget),
    (Name: 'Calculate Weapon Attack AP Cost'; Condition: epcWeapon),
    (Name: 'Calculate Mine Explode Chance'; Condition: epcItem),
    (Name: 'Adjust Range Penalty'; Condition: epcWeapon),
    (Name: 'Adjust Limb Damage'; Condition: epcAttackerAttackerWeapon),
    (Name: 'Calculate Weapon Range'; Condition: epcWeapon),
    (Name: 'Calculate To Hit Chance'; Condition: epcWeaponTarget),
    (Name: 'Adjust Experience Points'),
    (Name: 'Adjust Gained Skill Points'),
    (Name: 'Adjust Book Skill Points'),
    (Name: 'Modify Recovered Health'),
    (Name: 'Calculate Inventory AP Cost'),
    (Name: 'Get Disposition'; Condition: epcTarget),
    (Name: 'Get Should Attack'; Condition: epcAttacker),
    (Name: 'Get Should Assist'; Condition: epcAttackerAttackee),
    (Name: 'Calculate Buy Price'; Condition: epcItem),
    (Name: 'Get Bad Karma'),
    (Name: 'Get Good Karma'),
    (Name: 'Ignore Locked Terminal'),
    (Name: 'Add Leveled List On Death'; Condition: epcTarget; FunctionType: epfLeveledItem),
    (Name: 'Get Max Carry Weight'),
    (Name: 'Modify Addiction Chance'),
    (Name: 'Modify Addiction Duration'),
    (Name: 'Modify Positive Chem Duration'),
    (Name: 'Adjust Drinking Radiation'),
    (Name: 'Activate'; Condition: epcTarget; FunctionType: epfScript),
    (Name: 'Mysterious Stranger'),
    (Name: 'Has Paralyzing Palm'),
    (Name: 'Hacking Science Bonus'),
    (Name: 'Ignore Running During Detection'),
    (Name: 'Ignore Broken Lock'),
    (Name: 'Has Concentrated Fire'),
    (Name: 'Calculate Gun Spread'; Condition: epcWeapon),
    (Name: 'Player Kill AP Reward'; Condition: epcWeaponTarget),
    (Name: 'Modify Enemy Critical Hit Chance'; Condition: epcWeaponTarget)
  );

  wbPERKFunctionParams: array[TPERKEntryPointFunctionParamType] of string = (
    'None',
    'Float',
    'Float, Float',
    'Leveled Item',
    'Script'
  );

procedure wbPERKEntryPointAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  OldEntryPoint   : PPERKEntryPoint;
  NewEntryPoint   : PPERKEntryPoint;
  OldCondition    : PPERKCondition;
  NewCondition    : PPERKCondition;
  OldFunction     : PPERKFunction;
  EntryPoint      : IwbContainerElementRef;
  Effect          : IwbContainerElementRef;
  PerkConditions  : IwbContainerElementRef;
  PerkCondition   : IwbContainerElementRef;
  Container       : IwbContainerElementRef;
  i               : Integer;
begin
  if aOldValue <> aNewValue then begin
    OldEntryPoint := @wbPERKEntryPoints[Integer(aOldValue)];
    NewEntryPoint := @wbPERKEntryPoints[Integer(aNewValue)];
    OldCondition := @wbPERKCondition[OldEntryPoint.Condition];
    NewCondition := @wbPERKCondition[NewEntryPoint.Condition];

    if not Assigned(aElement) then
      Exit;

    if not Supports(aElement.Container, IwbContainerElementRef, EntryPoint) then
      Exit;

    i := EntryPoint.ElementNativeValues['Function'];
    if (i >= Low(wbPERKFunctions)) and (i <= High(wbPERKFunctions)) then
      OldFunction := @wbPERKFunctions[i]
    else
      OldFunction := nil;

    if not Assigned(OldFunction) or (OldFunction.FunctionType <> NewEntryPoint.FunctionType) then
      for i := Low(wbPERKFunctions) to High(wbPERKFunctions) do
        with wbPERKFunctions[i] do
          if FunctionType = NewEntryPoint.FunctionType then begin
            EntryPoint.ElementNativeValues['Function'] := i;
            Break;
          end;

    EntryPoint.ElementNativeValues['Perk Condition Tab Count'] := NewCondition.Count;

    if not Supports(EntryPoint.Container, IwbContainerElementRef, Container) then
      Exit;

    if not Supports(Container.Container, IwbContainerElementRef, Effect) then
      Exit;

    if not Supports(Effect.ElementByName['Perk Conditions'], IwbContainerElementRef, PerkConditions) then
      Exit;

    for i := Pred(PerkConditions.ElementCount) downto 0 do
      if Supports(PerkConditions.Elements[i], IwbContainerElementRef, PerkCondition) then
        if Integer(PerkCondition.ElementNativeValues['PRKC']) >= NewCondition.Count then
          PerkCondition.Remove
        else
          case Integer(PerkCondition.ElementNativeValues['PRKC']) of
            2: if OldCondition.Caption2 <> NewCondition.Caption2 then
                 PerkCondition.Remove;
            3: if OldCondition.Caption3 <> NewCondition.Caption3 then
                 PerkCondition.Remove;
          end;
  end;
end;

function wbPRKCToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Container     : IwbContainerElementRef;
  EntryPointVar : Variant;
  EntryPoint    : Integer;
begin
  case aType of
    ctToStr, ctToSummary:
    begin
      Result := aInt.ToString;
      if aType = ctToStr then
        Result := Result + ' <Warning: Could not resolve Entry Point>';
    end;
    ctToEditValue: Result := aInt.ToString;
    ctToSortKey:
    begin
      Result := IntToHex64(aInt, 2);
      Exit;
    end;
    ctCheck: Result := '<Warning: Could not resolve Entry Point>';
    ctEditType: Result := '';
    ctEditInfo: Result := '';
  end;

  if not Supports(aElement, IwbContainerElementRef, Container) then
    Exit;

  EntryPointVar := Container.ElementNativeValues['..\..\..\DATA\Entry Point\Entry Point'];
  if VarIsNull(EntryPointVar) or VarIsClear(EntryPointVar) then
    Exit;

  EntryPoint := EntryPointVar;
  if (EntryPoint < Low(wbPERKEntryPoints)) or (EntryPoint > High(wbPERKEntryPoints)) then begin
    case aType of
      ctToStr, ctToSummary: begin
        Result := aInt.ToString;
        if aType = ctToStr then
          Result := Result + ' <Warning: Unknown Entry Point #'+IntToStr(EntryPoint)+'>';
      end;
      ctCheck: Result := '<Warning: Unknown Entry Point #'+IntToStr(EntryPoint)+'>';
    end;
    Exit;
  end;

  with wbPERKEntryPoints[EntryPoint] do begin
    with wbPERKCondition[Condition] do begin
      case aType of
        ctEditType: Result := 'ComboBox';
        ctEditInfo: with TStringList.Create do try
          if Caption1 <> '' then
            Add(Caption1);
          if Caption2 <> '' then
            Add(Caption2);
          if Caption3 <> '' then
            Add(Caption3);
          Sort;
          Result := CommaText;
        finally
          Free;
        end;
      else
        if (aInt < 0) or (aInt >= Count) then
          case aType of
            ctToStr, ctToSummary: begin
              Result := aInt.ToString;
              if aType = ctToStr then
                Result := Result + ' <Warning: Value out of Bounds for this Entry Point>';
            end;
            ctCheck: Result := '<Warning: Value out of Bounds for this Entry Point>';
          end
        else
          case aType of
            ctToStr, ctToSummary, ctToEditValue: case Integer(aInt) of
              0: Result := Caption1;
              1: Result := Caption2;
              2: Result := Caption3;
            end;
            ctCheck: Result := '';
          end;
      end;
    end;
  end;
end;

function wbPRKCToInt(const aString: string; const aElement: IwbElement): Int64;
var
  Container     : IwbContainerElementRef;
  EntryPointVar : Variant;
  EntryPoint    : Integer;
  s             : string;
begin
  s := Trim(aString);

  Result := StrToInt64Def(s, Low(Integer));
  if Result <> Low(Integer) then
    Exit;

  if s = '' then begin
    Result := 0;
    Exit;
  end;

  if not Supports(aElement, IwbContainerElementRef, Container) then
    raise Exception.Create('Could not resolve Entry Point');

  EntryPointVar := Container.ElementNativeValues['..\..\..\DATA\Entry Point\Entry Point'];
  if VarIsNull(EntryPointVar) or VarIsClear(EntryPointVar) then
    raise Exception.Create('Could not resolve Entry Point');

  EntryPoint := EntryPointVar;
  if (EntryPoint < Low(wbPERKEntryPoints)) or (EntryPoint > High(wbPERKEntryPoints)) then
    raise Exception.Create('Unknown Entry Point #'+IntToStr(EntryPoint));

  with wbPERKEntryPoints[EntryPoint] do
    with wbPERKCondition[Condition] do
      if SameText(aString, Caption1) then
        Result := 0
      else if SameText(aString, Caption2) then
        Result := 1
      else if SameText(aString, Caption3) then
        Result := 2
      else
        raise Exception.Create('"'+s+'" is not valid for this Entry Point');
end;

function wbMESGTNAMDontShow(const aElement: IwbElement): Boolean;
var
  Container  : IwbContainerElementRef;
  MainRecord : IwbMainRecord;
begin
  Result := False;
  if not Supports(aElement, IwbMainRecord, MainRecord) then
    Exit;

  if not Supports(aElement, IwbContainerElementRef, Container) then
    Exit;

  if Integer(Container.ElementNativeValues['DNAM']) and 1 <> 0 then
    Result := True;
end;

function wbEPFDDontShow(const aElement: IwbElement): Boolean;
var
  Container: IwbContainerElementRef;
begin
  Result := False;
  if aElement.Name <> 'Entry Point Function Parameters' then
    Exit;

  if not Supports(aElement, IwbContainerElementRef, Container) then
    Exit;

  if not (Integer(Container.ElementNativeValues['EPFT']) in [1..3]) then
    Result := True;
end;

function wbTES4ONAMDontShow(const aElement: IwbElement): Boolean;
var
  MainRecord : IwbMainRecord;
begin
  Result := False;
  if not Assigned(aElement) then
    Exit;

  MainRecord := aElement.ContainingMainRecord;
  if not Assigned(MainRecord) then
    Exit;

  if not MainRecord.IsESM then
    Result := True;
end;


function wbEPF2DontShow(const aElement: IwbElement): Boolean;
var
  Container: IwbContainerElementRef;
begin
  Result := False;
  if aElement.Name <> 'Entry Point Function Parameters' then
    Exit;

  if not Supports(aElement, IwbContainerElementRef, Container) then
    Exit;

  if not (Integer(Container.ElementNativeValues['EPFT']) in [4]) then
    Result := True;
end;

function wbPERKPRKCDontShow(const aElement: IwbElement): Boolean;
var
  Container: IwbContainerElementRef;
begin
  Result := False;
  if aElement.Name <> 'Effect' then
    Exit;

  if not Supports(aElement, IwbContainerElementRef, Container) then
    Exit;

  if Integer(Container.ElementNativeValues['PRKE\Type']) <> 2 then
    Result := True;
end;

function wbPerkDATAFunctionToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Container     : IwbContainerElementRef;
  EntryPointVar : Variant;
  EntryPoint    : Integer;
  i             : Integer;
begin
  case aType of
    ctToStr, ctToSummary: begin
      Result := aInt.ToString;
      if aType = ctToStr then
        Result := Result + ' <Warning: Could not resolve Entry Point>';
    end;
    ctToEditValue: Result := aInt.ToString;
    ctToSortKey: begin
      Result := IntToHex64(aInt, 2);
      Exit;
    end;
    ctCheck: Result := '<Warning: Could not resolve Entry Point>';
    ctEditType: Result := '';
    ctEditInfo: Result := '';
  end;

  if not Supports(aElement, IwbContainerElementRef, Container) then
    Exit;

  EntryPointVar := Container.ElementNativeValues['..\Entry Point'];
  if VarIsNull(EntryPointVar) or VarIsClear(EntryPointVar) then
    Exit;

  EntryPoint := EntryPointVar;
  if (EntryPoint < Low(wbPERKEntryPoints)) or (EntryPoint > High(wbPERKEntryPoints)) then begin
    case aType of
      ctToStr, ctToSummary: begin
        Result := aInt.ToString;
        if aType = ctToStr then
          Result := Result + ' <Warning: Unknown Entry Point #'+IntToStr(EntryPoint)+'>';
      end;
      ctCheck: Result := '<Warning: Unknown Entry Point #'+IntToStr(EntryPoint)+'>';
    end;
    Exit;
  end;

  with wbPERKEntryPoints[EntryPoint] do begin
    case aType of
      ctEditType: Result := 'ComboBox';
      ctEditInfo: with TStringList.Create do try
        for i := Low(wbPERKFunctions) to High(wbPERKFunctions) do
          if wbPERKFunctions[i].FunctionType = FunctionType then
            if (wbPERKFunctions[i].Name <> '') then
              Add(wbPERKFunctions[i].Name);
        Sort;
        Result := CommaText;
      finally
        Free;
      end;
    else
      if (aInt < Low(wbPERKFunctions)) or (aInt > High(wbPERKFunctions)) then
        case aType of
          ctToStr, ctToSummary: begin
            Result := aInt.ToString;
            if aType = ctToStr then
              Result := Result + ' <Warning: Unknown Function>';
          end;
          ctCheck: Result := '<Warning: Unknown Function>';
        end
      else
        case aType of
          ctToStr, ctToSummary, ctToEditValue: begin
            Result := wbPERKFunctions[Integer(aInt)].Name;
            if (aType = ctToStr) and (wbPERKFunctions[Integer(aInt)].FunctionType <> FunctionType) then
              Result := Result + ' <Warning: Value out of Bounds for this Entry Point>';
          end;
          ctCheck:
            if wbPERKFunctions[Integer(aInt)].FunctionType <> FunctionType then
              Result := '<Warning: Value out of Bounds for this Entry Point>'
            else
              Result := '';
        end;
    end;
  end;
end;

function wbPerkDATAFunctionToInt(const aString: string; const aElement: IwbElement): Int64;
var
  Container     : IwbContainerElementRef;
  EntryPointVar : Variant;
  EntryPoint    : Integer;
  s             : string;
  i             : Integer;
begin
  s := Trim(aString);

  Result := StrToInt64Def(s, Low(Integer));
  if Result <> Low(Integer) then
    Exit;

  if s = '' then
    raise Exception.Create('"" is not a valid value for this field');

  if not Supports(aElement, IwbContainerElementRef, Container) then
    raise Exception.Create('Could not resolve Entry Point');

  EntryPointVar := Container.ElementNativeValues['..\Entry Point'];
  if VarIsNull(EntryPointVar) or VarIsClear(EntryPointVar) then
    raise Exception.Create('Could not resolve Entry Point');

  EntryPoint := EntryPointVar;
  if (EntryPoint < Low(wbPERKEntryPoints)) or (EntryPoint > High(wbPERKEntryPoints)) then
    raise Exception.Create('Unknown Entry Point #'+IntToStr(EntryPoint));

  with wbPERKEntryPoints[EntryPoint] do
    for i := Low(wbPERKFunctions) to High(wbPERKFunctions) do
      if wbPERKFunctions[i].FunctionType = FunctionType then
        if SameText(s, wbPERKFunctions[i].Name) then begin
          Result := i;
          Exit;
        end;

  raise Exception.Create('"'+s+'" is not valid for this Entry Point');
end;

procedure wbPerkDATAFunctionAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  NewFunction : Integer;
  Container   : IwbContainerElementRef;
  OldParamType: Integer;
  NewParamType: Integer;
begin
  NewFunction := aNewValue;
  if (NewFunction < Low(wbPERKFunctions)) or (NewFunction > High(wbPERKFunctions)) then
    Exit;

  if not Supports(aElement, IwbContainerElementRef, Container) then
    Exit;

  OldParamType := Container.ElementNativeValues['..\..\..\Entry Point Function Parameters\EPFT'];
  NewParamType := Ord(wbPERKFunctions[NewFunction].ParamType);

  if (OldParamType = NewParamType) and not VarSameValue(aOldValue, aNewValue) and (NewFunction in [4,5]) then
    Container.ElementNativeValues['..\..\..\Entry Point Function Parameters\EPFT'] := 0;

  Container.ElementNativeValues['..\..\..\Entry Point Function Parameters\EPFT'] := NewParamType;
end;

function wbPerkEPFTToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Container       : IwbContainerElementRef;
  FunctionTypeVar : Variant;
  FunctionType    : Integer;
//  i               : Integer;
begin
  case aType of
    ctToStr, ctToSummary: begin
      Result := aInt.ToString;
      if aType = ctToStr then
        Result := Result + ' <Warning: Could not resolve Function>';
    end;
    ctToEditValue: Result := aInt.ToString;
    ctToSortKey: begin
      Result := IntToHex64(aInt, 2);
      Exit;
    end;
    ctCheck: Result := '<Warning: Could not resolve Function>';
    ctEditType: Result := '';
    ctEditInfo: Result := '';
  end;

  if not Supports(aElement, IwbContainerElementRef, Container) then
    Exit;

  FunctionTypeVar := Container.ElementNativeValues['..\..\DATA\Entry Point\Function'];
  if VarIsNull(FunctionTypeVar) or VarIsClear(FunctionTypeVar) then
    Exit;

  FunctionType := FunctionTypeVar;
  if (FunctionType < Low(wbPERKFunctions)) or (FunctionType > High(wbPERKFunctions)) then begin
    case aType of
      ctToStr, ctToSummary: begin
        Result := aInt.ToString;
        if aType = ctToStr then
          Result := Result + ' <Warning: Unknown Function #'+IntToStr(FunctionType)+'>';
      end;
      ctCheck: Result := '<Warning: Unknown Function #'+IntToStr(FunctionType)+'>';
    end;
    Exit;
  end;

  with wbPERKFunctions[FunctionType] do begin
    case aType of
      ctEditType: Result := 'ComboBox';
      ctEditInfo: Result := '"' + wbPERKFunctionParams[ParamType] + '"';
    else
      if (aInt < Ord(Low(wbPERKFunctionParams))) or (aInt > Ord(High(wbPERKFunctionParams))) then
        case aType of
          ctToStr, ctToSummary: begin
            Result := aInt.ToString;
            if aType = ctToStr then
              Result := Result + ' <Warning: Unknown Function Param Type>';
          end;
          ctCheck: Result := '<Warning: Unknown Function Param Type>';
        end
      else
        case aType of
          ctToStr, ctToSummary, ctToEditValue: begin
            Result := wbPERKFunctionParams[TPERKEntryPointFunctionParamType(aInt)];
            if (aType = ctToStr) and (TPERKEntryPointFunctionParamType(aInt) <> ParamType) then
              Result := Result + ' <Warning: Value out of Bounds for this Function>';
          end;
          ctCheck:
            if TPERKEntryPointFunctionParamType(aInt) <> ParamType then
              Result := Result + ' <Warning: Value out of Bounds for this Function>'
            else
              Result := '';
        end;
    end;
  end;
end;

function wbPerkEPFTToInt(const aString: string; const aElement: IwbElement): Int64;
var
  Container       : IwbContainerElementRef;
  FunctionTypeVar : Variant;
  FunctionType    : Integer;
  s               : string;
//  i               : Integer;
  j               : TPERKEntryPointFunctionParamType;
begin
  s := Trim(aString);

  Result := StrToInt64Def(s, Low(Integer));
  if Result <> Low(Integer) then
    Exit;

  if s = '' then
    raise Exception.Create('"" is not a valid value for this field');

  if not Supports(aElement, IwbContainerElementRef, Container) then
    raise Exception.Create('Could not resolve Function');

  FunctionTypeVar := Container.ElementNativeValues['..\..\DATA\Entry Point\Function'];
  if VarIsNull(FunctionTypeVar) or VarIsClear(FunctionTypeVar) then
    raise Exception.Create('Could not resolve Function');

  FunctionType := FunctionTypeVar;
  if (FunctionType < Low(wbPERKFunctions)) or (FunctionType > High(wbPERKFunctions)) then
    raise Exception.Create('Unknown Function #'+IntToStr(FunctionType));

  with wbPERKFunctions[FunctionType] do begin
    for j := Low(wbPERKFunctionParams) to High(wbPERKFunctionParams) do
      if SameText(s, wbPERKFunctionParams[j]) then begin
        if j <> ParamType then
          raise Exception.Create('"'+s+'" is not a valid Parameter Type for Function "'+Name+'"');
        Result := Ord(j);
        Exit;
      end;
  end;

  raise Exception.Create('"'+s+'" is not a valid Parameter Type');
end;

procedure wbPerkEPFTAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  i: Integer;
  Container: IwbContainerElementRef;
begin
  if VarSameValue(aOldValue, aNewValue) then
    Exit;

  i := aNewValue;

  if (i < Ord(Low(wbPERKFunctionParams))) or (i> Ord(High(wbPERKFunctionParams))) then
    Exit;

  if not Supports(aElement.Container, IwbContainerElementRef, Container) then
    Exit;

  Container.RemoveElement('EPFD');
  Container.RemoveElement('EPF2');
  Container.RemoveElement('EPF3');
  Container.RemoveElement('Embedded Script');

  case TPERKEntryPointFunctionParamType(i) of
    epfpFloat, epfpFloatFloat, epfpLeveledItem:
      Container.Add('EPFD', True);
    epfpScript: begin
      Container.Add('EPF2', True);
      Container.Add('EPF3', True);
      Container.Add('SCHR', True);
    end;
  end;
end;

function wbActorTemplateUseTraits(const aElement: IwbElement): Boolean;
var
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
  i          : Int64;
begin
  Result := False;
  if not wbActorTemplateHide then Exit;

  Element := GetElementFromUnion(aElement);
  MainRecord := nil;

  while Assigned(Element) and not Supports(Element, IwbMainRecord, MainRecord) do
    Element := Element.Container;

  if Assigned(MainRecord) then begin
    i := MainRecord.ElementNativeValues['ACBS\Template Flags'];
    Result := (i and $00000001) <> 0;
  end;
end;

function wbActorTemplateUseStats(const aElement: IwbElement): Boolean;
var
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
  i          : Int64;
begin
  Result := False;
  if not wbActorTemplateHide then Exit;

  Element := GetElementFromUnion(aElement);
  MainRecord := nil;

  while Assigned(Element) and not Supports(Element, IwbMainRecord, MainRecord) do
    Element := Element.Container;

  if Assigned(MainRecord) then begin
    i := MainRecord.ElementNativeValues['ACBS\Template Flags'];
    Result := (i and $00000002) <> 0;
  end;
end;

function wbActorAutoCalcDontShow(const aElement: IwbElement): Boolean;
var
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
  i          : Int64;
begin
  Result := False;
  if not wbActorTemplateHide then Exit;

  Element := GetElementFromUnion(aElement);
  MainRecord := nil;

  while Assigned(Element) and not Supports(Element, IwbMainRecord, MainRecord) do
    Element := Element.Container;

  if Assigned(MainRecord) then begin
    i := MainRecord.ElementNativeValues['ACBS\Flags'];
    Result := (i and $00000010) <> 0;
  end;
end;

function wbActorTemplateUseStatsAutoCalc(const aElement: IwbElement): Boolean;
begin
  if not wbActorTemplateHide then
    Result := False
  else
    Result := wbActorTemplateUseStats(aElement) or wbActorAutoCalcDontShow(aElement);
end;

function wbActorTemplateUseFactions(const aElement: IwbElement): Boolean;
var
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
  i          : Int64;
begin
  Result := False;
  if not wbActorTemplateHide then Exit;

  Element := GetElementFromUnion(aElement);
  MainRecord := nil;

  while Assigned(Element) and not Supports(Element, IwbMainRecord, MainRecord) do
    Element := Element.Container;

  if Assigned(MainRecord) then begin
    i := MainRecord.ElementNativeValues['ACBS\Template Flags'];
    Result := (i and $00000004) <> 0;
  end;
end;

function wbActorTemplateUseActorEffectList(const aElement: IwbElement): Boolean;
var
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
  i          : Int64;
begin
  Result := False;
  if not wbActorTemplateHide then Exit;

  Element := GetElementFromUnion(aElement);
  MainRecord := nil;

  while Assigned(Element) and not Supports(Element, IwbMainRecord, MainRecord) do
    Element := Element.Container;

  if Assigned(MainRecord) then begin
    i := MainRecord.ElementNativeValues['ACBS\Template Flags'];
    Result := (i and $00000008) <> 0;
  end;
end;

function wbActorTemplateUseAIData(const aElement: IwbElement): Boolean;
var
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
  i          : Int64;
begin
  Result := False;
  if not wbActorTemplateHide then Exit;

  Element := GetElementFromUnion(aElement);
  MainRecord := nil;

  while Assigned(Element) and not Supports(Element, IwbMainRecord, MainRecord) do
    Element := Element.Container;

  if Assigned(MainRecord) then begin
    i := MainRecord.ElementNativeValues['ACBS\Template Flags'];
    Result := (i and $00000010) <> 0;
  end;
end;

function wbActorTemplateUseAIPackages(const aElement: IwbElement): Boolean;
var
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
  i          : Int64;
begin
  Result := False;
  if not wbActorTemplateHide then Exit;

  Element := GetElementFromUnion(aElement);
  MainRecord := nil;

  while Assigned(Element) and not Supports(Element, IwbMainRecord, MainRecord) do
    Element := Element.Container;

  if Assigned(MainRecord) then begin
    i := MainRecord.ElementNativeValues['ACBS\Template Flags'];
    Result := (i and $00000020) <> 0;
  end;
end;

function wbActorTemplateUseModelAnimation(const aElement: IwbElement): Boolean;
var
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
  i          : Int64;
begin
  Result := False;
  if not wbActorTemplateHide then Exit;

  Element := GetElementFromUnion(aElement);
  MainRecord := nil;

  while Assigned(Element) and not Supports(Element, IwbMainRecord, MainRecord) do
    Element := Element.Container;

  if Assigned(MainRecord) then begin
    i := MainRecord.ElementNativeValues['ACBS\Template Flags'];
    Result := (i and $00000040) <> 0;
  end;
end;

function wbActorTemplateUseBaseData(const aElement: IwbElement): Boolean;
var
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
  i          : Int64;
begin
  Result := False;
  if not wbActorTemplateHide then Exit;

  Element := GetElementFromUnion(aElement);
  MainRecord := nil;

  while Assigned(Element) and not Supports(Element, IwbMainRecord, MainRecord) do
    Element := Element.Container;

  if Assigned(MainRecord) then begin
    i := MainRecord.ElementNativeValues['ACBS\Template Flags'];
    Result := (i and $00000080) <> 0;
  end;
end;

function wbActorTemplateUseInventory(const aElement: IwbElement): Boolean;
var
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
  i          : Int64;
begin
  Result := False;
  if not wbActorTemplateHide then Exit;

  Element := GetElementFromUnion(aElement);
  MainRecord := nil;

  while Assigned(Element) and not Supports(Element, IwbMainRecord, MainRecord) do
    Element := Element.Container;

  if Assigned(MainRecord) then begin
    i := MainRecord.ElementNativeValues['ACBS\Template Flags'];
    Result := (i and $00000100) <> 0;
  end;
end;

function wbActorTemplateUseScript(const aElement: IwbElement): Boolean;
var
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
  i          : Int64;
begin
  Result := False;
  if not wbActorTemplateHide then Exit;

  Element := GetElementFromUnion(aElement);
  MainRecord := nil;

  while Assigned(Element) and not Supports(Element, IwbMainRecord, MainRecord) do
    Element := Element.Container;

  if Assigned(MainRecord) then begin
    i := MainRecord.ElementNativeValues['ACBS\Template Flags'];
    Result := (i and $00000200) <> 0;
  end;
end;

procedure wbMGEFAfterLoad(const aElement: IwbElement);
var
  Container     : IwbContainerElementRef;
  MainRecord    : IwbMainRecord;
  OldActorValue : Integer;
  NewActorValue : Integer;
begin
  if wbBeginInternalEdit then try
    if not wbTryGetContainerWithValidMainRecord(aElement, Container, MainRecord) then
      Exit;

    OldActorValue := Container.ElementNativeValues['DATA - Data\Actor Value'];
    NewActorValue := OldActorValue;
    case Integer(Container.ElementNativeValues['DATA - Data\Archtype']) of
      01, //Script
      02, //Dispel
      03, //Cure Disease
      13, //Light
      16, //Lock
      17, //Open
      18, //Bound Item
      19, //Summon Creature
      30, //Cure Paralysis
      31, //Cure Addiction
      32, //Cure Poison
      33: //Concussion
        NewActorValue := -1;
      11: //Invisibility
        NewActorValue := 48; //Invisibility
      12: //Chameleon
        NewActorValue := 49; //Chameleon
      24: //Paralysis
        NewActorValue := 47; //Paralysis
    end;
    if OldActorValue <> NewActorValue then
      Container.ElementNativeValues['DATA - Data\Actor Value'] := NewActorValue;
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbPACKAfterLoad(const aElement: IwbElement);
var
  Container     : IwbContainerElementRef;
  MainRecord    : IwbMainRecord;
  NewContainer  : IwbContainerElementRef;
begin
  if wbBeginInternalEdit then try
    if not wbTryGetContainerWithValidMainRecord(aElement, Container, MainRecord) then
      Exit;

    case Integer(Container.ElementNativeValues['PKDT - General\Type']) of
       0: begin {Find}
         Container.Add('PTDT');
       end;
       1: begin {Follow}
         Container.Add('PKFD');
       end;
       2: begin {Escort}
       end;
       3: begin {Eat}
         Container.Add('PTDT');
         Container.Add('PKED');
       end;
       4: begin {Sleep}
         if not Container.ElementExists['Locations'] then
           if Supports(Container.Add('Locations'), IwbContainerElementRef, NewContainer) then
             NewContainer.ElementEditValues['PLDT - Location 1\Type'] := 'Near editor location';
       end;
       5: begin {Wander}
       end;
       6: begin {Travel}
       end;
       7: begin {Accompany}
       end;
       8: begin {Use Item At}
       end;
       9: begin {Ambush}
       end;
      10: begin {Flee Not Combat}
      end;
      12: begin {Sandbox}
      end;
      13: begin {Patrol}
         if not Container.ElementExists['Locations'] then
           if Supports(Container.Add('Locations'), IwbContainerElementRef, NewContainer) then
             NewContainer.ElementEditValues['PLDT - Location 1\Type'] := 'Near linked reference';
        Container.Add('PKPT');
      end;
      14: begin {Guard}
      end;
      15: begin {Dialogue}
      end;
      16: begin {Use Weapon}
      end;
    end;

  finally
    wbEndInternalEdit;
  end;
end;

procedure wbNPCAfterLoad(const aElement: IwbElement);
var
  Container  : IwbContainerElementRef;
  MainRecord : IwbMainRecord;
//  BaseRecord : IwbMainRecord;
begin
  if wbBeginInternalEdit then try
    if not wbTryGetContainerWithValidMainRecord(aElement, Container, MainRecord) then
      Exit;

    if Container.ElementNativeValues['NAM5'] > 255 then
      Container.ElementNativeValues['NAM5'] := 255;
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbREFRAfterLoad(const aElement: IwbElement);
var
  Container  : IwbContainerElementRef;
  MainRecord : IwbMainRecord;
  BaseRecord : IwbMainRecord;
begin
  if wbBeginInternalEdit then try
    if not wbTryGetContainerWithValidMainRecord(aElement, Container, MainRecord) then
      Exit;

    Container.RemoveElement('RCLR');

    if Container.ElementExists['Ammo'] then begin
      BaseRecord := MainRecord.BaseRecord;
      if Assigned(BaseRecord) and (BaseRecord.Signature <> 'WEAP') then
        Container.RemoveElement('Ammo');
    end;
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbINFOAfterLoad(const aElement: IwbElement);
var
  Container  : IwbContainerElementRef;
  MainRecord : IwbMainRecord;
begin
  if wbBeginInternalEdit then try
    if not wbTryGetContainerWithValidMainRecord(aElement, Container, MainRecord) then
      Exit;

    if (Integer(Container.ElementNativeValues['DATA\Flags 1']) and $80) = 0 then
      Container.RemoveElement('DNAM');

    Container.RemoveElement('SNDD');

    if Container.ElementNativeValues['DATA\Type'] = 3 {Persuasion} then
      Container.ElementNativeValues['DATA\Type'] := 0 {Topic};
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbCELLAfterLoad(const aElement: IwbElement);
var
  Container    : IwbContainerElementRef;
//  Container2   : IwbContainerElementRef;
  MainRecord   : IwbMainRecord;
//  i            : Integer;
begin
  if wbBeginInternalEdit then try
    if not wbTryGetContainerWithValidMainRecord(aElement, Container, MainRecord) then
      Exit;

    if (not Container.ElementExists['XCLW']) and ((Integer(Container.ElementNativeValues['DATA']) and $02) <> 0) then begin
      Container.Add('XCLW', True);
      Container.ElementEditValues['XCLW'] := 'Default';
    end;

    if (not Container.ElementExists['XNAM']) and ((Integer(Container.ElementNativeValues['DATA']) and $02) <> 0) then
      Container.Add('XNAM', True);

//    if Supports(Container.ElementBySignature[XCLR], IwbContainerElementRef, Container2) then begin
//      for i:= Pred(Container2.ElementCount) downto 0 do
//        if not Supports(Container2.Elements[i].LinksTo, IwbMainRecord, MainRecord) or (MainRecord.Signature <> 'REGN') then
//          Container2.RemoveElement(i);
//      if Container2.ElementCount < 1 then
//        Container2.Remove;
//    end;
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbEmbeddedScriptAfterLoad(const aElement: IwbElement);
var
  Container: IwbContainerElementRef;
begin
  if wbBeginInternalEdit then try
    if not Supports(aElement, IwbContainerElementRef, Container) then
      Exit;

    if Container.ElementCount < 1 then
      Exit;

    if Container.ElementEditValues['SCHR\Type'] = 'Quest' then
      Container.ElementEditValues['SCHR\Type'] := 'Object';
  finally
    wbEndInternalEdit;
  end;
end;


procedure wbSOUNAfterLoad(const aElement: IwbElement);
var
  Container: IwbContainerElementRef;
  MainRecord   : IwbMainRecord;
  OldCntr: IwbContainerElementRef;
  NewCntr: IwbContainerElementRef;
  NewCntr2: IwbContainerElementRef;
  i: Integer;
begin
  if wbBeginInternalEdit then try
    if not wbTryGetContainerWithValidMainRecord(aElement, Container, MainRecord) then
      Exit;

    if Container.ElementExists['SNDD'] then
      Exit;

    if not Supports(Container.RemoveElement('SNDX - Sound Data'), IwbContainerElementRef, OldCntr) then
      Exit;

    if not Supports(Container.Add('SNDD', True), IwbContainerElementRef, NewCntr) then
      Exit;

    for i := 0 to Pred(Min(OldCntr.ElementCount, NewCntr.ElementCount)) do
      NewCntr.Elements[i].Assign(Low(Integer), OldCntr.Elements[i], False);

    if not Supports(NewCntr.ElementByName['Attenuation Curve'], IwbContainerElementRef, NewCntr2) then
      Assert(False);
    Assert(NewCntr2.ElementCount = 5);

    if Supports(Container.RemoveElement('ANAM'), IwbContainerElementRef, OldCntr) then begin
      Assert(OldCntr.ElementCount = 5);
      for i := 0 to Pred(Min(OldCntr.ElementCount, NewCntr2.ElementCount)) do
        NewCntr2.Elements[i].Assign(Low(Integer), OldCntr.Elements[i], False);
    end else begin
      NewCntr2.Elements[0].NativeValue := 100;
      NewCntr2.Elements[1].NativeValue := 50;
      NewCntr2.Elements[2].NativeValue := 20;
      NewCntr2.Elements[3].NativeValue := 5;
      NewCntr2.Elements[4].NativeValue := 0;
    end;

    if not Supports(NewCntr.ElementByName['Reverb Attenuation Control'], IwbContainerElementRef, NewCntr2) then
      Assert(False);

    if Supports(Container.RemoveElement('GNAM'), IwbContainerElementRef, OldCntr) then
      NewCntr2.Assign(Low(Integer), OldCntr, False)
    else
      NewCntr2.NativeValue := 80;

    if not Supports(NewCntr.ElementByName['Priority'], IwbContainerElementRef, NewCntr2) then
      Assert(False);

    if Supports(Container.RemoveElement('HNAM'), IwbContainerElementRef, OldCntr) then
      NewCntr2.Assign(Low(Integer), OldCntr, False)
    else
      NewCntr2.NativeValue := 128;
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbWATRAfterLoad(const aElement: IwbElement);
var
  Container: IwbContainerElementRef;
  MainRecord   : IwbMainRecord;
//  AnimationMultiplier : Extended;
//  AnimationAttackMultiplier : Extended;
  OldCntr: IwbContainerElementRef;
  NewCntr: IwbContainerElementRef;
  i: Integer;
begin
  if wbBeginInternalEdit then try
    if not wbTryGetContainerWithValidMainRecord(aElement, Container, MainRecord) then
      Exit;

    if Container.ElementExists['DNAM'] then
      Exit;

    if not Supports(Container.RemoveElement('DATA - Visual Data'), IwbContainerElementRef, OldCntr) then
      Exit;
    if not Supports(Container.Add('DNAM', True), IwbContainerElementRef, NewCntr) then
      Exit;
    for i := 0 to Pred(Min(OldCntr.ElementCount, NewCntr.ElementCount)) do
      if OldCntr.Elements[i].Name = 'Damage (Old Format)' then
        Container.ElementNativeValues['DATA - Damage'] := OldCntr.Elements[i].NativeValue
      else
        NewCntr.Elements[i].Assign(Low(Integer), OldCntr.Elements[i], False);

    NewCntr.ElementNativeValues['Noise Properties - Noise Layer One - Amplitude Scale'] := 1.0;
    NewCntr.ElementNativeValues['Noise Properties - Noise Layer Two - Amplitude Scale'] := 0.5;
    NewCntr.ElementNativeValues['Noise Properties - Noise Layer Three - Amplitude Scale'] := 0.25;
  finally
    wbEndInternalEdit;
  end;
end;


procedure wbWEAPAfterLoad(const aElement: IwbElement);
var
  Container: IwbContainerElementRef;
  MainRecord   : IwbMainRecord;
begin
  if wbBeginInternalEdit then try
    if not wbTryGetContainerWithValidMainRecord(aElement, Container, MainRecord) then
      Exit;

    if not Container.ElementExists['DNAM'] then
      Exit;

    if Container.ElementNativeValues['DNAM\Animation Multiplier'] = 0.0 then
      Container.ElementNativeValues['DNAM\Animation Multiplier'] := 1.0;
    if Container.ElementNativeValues['DNAM\Animation Attack Multiplier'] = 0.0 then
      Container.ElementNativeValues['DNAM\Animation Attack Multiplier'] := 1.0;
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbMESGAfterLoad(const aElement: IwbElement);
var
  Container    : IwbContainerElementRef;
  MainRecord   : IwbMainRecord;
  IsMessageBox : Boolean;
  HasTimeDelay : Boolean;
begin
  if wbBeginInternalEdit then try
    if not wbTryGetContainerWithValidMainRecord(aElement, Container, MainRecord) then
      Exit;

    IsMessageBox := (Integer(Container.ElementNativeValues['DNAM']) and 1) = 1;
    HasTimeDelay := Container.ElementExists['TNAM'];

    if IsMessageBox = HasTimeDelay then
      if IsMessageBox then
        Container.RemoveElement('TNAM')
      else begin
        if not Container.ElementExists['DNAM'] then
          Container.Add('DNAM', True);
        Container.ElementNativeValues['DNAM'] := Integer(Container.ElementNativeValues['DNAM']) or 1;
      end;
  finally
    wbEndInternalEdit;
  end;
end;


procedure wbEFSHAfterLoad(const aElement: IwbElement);
var
  Container: IwbContainerElementRef;
  MainRecord   : IwbMainRecord;
  FullParticleBirthRatio : Extended;
  PersistantParticleBirthRatio : Extended;
begin
  if wbBeginInternalEdit then try
    if not wbTryGetContainerWithValidMainRecord(aElement, Container, MainRecord) then
      Exit;

    if not Container.ElementExists['DATA'] then
      Exit;

    FullParticleBirthRatio := Container.ElementNativeValues['DATA\Particle Shader - Full Particle Birth Ratio'];
    PersistantParticleBirthRatio := Container.ElementNativeValues['DATA\Particle Shader - Persistant Particle Birth Ratio'];

    if ((FullParticleBirthRatio <> 0) and (FullParticleBirthRatio <= 1)) then begin
      FullParticleBirthRatio := FullParticleBirthRatio * 78.0;
      Container.ElementNativeValues['DATA\Particle Shader - Full Particle Birth Ratio'] := FullParticleBirthRatio;
    end;

    if ((PersistantParticleBirthRatio <> 0) and (PersistantParticleBirthRatio <= 1)) then begin
      PersistantParticleBirthRatio := PersistantParticleBirthRatio * 78.0;
      Container.ElementNativeValues['DATA\Particle Shader - Persistant Particle Birth Ratio'] := PersistantParticleBirthRatio;
    end;

  finally
    wbEndInternalEdit;
  end;
end;

procedure wbFACTAfterLoad(const aElement: IwbElement);
var
  Container: IwbContainerElementRef;
  MainRecord   : IwbMainRecord;
begin
  if wbBeginInternalEdit then try
    if not Supports(aElement, IwbContainerElementRef, Container) then
      Exit;

    if Container.ElementCount < 1 then
      Exit;

    if not Container.ElementExists['CNAM'] then
      Exit;

    if not Supports(aElement, IwbMainRecord, MainRecord) then
      Exit;

    if MainRecord.IsDeleted then
      Exit;

    Container.RemoveElement('CNAM');
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbEFITAfterLoad(const aElement: IwbElement);
var
  Container : IwbContainerElementRef;
  Element   : IwbElement;
  ActorValue: Variant;
  MainRecord: IwbMainRecord;
begin
  if wbBeginInternalEdit then try
    if not Supports(aElement, IwbContainerElementRef, Container) then
      Exit;

    if Container.ElementCount < 1 then
      Exit;

    MainRecord := Container.ContainingMainRecord;
    if not Assigned(MainRecord) or MainRecord.IsDeleted then
      Exit;

    Element := Container.ElementByPath['..\EFID'];
    if not wbTryGetMainRecord(Element, MainRecord, 'MGEF') then
      Exit;

    ActorValue := MainRecord.ElementNativeValues['DATA - Data\Actor Value'];
    if VarIsNull(ActorValue) or VarIsClear(ActorValue) then
      Exit;

    if VarCompareValue(ActorValue, Container.ElementNativeValues['Actor Value']) <> vrEqual then
      Container.ElementNativeValues['Actor Value'] := ActorValue;
  finally
    wbEndInternalEdit;
  end;
end;

function wbPKDTFalloutBehaviorFlagsDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container : IwbContainer;
  SubRecord : IwbSubRecord;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  if Supports(Container, IwbSubRecord, SubRecord) then
    if SubRecord.SubRecordHeaderSize = 8 then
      Result := 1;
end;

function wbPKDTSpecificFlagsDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container : IwbContainer;
  SubRecord : IwbSubRecord;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  if Supports(Container, IwbSubRecord, SubRecord) then
    if SubRecord.SubRecordHeaderSize = 8 then
      Exit;
  Result := Container.ElementByName['Type'].NativeValue + 1;
end;

procedure wbIDLAsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  Element         : IwbElement;
  Container       : IwbContainer;
  SelfAsContainer : IwbContainer;
begin
  if wbBeginInternalEdit(True) then try
//    if not wbCounterAfterSet('IDLC - Animation Count', aElement) then
      if Supports(aElement.Container, IwbContainer, Container) then begin
        Element := Container.ElementByPath['IDLC\Animation Count'];
        if Assigned(Element) and Supports(aElement, IwbContainer, SelfAsContainer) and
          (Element.GetNativeValue<>SelfAsContainer.GetElementCount) then
          Element.SetNativeValue(SelfAsContainer.GetElementCount);
      end;
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbAnimationsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  Element         : IwbElement;
  Elems           : IwbElement;
  Container       : IwbContainer;
begin
  if wbBeginInternalEdit(True) then try
//    if not wbCounterContainerAfterSet('IDLC - Animation Count', 'IDLA - Animations', aElement) then
      if Supports(aElement, IwbContainer, Container) then begin
        Element := Container.ElementByPath['IDLC\Animation Count'];
        Elems   := Container.ElementByName['IDLA - Animations'];
        if Assigned(Element) and not Assigned(Elems) then
          if Element.GetNativeValue<>0 then
            Element.SetNativeValue(0);
      end;
  finally
    wbEndInternalEdit;
  end;
end;

procedure DefineFO3;
begin
  DefineCommon;

  wbRecordFlags := wbInteger('Record Flags', itU32, wbFlags(wbFlagsList([])));

  wbMainRecordHeader := wbRecordHeader(wbRecordFlags);

  wbSizeOfMainRecordStruct := 24;

  wbIgnoreRecords.Add(XXXX);

  {>>> Enums <<<}

  wbActorValueEnum :=
    wbEnum([
      {0}  'Aggression',
      {1}  'Confidence',
      {2}  'Energy',
      {3}  'Responsibility',
      {4}  'Mood',
      {5}  'Strength',
      {6}  'Perception',
      {7}  'Endurance',
      {8}  'Charisma',
      {9}  'Intelligence',
      {10} 'Agility',
      {11} 'Luck',
      {12} 'Action Points',
      {13} 'Carry Weight',
      {14} 'Critical Chance',
      {15} 'Heal Rate',
      {16} 'Health',
      {17} 'Melee Damage',
      {18} 'Damage Resistance',
      {19} 'Poison Resistance',
      {20} 'Rad Resistance',
      {21} 'Speed Multiplier',
      {22} 'Fatigue',
      {23} 'Karma',
      {24} 'XP',
      {25} 'Perception Condition',
      {26} 'Endurance Condition',
      {27} 'Left Attack Condition',
      {28} 'Right Attack Condition',
      {29} 'Left Mobility Condition',
      {30} 'Right Mobility Condition',
      {31} 'Brain Condition',
      {32} 'Barter',
      {33} 'Big Guns',
      {34} 'Energy Weapons',
      {35} 'Explosives',
      {36} 'Lockpick',
      {37} 'Medicine',
      {38} 'Melee Weapons',
      {39} 'Repair',
      {40} 'Science',
      {41} 'Small Guns',
      {42} 'Sneak',
      {43} 'Speech',
      {44} 'Throwing (unused)',
      {45} 'Unarmed',
      {46} 'Inventory Weight',
      {47} 'Paralysis',
      {48} 'Invisibility',
      {49} 'Chameleon',
      {50} 'Night Eye',
      {51} 'Detect Life Range',
      {52} 'Fire Resistance',
      {53} 'Water Breathing',
      {54} 'Rad Level',
      {55} 'Bloody Mess',
      {56} 'Unarmed Damage',
      {57} 'Assistance',
      {58} 'Electric Resistance',
      {59} 'Frost Resistance',
      {60} 'Energy Resistance',
      {61} 'EMP Resistance',
      {62} 'Variable01',
      {63} 'Variable02',
      {64} 'Variable03',
      {65} 'Variable04',
      {66} 'Variable05',
      {67} 'Variable06',
      {68} 'Variable07',
      {69} 'Variable08',
      {70} 'Variable09',
      {71} 'Variable10',
      {72} 'Ignore Negative Effects'
    ], [
      -1, 'None'
    ]);

  wbFormTypeEnum :=
    wbEnum([], [
      $04, 'Texture Set',
      $05, 'Menu Icon',
      $06, 'Global',
      $07, 'Class',
      $08, 'Faction',
      $09, 'Head Part',
      $0A, 'Hair',
      $0B, 'Eyes',
      $0C, 'Race',
      $0D, 'Sound',
      $0E, 'Acoustic Space',
      $0F, 'Skill',
      $10, 'Base Effect',
      $11, 'Script',
      $12, 'Landscape Texture',
      $13, 'Object Effect',
      $14, 'Actor Effect',
      $15, 'Activator',
      $16, 'Talking Activator',
      $17, 'Terminal',
      $18, 'Armor',
      $19, 'Book',
      $1A, 'Clothing',
      $1B, 'Container',
      $1C, 'Door',
      $1D, 'Ingredient',
      $1E, 'Light',
      $1F, 'Misc',
      $20, 'Static',
      $21, 'Static Collection',
      $22, 'Movable Static',
      $23, 'Placeable Water',
      $24, 'Grass',
      $25, 'Tree',
      $26, 'Flora',
      $27, 'Furniture',
      $28, 'Weapon',
      $29, 'Ammo',
      $2A, 'NPC',
      $2B, 'Creature',
      $2C, 'Leveled Creature',
      $2D, 'Leveled NPC',
      $2E, 'Key',
      $2F, 'Ingestible',
      $30, 'Idle Marker',
      $31, 'Note',
      $32, 'Constructible Object',
      $33, 'Projectile',
      $34, 'Leveled Item',
      $35, 'Weather',
      $36, 'Climate',
      $37, 'Region',
      $39, 'Cell',
      $3A, 'Placed Object',
      $3B, 'Placed Character',
      $3C, 'Placed Creature',
      $3E, 'Placed Grenade',
      $41, 'Worldspace',
      $42, 'Landscape',
      $43, 'Navmesh',
      $45, 'Dialog Topic',
      $46, 'Dialog Response',
      $47, 'Quest',
      $48, 'Idle Animation',
      $49, 'Package',
      $4A, 'Combat Style',
      $4B, 'Load Screen',
      $4C, 'Leveled Spell',
      $4D, 'Animated Object',
      $4E, 'Water',
      $4F, 'Effect Shader',
      $51, 'Explosion',
      $52, 'Debris',
      $53, 'Image Space',
      $54, 'Image Space Modifier',
      $55, 'FormID List',
      $56, 'Perk',
      $57, 'Body Part Data',
      $58, 'Addon Node',
      $59, 'Actor Value Info',
      $5A, 'Radiation Stage',
      $5B, 'Camera Shot',
      $5C, 'Camera Path',
      $5D, 'Voice Type',
      $5E, 'Impact Data',
      $5F, 'Impact DataSet',
      $60, 'Armor Addon',
      $61, 'Encounter Zone',
      $62, 'Message',
      $63, 'Ragdoll',
      $64, 'Default Object Manager',
      $65, 'Lighting Template',
      $66, 'Music Type'
    ]);

  wbMiscStatEnum :=
    wbEnum([
      {0}  'Quests Completed',
      {1}  'Locations Discovered',
      {2}  'People Killed',
      {3}  'Creatures Killed',
      {4}  'Locks Picked',
      {5}  'Computers Hacked',
      {6}  'Stimpaks Taken',
      {7}  'Rad-X Taken',
      {8}  'RadAway Taken',
      {9}  'Chems Taken',
      {10} 'Times Addicted',
      {11} 'Mines Disarmed',
      {12} 'Speech Successes',
      {13} 'Pockets Picked',
      {14} 'Pants Exploded',
      {15} 'Books Read',
      {16} 'Bobbleheads Found',
      {17} 'Weapons Created',
      {18} 'People Mezzed',
      {19} 'Captives Rescued',
      {20} 'Sandman Kills',
      {21} 'Paralyzing Punches',
      {22} 'Robots Disabled',
      {23} 'Contracts Completed',
      {24} 'Corpses Eaten',
      {25} 'Mysterious Stranger Visits'
    ]);

  wbObjectTypeEnum :=
    wbEnum([
      {0}  'NONE',
      {1}  'Activators',
      {2}  'Armor',
      {3}  'Books',
      {4}  'Clothing',
      {5}  'Containers',
      {6}  'Doors',
      {7}  'Ingredients',
      {8}  'Lights',
      {9}  'Misc',
      {10} 'Flora',
      {11} 'Furniture',
      {12} 'Weapons: Any',
      {13} 'Ammo',
      {14} 'NPCs',
      {15} 'Creatures',
      {16} 'Keys',
      {17} 'Alchemy',
      {18} 'Food',
      {19} 'All: Combat Wearable',
      {20} 'All: Wearable',
      {21} 'Weapons: Ranged',
      {22} 'Weapons: Melee',
      {23} 'Weapons: NONE',
      {24} 'Actor Effects: Any',
      {25} 'Actor Effects: Range Target',
      {26} 'Actor Effects: Range Touch',
      {27} 'Actor Effects: Range Self'
      ], [
      29, 'Actors: Any'
    ]);

  wbPlayerActionEnum :=
    wbEnum([
      {0}  '',
      {1}  'Swinging Melee Weapon',
      {2}  'Throwing Grenade',
      {3}  'Fire Weapon',
      {4}  'Lay Mine',
      {5}  'Z Key Object',
      {6}  'Jumping',
      {7}  'Knocking over Objects',
      {8}  'Stand on Table/Chair',
      {9}  'Iron Sites',
      {10} 'Destroying Object'
    ]);

  wbSkillEnum :=
    wbEnum([
      {0}  'Barter',
      {1}  'Big Guns',
      {2}  'Energy Weapons',
      {3}  'Explosives',
      {4}  'Lockpick',
      {5}  'Medicine',
      {6}  'Melee Weapons',
      {7}  'Repair',
      {8}  'Science',
      {9}  'Small Guns',
      {10} 'Sneak',
      {11} 'Speech',
      {12} 'Throwing (unused)',
      {13} 'Unarmed'
    ], [
      -1, 'None'
    ]);

  wbSoundLevelEnum :=
    wbEnum([
      {0} 'Loud',
      {1} 'Normal',
      {2} 'Silent'
    ]);

  wbVatsActionEnum :=
    wbEnum([
      {0}  'Unarmed Attack',
      {1}  'One Hand Melee Attack',
      {2}  'Two Hand Melee Attack',
      {3}  'Fire Pistol',
      {4}  'Fire Rifle',
      {5}  'Fire Handle Weapon',
      {6}  'Fire Launcher',
      {7}  'Throw Grenade',
      {8}  'Place Mine',
      {9}  'Reload',
      {10} 'Crouch',
      {11} 'Stand',
      {12} 'Switch Weapon',
      {13} 'Toggle Weapon Drawn',
      {14} 'Heal',
      {15} 'Player Death'
    ]);

  wbVatsValueFunctionEnum :=
    wbEnum([
      {0}  'Weapon Is',
      {1}  'Weapon In List',
      {2}  'Target Is',
      {3}  'Target In List',
      {4}  'Target Distance',
      {5}  'Target Part',
      {6}  'VATS Action',
      {7}  'Is Success',
      {8}  'Is Critical',
      {9}  'Critical Effect Is',
      {10} 'Critical Effect In List',
      {11} 'Is Fatal',
      {12} 'Explode Part',
      {13} 'Dismember Part',
      {14} 'Cripple Part',
      {15} 'Weapon Type Is',
      {16} 'Is Stranger',
      {17} 'Is Paralyzing Palm'
    ]);

  wbWeaponAnimTypeEnum :=
    wbEnum([
      {0}  'Hand to Hand',
      {1}  'Melee (1 Hand)',
      {2}  'Melee (2 Hand)',
      {3}  'Pistol - Ballistic (1 Hand)',
      {4}  'Pistol - Energy (1 Hand)',
      {5}  'Rifle - Ballistic (2 Hand)',
      {6}  'Rifle - Automatic (2 Hand)',
      {7}  'Rifle - Energy (2 Hand)',
      {8}  'Handle (2 Hand)',
      {9}  'Launcher (2 Hand)',
      {10} 'Grenade Throw (1 Hand)',
      {11} 'Land Mine (1 Hand)',
      {12} 'Mine Drop (1 Hand)'
    ]);

  {>>> Flags <<<}

  wbMODD :=
    wbInteger(MODD, 'FaceGen Model Flags', itU8,
      wbFlags([
        {0} 'Head',
        {1} 'Torso',
        {2} 'Right Hand',
        {3} 'Left Hand'
      ]));

  wbMOSD :=
    wbInteger(MOSD, 'FaceGen Model Flags', itU8,
      wbFlags([
        {0} 'Head',
        {1} 'Torso',
        {2} 'Right Hand',
        {3} 'Left Hand'
      ]));

  {>>> Common Defs <<<}

  wbActorValue := wbInteger('Actor Value', itS32, wbActorValueEnum);
  wbBIPL := wbFormIDCk(BIPL, 'Biped Model List', [FLST]);
  wbDESC := wbStringKC(DESC, 'Description', 0, cpTranslate);
  wbDESCReq := wbStringKC(DESC, 'Description', 0, cpTranslate).SetRequired;
  wbEDID := wbString(EDID, 'Editor ID'); // not cpBenign according to Arthmoor
  wbEDIDReq := wbString(EDID, 'Editor ID').SetRequired; // not cpBenign according to Arthmoor
  wbEDIDReqKC := wbStringKC(EDID, 'Editor ID').SetRequired; // not cpBenign according to Arthmoor
  wbEFID := wbFormIDCk(EFID, 'Base Effect', [MGEF]);
  wbEITM := wbFormIDCk(EITM, 'Object Effect', [ENCH, SPEL]);
  wbETYP := wbInteger(ETYP, 'Equipment Type', itS32, wbEquipTypeEnum);
  wbETYPReq := wbInteger(ETYP, 'Equipment Type', itS32, wbEquipTypeEnum).SetRequired;
  wbFULL := wbStringKC(FULL, 'Name', 0, cpTranslate);
  wbFULLReq := wbStringKC(FULL, 'Name', 0, cpTranslate).SetRequired;
  wbMODS := wbArrayS(MODS, 'Alternate Textures', wbAlternateTexture, -1);
  wbMO2S := wbArrayS(MO2S, 'Alternate Textures', wbAlternateTexture, -1);
  wbMO3S := wbArrayS(MO3S, 'Alternate Textures', wbAlternateTexture, -1);
  wbMO4S := wbArrayS(MO4S, 'Alternate Textures', wbAlternateTexture, -1);
  wbREPL := wbFormIDCkNoReach(REPL, 'Repair List', [FLST]);
  wbSCRI := wbFormIDCk(SCRI, 'Script', [SCPT]);
  wbXLCM := wbInteger(XLCM, 'Level Modifier', itS32);
  wbXSCL := wbFloat(XSCL, 'Scale');
  wbYNAM := wbFormIDCk(YNAM, 'Sound - Pick Up', [SOUN]);
  wbZNAM := wbFormIDCk(ZNAM, 'Sound - Drop', [SOUN]);

  {>>> TwbSignatures <<<}

  wbConditionBaseObjects :=
    [ACTI, ALCH, AMMO, ARMA, ARMO, ASPC, BOOK, CONT, CREA, DOOR,
     FURN, GRAS, IDLM, KEYM, LIGH, LVLC, LVLN, MISC, MSTT, NOTE,
     NPC_, PROJ, PWAT, SCOL, SOUN, STAT, TACT, TERM, TREE, WEAP];

  {>>> Struct Members <<<}

  wbConditionVATSValueParameters := [
    {0}  wbFormIDCkNoReach('Weapon', [WEAP]),
    {1}  wbFormIDCkNoReach('Weapon List', [FLST], [WEAP]),
    {2}  wbFormIDCkNoReach('Target', [CREA, NPC_]),
    {3}  wbFormIDCkNoReach('Target List', [FLST], [CREA, NPC_]),
    {4}  wbUnused(4),
    {5}  wbInteger('Target Part', itS32, wbActorValueEnum),
    {6}  wbInteger('VATS Action', itU32, wbVatsActionEnum),
    {7}  wbUnused(4).IncludeFlag(dfZeroSortKey),
    {8}  wbUnused(4).IncludeFlag(dfZeroSortKey),
    {9}  wbFormIDCkNoReach('Critical Effect', [SPEL]),
    {10} wbFormIDCkNoReach('Critical Effect List', [FLST], [SPEL]),
    {11} wbUnused(4).IncludeFlag(dfZeroSortKey),
    {12} wbUnused(4).IncludeFlag(dfZeroSortKey),
    {13} wbUnused(4).IncludeFlag(dfZeroSortKey),
    {14} wbUnused(4).IncludeFlag(dfZeroSortKey),
    {15} wbInteger('Weapon Type', itU32, wbWeaponAnimTypeEnum),
    {16} wbUnused(4).IncludeFlag(dfZeroSortKey),
    {17} wbUnused(4).IncludeFlag(dfZeroSortKey)
  ];

  wbConditionParameters := [
    //Misc
    {0}  wbUnknown(4),
    {1}  wbByteArray('None', 4, cpIgnore).IncludeFlag(dfZeroSortKey),
    {2}  wbInteger('Integer', itS32),
    {3}  wbInteger('Quest Stage', itS32, wbConditionQuestStageToStr, wbCTDAParam2QuestStageToInt),
    {4}  wbInteger('Variable Name', itS32, wbConditionVariableNameToStr, wbConditionVariableNameToInt),
    {5}  wbUnion('VATS Value Param', wbConditionVATSValueParam, wbConditionVATSValueParameters),

    //Enums
    {6}  wbInteger('Actor Value', itS32, wbActorValueEnum),
    {7}  wbInteger('Alignment', itU32, wbAlignmentEnum),
    {8}  wbInteger('Axis', itU32, wbAxisEnum),
    {9}  wbInteger('Body Location', itS32, wbBodyLocationEnum),
    {10} wbInteger('Creature Type', itU32, wbCreatureTypeEnum),
    {11} wbInteger('Crime Type', itU32, wbCrimeTypeEnum),
    {12} wbInteger('Critical Stage', itU32, wbCriticalStageEnum),
    {13} wbInteger('Equip Type', itU32, wbEquipTypeEnum),
    {14} wbInteger('Form Type', itU32, wbFormTypeEnum),
    {15} wbInteger('Menu Mode', itU32, wbMenuModeEnum),
    {16} wbInteger('Misc Stat', itU32, wbMiscStatEnum),
    {17} wbInteger('Player Action', itU32, wbPlayerActionEnum),
    {18} wbInteger('Sex', itU32, wbSexEnum),
    {19} wbInteger('VATS Value Function', itU32, wbVATSValueFunctionEnum),

    //FormIDs
    {20} wbFormIDCkNoReach('Actor', [ACHR, ACRE, PLYR, TRGT], True),
    {21} wbFormIDCkNoReach('Actor Base', [CREA, NPC_]),
    {22} wbFormIDCkNoReach('Base Effect', [MGEF]),
    {23} wbFormIDCkNoReach('Base Object', wbConditionBaseObjects + [FLST], wbConditionBaseObjects),
    {24} wbFormIDCkNoReach('Cell', [CELL]),
    {25} wbFormIDCkNoReach('Class', [CLAS]),
    {26} wbFormIDCkNoReach('Effect Item', [ALCH, ENCH, INGR, SPEL]),
    {27} wbFormIDCkNoReach('Encounter Zone', [ECZN]),
    {28} wbFormIDCkNoReach('Faction', [FACT]),
    {29} wbFormIDCkNoReach('Form List', [FLST]),
    {30} wbFormIDCkNoReach('Furniture', [FLST, FURN], [FURN]),
    {31} wbFormIDCkNoReach('Global', [GLOB]),
    {32} wbFormIDCkNoReach('Idle', [IDLE]),
    {33} wbFormIDCkNoReach('Inventory Object', [ALCH, AMMO, ARMO, BOOK, FLST, KEYM, MISC, NOTE, WEAP]),
    {34} wbFormIDCkNoReach('Note', [NOTE]),
    {35} wbFormIDCkNoReach('Owner', [FACT, NPC_]),
    {36} wbFormIDCkNoReach('Package', [PACK]),
    {37} wbFormIDCkNoReach('Perk', [PERK]),
    {38} wbFormIDCkNoReach('Quest', [QUST]),
    {39} wbFormIDCkNoReach('Race', [RACE]),
    {40} wbFormIDCkNoReach('Reference', [ACHR, ACRE, PBEA, PGRE, PLYR, PMIS, REFR, TRGT], True),
    {41} wbFormIDCkNoReach('Voice Type', [VTYP]),
    {42} wbFormIDCkNoReach('Weapon', [WEAP]),
    {43} wbFormIDCkNoReach('Weather', [WTHR]),
    {44} wbFormIDCkNoReach('Worldspace', [WRLD])
  ];

  {>>> Record members <<<}

  wbAIDT :=
    wbStruct(AIDT, 'AI Data', [
      wbInteger('Aggression', itU8, wbAggressionEnum),
      wbInteger('Confidence', itU8, wbConfidenceEnum),
      wbInteger('Energy Level', itU8),
      wbInteger('Responsibility', itU8),
      wbInteger('Mood', itU8, wbMoodEnum),
      wbUnused(3),
      wbInteger('Buys/Sells and Services', itU32, wbServiceFlags),
      wbInteger('Teaches', itS8, wbSkillEnum),
      wbInteger('Maximum training level', itU8),
      wbInteger('Assistance', itS8, wbAssistanceEnum),
      wbInteger('Aggro Radius Behavior', itU8, wbBoolEnum),
      wbInteger('Aggro Radius', itS32)
    ]).SetDontShow(wbActorTemplateUseAIData)
      .SetRequired;

  wbBMDT :=
    wbStruct(BMDT, 'Biped Data', [
      wbInteger('Biped Flags', itU32,
        wbFlags([
          {0} 'Head',
          {1} 'Hair',
          {2} 'Upper Body',
          {3} 'Left Hand',
          {4} 'Right Hand',
          {5} 'Weapon',
          {6} 'PipBoy',
          {7} 'Backpack',
          {8} 'Necklace',
          {9} 'Headband',
          {10} 'Hat',
          {11} 'Eye Glasses',
          {12} 'Nose Ring',
          {13} 'Earrings',
          {14} 'Mask',
          {15} 'Choker',
          {16} 'Mouth Object',
          {17} 'Body AddOn 1',
          {18} 'Body AddOn 2',
          {19} 'Body AddOn 3'
        ])).IncludeFlag(dfCollapsed, wbCollapseFlags),
        wbInteger('General Flags', itU8,
          wbFlags(wbSparseFlags([
            5, 'Power Armor',
            6, 'Non-Playable',
            7, 'Heavy'
          ], False, 8), True)),
          wbUnused(3)
      ]).SetRequired;

  wbCOED :=
    wbStructExSK(COED, [2], [0, 1], 'Extra Data', [
      wbFormIDCkNoReach('Owner', [NPC_, FACT, NULL]),
      wbUnion('Global Variable / Required Rank', wbCOEDOwnerDecider, [
        wbUnused(4),
        wbFormIDCk('Global Variable', [GLOB, NULL]),
        wbInteger('Required Rank', itU32)
      ]),
      wbFloat('Item Condition')
    ]);

  wbCNTOs :=
    wbRArrayS('Items',
      wbRStructExSK([0], [1], 'Item', [
        wbStructExSK(CNTO, [0], [1], 'Item', [
          wbFormIDCk('Item', [ARMO, AMMO, MISC, WEAP, BOOK, LVLI, KEYM, ALCH, NOTE, MSTT{?}, STAT{?}]),
          wbInteger('Count', itS32).SetDefaultNativeValue(1)
        ]),
        wbCOED
      ]).SetToStr(wbItemToStr).IncludeFlag(dfCollapsed, wbCollapseItems)
    );

  wbConditions :=
    wbRArray('Conditions',
      wbStructSK(CTDA, [3, 5, 6], 'Condition', [
      {0} wbInteger('Type', itU8, wbConditionTypeToStr, wbConditionTypeToInt).SetAfterSet(wbConditionTypeAfterSet),
      {1} wbUnused(3),
      {2} wbUnion('Comparison Value', wbConditionCompValueDecider, [
            wbFloat('Comparison Value - Float'),
            wbFormIDCk('Comparison Value - Global', [GLOB])
          ]),
      {3} wbInteger('Function', itU16, wbConditionFunctionToStr, wbConditionFunctionToInt),   // Limited to itu16
      {4} wbUnused(2),
      {5} wbUnion('Parameter #1', wbConditionParam1Decider, wbConditionParameters),
      {6} wbUnion('Parameter #2', wbConditionParam2Decider, wbConditionParameters),
      {7} wbInteger('Run On', itU32,
            wbEnum([
              {0} 'Subject',
              {1} 'Target',
              {2} 'Reference',
              {3} 'Combat Target',
              {4} 'Linked Reference'
            ])).SetAfterSet(wbCTDARunOnAfterSet),
      {8} wbUnion('Reference', wbCTDAReferenceDecider, [
            wbInteger('Unused', itU32, nil, cpIgnore),
            wbFormIDCkNoReach('Reference', [ACHR, ACRE, PBEA, PGRE, PLYR, PMIS, REFR], True)
          ])
      ], cpNormal, False, nil, 7)
        .SetAfterLoad(wbConditionsfterLoad)
        .SetToStr(wbConditionToStr)
        .IncludeFlag(dfCollapsed, wbCollapseConditions));

  wbDEST :=
    wbRStruct('Destructible', [
      wbStruct(DEST, 'Header', [
        wbInteger('Health', itS32),
        wbInteger('Count', itU8),
        wbInteger('VATS Targetable', itU8, wbBoolEnum),
        wbUnused(2)
      ]),
      wbRArray('Stages',
        wbRStruct('Stage', [
          wbStruct(DSTD, 'Destruction Stage Data', [
            wbInteger('Health %', itU8),
            wbInteger('Index', itU8),
            wbInteger('Damage Stage', itU8),
            wbInteger('Flags', itU8,
              wbFlags([
                {0} 'Cap Damage',
                {1} 'Disable',
                {2} 'Destroy'
              ])).IncludeFlag(dfCollapsed, wbCollapseFlags),
            wbInteger('Self Damage per Second', itS32),
            wbFormIDCk('Explosion', [EXPL, NULL]),
            wbFormIDCk('Debris', [DEBR, NULL]),
            wbInteger('Debris Count', itS32)
          ]).SetRequired,
          wbRStructSK([0], 'Model', [
            wbString(DMDL, 'Model FileName'),
            wbDMDT
          ]).SetSummaryKey([0])
            .IncludeFlag(dfCollapsed, wbCollapseModels),
          wbEmpty(DSTF, 'End Marker').SetRequired
        ]))
    ]);

  wbDODT :=
    wbStruct(DODT, 'Decal Data', [
      wbFloat('Min Width'),
      wbFloat('Max Width'),
      wbFloat('Min Height'),
      wbFloat('Max Height'),
      wbFloat('Depth'),
      wbFloat('Shininess'),
      wbStruct('Parallax', [
        wbFloat('Scale'),
        wbInteger('Passes', itU8)
      ]),
      wbInteger('Flags', itU8, wbFlags([
        'Parallax',
        'Alpha - Blending',
        'Alpha - Testing'
      ], True)),
      wbUnused(2),
      wbByteColors('Color')
    ]);

  wbEFIT :=
    wbStructSK(EFIT, [3, 4], '', [
      wbInteger('Magnitude', itU32),
      wbInteger('Area', itU32),
      wbInteger('Duration', itU32),
      wbInteger('Type', itU32, wbEffectTypeEnum),
      wbActorValue
    ]).SetAfterLoad(wbEFITAfterLoad)
      .SetRequired;

  var wbEffect :=
    wbRStruct('Effect', [
      wbEFID,
      wbEFIT,
      wbConditions
    ]);

  wbEffects :=
    wbRArray('Effects', wbEffect);

  wbEffectsReq :=
    wbRArray('Effects', wbEffect).SetRequired;

  wbFaceGen := wbRStruct('FaceGen Data', [
    wbByteArray(FGGS, 'FaceGen Geometry-Symmetric').SetRequired,
    wbByteArray(FGGA, 'FaceGen Geometry-Asymmetric').SetRequired,
    wbByteArray(FGTS, 'FaceGen Texture-Symmetric').SetRequired
  ]).SetRequired;

  var wbHeadParts :=
    wbRArrayS('Parts',
      wbHeadPart(
        wbEnum([
          'Head',
          'Ears',
          'Mouth',
          'Teeth Lower',
          'Teeth Upper',
          'Tongue',
          'Left Eye',
          'Right Eye'
        ]),
        wbGenericModel(True),
        wbHeadPartsAfterSet)
    ).SetRequired;

  wbICON := wbRStruct('Icon', [
    wbString(ICON, 'Large Icon FileName'),
    wbString(MICO, 'Small Icon FileName')
  ]);

  wbICONReq := wbRStruct('Icon', [
    wbString(ICON, 'Large Icon FileName'),
    wbString(MICO, 'Small Icon FileName')
  ]).SetRequired;

  var wbBodyParts :=
    wbRArrayS('Parts',
      wbRStructSK([0], 'Part', [
        wbInteger(INDX, 'Index', itU32, wbBodyPartIndexEnum),
        wbICON,
        wbGenericModel(True)
      ]).SetSummaryKey([0, 2])
        .SetSummaryMemberPrefixSuffix(0, '[', ']')
        .SetSummaryDelimiter(' ')
        .IncludeFlag(dfSummaryMembersNoName)
        .IncludeFlag(dfSummaryNoSortKey)
        .IncludeFlag(dfCollapsed, wbCollapseBodyParts)
    ).SetRequired;

  wbSCHRReq :=
    wbStruct(SCHR, 'Basic Script Data', [
      wbUnused(4),
      wbInteger('RefCount', itU32),
      wbInteger('CompiledSize', itU32),
      wbInteger('VariableCount', itU32),
      wbInteger('Type', itU16,
        wbEnum([
          {0} 'Object',
          {1} 'Quest'
        ], [
          $100, 'Effect'
        ])),
      wbInteger('Enabled', itU16, wbBoolEnum).SetDefaultNativeValue(1)
    ]).SetRequired;

  wbSCROs :=
    wbRArray('References',
      wbRUnion('', [
        wbFormID(SCRO, 'Global Reference'),
        wbInteger(SCRV, 'Local Variable', itU32)
      ])).IncludeFlag(dfNotAlignable);

  wbSLSD :=
    wbStructSK(SLSD, [0], 'Local Variable Data', [
      wbInteger('Index', itU32),
      wbUnused(12),
      wbInteger('IsLongOrShort', itU8, wbBoolEnum, cpCritical),
      wbUnused(7)
    ]);

  wbEmbeddedScript :=
    wbRStruct('Embedded Script', [
      wbSCHRReq,
      wbByteArray(SCDA, 'Compiled Embedded Script'),
      wbStringScript(SCTX, 'Embedded Script Source'),
      wbRArrayS('Local Variables',
        wbRStructSK([0], 'Local Variable', [
          wbSLSD,
          wbString(SCVR, 'Name', 0, cpCritical).SetRequired
        ])),
      wbSCROs
    ]).SetAfterLoad(wbEmbeddedScriptAfterLoad)
      .SetToStr(wbScriptToStr);

  wbEmbeddedScriptReq :=
    wbRStruct('Embedded Script', [
      wbSCHRReq,
      wbByteArray(SCDA, 'Compiled Embedded Script'),
      wbStringScript(SCTX, 'Embedded Script Source'),
      wbRArrayS('Local Variables',
        wbRStructSK([0], 'Local Variable', [
          wbSLSD,
          wbString(SCVR, 'Name', 0, cpCritical).SetRequired
        ])),
      wbSCROs
    ]).SetAfterLoad(wbEmbeddedScriptAfterLoad)
      .SetToStr(wbScriptToStr)
      .SetRequired;

  wbSPLOs :=
    wbRArrayS('Actor Effects',
      wbFormIDCk(SPLO, 'Actor Effect', [SPEL])
    ).SetDontShow(wbActorTemplateUseActorEffectList);

  wbXESP :=
    wbStruct(XESP, 'Enable Parent', [
      wbFormIDCk('Reference', [PLYR, REFR, ACRE, ACHR, PGRE, PMIS, PBEA]),
      wbInteger('Flags', itU8,
        wbFlags([
          {0} 'Set Enable State to Opposite of Parent',
          {1} 'Pop In'
        ])).IncludeFlag(dfCollapsed, wbCollapseFlags),
      wbUnused(3)
    ]);


  wbRefRecord(ACHR, 'Placed NPC',
    wbFlags(wbFlagsList([
      10, 'Persistent',
      11, 'Initially Disabled',
      25, 'No AI Acquire'
    ])), [
    wbEDID,
    wbFormIDCk(NAME, 'Base', [NPC_]).SetRequired,
    wbFormIDCk(XEZN, 'Encounter Zone', [ECZN]),

    {--- Ragdoll ---}
    wbRagdoll,

    {--- Patrol Data ---}
    wbRStruct('Patrol Data', [
      wbFloat(XPRD, 'Idle Time').SetRequired,
      wbEmpty(XPPA, 'Patrol Script Marker').SetRequired,
      wbFormIDCk(INAM, 'Idle', [IDLE, NULL]).SetRequired,
      wbEmbeddedScriptReq,
      wbFormIDCk(TNAM, 'Topic', [DIAL, NULL]).SetRequired
    ]),

    {--- Leveled Actor ----}
    wbXLCM,

    {--- Merchant Container ----}
    wbFormIDCk(XMRC, 'Merchant Container', [REFR], True),

    {--- Extra ---}
    wbInteger(XCNT, 'Count', itS32),
    wbFloat(XRDS, 'Radius'),
    wbFloat(XHLP, 'Health'),

    {--- Decals ---}
    wbRArrayS('Linked Decals',
      wbStructSK(XDCR, [0], 'Decal', [
        wbFormIDCk('Reference', [REFR]),
        wbUnknown
      ])
    ),

    {--- Linked Ref ---}
    wbFormIDCk(XLKR, 'Linked Reference', [REFR, ACRE, ACHR, PGRE, PMIS, PBEA, PLYR]),
    wbStruct(XCLP, 'Linked Reference Color', [
      wbByteColors('Link Start Color'),
      wbByteColors('Link End Color')
    ]),

    {--- Activate Parents ---}
    wbRStruct('Activate Parents', [
      wbInteger(XAPD, 'Flags', itU8, wbFlags([
        'Parent Activate Only'
      ], True)),
      wbRArrayS('Activate Parent Refs',
        wbStructSK(XAPR, [0], 'Activate Parent Ref', [
          wbFormIDCk('Reference', [REFR, ACRE, ACHR, PGRE, PMIS, PBEA, PLYR]),
          wbFloat('Delay')
        ])
      )
    ]),

    {--- Enable Parent ---}
    wbXESP,

    {--- Emittance ---}
    wbFormIDCk(XEMI, 'Emittance', [LIGH, REGN]),

    {--- MultiBound ---}
    wbFormIDCk(XMBR, 'MultiBound Reference', [REFR]),

    {--- Flags ---}
    wbEmpty(XIBS, 'Ignored By Sandbox'),

    {--- 3D Data ---}
    wbXSCL,
    wbDATAPosRot
  ], True).SetAddInfo(wbPlacedAddInfo);

  wbRefRecord(ACRE, 'Placed Creature',
    wbFlags(wbFlagsList([
      10, 'Persistent',
      11, 'Initially Disabled',
      15, 'Visible When Distant',
      25, 'No AI Acquire'
    ])), [
    wbEDID,
    wbFormIDCk(NAME, 'Base', [CREA]).SetRequired,
    wbFormIDCk(XEZN, 'Encounter Zone', [ECZN]),

    wbRagdoll,

    {--- Patrol Data ---}
    wbRStruct('Patrol Data', [
      wbFloat(XPRD, 'Idle Time').SetRequired,
      wbEmpty(XPPA, 'Patrol Script Marker').SetRequired,
      wbFormIDCk(INAM, 'Idle', [IDLE, NULL]).SetRequired,
      wbEmbeddedScriptReq,
      wbFormIDCk(TNAM, 'Topic', [DIAL, NULL]).SetRequired
    ]),

    {--- Leveled Actor ----}
    wbXLCM,

    {--- Ownership ---}
    wbOwnership([XCMT, XCMO]),

    {--- Merchant Container ----}
    wbFormIDCk(XMRC, 'Merchant Container', [REFR], True),

    {--- Extra ---}
    wbInteger(XCNT, 'Count', itS32),
    wbFloat(XRDS, 'Radius'),
    wbFloat(XHLP, 'Health'),

    {--- Decals ---}
    wbRArrayS('Linked Decals',
      wbStructSK(XDCR, [0], 'Decal', [
        wbFormIDCk('Reference', [REFR, ACRE, ACHR, PGRE, PMIS, PBEA]),
        wbUnknown
      ])
    ),

    {--- Linked Ref ---}
    wbFormIDCk(XLKR, 'Linked Reference', [REFR, ACRE, ACHR, PGRE, PMIS, PBEA, PLYR]),
    wbStruct(XCLP, 'Linked Reference Color', [
      wbByteColors('Link Start Color'),
      wbByteColors('Link End Color')
    ]),

    {--- Activate Parents ---}
    wbRStruct('Activate Parents', [
      wbInteger(XAPD, 'Flags', itU8, wbFlags([
        'Parent Activate Only'
      ], True)),
      wbRArrayS('Activate Parent Refs',
        wbStructSK(XAPR, [0], 'Activate Parent Ref', [
          wbFormIDCk('Reference', [REFR, ACRE, ACHR, PGRE, PMIS, PBEA, PLYR]),
          wbFloat('Delay')
        ])
      )
    ]),

    {--- Enable Parent ---}
    wbXESP,

    {--- Emittance ---}
    wbFormIDCk(XEMI, 'Emittance', [LIGH, REGN]),

    {--- MultiBound ---}
    wbFormIDCk(XMBR, 'MultiBound Reference', [REFR]),

    {--- Flags ---}
    wbEmpty(XIBS, 'Ignored By Sandbox'),

    {--- 3D Data ---}
    wbXSCL,
    wbDATAPosRot
  ], True).SetAddInfo(wbPlacedAddInfo);

  wbRecord(ACTI, 'Activator',
    wbFlags(wbFlagsList([
      6, 'Has Tree LOD',
      9, 'On Local Map',
     10, 'Quest Item',
     15, 'Visible When Distant',
     16, 'Random Anim Start',
     17, 'Dangerous',
     19, 'Has Platform Specific Textures',
     25, 'Obstacle',
     26, 'Navmesh - Filter',
     27, 'Navmesh - Bounding Box',
     29, 'Child Can Use',
     30, 'Navmesh - Ground'
    ])).SetFlagHasDontShow(26, wbFlagNavmeshFilterDontShow)
       .SetFlagHasDontShow(27, wbFlagNavmeshBoundingBoxDontShow)
       .SetFlagHasDontShow(30, wbFlagNavmeshGroundDontShow), [
    wbEDIDReq,
    wbOBND(True),
    wbFULL,
    wbGenericModel,
    wbSCRI,
    wbDEST,
    wbFormIDCk(SNAM, 'Sound - Looping', [SOUN]),
    wbFormIDCk(VNAM, 'Sound - Activation', [SOUN]),
    wbFormIDCk(RNAM, 'Radio Station', [TACT]),
    wbFormIDCk(WNAM, 'Water Type', [WATR])
  ]);

  wbRecord(ALCH, 'Ingestible',
    wbFlags(wbFlagsList([
      10, 'Quest Item',
      29, 'Unknown 29'
    ])), [
    wbEDIDReq,
    wbOBND(True),
    wbFULLReq,
    wbGenericModel,
    wbICON,
    wbSCRI,
    wbDEST,
    wbYNAM,
    wbZNAM,
    wbETYPReq,
    wbFloat(DATA, 'Weight').SetRequired,
    wbStruct(ENIT, 'Effect Data', [
      wbInteger('Value', itS32),
      wbInteger('Flags', itU8, wbFlags([
        'No Auto-Calc',
        'Food Item',
        'Medicine'
      ])),
      wbUnused(3),
      wbFormIDCk('Withdrawal Effect', [SPEL, NULL]),
      wbFloat('Addiction Chance'),
      wbFormIDCk('Sound - Consume', [SOUN])
    ]).SetRequired,
    wbEffectsReq
  ]);

  wbRecord(AMMO, 'Ammunition', [
    wbEDIDReq,
    wbOBND(True),
    wbFULLReq,
    wbGenericModel,
    wbICON,
    wbDEST,
    wbYNAM,
    wbZNAM,
    wbStruct(DATA, 'Data', [
      wbFloat('Speed'),
      wbInteger('Flags', itU8, wbFlags([
        'Ignores Normal Weapon Resistance',
        'Non-Playable'
      ])),
      wbUnused(3),
      wbInteger('Value', itS32),
      wbInteger('Clip Rounds', itU8)
    ]).SetRequired,
    wbStringKC(ONAM, 'Short Name', 0, cpTranslate)
  ]);

  wbRecord(ANIO, 'Animated Object', [
    wbEDIDReq,
    wbGenericModel(True),
    wbFormIDCk(DATA, 'Animation', [IDLE]).SetRequired
  ]);

  wbRecord(ARMO, 'Armor',
    wbFlags(wbFlagsList([
      10, 'Quest Item',
      19, 'Has Platform Specific Textures'
    ])), [
    wbEDIDReq,
    wbOBND(True),
    wbFULL,
    wbSCRI,
    wbEITM,
    wbBMDT,
    wbTexturedModel('Male Biped Model', [MODL, MODT], [wbMODS, wbMODD]),
    wbTexturedModel('Male World Model', [MOD2, MO2T], [wbMO2S, nil]),
    wbString(ICON, 'Male Icon Filename'),
    wbString(MICO, 'Male Message Icon Filename'),
    wbTexturedModel('Female Biped Model', [MOD3, MO3T], [wbMO3S, wbMOSD]),
    wbTexturedModel('Female World Model', [MOD4, MO4T], [wbMO4S, nil]),
    wbString(ICO2, 'Female Icon Filename'),
    wbString(MIC2, 'Female Message Icon Filename'),
    wbString(BMCT, 'Ragdoll Constraint Template'),
    wbDEST,
    wbREPL,
    wbBIPL,
    wbETYPReq,
    wbYNAM,
    wbZNAM,
    wbStruct(DATA, 'Data', [
      wbInteger('Value', itS32),
      wbInteger('Max Condition', itS32),
      wbFloat('Weight')
    ]).SetRequired,
    wbStruct(DNAM, '', [
      wbInteger('DR', itS16, wbDiv(100)),
      wbInteger('Flags', itU16, wbFlags([
        'Modulates Voice'
      ]))
    ]).SetRequired
  ]);

  wbRecord(ARMA, 'Armor Addon', [
    wbEDIDReq,
    wbOBND(True),
    wbFULL,
    wbBMDT,
    wbTexturedModel('Male Biped Model', [MODL, MODT], [wbMODS, wbMODD]),
    wbTexturedModel('Male World Model', [MOD2, MO2T], [wbMO2S, nil]),
    wbString(ICON, 'Male Icon Filename'),
    wbString(MICO, 'Male Message Icon Filename'),
    wbTexturedModel('Female Biped Model', [MOD3, MO3T], [wbMO3S, wbMOSD]),
    wbTexturedModel('Female World Model', [MOD4, MO4T], [wbMO4S, nil]),
    wbString(ICO2, 'Female Icon Filename'),
    wbString(MIC2, 'Female Message Icon Filename'),
    wbETYPReq,
    wbStruct(DATA, 'Data', [
      wbInteger('Value', itS32),
      wbInteger('Max Condition', itS32),
      wbFloat('Weight')
    ]).SetRequired,
    wbStruct(DNAM, '', [
      wbInteger('DR', itS16, wbDiv(100)),
      wbInteger('Flags', itU16, wbFlags([
        'Modulates Voice'
      ]))
    ]).SetRequired
  ]);

  wbRecord(BOOK, 'Book',
    wbFlags(wbFlagsList([
      10, 'Quest Item'
    ])), [
    wbEDIDReq,
    wbOBND(True),
    wbFULL,
    wbGenericModel,
    wbICON,
    wbSCRI,
    wbDESCReq,
    wbDEST,
    wbYNAM,
    wbZNAM,
    wbStruct(DATA, 'Data', [
      wbInteger('Flags', itU8, wbFlags([
        'Scroll',
        'Can''t be Taken'
      ])),
      wbInteger('Skill', itS8, wbSkillEnum),
      wbInteger('Value', itS32),
      wbFloat('Weight')
    ]).SetRequired
  ]);

  wbRecord(CELL, 'Cell',
    wbFlags(wbFlagsList([
      10, 'Persistent',
      17, 'Off Limits',
      19, 'Can''t Wait'
    ])), [
    wbEDID,
    wbFULL,
    wbInteger(DATA, 'Flags', itU8, wbFlags([
      {0x01} 'Is Interior Cell',
      {0x02} 'Has water',
      {0x04} 'Can Travel From Here',
      {0x08} 'No LOD Water',
      {0x10} '',
      {0x20} 'Public Area',
      {0x40} 'Hand changed',
      {0x80} 'Behave like exterior'
    ])).SetRequired,
    wbCellGrid,
    wbStruct(XCLL, 'Lighting', [
      wbByteColors('Ambient Color'),
      wbByteColors('Directional Color'),
      wbByteColors('Fog Color'),
      wbFloat('Fog Near'),
      wbFloat('Fog Far'),
      wbInteger('Directional Rotation XY', itS32),
      wbInteger('Directional Rotation Z', itS32),
      wbFloat('Directional Fade'),
      wbFloat('Fog Clip Dist'),
      wbFloat('Fog Power')
    ], cpNormal, False, nil, 7)
      .SetDontShow(wbCellExteriorDontShow)
      .SetIsRemovable(wbCellLightingIsRemovable),
    wbArray(IMPF, 'Footstep Materials', wbString('Unknown', 30), [
      'ConcSolid',
      'ConcBroken',
      'MetalSolid',
      'MetalHollow',
      'MetalSheet',
      'Wood',
      'Sand',
      'Dirt',
      'Grass',
      'Water'
    ]),
    wbRStruct('Light Template', [
      wbFormIDCk(LTMP, 'Template', [LGTM, NULL]),
      wbInteger(LNAM, 'Inherit', itU32, wbFlags([
        {0x00000001}'Ambient Color',
        {0x00000002}'Directional Color',
        {0x00000004}'Fog Color',
        {0x00000008}'Fog Near',
        {0x00000010}'Fog Far',
        {0x00000020}'Directional Rotation',
        {0x00000040}'Directional Fade',
        {0x00000080}'Clip Distance',
        {0x00000100}'Fog Power'
      ])).SetRequired
    ]).SetRequired,
    wbFloat(XCLW, 'Water Height'),
    wbString(XNAM, 'Water Noise Texture'),
    wbArrayS(XCLR, 'Regions', wbFormIDCk('Region', [REGN])),
    wbFormIDCk(XCIM, 'Image Space', [IMGS]),
    wbByteArray(XCET, 'Unknown', 1, cpIgnore),
    wbFormIDCk(XEZN, 'Encounter Zone', [ECZN]),
    wbFormIDCk(XCCM, 'Climate', [CLMT]),
    wbFormIDCk(XCWT, 'Water', [WATR]),
    wbOwnership([XCMT, XCMO]),
    wbFormIDCk(XCAS, 'Acoustic Space', [ASPC]),
    wbByteArray(XCMT, 'Unused', 1, cpIgnore),
    wbFormIDCk(XCMO, 'Music Type', [MUSC])
  ], True)
    .SetAddInfo(wbCellAddInfo)
    .SetAfterLoad(wbCELLAfterLoad);

  wbRecord(CLAS, 'Class', [
    wbEDIDReq,
    wbFULLReq,
    wbDESCReq,
    wbICON,
    wbStruct(DATA, '', [
      wbArray('Tag Skills', wbInteger('Tag Skill', itS32, wbActorValueEnum), 4),
      wbInteger('Flags', itU32, wbFlags(['Playable', 'Guard'], True)),
      wbInteger('Buys/Sells and Services', itU32, wbServiceFlags),
      wbInteger('Teaches', itS8, wbSkillEnum),
      wbInteger('Maximum training level', itU8),
      wbUnused(2)
    ]).SetRequired,
    wbArray(ATTR, 'Attributes', wbInteger('Attribute', itU8), [
      'Strength',
      'Perception',
      'Endurance',
      'Charisma',
      'Intelligence',
      'Agility',
      'Luck'
    ]).SetRequired
  ]);

  wbRecord(CLMT, 'Climate', [
    wbEDIDReq,
    wbArrayS(WLST, 'Weather Types', wbStructSK([0], 'Weather Type', [
      wbFormIDCk('Weather', [WTHR, NULL]),
      wbInteger('Chance', itS32),
      wbFormIDCk('Global', [GLOB, NULL])
    ])),
    wbString(FNAM, 'Sun Texture'),
    wbString(GNAM, 'Sun Glare Texture'),
    wbGenericModel,
    wbClimateTiming(wbClmtTime, wbClmtMoonsPhaseLength)
  ]);

  wbRecord(CONT, 'Container',
    wbFlags(wbFlagsList([
      10, 'Quest Item',
      16, 'Random Anim Start',
      25, 'Obstacle',
      26, 'Navmesh - Filter',
      27, 'Navmesh - Bounding Box',
      30, 'Navmesh - Ground'
    ])).SetFlagHasDontShow(26, wbFlagNavmeshFilterDontShow)
       .SetFlagHasDontShow(27, wbFlagNavmeshBoundingBoxDontShow)
       .SetFlagHasDontShow(30, wbFlagNavmeshGroundDontShow), [
    wbEDIDReq,
    wbOBND(True),
    wbFULL,
    wbGenericModel,
    wbSCRI,
    wbCNTOs,
    wbDEST,
    wbStruct(DATA, '', [
      wbInteger('Flags', itU8, wbFlags(['', 'Respawns'])),
      wbFloat('Weight')
    ]).SetRequired,
    wbFormIDCk(SNAM, 'Sound - Open', [SOUN]),
    wbFormIDCk(QNAM, 'Sound - Close', [SOUN])
  ], True);

  wbRecord(CREA, 'Creature',
    wbFlags(wbFlagsList([
      10, 'Quest Item',
      19, 'Unknown 19',
      29, 'Unknown 29'
    ])), [
    wbEDIDReq,
    wbOBND(True),
    wbFULL.SetDontShow(wbActorTemplateUseBaseData),
    wbGenericModel(False, wbActorTemplateUseModelAnimation),
    wbSPLOs,
    wbFormIDCk(EITM, 'Unarmed Attack Effect', [ENCH, SPEL]).SetDontShow(wbActorTemplateUseActorEffectList),
    wbInteger(EAMT, 'Unarmed Attack Animation', itU16, wbAttackAnimationEnum)
      .SetDontShow(wbActorTemplateUseActorEffectList)
      .SetRequired,
    wbArrayS(NIFZ, 'Model List', wbStringLC('Model')).SetDontShow(wbActorTemplateUseModelAnimation),
    wbModelInfos(NIFT, 'Model List Textures').SetDontShow(wbActorTemplateUseModelAnimation),
    wbStruct(ACBS, 'Configuration', [
      wbInteger('Flags', itU32,
        wbFlags(wbSparseFlags([
          0,  'Biped',
          1,  'Essential',
          2,  'Weapon & Shield?',
          3,  'Respawn',
          4,  'Swims',
          5,  'Flies',
          6,  'Walks',
          7,  'PC Level Mult',
          8,  'Unknown 8',
          9,  'No Low Level Processing',
          10, '',
          11, 'No Blood Spray',
          12, 'No Blood Decal',
          13, '',
          14, '',
          15, 'No Head',
          16, 'No Right Arm',
          17, 'No Left Arm',
          18, 'No Combat in Water',
          19, 'No Shadow',
          20, 'No VATS Melee',
          21, 'Allow PC Dialogue',
          22, 'Can''t Open Doors',
          23, 'Immobile',
          24, 'Tilt Front/Back',
          25, 'Tilt Left/Right',
          26, 'No Knockdowns',
          27, 'Not Pushable',
          28, 'Allow Pickpocket',
          29, 'Is Ghost',
          30, 'No Rotating To Head-track',
          31, 'Invulnerable'
        ], False))
          .SetFlagHasDontShow(0,  wbActorTemplateUseModelAnimation)
          .SetFlagHasDontShow(1,  wbActorTemplateUseBaseData)
          .SetFlagHasDontShow(3,  wbActorTemplateUseBaseData)
          .SetFlagHasDontShow(4,  wbActorTemplateUseModelAnimation)
          .SetFlagHasDontShow(5,  wbActorTemplateUseModelAnimation)
          .SetFlagHasDontShow(6,  wbActorTemplateUseModelAnimation)
          .SetFlagHasDontShow(7,  wbActorTemplateUseStats)
          .SetFlagHasDontShow(9,  wbActorTemplateUseBaseData)
          .SetFlagHasDontShow(10, wbActorTemplateUseModelAnimation)
          .SetFlagHasDontShow(11, wbActorTemplateUseModelAnimation)
          .SetFlagHasDontShow(15, wbActorTemplateUseModelAnimation)
          .SetFlagHasDontShow(16, wbActorTemplateUseModelAnimation)
          .SetFlagHasDontShow(17, wbActorTemplateUseModelAnimation)
          .SetFlagHasDontShow(18, wbActorTemplateUseModelAnimation)
          .SetFlagHasDontShow(19, wbActorTemplateUseModelAnimation)
          .SetFlagHasDontShow(21, wbActorTemplateUseBaseData)
          .SetFlagHasDontShow(22, wbActorTemplateUseBaseData)
          .SetFlagHasDontShow(23, wbActorTemplateUseModelAnimation)
          .SetFlagHasDontShow(24, wbActorTemplateUseModelAnimation)
          .SetFlagHasDontShow(25, wbActorTemplateUseModelAnimation)
          .SetFlagHasDontShow(27, wbActorTemplateUseModelAnimation)
          .SetFlagHasDontShow(28, wbActorTemplateUseBaseData)
          .SetFlagHasDontShow(30, wbActorTemplateUseModelAnimation)
      ).IncludeFlag(dfCollapsed, wbCollapseFlags),
      {04} wbInteger('Fatigue', itU16).SetDontShow(wbActorTemplateUseStats),
      {06} wbInteger('Barter gold', itU16).SetDontShow(wbActorTemplateUseAIData),
      {08} wbUnion('Level', wbCreaLevelDecider, [
             wbInteger('Level', itS16).SetDontShow(wbActorTemplateUseStats),
             wbInteger('Level Mult', itS16, wbDiv(1000)).SetDontShow(wbActorTemplateUseStats)
           ]).SetDontShow(wbActorTemplateUseStats),
      {10} wbInteger('Calc min', itU16).SetDontShow(wbActorTemplateUseStats),
      {12} wbInteger('Calc max', itU16).SetDontShow(wbActorTemplateUseStats),
      {14} wbInteger('Speed Multiplier', itU16).SetDontShow(wbActorTemplateUseStats),
      {16} wbFloat('Karma (Alignment)').SetDontShow(wbActorTemplateUseTraits),
      {20} wbInteger('Disposition Base', itS16).SetDontShow(wbActorTemplateUseTraits),
      {22} wbInteger('Template Flags', itU16, wbTemplateFlags)
    ]).SetRequired,
    wbRArrayS('Factions', wbFaction).SetDontShow(wbActorTemplateUseFactions),
    wbFormIDCk(INAM, 'Death item', [LVLI]).SetDontShow(wbActorTemplateUseTraits),
    wbFormIDCk(VTCK, 'Voice', [VTYP]).SetDontShow(wbActorTemplateUseTraits),
    wbFormIDCk(TPLT, 'Template', [CREA, LVLC]),
    wbDEST.SetDontShow(wbActorTemplateUseModelAnimation),
    wbSCRI.SetDontShow(wbActorTemplateUseScript),
    wbCNTOs.SetDontShow(wbActorTemplateUseInventory),
    wbAIDT,
    wbRArray('Packages', wbFormIDCk(PKID, 'Package', [PACK])).SetDontShow(wbActorTemplateUseAIPackages),
    wbArrayS(KFFZ, 'Animations', wbStringLC('Animation')).SetDontShow(wbActorTemplateUseModelAnimation),
    wbStruct(DATA, '', [
      {00} wbInteger('Type', itU8, wbCreatureTypeEnum).SetDontShow(wbActorTemplateUseTraits),
      {01} wbInteger('Combat Skill', itU8).SetDontShow(wbActorTemplateUseStats),
      {02} wbInteger('Magic Skill', itU8).SetDontShow(wbActorTemplateUseStats),
      {03} wbInteger('Stealth Skill', itU8).SetDontShow(wbActorTemplateUseStats),
      {04} wbInteger('Health', itS16).SetDontShow(wbActorTemplateUseStats),
      {06} wbUnused(2),
      {08} wbInteger('Damage', itS16).SetDontShow(wbActorTemplateUseStats),
      {10} wbArray('Attributes', wbInteger('Attribute', itU8), [
            'Strength',
            'Perception',
            'Endurance',
            'Charisma',
            'Intelligence',
            'Agility',
            'Luck'
          ]).SetDontShow(wbActorTemplateUseStats)
    ]).SetRequired,
    wbInteger(RNAM, 'Attack reach', itU8)
      .SetDontShow(wbActorTemplateUseTraits)
      .SetRequired,
    wbFormIDCk(ZNAM, 'Combat Style', [CSTY]).SetDontShow(wbActorTemplateUseTraits),
    wbFormIDCk(PNAM, 'Body Part Data', [BPTD]).SetDontShow(wbActorTemplateUseModelAnimation).SetRequired,
    wbFloat(TNAM, 'Turning Speed')
      .SetDontShow(wbActorTemplateUseStats)
      .SetRequired,
    wbFloat(BNAM, 'Base Scale')
      .SetDontShow(wbActorTemplateUseStats)
      .SetRequired,
    wbFloat(WNAM, 'Foot Weight')
      .SetDontShow(wbActorTemplateUseStats)
      .SetRequired,
    wbInteger(NAM4, 'Impact Material Type', itU32, wbActorImpactMaterialEnum)
      .SetDontShow(wbActorTemplateUseModelAnimation)
      .SetRequired,
    wbInteger(NAM5, 'Sound Level', itU32, wbSoundLevelEnum)
      .SetDontShow(wbActorTemplateUseModelAnimation)
      .SetRequired,
    wbFormIDCk(CSCR, 'Inherits Sounds from', [CREA]).SetDontShow(wbActorTemplateUseModelAnimation),
    wbRArrayS('Sound Types',
      wbRStructSK([0], 'Sound Type', [
        wbInteger(CSDT, 'Type', itU32,
          wbEnum([
            {0}  'Left Foot',
            {1}  'Right Foot',
            {2}  'Left Back Foot',
            {3}  'Right Back Foot',
            {4}  'Idle',
            {5}  'Aware',
            {6}  'Attack',
            {7}  'Hit',
            {8}  'Death',
            {9}  'Weapon',
            {10} 'Movement',
            {11} 'Conscious'
          ])),
        wbSoundTypeSounds
      ])).SetDontShow(wbActorTemplateUseModelAnimation),
    wbFormIDCk(CNAM, 'Impact Dataset', [IPDS]).SetDontShow(wbActorTemplateUseModelAnimation),
    wbFormIDCk(LNAM, 'Melee Weapon List', [FLST]).SetDontShow(wbActorTemplateUseTraits)
  ], True);

  wbRecord(CSTY, 'Combat Style', [
    wbEDIDReq,
    wbStruct(CSTD, 'Advanced - Standard', [
      {000}wbInteger('Maneuver Decision - Dodge % Chance', itU8),
      {001}wbInteger('Maneuver Decision - Left/Right % Chance', itU8),
      {002}wbUnused(2),
      {004}wbFloat('Maneuver Decision - Dodge L/R Timer (min)'),
      {008}wbFloat('Maneuver Decision - Dodge L/R Timer (max)'),
      {012}wbFloat('Maneuver Decision - Dodge Forward Timer (min)'),
      {016}wbFloat('Maneuver Decision - Dodge Forward Timer (max)'),
      {020}wbFloat('Maneuver Decision - Dodge Back Timer Min'),
      {024}wbFloat('Maneuver Decision - Dodge Back Timer Max'),
      {028}wbFloat('Maneuver Decision - Idle Timer min'),
      {032}wbFloat('Maneuver Decision - Idle Timer max'),
      {036}wbInteger('Melee Decision - Block % Chance', itU8),
      {037}wbInteger('Melee Decision - Attack % Chance', itU8),
      {038}wbUnused(2),
      {040}wbFloat('Melee Decision - Recoil/Stagger Bonus to Attack'),
      {044}wbFloat('Melee Decision - Unconscious Bonus to Attack'),
      {048}wbFloat('Melee Decision - Hand-To-Hand Bonus to Attack'),
      {052}wbInteger('Melee Decision - Power Attacks - Power Attack % Chance', itU8),
      {053}wbUnused(3),
      {056}wbFloat('Melee Decision - Power Attacks - Recoil/Stagger Bonus to Power'),
      {060}wbFloat('Melee Decision - Power Attacks - Unconscious Bonus to Power Attack'),
      {064}wbInteger('Melee Decision - Power Attacks - Normal', itU8),
      {065}wbInteger('Melee Decision - Power Attacks - Forward', itU8),
      {066}wbInteger('Melee Decision - Power Attacks - Back', itU8),
      {067}wbInteger('Melee Decision - Power Attacks - Left', itU8),
      {068}wbInteger('Melee Decision - Power Attacks - Right', itU8),
      {069}wbUnused(3),
      {072}wbFloat('Melee Decision - Hold Timer (min)'),
      {076}wbFloat('Melee Decision - Hold Timer (max)'),
      {080}wbInteger('Flags', itU16, wbFlags([
             'Choose Attack using % Chance',
             'Melee Alert OK',
             'Flee Based on Personal Survival',
             '',
             'Ignore Threats',
             'Ignore Damaging Self',
             'Ignore Damaging Group',
             'Ignore Damaging Spectators',
             'Cannot Use Stealthboy'
           ])),
      {082}wbUnused(2),
      {085}wbInteger('Maneuver Decision - Acrobatic Dodge % Chance', itU8),
      {085}wbInteger('Melee Decision - Power Attacks - Rushing Attack % Chance', itU8),
      {086}wbUnused(2),
      {088}wbFloat('Melee Decision - Power Attacks - Rushing Attack Distance Mult')
    ]).SetRequired,
    wbStruct(CSAD, 'Advanced - Advanced', [
      wbFloat('Dodge Fatigue Mod Mult'),
      wbFloat('Dodge Fatigue Mod Base'),
      wbFloat('Encumb. Speed Mod Base'),
      wbFloat('Encumb. Speed Mod Mult'),
      wbFloat('Dodge While Under Attack Mult'),
      wbFloat('Dodge Not Under Attack Mult'),
      wbFloat('Dodge Back While Under Attack Mult'),
      wbFloat('Dodge Back Not Under Attack Mult'),
      wbFloat('Dodge Forward While Attacking Mult'),
      wbFloat('Dodge Forward Not Attacking Mult'),
      wbFloat('Block Skill Modifier Mult'),
      wbFloat('Block Skill Modifier Base'),
      wbFloat('Block While Under Attack Mult'),
      wbFloat('Block Not Under Attack Mult'),
      wbFloat('Attack Skill Modifier Mult'),
      wbFloat('Attack Skill Modifier Base'),
      wbFloat('Attack While Under Attack Mult'),
      wbFloat('Attack Not Under Attack Mult'),
      wbFloat('Attack During Block Mult'),
      wbFloat('Power Att. Fatigue Mod Base'),
      wbFloat('Power Att. Fatigue Mod Mult')
    ]).SetRequired,
    wbStruct(CSSD, 'Simple', [
      {00} wbFloat('Cover Search Radius'),
      {04} wbFloat('Take Cover Chance'),
      {08} wbFloat('Wait Timer (min)'),
      {12} wbFloat('Wait Timer (max)'),
      {16} wbFloat('Wait to Fire Timer (min)'),
      {20} wbFloat('Wait to Fire Timer (max)'),
      {24} wbFloat('Fire Timer (min)'),
      {28} wbFloat('Fire Timer (max)'),
      {32} wbFloat('Ranged Weapon Range Mult (min)'),
      {36} wbUnused(4),
      {40} wbInteger('Weapon Restrictions', itU32, wbEnum([
        'None',
        'Melee Only',
        'Ranged Only'
      ])),
      {44} wbFloat('Ranged Weapon Range Mult (max)'),
      {48} wbFloat('Max Targeting FOV'),
      {52} wbFloat('Combat Radius'),
      {56} wbFloat('Semi-Auto Firing Delay Mult (min)'),
      {60} wbFloat('Semi-Auto Firing Delay Mult (max)')
    ]).SetRequired
  ]);

  wbRecord(DIAL, 'Dialog Topic', [
    wbEDIDReqKC,
    wbRArrayS('Quests', wbFormIDCkNoReach(QSTI, 'Quest', [QUST], False, cpBenign)),
    wbRArrayS('Quests?', wbFormIDCkNoReach(QSTR, 'Quest?', [QUST], False, cpBenign)),
    wbFULL,
    wbFloat(PNAM, 'Priority')
      .SetDefaultNativeValue(50)
      .SetRequired,
    wbStruct(DATA, '', [
      wbInteger('Type', itU8, wbEnum([
        {0} 'Topic',
        {1} 'Conversation',
        {2} 'Combat',
        {3} 'Persuasion',
        {4} 'Detection',
        {5} 'Service',
        {6} 'Miscellaneous',
        {7} 'Radio'
      ])),
      wbInteger('Flags', itU8, wbFlags([
        'Rumors',
        'Top-level'
      ]))
    ], cpNormal, True, nil, 1),
    wbINOM,
    wbINOA
  ], True);

  wbRecord(DOOR, 'Door',
    wbFlags(wbFlagsList([
      10, 'Quest Item',
      15, 'Visible When Distant',
      16, 'Random Anim Start'
    ])), [
    wbEDIDReq,
    wbOBND(True),
    wbFULL,
    wbGenericModel(True),
    wbSCRI,
    wbDEST,
    wbFormIDCk(SNAM, 'Sound - Open', [SOUN]),
    wbFormIDCk(ANAM, 'Sound - Close', [SOUN]),
    wbFormIDCk(BNAM, 'Sound - Looping', [SOUN]),
    wbInteger(FNAM, 'Flags', itU8, wbFlags([
      '',
      'Automatic Door',
      'Hidden',
      'Minimal Use',
      'Sliding Door'
    ])).SetRequired
  ]);

  wbRecord(EFSH, 'Effect Shader', [
    wbEDID,
    wbString(ICON, 'Fill Texture'),
    wbString(ICO2, 'Particle Shader Texture'),
    wbString(NAM7, 'Holes Texture'),
    wbStruct(DATA, '', [
      wbInteger('Flags', itU8, wbFlags([
        {0} 'No Membrane Shader',
        {1} '',
        {2} '',
        {3} 'No Particle Shader',
        {4} 'Edge Effect - Inverse',
        {5} 'Membrane Shader - Affect Skin Only'
      ])),
      wbUnused(3),
      wbInteger('Membrane Shader - Source Blend Mode', itU32, wbBlendModeEnum),
      wbInteger('Membrane Shader - Blend Operation', itU32, wbBlendOpEnum),
      wbInteger('Membrane Shader - Z Test Function', itU32, wbZTestFuncEnum),
      wbByteColors('Fill/Texture Effect - Color'),
      wbFloat('Fill/Texture Effect - Alpha Fade In Time'),
      wbFloat('Fill/Texture Effect - Full Alpha Time'),
      wbFloat('Fill/Texture Effect - Alpha Fade Out Time'),
      wbFloat('Fill/Texture Effect - Presistent Alpha Ratio'),
      wbFloat('Fill/Texture Effect - Alpha Pulse Amplitude'),
      wbFloat('Fill/Texture Effect - Alpha Pulse Frequency'),
      wbFloat('Fill/Texture Effect - Texture Animation Speed (U)'),
      wbFloat('Fill/Texture Effect - Texture Animation Speed (V)'),
      wbFloat('Edge Effect - Fall Off'),
      wbByteColors('Edge Effect - Color'),
      wbFloat('Edge Effect - Alpha Fade In Time'),
      wbFloat('Edge Effect - Full Alpha Time'),
      wbFloat('Edge Effect - Alpha Fade Out Time'),
      wbFloat('Edge Effect - Persistent Alpha Ratio'),
      wbFloat('Edge Effect - Alpha Pulse Amplitude'),
      wbFloat('Edge Effect - Alpha Pusle Frequence'),
      wbFloat('Fill/Texture Effect - Full Alpha Ratio'),
      wbFloat('Edge Effect - Full Alpha Ratio'),
      wbInteger('Membrane Shader - Dest Blend Mode', itU32, wbBlendModeEnum),
      wbInteger('Particle Shader - Source Blend Mode', itU32, wbBlendModeEnum),
      wbInteger('Particle Shader - Blend Operation', itU32, wbBlendOpEnum),
      wbInteger('Particle Shader - Z Test Function', itU32, wbZTestFuncEnum),
      wbInteger('Particle Shader - Dest Blend Mode', itU32, wbBlendModeEnum),
      wbFloat('Particle Shader - Particle Birth Ramp Up Time'),
      wbFloat('Particle Shader - Full Particle Birth Time'),
      wbFloat('Particle Shader - Particle Birth Ramp Down Time'),
      wbFloat('Particle Shader - Full Particle Birth Ratio'),
      wbFloat('Particle Shader - Persistant Particle Birth Ratio'),
      wbFloat('Particle Shader - Particle Lifetime'),
      wbFloat('Particle Shader - Particle Lifetime +/-'),
      wbFloat('Particle Shader - Initial Speed Along Normal'),
      wbFloat('Particle Shader - Acceleration Along Normal'),
      wbFloat('Particle Shader - Initial Velocity #1'),
      wbFloat('Particle Shader - Initial Velocity #2'),
      wbFloat('Particle Shader - Initial Velocity #3'),
      wbFloat('Particle Shader - Acceleration #1'),
      wbFloat('Particle Shader - Acceleration #2'),
      wbFloat('Particle Shader - Acceleration #3'),
      wbFloat('Particle Shader - Scale Key 1'),
      wbFloat('Particle Shader - Scale Key 2'),
      wbFloat('Particle Shader - Scale Key 1 Time'),
      wbFloat('Particle Shader - Scale Key 2 Time'),
      wbByteColors('Color Key 1 - Color'),
      wbByteColors('Color Key 2 - Color'),
      wbByteColors('Color Key 3 - Color'),
      wbFloat('Color Key 1 - Color Alpha'),
      wbFloat('Color Key 2 - Color Alpha'),
      wbFloat('Color Key 3 - Color Alpha'),
      wbFloat('Color Key 1 - Color Key Time'),
      wbFloat('Color Key 2 - Color Key Time'),
      wbFloat('Color Key 3 - Color Key Time'),
      wbFloat('Particle Shader - Initial Speed Along Normal +/-'),
      wbFloat('Particle Shader - Initial Rotation (deg)'),
      wbFloat('Particle Shader - Initial Rotation (deg) +/-'),
      wbFloat('Particle Shader - Rotation Speed (deg/sec)'),
      wbFloat('Particle Shader - Rotation Speed (deg/sec) +/-'),
      wbFormIDCk('Addon Models', [DEBR, NULL]),
      wbFloat('Holes - Start Time'),
      wbFloat('Holes - End Time'),
      wbFloat('Holes - Start Val'),
      wbFloat('Holes - End Val'),
      wbFloat('Edge Width (alpha units)'),
      wbByteColors('Edge Color'),
      wbFloat('Explosion Wind Speed'),
      wbInteger('Texture Count U', itU32),
      wbInteger('Texture Count V', itU32),
      wbFloat('Addon Models - Fade In Time'),
      wbFloat('Addon Models - Fade Out Time'),
      wbFloat('Addon Models - Scale Start'),
      wbFloat('Addon Models - Scale End'),
      wbFloat('Addon Models - Scale In Time'),
      wbFloat('Addon Models - Scale Out Time')
    ], cpNormal, True, nil, 57)
  ]).SetAfterLoad(wbEFSHAfterLoad);

  wbRecord(ENCH, 'Object Effect', [
    wbEDIDReq,
    wbFULL,
    wbStruct(ENIT, 'Effect Data', [
      wbInteger('Type', itU32, wbEnum([
        {0} '',
        {1} '',
        {2} 'Weapon',
        {3} 'Apparel'
      ])),
      wbUnused(4),
      wbUnused(4),
      wbInteger('Flags', itU8, wbFlags([
        'No Auto-Calc',
        'Unknown 1',
        'Hide Effect'
      ])),
      wbUnused(3)
    ]).SetRequired,
    wbEffectsReq
  ]);

  wbRecord(EYES, 'Eyes', [
    wbEDIDReq,
    wbFULLReq,
    wbString(ICON, 'Texture'),
    wbInteger(DATA, 'Flags', itU8, wbFlags([
      'Playable',
      'Not Male',
      'Not Female'
    ])).SetRequired
  ]);

  wbRecord(FACT, 'Faction', [
    wbEDIDReq,
    wbFULL,
    wbFactionRelations,
    wbStruct(DATA, '', [
      wbInteger('Flags 1', itU8, wbFlags([
        'Hidden from PC',
        'Evil',
        'Special Combat'
      ])),
      wbInteger('Flags 2', itU8, wbFlags([
        'Track Crime',
        'Allow Sell'
      ])),
      wbUnused(2)
    ], cpNormal, True, nil, 1),
    wbFloat(CNAM, 'Unused'),
    wbRArrayS('Ranks',
      wbRStructSK([0], 'Rank', [
        wbInteger(RNAM, 'Rank#', itS32),
        wbString(MNAM, 'Male', 0, cpTranslate),
        wbString(FNAM, 'Female', 0, cpTranslate),
        wbString(INAM, 'Insignia (Unused)')
      ]))
  ]).SetAfterLoad(wbFACTAfterLoad);

  wbRecord(FURN, 'Furniture',
    wbFlags(wbFlagsList([
      10, 'Quest Item',
      16, 'Random Anim Start',
      29, 'Child Can Use'
    ])), [
    wbEDIDReq,
    wbOBND(True),
    wbFULL,
    wbGenericModel(True),
    wbSCRI,
    wbDEST,
    wbByteArray(MNAM, 'Marker Flags').SetRequired
  ]);

  wbRecord(GLOB, 'Global',
    wbFlags(wbFlagsList([
      6, 'Constant'
    ])), [
    wbEDIDReq,
    wbInteger(FNAM, 'Type', itU8, wbEnum([], [
      Ord('s'), 'Short',
      Ord('l'), 'Long',
      Ord('f'), 'Float'
    ])).SetDefaultEditValue('Float').SetRequired,
    wbFloat(FLTV, 'Value').SetRequired
  ]);

  wbRecord(GMST, 'Game Setting', [
    wbString(EDID, 'Editor ID', 0, cpCritical)
      .SetAfterSet(wbGMSTEDIDAfterSet)
      .SetRequired,
    wbUnion(DATA, 'Value', wbGMSTUnionDecider, [
      wbString('Name', 0, cpTranslate),
      wbInteger('Int', itS32),
      wbFloat('Float')
    ]).SetRequired
  ]).SetSummaryKey([1])
    .IncludeFlag(dfIndexEditorID);

  wbRecord(TXST, 'Texture Set', [
    wbEDIDReq,
    wbOBND(True),
    wbRStruct('Textures (RGB/A)', [
      wbString(TX00,'Base Image / Transparency'),
      wbString(TX01,'Normal Map / Specular'),
      wbString(TX02,'Environment Map Mask / ?'),
      wbString(TX03,'Glow Map / Unused'),
      wbString(TX04,'Parallax Map / Unused'),
      wbString(TX05,'Environment Map / Unused')
    ]),
    wbDODT,
    wbInteger(DNAM, 'Flags', itU16, wbFlags([
      'No Specular Map'
    ])).SetRequired
  ]);

  wbRecord(MICN, 'Menu Icon', [
    wbEDIDReq,
    wbICONReq
  ]);

  wbRecord(HDPT, 'Head Part', [
    wbEDIDReq,
    wbFULLReq,
    wbGenericModel,
    wbInteger(DATA, 'Flags', itU8, wbFlags([
      'Playable'
    ])).SetRequired,
    wbRArrayS('Extra Parts',
      wbFormIDCk(HNAM, 'Part', [HDPT])
    )
  ]);

  wbRecord(ASPC, 'Acoustic Space', [
    wbEDIDReq,
    wbOBND(True),
    wbFormIDCk(SNAM, 'Sound - Looping', [SOUN]),
    wbFormIDCk(RDAT, 'Use Sound from Region (Interiors Only)', [REGN]),
    wbInteger(ANAM, 'Environment Type', itU32, wbEnum([
      'None',
      'Default',
      'Generic',
      'Padded Cell',
      'Room',
      'Bathroom',
      'Livingroom',
      'Stone Room',
      'Auditorium',
      'Concerthall',
      'Cave',
      'Arena',
      'Hangar',
      'Carpeted Hallway',
      'Hallway',
      'Stone Corridor',
      'Alley',
      'Forest',
      'City',
      'Mountains',
      'Quarry',
      'Plain',
      'Parkinglot',
      'Sewerpipe',
      'Underwater',
      'Small Room',
      'Medium Room',
      'Large Room',
      'Medium Hall',
      'Large Hall',
      'Plate'
    ])).SetRequired
  ]);

  wbRecord(TACT, 'Talking Activator',
    wbFlags(wbFlagsList([
      9, 'On Local Map',
     10, 'Quest Item',
     13, 'No Voice Filter',
     16, 'Random Anim Start',
     17, 'Radio Station',
     28, 'Non-Pipboy',     //Requires Radio Station
     30, 'Cont. Broadcast' //Requires Radio Station
    ])), [
    wbEDIDReq,
    wbOBND(True),
    wbFULL,
    wbGenericModel(True),
    wbSCRI,
    wbDEST,
    wbFormIDCk(SNAM, 'Sound', [SOUN]),
    wbFormIDCk(VNAM, 'Voice Type', [VTYP])
  ]);

  wbRecord(SCPT, 'Script', [
    wbEDIDReq,
    wbSCHRReq,
    wbByteArray(SCDA, 'Compiled Script'),
    wbStringScript(SCTX, 'Script Source'),
    wbRArrayS('Local Variables', wbRStructSK([0], 'Local Variable', [
      wbSLSD,
      wbString(SCVR, 'Name', 0, cpCritical).SetRequired
    ])),
    wbSCROs
  ]).SetToStr(wbScriptToStr);

  wbRecord(TERM, 'Terminal',
    wbFlags(wbFlagsList([
      10, 'Quest Item',
      16, 'Random Anim Start'
    ])), [
    wbEDIDReq,
    wbOBND(True),
    wbFULL,
    wbGenericModel,
    wbSCRI,
    wbDEST,
    wbDESCReq,
    wbFormIDCk(SNAM, 'Sound - Looping', [SOUN]),
    wbFormIDCk(PNAM, 'Password Note', [NOTE]),
    wbStruct(DNAM, '', [
      wbInteger('Base Hacking Difficulty', itU8, wbEnum([
        'Very Easy',
        'Easy',
        'Average',
        'Hard',
        'Very Hard',
        'Requires Key'
      ])),
      wbInteger('Flags', itU8, wbFlags([
        'Leveled',
        'Unlocked',
        'Alternate Colors',
        'Hide Welcome Text when displaying Image'
      ])),
      wbInteger('ServerType', itU8, wbEnum([
        '-Server 1-',
        '-Server 2-',
        '-Server 3-',
        '-Server 4-',
        '-Server 5-',
        '-Server 6-',
        '-Server 7-',
        '-Server 8-',
        '-Server 9-',
        '-Server 10-'
      ])),
      wbUnused(1)
    ]).SetRequired,
    wbRArray('Menu Items',
      wbRStruct('Menu Item', [
        wbStringKC(ITXT, 'Item Text', 0, cpTranslate),
        wbStringKC(RNAM, 'Result Text', 0, cpTranslate).SetRequired,
        wbInteger(ANAM, 'Flags', itU8, wbFlags([
          'Add Note',
          'Force Redraw'
        ])).SetRequired,
        wbFormIDCk(INAM, 'Display Note', [NOTE]),
        wbFormIDCk(TNAM, 'Sub Menu', [TERM]),
        wbEmbeddedScriptReq,
        wbConditions
      ])
    )
  ]);

  wbRecord(SCOL, 'Static Collection',
    wbFlags(wbFlagsList([
      6, 'Has Tree LOD',
      9, 'On Local Map',
     10, 'Quest Item',
     15, 'Visible When Distant',
     25, 'Obstacle',
     26, 'Navmesh - Filter',
     27, 'Navmesh - Bounding Box',
     30, 'Navmesh - Ground'
    ])).SetFlagHasDontShow(26, wbFlagNavmeshFilterDontShow)
       .SetFlagHasDontShow(27, wbFlagNavmeshBoundingBoxDontShow)
       .SetFlagHasDontShow(30, wbFlagNavmeshGroundDontShow), [
    wbEDIDReq,
    wbOBND(True),
    wbGenericModel(True),
    wbRArray('Parts',
      wbRStruct('Part', [
        wbFormIDCk(ONAM, 'Static', [STAT]),
        wbStaticPartPlacements
      ]).SetRequired
    ).SetRequired
  ]);

  wbRecord(MSTT, 'Moveable Static',
    wbFlags(wbFlagsList([
       9, 'On Local Map',
      10, 'Quest Item',
      16, 'Random Anim Start',
      25, 'Obstacle'
    ])), [
    wbEDIDReq,
    wbOBND(True),
    wbFULL,
    wbGenericModel(True),
    wbDEST,
    wbByteArray(DATA, 'Unknown', 1).SetRequired,
    wbFormIDCk(SNAM, 'Sound', [SOUN])
  ]);

  wbRecord(PWAT, 'Placeable Water', [
    wbEDIDReq,
    wbOBND(True),
    wbGenericModel(True),
    wbStruct(DNAM, '', [
      wbInteger('Flags', itU32, wbFlags([
        {0x00000001}'Reflects',
        {0x00000002}'Reflects - Actors',
        {0x00000004}'Reflects - Land',
        {0x00000008}'Reflects - LOD Land',
        {0x00000010}'Reflects - LOD Buildings',
        {0x00000020}'Reflects - Trees',
        {0x00000040}'Reflects - Sky',
        {0x00000080}'Reflects - Dynamic Objects',
        {0x00000100}'Reflects - Dead Bodies',
        {0x00000200}'Refracts',
        {0x00000400}'Refracts - Actors',
        {0x00000800}'Refracts - Land',
        {0x00001000}'',
        {0x00002000}'',
        {0x00004000}'',
        {0x00008000}'',
        {0x00010000}'Refracts - Dynamic Objects',
        {0x00020000}'Refracts - Dead Bodies',
        {0x00040000}'Silhouette Reflections',
        {0x00080000}'',
        {0x00100000}'',
        {0x00200000}'',
        {0x00400000}'',
        {0x00800000}'',
        {0x01000000}'',
        {0x02000000}'',
        {0x03000000}'',
        {0x08000000}'',
        {0x10000000}'Depth',
        {0x20000000}'Object Texture Coordinates',
        {0x40000000}'',
        {0x80000000}'No Underwater Fog'
      ])),
      wbFormIDCk('Water', [WATR])
    ]).SetRequired
  ]);

  wbRecord(IDLM, 'Idle Marker',
    wbFlags(wbFlagsList([
      10, 'Quest Item',
      29, 'Child Can Use'
    ])), [
    wbEDIDReq,
    wbOBND(True),
    wbInteger(IDLF, 'Flags', itU8, wbFlags([
      'Run in Sequence',
      '',
      'Do Once'
    ])).SetRequired,
    wbStruct(IDLC, '', [
      wbInteger('Animation Count', itU8),
      wbUnused(3)
    ], cpNormal, True, nil, 1),
    wbFloat(IDLT, 'Idle Timer Setting').SetRequired,
    wbArray(IDLA, 'Animations',
      wbFormIDCk('Animation', [IDLE, NULL])
    ).SetAfterSet(wbIDLAsAfterSet)
     .SetRequired  // NULL looks valid if IDLS\Animation Count is 0
  ]).SetAfterSet(wbAnimationsAfterSet);

  wbRecord(NOTE, 'Note', [
    wbEDIDReq,
    wbOBND(True),
    wbFULL,
    wbGenericModel,
    wbICON,
    wbYNAM,
    wbZNAM,
    wbInteger(DATA, 'Type', itU8, wbEnum([
      'Sound',
      'Text',
      'Image',
      'Voice'
    ]), cpNormal, True),
    wbRArrayS('Quests', wbFormIDCkNoReach(ONAM, 'Quest', [QUST])),
    wbString(XNAM, 'Texture'),
    wbUnion(TNAM, 'Text / Topic', wbNOTETNAMDecide, [
      wbStringKC('Text'),
      wbFormIDCk('Topic', [DIAL])
    ]),
    wbUnion(SNAM, 'Sound / NPC', wbNOTESNAMDecide, [
      wbFormIDCk('Sound', [SOUN]),
      wbFormIDCk('NPC', [NPC_])
    ])
  ]);

  wbRecord(PROJ, 'Projectile',
    wbFlags(wbFlagsList([
      27, 'Unknown 27'
    ])), [
    wbEDIDReq,
    wbOBND(True),
    wbFULL,
    wbGenericModel(True),
    wbDEST,
    wbStruct(DATA, 'Data', [
      {00} wbInteger('Flags', itU16, wbFlags([
        'Hitscan',
        'Explosion',
        'Alt. Trigger',
        'Muzzle Flash',
        '',
        'Can Be Disabled',
        'Can Be Picked Up',
        'Supersonic',
        'Pins Limbs',
        'Pass Through Small Transparent'
      ])),
      {00} wbInteger('Type', itU16, wbEnum([
        {00} '',
        {01} 'Missile',
        {02} 'Lobber',
        {03} '',
        {04} 'Beam',
        {05} '',
        {06} '',
        {07} '',
        {08} 'Flame'
      ])),
      {04} wbFloat('Gravity'),
      {08} wbFloat('Speed'),
      {12} wbFloat('Range'),
      {16} wbFormIDCk('Light', [LIGH, NULL]),
      {20} wbFormIDCk('Muzzle Flash - Light', [LIGH, NULL]),
      {24} wbFloat('Tracer Chance'),
      {28} wbFloat('Explosion - Alt. Trigger - Proximity'),
      {32} wbFloat('Explosion - Alt. Trigger - Timer'),
      {36} wbFormIDCk('Explosion', [EXPL, NULL]),
      {40} wbFormIDCk('Sound', [SOUN, NULL]),
      {44} wbFloat('Muzzle Flash - Duration'),
      {48} wbFloat('Fade Duration'),
      {52} wbFloat('Impact Force'),
      {56} wbFormIDCk('Sound - Countdown', [SOUN, NULL]),
      {60} wbFormIDCk('Sound - Disable', [SOUN, NULL]),
      {64} wbFormIDCk('Default Weapon Source', [WEAP, NULL])
    ]).SetRequired,
    wbRStructSK([0], 'Muzzle Flash Model', [
      wbString(NAM1, 'Model FileName'),
      wbModelInfo(NAM2)
    ]).SetSummaryKey([0])
      .SetRequired
      .IncludeFlag(dfCollapsed, wbCollapseModels),
    wbInteger(VNAM, 'Sound Level', itU32, wbSoundLevelEnum).SetRequired
  ]);

  wbRecord(NAVI, 'Navmesh Info Map', [
    wbEDID,
    wbInteger(NVER, 'Version', itU32),
    wbRArray('Navmesh Infos',
      wbStruct(NVMI, 'Navmesh Info', [
        wbByteArray('Unknown', 4),
        wbFormIDCk('Navmesh', [NAVM]),
        wbFormIDCk('Location', [CELL, WRLD]),
        wbStruct('Grid', [
          wbInteger('X', itS16),
          wbInteger('Y', itS16)
        ]),
        wbUnknown
{        wbUnion('Data', wbNAVINVMIDecider, [
          wbStruct('Data', [
            wbUnknown
          ]),
          wbStruct('Data', [
            wbArray('Unknown', wbFloat('Unknown'), 3),
            wbByteArray('Unknown', 4)
          ]),
          wbStruct('Data', [
            wbArray('Unknown', wbArray('Unknown', wbFloat('Unknown'), 3), 3),
            wbInteger('Count 1', itU16),
            wbInteger('Count 2', itU16),
            wbArray('Unknown', wbArray('Unknown', wbFloat('Unknown'), 3), [], wbNAVINAVMGetCount1),
            wbUnknown
          ]),
          wbStruct('Data', [
            wbUnknown
          ])
        ])}
      ])
    ),
    wbRArray('Navmesh Connection Infos',
      wbStruct(NVCI, 'Navmesh Connection Info', [
        wbFormIDCk('Navmesh', [NAVM]),
        wbArray('Unknown', wbFormIDCk('Navmesh', [NAVM]), -1),
        wbArray('Unknown', wbFormIDCk('Navmesh', [NAVM]), -1),
        wbArray('Door Links', wbFormIDCk('Door', [REFR]), -1)
      ])
    )
  ]);

  wbRecord(NAVM, 'Navmesh',
    wbFlags(wbFlagsList([
      11, 'Initially Disabled',
      26, 'Autogen'
    ])), [
    wbEDID,
    wbInteger(NVER, 'Version', itU32),
    wbStruct(DATA, 'Data', [
      wbFormIDCk('Cell', [CELL]),
      wbInteger('Vertex Count', itU32),
      wbInteger('Triangle Count', itU32),
      wbInteger('Edge Link Count', itU32),
      wbInteger('Cover Triangle Count', itU32),
      wbInteger('Door Link Count', itU32)
    ]),
    IfThen(wbSimpleRecords,
      wbArray(NVVX, 'Vertices',
        wbByteArray('Vertex', 12)
      ).SetCountPathOnValue('DATA\Vertex Count', False)
       .IncludeFlag(dfNotAlignable),
      wbArray(NVVX, 'Vertices',
        wbVec3('Vertex')
      ).SetCountPathOnValue('DATA\Vertex Count', False)
       .IncludeFlag(dfNotAlignable)
    ),
    IfThen(wbSimpleRecords,
      wbArray(NVTR, 'Triangles',
        wbByteArray('Triangle', 16)
      ).SetCountPathOnValue('DATA\Triangle Count', False)
       .IncludeFlag(dfNotAlignable),
      wbArray(NVTR, 'Triangles',
        wbStruct('Triangle', [
          wbInteger('Vertex 0', itU16),
          wbInteger('Vertex 1', itU16),
          wbInteger('Vertex 2', itU16),
          wbInteger('Edge 0-1', itS16, wbNVTREdgeToStr, wbNVTREdgeToInt),
          wbInteger('Edge 1-2', itS16, wbNVTREdgeToStr, wbNVTREdgeToInt),
          wbInteger('Edge 2-0', itS16, wbNVTREdgeToStr, wbNVTREdgeToInt),
          wbInteger('Flags', itU16, wbNavmeshTriangleFlags)
            .IncludeFlag(dfCollapsed, wbCollapseFlags),
          wbInteger('Cover Flags', itU16, wbNavmeshCoverFlags)
            .IncludeFlag(dfCollapsed, wbCollapseFlags)
        ])
      ).SetCountPathOnValue('DATA\Triangle Count', False)
       .IncludeFlag(dfNotAlignable)
    ),
    IfThen(wbSimpleRecords,
      wbArray(NVCA, 'Cover Triangles',
        wbByteArray('Cover Triangle', 2)
      ).SetCountPathOnValue('DATA\Cover Triangle Count', False)
       .IncludeFlag(dfNotAlignable),
      wbArray(NVCA, 'Cover Triangles',
        wbInteger('Cover Triangle', itU16)
      ).SetCountPathOnValue('DATA\Cover Triangle Count', False)
       .IncludeFlag(dfNotAlignable)
    ),
    wbArrayS(NVDP, 'Door Links',
      wbStructSK([1, 0], 'Door Link', [
        wbFormIDCk('Door Ref', [REFR]),
        wbInteger('Triangle', itU16),
        wbUnused(2)
      ])
    ).SetCountPathOnValue('DATA\Door Link Count', False)
     .IncludeFlag(dfNotAlignable),
    wbStruct(NVGD, 'Navmesh Grid', [
      wbInteger('Divisor', itU32),
      wbFloat('Max X Distance'),
      wbFloat('Max Y Distance'),
      wbVec3('Min'),
      wbVec3('Max'),
      IfThen(wbSimpleRecords,
        wbArray('Cells',
          wbArray('Cell',
            wbByteArray('Triangle', 2),
          -2).IncludeFlag(dfNotAlignable)
        ).IncludeFlag(dfNotAlignable),
        wbArray('Cells',
          wbArray('Cell',
            wbInteger('Triangle', itU16),
          -2).IncludeFlag(dfNotAlignable)
        ).IncludeFlag(dfNotAlignable)
      )
    ]),
    wbArray(NVEX, 'Edge Links',
      wbStruct('Edge Link', [
        wbInteger('Type', itU32, wbNavmeshEdgeLinkEnum, cpIgnore),
        wbFormIDCk('Navmesh', [NAVM]),
        wbInteger('Triangle', itU16)
      ])
    ).SetCountPathOnValue('DATA\Edge Link Count', False)
     .IncludeFlag(dfNotAlignable)
  ]).SetAddInfo(wbNAVMAddInfo);

  wbRefRecord(PGRE, 'Placed Grenade',
    wbFlags(wbFlagsList([
      10, 'Persistent',
      11, 'Initially Disabled'
    ])), [
    wbEDID,
    wbFormIDCk(NAME, 'Base', [PROJ]).SetRequired,
    wbFormIDCk(XEZN, 'Encounter Zone', [ECZN]),

    wbRagdoll,

    {--- Patrol Data ---}
    wbRStruct('Patrol Data', [
      wbFloat(XPRD, 'Idle Time').SetRequired,
      wbEmpty(XPPA, 'Patrol Script Marker').SetRequired,
      wbFormIDCk(INAM, 'Idle', [IDLE, NULL]).SetRequired,
      wbEmbeddedScriptReq,
      wbFormIDCk(TNAM, 'Topic', [DIAL, NULL]).SetRequired
    ]),

    {--- Ownership ---}
    wbOwnership([XCMT, XCMO]),

    {--- Extra ---}
    wbInteger(XCNT, 'Count', itS32),
    wbFloat(XRDS, 'Radius'),
    wbFloat(XHLP, 'Health'),

    {--- Reflected By / Refracted By ---}
    wbRArrayS('Reflected/Refracted By',
      wbStructSK(XPWR, [0], 'Water', [
        wbFormIDCk('Reference', [REFR]),
        wbInteger('Type', itU32, wbFlags([
          'Reflection',
          'Refraction'
        ]))
      ])
    ),

    {--- Decals ---}
    wbRArrayS('Linked Decals',
      wbStructSK(XDCR, [0], 'Decal', [
        wbFormIDCk('Reference', [REFR]),
        wbUnknown
      ])
    ),

    {--- Linked Ref ---}
    wbFormIDCk(XLKR, 'Linked Reference', [REFR, ACRE, ACHR, PGRE, PMIS, PBEA, PLYR]),
    wbStruct(XCLP, 'Linked Reference Color', [
      wbByteColors('Link Start Color'),
      wbByteColors('Link End Color')
    ]),

    {--- Activate Parents ---}
    wbRStruct('Activate Parents', [
      wbInteger(XAPD, 'Flags', itU8, wbFlags([
        'Parent Activate Only'
      ], True)),
      wbRArrayS('Activate Parent Refs',
        wbStructSK(XAPR, [0], 'Activate Parent Ref', [
          wbFormIDCk('Reference', [REFR, ACRE, ACHR, PGRE, PMIS, PBEA, PLYR]),
          wbFloat('Delay')
        ])
      )
    ]),

    {--- Enable Parent ---}
    wbXESP,

    {--- Emittance ---}
    wbFormIDCk(XEMI, 'Emittance', [LIGH, REGN]),

    {--- MultiBound ---}
    wbFormIDCk(XMBR, 'MultiBound Reference', [REFR]),

    {--- Flags ---}
    wbEmpty(XIBS, 'Ignored By Sandbox'),

    {--- 3D Data ---}
    wbXSCL,
    wbDATAPosRot
  ], True).SetAddInfo(wbPlacedAddInfo);

  wbRefRecord(PMIS, 'Placed Missile', [
    wbEDID,
    wbFormIDCk(NAME, 'Base', [PROJ]).SetRequired,
    wbFormIDCk(XEZN, 'Encounter Zone', [ECZN]),

    wbRagdoll,

    {--- Patrol Data ---}
    wbRStruct('Patrol Data', [
      wbFloat(XPRD, 'Idle Time').SetRequired,
      wbEmpty(XPPA, 'Patrol Script Marker').SetRequired,
      wbFormIDCk(INAM, 'Idle', [IDLE, NULL]).SetRequired,
      wbEmbeddedScriptReq,
      wbFormIDCk(TNAM, 'Topic', [DIAL, NULL]).SetRequired
    ]),

    {--- Ownership ---}
    wbOwnership([XCMT, XCMO]),

    {--- Extra ---}
    wbInteger(XCNT, 'Count', itS32),
    wbFloat(XRDS, 'Radius'),
    wbFloat(XHLP, 'Health'),

    {--- Reflected By / Refracted By ---}
    wbRArrayS('Reflected/Refracted By',
      wbStructSK(XPWR, [0], 'Water', [
        wbFormIDCk('Reference', [REFR]),
        wbInteger('Type', itU32, wbFlags([
          'Reflection',
          'Refraction'
        ]))
      ])
    ),

    {--- Decals ---}
    wbRArrayS('Linked Decals',
      wbStructSK(XDCR, [0], 'Decal', [
        wbFormIDCk('Reference', [REFR]),
        wbUnknown
      ])
    ),

    {--- Linked Ref ---}
    wbFormIDCk(XLKR, 'Linked Reference', [REFR, ACRE, ACHR, PGRE, PMIS, PBEA, PLYR]),
    wbStruct(XCLP, 'Linked Reference Color', [
      wbByteColors('Link Start Color'),
      wbByteColors('Link End Color')
    ]),

    {--- Activate Parents ---}
    wbRStruct('Activate Parents', [
      wbInteger(XAPD, 'Flags', itU8, wbFlags([
        'Parent Activate Only'
      ], True)),
      wbRArrayS('Activate Parent Refs',
        wbStructSK(XAPR, [0], 'Activate Parent Ref', [
          wbFormIDCk('Reference', [REFR, ACRE, ACHR, PGRE, PMIS, PBEA, PLYR]),
          wbFloat('Delay')
        ])
      )
    ]),

    {--- Enable Parent ---}
    wbXESP,

    {--- Emittance ---}
    wbFormIDCk(XEMI, 'Emittance', [LIGH, REGN]),

    {--- MultiBound ---}
    wbFormIDCk(XMBR, 'MultiBound Reference', [REFR]),

    {--- Flags ---}
    wbEmpty(XIBS, 'Ignored By Sandbox'),

    {--- 3D Data ---}
    wbXSCL,
    wbDATAPosRot
  ], True).SetAddInfo(wbPlacedAddInfo);

  wbRefRecord(PBEA, 'Placed Beam', [
    wbEDID,
    wbFormIDCk(NAME, 'Base', [PROJ]).SetRequired,
    wbFormIDCk(XEZN, 'Encounter Zone', [ECZN]),

    wbRagdoll,

    {--- Patrol Data ---}
    wbRStruct('Patrol Data', [
      wbFloat(XPRD, 'Idle Time').SetRequired,
      wbEmpty(XPPA, 'Patrol Script Marker').SetRequired,
      wbFormIDCk(INAM, 'Idle', [IDLE, NULL]).SetRequired,
      wbEmbeddedScriptReq,
      wbFormIDCk(TNAM, 'Topic', [DIAL, NULL]).SetRequired
    ]),

    {--- Ownership ---}
    wbOwnership([XCMT, XCMO]),

    {--- Extra ---}
    wbInteger(XCNT, 'Count', itS32),
    wbFloat(XRDS, 'Radius'),
    wbFloat(XHLP, 'Health'),

    {--- Reflected By / Refracted By ---}
    wbRArrayS('Reflected/Refracted By',
      wbStructSK(XPWR, [0], 'Water', [
        wbFormIDCk('Reference', [REFR]),
        wbInteger('Type', itU32, wbFlags([
          'Reflection',
          'Refraction'
        ]))
      ])
    ),

    {--- Decals ---}
    wbRArrayS('Linked Decals',
      wbStructSK(XDCR, [0], 'Decal', [
        wbFormIDCk('Reference', [REFR]),
        wbUnknown
      ])
    ),

    {--- Linked Ref ---}
    wbFormIDCk(XLKR, 'Linked Reference', [REFR, ACRE, ACHR, PGRE, PMIS, PBEA, PLYR]),
    wbStruct(XCLP, 'Linked Reference Color', [
      wbByteColors('Link Start Color'),
      wbByteColors('Link End Color')
    ]),

    {--- Activate Parents ---}
    wbRStruct('Activate Parents', [
      wbInteger(XAPD, 'Flags', itU8, wbFlags([
        'Parent Activate Only'
      ], True)),
      wbRArrayS('Activate Parent Refs',
        wbStructSK(XAPR, [0], 'Activate Parent Ref', [
          wbFormIDCk('Reference', [REFR, ACRE, ACHR, PGRE, PMIS, PBEA, PLYR]),
          wbFloat('Delay')
        ])
      )
    ]),

    {--- Enable Parent ---}
    wbXESP,

    {--- Emittance ---}
    wbFormIDCk(XEMI, 'Emittance', [LIGH, REGN]),

    {--- MultiBound ---}
    wbFormIDCk(XMBR, 'MultiBound Reference', [REFR]),

    {--- Flags ---}
    wbEmpty(XIBS, 'Ignored By Sandbox'),

    {--- 3D Data ---}
    wbXSCL,
    wbDATAPosRot
  ], True).SetAddInfo(wbPlacedAddInfo);

   wbRecord(EXPL, 'Explosion', [
    wbEDIDReq,
    wbOBND(True),
    wbFULL,
    wbGenericModel,
    wbEITM,
    wbFormIDCk(MNAM, 'Image Space Modifier', [IMAD]),
    wbStruct(DATA, 'Data', [
      {00} wbFloat('Force'),
      {04} wbFloat('Damage'),
      {08} wbFloat('Radius'),
      {12} wbFormIDCk('Light', [LIGH, NULL]),
      {16} wbFormIDCk('Sound 1', [SOUN, NULL]),
      {20} wbInteger('Flags', itU32, wbFlags([
             {0x00000001}'Unknown 1',
             {0x00000002}'Always Uses World Orientation',
             {0x00000004}'Knock Down - Always',
             {0x00000008}'Knock Down - By Formula',
             {0x00000010}'Ignore LOS Check',
             {0x00000020}'Push Explosion Source Ref Only',
             {0x00000040}'Ignore Image Space Swap'
           ])),
      {24} wbFloat('IS Radius'),
      {28} wbFormIDCk('Impact DataSet', [IPDS, NULL]),
      {32} wbFormIDCk('Sound 2', [SOUN, NULL]),
           wbStruct('Radiation', [
             {36} wbFloat('Level'),
             {40} wbFloat('Dissipation Time'),
             {44} wbFloat('Radius')
           ]),
      {48} wbInteger('Sound Level', itU32, wbSoundLevelEnum)
    ]).SetRequired,
    wbFormIDCk(INAM, 'Placed Impact Object', [TREE, SOUN, ACTI, DOOR, STAT, FURN,
          CONT, ARMO, AMMO, LVLN, LVLC, MISC, WEAP, BOOK, KEYM, ALCH, LIGH, GRAS,
          ASPC, IDLM, ARMA, MSTT, NOTE, PWAT, SCOL, TACT, TERM, TXST])
  ]);

  wbRecord(DEBR, 'Debris', [
    wbEDIDReq,
    wbRArray('Models', wbDebrisModel(wbMODT)).SetRequired
  ]);

  wbRecord(IMGS, 'Image Space', [
    wbEDIDReq,
    wbStruct(DNAM, '', [
      wbStruct('HDR', [
        {00} wbFloat('Eye Adapt Speed'),
        {04} wbFloat('Blur Radius'),
        {08} wbFloat('Blur Passes'),
        {12} wbFloat('Emissive Mult'),
        {16} wbFloat('Target LUM'),
        {20} wbFloat('Upper LUM Clamp'),
        {24} wbFloat('Bright Scale'),
        {28} wbFloat('Bright Clamp'),
        {32} wbFloat('LUM Ramp No Tex'),
        {36} wbFloat('LUM Ramp Min'),
        {40} wbFloat('LUM Ramp Max'),
        {44} wbFloat('Sunlight Dimmer'),
        {48} wbFloat('Grass Dimmer'),
        {52} wbFloat('Tree Dimmer'),
        {56} wbFromVersion(10, wbFloat('Skin Dimmer'))
      ], cpNormal, False, nil, 14),
      wbStruct('Bloom', [
        {60} wbFloat('Blur Radius'),
        {64} wbFloat('Alpha Mult Interior'),
        {68} wbFloat('Alpha Mult Exterior')
      ]),
      wbStruct('Get Hit', [
        {72} wbFloat('Blur Radius'),
        {76} wbFloat('Blur Damping Constant'),
        {80} wbFloat('Damping Constant')
      ]),
      wbStruct('Night Eye', [
        wbFloatColors('Tint Color'),
      {96} wbFloat('Brightness')
      ]),
      wbStruct('Cinematic', [
        {100} wbFloat('Saturation'),
        wbStruct('Contrast', [
          {104} wbFloat('Avg Lum Value'),
          {108} wbFloat('Value')
        ]),
        {112} wbFloat('Cinematic - Brightness - Value'),
        wbStruct('Tint', [
          wbFloatColors('Color'),
        {128} wbFloat('Value')
        ])
      ]),
      wbByteArray('Unknown', 4),
      wbFromVersion(10, wbUnused(4)),
      wbFromVersion(10, wbUnused(4)),
      wbFromVersion(10, wbUnused(4)),
      wbFromVersion(13, wbInteger('Flags', itU8, wbFlags([
        'Saturation',
        'Contrast',
        'Tint',
        'Brightness'
      ], True))),
      wbFromVersion(13, wbUnused(3))
    ], cpNormal, True, nil, 5)
  ]);

  wbRecord(IMAD, 'Image Space Adapter', [
    wbEDID,
    wbStruct(DNAM, 'Data Count', [
      wbInteger('Flags', itU32, wbFlags(['Animatable'])),
      wbFloat('Duration'),
      wbStruct('HDR', [
        wbInteger('Eye Adapt Speed Mult', itU32),
        wbInteger('Eye Adapt Speed Add', itU32),
        wbInteger('Bloom Blur Radius Mult', itU32),
        wbInteger('Bloom Blur Radius Add', itU32),
        wbInteger('Bloom Threshold Mult', itU32),
        wbInteger('Bloom Threshold Add', itU32),
        wbInteger('Bloom Scale Mult', itU32),
        wbInteger('Bloom Scale Add', itU32),
        wbInteger('Target Lum Min Mult', itU32),
        wbInteger('Target Lum Min Add', itU32),
        wbInteger('Target Lum Max Mult', itU32),
        wbInteger('Target Lum Max Add', itU32),
        wbInteger('Sunlight Scale Mult', itU32),
        wbInteger('Sunlight Scale Add', itU32),
        wbInteger('Sky Scale Mult', itU32),
        wbInteger('Sky Scale Add', itU32)
      ]),
      wbInteger('Unknown08 Mult', itU32),
      wbInteger('Unknown48 Add', itU32),
      wbInteger('Unknown09 Mult', itU32),
      wbInteger('Unknown49 Add', itU32),
      wbInteger('Unknown0A Mult', itU32),
      wbInteger('Unknown4A Add', itU32),
      wbInteger('Unknown0B Mult', itU32),
      wbInteger('Unknown4B Add', itU32),
      wbInteger('Unknown0C Mult', itU32),
      wbInteger('Unknown4C Add', itU32),
      wbInteger('Unknown0D Mult', itU32),
      wbInteger('Unknown4D Add', itU32),
      wbInteger('Unknown0E Mult', itU32),
      wbInteger('Unknown4E Add', itU32),
      wbInteger('Unknown0F Mult', itU32),
      wbInteger('Unknown4F Add', itU32),
      wbInteger('Unknown10 Mult', itU32),
      wbInteger('Unknown50 Add', itU32),
      wbStruct('Cinematic', [
        wbInteger('Saturation Mult', itU32),
        wbInteger('Saturation Add', itU32),
        wbInteger('Brightness Mult', itU32),
        wbInteger('Brightness Add', itU32),
        wbInteger('Contrast Mult', itU32),
        wbInteger('Contrast Add', itU32)
      ]),
      wbInteger('Unknown14 Mult', itU32),
      wbInteger('Unknown54 Add', itU32),
      wbInteger('Tint Color', itU32),
      wbInteger('Blur Radius', itU32),
      wbInteger('Double Vision Strength', itU32),
      wbInteger('Radial Blur Strength', itU32),
      wbInteger('Radial Blur Ramp Up', itU32),
      wbInteger('Radial Blur Start', itU32),
      wbInteger('Radial Blur Flags', itU32, wbFlags(['Use Target'])),
      wbFloat('Radial Blur Center X'),
      wbFloat('Radial Blur Center Y'),
      wbInteger('DoF Strength', itU32),
      wbInteger('DoF Distance', itU32),
      wbInteger('DoF Range', itU32),
      wbInteger('DoF Use Target', itU8, wbBoolEnum),
      wbInteger('Unused', itU8),
      wbInteger('Unused', itU16),
      wbInteger('Radial Blur Ramp Down', itU32),
      wbInteger('Radial Blur Down Start', itU32),
      wbInteger('Fade Color', itU32),
      wbInteger('Motion Blur Strength', itU32)
    ], cpNormal, True, nil, 26),
    wbTimeInterpolators(BNAM, 'Blur Radius'),
    wbTimeInterpolators(VNAM, 'Double Vision Strength'),
    wbArray(TNAM, 'Tint Color', wbColorInterpolator),
    wbArray(NAM3, 'Fade Color', wbColorInterpolator),
    wbRStruct('Radial Blur', [
      wbTimeInterpolators(RNAM, 'Strength'),
      wbTimeInterpolators(SNAM, 'Ramp Up'),
      wbTimeInterpolators(UNAM, 'Start'),
      wbTimeInterpolators(NAM1, 'Ramp Down'),
      wbTimeInterpolators(NAM2, 'Down Start')
    ]),
    wbRStruct('Depth of Field', [
      wbTimeInterpolators(WNAM, 'Strength'),
      wbTimeInterpolators(XNAM, 'Distance'),
      wbTimeInterpolators(YNAM, 'Range')
    ]),
    wbTimeInterpolators(NAM4, 'Motion Blur Strength'),
    wbRStruct('HDR', [
      wbTimeInterpolatorsMultAdd(_00_IAD, _40_IAD, 'Eye Adapt Speed'),
      wbTimeInterpolatorsMultAdd(_01_IAD, _41_IAD, 'Blur Radius'),
      wbTimeInterpolatorsMultAdd(_02_IAD, _42_IAD, 'Skin Dimmer'),
      wbTimeInterpolatorsMultAdd(_03_IAD, _43_IAD, 'Emissive Mult'),
      wbTimeInterpolatorsMultAdd(_04_IAD, _44_IAD, 'Target LUM'),
      wbTimeInterpolatorsMultAdd(_05_IAD, _45_IAD, 'Upper LUM Clamp'),
      wbTimeInterpolatorsMultAdd(_06_IAD, _46_IAD, 'Bright Scale'),
      wbTimeInterpolatorsMultAdd(_07_IAD, _47_IAD, 'Bright Clamp'),
      wbTimeInterpolatorsMultAdd(_08_IAD, _48_IAD, 'LUM Ramp No Tex'),
      wbTimeInterpolatorsMultAdd(_09_IAD, _49_IAD, 'LUM Ramp Min'),
      wbTimeInterpolatorsMultAdd(_0A_IAD, _4A_IAD, 'LUM Ramp Max'),
      wbTimeInterpolatorsMultAdd(_0B_IAD, _4B_IAD, 'Sunlight Dimmer'),
      wbTimeInterpolatorsMultAdd(_0C_IAD, _4C_IAD, 'Grass Dimmer'),
      wbTimeInterpolatorsMultAdd(_0D_IAD, _4D_IAD, 'Tree Dimmer')
    ]),
    wbRStruct('Bloom', [
      wbTimeInterpolatorsMultAdd(_0E_IAD, _4E_IAD, 'Blur Radius'),
      wbTimeInterpolatorsMultAdd(_0F_IAD, _4F_IAD, 'Alpha Mult Interior'),
      wbTimeInterpolatorsMultAdd(_10_IAD, _50_IAD, 'Alpha Mult Exterior')
    ]),
    wbCinematicIMAD
  ]);

  wbRecord(FLST, 'FormID List', [
    wbString(EDID, 'Editor ID', 0, cpBenign)
      .SetAfterSet(wbFLSTEDIDAfterSet)
      .SetRequired,
    wbRArrayS('FormIDs', wbFormID(LNAM, 'FormID'), cpNormal, False, nil, nil, nil, wbFLSTLNAMIsSorted)
  ]);

  wbRecord(PERK, 'Perk', [
    wbEDIDReq,
    wbFULL,
    wbDESCReq,
    wbICON,
    wbConditions,
    wbStruct(DATA, 'Data', [
      wbInteger('Trait', itU8, wbBoolEnum),
      wbInteger('Min Level', itU8),
      wbInteger('Ranks', itU8),
      wbInteger('Playable', itU8, wbBoolEnum),
      wbInteger('Hidden', itU8, wbBoolEnum)
    ], cpNormal, True, nil, 4),
    wbRArrayS('Effects',
      wbRStructSK([0, 1], 'Effect', [
        wbStructSK(PRKE, [1, 2, 0], 'Header', [
          wbPerkEffectType(wbPERKPRKETypeAfterSet),
          wbInteger('Rank', itU8),
          wbInteger('Priority', itU8)
        ]),
        wbUnion(DATA, 'Effect Data', wbPerkDATADecider, [
          wbStructSK([0, 1], 'Quest + Stage', [
            wbFormIDCk('Quest', [QUST]),
            wbInteger('Quest Stage', itU8, wbPerkDATAQuestStageToStr, wbCTDAParam2QuestStageToInt),
            wbUnused(3)
          ]),
          wbFormIDCk('Ability', [SPEL]),
          wbStructSK([0, 1], 'Entry Point', [
            wbInteger('Entry Point', itU8,
              wbEnum([
                {00} 'Calculate Weapon Damage',
                {01} 'Calculate My Critical Hit Chance',
                {02} 'Calculate My Critical Hit Damage',
                {03} 'Calculate Weapon Attack AP Cost',
                {04} 'Calculate Mine Explode Chance',
                {05} 'Adjust Range Penalty',
                {06} 'Adjust Limb Damage',
                {07} 'Calculate Weapon Range',
                {08} 'Calculate To Hit Chance',
                {09} 'Adjust Experience Points',
                {10} 'Adjust Gained Skill Points',
                {11} 'Adjust Book Skill Points',
                {12} 'Modify Recovered Health',
                {13} 'Calculate Inventory AP Cost',
                {14} 'Get Disposition',
                {15} 'Get Should Attack',
                {16} 'Get Should Assist',
                {17} 'Calculate Buy Price',
                {18} 'Get Bad Karma',
                {19} 'Get Good Karma',
                {20} 'Ignore Locked Terminal',
                {21} 'Add Leveled List On Death',
                {22} 'Get Max Carry Weight',
                {23} 'Modify Addiction Chance',
                {24} 'Modify Addiction Duration',
                {25} 'Modify Positive Chem Duration',
                {26} 'Adjust Drinking Radiation',
                {27} 'Activate',
                {28} 'Mysterious Stranger',
                {29} 'Has Paralyzing Palm',
                {30} 'Hacking Science Bonus',
                {31} 'Ignore Running During Detection',
                {32} 'Ignore Broken Lock',
                {33} 'Has Concentrated Fire',
                {34} 'Calculate Gun Spread',
                {35} 'Player Kill AP Reward',
                {36} 'Modify Enemy Critical Hit Chance'
              ])).SetAfterSet(wbPERKEntryPointAfterSet),
            wbInteger('Function', itU8, wbPerkDATAFunctionToStr, wbPerkDATAFunctionToInt).SetAfterSet(wbPerkDATAFunctionAfterSet),
            wbInteger('Perk Condition Tab Count', itU8, nil, cpIgnore)
          ])
        ]).SetRequired,
        wbRArrayS('Perk Conditions',
          wbRStructSK([0], 'Perk Condition', [
            wbInteger(PRKC, 'Run On', itS8, wbPRKCToStr, wbPRKCToInt),
            wbConditions.SetRequired
          ]).SetDontShow(wbPERKPRKCDontShow)),
        wbRStruct('Entry Point Function Parameters', [
          wbInteger(EPFT, 'Type', itU8, wbPerkEPFTToStr, wbPerkEPFTToInt, cpIgnore).SetAfterSet(wbPerkEPFTAfterSet),
          wbUnion(EPFD, 'Data', wbEPFDDecider, [
            wbByteArray('Unknown'),
            wbFloat('Float'),
            wbStruct('Float, Float', [
              wbFloat('Float 1'),
              wbFloat('Float 2')
            ]),
            wbFormIDCk('Leveled Item', [LVLI]),
            wbEmpty('None (Script)'),
            wbStruct('Actor Value, Float', [
              wbInteger('Actor Value', itU32, wbEPFDActorValueToStr, wbEPFDActorValueToInt),
              wbFloat('Float')
            ])
          ]).SetDontShow(wbEPFDDontShow),
          wbStringKC(EPF2, 'Button Label').SetDontShow(wbEPF2DontShow),
          wbInteger(EPF3, 'Run Immediately', itU16, wbBoolEnum).SetDontShow(wbEPF2DontShow),
          wbEmbeddedScript.SetDontShow(wbEPF2DontShow)
        ]).SetDontShow(wbPERKPRKCDontShow),
        wbEmpty(PRKF, 'End Marker', cpIgnore).SetRequired
      ]))
  ]);

  wbRecord(BPTD, 'Body Part Data', [
    wbEDIDReq,
    wbGenericModel(True),
    wbRStructS('Body Parts', 'Body Part', [
      wbString(BPTN, 'Part Name').SetRequired,
      wbString(BPNN, 'Part Node').SetRequired,
      wbString(BPNT, 'VATS Target').SetRequired,
      wbString(BPNI, 'IK Data - Start Node').SetRequired,
      wbStruct(BPND, '', [
        wbFloat('Damage Mult'),
        wbInteger('Flags', itU8,
          wbFlags([
            {0} 'Severable',
            {1} 'IK Data',
            {2} 'IK Data - Biped Data',
            {3} 'Explodable',
            {4} 'IK Data - Is Head',
            {5} 'IK Data - Headtracking',
            {6} 'To Hit Chance - Absolute'
          ])).IncludeFlag(dfCollapsed, wbCollapseFlags),
        wbInteger('Part Type', itS8, wbBodyLocationEnum),
        wbInteger('Health Percent', itU8),
        wbInteger('Actor Value', itS8, wbActorValueEnum),
        wbInteger('To Hit Chance', itU8),
        wbInteger('Explodable - Explosion Chance %', itU8),
        wbInteger('Explodable - Debris Count', itU16),
        wbFormIDCk('Explodable - Debris', [DEBR, NULL]),
        wbFormIDCk('Explodable - Explosion', [EXPL, NULL]),
        wbFloat('Tracking Max Angle'),
        wbFloat('Explodable - Debris Scale'),
        wbInteger('Severable - Debris Count', itS32),
        wbFormIDCk('Severable - Debris', [DEBR, NULL]),
        wbFormIDCk('Severable - Explosion', [EXPL, NULL]),
        wbFloat('Severable - Debris Scale'),
        wbVec3PosRot('Gore Effects Positioning'),
        wbFormIDCk('Severable - Impact DataSet', [IPDS, NULL]),
        wbFormIDCk('Explodable - Impact DataSet', [IPDS, NULL]),
        wbInteger('Severable - Decal Count', itU8),
        wbInteger('Explodable - Decal Count', itU8),
        wbUnused(2),
        wbFloat('Limb Replacement Scale')
      ]).SetRequired,
      wbString(NAM1, 'Limb Replacement Model').SetRequired,
      wbString(NAM4, 'Gore Effects - Target Bone').SetRequired,
      wbModelInfo(NAM5)
    ]).SetRequired,
    wbFormIDCk(RAGA, 'Ragdoll', [RGDL])
  ]);

  wbRecord(ADDN, 'Addon Node', [
    wbEDIDReq,
    wbOBND(True),
    wbGenericModel(True),
    wbInteger(DATA, 'Node Index', itS32).SetRequired,
    wbFormIDCk(SNAM, 'Sound', [SOUN]),
    wbStruct(DNAM, 'Data', [
      wbInteger('Master Particle System Cap', itU16),
      wbByteArray('Unknown', 2)
    ]).SetRequired
  ]);

  wbRecord(AVIF, 'ActorValue Information', [
    wbEDIDReq,
    wbFULL,
    wbDESCReq,
    wbICON,
    wbStringKC(ANAM, 'Short Name', 0, cpTranslate)
  ]);

  wbRecord(RADS, 'Radiation Stage', [
    wbEDIDReq,
    wbStruct(DATA, '', [
      wbInteger('Trigger Threshold', itU32),
      wbFormIDCk('Actor Effect', [SPEL])
    ]).SetRequired
  ]);

  wbRecord(CAMS, 'Camera Shot', [
    wbEDIDReq,
    wbGenericModel,
    wbStruct(DATA, 'Data', [
      {00} wbInteger('Action', itU32, wbEnum([
        'Shoot',
        'Fly',
        'Hit',
        'Zoom'
      ])),
      {04} wbInteger('Location', itU32, wbEnum([
        'Attacker',
        'Projectile',
        'Target'
      ])),
      {08} wbInteger('Target', itU32, wbEnum([
        'Attacker',
        'Projectile',
        'Target'
      ])),
      {12} wbInteger('Flags', itU32, wbFlags([
        'Position Follows Location',
        'Rotation Follows Target',
        'Don''t Follow Bone',
        'First Person Camera',
        'No Tracer',
        'Start At Time Zero'
      ])),
      wbStruct('Time Multipliers', [
        {16} wbFloat('Player'),
        {20} wbFloat('Target'),
        {24} wbFloat('Global')
      ]),
      {28} wbFloat('Max Time'),
      {32} wbFloat('Min Time'),
      {36} wbFloat('Target % Between Actors')
    ], cpNormal, True, nil, 7),
    wbFormIDCk(MNAM, 'Image Space Modifier', [IMAD])
  ]);

  wbRecord(CPTH, 'Camera Path', [
    wbEDIDReq,
    wbConditions,
    wbArray(ANAM, 'Related Camera Paths', wbFormIDCk('Related Camera Path', [CPTH, NULL]), ['Parent', 'Previous Sibling']).SetRequired,
    wbInteger(DATA, 'Camera Zoom', itU8, wbEnum([
      'Default',
      'Disable',
      'Shot List'
    ])).SetRequired,
    wbRArray('Camera Shots', wbFormIDCk(SNAM, 'Camera Shot', [CAMS]))
  ]);

  wbRecord(VTYP, 'Voice Type', [
    wbEDIDReq,
    wbInteger(DNAM, 'Flags', itU8, wbFlags([
      'Allow Default Dialog',
      'Female'
    ])).SetRequired
  ]);

  wbRecord(IPCT, 'Impact', [
    wbEDIDReq,
    wbGenericModel,
    wbStruct(DATA, '', [
      wbFloat('Effect - Duration'),
      wbInteger('Effect - Orientation', itU32, wbEnum([
        'Surface Normal',
        'Projectile Vector',
        'Projectile Reflection'
      ])),
      wbFloat('Angle Threshold'),
      wbFloat('Placement Radius'),
      wbInteger('Sound Level', itU32, wbSoundLevelEnum),
      wbInteger('Flags', itU32, wbFlags([
        'No Decal Data'
      ]))
    ]).SetRequired,
    wbDODT,
    wbFormIDCk(DNAM, 'Texture Set', [TXST]),
    wbFormIDCk(SNAM, 'Sound 1', [SOUN]),
    wbFormIDCk(NAM1, 'Sound 2', [SOUN])
  ]);

  wbRecord(IPDS, 'Impact DataSet', [
    wbEDIDReq,
    wbStruct(DATA, 'Impacts', [
      wbFormIDCk('Stone', [IPCT, NULL]),
      wbFormIDCk('Dirt', [IPCT, NULL]),
      wbFormIDCk('Grass', [IPCT, NULL]),
      wbFormIDCk('Glass', [IPCT, NULL]),
      wbFormIDCk('Metal', [IPCT, NULL]),
      wbFormIDCk('Wood', [IPCT, NULL]),
      wbFormIDCk('Organic', [IPCT, NULL]),
      wbFormIDCk('Cloth', [IPCT, NULL]),
      wbFormIDCk('Water', [IPCT, NULL]),
      wbFormIDCk('Hollow Metal', [IPCT, NULL]),
      wbFormIDCk('Organic Bug', [IPCT, NULL]),
      wbFormIDCk('Organic Glow', [IPCT, NULL])
    ], cpNormal, True, nil, 9)
  ]);

  wbRecord(ECZN, 'Encounter Zone', [
    wbEDIDReq,
    wbStruct(DATA, '', [
      wbFormIDCkNoReach('Owner', [NPC_, FACT, NULL]),
      wbInteger('Rank', itS8),
      wbInteger('Minimum Level', itS8),
      wbInteger('Flags', itU8, wbFlags([
        'Never Resets',
        'Match PC Below Minimum Level'
      ])),
      wbUnused(1)
    ]).SetRequired
  ]);

  wbRecord(MESG, 'Message', [
    wbEDIDReq,
    wbDESCReq,
    wbFULL,
    wbFormIDCk(INAM, 'Icon', [MICN, NULL]).SetRequired,
    wbByteArray(NAM0, 'Unused', 0, cpIgnore),
    wbByteArray(NAM1, 'Unused', 0, cpIgnore),
    wbByteArray(NAM2, 'Unused', 0, cpIgnore),
    wbByteArray(NAM3, 'Unused', 0, cpIgnore),
    wbByteArray(NAM4, 'Unused', 0, cpIgnore),
    wbByteArray(NAM5, 'Unused', 0, cpIgnore),
    wbByteArray(NAM6, 'Unused', 0, cpIgnore),
    wbByteArray(NAM7, 'Unused', 0, cpIgnore),
    wbByteArray(NAM8, 'Unused', 0, cpIgnore),
    wbByteArray(NAM9, 'Unused', 0, cpIgnore),
    wbInteger(DNAM, 'Flags', itU32, wbFlags([
      'Message Box',
      'Auto Display'
    ])).SetAfterSet(wbMESGDNAMAfterSet)
       .SetRequired,
    wbInteger(TNAM, 'Display Time', itU32).SetDontShow(wbMESGTNAMDontShow),
    wbRArray('Menu Buttons',
      wbRStruct('Menu Button', [
        wbStringKC(ITXT, 'Button Text', 0, cpTranslate),
        wbConditions
      ]))
  ]).SetAfterLoad(wbMESGAfterLoad);

  wbRecord(RGDL, 'Ragdoll', [
    wbEDIDReq,
    wbInteger(NVER, 'Version', itU32).SetRequired,
    wbStruct(DATA, 'General Data', [
      wbInteger('Dynamic Bone Count', itU32),
      wbUnused(4),
      wbStruct('Enabled', [
        wbInteger('Feedback', itU8, wbBoolEnum),
        wbInteger('Foot IK (broken, don''t use)', itU8, wbBoolEnum),
        wbInteger('Look IK (broken, don''t use)', itU8, wbBoolEnum),
        wbInteger('Grab IK (broken, don''t use)', itU8, wbBoolEnum),
        wbInteger('Pose Matching', itU8, wbBoolEnum)
      ]),
      wbUnused(1)
    ]).SetRequired,
    wbFormIDCk(XNAM, 'Actor Base', [CREA, NPC_]).SetRequired,
    wbFormIDCk(TNAM, 'Body Part Data', [BPTD]).SetRequired,
    wbStruct(RAFD, 'Feedback Data', [
    {00} wbFloat('Dynamic/Keyframe Blend Amount'),
    {04} wbFloat('Hierarchy Gain'),
    {08} wbFloat('Position Gain'),
    {12} wbFloat('Velocity Gain'),
    {16} wbFloat('Acceleration Gain'),
    {20} wbFloat('Snap Gain'),
    {24} wbFloat('Velocity Damping'),
         wbStruct('Snap Max Settings', [
           {28} wbFloat('Linear Velocity'),
           {32} wbFloat('Angular Velocity'),
           {36} wbFloat('Linear Distance'),
           {40} wbFloat('Angular Distance')
         ]),
         wbStruct('Position Max Velocity', [
           {44} wbFloat('Linear'),
           {48} wbFloat('Angular')
         ]),
         wbStruct('Position Max Velocity', [
           {52} wbInteger('Projectile', itS32, wbDiv(1000)),
           {56} wbInteger('Melee', itS32, wbDiv(1000))
         ])
    ]).SetRequired,
    wbArray(RAFB, 'Feedback Dynamic Bones', wbInteger('Bone', itU16)).SetRequired,
    wbStruct(RAPS, 'Pose Matching Data', [
    {00} wbArray('Match Bones', wbInteger('Bone', itU16, wbHideFFFF), 3),
    {06} wbInteger('Flags', itU8, wbFlags([
           'Disable On Move'
         ])),
    {07} wbUnused(1),
    {08} wbFloat('Motors Strength'),
    {12} wbFloat('Pose Activation Delay Time'),
    {16} wbFloat('Match Error Allowance'),
    {20} wbFloat('Displacement To Disable')
    ]).SetRequired,
    wbString(ANAM, 'Death Pose')
  ]);

  wbRecord(DOBJ, 'Default Object Manager', [
    wbEDIDReq,
    wbArray(DATA, 'Default Objects', wbFormID('Default Object'), [
      'Stimpak',
      'SuperStimpak',
      'RadX',
      'RadAway',
      'Morphine',
      'Perk Paralysis',
      'Player Faction',
      'Mysterious Stranger NPC',
      'Mysterious Stranger Faction',
      'Default Music',
      'Battle Music',
      'Death Music',
      'Success Music',
      'Level Up Music',
      'Player Voice (Male)',
      'Player Voice (Male Child)',
      'Player Voice (Female)',
      'Player Voice (Female Child)',
      'Eat Package Default Food',
      'Every Actor Ability',
      'Drug Wears Off Image Space'
    ]).SetRequired
  ]);

  wbRecord(LGTM, 'Lighting Template', [
    wbEDIDReq,
    wbStruct(DATA, 'Lighting', [
      wbByteColors('Ambient Color'),
      wbByteColors('Directional Color'),
      wbByteColors('Fog Color'),
      wbFloat('Fog Near'),
      wbFloat('Fog Far'),
      wbInteger('Directional Rotation XY', itS32),
      wbInteger('Directional Rotation Z', itS32),
      wbFloat('Directional Fade'),
      wbFloat('Fog Clip Dist'),
      wbFloat('Fog Power')
    ]).SetRequired
  ]);

  wbRecord(MUSC, 'Music Type', [
    wbEDIDReq,
    wbString(FNAM, 'FileName')
  ]);

  wbRecord(GRAS, 'Grass', [
    wbEDIDReq,
    wbOBND(True),
    wbGenericModel(True),
    wbStruct(DATA, '', [
      wbInteger('Density', itU8),
      wbInteger('Min Slope', itU8),
      wbInteger('Max Slope', itU8),
      wbUnused(1),
      wbInteger('Unit from water amount', itU16),
      wbUnused(2),
      wbInteger('Unit from water type', itU32, wbEnum([
        'Above - At Least',
        'Above - At Most',
        'Below - At Least',
        'Below - At Most',
        'Either - At Least',
        'Either - At Most',
        'Either - At Most Above',
        'Either - At Most Below'
      ])),
      wbFloat('Position Range'),
      wbFloat('Height Range'),
      wbFloat('Color Range'),
      wbFloat('Wave Period'),
      wbInteger('Flags', itU8, wbFlags([
        'Vertex Lighting',
        'Uniform Scaling',
        'Fit to Slope'
      ])),
      wbUnused(3)
    ]).SetRequired
  ]);

  wbRecord(HAIR, 'Hair', [
    wbEDIDReq,
    wbFULLReq,
    wbGenericModel(True),
    wbString(ICON, 'Texture').SetRequired,
    wbInteger(DATA, 'Flags', itU8, wbFlags([
      'Playable',
      'Not Male',
      'Not Female',
      'Fixed'
    ])).SetRequired
  ]);

  wbRecord(IDLE, 'Idle Animation', [
    wbEDID,
    wbGenericModel(True),
    wbConditions,
    wbArray(ANAM, 'Related Idle Animations', wbFormIDCk('Related Idle Animation', [IDLE, NULL]), ['Parent', 'Previous Sibling']).SetRequired,
    wbStruct(DATA, '', [
      wbInteger('Animation Group Section', itU8, wbIdleAnam),
      wbStruct('Looping', [
        wbInteger('Min', itU8),
        wbInteger('Max', itU8)
      ]),
      wbUnused(1),
      wbInteger('Replay Delay', itS16),
      wbInteger('Flags', itU8, wbFlags([
        'No attacking'
      ])),
      wbUnused(1)
    ], cpNormal, True, nil, 4)
  ]);

  wbRecord(INFO, 'Dialog response',
    wbFlags(wbFlagsList([
      13, 'Unknown 13'
    ])), [
    wbStruct(DATA, '', [
      wbInteger('Type', itU8, wbEnum([
        {0} 'Topic',
        {1} 'Conversation',
        {2} 'Combat',
        {3} 'Persuasion',
        {4} 'Detection',
        {5} 'Service',
        {6} 'Miscellaneous',
        {7} 'Radio'
      ])),
      wbNextSpeaker,
      wbInteger('Flags 1', itU8, wbFlags([
        {0x01} 'Goodbye',
        {0x02} 'Random',
        {0x04} 'Say Once',
        {0x08} 'Run Immediately',
        {0x10} 'Info Refusal',
        {0x20} 'Random End',
        {0x40} 'Run for Rumors',
        {0x80} 'Speech Challenge'
      ])),
      wbInteger('Flags 2', itU8, wbFlags([
        {0x01} 'Say Once a Day',
        {0x02} 'Always Darken'
      ]))
    ], cpNormal, True, nil, 3),
    wbFormIDCkNoReach(QSTI, 'Quest', [QUST]).SetRequired,
    wbFormIDCk(TPIC, 'Topic', [DIAL]),
    wbFormIDCkNoReach(PNAM, 'Previous INFO', [INFO, NULL]),
    wbRArray('Add Topics', wbFormIDCk(NAME, 'Topic', [DIAL])),
    wbRArray('Responses',
      wbRStruct('Response', [
        wbStruct(TRDT, 'Response Data', [
          wbInteger('Emotion Type', itU32, wbEnum([
            {0} 'Neutral',
            {1} 'Anger',
            {2} 'Disgust',
            {3} 'Fear',
            {4} 'Sad',
            {5} 'Happy',
            {6} 'Surprise',
            {7} 'Pained'
          ])),
          wbInteger('Emotion Value', itS32),
          wbUnused(4),
          wbInteger('Response number', itU8),
          wbUnused(3),
          wbFormIDCk('Sound', [SOUN, NULL]),
          wbInteger('Flags', itU8, wbFlags([
            'Use Emotion Animation'
          ])),
          wbUnused(3)
        ], cpNormal, False, nil, 5),
        wbStringKC(NAM1, 'Response Text', 0, cpTranslate).SetRequired,
        wbString(NAM2, 'Script Notes', 0, cpTranslate).SetRequired,
        wbString(NAM3, 'Edits'),
        wbFormIDCk(SNAM, 'Speaker Animation', [IDLE]),
        wbFormIDCk(LNAM, 'Listener Animation', [IDLE])
      ])
    ),
    wbConditions,
    wbRArray('Choices', wbFormIDCk(TCLT, 'Choice', [DIAL])),
    wbRArray('Link From', wbFormIDCk(TCLF, 'Topic', [DIAL])),
    wbRStruct('Script (Begin)', [
      wbEmbeddedScriptReq
    ]).SetRequired,
    wbRStruct('Script (End)', [
      wbEmpty(NEXT, 'Marker').SetRequired,
      wbEmbeddedScriptReq
    ]).SetRequired,
    wbFormIDCk(SNDD, 'Unused', [SOUN]),
    wbStringKC(RNAM, 'Prompt', 0, cpTranslate),
    wbFormIDCk(ANAM, 'Speaker', [CREA, NPC_]),
    wbFormIDCk(KNAM, 'ActorValue/Perk', [AVIF, PERK]),
    wbInteger(DNAM, 'Speech Challenge', itU32, wbEnum([
      '---',
      'Very Easy',
      'Easy',
      'Average',
      'Hard',
      'Very Hard'
    ]))
  ]).SetAddInfo(wbINFOAddInfo)
    .SetAfterLoad(wbINFOAfterLoad);

  wbRecord(INGR, 'Ingredient', [
    wbEDIDReq,
    wbOBND(True),
    wbFULL,
    wbGenericModel,
    wbICON,
    wbSCRI,
    wbETYPReq,
    wbFloat(DATA, 'Weight').SetRequired,
    wbStruct(ENIT, 'Effect Data', [
      wbInteger('Value', itS32),
      wbInteger('Flags', itU8, wbFlags(['No auto-calculation', 'Food item'])),
      wbUnused(3)
    ]).SetRequired,
    wbEffectsReq
  ]);

  wbRecord(KEYM, 'Key',
    wbFlags(wbFlagsList([
      10, 'Quest Item'
    ])), [
    wbEDIDReq,
    wbOBND(True),
    wbFULLReq,
    wbGenericModel,
    wbICONReq,
    wbSCRI,
    wbDEST,
    wbYNAM,
    wbZNAM,
    wbStruct(DATA, '', [
      wbInteger('Value', itS32),
      wbFloat('Weight')
    ]).SetRequired
  ]);

  wbRecord(LAND, 'Landscape',
    wbFlags(wbFlagsList([
      18, 'Compressed'
    ])), [
    wbInteger(DATA, 'Flags', itU32, wbFlags([
      {0x001} 'Has Vertex Normals/Height Map',
      {0x002} 'Has Vertex Colours',
      {0x004} 'Has Layers',
      {0x008} 'Unknown 4',
      {0x010} 'Auto-Calc Normals',
      {0x020} '',
      {0x040} '',
      {0x080} '',
      {0x100} '',
      {0x200} '',
      {0x400} 'Ignored'
    ])),
    wbLandNormals,
    wbLandHeights,
    wbLandColors,
    wbLandLayers
  ]).SetAddInfo(wbLANDAddInfo);

  wbRecord(LIGH, 'Light',
    wbFlags(wbFlagsList([
      10, 'Quest Item',
      16, 'Random Anim Start',
      25, 'Obstacle'
    ])), [
    wbEDIDReq,
    wbOBND(True),
    wbGenericModel,
    wbSCRI,
    wbDEST,
    wbFULL,
    wbICON,
    wbStruct(DATA, '', [
      wbInteger('Time', itS32),
      wbInteger('Radius', itU32),
      wbByteColors('Color'),
      wbInteger('Flags', itU32, wbFlags([
        {0x00000001} 'Dynamic',
        {0x00000002} 'Can Carry',
        {0x00000004} 'Negative',
        {0x00000008} 'Flicker',
        {0x00000010} '',
        {0x00000020} 'Off By Default',
        {0x00000040} 'Flicker Slow',
        {0x00000080} 'Pulse',
        {0x00000100} 'Pulse Slow',
        {0x00000200} 'Spot Light',
        {0x00000400} 'Spot Shadow'
      ])),
      wbFloat('Falloff Exponent').SetDefaultNativeValue(1),
      wbFloat('FOV').SetDefaultNativeValue(90),
      wbInteger('Value', itU32),
      wbFloat('Weight')
    ]).SetRequired,
    wbFloat(FNAM, 'Fade value')
      .SetDefaultNativeValue(1.0)
      .SetRequired,
    wbFormIDCk(SNAM, 'Sound', [SOUN])
  ]);

  wbRecord(LSCR, 'Load Screen',
    wbFlags(wbFlagsList([
      10, 'Displays In Main Menu'
    ])), [
    wbEDIDReq,
    wbICONReq,
    wbDESCReq,
    wbRArrayS('Locations', wbStructSK(LNAM, [0, 1], 'Location', [
      wbFormIDCkNoReach('Cell', [CELL, WRLD]),
      wbUnused(8)
    ]))
  ]);

  wbRecord(LTEX, 'Landscape Texture', [
    wbEDIDReq,
    wbICON,
    wbFormIDCk(TNAM, 'Texture', [TXST]).SetRequired,
    wbStruct(HNAM, 'Havok Data', [
      wbInteger('Material Type', itU8, wbEnum([
        {00} 'STONE',
        {01} 'CLOTH',
        {02} 'DIRT',
        {03} 'GLASS',
        {04} 'GRASS',
        {05} 'METAL',
        {06} 'ORGANIC',
        {07} 'SKIN',
        {08} 'WATER',
        {09} 'WOOD',
        {10} 'HEAVY STONE',
        {11} 'HEAVY METAL',
        {12} 'HEAVY WOOD',
        {13} 'CHAIN',
        {14} 'SNOW',
        {15} 'ELEVATOR',
        {16} 'HOLLOW METAL',
        {17} 'SHEET METAL',
        {18} 'SAND',
        {19} 'BRIKEN CONCRETE',
        {20} 'VEHILCE BODY',
        {21} 'VEHILCE PART SOLID',
        {22} 'VEHILCE PART HOLLOW',
        {23} 'BARREL',
        {24} 'BOTTLE',
        {25} 'SODA CAN',
        {26} 'PISTOL',
        {27} 'RIFLE',
        {28} 'SHOPPING CART',
        {29} 'LUNCHBOX',
        {30} 'BABY RATTLE',
        {31} 'RUBER BALL'
      ])),
      wbInteger('Friction', itU8),
      wbInteger('Restitution', itU8)
    ]).SetRequired,
    wbInteger(SNAM, 'Texture Specular Exponent', itU8).SetRequired,
    wbRArrayS('Grasses', wbFormIDCk(GNAM, 'Grass', [GRAS]))
  ]);

  wbRecord(LVLC, 'Leveled Creature', [
    wbEDIDReq,
    wbOBND(True),
    wbInteger(LVLD, 'Chance none', itU8).SetRequired,
    wbInteger(LVLF, 'Flags', itU8, wbFlags([
      {0x01} 'Calculate from all levels <= player''s level',
      {0x02} 'Calculate for each item in count'
    ])).SetRequired,
    wbRArrayS('Leveled List Entries',
      wbRStructExSK([0], [1], 'Leveled List Entry', [
        wbLeveledListEntry('Creature', [CREA, LVLC]),
        wbCOED
      ]).SetSummaryMemberMaxDepth(0, 1)
        .IncludeFlag(dfCollapsed, wbCollapseLeveledItems)
    ),
    wbGenericModel
  ]);

  wbRecord(LVLN, 'Leveled NPC', [
    wbEDIDReq,
    wbOBND(True),
    wbInteger(LVLD, 'Chance none', itU8).SetRequired,
    wbInteger(LVLF, 'Flags', itU8, wbFlags([
      {0x01} 'Calculate from all levels <= player''s level',
      {0x02} 'Calculate for each item in count'
    ])).SetRequired,
    wbRArrayS('Leveled List Entries',
      wbRStructExSK([0], [1], 'Leveled List Entry', [
        wbLeveledListEntry('NPC', [LVLN, NPC_]),
        wbCOED
      ]).SetSummaryMemberMaxDepth(0, 1)
        .IncludeFlag(dfCollapsed, wbCollapseLeveledItems)
    ),
    wbGenericModel
  ]);

   wbRecord(LVLI, 'Leveled Item', [
    wbEDIDReq,
    wbOBND(True),
    wbInteger(LVLD, 'Chance none', itU8).SetRequired,
    wbInteger(LVLF, 'Flags', itU8, wbFlags([
      {0x01} 'Calculate from all levels <= player''s level',
      {0x02} 'Calculate for each item in count',
      {0x04} 'Use All'
    ])).SetRequired,
    wbFormIDCk(LVLG, 'Global', [GLOB]),
    wbRArrayS('Leveled List Entries',
      wbRStructExSK([0], [1], 'Leveled List Entry', [
        wbLeveledListEntry('Item', [ALCH, AMMO, ARMO, BOOK, KEYM, LVLI, MISC, NOTE, WEAP]),
        wbCOED
      ]).SetSummaryMemberMaxDepth(0, 1)
        .IncludeFlag(dfCollapsed, wbCollapseLeveledItems)
    )
  ]);

  wbRecord(MGEF, 'Base Effect', [
    wbEDIDReq,
    wbFULL,
    wbDESCReq,
    wbICON,
    wbGenericModel,
    wbStruct(DATA, 'Data', [
      wbInteger('Flags', itU32, wbFlags([
        {0x00000001} 'Hostile',
        {0x00000002} 'Recover',
        {0x00000004} 'Detrimental',
        {0x00000008} '',
        {0x00000010} 'Self',
        {0x00000020} 'Touch',
        {0x00000040} 'Target',
        {0x00000080} 'No Duration',
        {0x00000100} 'No Magnitude',
        {0x00000200} 'No Area',
        {0x00000400} 'FX Persist',
        {0x00000800} '',
        {0x00001000} 'Gory Visuals',
        {0x00002000} 'Display Name Only',
        {0x00004000} '',
        {0x00008000} 'Radio Broadcast ??',
        {0x00010000} '',
        {0x00020000} '',
        {0x00040000} '',
        {0x00080000} 'Use skill',
        {0x00100000} 'Use attribute',
        {0x00200000} '',
        {0x00400000} '',
        {0x00800000} '',
        {0x01000000} 'Painless',
        {0x02000000} 'Spray projectile type (or Fog if Bolt is specified as well)',
        {0x04000000} 'Bolt projectile type (or Fog if Spray is specified as well)',
        {0x08000000} 'No Hit Effect',
        {0x10000000} 'No Death Dispel',
        {0x20000000} '????'
      ])),
      {04} wbFloat('Base cost (Unused)'),
      {08} wbUnion('Assoc. Item', wbMGEFFAssocItemDecider, [
             wbFormID('Unused', cpIgnore),
             wbFormID('Assoc. Item'),
             wbFormIDCk('Assoc. Script', [SCPT, NULL]), //Script
             wbFormIDCk('Assoc. Item', [WEAP, ARMO, NULL]), //Bound Item
             wbFormIDCk('Assoc. Creature', [CREA]) //Summon Creature
           ]).SetAfterSet(wbMGEFAssocItemAfterSet),
      {12} wbInteger('Magic School (Unused)', itS32, wbEnum([
      ], [
        -1, 'None'
      ])),
      {16} wbInteger('Resistance Type', itS32, wbActorValueEnum),
      {20} wbInteger('Counter effect count', itU16),
      {22} wbUnused(2),
      {24} wbFormIDCk('Light', [LIGH, NULL]),
      {28} wbFloat('Projectile speed'),
      {32} wbFormIDCk('Effect Shader', [EFSH, NULL]),
      {36} wbFormIDCk('Object Display Shader', [EFSH, NULL]),
      {40} wbFormIDCk('Effect sound', [NULL, SOUN]),
      {44} wbFormIDCk('Bolt sound', [NULL, SOUN]),
      {48} wbFormIDCk('Hit sound', [NULL, SOUN]),
      {52} wbFormIDCk('Area sound', [NULL, SOUN]),
      {56} wbFloat('Constant Effect enchantment factor  (Unused)'),
      {60} wbFloat('Constant Effect barter factor (Unused)'),
      {64} wbInteger('Archtype', itU32, wbArchtypeEnum).SetAfterSet(wbMGEFArchtypeAfterSet),
      {68} wbActorValue
    ]).SetRequired,
    wbRArrayS('Counter Effects',
      wbFormIDCk(ESCE, 'Effect', [MGEF])
    ).SetAfterSet(wbCounterEffectsAfterSet)
  ]).SetAfterLoad(wbMGEFAfterLoad)
    .SetAfterSet(wbMGEFAfterSet);

  wbRecord(MISC, 'Misc. Item',
    wbFlags(wbFlagsList([
      10, 'Quest Item'
    ])), [
    wbEDIDReq,
    wbOBND(True),
    wbFULL,
    wbGenericModel,
    wbICON,
    wbSCRI,
    wbDEST,
    wbYNAM,
    wbZNAM,
    wbStruct(DATA, '', [
      wbInteger('Value', itS32),
      wbFloat('Weight')
    ]).SetRequired
  ]);

  wbRecord(COBJ, 'Constructible Object', [
    wbEDID,
    wbOBND,
    wbFULL,
    wbGenericModel,
    wbICON,
    wbSCRI,
    wbYNAM,
    wbZNAM,
    wbStruct(DATA, '', [
      wbInteger('Value', itS32),
      wbFloat('Weight')
    ]).SetRequired
  ]);

  wbRecord(NPC_, 'Non-Player Character',
    wbFlags(wbFlagsList([
      10, 'Quest Item',
      18, 'Compressed',
      19, 'Unknown 19'
    ])), [
    wbEDIDReq,
    wbOBND(True),
    wbFULL.SetDontShow(wbActorTemplateUseBaseData),
    wbGenericModel(False, wbActorTemplateUseModelAnimation),
    wbStruct(ACBS, 'Configuration', [
      wbInteger('Flags', itU32,
        wbFlags(wbSparseFlags([
          0,  'Female',
          1,  'Essential',
          2,  'Is CharGen Face Preset',
          3,  'Respawn',
          4,  'Auto-calc stats',
          7,  'PC Level Mult',
          8,  'Use Template',
          9,  'No Low Level Processing',
          11, 'No Blood Spray',
          12, 'No Blood Decal',
          20, 'No VATS Melee',
          22, 'Can be all races',
          26, 'No Knockdowns',
          27, 'Not Pushable',
          30, 'No Rotating To Head-track'
        ])).SetFlagHasDontShow(0,  wbActorTemplateUseTraits)
           .SetFlagHasDontShow(1,  wbActorTemplateUseBaseData)
           .SetFlagHasDontShow(3,  wbActorTemplateUseBaseData)
           .SetFlagHasDontShow(4,  wbActorTemplateUseStats)
           .SetFlagHasDontShow(7,  wbActorTemplateUseStats)
           .SetFlagHasDontShow(9,  wbActorTemplateUseBaseData)
           .SetFlagHasDontShow(11, wbActorTemplateUseModelAnimation)
           .SetFlagHasDontShow(12, wbActorTemplateUseModelAnimation)
           .SetFlagHasDontShow(27, wbActorTemplateUseModelAnimation)
           .SetFlagHasDontShow(30, wbActorTemplateUseModelAnimation)
      ).IncludeFlag(dfCollapsed, wbCollapseFlags),
      {04} wbInteger('Fatigue', itU16).SetDontShow(wbActorTemplateUseStats),
      {06} wbInteger('Barter gold', itU16).SetDontShow(wbActorTemplateUseAIData),
      {08} wbUnion('Level', wbCreaLevelDecider, [
             wbInteger('Level', itS16).SetDontShow(wbActorTemplateUseStats),
             wbInteger('Level Mult', itS16, wbDiv(1000)).SetDontShow(wbActorTemplateUseStats)
           ]).SetDontShow(wbActorTemplateUseStats),
      {10} wbInteger('Calc min', itU16).SetDontShow(wbActorTemplateUseStats),
      {12} wbInteger('Calc max', itU16).SetDontShow(wbActorTemplateUseStats),
      {14} wbInteger('Speed Multiplier', itU16).SetDontShow(wbActorTemplateUseStats),
      {16} wbFloat('Karma (Alignment)').SetDontShow(wbActorTemplateUseTraits),
      {20} wbInteger('Disposition Base', itS16).SetDontShow(wbActorTemplateUseTraits),
      {22} wbInteger('Template Flags', itU16, wbTemplateFlags)
    ]).SetRequired,
    wbRArrayS('Factions', wbFaction).SetDontShow(wbActorTemplateUseFactions),
    wbFormIDCk(INAM, 'Death item', [LVLI]).SetDontShow(wbActorTemplateUseTraits),
    wbFormIDCk(VTCK, 'Voice', [VTYP])
      .SetDontShow(wbActorTemplateUseTraits)
      .SetRequired,
    wbFormIDCk(TPLT, 'Template', [LVLN, NPC_]),
    wbFormIDCk(RNAM, 'Race', [RACE])
      .SetDontShow(wbActorTemplateUseTraits)
      .SetRequired,
    wbSPLOs,
    wbFormIDCk(EITM, 'Unarmed Attack Effect', [ENCH, SPEL]).SetDontShow(wbActorTemplateUseActorEffectList),
    wbInteger(EAMT, 'Unarmed Attack Animation', itU16, wbAttackAnimationEnum)
      .SetDontShow(wbActorTemplateUseActorEffectList)
      .SetRequired,
    wbDEST.SetDontShow(wbActorTemplateUseModelAnimation),
    wbSCRI.SetDontShow(wbActorTemplateUseScript),
    wbCNTOs.SetDontShow(wbActorTemplateUseInventory),
    wbAIDT,
    wbRArray('Packages', wbFormIDCk(PKID, 'Package', [PACK])).SetDontShow(wbActorTemplateUseAIPackages),
    wbArrayS(KFFZ, 'Animations', wbStringLC('Animation')).SetDontShow(wbActorTemplateUseModelAnimation),
    wbFormIDCk(CNAM, 'Class', [CLAS])
      .SetDontShow(wbActorTemplateUseTraits)
      .SetRequired,
    wbStruct(DATA, '', [
      {00} wbInteger('Base Health', itS32),
      {04} wbArray('Attributes', wbInteger('Attribute', itU8), [
            'Strength',
            'Perception',
            'Endurance',
            'Charisma',
            'Intelligence',
            'Agility',
            'Luck'
          ]).SetDontShow(wbActorAutoCalcDontShow),
          wbByteArray('Unused'{, 14 - only present in old record versions})
    ]).SetDontShow(wbActorTemplateUseStats)
      .SetRequired,
    wbStruct(DNAM, '', [
      {00} wbArray('Skill Values', wbInteger('Skill', itU8), [
             'Barter',
             'Big Guns',
             'Energy Weapons',
             'Explosives',
             'Lockpick',
             'Medicine',
             'Melee Weapons',
             'Repair',
             'Science',
             'Small Guns',
             'Sneak',
             'Speech',
             'Throwing (unused)',
             'Unarmed'
           ]),
      {14} wbArray('Skill Offsets', wbInteger('Skill', itU8), [
             'Barter',
             'Big Guns',
             'Energy Weapons',
             'Explosives',
             'Lockpick',
             'Medicine',
             'Melee Weapons',
             'Repair',
             'Science',
             'Small Guns',
             'Sneak',
             'Speech',
             'Throwing (unused)',
             'Unarmed'
           ])
    ]).SetDontShow(wbActorTemplateUseStatsAutoCalc),
    wbRArrayS('Head Parts',
      wbFormIDCk(PNAM, 'Head Part', [HDPT])
    ).SetDontShow(wbActorTemplateUseModelAnimation),
    wbFormIDCk(HNAM, 'Hair', [HAIR]).SetDontShow(wbActorTemplateUseModelAnimation),
    wbFloat(LNAM, 'Hair length').SetDontShow(wbActorTemplateUseModelAnimation),
    wbFormIDCk(ENAM, 'Eyes', [EYES]).SetDontShow(wbActorTemplateUseModelAnimation),
    wbByteColors(HCLR, 'Hair color')
      .SetDontShow(wbActorTemplateUseModelAnimation)
      .SetRequired,
    wbFormIDCk(ZNAM, 'Combat Style', [CSTY]).SetDontShow(wbActorTemplateUseTraits),
    wbInteger(NAM4, 'Impact Material Type', itU32, wbActorImpactMaterialEnum).SetDontShow(wbActorTemplateUseModelAnimation).SetRequired,
    wbFaceGen.SetDontShow(wbActorTemplateUseModelAnimation),
    wbInteger(NAM5, 'Unknown', itU16)
      .SetDefaultNativeValue(255)
      .SetRequired,
    wbFloat(NAM6, 'Height')
      .SetDontShow(wbActorTemplateUseTraits)
      .SetRequired,
    wbFloat(NAM7, 'Weight')
      .SetDontShow(wbActorTemplateUseTraits)
      .SetRequired
  ], True).SetAfterLoad(wbNPCAfterLoad);

  wbRecord(PACK, 'Package',
    wbFlags(wbFlagsList([
      27, 'Unknown 27'
    ])), [
    wbEDIDReq,
    wbStruct(PKDT, 'General', [
      wbInteger('General Flags', itU32, wbPackageFlags),
      wbInteger('Type', itU8, wbPackageTypeEnum),
      wbUnused(1),
      wbInteger('Fallout Behavior Flags', itU16, wbFlags([
        {0x00000001}'Hellos To Player',
        {0x00000002}'Random Conversations',
        {0x00000004}'Observe Combat Behavior',
        {0x00000008}'Unknown 4',
        {0x00000010}'Reaction To Player Actions',
        {0x00000020}'Friendly Fire Comments',
        {0x00000040}'Aggro Radius Behavior',
        {0x00000080}'Allow Idle Chatter',
        {0x00000100}'Avoid Radiation'
      ], True)),
      wbUnion('Type Specific Flags', wbPKDTSpecificFlagsDecider, [
        wbEmpty('Type Specific Flags (missing)', cpIgnore, False, nil, True),
        wbInteger('Type Specific Flags - Find', itU16,
          wbFlags(wbSparseFlags([
            8, 'Allow Buying',
            9, 'Allow Killing',
           10, 'Allow Stealing'
        ], False, 11), True)),
        wbInteger('Type Specific Flags - Follow', itU16, wbFlags([], True)),
        wbInteger('Type Specific Flags - Escort', itU16,
          wbFlags(wbSparseFlags([
            8, 'Allow Buying',
            9, 'Allow Killing',
           10, 'Allow Stealing'
        ], False, 11), True)),
        wbInteger('Type Specific Flags - Eat', itU16,
          wbFlags(wbSparseFlags([
            8, 'Allow Buying',
            9, 'Allow Killing',
           10, 'Allow Stealing'
        ], False, 11), True)),
        wbInteger('Type Specific Flags - Sleep', itU16, wbFlags([], True)),
        wbInteger('Type Specific Flags - Wander', itU16,
          wbFlags(wbSparseFlags([
            0, 'No Eating',
            1, 'No Sleeping',
            2, 'No Conversation',
            3, 'No Idle Markers',
            4, 'No Furniture',
            5, 'No Wandering'
        ], False, 6), True)),
        wbInteger('Type Specific Flags - Travel', itU16, wbFlags([], True)),
        wbInteger('Type Specific Flags - Accompany', itU16, wbFlags([], True)),
        wbInteger('Type Specific Flags - Use Item At', itU16,
          wbFlags(wbSparseFlags([
            2, 'Sit Down',
            8, 'Allow Buying',
            9, 'Allow Killing',
           10, 'Allow Stealing'
        ], False, 11), True)),
        wbInteger('Type Specific Flags - Ambush', itU16,
          wbFlags(wbSparseFlags([
            0, 'Hide While Ambushing'
        ], False, 1), True)),
        wbInteger('Type Specific Flags - Flee Not Combat', itU16, wbFlags([], True)),
        wbInteger('Type Specific Flags - Cast Magic', itU16, wbFlags([], True)),
        wbInteger('Type Specific Flags - Sandbox', itU16,
          wbFlags(wbSparseFlags([
            0, 'No Eating',
            1, 'No Sleeping',
            2, 'No Conversation',
            3, 'No Idle Markers',
            4, 'No Furniture',
            5, 'No Wandering'
        ], False, 6), True)),
        wbInteger('Type Specific Flags - Patrol', itU16, wbFlags([], True)),
        wbInteger('Type Specific Flags - Guard', itU16,
          wbFlags(wbSparseFlags([
            3, 'Remain Near Reference to Guard'
        ], False, 3), True)),
        wbInteger('Type Specific Flags - Dialogue', itU16, wbFlags([], True)),
        wbInteger('Type Specific Flags - Use Weapon', itU16, wbFlags([], True))
      ]),
      wbUnused(2)
    ], cpNormal, True, nil, 2),
    wbRStruct('Locations', [
      wbStruct(PLDT, 'Location 1', [
        wbInteger('Type', itS32, wbEnum([     // Byte + filler
          {0} 'Near reference',
          {1} 'In cell',
          {2} 'Near current location',
          {3} 'Near editor location',
          {4} 'Object ID',
          {5} 'Object Type',
          {6} 'Near linked reference',
          {7} 'At package location'
        ])),
        wbUnion('Location', wbPxDTLocationDecider, [
          wbFormIDCkNoReach('Reference', [REFR, PGRE, PMIS, PBEA, ACHR, ACRE, PLYR], True),
          wbFormIDCkNoReach('Cell', [CELL]),
          wbUnused(4),
          wbUnused(4),
          wbFormIDCkNoReach('Object ID', [ACTI, DOOR, STAT, FURN, CREA, SPEL, NPC_, CONT, ARMO, AMMO, MISC, WEAP, BOOK, KEYM, ALCH, LIGH]),
          wbInteger('Object Type', itU32, wbObjectTypeEnum),
          wbUnused(4),
          wbUnused(4)
        ]),
        wbInteger('Radius', itS32)
      ]),
      wbStruct(PLD2, 'Location 2', [
        wbInteger('Type', itS32, wbEnum([
          {0} 'Near reference',
          {1} 'In cell',
          {2} 'Near current location',
          {3} 'Near editor location',
          {4} 'Object ID',
          {5} 'Object Type',
          {6} 'Near linked reference',
          {7} 'At package location'
        ])),
        wbUnion('Location', wbPxDTLocationDecider, [
          wbFormIDCkNoReach('Reference', [REFR, PGRE, PMIS, PBEA, ACHR, ACRE, PLYR], True),
          wbFormIDCkNoReach('Cell', [CELL]),
          wbUnused(4),
          wbUnused(4),
          wbFormIDCkNoReach('Object ID', [ACTI, DOOR, STAT, FURN, CREA, SPEL, NPC_, CONT, ARMO, AMMO, MISC, WEAP, BOOK, KEYM, ALCH, LIGH]),
          wbInteger('Object Type', itU32, wbObjectTypeEnum),
          wbUnused(4),
          wbUnused(4)
        ]),
        wbInteger('Radius', itS32)
      ])
    ], [], cpNormal, False, nil, True),
    wbStruct(PSDT, 'Schedule', [
      wbInteger('Month', itS8),
      wbInteger('Day of week', itS8, wbEnum([
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Weekdays',
        'Weekends',
        'Monday, Wednesday, Friday',
        'Tuesday, Thursday'
      ], [
        -1, 'Any'
      ])),
      wbInteger('Date', itU8),
      wbInteger('Time', itS8),
      wbInteger('Duration', itS32)
    ]).SetRequired,
    wbStruct(PTDT, 'Target 1', [
      wbInteger('Type', itS32, wbEnum([
        {0} 'Specific Reference',
        {1} 'Object ID',
        {2} 'Object Type',
        {3} 'Linked Reference'
      ]), cpNormal, False, nil, nil, 2),
      wbUnion('Target', wbPxDTLocationDecider, [
        wbFormIDCkNoReach('Reference', [ACHR, ACRE, REFR, PGRE, PMIS, PBEA, PLYR], True),
        wbFormIDCkNoReach('Object ID', [ACTI, DOOR, STAT, FURN, CREA, SPEL, NPC_, LVLN, LVLC, CONT, ARMO, AMMO, MISC, WEAP, BOOK, KEYM, ALCH, LIGH, FACT, FLST]),
        wbInteger('Object Type', itU32, wbObjectTypeEnum),
        wbUnused(4)
      ]),
      wbInteger('Count / Distance', itS32),
      wbFloat('Unknown')
    ], cpNormal, False, nil, 3),
    wbConditions,
    wbRStruct('Idle Animations', [
      wbInteger(IDLF, 'Flags', itU8, wbFlags([
        'Run in Sequence',
        '',
        'Do Once'
      ])).SetRequired,
      wbStruct(IDLC, '', [
        wbInteger( 'Animation Count', itU8),
        wbUnused(3)
      ], cpNormal, True, nil, 1),
      wbFloat(IDLT, 'Idle Timer Setting').SetRequired,
      wbArray(IDLA, 'Animations',
        wbFormIDCk('Animation', [IDLE])
      ).SetAfterSet(wbIDLAsAfterSet)
       .SetRequired,
      wbByteArray(IDLB, 'Unused', 4, cpIgnore)
    ]),//.SetAfterSet(wbAnimationsAfterSet),
    wbFormIDCk(CNAM, 'Combat Style', [CSTY]),
    wbEmpty(PKED, 'Eat Marker'),
    wbInteger(PKE2, 'Escort Distance', itU32),
    wbFloat(PKFD, 'Follow - Start Location - Trigger Radius'),
    wbStruct(PKPT, 'Patrol Flags', [
      wbInteger('Repeatable', itU8, wbBoolEnum, cpNormal, False, nil, nil, 1),
      wbUnused(1)
    ], cpNormal, False, nil, 1),
    wbStruct(PKW3, 'Use Weapon Data', [
      wbInteger('Flags', itU32, wbFlags([
        'Always Hit',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        'Do No Damage',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        'Crouch To Reload',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        'Hold Fire When Blocked'
      ])),
      wbInteger('Fire Rate', itU8, wbEnum([
        'Auto Fire',
        'Volley Fire'
      ])),
      wbInteger('Fire Count', itU8, wbEnum([
        'Number of Bursts',
        'Repeat Fire'
      ])),
      wbInteger('Number of Bursts', itU16),
      wbStruct('Shoots Per Volleys', [
        wbInteger('Min', itU16),
        wbInteger('Max', itU16)
      ]),
      wbStruct('Pause Between Volleys', [
        wbFloat('Min'),
        wbFloat('Max')
      ]),
      wbUnused(4)
    ]),
    wbStruct(PTD2, 'Target 2', [
      wbInteger('Type', itS32, wbEnum([
        {0} 'Specific reference',
        {1} 'Object ID',
        {2} 'Object Type',
        {3} 'Linked Reference'
      ])),
      wbUnion('Target', wbPxDTLocationDecider, [
        wbFormIDCkNoReach('Reference', [ACHR, ACRE, REFR, PGRE, PMIS, PBEA, PLYR], True),
        wbFormIDCkNoReach('Object ID', [ACTI, DOOR, STAT, FURN, CREA, SPEL, NPC_, LVLN, LVLC, CONT, ARMO, AMMO, MISC, WEAP, BOOK, KEYM, ALCH, LIGH, FACT, FLST]),
        wbInteger('Object Type', itU32, wbObjectTypeEnum),
        wbUnused(4)
      ]),
      wbInteger('Count / Distance', itS32),
      wbFloat('Unknown')
    ], cpNormal, False, nil, 3),
    wbEmpty(PUID, 'Use Item Marker'),
    wbEmpty(PKAM, 'Ambush Marker'),
    wbStruct(PKDD, 'Dialogue Data', [
      wbFloat('FOV'),
      wbFormIDCk('Topic', [DIAL, NULL]),
      wbInteger('Flags', itU32, wbFlags([
        'No Headtracking',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        'Don''t Control Target Movement'
      ])),
      wbUnused(4),
      wbInteger('Dialogue Type', itU32, wbEnum([
        'Conversation',
        'Say To'
      ])),
      wbByteArray('Unknown', 4)
    ], cpNormal, False, nil, 3),
    wbStruct(PLD2, 'Location 2 (again??)', [
      wbInteger('Type', itS32, wbEnum([
        {0} 'Near reference',
        {1} 'In cell',
        {2} 'Near current location',
        {3} 'Near editor location',
        {4} 'Object ID',
        {5} 'Object Type',
        {6} 'Near linked reference',
        {7} 'At package location'
      ])),
      wbUnion('Location', wbPxDTLocationDecider, [
        wbFormIDCkNoReach('Reference', [REFR, PGRE, PMIS, PBEA, ACHR, ACRE, PLYR], True),
        wbFormIDCkNoReach('Cell', [CELL]),
        wbUnused(4),
        wbUnused(4),
        wbFormIDCkNoReach('Object ID', [ACTI, DOOR, STAT, FURN, CREA, SPEL, NPC_, CONT, ARMO, AMMO, MISC, WEAP, BOOK, KEYM, ALCH, LIGH]),
        wbInteger('Object Type', itU32, wbObjectTypeEnum),
        wbUnused(4),
        wbUnused(4)
      ]),
      wbInteger('Radius', itS32)
    ]),
    wbRStruct('OnBegin', [
      wbEmpty(POBA, 'OnBegin Marker').SetRequired,
      wbFormIDCk(INAM, 'Idle', [IDLE, NULL]).SetRequired,
      wbEmbeddedScriptReq,
      wbFormIDCk(TNAM, 'Topic', [DIAL, NULL]).SetRequired
    ]).SetRequired,
    wbRStruct('OnEnd', [
      wbEmpty(POEA, 'OnEnd Marker').SetRequired,
      wbFormIDCk(INAM, 'Idle', [IDLE, NULL]).SetRequired,
      wbEmbeddedScriptReq,
      wbFormIDCk(TNAM, 'Topic', [DIAL, NULL]).SetRequired
    ]).SetRequired,
    wbRStruct('OnChange', [
      wbEmpty(POCA, 'OnChange Marker').SetRequired,
      wbFormIDCk(INAM, 'Idle', [IDLE, NULL]).SetRequired,
      wbEmbeddedScriptReq,
      wbFormIDCk(TNAM, 'Topic', [DIAL, NULL]).SetRequired
    ]).SetRequired
  ]).SetAfterLoad(wbPACKAfterLoad);

  wbRecord(QUST, 'Quest', [
    wbEDIDReq,
    wbSCRI,
    wbFULL,
    wbICON,
    wbStruct(DATA, 'General', [
      wbInteger('Flags', itU8, wbFlags([
        {0x01} 'Start game enabled',
        {0x02} '',
        {0x04} 'Allow repeated conversation topics',
        {0x08} 'Allow repeated stages',
        {0x10} 'Default Script Processing Delay'
      ])),
      wbInteger('Priority', itU8),
      wbUnused(2),
      wbFloat('Quest Delay')
    ], cpNormal, True, nil, 3),
    wbConditions,
    wbRArrayS('Stages', wbRStructSK([0], 'Stage', [
      wbInteger(INDX, 'Stage Index', itS16),
      wbRArray('Log Entries', wbRStruct('Log Entry', [
        wbInteger(QSDT, 'Stage Flags', itU8, wbFlags([
          {0x01} 'Complete Quest',
          {0x02} 'Fail Quest'
        ])),
        wbConditions,
        wbStringKC(CNAM, 'Log Entry', 0, cpTranslate),
        wbEmbeddedScriptReq,
        wbFormIDCk(NAM0, 'Next Quest', [QUST])
      ]))
    ])),
    wbRArray('Objectives', wbRStruct('Objective', [
      wbInteger(QOBJ, 'Objective Index', itS32),
      wbStringKC(NNAM, 'Description').SetRequired,
      wbRArray('Targets', wbRStruct('Target', [
        wbStruct(QSTA, 'Target', [
          wbFormIDCkNoReach('Target', [REFR, PGRE, PMIS, PBEA, ACRE, ACHR], True),
          wbInteger('Flags', itU8, wbFlags([
            {0x01} 'Compass Marker Ignores Locks'
          ])),
          wbUnused(3)
        ]),
        wbConditions
      ]))
    ]))
  ]);

  wbRecord(RACE, 'Race', [
    wbEDIDReq,
    wbFULLReq,
    wbDESCReq,
    wbFactionRelations,
    wbStruct(DATA, '', [
      wbArrayS('Skill Boosts', wbStructSK([0], 'Skill Boost', [
        wbInteger('Skill', itS8, wbActorValueEnum),
        wbInteger('Boost', itS8)
      ]).SetSummaryKey([1, 0])
        .SetSummaryMemberPrefixSuffix(1, '+', '')
        .SetSummaryMemberPrefixSuffix(0, '', '')
        .SetSummaryDelimiter(' ')
        .IncludeFlag(dfSummaryNoSortKey)
        .IncludeFlag(dfSummaryMembersNoName).IncludeFlag(dfCollapsed), 7),
      wbUnused(2),
      wbFloat('Male Height'),
      wbFloat('Female Height'),
      wbFloat('Male Weight'),
      wbFloat('Female Weight'),
      wbInteger('Flags', itU32, wbFlags([
        'Playable',
        '',
        'Child'
      ]))
    ]).SetRequired,
    wbFormIDCk(ONAM, 'Older', [RACE]),
    wbFormIDCk(YNAM, 'Younger', [RACE]),
    wbEmpty(NAM2, 'Unknown Marker').SetRequired,
    wbArray(VTCK, 'Voices', wbFormIDCk('Voice', [VTYP]), ['Male', 'Female']).SetRequired,
    wbArray(DNAM, 'Default Hair Styles', wbFormIDCk('Default Hair Style', [HAIR, NULL]), ['Male', 'Female']).SetRequired,
    wbArray(CNAM, 'Default Hair Colors', wbInteger('Default Hair Color', itU8, wbEnum([
      'Bleached',
      'Brown',
      'Chocolate',
      'Platinum',
      'Cornsilk',
      'Suede',
      'Pecan',
      'Auburn',
      'Ginger',
      'Honey',
      'Gold',
      'Rosewood',
      'Black',
      'Chestnut',
      'Steel',
      'Champagne'
    ])), ['Male', 'Female']).SetRequired,
    wbFloat(PNAM, 'FaceGen - Main clamp').SetRequired,
    wbFloat(UNAM, 'FaceGen - Face clamp').SetRequired,
    wbByteArray(ATTR, 'Unused').SetRequired,
    wbRStruct('Head Data', [
      wbEmpty(NAM0, 'Head Data Marker').SetRequired,
      wbRStruct('Male Head Data', [
        wbEmpty(MNAM, 'Male Data Marker').SetRequired,
        wbHeadParts
      ]).SetRequired,
      wbRStruct('Female Head Data', [
        wbEmpty(FNAM, 'Female Data Marker').SetRequired,
        wbHeadParts
      ]).SetRequired
    ]).SetRequired,
    wbRStruct('Body Data', [
      wbEmpty(NAM1, 'Body Data Marker').SetRequired,
      wbRStruct('Male Body Data', [
        wbEmpty(MNAM, 'Male Data Marker'),
        wbBodyParts
      ]).SetRequired,
      wbRStruct('Female Body Data', [
        wbEmpty(FNAM, 'Female Data Marker').SetRequired,
        wbBodyParts
      ]).SetRequired
    ]).SetRequired,
    wbArrayS(HNAM, 'Hairs', wbFormIDCk('Hair', [HAIR])).SetRequired,
    wbArrayS(ENAM, 'Eyes', wbFormIDCk('Eye', [EYES])).SetRequired,
    wbRStruct('FaceGen Data', [
      wbRStruct('Male FaceGen Data', [
        wbEmpty(MNAM, 'Male Data Marker').SetRequired,
        wbFaceGen,
        wbUnknown(SNAM).SetRequired
      ]).SetRequired,
      wbRStruct('Female FaceGen Data', [
        wbEmpty(FNAM, 'Female Data Marker').SetRequired,
        wbFaceGen,
        wbUnknown(SNAM).SetRequired
      ]).SetRequired
    ]).SetRequired
  ]);

  wbRefRecord(REFR, 'Placed Object',
    wbFlags(wbFlagsList([
       6, 'Hidden From Local Map',
       7, 'Turn Off Fire',  //Only MSTT placing FXSmokeMed01 [00071FED]?
       8, 'Inaccessible',
       9, 'Casts Shadows/Motion Blur',
      10, 'Persistent',
      11, 'Initially Disabled',
      15, 'Visible When Distant',
      16, 'High Priority LOD',  //Requires Visible When Distant
      25, 'No AI Acquire',
      26, 'Navmesh - Filter',
      27, 'Navmesh - Bounding Box',
      28, 'Reflected By Auto Water', //Only REFRs placed in Exterior?
      29, 'Refracted by Auto Water', //Only REFRs placed in Exterior?
      30, 'Navmesh - Ground',
      31, 'Multibound'
    ])).SetFlagHasDontShow(26, wbFlagNavmeshFilterDontShow)
       .SetFlagHasDontShow(27, wbFlagNavmeshBoundingBoxDontShow)
       .SetFlagHasDontShow(30, wbFlagNavmeshGroundDontShow), [
    wbEDID,
    {
    wbStruct(RCLR, 'Linked Reference Color (Old Format?)', [
      wbStruct('Link Start Color', [
        wbInteger('Red', itU8),
        wbInteger('Green', itU8),
        wbInteger('Blue', itU8),
        wbUnused(1)
      ]),
      wbStruct('Link End Color', [
        wbInteger('Red', itU8),
        wbInteger('Green', itU8),
        wbInteger('Blue', itU8),
        wbUnused(1)
      ])
    ], cpIgnore),}
    wbByteArray(RCLR, 'Unused', 0, cpIgnore),
    wbFormIDCk(NAME, 'Base', [TREE, SOUN, ACTI, DOOR, STAT, FURN, CONT, ARMO, AMMO, LVLN, LVLC,
                              MISC, WEAP, BOOK, KEYM, ALCH, LIGH, GRAS, ASPC, IDLM, ARMA,
                              MSTT, NOTE, PWAT, SCOL, TACT, TERM, TXST, ADDN]).SetRequired,
    wbFormIDCk(XEZN, 'Encounter Zone', [ECZN]),

    {--- ?? ---}
    wbRagdoll,

    {--- Primitive ---}
    wbStruct(XPRM, 'Primitive', [
      wbStruct('Bounds', [
        wbFloat('X', cpNormal, True, 2, 4),
        wbFloat('Y', cpNormal, True, 2, 4),
        wbFloat('Z', cpNormal, True, 2, 4)
      ]).SetToStr(wbVec3ToStr).IncludeFlag(dfCollapsed, wbCollapseVec3),
      wbFloatColors('Color'),
      wbUnknown(4),
      wbInteger('Type', itU32, wbEnum([
        'None',
        'Box',
        'Sphere',
        'Portal Box'
      ]))
    ]),
    wbInteger(XTRI, 'Collision Layer', itU32, wbEnum([
      'Unidentified',
      'Static',
      'AnimStatic',
      'Transparent',
      'Clutter',
      'Weapon',
      'Projectile',
      'Spell',
      'Biped',
      'Trees',
      'Props',
      'Water',
      'Trigger',
      'Terrain',
      'Trap',
      'Non Collidable',
      'Cloud Trap',
      'Ground',
      'Portal',
      'Debris Small',
      'Debris Large',
      'Acoustic Space',
      'Actor Zone',
      'Projectile Zone',
      'Gas Trap',
      'Shell Casing',
      'Transparent Small',
      'Invisible Wall',
      'Transparent Small Anim',
      'Dead Bip',
      'Char Controller',
      'Avoid Box',
      'Collision Box',
      'Camera Sphere',
      'Door Detection',
      'Camera Pick',
      'Item Pick',
      'Line Of Sight',
      'Path Pick',
      'Custom Pick 1',
      'Custom Pick 2',
      'Spell Explosion',
      'Dropping Pick'
    ])),
    wbEmpty(XMBP, 'MultiBound Primitive Marker'),

    {--- Bound Contents ---}

    {--- Bound Data ---}
    wbVec3(XMBO, 'Bound Half Extents'),

    {--- Teleport ---}
    wbStruct(XTEL, 'Teleport Destination', [
      wbFormIDCk('Door', [REFR], True),
      wbPosRot,
      wbInteger('Flags', itU32, wbFlags([
        'No Alarm'
      ]))
    ]),

    {--- Map Data ---}
    wbRStruct('Map Marker', [
      wbEmpty(XMRK, 'Map Marker Data'),
      wbInteger(FNAM, 'Flags', itU8, wbFlags([
        {0x01} 'Visible',
        {0x02} 'Can Travel To',
        {0x04} '"Show All" Hidden'
      ])).SetRequired,
      wbFULLReq,
      wbStruct(TNAM, '', [
        wbInteger('Type', itU8, wbEnum([
          'None',
          'City',
          'Settlement',
          'Encampment',
          'Natural Landmark',
          'Cave',
          'Factory',
          'Monument',
          'Military',
          'Office',
          'Town Ruins',
          'Urban Ruins',
          'Sewer Ruins',
          'Metro',
          'Vault'
        ])),
        wbUnused(1)
      ]).SetRequired
    ]),

    wbInteger(XSRF, 'Special Rendering Flags', itU32, wbFlags([
      'Unknown 0',
      'Imposter',
      'Use Full Shader in LOD'
    ])),
    wbByteArray(XSRD, 'Special Rendering Data', 4),

    {--- X Target Data ---}
    wbFormIDCk(XTRG, 'Target', [REFR, ACRE, ACHR, PGRE, PMIS, PBEA], True),

    {--- Leveled Actor ----}
    wbXLCM,

    {--- Patrol Data ---}
    wbRStruct('Patrol Data', [
      wbFloat(XPRD, 'Idle Time').SetRequired,
      wbEmpty(XPPA, 'Patrol Script Marker').SetRequired,
      wbFormIDCk(INAM, 'Idle', [IDLE, NULL]).SetRequired,
      wbEmbeddedScriptReq,
      wbFormIDCk(TNAM, 'Topic', [DIAL, NULL]).SetRequired
    ]),

    {--- Radio ---}
    wbStruct(XRDO, 'Radio Data', [
      wbFloat('Range Radius'),
      wbInteger('Broadcast Range Type', itU32, wbEnum([
        'Radius',
        'Everywhere',
        'Worldspace and Linked Interiors',
        'Linked Interiors',
        'Current Cell Only'
      ])),
      wbFloat('Static Percentage'),
      wbFormIDCkNoReach('Position Reference', [REFR, ACRE, ACHR, PGRE, PMIS, PBEA, NULL])
    ]),

    {--- Ownership ---}
    wbOwnership([XCMT, XCMO]),

    {--- Lock ---}
    wbStruct(XLOC, 'Lock Data', [
      wbInteger('Level', itU8),
      wbUnused(3),
      wbFormIDCkNoReach('Key', [KEYM, NULL]),
      wbInteger('Flags', itU8, wbFlags(['', '', 'Leveled Lock'])),
      wbUnused(3),
      wbByteArray('Unknown', 8)
    ], cpNormal, False, nil, 5),

    {--- Extra ---}
    wbInteger(XCNT, 'Count', itS32),
    wbFloat(XRDS, 'Radius'),
    wbFloat(XHLP, 'Health'),
    wbFloat(XRAD, 'Radiation'),
    wbFloat(XCHG, 'Charge'),
    wbRStruct('Ammo', [
      wbFormIDCk(XAMT, 'Type', [AMMO]).SetRequired,
      wbInteger(XAMC, 'Count', itS32).SetRequired
    ]),

    {--- Reflected By / Refracted By ---}
    wbRArrayS('Reflected/Refracted By',
      wbStructSK(XPWR, [0], 'Water', [
        wbFormIDCk('Reference', [REFR]),
        wbInteger('Type', itU32, wbFlags([
          'Reflection',
          'Refraction'
        ]))
      ])
    ),

    {--- Lit Water ---}
    wbRArrayS('Lit Water',
      wbFormIDCk(XLTW, 'Water', [REFR])
    ),

    {--- Decals ---}
    wbRArrayS('Linked Decals',
      wbStructSK(XDCR, [0], 'Decal', [
        wbFormIDCk('Reference', [REFR]),
        wbUnknown
      ])
    ),

    {--- Linked Ref ---}
    wbFormIDCk(XLKR, 'Linked Reference', [REFR, ACRE, ACHR, PGRE, PMIS, PBEA, PLYR]),
    wbStruct(XCLP, 'Linked Reference Color', [
      wbByteColors('Link Start Color'),
      wbByteColors('Link End Color')
    ]),

    {--- Activate Parents ---}
    wbRStruct('Activate Parents', [
      wbInteger(XAPD, 'Flags', itU8, wbFlags([
        'Parent Activate Only'
      ], True)),
      wbRArrayS('Activate Parent Refs',
        wbStructSK(XAPR, [0], 'Activate Parent Ref', [
          wbFormIDCk('Reference', [REFR, ACRE, ACHR, PGRE, PMIS, PBEA, PLYR]),
          wbFloat('Delay')
        ])
      )
    ]),

    {--- Enable Parent ---}
    wbXESP,

    {--- Emittance ---}
    wbFormIDCk(XEMI, 'Emittance', [LIGH, REGN]),

    {--- MultiBound ---}
    wbFormIDCk(XMBR, 'MultiBound Reference', [REFR]),

    {--- Flags ---}
    wbActionFlag,
    wbEmpty(ONAM, 'Open by Default'),
    wbEmpty(XIBS, 'Ignored By Sandbox'),

    {--- Generated Data ---}
    wbStruct(XNDP, 'Navmesh Door Link', [
      wbFormIDCk('Navmesh', [NAVM]),
      wbInteger('Triangle', itS16, wbREFRNavmeshTriangleToStr, wbStringToInt),
      wbUnused(2)
    ]),

    wbArray(XPOD, 'Portal Data', wbFormIDCk('Room', [REFR, NULL]), 2),
    wbSizePosRot(XPTL, 'Portal Data'),

    wbInteger(XSED, 'SpeedTree Seed', itU8),

    wbRStruct('Room Data', [
      wbStruct(XRMR, 'Header', [
        wbInteger('Linked Rooms Count', itU16),
        wbByteArray('Unknown', 2)
      ]),
      wbRArrayS('Linked Rooms',
        wbFormIDCk(XLRM, 'Linked Room', [REFR])
      ).SetCountPath('XRMR\Linked Rooms Count')
    ]),

    wbSizePosRot(XOCP, 'Occlusion Plane Data'),
    wbArray(XORD, 'Linked Occlusion Planes', wbFormIDCk('Plane', [REFR, NULL]), [
      'Right',
      'Left',
      'Bottom',
      'Top'
    ]),

    wbXLOD,

    {--- 3D Data ---}
    wbXSCL,
    wbDATAPosRot
  ], True)
    .SetAddInfo(wbPlacedAddInfo)
    .SetAfterLoad(wbREFRAfterLoad);


  wbRecord(REGN, 'Region',
    wbFlags(wbFlagsList([
      6, 'Border Region'
    ])), [
    wbEDID,
    wbICON,
    wbByteColors(RCLR, 'Map Color').SetRequired,
    wbFormIDCkNoReach(WNAM, 'Worldspace', [WRLD]),
    wbRegionAreas,

    wbRArrayS('Region Data Entries', wbRStructSK([0], 'Region Data Entry', [
      {always starts with an RDAT}
      wbStructSK(RDAT, [0], 'Data Header', [
        wbInteger('Type', itU32,
          wbEnum([], [
            2, 'Objects',
            3, 'Weather',
            4, 'Map',
            5, 'Land',
            6, 'Grass',
            7, 'Sound'
          ])
        ),
        wbInteger('Override', itU8, wbBoolEnum),
        wbInteger('Priority', itU8),
        wbByteArray('Unused')
      ]).SetRequired,

      {followed by one of these: }

      {--- Objects ---}
      wbArray(RDOT, 'Objects',
      wbStruct('Object', [
        wbFormIDCk('Object', [TREE, STAT, LTEX]),
        wbInteger('Parent Index', itU16, wbHideFFFF),
        wbUnused(2),
        wbFloat('Density'),
        wbInteger('Clustering', itU8),
        wbInteger('Min Slope', itU8),
        wbInteger('Max Slope', itU8),
        wbInteger('Flags', itU8,
        wbFlags([
          {0}'Conform to slope',
          {1}'Paint Vertices',
          {2}'Size Variance +/-',
          {3}'X +/-',
          {4}'Y +/-',
          {5}'Z +/-',
          {6}'Tree',
          {7}'Huge Rock'
        ])
        ),
        wbInteger('Radius wrt Parent', itU16),
        wbInteger('Radius', itU16),
        wbFloat('Min Height'),
        wbFloat('Max Height'),
        wbFloat('Sink'),
        wbFloat('Sink Variance'),
        wbFloat('Size Variance'),
        wbStruct('Angle Variance', [
          wbInteger('X', itU16),
          wbInteger('Y', itU16),
          wbInteger('Z', itU16)
        ]).SetToStr(wbVec3ToStr)
          .IncludeFlag(dfCollapsed, wbCollapseVec3),
        wbUnused(2),
        wbByteArray('Unknown', 4)
      ])).SetDontShow(wbREGNObjectsDontShow),

      {--- Map ---}
      wbString(RDMP, 'Map Name', 0, cpTranslate).SetDontShow(wbREGNMapDontShow),

      {--- Grass ---}
      wbArrayS(RDGS, 'Grasses', wbStructSK([0], 'Grass', [
        wbFormIDCk('Grass', [GRAS]),
        wbByteArray('Unknown',4)
      ])).SetDontShow(wbREGNGrassDontShow),

      {--- Sound ---}
      wbInteger(RDMD, 'Music Type', itU32, wbMusicEnum, cpIgnore).SetDontShow(wbNeverShow),
      wbFormIDCk(RDMO, 'Music', [MUSC]).SetDontShow(wbREGNSoundDontShow),
      wbRegionSounds,

      {--- Weather ---}
      wbArrayS(RDWT, 'Weather Types', wbStructSK([0], 'Weather Type', [
        wbFormIDCk('Weather', [WTHR]),
        wbInteger('Chance', itU32),
        wbFormIDCk('Global', [GLOB, NULL])
      ])).SetDontShow(wbREGNWeatherDontShow)
    ]))
  ], True);

  wbRecord(SOUN, 'Sound', [
    wbEDIDReq,
    wbOBND(True),
    wbString(FNAM, 'Sound FileName'),
    wbRUnion('Sound Data', [
      wbStruct(SNDD, 'Sound Data', [
        wbInteger('Minimum Attenuation Distance', itU8, wbMul(5)),
        wbInteger('Maximum Attenuation Distance', itU8, wbMul(100)),
        wbInteger('Frequency Adjustment %', itS8),
        wbUnused(1),
        wbInteger('Flags', itU32, wbFlags([
          {0x0001} 'Random Frequency Shift',
          {0x0002} 'Play At Random',
          {0x0004} 'Environment Ignored',
          {0x0008} 'Random Location',
          {0x0010} 'Loop',
          {0x0020} 'Menu Sound',
          {0x0040} '2D',
          {0x0080} '360 LFE',
          {0x0100} 'Dialogue Sound',
          {0x0200} 'Envelope Fast',
          {0x0400} 'Envelope Slow',
          {0x0800} '2D Radius',
          {0x1000} 'Mute When Submerged'
        ])),
        wbInteger('Static attenuation cdB', itS16),
        wbInteger('Stop time ', itU8),
        wbInteger('Start time ', itU8),
        wbArray('Attenuation Curve', wbInteger('Point', itS16), 5),
        wbInteger('Reverb Attenuation Control', itS16),
        wbInteger('Priority', itS32),
        wbByteArray('Unknown', 8)
      ]).SetRequired,
      wbStruct(SNDX, 'Sound Data', [
        wbInteger('Minimum attenuation distance', itU8, wbMul(5)),
        wbInteger('Maximum attenuation distance', itU8, wbMul(100)),
        wbInteger('Frequency adjustment %', itS8),
        wbUnused(1),
        wbInteger('Flags', itU32, wbFlags([
          {0x0001} 'Random Frequency Shift',
          {0x0002} 'Play At Random',
          {0x0004} 'Environment Ignored',
          {0x0008} 'Random Location',
          {0x0010} 'Loop',
          {0x0020} 'Menu Sound',
          {0x0040} '2D',
          {0x0080} '360 LFE',
          {0x0100} 'Dialogue Sound',
          {0x0200} 'Envelope Fast',
          {0x0400} 'Envelope Slow',
          {0x0800} '2D Radius',
          {0x1000} 'Mute When Submerged'
        ])),
        wbInteger('Static attenuation cdB', itS16),
        wbInteger('Stop time ', itU8),
        wbInteger('Start time ', itU8)
      ]).SetRequired
    ]).SetRequired,
    wbArray(ANAM, 'Attenuation Curve', wbInteger('Point', itS16), 5).SetDontShow(wbNeverShow),
    wbInteger(GNAM, 'Reverb Attenuation Control', itS16).SetDontShow(wbNeverShow),
    wbInteger(HNAM, 'Priority', itS32).SetDontShow(wbNeverShow)
  ]).SetAfterLoad(wbSOUNAfterLoad);

  wbRecord(SPEL, 'Actor Effect', [
    wbEDIDReq,
    wbFULL,
    wbStruct(SPIT, '', [
      wbInteger('Type', itU32, wbEnum([
        {0} 'Actor Effect',
        {1} 'Disease',
        {2} 'Power',
        {3} 'Lesser Power',
        {4} 'Ability',
        {5} 'Poison',
        {6} '',
        {7} '',
        {8} '',
        {9} '',
       {10} 'Addiction'
      ])),
      wbInteger('Cost (Unused)', itU32),
      wbInteger('Level (Unused)', itU32, wbEnum([
        {0} 'Unused'
      ])),
      wbInteger('Flags', itU8, wbFlags([
        {0x00000001} 'No Auto-Calc',
        {0x00000002} 'Immune to Silence 1?',
        {0x00000004} 'PC Start Effect',
        {0x00000008} 'Immune to Silence 2?',
        {0x00000010} 'Area Effect Ignores LOS',
        {0x00000020} 'Script Effect Always Applies',
        {0x00000040} 'Disable Absorb/Reflect',
        {0x00000080} 'Force Touch Explode'
      ])),
      wbUnused(3)
    ]).SetRequired,
    wbEffectsReq
  ]);

  wbRecord(STAT, 'Static',
    wbFlags(wbFlagsList([
      6, 'Has Tree LOD',
      9, 'On Local Map',
      10, 'Quest Item',
      15, 'Visible When Distant',
      25, 'Obstacle',
      26, 'Navmesh - Filter',
      27, 'Navmesh - Bounding Box',
      30, 'Navmesh - Ground'
    ])).SetFlagHasDontShow(26, wbFlagNavmeshFilterDontShow)
       .SetFlagHasDontShow(27, wbFlagNavmeshBoundingBoxDontShow)
       .SetFlagHasDontShow(30, wbFlagNavmeshGroundDontShow), [
    wbEDIDReq,
    wbOBND(True),
    wbGenericModel
  ]);

  wbRecord(TES4, 'Main File Header',
    wbFlags(wbFlagsList([
      0, 'ESM',
      4, 'Optimized'
    ])), [
    wbHEDR,
    wbByteArray(OFST, 'Unknown', 0, cpIgnore),
    wbByteArray(DELE, 'Unknown', 0, cpIgnore),
    wbString(CNAM, 'Author', 0, cpTranslate).SetRequired,
    wbString(SNAM, 'Description', 0, cpTranslate),
    wbRArray('Master Files', wbRStruct('Master File', [
      wbStringForward(MAST, 'FileName').SetRequired,
      wbByteArray(DATA, 'Unused', 8, cpIgnore).SetRequired
    ], [ONAM])).IncludeFlag(dfInternalEditOnly, not wbAllowMasterFilesEdit),
    wbArray(ONAM, 'Overridden Forms',
      wbFormIDCk('Form', [REFR, ACHR, ACRE, PMIS, PBEA, PGRE, LAND, NAVM])
    ).SetDontShow(wbTES4ONAMDontShow),
    wbByteArray(SCRN, 'Screenshot')
  ], True, nil, cpNormal, True);

  wbRecord(PLYR, 'Player Reference', [
    wbEDID,
    wbFormID(PLYR, 'Player')
      .SetDefaultNativeValue($7)
      .SetRequired
  ]).IncludeFlag(dfInternalEditOnly);

  wbRecord(TREE, 'Tree', [
    wbEDIDReq,
    wbOBND(True),
    wbGenericModel(True),
    wbICONReq,
    wbArrayS(SNAM, 'SpeedTree Seeds', wbInteger('SpeedTree Seed', itU32)).SetRequired,
    wbStruct(CNAM, 'Tree Data', [
      wbFloat('Leaf Curvature'),
      wbFloat('Minimum Leaf Angle'),
      wbFloat('Maximum Leaf Angle'),
      wbFloat('Branch Dimming Value'),
      wbFloat('Leaf Dimming Value'),
      wbInteger('Shadow Radius', itS32),
      wbFloat('Rock Speed'),
      wbFloat('Rustle Speed')
    ]).SetRequired,
    wbStruct(BNAM, 'Billboard Dimensions', [
      wbFloat('Width'),
      wbFloat('Height')
    ]).SetRequired
  ]);

  wbRecord(WATR, 'Water', [
    wbEDIDReq,
    wbFULL,
    wbString(NNAM, 'Noise Map').SetRequired,
    wbInteger(ANAM, 'Opacity', itU8).SetRequired,
    wbInteger(FNAM, 'Flags', itU8, wbFlags([
      {0}'Causes Damage',
      {1}'Reflective'
    ])).SetRequired,
    wbString(MNAM, 'Material ID').SetRequired,
    wbFormIDCk(SNAM, 'Sound', [SOUN]),
    wbFormIDCk(XNAM, 'Actor Effect', [SPEL]),
    wbInteger(DATA, 'Damage', itU16, nil, cpNormal, True, True),
    wbRUnion('Visual Data', [
      wbStruct(DNAM, 'Visual Data', [
        wbFloat('Unknown'),
        wbFloat('Unknown'),
        wbFloat('Unknown'),
        wbFloat('Unknown'),
        wbFloat('Water Properties - Sun Power'),
        wbFloat('Water Properties - Reflectivity Amount'),
        wbFloat('Water Properties - Fresnel Amount'),
        wbUnused(4),
        wbFloat('Fog Properties - Above Water - Fog Distance - Near Plane'),
        wbFloat('Fog Properties - Above Water - Fog Distance - Far Plane'),
        wbByteColors('Shallow Color'),
        wbByteColors('Deep Color'),
        wbByteColors('Reflection Color'),
        wbUnused(4),
        wbFloat('Rain Simulator - Force'),
        wbFloat('Rain Simulator - Velocity'),
        wbFloat('Rain Simulator - Falloff'),
        wbFloat('Rain Simulator - Dampner'),
        wbFloat('Displacement Simulator - Starting Size'),
        wbFloat('Displacement Simulator - Force'),
        wbFloat('Displacement Simulator - Velocity'),
        wbFloat('Displacement Simulator - Falloff'),
        wbFloat('Displacement Simulator - Dampner'),
        wbFloat('Rain Simulator - Starting Size'),
        wbFloat('Noise Properties - Normals - Noise Scale'),
        wbFloat('Noise Properties - Noise Layer One - Wind Direction'),
        wbFloat('Noise Properties - Noise Layer Two - Wind Direction'),
        wbFloat('Noise Properties - Noise Layer Three - Wind Direction'),
        wbFloat('Noise Properties - Noise Layer One - Wind Speed'),
        wbFloat('Noise Properties - Noise Layer Two - Wind Speed'),
        wbFloat('Noise Properties - Noise Layer Three - Wind Speed'),
        wbFloat('Noise Properties - Normals - Depth Falloff Start'),
        wbFloat('Noise Properties - Normals - Depth Falloff End'),
        wbFloat('Fog Properties - Above Water - Fog Amount'),
        wbFloat('Noise Properties - Normals - UV Scale'),
        wbFloat('Fog Properties - Under Water - Fog Amount'),
        wbFloat('Fog Properties - Under Water - Fog Distance - Near Plane'),
        wbFloat('Fog Properties - Under Water - Fog Distance - Far Plane'),
        wbFloat('Water Properties - Distortion Amount'),
        wbFloat('Water Properties - Shininess'),
        wbFloat('Water Properties - Reflection HDR Multiplier'),
        wbFloat('Water Properties - Light Radius'),
        wbFloat('Water Properties - Light Brightness'),
        wbFloat('Noise Properties - Noise Layer One - UV Scale'),
        wbFloat('Noise Properties - Noise Layer Two - UV Scale'),
        wbFloat('Noise Properties - Noise Layer Three - UV Scale'),
        wbFloat('Noise Properties - Noise Layer One - Amplitude Scale'),
        wbFloat('Noise Properties - Noise Layer Two - Amplitude Scale'),
        wbFloat('Noise Properties - Noise Layer Three - Amplitude Scale')
      ], cpNormal, True, nil, 46),
      wbStruct(DATA, 'Visual Data', [
        wbFloat('Unknown'),
        wbFloat('Unknown'),
        wbFloat('Unknown'),
        wbFloat('Unknown'),
        wbFloat('Water Properties - Sun Power'),
        wbFloat('Water Properties - Reflectivity Amount'),
        wbFloat('Water Properties - Fresnel Amount'),
        wbUnused(4),
        wbFloat('Fog Properties - Above Water - Fog Distance - Near Plane'),
        wbFloat('Fog Properties - Above Water - Fog Distance - Far Plane'),
        wbByteColors('Shallow Color'),
        wbByteColors('Deep Color'),
        wbByteColors('Reflection Color'),
        wbUnused(4),
        wbFloat('Rain Simulator - Force'),
        wbFloat('Rain Simulator - Velocity'),
        wbFloat('Rain Simulator - Falloff'),
        wbFloat('Rain Simulator - Dampner'),
        wbFloat('Displacement Simulator - Starting Size'),
        wbFloat('Displacement Simulator - Force'),
        wbFloat('Displacement Simulator - Velocity'),
        wbFloat('Displacement Simulator - Falloff'),
        wbFloat('Displacement Simulator - Dampner'),
        wbFloat('Rain Simulator - Starting Size'),
        wbFloat('Noise Properties - Normals - Noise Scale'),
        wbFloat('Noise Properties - Noise Layer One - Wind Direction'),
        wbFloat('Noise Properties - Noise Layer Two - Wind Direction'),
        wbFloat('Noise Properties - Noise Layer Three - Wind Direction'),
        wbFloat('Noise Properties - Noise Layer One - Wind Speed'),
        wbFloat('Noise Properties - Noise Layer Two - Wind Speed'),
        wbFloat('Noise Properties - Noise Layer Three - Wind Speed'),
        wbFloat('Noise Properties - Normals - Depth Falloff Start'),
        wbFloat('Noise Properties - Normals - Depth Falloff End'),
        wbFloat('Fog Properties - Above Water - Fog Amount'),
        wbFloat('Noise Properties - Normals - UV Scale'),
        wbFloat('Fog Properties - Under Water - Fog Amount'),
        wbFloat('Fog Properties - Under Water - Fog Distance - Near Plane'),
        wbFloat('Fog Properties - Under Water - Fog Distance - Far Plane'),
        wbFloat('Water Properties - Distortion Amount'),
        wbFloat('Water Properties - Shininess'),
        wbFloat('Water Properties - Reflection HDR Multiplier'),
        wbFloat('Water Properties - Light Radius'),
        wbFloat('Water Properties - Light Brightness'),
        wbFloat('Noise Properties - Noise Layer One - UV Scale'),
        wbFloat('Noise Properties - Noise Layer Two - UV Scale'),
        wbFloat('Noise Properties - Noise Layer Three - UV Scale'),
        wbEmpty('Noise Properties - Noise Layer One - Amplitude Scale'),
        wbEmpty('Noise Properties - Noise Layer Two - Amplitude Scale'),
        wbEmpty('Noise Properties - Noise Layer Three - Amplitude Scale'),
        wbInteger('Damage (Old Format)', itU16)
      ]).SetRequired
    ]).SetRequired,
    wbStruct(GNAM, 'Related Waters (Unused)', [
      wbFormIDCk('Daytime', [WATR, NULL]),
      wbFormIDCk('Nighttime', [WATR, NULL]),
      wbFormIDCk('Underwater', [WATR, NULL])
    ]).SetRequired
  ]).SetAfterLoad(wbWATRAfterLoad);

  wbRecord(WEAP, 'Weapon',
    wbFlags(wbFlagsList([
      10, 'Quest Item',
      27, 'Unknown 27',
      29, 'Unknown 29'
    ])), [
    wbEDIDReq,
    wbOBND(True),
    wbFULL,
    wbGenericModel,
    wbICON,
    wbSCRI,
    wbEITM,
    wbInteger(EAMT, 'Enchantment Charge Amount', itS16),
    wbFormIDCkNoReach(NAM0, 'Ammo', [AMMO, FLST]),
    wbDEST,
    wbREPL,
    wbETYPReq,
    wbBIPL,
    wbYNAM,
    wbZNAM,
    wbRStruct('Shell Casing Model', [
      wbString(MOD2, 'Model FileName'),
      wbModelInfo(MO2T),
      wbMO2S
    ])
    .SetSummaryKey([0])
    .IncludeFlag(dfCollapsed, wbCollapseModels),
    wbRStruct('Scope Model', [
      wbString(MOD3, 'Model FileName'),
      wbModelInfo(MO3T),
      wbMO3S
    ])
    .SetSummaryKey([0])
    .IncludeFlag(dfCollapsed, wbCollapseModels),
    wbFormIDCK(EFSD, 'Scope Effect', [EFSH]),
    wbRStruct('World Model', [
      wbString(MOD4, 'Model FileName'),
      wbModelInfo(MO4T),
      wbMO4S
    ])
    .SetSummaryKey([0])
    .IncludeFlag(dfCollapsed, wbCollapseModels),
    wbString(NNAM, 'Embedded Weapon Node'),
    wbFormIDCk(INAM, 'Impact DataSet', [IPDS]),
    wbFormIDCk(WNAM, '1st Person Model', [STAT]),
    wbFormIDCk(SNAM, 'Sound - Gun - Shoot 3D', [SOUN]),
    wbFormIDCk(XNAM, 'Sound - Gun - Shoot 2D', [SOUN]),
    wbFormIDCk(NAM7, 'Sound - Gun - Shoot 3D Looping', [SOUN]),
    wbFormIDCk(TNAM, 'Sound - Melee - Swing / Gun - No Ammo', [SOUN]),
    wbFormIDCk(NAM6, 'Sound - Block', [SOUN]),
    wbFormIDCk(UNAM, 'Sound - Idle', [SOUN]),
    wbFormIDCk(NAM9, 'Sound - Equip', [SOUN]),
    wbFormIDCk(NAM8, 'Sound - Unequip', [SOUN]),
    wbStruct(DATA, '', [
      wbInteger('Value', itS32),
      wbInteger('Health', itS32),
      wbFloat('Weight'),
      wbInteger('Base Damage', itS16),
      wbInteger('Clip Size', itU8)
    ]).SetRequired,
    wbStruct(DNAM, '', [
      {00} wbInteger('Animation Type', itU32, wbWeaponAnimTypeEnum),
      {04} wbFloat('Animation Multiplier'),
      {08} wbFloat('Reach'),
      {12} wbInteger('Flags 1', itU8, wbFlags([
        'Ignores Normal Weapon Resistance',
        'Automatic',
        'Has Scope',
        'Can''t Drop',
        'Hide Backpack',
        'Embedded Weapon',
        'Don''t Use 1st Person IS Animations',
        'Non-Playable'
      ])),
      {13} wbInteger('Grip Animation', itU8, wbEnum([
      ], [
        171, 'HandGrip1',
        172, 'HandGrip2',
        173, 'HandGrip3',
        255, 'DEFAULT'
      ])),
      {14} wbInteger('Ammo Use', itU8),
      {15} wbInteger('Reload Animation', itU8,
             wbEnum([
               {0}  'ReloadA',
               {1}  'ReloadB',
               {2}  'ReloadC',
               {3}  'ReloadD',
               {4}  'ReloadE',
               {5}  'ReloadF',
               {6}  'ReloadG',
               {7}  'ReloadH',
               {8}  'ReloadI',
               {9}  'ReloadJ',
               {10} 'ReloadK'
             ],[
                255, 'None'
             ])),
      {16} wbFloat('Min Spread'),
      {20} wbFloat('Spread'),
      {24} wbFloat('Unknown'),
      {28} wbFloat('Sight FOV'),
      {32} wbUnused(4),
      {36} wbFormIDCk('Projectile', [PROJ, NULL]),
      {40} wbInteger('Base VATS To-Hit Chance', itU8),
      {41} wbInteger('Attack Animation', itU8, wbEnum([
           ], [
             26, 'AttackLeft',
             32, 'AttackRight',
             38, 'Attack3',
             44, 'Attack4',
             50, 'Attack5',
             56, 'Attack6',
             62, 'Attack7',
             68, 'Attack8',
             74, 'AttackLoop',
             80, 'AttackSpin',
             86, 'AttackSpin2',
             97, 'PlaceMine',
            103, 'PlaceMine2',
            109, 'AttackThrow',
            115, 'AttackThrow2',
            121, 'AttackThrow3',
            127, 'AttackThrow4',
            133, 'AttackThrow5',
            255, 'DEFAULT'
           ])),
      {42} wbInteger('Projectile Count', itU8),
      {43} wbInteger('Embedded Weapon - Actor Value', itU8, wbEnum([
        {00} 'Perception',
        {01} 'Endurance',
        {02} 'Left Attack',
        {03} 'Right Attack',
        {04} 'Left Mobility',
        {05} 'Right Mobility',
        {06} 'Brain'
      ])),
      {44} wbFloat('Min Range'),
      {48} wbFloat('Max Range'),
      {52} wbInteger('On Hit', itU32, wbEnum([
        'Normal formula behavior',
        'Dismember Only',
        'Explode Only',
        'No Dismember/Explode'
      ])),
      {56} wbInteger('Flags 2', itU32, wbFlags([
        {0x00000001}'Player Only',
        {0x00000002}'NPCs Use Ammo',
        {0x00000004}'No Jam After Reload',
        {0x00000008}'Override - Action Points',
        {0x00000010}'Minor Crime',
        {0x00000020}'Range - Fixed',
        {0x00000040}'Not Used In Normal Combat',
        {0x00000080}'Override - Damage to Weapon Mult',
        {0x00000100}'Don''t Use 3rd Person IS Animations',
        {0x00000200}'Short Burst',
        {0x00000400}'Rumble Alternate',
        {0x00000800}'Long Burst'
      ])),
      {60} wbFloat('Animation Attack Multiplier'),
      {64} wbFloat('Fire Rate'),
      {68} wbFloat('Override - Action Points'),
      {72} wbFloat('Rumble - Left Motor Strength'),
      {76} wbFloat('Rumble - Right Motor Strength'),
      {80} wbFloat('Rumble - Duration'),
      {84} wbFloat('Override - Damage to Weapon Mult'),
      {88} wbFloat('Attack Shots/Sec'),
      {92} wbFloat('Reload Time'),
      {96} wbFloat('Jam Time'),
     {100} wbFloat('Aim Arc'),
     {104} wbInteger('Skill', itS32, wbActorValueEnum),
     {108} wbInteger('Rumble - Pattern', itU32, wbEnum([
       'Constant',
       'Square',
       'Triangle',
       'Sawtooth'
     ])),
     {112} wbFloat('Rumble - Wavelength'),
     {116} wbFloat('Limb Dmg Mult'),
     {120} wbInteger('Resist Type', itS32, wbActorValueEnum),
     {124} wbFloat('Sight Usage'),
     {128} wbFloat('Semi-Automatic Fire Delay Min'),
     {132} wbFloat('Semi-Automatic Fire Delay Max')
    ], cpNormal, True, nil, 36),

   wbStruct(CRDT, 'Critical Data', [
      {00} wbInteger('Critical Damage', itU16),
      {09} wbUnused(2),
      {04} wbFloat('Crit % Mult'),
      {08} wbInteger('Flags', itU8, wbFlags([
        'On Death'
      ])),
      {09} wbUnused(3),
      {12} wbFormIDCk('Effect', [SPEL, NULL])
    ], cpNormal, True),
    wbInteger(VNAM, 'Sound Level', itU32, wbSoundLevelEnum).SetRequired
  ]).SetAfterLoad(wbWEAPAfterLoad);

  wbRecord(WTHR, 'Weather', [
    wbEDIDReq,
    wbFormIDCk(_00_IAD, 'Sunrise', [IMAD]),
    wbFormIDCk(_01_IAD, 'Day', [IMAD]),
    wbFormIDCk(_02_IAD, 'Sunset', [IMAD]),
    wbFormIDCk(_03_IAD, 'Night', [IMAD]),
    wbWeatherCloudTextures,
    wbRStruct('Precipitation', [
      wbGenericModel
    ]),
    wbInteger(LNAM, 'Max Cloud Layers', itU32)
      .SetDefaultNativeValue(4)
      .SetRequired,
    wbWeatherCloudSpeed,
    wbWeatherCloudColors,
    wbWeatherColors,
    wbWeatherFogDistance,
    wbUnused(INAM, 304).SetRequired,
    wbStruct(DATA, 'Data', [
      wbInteger('Wind Speed', itU8),
      wbUnused(2),
      wbInteger('Trans Delta', itU8),
      wbInteger('Sun Glare', itU8),
      wbInteger('Sun Damage', itU8),
      wbInteger('Precipitation - Begin Fade In', itU8),
      wbInteger('Precipitation - End Fade Out', itU8),
      wbInteger('Thunder/Lightning - Begin Fade In', itU8),
      wbInteger('Thunder/Lightning - End Fade Out', itU8),
      wbInteger('Thunder/Lightning - Frequency', itU8),
      wbInteger('Flags', itU8,
        wbFlags(wbSparseFlags([
          0, 'Weather - Pleasant',
          1, 'Weather - Cloudy',
          2, 'Weather - Rainy',
          3, 'Weather - Snow'
        ], False, 4), True)
      ).IncludeFlag(dfCollapsed, wbCollapseFlags),
      wbWeatherLightningColor
    ]).SetRequired,
    wbWeatherSounds
  ]);

  wbRecord(WRLD, 'Worldspace',
    wbFlags(wbFlagsList([
      19, 'Can''t Wait'
    ])), [
    wbEDIDReq,
    wbFULL,
    wbFormIDCk(XEZN, 'Encounter Zone', [ECZN]),
    wbRStruct('Parent Worldspace', [
      wbFormIDCk(WNAM, 'World', [WRLD]),
      wbInteger(PNAM, 'Flags', itU16,
        wbFlags(wbSparseFlags([
          0, 'Use Land Data',
          1, 'Use LOD Data',
          2, 'Use Map Data',
          3, 'Use Water Data',
          4, 'Use Climate Data',
          5, 'Use Image Space Data'
        ], False, 6), True)
      ).SetRequired
       .IncludeFlag(dfCollapsed, wbCollapseFlags)
    ]),
    wbFormIDCk(CNAM, 'Climate', [CLMT])
      .SetDefaultNativeValue(351)
      .SetIsRemovable(wbWorldClimateIsRemovable),
    wbFormIDCk(NAM2, 'Water', [WATR])
      .SetDefaultNativeValue(24)
      .SetIsRemovable(wbWorldWaterIsRemovable),
    wbWorldLODData,
    wbWorldLandData,
    wbICON,
    wbWorldMapData,
    wbWorldMapOffset,
    wbFormIDCk(INAM, 'Image Space', [IMGS]).SetDefaultNativeValue(353),
    wbInteger(DATA, 'Flags', itU8,
      wbFlags(wbSparseFlags([
        0, 'Small World',
        1, 'Can''t Fast Travel',
        4, 'No LOD Water',
        5, 'No LOD Noise',
        6, 'Don''t Allow NPC Fall Damage',
        7, 'Needs Water Adjustment'
      ], False, 8), True)
    ).SetDefaultNativeValue(1)
     .SetRequired
     .IncludeFlag(dfCollapsed, wbCollapseFlags),
    wbWorldObjectBounds,
    wbFormIDCk(ZNAM, 'Music', [MUSC]),
    wbString(NNAM, 'Canopy Shadow').SetRequired,
    wbString(XNAM, 'Water Noise Texture').SetRequired,
    wbWorldSwapsImpactData,
    wbWorldOffsetData
  ]).SetAfterLoad(wbWorldAfterLoad)
    .SetAfterSet(wbWorldAfterSet);

  wbAddGroupOrder(GMST);
  wbAddGroupOrder(TXST);
  wbAddGroupOrder(MICN);
  wbAddGroupOrder(GLOB);
  wbAddGroupOrder(CLAS);
  wbAddGroupOrder(FACT);
  wbAddGroupOrder(HDPT);
  wbAddGroupOrder(HAIR);
  wbAddGroupOrder(EYES);
  wbAddGroupOrder(RACE);
  wbAddGroupOrder(SOUN);
  wbAddGroupOrder(ASPC);
  //wbAddGroupOrder(SKIL);
  wbAddGroupOrder(MGEF);
  wbAddGroupOrder(SCPT);
  wbAddGroupOrder(LTEX);
  wbAddGroupOrder(ENCH);
  wbAddGroupOrder(SPEL);
  wbAddGroupOrder(ACTI);
  wbAddGroupOrder(TACT);
  wbAddGroupOrder(TERM);
  wbAddGroupOrder(ARMO);
  wbAddGroupOrder(BOOK);
  //wbAddGroupOrder(CLOT);
  wbAddGroupOrder(CONT);
  wbAddGroupOrder(DOOR);
  wbAddGroupOrder(INGR);
  wbAddGroupOrder(LIGH);
  wbAddGroupOrder(MISC);
  wbAddGroupOrder(STAT);
  wbAddGroupOrder(SCOL);
  wbAddGroupOrder(MSTT);
  wbAddGroupOrder(PWAT);
  wbAddGroupOrder(GRAS);
  wbAddGroupOrder(TREE);
  //wbAddGroupOrder(FLOR);
  wbAddGroupOrder(FURN);
  wbAddGroupOrder(WEAP);
  wbAddGroupOrder(AMMO);
  wbAddGroupOrder(NPC_);
  wbAddGroupOrder(PLYR);
  wbAddGroupOrder(CREA);
  wbAddGroupOrder(LVLC);
  wbAddGroupOrder(LVLN);
  wbAddGroupOrder(KEYM);
  wbAddGroupOrder(ALCH);
  wbAddGroupOrder(IDLM);
  wbAddGroupOrder(NOTE);
  wbAddGroupOrder(COBJ);
  wbAddGroupOrder(PROJ);
  wbAddGroupOrder(LVLI);
  wbAddGroupOrder(WTHR);
  wbAddGroupOrder(CLMT);
  wbAddGroupOrder(REGN);
  wbAddGroupOrder(NAVI);
  wbAddGroupOrder(CELL);
  //wbAddGroupOrder(REFR);
  //wbAddGroupOrder(ACHR);
  //wbAddGroupOrder(ACRE);
  //wbAddGroupOrder(PMIS);
  //wbAddGroupOrder(PGRE);
  //wbAddGroupOrder(PBEA);
  //wbAddGroupOrder(PFLA);
  wbAddGroupOrder(WRLD);
  //wbAddGroupOrder(LAND);
  //wbAddGroupOrder(NAVM);
  //wbAddGroupOrder(TLOD);
  wbAddGroupOrder(DIAL);
  //wbAddGroupOrder(INFO);
  wbAddGroupOrder(QUST);
  wbAddGroupOrder(IDLE);
  wbAddGroupOrder(PACK);
  wbAddGroupOrder(CSTY);
  wbAddGroupOrder(LSCR);
  //wbAddGroupOrder(LVSP);
  wbAddGroupOrder(ANIO);
  wbAddGroupOrder(WATR);
  wbAddGroupOrder(EFSH);
  //wbAddGroupOrder(TOFT);
  wbAddGroupOrder(EXPL);
  wbAddGroupOrder(DEBR);
  wbAddGroupOrder(IMGS);
  wbAddGroupOrder(IMAD);
  wbAddGroupOrder(FLST);
  wbAddGroupOrder(PERK);
  wbAddGroupOrder(BPTD);
  wbAddGroupOrder(ADDN);
  wbAddGroupOrder(AVIF);
  wbAddGroupOrder(RADS);
  wbAddGroupOrder(CAMS);
  wbAddGroupOrder(CPTH);
  wbAddGroupOrder(VTYP);
  wbAddGroupOrder(IPCT);
  wbAddGroupOrder(IPDS);
  wbAddGroupOrder(ARMA);
  wbAddGroupOrder(ECZN);
  wbAddGroupOrder(MESG);
  wbAddGroupOrder(RGDL);
  wbAddGroupOrder(DOBJ);
  wbAddGroupOrder(LGTM);
  wbAddGroupOrder(MUSC);
  wbNexusModsUrl := 'https://www.nexusmods.com/fallout3/mods/637';
  if wbToolMode = tmLODgen then
    wbNexusModsUrl := 'https://www.nexusmods.com/fallout3/mods/21174';
  wbHEDRVersion := 0.94;
end;

end.
