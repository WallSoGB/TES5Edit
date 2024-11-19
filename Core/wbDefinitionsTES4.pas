{******************************************************************************

  This Source Code Form is subject to the terms of the Mozilla Public License, 
  v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain 
  one at https://mozilla.org/MPL/2.0/.

*******************************************************************************}

unit wbDefinitionsTES4;

{$I wbDefines.inc}

interface

procedure DefineTES4;

implementation

uses
  Classes,
  SysUtils,
  Variants,
  wbDefinitionsCommon,
  wbDefinitionsSignatures,
  wbInterface;

var
  wbConditionMembers: array of IwbValueDef;
  wbConditionParameters: array of IwbValueDef;
  wbSoundDataMembers: array of IwbValueDef;

  wbAttributeEnum: IwbEnumDef;
  wbDialogueTypeEnum: IwbEnumDef;
  wbFormTypeEnum: IwbEnumDef;
  wbHeadPartIndexEnum: IwbEnumDef;
  wbMagicSchoolEnum: IwbEnumDef;
  wbMajorSkillEnum: IwbEnumDef;
  wbOBMEResolutionEnum: IwbEnumDef;
  wbResistEnum: IwbEnumDef;
  wbSkillEnum: IwbEnumDef;
  wbSpecializationEnum: IwbEnumDef;

  wbBipedFlags: IwbFlagsDef;

  wbOBMEVersion: IwbStructDef;

  wbBodyParts: IwbRecordMemberDef;
  wbCNTOs: IwbRecordMemberDef;
  wbConditions: IwbRecordMemberDef;
  wbDESC: IwbRecordMemberDef;
  wbEDID: IwbRecordMemberDef;
  wbEffects: IwbRecordMemberDef;
  wbFaceGen: IwbRecordMemberDef;
  wbFULL: IwbRecordMemberDef;
  wbFULLReq: IwbRecordMemberDef;
  wbICON: IwbRecordMemberDef;
  wbPGRP: IwbRecordMemberDef;
  wbResultScript: IwbRecordMemberDef;
  wbSCHR: IwbRecordMemberDef;
  wbSCRI: IwbRecordMemberDef;
  wbSCROs: IwbRecordMemberDef;
  wbSLSD: IwbRecordMemberDef;
  wbSPLO: IwbRecordMemberDef;
  wbSPLOs: IwbRecordMemberDef;
  wbXESP: IwbRecordMemberDef;
  wbXSCL: IwbRecordMemberDef;

type
  TCTDAFunctionParamType = (
    ptNone,
    ptInteger,
    ptQuestStage,
    ptVariableName,

    ptActorValue,    //wbActorValue
    ptAxis,          //wbAxisEnum
    ptCrimeType,     //wbCrimeTypeEnum
    ptFormType,      //wbFormTypeEnum
    ptSex,           //wbSexEnum

    ptActor,              //ACHR, ACRE, PLYR, TRGT
    ptActorBase,          //CREA, NPC_
    ptBaseObject,         //ACTI, ALCH, AMMO, APPA, ARMO, BOOK, CLOT, CONT, CREA, DOOR, FLOR, FURN, GRAS, INGR, KEYM, LIGH, LVLC, MISC, NPC_, SBSP, SGST, SLGM, SOUN, STAT, TREE, WEAP
    ptBirthsign,          //BSGN
    ptCell,               //CELL
    ptClass,              //CLAS
    ptFaction,            //FACT
    ptFurniture,          //FURN
    ptGlobal,             //GLOB
    ptInventoryObject,    //ALCH, AMMO, APPA, ARMO, BOOK, CLOT, INGR, KEYM, LIGH, MISC, SGST, SLGM, WEAP
    ptMagicEffect,        //MGEF
    ptOwner,              //FACT, NPC_
    ptPackage,            //PACK
    ptQuest,              //QUST
    ptRace,               //RACE
    ptReference,          //ACHR, ACRE, PLYR, REFR, TRGT
    ptSpell,              //SPEL
    ptWeather,            //WTHR
    ptWorldspace          //WRLD
  );

  PCTDAFunction = ^TCTDAFunction;
  TCTDAFunction = record
    Index: Integer;
    Name: string;
    ParamType1: TCTDAFunctionParamType;
    ParamType2: TCTDAFunctionParamType;
  end;

const
  wbCTDAFunctions : array[0..199] of TCTDAFunction = (
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
    (Index:  27; Name: 'GetLineOfSight'; ParamType1: ptReference),
    (Index:  32; Name: 'GetInSameCell'; ParamType1: ptReference),
    (Index:  35; Name: 'GetDisabled'),
    (Index:  36; Name: 'MenuMode'; ParamType1: ptInteger),
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
    (Index:  98; Name: 'GetPlayerControlsDisabled'),
    (Index:  99; Name: 'GetHeadingAngle'; ParamType1: ptReference),
    (Index: 101; Name: 'IsWeaponOut'),
    (Index: 102; Name: 'IsTorchOut'),
    (Index: 103; Name: 'IsShieldOut'),
    (Index: 104; Name: 'IsYielding'),
    (Index: 106; Name: 'IsFacingUp'),
    (Index: 107; Name: 'GetKnockedState'),
    (Index: 108; Name: 'GetWeaponAnimType'),
    (Index: 109; Name: 'GetWeaponSkillType'),
    (Index: 110; Name: 'GetCurrentAIPackage'),
    (Index: 111; Name: 'IsWaiting'),
    (Index: 112; Name: 'IsIdlePlaying'),
    (Index: 116; Name: 'GetCrimeGold'),
    (Index: 122; Name: 'GetCrime'; ParamType1: ptActor; ParamType2: ptCrimeType),
    (Index: 125; Name: 'IsGuard'),
    (Index: 127; Name: 'CanPayCrimeGold'),
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
    (Index: 171; Name: 'IsPlayerInJail'),
    (Index: 172; Name: 'GetTalkedToPCParam'; ParamType1: ptActor),
    (Index: 175; Name: 'IsPCSleeping'),
    (Index: 176; Name: 'IsPCAMurderer'),
    (Index: 180; Name: 'GetDetectionLevel'; ParamType1: ptActor),
    (Index: 182; Name: 'GetEquipped'; ParamType1: ptInventoryObject),
    (Index: 185; Name: 'IsSwimming'),
    (Index: 190; Name: 'GetAmountSoldStolen'),
    (Index: 193; Name: 'GetPCExpelled'; ParamType1: ptFaction),
    (Index: 195; Name: 'GetPCFactionMurder'; ParamType1: ptFaction),
    (Index: 197; Name: 'GetPCFactionSteal'; ParamType1: ptFaction),
    (Index: 199; Name: 'GetPCFactionAttack'; ParamType1: ptFaction),
    (Index: 201; Name: 'GetPCFactionSubmitAuthority'; ParamType1: ptFaction),
    (Index: 203; Name: 'GetDestroyed'),
    (Index: 214; Name: 'HasMagicEffect'; ParamType1: ptMagicEffect),
    (Index: 215; Name: 'GetDoorDefaultOpen'),
    (Index: 223; Name: 'IsSpellTarget'; ParamType1: ptSpell),
    (Index: 224; Name: 'GetIsPlayerBirthsign'; ParamType1: ptBirthsign),
    (Index: 225; Name: 'GetPersuasionNumber'),
    (Index: 227; Name: 'HasVampireFed'),
    (Index: 228; Name: 'GetIsClassDefault'; ParamType1: ptClass),
    (Index: 229; Name: 'GetClassDefaultMatch'),
    (Index: 230; Name: 'GetInCellParam'; ParamType1: ptCell; ParamType2: ptReference),
    (Index: 237; Name: 'GetIsGhost'),
    (Index: 242; Name: 'GetUnconscious'),
    (Index: 244; Name: 'GetRestrained'),
    (Index: 246; Name: 'GetIsUsedItem'; ParamType1: ptBaseObject),
    (Index: 247; Name: 'GetIsUsedItemType'; ParamType1: ptFormType),
    (Index: 249; Name: 'GetPCFame'),
    (Index: 251; Name: 'GetPCInfamy'),
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
    (Index: 288; Name: 'GetFriendHit'; ParamType1: ptActor),
    (Index: 289; Name: 'IsInCombat'),
    (Index: 300; Name: 'IsInInterior'),
    (Index: 305; Name: 'GetInvestmentGold'),
    (Index: 306; Name: 'IsActorUsingATorch'),
    (Index: 309; Name: 'IsXBox'),
    (Index: 310; Name: 'GetInWorldspace'; ParamType1: ptWorldSpace),
    (Index: 312; Name: 'GetPCMiscStat'; ParamType1: ptInteger),
    (Index: 313; Name: 'IsActorEvil'),
    (Index: 314; Name: 'IsActorAVictim'),
    (Index: 315; Name: 'GetTotalPersuasionNumber'),
    (Index: 318; Name: 'GetIdleDoneOnce'),
    (Index: 320; Name: 'GetNoRumors'),
    (Index: 323; Name: 'WhichServiceMenu'),
    (Index: 327; Name: 'IsRidingHorse'),
    (Index: 329; Name: 'IsTurnArrest'),
    (Index: 332; Name: 'IsInDangerousWater'),
    (Index: 338; Name: 'GetIgnoreFriendlyHits'),
    (Index: 339; Name: 'IsPlayersLastRiddenHorse'),
    (Index: 353; Name: 'IsActor'),
    (Index: 354; Name: 'IsEssential'),
    (Index: 358; Name: 'IsPlayerMovingIntoNewSpace'),
    (Index: 361; Name: 'GetTimeDead'),
    (Index: 362; Name: 'GetPlayerHasLastRiddenHorse'),
    (Index: 365; Name: 'GetPlayerInSEWorld'),

    // Added by (x)OBSE:
    (Index: 1107; Name: 'IsAmmo'; ParamType1: ptInteger),
    (Index: 1122; Name: 'HasSpell'; ParamType1: ptSpell),
    (Index: 1124; Name: 'IsClassSkill'; ParamType1: ptActorValue; ParamType2: ptClass),
    (Index: 1254; Name: 'GetActorLightAmount'),
    (Index: 1884; Name: 'GetPCTrainingSessionsUsed'; ParamType1: ptPackage),
    (Index: 2213; Name: 'GetPackageOffersServices'; ParamType1: ptPackage),
    (Index: 2214; Name: 'GetPackageMustReachLocation'; ParamType1: ptPackage),
    (Index: 2215; Name: 'GetPackageMustComplete'; ParamType1: ptPackage),
    (Index: 2216; Name: 'GetPackageLockDoorsAtStart'; ParamType1: ptPackage),
    (Index: 2217; Name: 'GetPackageLockDoorsAtEnd'; ParamType1: ptPackage),
    (Index: 2218; Name: 'GetPackageLockDoorsAtLocation'; ParamType1: ptPackage),
    (Index: 2219; Name: 'GetPackageUnlockDoorsAtStart'; ParamType1: ptPackage),
    (Index: 2220; Name: 'GetPackageUnlockDoorsAtEnd'; ParamType1: ptPackage),
    (Index: 2221; Name: 'GetPackageUnlockDoorsAtLocation'; ParamType1: ptPackage),
    (Index: 2222; Name: 'GetPackageContinueIfPCNear'; ParamType1: ptPackage),
    (Index: 2223; Name: 'GetPackageOncePerDay'; ParamType1: ptPackage),
    (Index: 2224; Name: 'GetPackageSkipFalloutBehavior'; ParamType1: ptPackage),
    (Index: 2225; Name: 'GetPackageAlwaysRun'; ParamType1: ptPackage),
    (Index: 2226; Name: 'GetPackageAlwaysSneak'; ParamType1: ptPackage),
    (Index: 2227; Name: 'GetPackageAllowSwimming'; ParamType1: ptPackage),
    (Index: 2228; Name: 'GetPackageAllowFalls'; ParamType1: ptPackage),
    (Index: 2229; Name: 'GetPackageArmorUnequipped'; ParamType1: ptPackage),
    (Index: 2230; Name: 'GetPackageWeaponsUnequipped'; ParamType1: ptPackage),
    (Index: 2231; Name: 'GetPackageDefensiveCombat'; ParamType1: ptPackage),
    (Index: 2232; Name: 'GetPackageUseHorse'; ParamType1: ptPackage),
    (Index: 2233; Name: 'GetPackageNoIdleAnims'; ParamType1: ptPackage),
    (Index: 2571; Name: 'GetBaseAV3'; ParamType1: ptActorValue),
    (Index: 2572; Name: 'GetBaseAV3C'; ParamType1: ptInteger),
    (Index: 2573; Name: 'IsNaked'; ParamType1: ptInteger),
    (Index: 2577; Name: 'IsMajorRef'; ParamType1: ptActorValue),
    (Index: 2578; Name: 'IsDiseased')
  );

function wbCTDAParamDescFromIndex(aIndex: Integer): PCTDAFunction;
var
  L, H, I, C: Integer;
begin
  Result := nil;

  L := Low(wbCTDAFunctions);
  H := High(wbCTDAFunctions);
  while L <= H do begin
    I := (L + H) shr 1;
    C := CmpW32(wbCTDAFunctions[I].Index, aIndex);
    if C < 0 then
      L := I + 1
    else begin
      H := I - 1;
      if C = 0 then begin
        L := I;
        Result := @wbCTDAFunctions[L];
      end;
    end;
  end;
end;

function wbCTDAFunctionToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  wbCTDAFunctionEditInfo : string;
  Desc                   : PCTDAFunction;
  i                      : Integer;
begin
  Result := '';
  case aType of
    ctToStr, ctToSummary, ctToEditValue: begin
      Desc := wbCTDAParamDescFromIndex(aInt);
      if Assigned(Desc) then
        Result := Desc.Name
      else if aType in [ctToSummary, ctToEditValue] then
        Result := aInt.ToString
      else
        Result := '<Unknown: '+aInt.ToString+'>';
    end;
    ctToSortKey: Result := IntToHex(aInt, 8);
    ctCheck: begin
      Desc := wbCTDAParamDescFromIndex(aInt);
      if Assigned(Desc) then
        Result := ''
      else
        Result := '<Unknown: '+aInt.ToString+'>';
    end;
    ctEditType:
      Result := 'ComboBox';
    ctEditInfo: begin
      Result := wbCTDAFunctionEditInfo;
      if Result = '' then begin
        with TStringList.Create do try
          for i := Low(wbCTDAFunctions) to High(wbCTDAFunctions) do
            Add(wbCTDAFunctions[i].Name);
          Sort;
          Result := CommaText;
        finally
          Free;
        end;
        wbCTDAFunctionEditInfo := Result;
      end;
    end;
  end;
end;

function wbCTDAFunctionToInt(const aString: string; const aElement: IwbElement): Int64;
var
  i: Integer;
begin
  for i := Low(wbCTDAFunctions) to High(wbCTDAFunctions) do
    with wbCTDAFunctions[i] do
      if SameText(Name, aString) then begin
        Result := Index;
        Exit;
      end;
  Result := StrToInt64(aString);
end;

function wbCTDAParam1Decider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Desc: PCTDAFunction;
  Container: IwbContainer;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  Desc := wbCTDAParamDescFromIndex(Container.ElementByName['Function'].NativeValue);
  if Assigned(Desc) then
    Result := Succ(Integer(Desc.ParamType1));
end;

function wbCTDAParam2Decider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Desc: PCTDAFunction;
  Container: IwbContainer;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  Desc := wbCTDAParamDescFromIndex(Container.ElementByName['Function'].NativeValue);
  if Assigned(Desc) then
    Result := Succ(Integer(Desc.ParamType2));
end;

function wbCTDAParam2QuestStageToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
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
        Result := Result + ' <Warning: Could not resolve Parameter 1>';
    end;
    ctToEditValue: Result := aInt.ToString;
    ctToSortKey: begin
      Result := IntToHex64(aInt, 8);
      Exit;
    end;
    ctCheck: Result := '<Warning: Could not resolve Parameter 1>';
    ctEditType: Result := '';
    ctEditInfo: Result := '';
  end;

  if not wbTryGetContainerRefFromUnionOrValue(aElement, Container) then
    Exit;

  Param1 := Container.ElementByName['Parameter #1'];
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
          if aType = ctToSummary then
            s := Stage.ElementSummaries['Log Entries\Log Entry\CNAM']
          else
            s := Stage.ElementValues['Log Entries\Log Entry\CNAM'];
          s := s.Trim;
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

function wbCTDAParam2VariableNameToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Container  : IwbContainerElementRef;
  Param1     : IwbElement;
  MainRecord : IwbMainRecord;
  BaseRecord : IwbMainRecord;
  ScriptRef  : IwbElement;
  Script     : IwbMainRecord;
  Variables  : TStringList;
  LocalVars  : IwbContainerElementRef;
  LocalVar   : IwbContainerElementRef;
  i, j       : Integer;
  s          : string;
begin
  case aType of
    ctToStr, ctToSummary: begin
      Result := aInt.ToString;
      if aType = ctToStr then
        Result := Result + ' <Warning: Could not resolve Parameter 1>';
    end;
    ctToEditValue: Result := aInt.ToString;
    ctToSortKey: begin
      Result := IntToHex64(aInt, 8);
      Exit;
    end;
    ctCheck: Result := '<Warning: Could not resolve Parameter 1>';
    ctEditType: Result := '';
    ctEditInfo: Result := '';
  end;

  if not wbTryGetContainerRefFromUnionOrValue(aElement, Container) then
    Exit;

  Param1 := Container.ElementByName['Parameter #1'];
  if not wbTryGetMainRecord(Param1, MainRecord) then
    Exit;

{    if Param1.NativeValue = 0 then
      if Supports(Container.Container, IwbContainerElementRef, Container) then
        for i := 0 to Pred(Container.ElementCount) do
          if Supports(Container.Elements[i], IwbContainerElementRef, Container2) then
            if SameText(Container2.ElementValues['Function'], 'GetIsID') then begin
              Param1 := Container2.ElementByName['Parameter #1'];
              if Supports(Param1.LinksTo, IwbMainRecord, MainRecord) then
                Break;
            end;}

  BaseRecord := MainRecord.BaseRecord;
  if Assigned(BaseRecord) then
    MainRecord := BaseRecord;

  ScriptRef := MainRecord.RecordBySignature['SCRI'];

  if not Assigned(ScriptRef) then begin
    case aType of
      ctToStr, ctToSummary: begin
        Result := aInt.ToString;
        if aType = ctToStr then
          Result := Result + ' <Warning: "'+MainRecord.ShortName+'" does not contain a SCRI subrecord>';
      end;
      ctCheck: Result := '<Warning: "'+MainRecord.ShortName+'" does not contain a SCRI subrecord>';
    end;
    Exit;
  end;

  if not Supports(ScriptRef.LinksTo, IwbMainRecord, Script) then begin
    case aType of
      ctToStr, ctToSummary: begin
        Result := aInt.ToString;
        if aType = ctToStr then
          Result := Result + ' <Warning: "'+MainRecord.ShortName+'" does not have a valid script>';
      end;
      ctCheck: Result := '<Warning: "'+MainRecord.ShortName+'" does not have a valid script>';
    end;
    Exit;
  end;

  case aType of
    ctEditType: begin
      Result := 'ComboBox';
      Exit;
    end;
    ctEditInfo:
      Variables := TStringList.Create;
  else
    Variables := nil;
  end;
  try
    if Supports(Script.ElementByName['Local Variables'], IwbContainerElementRef, LocalVars) then begin
      for i := 0 to Pred(LocalVars.ElementCount) do
        if Supports(LocalVars.Elements[i], IwbContainerElementRef, LocalVar) then begin
          j := LocalVar.ElementNativeValues['SLSD\Index'];
          s := LocalVar.ElementNativeValues['SCVR'];
          if Assigned(Variables) then
            Variables.AddObject(s, TObject(j))
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
      ctToStr, ctToSummary: begin
        Result := aInt.ToString;
        if aType = ctToStr then
          Result := Result + ' <Warning: Variable Index not found in "' + Script.Name + '">';
      end;
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

function wbCTDAParam2VariableNameToInt(const aString: string; const aElement: IwbElement): Int64;
var
  Container  : IwbContainerElementRef;
  Param1     : IwbElement;
  MainRecord : IwbMainRecord;
  BaseRecord : IwbMainRecord;
  ScriptRef  : IwbElement;
  Script     : IwbMainRecord;
  LocalVars  : IwbContainerElementRef;
  LocalVar   : IwbContainerElementRef;
  i, j       : Integer;
  s          : string;
begin
  Result := StrToInt64Def(aString, Low(Cardinal));
  if Result <> Low(Cardinal) then
    Exit;

  if not Assigned(aElement) then
    raise Exception.Create('aElement not specified');

  Container := GetContainerRefFromUnionOrValue(aElement);

  if not Assigned(Container) then
    raise Exception.Create('Container not assigned');

  Param1 := Container.ElementByName['Parameter #1'];

  if not Assigned(Param1) then
    raise Exception.Create('Could not find "Parameter #1"');

  if not Supports(Param1.LinksTo, IwbMainRecord, MainRecord) then
    raise Exception.Create('"Parameter #1" does not reference a valid main record');

  BaseRecord := MainRecord.BaseRecord;
  if Assigned(BaseRecord) then
    MainRecord := BaseRecord;

  ScriptRef := MainRecord.RecordBySignature['SCRI'];

  if not Assigned(ScriptRef) then
    raise Exception.Create('"'+MainRecord.ShortName+'" does not contain a SCRI subrecord');

  if not Supports(ScriptRef.LinksTo, IwbMainRecord, Script) then
    raise Exception.Create('"'+MainRecord.ShortName+'" does not have a valid script');

  if Supports(Script.ElementByName['Local Variables'], IwbContainerElementRef, LocalVars) then begin
    for i := 0 to Pred(LocalVars.ElementCount) do
      if Supports(LocalVars.Elements[i], IwbContainerElementRef, LocalVar) then begin
        j := LocalVar.ElementNativeValues['SLSD\Index'];
        s := LocalVar.ElementNativeValues['SCVR'];
        if SameText(s, Trim(aString)) then begin
          Result := j;
          Exit;
        end;
      end;
  end;

  raise Exception.Create('Variable "'+aString+'" was not found in "'+MainRecord.ShortName+'"');
end;

function wbCalcPGRRSize(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
var
  Index: Integer;

  function ExtractCountFromLabel(const aElement: IwbElement; aCount: Integer): Integer;
  var
    i: Integer;
  begin
    i := Pos('#', aElement.Name);
    if i = 0 then
      Result := aCount
    else try
      Result := StrToInt(Trim(Copy(aElement.Name, i+1, Length(aElement.Name))))+1;
    except
      Result := aCount;
    end;

  end;

begin
  Index := ExtractCountFromLabel(aElement, aElement.Container.ElementCount);
  Result := ((aElement.Container.Container as IwbMainRecord).RecordBySignature['PGRP'].Elements[Pred(Index)] as IwbContainer).Elements[3].NativeValue;
end;

procedure wbCELLAfterLoad(const aElement: IwbElement);
var
  Container    : IwbContainerElementRef;
//  Container2   : IwbContainerElementRef;
  MainRecord   : IwbMainRecord;
//  i            : Integer;
  IsInterior   : Boolean;
  GroupRecord  : IwbGroupRecord;
//  Removed      : Boolean;
begin
  if wbBeginInternalEdit then try
    if not wbTryGetContainerWithValidMainRecord(aElement, Container, MainRecord) then
      Exit;

    if not Container.ElementExists['DATA'] then
      Exit;

    IsInterior := (Container.ElementNativeValues['DATA'] and 1) <> 0;

    if IsInterior then
      Container.Add('XCLL')
    else begin
      Container.Add('XCLC');
      if (Container.ElementNativeValues['DATA'] and 2) = 0 then
        if Supports(MainRecord.Container, IwbGroupRecord, GroupRecord) then
          if GroupRecord.GroupType = 1 then
            Container.ElementNativeValues['DATA'] :=
              Container.ElementNativeValues['DATA'] or 2;
    end;

//    Removed := False;
//    if Supports(Container.ElementBySignature[XCLR], IwbContainerElementRef, Container2) then begin
//      for i:= Pred(Container2.ElementCount) downto 0 do
//        if not Supports(Container2.Elements[i].LinksTo, IwbMainRecord, MainRecord) or (MainRecord.Signature <> 'REGN') then begin
//          if not Removed then begin
//            Removed := True;
//            Container2.MarkModifiedRecursive;
//          end;
//          Container2.RemoveElement(i);
//        end;
//      if Container2.ElementCount < 1 then
//        Container2.Remove;
//    end;
  finally
    wbEndInternalEdit;
  end;
end;

function wbEDDXDontShow(const aElement: IwbElement): Boolean;
var
  MainRecord : IwbMainRecord;
begin
  Result := True;

  if Supports(aElement.Container, IwbMainRecord, MainRecord) then
    Result := not Assigned(MainRecord.ElementBySignature[OBME]);
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

    Element := Container.ElementByName['Magic effect name'];
    if not wbTryGetMainRecord(Element, MainRecord, 'MGEF') then
      Exit;

    if (MainRecord.ElementNativeValues['DATA - Data\Flags'] and $01000000) = 0 then
      Exit;

    ActorValue := MainRecord.ElementNativeValues['DATA - Data\Assoc. Item'];
    if VarIsNull(ActorValue) or VarIsClear(ActorValue) then
      Exit;

    if VarCompareValue(ActorValue, Container.ElementNativeValues['Actor Value']) <> vrEqual then
      Container.ElementNativeValues['Actor Value'] := ActorValue;
  finally
    wbEndInternalEdit;
  end;
end;

function wbEFITOBMEParamDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  ParamInfo: Variant;
  Container: IwbContainer;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  ParamInfo := Container.ElementNativeValues['..\EFME\EFIT Param Info'];
  if VarIsNull(ParamInfo) or VarIsEmpty(ParamInfo) then
  else
    Result := ParamInfo;
end;

function wbEFIXParamDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  ParamInfo: Variant;
  Container: IwbContainer;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  ParamInfo := Container.ElementNativeValues['..\EFME\EFIX Param Info'];
  if VarIsNull(ParamInfo) or VarIsEmpty(ParamInfo) then
  else
    Result := ParamInfo;
end;

function wbIdleAnam(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
begin
  Result := '';
  case aType of
    ctToStr, ctToSummary: begin
      case aInt and not $80 of
        0: Result := 'Lower Body';
        1: Result := 'Left Arm';
        2: Result := 'Left Hand';
        3: Result := 'Right Arm';
        4: Result := 'Special Idle';
        5: Result := 'Whole Body';
        6: Result := 'Upper Body';
      else
        Result := '<Unknown: '+IntToStr(aInt and not $80)+'>';
      end;

      if (aInt and $80) = 0 then
        Result := Result + ', Must return a file';
    end;
    ctToSortKey: begin
      Result := IntToHex64(aInt, 2);
    end;
    ctCheck: begin
      case aInt and not $80 of
        0..6: Result := '';
      else
        Result := '<Unknown: '+IntToStr(aInt and not $80)+'>';
      end;
    end;
  end;
end;

procedure wbLVLAfterLoad(const aElement: IwbElement);
var
  Container  : IwbContainerElementRef;
  MainRecord : IwbMainRecord;
  Chance     : Integer;
begin
  if wbBeginInternalEdit then try
    if not wbTryGetContainerWithValidMainRecord(aElement, Container, MainRecord) then
      Exit;

    Container.RemoveElement('DATA');

    Chance := Container.ElementNativeValues['LVLD'];
    if (Chance and $80) <> 0 then begin
      Chance := Chance and not $80;
      Container.ElementNativeValues['LVLD'] := Chance;
      Container.ElementNativeValues['LVLF'] := Container.ElementNativeValues['LVLF'] or $01;
    end;
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbMGEFAfterLoad(const aElement: IwbElement);
var
  Container    : IwbContainerElementRef;
  MainRecord   : IwbMainRecord;
  _File        : IwbFile;
begin
  if wbBeginInternalEdit then try
    if not wbTryGetContainerWithValidMainRecord(aElement, Container, MainRecord) then
      Exit;

    _File := MainRecord._File;

    if not Assigned(_File) then
      Exit;

    if not SameText(_File.FileName, 'Oblivion.esm') then
      Exit;

    if SameText(MainRecord.EditorID, 'RSFI') or
       SameText(MainRecord.EditorID, 'RSFR') or
       SameText(MainRecord.EditorID, 'RSPA') or
       SameText(MainRecord.EditorID, 'RSSH') then begin

         Container.ElementNativeValues['DATA - Data\Flags'] :=
           Cardinal(Container.ElementNativeValues['DATA - Data\Flags']) or $8;

       end;

    if SameText(MainRecord.EditorID, 'REAN') then begin

         Container.ElementNativeValues['DATA - Data\Flags'] :=
           Cardinal(Container.ElementNativeValues['DATA - Data\Flags']) and not $20000;

       end;

  finally
    wbEndInternalEdit;
  end;
end;

function wbMGEFFAssocItemDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  s: string;
  Container: IwbContainer;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  s := Container.ElementByName['Flags'].SortKey[False];
  if s[17] = '1' then
    Result := 1
  else if s[18] = '1' then
    Result := 2
  else if s[19] = '1' then
    Result := 3
  else if s[25] = '1' then
    Result := 4;
end;

function wbMISCActorValueDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  MainRecord : IwbMainRecord;
begin
  Result := 0;

  if not wbTryGetContainingMainRecord(aElement, MainRecord) then
    Exit;

  if (MainRecord.Flags._Flags and $000000C0) = $000000C0 then
    Result := 1;
end;

function wbOBMEDontShow(const aElement: IwbElement): Boolean;
var
  _File: IwbFile;
begin
  if not Assigned(aElement) then begin
    Result := True;
    Exit;
  end;

  Result := False;

  _File := aElement._File;
  if Assigned(_File) and SameText(_File.FileName, 'Oblivion.esm') then
    Result := True;
end;

function wbPACKPKDTDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container : IwbContainer;
  SubRecord : IwbSubRecord;
begin
  Result := 1;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  if Supports(Container, IwbSubRecord, SubRecord) then
    if SubRecord.SubRecordHeaderSize = 4 then
      Result := 0;
end;

procedure wbPGRDAfterLoad(const aElement: IwbElement);
var
  Container   : IwbContainerElementRef;
  MainRecord  : IwbMainRecord;
  Points      : IwbContainerElementRef;
  Connections : IwbContainerElementRef;
  i, j        : Integer;
  Point       : IwbContainerElementRef;
  Connection  : IwbContainerElementRef;
  Removed     : Boolean;
  FirstRemoved: Boolean;
begin
  if wbBeginInternalEdit then try
    if not wbTryGetContainerWithValidMainRecord(aElement, Container, MainRecord) then
      Exit;

    if not Supports(Container.ElementBySignature['PGRP'], IwbContainerElementRef, Points) then
      Exit;

    if not Container.ElementExists['PGAG'] then
      Container.Add('PGAG').DataSize := (Points.ElementCount + 7) div 8;

    MainRecord.IsCompressed := True;

    if not Supports(Container.ElementBySignature['PGRR'], IwbContainerElementRef, Connections) then
      Exit;

    if Points.ElementCount < Connections.ElementCount then
      Exit;

    FirstRemoved := False;
    for i := Pred(Connections.ElementCount) downto 0 do begin
      Connection := Connections.Elements[i] as IwbContainerElementRef;

      Removed := False;
      j := Connection.ElementCount;
      while j > 0 do begin
        Dec(j);
        if Connection.Elements[j].NativeValue = 65535 then begin
          if not FirstRemoved then begin
            FirstRemoved := True;
            Connections.MarkModifiedRecursive(AllElementTypes);
          end;
          Connection.Elements[j].Remove;
          Removed := True;
        end else
          Break;
      end;

      if Removed then begin
        Point := Points.Elements[i] as IwbContainerElementRef;
        Point.ElementNativeValues['Connections'] := Connection.ElementCount;
      end;

    end;

  finally
    wbEndInternalEdit;
  end;
end;

procedure wbPGRIPointerAfterLoad(const aElement: IwbElement);
var
  Connections : IwbContainerElementRef;
  i, j        : Integer;
  s           : string;
  Keys        : TStringList;
begin
  if wbBeginInternalEdit then try
    if not Supports(aElement, IwbContainerElementRef, Connections) then
      Exit;

    Keys := TStringList.Create;
    try
      Keys.Sorted := True;
      Keys.Duplicates := dupError;
      for i := Pred(Connections.ElementCount) downto 0 do begin
        s := Connections.Elements[i].SortKey[True];
        if Keys.Find(s, j) then
          Connections.RemoveElement(i, True)
        else
          Keys.Add(s);
      end;
    finally
      Keys.Free;
    end;
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbPGRRPointAfterLoad(const aElement: IwbElement);
var
  Connections : IwbContainerElementRef;
  i           : Integer;
//  Index       : Integer;
begin
  if wbBeginInternalEdit then try
    if not Supports(aElement, IwbContainerElementRef, Connections) then
      Exit;
    for i := Pred(Connections.ElementCount) downto 0 do
      if Connections.Elements[i].NativeValue = 65535 then begin
        Connections.RemoveElement(i);
      end;
{    if Removed then begin
      Index := aElement.Container.ElementCount;
      (aElement.ContainingMainRecord.RecordBySignature['PGRP'].Elements[Index] as IwbContainer).Elements[3].NativeValue := Connections.ElementCount;
    end;}
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbREFRAfterLoad(const aElement: IwbElement);
var
  Container: IwbContainerElementRef;
begin
  if wbBeginInternalEdit then try
    if not Supports(aElement, IwbContainerElementRef, Container) then
      Exit;
    if Container.ElementCount < 1 then
      Exit;

    Container.RemoveElement('XPCI');
  finally
    wbEndInternalEdit;
  end;
end;

function wbREFRXSEDDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container : IwbContainer;
  SubRecord : IwbSubRecord;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  if Supports(Container, IwbSubRecord, SubRecord) then
    if SubRecord.SubRecordHeaderSize = 4 then
      Result := 1;
end;

function wbXLOCFillerDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container : IwbContainer;
  SubRecord : IwbSubRecord;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  if Supports(Container, IwbSubRecord, SubRecord) then
    if SubRecord.SubRecordHeaderSize = 16 then
      Result := 1;
end;

procedure DefineTES4;
begin
  DefineCommon;

  wbRecordFlags := wbInteger('Record Flags', itU32, wbFlags(wbFlagsList([])));

  wbMainRecordHeader := wbStruct('Record Header', [
    wbString('Signature', 4, cpCritical),
    wbInteger('Data Size', itU32, nil, cpIgnore),
    wbRecordFlags,
    wbFormID('FormID', cpFormID).IncludeFlag(dfSummarySelfAsShortName),
    wbByteArray('Version Control Info', 4, cpIgnore).SetToStr(wbVCI1ToStrBeforeFO4)
  ]).SetSummaryKey([3, 2])
    .SetSummaryMemberPrefixSuffix(2, '{', '}')
    .IncludeFlag(dfSummaryMembersNoName)
    .IncludeFlag(dfCollapsed, wbCollapseRecordHeader);

  wbSizeOfMainRecordStruct := 20;

  wbIgnoreRecords.Add(XXXX);

{>>> Enums <<<}

  wbActorValueEnum :=
    wbEnum([
      {0}  'Strength',
      {1}  'Intelligence',
      {2}  'Willpower',
      {3}  'Agility',
      {4}  'Speed',
      {5}  'Endurance',
      {6}  'Personality',
      {7}  'Luck',
      {8}  'Health',
      {9}  'Magicka',
      {10} 'Fatigue',
      {11} 'Encumbrance',
      {12} 'Armorer',
      {13} 'Athletics',
      {14} 'Blade',
      {15} 'Block',
      {16} 'Blunt',
      {17} 'Hand To Hand',
      {18} 'Heavy Armor',
      {19} 'Alchemy',
      {20} 'Alteration',
      {21} 'Conjuration',
      {22} 'Destruction',
      {23} 'Illusion',
      {24} 'Mysticism',
      {25} 'Restoration',
      {26} 'Acrobatics',
      {27} 'Light Armor',
      {28} 'Marksman',
      {29} 'Mercantile',
      {30} 'Security',
      {31} 'Sneak',
      {32} 'Speechcraft',
      {33} 'Aggression',
      {34} 'Confidence',
      {35} 'Energy',
      {36} 'Responsibility',
      {37} 'Bounty',
      {38} 'Fame',
      {39} 'Infamy',
      {40} 'Magicka Multiplier',
      {41} 'Night Eye Bonus',
      {42} 'Attack Bonus',
      {43} 'Defend Bonus',
      {44} 'Casting Penalty',
      {45} 'Blindness',
      {46} 'Chameleon',
      {47} 'Invisibility',
      {48} 'Paralysis',
      {49} 'Silence',
      {50} 'Confusion',
      {51} 'Detect Item Range',
      {52} 'Spell Absorb Chance',
      {53} 'Spell Reflect Chance',
      {54} 'Swim Speed Multiplier',
      {55} 'Water Breathing',
      {56} 'Water Walking',
      {57} 'Stunted Magicka',
      {58} 'Detect Life Range',
      {59} 'Reflect Damage',
      {60} 'Telekinesis',
      {61} 'Resist Fire',
      {62} 'Resist Frost',
      {63} 'Resist Disease',
      {64} 'Resist Magic',
      {65} 'Resist Normal Weapons',
      {66} 'Resist Paralysis',
      {67} 'Resist Poison',
      {68} 'Resist Shock',
      {69} 'Vampirism',
      {70} 'Darkness',
      {71} 'Resist Water Damage'
    ], [
      255, 'None'
    ]);

  wbAttributeEnum :=
    wbEnum([
      {0} 'Strength',
      {1} 'Intelligence',
      {2} 'Willpower',
      {3} 'Agility',
      {4} 'Speed',
      {5} 'Endurance',
      {6} 'Personality',
      {7} 'Luck'
    ]);

  wbDialogueTypeEnum :=
    wbEnum([
      {0} 'Topic',
      {1} 'Conversation',
      {2} 'Combat',
      {3} 'Persuasion',
      {4} 'Detection',
      {5} 'Service',
      {6} 'Miscellaneous'
    ]);

  wbFormTypeEnum :=
    wbEnum([], [
      10, 'Sound',
      14, 'Land Texture',
      15, 'Enchantment',
      16, 'Spell',
      18, 'Activator',
      19, 'Apparatus',
      20, 'Armor',
      21, 'Book',
      22, 'Clothing',
      23, 'Container',
      24, 'Door',
      25, 'Ingredient',
      26, 'Light',
      27, 'Misc Item',
      28, 'Static',
      29, 'Grass',
      30, 'Tree',
      31, 'Flora',
      32, 'Furniture',
      33, 'Weapon',
      34, 'Ammo',
      35, 'NPC',
      36, 'Creature',
      37, 'Leveled Creature',
      38, 'Soul Gem',
      39, 'Key',
      40, 'Potion',
      41, 'Sub Space',
      42, 'Sigil Stone',
      43, 'Leveled Item',
      62, 'Combat Style',
      63, 'Load Screen',
      64, 'Leveled Spell',
      65, 'Anim Object',
      66, 'Water Type',
      67, 'Effect Shader'
    ]);

  wbHeadPartIndexEnum :=
    wbEnum([
      {0} 'Head',
      {1} 'Ear (Male)',
      {2} 'Ear (Female)',
      {3} 'Mouth',
      {4} 'Teeth (Lower)',
      {5} 'Teeth (Upper)',
      {6} 'Tongue',
      {7} 'Eye (Left)',
      {8} 'Eye (Right)'
    ]);

  wbMagicSchoolEnum :=
    wbEnum([
      {0} 'Alteration',
      {1} 'Conjuration',
      {2} 'Destruction',
      {3} 'Illusion',
      {4} 'Mysticism',
      {5} 'Restoration'
    ]);

  wbMajorSkillEnum :=
    wbEnum([], [
      12,  'Armoer',
      13,  'Athletics',
      14,  'Blade',
      15,  'Block',
      16,  'Blunt',
      17,  'Hand To Hand',
      18,  'Heavy Armor',
      19,  'Alchemy',
      20,  'Alteration',
      21,  'Conjuration',
      22,  'Destruction',
      23,  'Illusion',
      24,  'Mysticism',
      25,  'Restoration',
      26,  'Acrobatics',
      27,  'Light Armor',
      28,  'Marksman',
      29,  'Mercantile',
      30,  'Security',
      31,  'Sneak',
      32,  'Speechcraft',
      255, 'None'
    ]);

  wbOBMEResolutionEnum :=
    wbEnum([
      {0} 'None',
      {1} 'FormID',
      {2} 'Magic Effect Code',
      {3} 'Actor Value'
    ]);

  wbResistEnum :=
    wbEnum([], [
      61,  'Resist Fire',
      62,  'Resist Frost',
      63,  'Resist Disease',
      64,  'Resist Magic',
      65,  'Resist Normal Weapons',
      66,  'Resist Paralysis',
      67,  'Resist Poison',
      68,  'Resist Shock',
      255, 'None'
    ]);

  wbSkillEnum :=
    wbEnum([
      {0}   'Armorer',
      {1}   'Athletics',
      {2}   'Blade',
      {3}   'Block',
      {4}   'Blunt',
      {5}   'Hand To Hand',
      {6}   'Heavy Armor',
      {7}   'Alchemy',
      {8}   'Alteration',
      {9}   'Conjuration',
      {10}  'Destruction',
      {11}  'Illusion',
      {12}  'Mysticism',
      {13}  'Restoration',
      {14}  'Acrobatics',
      {15}  'Light Armor',
      {16}  'Marksman',
      {17}  'Mercantile',
      {18}  'Security',
      {19}  'Sneak',
      {20}  'Speechcraft'
    ], [
      255, 'None'
    ]);

  wbSpecializationEnum :=
    wbEnum([
      {0} 'Combat',
      {1} 'Magic',
      {2} 'Stealth'
    ]);

{>>> Flags <<<}

  wbBipedFlags :=
    wbFlags([
      {0}  'Head',
      {1}  'Hair',
      {2}  'Upper Body',
      {3}  'Lower Body',
      {4}  'Hand',
      {5}  'Foot',
      {6}  'Right Ring',
      {7}  'Left Ring',
      {8}  'Amulet',
      {9}  'Weapon',
      {10} 'Back Weapon',
      {11} 'Side Weapon',
      {12} 'Quiver',
      {13} 'Shield',
      {14} 'Torch',
      {15} 'Tail'
    ]);

{>>> Common Defs <<<}

  wbDESC := wbStringKC(DESC, 'Description', 0, cpTranslate);
  wbEDID := wbString(EDID, 'Editor ID', 0, cpNormal); // not cpBenign according to Arthmoor
  wbFULL := wbStringKC(FULL, 'Name', 0, cpTranslate);
  wbFULLReq := wbStringKC(FULL, 'Name', 0, cpTranslate).SetRequired;
  wbICON := wbString(ICON, 'Icon FileName');
  wbSCRI := wbFormIDCk(SCRI, 'Script', [SCPT]);
  wbSPLO := wbFormIDCkST(SPLO, 'Spell', [LVSP, SPEL]);
  wbSPLOs := wbRArrayS('Spells', wbSPLO);
  wbXSCL := wbFloat(XSCL, 'Scale');

{>>> Struct Members <<<}

  wbConditionParameters := [
    wbUnknown(4),
    wbByteArray('None', 4, cpIgnore).IncludeFlag(dfZeroSortKey),
    wbInteger('Integer', itS32),
    wbInteger('Quest Stage', itS32, wbCTDAParam2QuestStageToStr, wbCTDAParam2QuestStageToInt),
    wbInteger('Variable Name', itS32, wbCTDAParam2VariableNameToStr, wbCTDAParam2VariableNameToInt),

	  wbFormIDCk('Actor Value', [ACVA]),
	  wbInteger('Axis', itU32, wbAxisEnum),
   	wbInteger('Crime Type', itU32, wbCrimeTypeEnum),
    wbInteger('Form Type', itU32, wbFormTypeEnum),
    wbInteger('Sex', itU32, wbSexEnum),

   	wbFormIDCkNoReach('Actor', [ACHR, ACRE, PLYR, TRGT]),
    wbFormIDCkNoReach('Actor Base', [CREA, NPC_]),
    wbFormIDCkNoReach('Base Object', [ACTI, ALCH, AMMO, APPA, ARMO, BOOK, CLOT, CONT, CREA, DOOR, FLOR, FURN, GRAS, INGR, KEYM, LIGH, LVLC, MISC, NPC_, SBSP, SGST, SLGM, SOUN, STAT, TREE, WEAP]),
    wbFormIDCkNoReach('Birthsign', [BSGN]),
    wbFormIDCkNoReach('Cell', [CELL]),
    wbFormIDCkNoReach('Class', [CLAS]),
    wbFormIDCkNoReach('Faction', [FACT]),
    wbFormIDCkNoReach('Furniture', [FURN]),
    wbFormIDCkNoReach('Global', [GLOB]),
    wbFormIDCkNoReach('Inventory Object', [ALCH, AMMO, APPA, ARMO, BOOK, CLOT, INGR, KEYM, LIGH, MISC, SGST, SLGM, WEAP]),
    wbFormIDCkNoReach('Magic Effect', [MGEF]),
    wbFormIDCkNoReach('Owner', [FACT, NPC_]),
    wbFormIDCkNoReach('Package', [PACK]),
    wbFormIDCkNoReach('Quest', [QUST]),
    wbFormIDCkNoReach('Race', [RACE]),
    wbFormIDCkNoReach('Reference', [ACHR, ACRE, PLYR, REFR, TRGT]),
    wbFormIDCkNoReach('Spell', [SPEL]),
    wbFormIDCkNoReach('Weather', [WTHR]),
    wbFormIDCkNoReach('Worldspace', [WRLD])
  ];

  wbConditionMembers := [
    wbInteger('Type', itU8, wbConditionTypeToStr, wbConditionTypeToInt).SetAfterSet(wbConditionTypeAfterSet),
    wbUnused(3),
    wbUnion('Comparison Value', wbConditionCompValueDecider, [
      wbFloat('Comparison Value - Float'),
      wbFormIDCk('Comparison Value - Global', [GLOB])
    ]),
    wbInteger('Function', itU16, wbCTDAFunctionToStr, wbCTDAFunctionToInt),
    wbUnused(2),
    wbUnion('Parameter #1', wbCTDAParam1Decider, wbConditionParameters),
    wbUnion('Parameter #2', wbCTDAParam2Decider, wbConditionParameters),
    wbUnused(0)
  ];

  wbSoundDataMembers := [
    wbInteger('Minimum attenuation distance', itU8, wbMul(5)),
    wbInteger('Maximum attenuation distance', itU8, wbMul(100)),
    wbInteger('Frequency adjustment %', itS8),
    wbUnused(1),
    wbInteger('Flags', itU16,
      wbFlags([
        {0} 'Random Frequency Shift',
        {1} 'Play At Random',
        {2} 'Environment Ignored',
        {3} 'Random Location',
        {4} 'Loop',
        {5} 'Menu Sound',
        {6} '2D',
        {7} '360 LFE'
      ])
    ).IncludeFlag(dfCollapsed, wbCollapseFlags),
    wbUnused(2),
    wbInteger('Static Attenuation (db)', itU16, wbDiv(100)),
    wbInteger('Stop time', itU8),
    wbInteger('Start time', itU8)
  ];

{>>> Common Record Members <<<}

  wbBodyParts :=
    wbRArrayS('Parts',
      wbRStructSK([0], 'Part', [
        wbInteger(INDX, 'Index', itU32, wbBodyPartIndexEnum),
        wbICON
      ]).SetSummaryKey([0, 1])
        .SetSummaryMemberPrefixSuffix(0, '[', ']')
        .SetSummaryMemberPrefixSuffix(1, 'ICON: ', '')
        .SetSummaryDelimiter(' ')
        .IncludeFlag(dfSummaryMembersNoName)
        .IncludeFlag(dfSummaryNoSortKey)
        .IncludeFlag(dfCollapsed, wbCollapseBodyParts)
    );

  wbCNTOS :=
    wbRArrayS('Items',
      wbStructSK(CNTO, [0], 'Item', [
        wbFormIDCk('Item', [ALCH, AMMO, APPA, ARMO, BOOK, CLOT, INGR, KEYM, LIGH, LVLI, MISC, SGST, SLGM, WEAP]),
        wbInteger('Count', itS32).SetDefaultNativeValue(1)
      ]).SetToStr(wbItemToStr)
        .IncludeFlag(dfCollapsed, wbCollapseItems)
    );

  wbConditions :=
    wbRArray('Conditions',
      wbRUnion('Condition', [
        wbStructSK(CTDA, [3, 5, 6], 'Condition', wbConditionMembers, cpNormal, False, nil, 7)
          .SetToStr(wbConditionToStr)
          .IncludeFlag(dfCollapsed, wbCollapseConditions),
        wbStructSK(CTDT, [3, 5, 6], 'Condition', wbConditionMembers, cpNormal, False, nil, 7)
          .SetToStr(wbConditionToStr)
          .IncludeFlag(dfCollapsed, wbCollapseConditions)
      ])
    );

  wbFaceGen :=
    wbRStruct('FaceGen Data', [
      wbByteArray(FGGS, 'FaceGen Geometry-Symmetric').SetRequired,
      wbByteArray(FGGA, 'FaceGen Geometry-Asymmetric').SetRequired,
      wbByteArray(FGTS, 'FaceGen Texture-Symmetric').SetRequired
    ]).SetRequired;

  wbOBMEVersion :=
    wbStruct('OBME Version', [
      wbInteger('Beta', itU8),
      wbInteger('Minor', itU8),
      wbInteger('Major', itU8)
    ]);

  wbPGRP :=
    wbArray(PGRP, 'Points',
      wbStruct('Point', [
        wbFloat('X'),
        wbFloat('Y'),
        wbFloat('Z (Even = Red/Orange, Odd = Blue)'),
        wbInteger('Connections', itU8),
        wbUnused(3)
      ])
    ).SetCountPathOnValue('DATA', False)
     .SetRequired
     .IncludeFlag(dfNotAlignable);

  wbSCHR :=
    wbRUnion('Basic Script Data', [
      wbStruct(SCHR, 'Basic Script Data', [
        wbUnused(4),
        wbInteger('RefCount', itU32),
        wbInteger('CompiledSize', itU32),
        wbInteger('VariableCount', itU32),
        wbInteger('Type', itU32,
          wbEnum([
            {0} 'Object',
            {1} 'Quest'
          ], [
            $100, 'Magic Effect'
          ])
        )
      ]).SetSummaryKeyOnValue([4, 2, 1, 3])
        .SetSummaryPrefixSuffixOnValue(4, '', '')
        .SetSummaryPrefixSuffixOnValue(2, '{CompiledSize = ', ',')
        .SetSummaryPrefixSuffixOnValue(1, 'RefCount = ', ',')
        .SetSummaryPrefixSuffixOnValue(3, 'VariableCount = ', '}')
        .IncludeFlagOnValue(dfSummaryMembersNoName)
        .IncludeFlag(dfCollapsed, wbCollapseScriptData),
      wbStruct(SCHD, 'Basic Script Data', [
        wbUnused(4),
        wbInteger('RefCount', itU32),
        wbInteger('CompiledSize', itU32),
        wbInteger('VariableCount', itU32),
        wbInteger('Type', itU32,
          wbEnum([
            {0} 'Object',
            {1} 'Quest'
          ], [
            $100, 'Magic Effect'
          ])
        ),
        wbByteArray('Unknown')
      ]).SetSummaryKeyOnValue([4, 2, 1, 3])
        .SetSummaryPrefixSuffixOnValue(4, '', '')
        .SetSummaryPrefixSuffixOnValue(2, '{CompiledSize = ', ', ')
        .SetSummaryPrefixSuffixOnValue(1, 'RefCount = ', ', ')
        .SetSummaryPrefixSuffixOnValue(3, 'VariableCount = ', '}')
        .IncludeFlagOnValue(dfSummaryMembersNoName)
        .IncludeFlag(dfCollapsed, wbCollapseScriptData)
    ]);

  wbEffects :=
    wbRArray('Effects',
      wbRUnion('Effects', [
        wbRStructSK([0, 1], 'Effect', [
          wbInteger(EFID, 'Magic Effect Name', itU32, wbChar4).SetRequired,
          wbStructSK(EFIT, [4, 5], '', [
            wbInteger('Magic Effect Name', itU32, wbChar4),
            wbInteger('Magnitude', itU32),
            wbInteger('Area', itU32),
            wbInteger('Duration', itU32),
            wbInteger('Type', itU32,
              wbEnum([
                {0} 'Self',
                {1} 'Touch',
                {2} 'Target'
              ])
            ),
            wbInteger('Actor Value', itU32, wbActorValueEnum)
          ]).SetAfterLoad(wbEFITAfterLoad)
            .SetRequired,
          wbRStructSK([0], 'Script Effect', [
            wbStructSK(SCIT, [0], 'Script Effect Data', [
              wbFormIDCk('Script effect', [SCPT, NULL]),
              wbInteger('Magic school', itU32, wbMagicSchoolEnum),
              wbInteger('Visual effect name', itU32, wbChar4),
              wbInteger('Hostile', itU8, wbBoolEnum),
              wbUnused(3)
            ], cpNormal, True, nil, 1),
            wbFULLReq
          ])
        ]),
        wbRStruct('Effects', [
          wbRArray('Effects',
            wbRStruct('Effect', [
              wbStruct(EFME, 'Oblivion Magic Extender', [
                wbInteger('Record Version', itU8),
                wbOBMEVersion,
                wbInteger('EFIT Param Info', itU8, wbOBMEResolutionEnum),
                wbInteger('EFIX Param Info', itU8, wbOBMEResolutionEnum),
                wbUnused($0A)
              ]),
              wbStringMgefCode(EFID, 'Magic Effect Code', 4).SetRequired,
              wbStructSK(EFIT, [4, 5], '', [
                wbStringMgefCode('Magic Effect Code', 4),
                wbInteger('Magnitude', itU32),
                wbInteger('Area', itU32),
                wbInteger('Duration', itU32),
                wbInteger('Type', itU32,
                  wbEnum([
                    {0} 'Self',
                    {1} 'Touch',
                    {2} 'Target'
                  ])
                ),
                wbUnion('Param #1', wbEFITOBMEParamDecider, [
                  wbByteArray('Param #1 - Unknown Type', 4),
                  wbFormID('Param #1 - FormID'),
                  wbStringMgefCode('Param #1 - Magic Effect Code', 4),
                  wbFormIDCk('Param #1 - Actor Value', [ACVA])
                ])
              ]).SetRequired,
              wbRStructSK([0], 'Script Effect', [
                wbStructSK(SCIT, [0], 'Script Effect Data', [
                  wbFormIDCk('Script effect', [SCPT, NULL]),
                  wbInteger('Magic school', itU32, wbMagicSchoolEnum),
                  wbStringMgefCode('Visual Effect Code', 4),
                  wbInteger('Hostile', itU8, wbBoolEnum),
                  wbUnused(3)
                ], cpNormal, True, nil, 1),
                wbFULLReq
              ]),
              wbString(EFII, 'Icon'),
              wbStructSK(EFIX, [3], '', [
                wbInteger('Override Mask', itU32, wbFlags([])),
                wbInteger('Flags', itU32, wbFlags([])),
                wbFloat('Base Cost'),
                wbUnion('Param #2', wbEFIXParamDecider, [
                  wbByteArray('Param #2 - Unknown Type', 4),
                  wbFormID('Param #2 - FormID'),
                  wbStringMgefCode('Param #2 - Magic Effect Code', 4),
                  wbFormIDCk('Param #2 - Actor Value', [ACVA])
                ]),
                wbUnknown
              ]).SetAfterLoad(wbEFITAfterLoad)
                .SetRequired
            ])
          ),
          wbEmpty(EFXX, 'Effects End Marker').SetRequired,
          wbFULLReq
        ])
      ])
    );

  wbSCROs :=
    wbRArray('References',
      wbRUnion('', [
        wbFormID(SCRO, 'Global Reference'),
        wbInteger(SCRV, 'Local Variable', itU32)
      ])
    ).IncludeFlag(dfNotAlignable);

  wbResultScript := wbRStruct('Result Script', [
    wbSCHR,
    wbByteArray(SCDA, 'Compiled result script'),
    wbStringScript(SCTX, 'Result script source'),
    wbSCROs
  ]).SetToStr(wbScriptToStr);

  wbSLSD := wbStructSK(SLSD, [0], 'Local Variable Data', [
    wbInteger('Index', itU32),
    wbUnused(12),
    wbInteger('IsLongOrShort', itU8, wbBoolEnum, cpCritical),
    wbByteArray('Unused')
  ]).IncludeFlag(dfSummaryMembersNoName);

  wbXESP := wbStruct(XESP, 'Enable Parent', [
    wbFormIDCk('Reference', [ACHR, ACRE, PLYR, REFR]),
    wbInteger('Set Enable State To Opposite Of Parent', itU8, wbBoolEnum),
    wbUnused(3)
  ]);

{>>> Record Defs <<<}

  wbRecord(TES4, 'Main File Header',
    wbFlags(wbFlagsList([
      0, 'ESM'
    ])), [
    wbHEDR,
    wbByteArray(OFST, 'Unknown', 0, cpIgnore),
    wbByteArray(DELE, 'Unknown', 0, cpIgnore),
    wbString(CNAM, 'Author', 0, cpTranslate).SetRequired,
    wbString(SNAM, 'Description', 0, cpTranslate),
    wbRArray('Master Files',
      wbRStruct('Master File', [
        wbStringForward(MAST, 'FileName').SetRequired,
        wbUnused(DATA, 8).SetRequired
      ])
    ).IncludeFlag(dfInternalEditOnly, not wbAllowMasterFilesEdit)
  ], False, nil, cpNormal, True);

  wbRefRecord(ACHR, 'Placed NPC',
    wbFlags(wbFlagsList([
      10, 'Persistent',
      11, 'Initially Disabled',
      15, 'Visible When Distant'
    ])), [
    wbEDID,
    wbFormIDCk(NAME, 'Base', [NPC_]).SetRequired,
    wbRStruct('Unused', [
      wbFormIDCk(XPCI, 'Unused', [CELL]),
      wbString(FULL, 'Unused')
    ]),
    wbXLOD,
    wbXESP,
    wbFormIDCk(XMRC, 'Merchant container', [REFR], True),
    wbFormIDCk(XHRS, 'Horse', [ACRE], True),
    wbRagdoll,
    wbXSCL,
    wbDATAPosRot
  ], True)
    .SetAddInfo(wbPlacedAddInfo)
    .SetAfterLoad(wbREFRAfterLoad);

  wbRefRecord(ACRE, 'Placed Creature',
    wbFlags(wbFlagsList([
      10, 'Persistent',
      11, 'Initially Disabled',
      15, 'Visible When Distant'
    ])), [
    wbEDID,
    wbFormIDCk(NAME, 'Base', [CREA]).SetRequired,
    wbOwnership,
    wbRagdoll,
    wbXLOD,
    wbXESP,
    wbXSCL,
    wbDATAPosRot
  ], True).SetAddInfo(wbPlacedAddInfo);

  wbRecord(ACTI, 'Activator',
    wbFlags(wbFlagsList([
      10, 'Quest Item',
      17, 'Dangerous'
    ])), [
    wbEDID,
    wbFULL,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbSCRI,
    wbFormIDCk(SNAM, 'Sound', [SOUN])
  ]);

  wbRecord(ALCH, 'Potion',
    wbFlags(wbFlagsList([
      10, 'Quest Item'
    ])), [
    wbEDID,
    wbStruct(OBME, 'Oblivion Magic Extender', [
      wbInteger('Record Version', itU8),
      wbOBMEVersion,
      wbUnused($1C)
    ]).SetDontShow(wbOBMEDontShow),
    wbFULL,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbICON,
    wbSCRI,
    wbFloat(DATA, 'Weight').SetRequired,
    wbStruct(ENIT, '', [
      wbInteger('Value', itS32),
      wbInteger('Flags', itU8,
        wbFlags([
          {0} 'No auto-calculation',
          {1} 'Food item'
        ])
      ).IncludeFlag(dfCollapsed, wbCollapseFlags),
      wbUnused(3)
    ]).SetRequired,
    wbEffects
  ]);

  wbRecord(AMMO, 'Ammunition',
    wbFlags(wbFlagsList([
      10, 'Quest Item'
    ])), [
    wbEDID,
    wbFULL,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbICON,
    wbEnchantment(True),
    wbStruct(DATA, '', [
      wbFloat('Speed'),
      wbInteger('Ignores Normal Weapon Resistance', itU8, wbBoolEnum),
      wbUnused(3),
      wbInteger('Value', itU32),
      wbFloat('Weight'),
      wbInteger('Damage', itU16)
    ]).SetRequired
  ]);

  wbRecord(ANIO, 'Animated Object', [
    wbEDID,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbFormIDCk(DATA, 'IDLE animation', [IDLE]).SetRequired
  ]).SetSummaryKey([1, 2])
    .IncludeFlag(dfSummaryMembersNoName);

  wbRecord(APPA, 'Alchemical Apparatus', [
    wbEDID,
    wbFULL,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbICON,
    wbSCRI,
    wbStruct(DATA, '', [
      wbInteger('Type', itU8,
        wbEnum([
          {0} 'Mortar and Pestle',
          {1} 'Alembic',
          {2} 'Calcinator',
          {3} 'Retort'
        ])
      ),
      wbInteger('Value', itU32),
      wbFloat('Weight'),
      wbFloat('Quality')
    ]).SetRequired
  ]);

  wbRecord(ARMO, 'Armor',
    wbFlags(wbFlagsList([
      10, 'Quest Item'
    ])), [
    wbEDID,
    wbFULL,
    wbSCRI,
    wbEnchantment(True),
    wbStruct(BMDT, '', [
      wbInteger('Biped Flags', itU16, wbBipedFlags).IncludeFlag(dfCollapsed, wbCollapseFlags),
      wbInteger('General Flags', itU8,
        wbFlags(wbSparseFlags([
          0, 'Hide Rings',
          1, 'Hide Amulets',
          6, 'Non-Playable',
          7, 'Heavy armor'
        ], False, 8))
      ).IncludeFlag(dfCollapsed, wbCollapseFlags),
      wbUnused(1)
    ]).SetRequired,
    wbTexturedModel('Male Biped Model', [MODL, MODB, MODT], []),
    wbTexturedModel('Male World Model', [MOD2, MO2B, MO2T], []),
    wbString(ICON, 'Male Icon Filename'),
    wbTexturedModel('Female Biped Model', [MOD3, MO3B, MO3T], []),
    wbTexturedModel('Female World Model', [MOD4, MO4B, MO4T], []),
    wbString(ICO2, 'Female Icon Filename'),
    wbStruct(DATA, '', [
      wbInteger('Armor', itU16, wbDiv(100)),
      wbInteger('Value', itU32),
      wbInteger('Health', itU32),
      wbFloat('Weight')
    ]).SetRequired
  ]);

  wbRecord(BOOK, 'Book',
    wbFlags(wbFlagsList([
      10, 'Quest Item'
    ])), [
    wbEDID,
    wbFULL,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbICON,
    wbSCRI,
    wbEnchantment(True),
    wbDESC,
    wbStruct(DATA, '', [
      wbInteger('Flags', itU8,
        wbFlags([
          {0} 'Scroll',
          {1} 'Can''t be taken'
        ])
      ).IncludeFlag(dfCollapsed, wbCollapseFlags),
      wbInteger('Teaches', itU8, wbSkillEnum),
      wbInteger('Value', itU32),
      wbFloat('Weight')
    ]).SetRequired
  ], True);

  wbRecord(BSGN, 'Birthsign', [
    wbEDID,
    wbFULL,
    wbICON,
    wbDESC,
    wbSPLOs
  ]);

  wbRecord(CELL, 'Cell',
    wbFlags(wbFlagsList([
      10, 'Persistent',
      17, 'Off Limits',
      19, 'Can''t Wait'
    ])), [
    wbEDID,
    wbFULL,
    wbInteger(DATA, 'Flags', itU8,
      wbFlags(wbSparseFlags([
        0, 'Is Interior Cell',
        1, 'Has water',
        2, 'Can''t Travel From Here',
        3, 'Force hide land (exterior cell) / Oblivion interior (interior cell)',
        5, 'Public Area',
        6, 'Hand changed',
        7, 'Behave like exterior'
      ], False, 8))
    ).SetRequired
     .IncludeFlag(dfCollapsed, wbCollapseFlags),
    wbStruct(XCLL, 'Lighting', [
      wbByteColors('Ambient Color'),
      wbByteColors('Directional Color'),
      wbByteColors('Fog Color'),
      wbFloat('Fog Near'),
      wbFloat('Fog Far'),
      wbInteger('Directional Rotation XY', itS32),
      wbInteger('Directional Rotation Z', itS32),
      wbFloat('Directional Fade').SetDefaultNativeValue(1),
      wbFloat('Fog Clip Dist')
    ]).SetDontShow(wbCellLightingDontShow)
      .SetIsRemovable(wbCellLightingIsRemovable),
    wbArrayS(XCLR, 'Regions', wbFormIDCk('Region', [REGN])),
    wbInteger(XCMT, 'Music', itU8, wbMusicEnum),
    wbFloat(XCLW, 'Water Height', cpBenign),
    wbFormIDCk(XCCM, 'Climate', [CLMT]),
    wbFormIDCk(XCWT, 'Water', [WATR]),
    wbOwnership([XCCM, XCLW, XCMT]),
    wbStruct(XCLC, 'Grid', [
      wbInteger('X', itS32),
      wbInteger('Y', itS32)
    ]).SetDontShow(wbCellGridDontShow)
      .SetIsRemovable(wbCellGridIsRemovable)
  ], True)
    .SetAddInfo(wbCellAddInfo)
    .SetAfterLoad(wbCELLAfterLoad);

  wbRecord(CLAS, 'Class', [
    wbEDID,
    wbFULL,
    wbDESC,
    wbICON,
    wbStruct(DATA, '', [
      wbArrayS('Primary Attributes', wbInteger('Primary Attribute', itU32, wbAttributeEnum), 2),
      wbInteger('Specialization', itU32, wbSpecializationEnum),
      wbArrayS('Major Skills', wbInteger('Major Skill', itU32, wbMajorSkillEnum), 7),
      wbInteger('Flags', itU32,
        wbFlags([
          {0} 'Playable',
          {1} 'Guard'
        ])
      ).IncludeFlag(dfCollapsed, wbCollapseFlags),
      wbInteger('Buys/Sells and Services', itU32, wbServiceFlags),
      wbInteger('Teaches', itU8, wbSkillEnum),
      wbInteger('Maximum training level', itU8),
      wbInteger('Unused', itU16)
    ], cpNormal, True, nil, 5)
  ]);

  wbRecord(CLMT, 'Climate', [
    wbEDID,
    wbArrayS(WLST, 'Weather Types',
      wbStructSK([0], 'Weather Type', [
        wbFormIDCk('Weather', [WTHR]),
        wbInteger('Chance', itS32)
      ])
    ),
    wbString(FNAM, 'Sun Texture'),
    wbString(GNAM, 'Sun Glare Texture'),
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbClimateTiming(wbClmtTime, wbClmtMoonsPhaseLength)
  ]);

  wbRecord(CLOT, 'Clothing',
    wbFlags(wbFlagsList([
      10, 'Quest Item'
    ])), [
    wbEDID,
    wbFULL,
    wbSCRI,
    wbEnchantment(True),
    wbStruct(BMDT, '', [
      wbInteger('Biped Flags', itU16, wbBipedFlags).IncludeFlag(dfCollapsed, wbCollapseFlags),
      wbInteger('General Flags', itU8,
        wbFlags(wbSparseFlags([
          0, 'Hide Rings',
          1, 'Hide Amulets',
          6, 'Non-Playable'
        ], False, 7))
      ).IncludeFlag(dfCollapsed, wbCollapseFlags),
      wbUnused(1)
    ]).SetRequired,
    wbTexturedModel('Male biped model', [MODL, MODB, MODT], []),
    wbTexturedModel('Male world model', [MOD2, MO2B, MO2T], []),
    wbString(ICON, 'Male icon FileName'),
    wbTexturedModel('Female biped model', [MOD3, MO3B, MO3T], []),
    wbTexturedModel('Female world model', [MOD4, MO4B, MO4T], []),
    wbString(ICO2, 'Female icon FileName'),
    wbStruct(DATA, '', [
      wbInteger('Value', itU32),
      wbFloat('Weight')
    ]).SetRequired
  ]);

  wbRecord(CONT, 'Container',
    wbFlags(wbFlagsList([
      10, 'Quest Item'
    ])), [
    wbEDID,
    wbFULL,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbSCRI,
    wbCNTOs,
    wbStruct(DATA, '', [
      wbInteger('Flags', itU8,
        wbFlags(wbSparseFlags([
          1, 'Respawns'
        ], False, 2))
      ).IncludeFlag(dfCollapsed, wbCollapseFlags),
      wbFloat('Weight')
    ]).SetRequired,
    wbFormIDCk(SNAM, 'Open sound', [SOUN]),
    wbFormIDCk(QNAM, 'Close sound', [SOUN])
  ]);

  wbRecord(CREA, 'Creature',
    wbFlags(wbFlagsList([
      10, 'Quest Item',
      19, 'Unknown 19'
    ])), [
    wbEDID,
    wbFULL,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbCNTOs,
    wbSPLOs,
    wbArrayS(NIFZ, 'Models', wbStringLC('Model')),
    wbModelInfos(NIFT, 'Model List Textures'),
    wbStruct(ACBS, 'Configuration', [
      wbInteger('Flags', itU32,
        wbFlags(wbSparseFlags([
          0,  'Biped',
          1,  'Essential',
          2,  'Weapon & Shield',
          3,  'Respawn',
          4,  'Swims',
          5,  'Flies',
          6,  'Walks',
          7,  'PC Level Offset',
          9,  'No Low Level Processing',
          11, 'No Blood Spray',
          12, 'No Blood Decal',
          15, 'No Head',
          16, 'No Right Arm',
          17, 'No Left Arm',
          18, 'No Combat in Water',
          19, 'No Shadow',
          20, 'No Corpse Check'
        ], False, 21), True)
      ).IncludeFlag(dfCollapsed, wbCollapseFlags),
      wbInteger('Base spell points', itU16),
      wbInteger('Fatigue', itU16),
      wbInteger('Barter gold', itU16),
      wbInteger('Level (offset)', itS16),
      wbInteger('Calc min', itU16),
      wbInteger('Calc max', itU16)
    ]).SetRequired,
    wbRArrayS('Factions', wbFaction),
    wbFormIDCk(INAM, 'Death item', [LVLI]),
    wbSCRI,
    wbStruct(AIDT, 'AI Data', [
      wbInteger('Aggression', itU8),
      wbInteger('Confidence', itU8),
      wbInteger('Energy Level', itU8),
      wbInteger('Responsibility', itU8),
      wbInteger('Buys/Sells and Services', itU32, wbServiceFlags),
      wbInteger('Teaches', itU8, wbSkillEnum),
      wbInteger('Maximum training level', itU8),
      wbUnused(2)
    ]).SetRequired,
    wbRArray('AI Packages',
      wbFormIDCk(PKID, 'AI Package', [PACK])
    ),
    wbArrayS(KFFZ, 'Animations', wbStringLC('Animation')),
    wbStruct(DATA, 'Creature Data', [
      wbInteger('Type', itU8,
        wbEnum([
          {0} 'Creature',
          {1} 'Daedra',
          {2} 'Undead',
          {3} 'Humanoid',
          {4} 'Horse',
          {5} 'Giant'
        ])
      ),
      wbInteger('Combat Skill', itU8),
      wbInteger('Magic Skill', itU8),
      wbInteger('Stealth Skill', itU8),
      wbInteger('Soul', itU8, wbSoulGemEnum),
      wbUnused(1),
      wbInteger('Health', itU16),
      wbUnused(2),
      wbInteger('Attack Damage', itU16),
      wbInteger('Strength', itU8),
      wbInteger('Intelligence', itU8),
      wbInteger('Willpower', itU8),
      wbInteger('Agility', itU8),
      wbInteger('Speed', itU8),
      wbInteger('Endurance', itU8),
      wbInteger('Personality', itU8),
      wbInteger('Luck', itU8)
    ]).SetRequired,
    wbInteger(RNAM, 'Attack reach', itU8).SetRequired,
    wbFormIDCk(ZNAM, 'Combat Style', [CSTY]),
    wbFloat(TNAM, 'Turning Speed').SetRequired,
    wbFloat(BNAM, 'Base Scale').SetRequired,
    wbFloat(WNAM, 'Foot Weight').SetRequired,
    wbString(NAM0, 'Blood Spray'),
    wbString(NAM1, 'Blood Decal'),
    wbFormIDCk(CSCR, 'Inherits Sounds from', [CREA]),
    wbRArrayS('Sound Types',
      wbRStructSK([0], 'Sound Type', [
        wbInteger(CSDT, 'Type', itU32,
          wbEnum([
            {0} 'Left Foot',
            {1} 'Right Foot',
            {2} 'Left Back Foot',
            {3} 'Right Back Foot',
            {4} 'Idle',
            {5} 'Aware',
            {6} 'Attack',
            {7} 'Hit',
            {8} 'Death',
            {9} 'Weapon'
        ])),
        wbSoundTypeSounds
      ])
    )
  ], True);

  wbRecord(CSTY, 'Combat Style', [
    wbEDID,
    wbStruct(CSTD, 'Standard', [
      wbInteger('Dodge % Chance', itU8),
      wbInteger('Left/Right % Chance', itU8),
      wbUnused(2),
      wbFloat('Dodge L/R Timer (min)'),
      wbFloat('Dodge L/R Timer (max)'),
      wbFloat('Dodge Forward Timer (min)'),
      wbFloat('Dodge Forward Timer (max)'),
      wbFloat('Dodge Back Timer Min'),
      wbFloat('Dodge Back Timer Max'),
      wbFloat('Idle Timer min'),
      wbFloat('Idle Timer max'),
      wbInteger('Block % Chance', itU8),
      wbInteger('Attack % Chance', itU8),
      wbUnused(2),
      wbFloat('Recoil/Stagger Bonus to Attack'),
      wbFloat('Unconscious Bonus to Attack'),
      wbFloat('Hand-To-Hand Bonus to Attack'),
      wbInteger('Power Attack % Chance', itU8),
      wbUnused(3),
      wbFloat('Recoil/Stagger Bonus to Power'),
      wbFloat('Unconscious Bonus to Power Attack'),
      wbInteger('Power Attack - Normal', itU8),
      wbInteger('Power Attack - Forward', itU8),
      wbInteger('Power Attack - Back', itU8),
      wbInteger('Power Attack - Left', itU8),
      wbInteger('Power Attack - Right', itU8),
      wbUnused(3),
      wbFloat('Hold Timer (min)'),
      wbFloat('Hold Timer (max)'),
      wbInteger('Flags', itU8,
        wbFlags([
          {0} 'Advanced',
          {1} 'Choose Attack using % Chance',
          {2} 'Ignore Allies in Area',
          {3} 'Will Yield',
          {4} 'Rejects Yields',
          {5} 'Fleeing Disabled',
          {6} 'Prefers Ranged',
          {7} 'Melee Alert OK'
        ])
      ).IncludeFlag(dfCollapsed, wbCollapseFlags),
      wbInteger('Acrobatic Dodge % Chance', itU8),
      wbUnused(2),
      wbFloat('Range Mult (Optimal)'),
      wbFloat('Range Mult (Max)'),
      wbFloat('Switch Distance (Melee)'),
      wbFloat('Switch Distance (Ranged)'),
      wbFloat('Buff standoff Distance'),
      wbFloat('Ranged standoff Distance'),
      wbFloat('Group standoff Distance'),
      wbInteger('Rushing Attack % Chance', itU8),
      wbUnused(3),
      wbFloat('Rushing Attack Distance Mult'),
      wbInteger('Do Not Acquire', itU32, wbBoolEnum)
    ], cpNormal, True, nil, 31),
    wbStruct(CSAD, 'Advanced', [
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
    ])
  ]);

  wbRecord(DIAL, 'Dialog Topic', [
    wbEDID,
    wbRArrayS('Quests', wbFormIDCkNoReach(QSTI, 'Quest', [QUST], False, cpBenign)),
    wbRArrayS('Quests?', wbFormIDCkNoReach(QSTR, 'Quest?', [QUST], False, cpBenign)),
    wbFULL,
    wbInteger(DATA, 'Type', itU8, wbDialogueTypeEnum).SetRequired,
    wbINOM,
    wbINOA
  ], True);

  wbRecord(DOOR, 'Door',
    wbFlags(wbFlagsList([
      10, 'Quest Item'
    ])), [
    wbEDID,
    wbFULL,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbSCRI,
    wbFormIDCk(SNAM, 'Open sound', [SOUN]),
    wbFormIDCk(ANAM, 'Close sound', [SOUN]),
    wbFormIDCk(BNAM, 'Loop sound', [SOUN]),
    wbInteger(FNAM, 'Flags', itU8,
      wbFlags([
        {0} 'Oblivion gate',
        {1} 'Automatic door',
        {2} 'Hidden',
        {3} 'Minimal use'
      ])
    ).SetRequired,
    wbRArrayS('Random teleport destinations',
      wbFormIDCk(TNAM, 'Destination', [CELL, WRLD])
    )
  ]);

  wbRecord(EFSH, 'Effect Shader', [
    wbEDID,
    wbString(ICON, 'Fill Texture'),
    wbString(ICO2, 'Particle Shader Texture'),
    wbStruct(DATA, '', [
      wbInteger('Flags', itU8,
        wbFlags(wbSparseFlags([
          0, 'No Membrane Shader',
          3, 'No Particle Shader',
          4, 'Edge Effect - Inverse',
          5, 'Membrane Shader - Affect Skin Only'
        ], False, 6))
      ).IncludeFlag(dfCollapsed, wbCollapseFlags),
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
      wbFloat('Color Key 3 - Color Key Time')
    ], cpNormal, True, nil, 25)
  ]);

  wbRecord(ENCH, 'Enchantment', [
    wbEDID,
    wbStruct(OBME, 'Oblivion Magic Extender', [
      wbInteger('Record Version', itU8),
      wbOBMEVersion,
      wbUnused($1C)
    ]).SetDontShow(wbOBMEDontShow),
    wbFULL,
    wbStruct(ENIT, '', [
      wbInteger('Type', itU32,
        wbEnum([
          {0} 'Scroll',
          {1} 'Staff',
          {2} 'Weapon',
          {3} 'Apparel'
        ])
      ),
      wbInteger('Charge Amount', itU32),
      wbInteger('Enchant Cost', itU32),
      wbInteger('No Autocalc Cost', itU8, wbBoolEnum),
      wbUnused(3)
    ]).SetRequired,
    wbEffects
  ]);

  wbRecord(EYES, 'Eyes', [
    wbEDID,
    wbFULL,
    wbString(ICON, 'Texture').SetRequired,
    wbInteger(DATA, 'Playable', itU8, wbBoolEnum).SetRequired
  ]);

  wbRecord(FACT, 'Faction', [
    wbEDID,
    wbFULL,
    wbFactionRelations,
    wbInteger(DATA, 'Flags', itU8,
      wbFlags([
        {0} 'Hidden from Player',
        {1} 'Evil',
        {2} 'Special Combat'
      ])
    ).SetRequired
     .IncludeFlag(dfCollapsed, wbCollapseFlags),
    wbFloat(CNAM, 'Crime Gold Multiplier')
      .SetDefaultNativeValue(1)
      .SetRequired,
    wbRArrayS('Ranks',
      wbRStructSK([0], 'Rank', [
        wbInteger(RNAM, 'Rank#', itS32),
        wbString(MNAM, 'Male', 0, cpTranslate),
        wbString(FNAM, 'Female', 0, cpTranslate),
        wbString(INAM, 'Insignia')
      ])
    )
  ]);

  wbRecord(FLOR, 'Flora', [
    wbEDID,
    wbFULL,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbSCRI,
    wbFormIDCk(PFIG, 'Ingredient', [INGR]),
    wbSeasons
  ]);

  wbRecord(FURN, 'Furniture',
    wbFlags(wbFlagsList([
      10, 'Quest Item'
    ])), [
    wbEDID,
    wbFULL,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbSCRI,
    wbByteArray(MNAM, 'Marker Flags').SetRequired
  ]);

  wbRecord(GLOB, 'Global', [
    wbEDID,
    wbInteger(FNAM, 'Type', itU8,
      wbEnum([], [
        Ord('s'), 'Short',
        Ord('l'), 'Long',
        Ord('f'), 'Float'
      ])
    ).SetDefaultEditValue('Float')
       .SetRequired,
    wbFloat(FLTV, 'Value').SetRequired
  ]).SetSummaryKey([2]);

  wbRecord(GMST, 'Game Setting', [
    wbEDID,
    wbUnion(DATA, 'Value', wbGMSTUnionDecider, [
      wbString('Name', 0, cpTranslate),
      wbInteger('Int', itS32),
      wbFloat('Float')
    ]).SetRequired
  ]).SetSummaryKey([1])
    .IncludeFlag(dfIndexEditorID);

  wbRecord(GRAS, 'Grass', [
    wbEDID,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbStruct(DATA, '', [
      wbInteger('Density', itU8),
      wbInteger('Min Slope', itU8),
      wbInteger('Max Slope', itU8),
      wbUnused(1),
      wbInteger('Unit from water amount', itU16),
      wbUnused(2),
      wbInteger('Unit from water type', itU32,
        wbEnum([
          {0} 'Above - At Least',
          {1} 'Above - At Most',
          {2} 'Below - At Least',
          {3} 'Below - At Most',
          {4} 'Either - At Least',
          {5} 'Either - At Most',
          {6} 'Either - At Most Above',
          {7} 'Either - At Most Below'
        ])
      ),
      wbFloat('Position Range'),
      wbFloat('Height Range'),
      wbFloat('Color Range'),
      wbFloat('Wave Period'),
      wbInteger('Flags', itU8,
        wbFlags([
          {0} 'Vertex Lighting',
          {1} 'Uniform Scaling',
          {2} 'Fit to Slope'
        ])
      ).IncludeFlag(dfCollapsed, wbCollapseFlags),
      wbUnused(3)
    ]).SetRequired
  ]).SetSummaryKey([1]);

  wbRecord(HAIR, 'Hair', [
    wbEDID,
    wbFULL,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbString(ICON, 'Texture').SetRequired,
    wbInteger(DATA, 'Flags', itU8,
      wbFlags([
        {0} 'Playable',
        {1} 'Not Male',
        {2} 'Not Female',
        {3} 'Fixed'
      ])
    ).SetRequired
     .IncludeFlag(dfCollapsed, wbCollapseFlags)
  ]);

  wbRecord(IDLE, 'Idle Animation', [
    wbEDID,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbConditions,
    wbInteger(ANAM, 'Animation Group Section', itU8, wbIdleAnam).SetRequired,
    wbStruct(DATA, 'Animations', [
      wbFormIDCk('Parent', [IDLE, NULL]),
      wbFormIDCk('Previous', [IDLE, NULL])
    ]).SetRequired
  ]).SetSummaryKey([1]);

  wbRecord(INFO, 'Dialog response', [
    wbStruct(DATA, '', [
      wbInteger('Type', itU8, wbDialogueTypeEnum),
      wbNextSpeaker,
      wbInteger('Flags', itU8,
        wbFlags([
          {0} 'Goodbye',
          {1} 'Random',
          {2} 'Say Once',
          {3} 'Run Immediately',
          {4} 'Info Refusal',
          {5} 'Random End',
          {6} 'Run for Rumors'
        ])
      ).IncludeFlag(dfCollapsed, wbCollapseFlags)
    ], cpNormal, True, nil, 2),
    wbFormIDCkNoReach(QSTI, 'Quest', [QUST]).SetRequired,
    wbFormIDCk(TPIC, 'Topic', [DIAL]),
    wbFormIDCkNoReach(PNAM, 'Previous INFO', [INFO, NULL]),
    wbRArray('Add topics',
      wbFormIDCk(NAME, 'Topic', [DIAL])
    ),
    wbRArray('Responses',
      wbRStruct('Response', [
        wbStruct(TRDT, 'Response Data', [
          wbInteger('Emotion Type', itU32,
            wbEnum([
              {0} 'Neutral',
              {1} 'Anger',
              {2} 'Disgust',
              {3} 'Fear',
              {4} 'Sad',
              {5} 'Happy',
              {6} 'Surprise'
            ])
          ),
          wbInteger('Emotion Value', itS32),
          wbUnused(4),
          wbInteger('Response number', itU8),
          wbUnused(3)
        ]),
        wbStringKC(NAM1, 'Response Text', 0, cpTranslate),
        wbString(NAM2, 'Actor notes', 0, cpTranslate)
      ])
    ),
    wbConditions,
    wbRArray('Choices',
      wbFormIDCk(TCLT, 'Choice', [DIAL])
    ),
    wbRArray('Link From',
      wbFormIDCk(TCLF, 'Topic', [DIAL])
    ),
    wbResultScript
  ]).SetAddInfo(wbINFOAddInfo);

  wbRecord(INGR, 'Ingredient',
    wbFlags(wbFlagsList([
      10, 'Quest Item'
    ])), [
    wbEDID,
    wbStruct(OBME, 'Oblivion Magic Extender', [
      wbInteger('Record Version', itU8),
      wbOBMEVersion,
      wbUnused($1C)
    ]).SetDontShow(wbOBMEDontShow),
    wbFULL,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbICON,
    wbSCRI,
    wbFloat(DATA, 'Weight').SetRequired,
    wbStruct(ENIT, 'Data', [
      wbInteger('Value', itS32),
      wbInteger('Flags', itU8,
        wbFlags([
          {0} 'No auto-calculation',
          {1} 'Food item'
        ])
      ).IncludeFlag(dfCollapsed, wbCollapseFlags),
      wbUnused(3)
    ]).SetRequired,
    wbEffects
  ]);

  wbRecord(KEYM, 'Key',
    wbFlags(wbFlagsList([
      10, 'Quest Item'
    ])), [
    wbEDID,
    wbFULL,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbICON,
    wbSCRI,
    wbStruct(DATA, 'Data', [
      wbInteger('Value', itS32),
      wbFloat('Weight')
    ]).SetRequired
  ]);

  wbRecord(LAND, 'Landscape',
    wbFlags(wbFlagsList([
      18, 'Compressed'
    ])), [
    wbInteger(DATA, 'Flags', itU32,
      wbFlags(wbSparseFlags([
        0,  'Has Vertex Normals/Height Map',
        1,  'Has Vertex Colours',
        2,  'Has Layers',
        3,  'Unknown 4',
        4,  'Auto-Calc Normals',
        10, 'Ignored'
      ], False, 11))
    ).IncludeFlag(dfCollapsed, wbCollapseFlags),
    wbLandNormals,
    wbLandHeights,
    wbLandColors,
    wbLandLayers,
    wbArray(VTEX, 'Landscape Textures', wbFormIDCk('Texture', [LTEX, NULL]))
  ]).SetAddInfo(wbLANDAddInfo);

  wbRecord(LIGH, 'Light',
    wbFlags(wbFlagsList([
      10, 'Quest'
    ])), [
    wbEDID,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbSCRI,
    wbFULL,
    wbICON,
    wbStruct(DATA, '', [
      wbInteger('Time', itS32),
      wbInteger('Radius', itU32),
      wbByteColors('Color'),
      wbInteger('Flags', itU32,
        wbFlags([
          {0}  'Dynamic',
          {1}  'Can be Carried',
          {2}  'Negative',
          {3}  'Flicker',
          {4}  'Unused',
          {5}  'Off By Default',
          {6}  'Flicker Slow',
          {7}  'Pulse',
          {8}  'Pulse Slow',
          {9}  'Spot Light',
          {10} 'Spot Shadow'
        ])
      ).IncludeFlag(dfCollapsed, wbCollapseFlags),
      wbFloat('Falloff Exponent').SetDefaultNativeValue(1),
      wbFloat('FOV').SetDefaultNativeValue(90),
      wbInteger('Value', itU32),
      wbFloat('Weight')
    ], cpNormal, True, nil, 6),
    wbFloat(FNAM, 'Fade value')
      .SetDefaultNativeValue(1.0)
      .SetRequired,
    wbFormIDCk(SNAM, 'Sound', [SOUN])
  ]);

  wbRecord(LSCR, 'Load Screen', [
    wbEDID,
    wbICON,
    wbDESC,
    wbRArrayS('Locations',
      wbStructSK(LNAM, [0, 1], 'Location', [
        wbFormIDCkNoReach('Direct', [CELL, WRLD, NULL]),
        wbStructSK([0, 1], 'Indirect', [
          wbFormIDCkNoReach('World', [WRLD, NULL]),
          wbStructSK([0,1], 'Grid', [
            wbInteger('Y', itS16),
            wbInteger('X', itS16)
          ])
        ])
      ])
    )
  ]).SetSummaryKey([2]);

  wbRecord(LTEX, 'Landscape Texture', [
    wbEDID,
    wbICON,
    wbStruct(HNAM, 'Havok Data', [
      wbInteger('Material Type', itU8,
        wbEnum([
          {0}  'Stone',
          {1}  'Cloth',
          {2}  'Dirt',
          {3}  'Glass',
          {4}  'Grass',
          {5}  'Metal',
          {6}  'Organic',
          {7}  'Skin',
          {8}  'Water',
          {9}  'Wood',
          {10} 'Heavy Stone',
          {11} 'Heavy Metal',
          {12} 'Heavy Wood',
          {13} 'Chain',
          {14} 'Snow'
        ])
      ).SetDefaultNativeValue(2),
      wbInteger('Friction', itU8).SetDefaultNativeValue(30),
      wbInteger('Restitution', itU8).SetDefaultNativeValue(30)
    ]).SetRequired,
    wbInteger(SNAM, 'Texture Specular Exponent', itU8).SetDefaultNativeValue(30),
    wbRArrayS('Grasses',
      wbFormIDCk(GNAM, 'Grass', [GRAS])
    )
  ]).SetSummaryKey([1]);

  wbRecord(LVLC, 'Leveled Creature', [
    wbEDID,
    wbInteger(LVLD, 'Chance none', itU8).SetRequired,
    wbInteger(LVLF, 'Flags', itU8,
      wbFlags([
        {0} 'Calculate from all levels <= player''s level',
        {1} 'Calculate for each item in count'
      ])
    ).SetRequired
     .IncludeFlag(dfCollapsed, wbCollapseFlags),
    wbRArrayS('Leveled List Entries',
      wbLeveledListEntry('Creature', [CREA, LVLC, NPC_])
    ).SetRequired,
    wbSCRI,
    wbFormIDCk(TNAM, 'Creature template', [CREA, NPC_])
  ], True)
    .SetSummaryKey([3])
    .SetAfterLoad(wbLVLAfterLoad);

  wbRecord(LVLI, 'Leveled Item', [
    wbEDID,
    wbInteger(LVLD, 'Chance none', itU8).SetRequired,
    wbInteger(LVLF, 'Flags', itU8,
      wbFlags([
        {0} 'Calculate from all levels <= player''s level',
        {1} 'Calculate for each item in count'
      ])
    ).SetRequired
     .IncludeFlag(dfCollapsed, wbCollapseFlags),
    wbRArrayS('Leveled List Entries',
      wbLeveledListEntry('Item', [ALCH, AMMO, APPA, ARMO, BOOK, CLOT, INGR, KEYM, LIGH, LVLI, MISC, SGST, SLGM, WEAP])
    ).SetRequired,
    wbUnused(DATA, 1)
  ]).SetSummaryKey([3])
    .SetAfterLoad(wbLVLAfterLoad);

  wbRecord(LVSP, 'Leveled Spell', [
    wbEDID,
    wbInteger(LVLD, 'Chance none', itU8).SetRequired,
    wbInteger(LVLF, 'Flags', itU8,
      wbFlags([
        {0} 'Calculate from all levels <= player''s level',
        {1} 'Calculate for each item in count',
        {2} 'Use all spells'
      ])
    ).SetRequired
     .IncludeFlag(dfCollapsed, wbCollapseFlags),
    wbRArrayS('Leveled List Entries',
      wbLeveledListEntry('Spell', [LVSP, SPEL])
    ).SetRequired
  ]).SetSummaryKey([3])
    .SetAfterLoad(wbLVLAfterLoad);

  wbRecord(MGEF, 'Magic Effect', [
    wbStringMgefCode(EDID, 'Magic Effect Code'),
    wbStruct(OBME, 'Oblivion Magic Extender', [
      wbInteger('Record Version', itU8),
      wbOBMEVersion,
      wbInteger('Param A Info', itU8, wbOBMEResolutionEnum),
      wbInteger('Param B Info', itU8, wbOBMEResolutionEnum),
      wbUnused(2),
      wbString('Handler', 4),
      wbInteger('Flag Overrides', itU32,
        wbFlags(wbSparseFlags([
          2,  'ParamFlagA',
          3,  'Beneficial',
          16, 'ParamFlagB',
          17, 'Magnitude Is Range',
          18, 'Atomic Resistance',
          19, 'ParamFlagC',
          20, 'ParamFlagD',
          30, 'Hidden'
        ], False, 31))
      ),
      wbByteArray('ParamB', 4),
      wbUnused($1C)
    ]).SetDontShow(wbOBMEDontShow),
    wbString(EDDX, 'EditorID').SetDontShow(wbEDDXDontShow),
    wbFULL,
    wbDESC,
    wbICON,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbStruct(DATA, 'Data', [
      wbInteger('Flags', itU32,
        wbFlags(wbSparseFlags([
          0,  'Hostile',
          1,  'Recover',
          2,  'Detrimental',
          3,  'Magnitude %',
          4,  'Self',
          5,  'Touch',
          6,  'Target',
          7,  'No duration',
          8,  'No magnitude',
          9,  'No area',
          10, 'FX persist',
          11, 'Spellmaking',
          12, 'Enchanting',
          13, 'No Ingredient',
          16, 'Use weapon',
          17, 'Use armor',
          18, 'Use creature',
          19, 'Use skill',
          20, 'Use attribute',
          24, 'Use actor value',
          25, 'Spray projectile type (or Fog if Bolt is specified as well)',
          26, 'Bolt projectile type',
          27, 'No hit effect'
        ], False, 28), True)
      ).IncludeFlag(dfCollapsed, wbCollapseFlags),
      wbFloat('Base cost'),
      wbUnion('Assoc. Item', wbMGEFFAssocItemDecider, [
        wbFormIDCk('Unused', [NULL]),
        wbFormIDCk('Assoc. Weapon', [WEAP]),
        wbFormIDCk('Assoc. Armor', [ARMO, NULL{?}]),
        wbFormIDCk('Assoc. Creature', [CREA, LVLC, NPC_]),
        wbInteger('Assoc. Actor Value', itU32, wbActorValueEnum)
      ]),
      wbInteger('Magic School', itU32, wbMagicSchoolEnum),
      wbInteger('Resist value', itU32, wbResistEnum),
      wbInteger('Counter Effect Count', itU16), //!!! must be updated automatically when ESCE length changes!
      wbUnused(2),
      wbFormIDCk('Light', [LIGH, NULL]),
      wbFloat('Projectile speed'),
      wbFormIDCk('Effect Shader', [EFSH, NULL]),
      wbFormIDCk('Enchant effect', [EFSH, NULL]),
      wbFormIDCk('Casting sound', [SOUN, NULL]),
      wbFormIDCk('Bolt sound', [SOUN, NULL]),
      wbFormIDCk('Hit sound', [SOUN, NULL]),
      wbFormIDCk('Area sound', [SOUN, NULL]),
      wbFloat('Constant Effect enchantment factor'),
      wbFloat('Constant Effect barter factor')
    ], cpNormal, True, nil, 10),
    wbArrayS(ESCE, 'Counter Effects', wbStringMgefCode('Counter Effect Code', 4))
      .SetCountPathOnValue('DATA\Counter Effect Count', False)
  ]).SetAfterLoad(wbMGEFAfterLoad)
    .IncludeFlag(dfIndexEditorID);;

  wbRecord(MISC, 'Misc. Item',
    wbFlags(wbFlagsList([
      10, 'Quest Item'
    ])), [
    wbEDID,
    wbFULL,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbICON,
    wbSCRI,
    wbStruct(DATA, '', [
      wbUnion('', wbMISCActorValueDecider, [
        wbInteger('Value', itS32),
        wbFormIDCk('Actor Value', [ACVA])
      ]),
      wbUnion('', wbMISCActorValueDecider, [
        wbFloat('Weight'),
        wbInteger('Group', itU32,
          wbEnum([], [
            $40E00000, ' [NONE]',
            $40400000, 'AI',
            $00000000, 'Attribute',
            $40C00000, 'Combat',
            $40A00000, 'Misc',
            $40000000, 'Skill',
            $40800000, 'Social',
            $3F800000, 'Stat'
          ])
        )
      ])
    ]).SetRequired
  ]);

  wbRecord(NPC_, 'Non-Player Character',
    wbFlags(wbFlagsList([
      10, 'Quest Item',
      18, 'Compressed',
      19, 'Unknown 19'
    ])), [
    wbEDID,
    wbFULL,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbStruct(ACBS, 'Configuration', [
      wbInteger('Flags', itU32,
        wbFlags(wbSparseFlags([
          0, 'Female',
          1, 'Essential',
          3, 'Respawn',
          4, 'Auto-calc stats',
          7, 'PC Level Offset',
          9, 'No Low Level Processing',
          13, 'No Rumors',
          14, 'Summonable',
          15, 'No Persuasion',
          20, 'Can Corpse Check'
      ], False, 21))),
      wbInteger('Base spell points', itU16),
      wbInteger('Fatigue', itU16),
      wbInteger('Barter gold', itU16),
      wbInteger('Level (offset)', itS16),
      wbInteger('Calc min', itU16),
      wbInteger('Calc max', itU16)
    ]).SetRequired,
    wbRArrayS('Factions', wbFaction),
    wbFormIDCk(INAM, 'Death item', [LVLI]),
    wbFormIDCk(RNAM, 'Race', [RACE]).SetRequired,
    wbSPLOs,
    wbSCRI,
    wbCNTOs,
    wbStruct(AIDT, 'AI Data', [
      wbInteger('Aggression', itU8),
      wbInteger('Confidence', itU8),
      wbInteger('Energy Level', itU8),
      wbInteger('Responsibility', itU8),
      wbInteger('Buys/Sells and Services', itU32, wbServiceFlags),
      wbInteger('Teaches', itU8, wbSkillEnum),
      wbInteger('Maximum training level', itU8),
      wbUnused(2)
    ]).SetRequired,
    wbRArray('AI Packages',
      wbFormIDCk(PKID, 'AI Package', [PACK])
    ),
    wbArrayS(KFFZ, 'Animations', wbString('Animation')),
    wbFormIDCk(CNAM, 'Class', [CLAS]).SetRequired,
    wbStruct(DATA, 'Stats', [
      wbInteger('Armorer', itU8),
      wbInteger('Athletics', itU8),
      wbInteger('Blade', itU8),
      wbInteger('Block', itU8),
      wbInteger('Blunt', itU8),
      wbInteger('Hand to Hand', itU8),
      wbInteger('Heavy Armor', itU8),
      wbInteger('Alchemy', itU8),
      wbInteger('Alteration', itU8),
      wbInteger('Conjuration', itU8),
      wbInteger('Destruction', itU8),
      wbInteger('Illusion', itU8),
      wbInteger('Mysticism', itU8),
      wbInteger('Restoration', itU8),
      wbInteger('Acrobatics', itU8),
      wbInteger('Light Armor', itU8),
      wbInteger('Marksman', itU8),
      wbInteger('Mercantile', itU8),
      wbInteger('Security', itU8),
      wbInteger('Sneak', itU8),
      wbInteger('Speechcraft', itU8),
      wbInteger('Health', itU16),
      wbUnused(2),
      wbInteger('Strength', itU8),
      wbInteger('Intelligence', itU8),
      wbInteger('Willpower', itU8),
      wbInteger('Agility', itU8),
      wbInteger('Speed', itU8),
      wbInteger('Endurance', itU8),
      wbInteger('Personality', itU8),
      wbInteger('Luck', itU8)
    ]).SetRequired,
    wbFormIDCk(HNAM, 'Hair', [HAIR]),
    wbFloat(LNAM, 'Hair length'),
    wbArray(ENAM, 'Eyes', wbFormIDCk('Eyes', [EYES])),
    wbByteColors(HCLR, 'Hair color').SetRequired,
    wbFormIDCk(ZNAM, 'Combat Style', [CSTY]),
    wbFaceGen,
    wbByteArray(FNAM, 'Unknown', 0, cpBenign)
  ], True);

  wbRecord(PACK, 'AI Package',
    wbFlags(wbFlagsList([
      14, 'Unknown 14',
      15, 'Unknown 15'
    ])), [
    wbEDID,
    wbUnion(PKDT, 'General', wbPACKPKDTDecider, [
      wbStruct('', [
        wbInteger('Flags', itU16, wbPackageFlags),
        wbInteger('Type', itU8, wbPackageTypeEnum),
        wbUnused(1)
      ]).SetSummaryKey([1])
        .IncludeFlag(dfSummaryMembersNoName),
      wbStruct('', [
        wbInteger('Flags', itU32, wbPackageFlags),
        wbInteger('Type', itU8, wbPackageTypeEnum),
        wbUnused(3)
      ]).SetSummaryKey([1])
        .IncludeFlag(dfSummaryMembersNoName)
    ]).IncludeFlag(dfSummaryMembersNoName),
    wbStruct(PLDT, 'Location', [
      wbInteger('Type', itU32,
        wbEnum([
          {0} 'Near Reference',
          {1} 'In Cell',
          {2} 'Near Current Location',
          {3} 'Near Editor Location',
          {4} 'Object ID',
          {5} 'Object Type'
        ])
      ),
      wbUnion('Location', wbPxDTLocationDecider, [
        wbFormIDCkNoReach('Reference', [ACHR, ACRE, PLYR, REFR], True),
        wbFormIDCkNoReach('Cell', [CELL]),
        wbFormIDCk('Unused', [NULL]),
        wbFormIDCk('Unused', [NULL]),
        wbFormIDCkNoReach('Object ID', [ACTI, ALCH, AMMO, APPA, ARMO, BOOK, CLOT, CONT, CREA, DOOR, FLOR, FURN, INGR, KEYM, LIGH, MISC, NPC_, SGST, SLGM, SPEL, STAT, WEAP]),
        wbInteger('Object type', itU32)
      ]),
      wbInteger('Radius', itS32)
    ]).SetSummaryKeyOnValue([0, 1])
      .IncludeFlagOnValue(dfSummaryMembersNoName)
      .IncludeFlag(dfSummaryMembersNoName),
    wbStruct(PSDT, 'Schedule', [
      wbInteger('Month', itS8),
      wbInteger('Day of week', itU8,
        wbEnum([
          {0}  'Sundas',
          {1}  'Morndas',
          {2}  'Tirdas',
          {3}  'Middas',
          {4}  'Turdas',
          {5}  'Fredas',
          {6}  'Loredas',
          {7}  'Morndas to Fredas',
          {8}  'Loredas, Sundas',
          {9}  'Morndas, Middas, Fredas',
          {10} 'Tirdas, Turdas'
        ], [
          255, 'Any'
        ])
      ),
      wbInteger('Date', itU8),
      wbInteger('Time', itS8),
      wbInteger('Duration', itS32)
    ]),
    wbStruct(PTDT, 'Target', [
      wbInteger('Type', itU32,
        wbEnum([
          {0} 'Specific Reference',
          {1} 'Object ID',
          {2} 'Object Type'
        ])
      ),
      wbUnion('Target', wbPxDTLocationDecider, [
        wbFormIDCkNoReach('Reference', [ACHR, ACRE, REFR, PLYR], True),
        wbFormIDCkNoReach('Object ID', [ACTI, ALCH, AMMO, APPA, ARMO, BOOK, CLOT, CONT, CREA, DOOR, FLOR, FURN, INGR, KEYM, LIGH, MISC, NPC_, SGST, SLGM, SPEL, STAT, WEAP]),
        wbInteger('Object type', itU32)
      ]),
      wbInteger('Count', itS32)
    ]).SetSummaryKeyOnValue([0, 1])
      .IncludeFlagOnValue(dfSummaryMembersNoName)
      .IncludeFlag(dfSummaryMembersNoName),
    wbConditions
  ]).SetSummaryKey([1, 2, 4, 5])
    .SetSummaryMemberPrefixSuffix(5, 'if ', '')
    .IncludeFlag(dfSummaryMembersNoName);

  wbRecord(PGRD, 'Path Grid',
    wbFlags(wbFlagsList([
      18, 'Compressed'
    ])), [
    wbInteger(DATA, 'Point Count', itU16).SetRequired,
    wbPGRP,
    wbByteArray(PGAG, 'Unknown'),
    wbArray(PGRR, 'Point-to-Point Connections',
      wbArrayS('Point',
        wbInteger('Point', itS16),
      wbCalcPGRRSize)//.SetAfterLoad(wbPGRRPointAfterLoad)
    ),
    wbArrayS(PGRI, 'Inter-Cell Connections',
      wbStructSK([0,2,3,4], 'Inter-Cell Connection', [
        wbInteger('Point', itU16),
        wbUnused(2),
        wbFloat('X'),
        wbFloat('Y'),
        wbFloat('Z')
      ])
    ).SetAfterLoad(wbPGRIPointerAfterLoad),
    wbRArrayS('Point-to-Reference Mappings',
      wbStructSK(PGRL, [0], 'Point-to-Reference Mapping', [
        wbFormIDCk('Reference', [REFR]),
        wbArrayS('Points',
          wbInteger('Point', itU32)
        )
      ])
    )
  ]).SetAddInfo(wbPGRDAddInfo)
    .SetAfterLoad(wbPGRDAfterLoad);

  wbRecord(PLYR, 'Player Reference', [
    wbEDID,
    wbFormID(PLYR, 'Player')
      .SetDefaultNativeValue($7)
      .SetRequired
  ]).IncludeFlag(dfInternalEditOnly);

  wbRecord(QUST, 'Quest', [
    wbEDID,
    wbSCRI,
    wbFULL,
    wbICON,
    wbStruct(DATA, 'General', [
      wbInteger('Flags', itU8,
        wbFlags(wbSparseFlags([
          0, 'Start game enabled',
          2, 'Allow repeated conversation topics',
          3, 'Allow repeated stages'
        ], False, 4))
      ),
      wbInteger('Priority', itU8)
    ]).SetRequired,
    wbConditions,
    wbRArrayS('Stages',
      wbRStructSK([0], 'Stage', [
        wbInteger(INDX, 'Stage index', itS16),
        wbRArray('Log Entries',
          wbRStruct('Log Entry', [
            wbInteger(QSDT, 'Complete Quest', itU8, wbBoolEnum),
            wbConditions,
            wbStringKC(CNAM, 'Log Entry', 0, cpTranslate),
            wbResultScript
          ]).SetSummaryKey([2, 1]))
      ]).SetSummaryKey([1])
    ),
    wbRArray('Targets',
      wbRStruct('Target', [
        wbStructSK(QSTA, [0], 'Target', [
          wbFormIDCkNoReach('Target', [ACHR, ACRE, REFR], True),
          wbInteger('Compass Marker Ignores Locks', itU8, wbBoolEnum),
          wbUnused(3)
        ]),
        wbConditions
      ]).SetSummaryKey([0, 1])
    )
  ]);

  wbRecord(RACE, 'Race', [
    wbEDID,
    wbFULL,
    wbDESC,
    wbSPLOs,
    wbFactionRelations,
    wbStruct(DATA, '', [
      wbArrayS('Skill Boosts',
        wbStructSK([0], 'Skill Boost', [
          wbInteger('Skill', itU8, wbMajorSkillEnum),
          wbInteger('Boost', itS8)
        ]).SetSummaryKey([1, 0])
          .SetSummaryMemberPrefixSuffix(1, '+', '')
          .SetSummaryMemberPrefixSuffix(0, '', '')
          .SetSummaryDelimiter(' ')
          .IncludeFlag(dfSummaryNoSortKey)
          .IncludeFlag(dfSummaryMembersNoName).IncludeFlag(dfCollapsed),
      7),
      wbUnused(2),
      wbFloat('Male Height'),
      wbFloat('Female Height'),
      wbFloat('Male Weight'),
      wbFloat('Female Weight'),
      wbInteger('Playable', itU32, wbBoolEnum)
    ]).SetRequired,
    wbStruct(VNAM, 'Voice', [
      wbFormIDCk('Male', [RACE, NULL]),
      wbFormIDCk('Female', [RACE, NULL])
    ]),
    wbStruct(DNAM, 'Default Hair', [
      wbFormIDCk('Male', [HAIR]),
      wbFormIDCk('Female', [HAIR])
    ]),
    wbInteger(CNAM, 'Default Hair Color', itU8).SetRequired,
    wbFloat(PNAM, 'FaceGen - Main clamp').SetRequired,
    wbFloat(UNAM, 'FaceGen - Face clamp').SetRequired,
    wbStruct(ATTR, 'Base Attributes', [
      wbStruct('Male', [
        wbInteger('Strength', itU8),
        wbInteger('Intelligence', itU8),
        wbInteger('Willpower', itU8),
        wbInteger('Agility', itU8),
        wbInteger('Speed', itU8),
        wbInteger('Endurance', itU8),
        wbInteger('Personality', itU8),
        wbInteger('Luck', itU8)
      ]),
      wbStruct('Female', [
        wbInteger('Strength', itU8),
        wbInteger('Intelligence', itU8),
        wbInteger('Willpower', itU8),
        wbInteger('Agility', itU8),
        wbInteger('Speed', itU8),
        wbInteger('Endurance', itU8),
        wbInteger('Personality', itU8),
        wbInteger('Luck', itU8)
      ])
    ]),
    wbRStruct('Face Data', [
      wbEmpty(NAM0, 'Face Data Marker'),
      wbRArrayS('Parts',
        wbHeadPart(wbHeadPartIndexEnum, wbTexturedModel('Model', [MODL, MODB, MODT], []), nil)
      )
    ]).SetRequired,
    wbEmpty(NAM1, 'Body Data Marker').SetRequired,
    wbRStruct('Male Body Data', [
      wbEmpty(MNAM, 'Male Body Data Marker'),
      wbTexturedModel('Model', [MODL, MODB, MODT], []),
      wbBodyParts
    ]).SetRequired,
    wbRStruct('Female Body Data', [
      wbEmpty(FNAM, 'Female Body Data Marker'),
      wbTexturedModel('Model', [MODL, MODB, MODT], []),
      wbBodyParts
    ]).SetRequired,
    wbArrayS(HNAM, 'Hairs', wbFormIDCk('Hair', [HAIR])).SetRequired,
    wbArrayS(ENAM, 'Eyes', wbFormIDCk('Eye', [EYES])).SetRequired,
    wbFaceGen,
    wbByteArray(SNAM, 'Unknown', 2).SetRequired
  ], True);

  wbRefRecord(REFR, 'Placed Object',
    wbFlags(wbFlagsList([
       7, 'Turn Off Fire',
       9, 'Cast Shadows',
      10, 'Persistent',
      11, 'Initially Disabled',
      15, 'Visible When Distant'
    ])), [
    wbEDID,
    wbFormIDCk(NAME, 'Base', [ACTI, ALCH, AMMO, APPA, ARMO, BOOK, CLOT, CONT, DOOR, FLOR, FURN, GRAS, INGR, KEYM, LIGH, LVLC, MISC, SBSP, SGST, SLGM, SOUN, STAT, TREE, WEAP], False, cpNormal, True),
    wbStruct(XTEL, 'Teleport Destination', [
      wbFormIDCk('Door', [REFR], True),
      wbPosRot
    ]),
    wbStruct(XLOC, 'Lock information', [
      wbInteger('Lock Level', itU8),
      wbUnused(3),
      wbFormIDCk('Key', [KEYM, NULL]),
      wbUnion('Unused', wbXLOCFillerDecider, [
        wbUnused(),
        wbUnused(4)
      ]),
      wbInteger('Flags', itU8,
        wbFlags(wbSparseFlags([
          3, 'Leveled Lock'
        ], False, 3))
      ).IncludeFlag(dfCollapsed, wbCollapseFlags),
      wbUnused(3)
    ]),
    wbOwnership([XLOC]),
    wbXESP,
    wbFormIDCk(XTRG, 'Target', [ACHR, ACRE, REFR], True),
    wbStruct(XSED, 'SpeedTree', [
      wbInteger('Seed', itU8),
      wbUnused(0)
    ]),
    wbXLOD,
    wbFloat(XCHG, 'Charge'),
    wbInteger(XHLT, 'Health', itS32),
    wbRStruct('Unused', [
      wbFormIDCk(XPCI, 'Unused', [CELL]),
      wbString(FULL, 'Unused')
    ]),
    wbInteger(XLCM, 'Level Modifier', itS32),
    wbFormIDCk(XRTM, 'Reference Teleport Marker', [REFR]),
    wbActionFlag,
    wbInteger(XCNT, 'Count', itS32),
    wbRStruct('Map Marker', [
      wbEmpty(XMRK, 'Map Marker Data'),
      wbInteger(FNAM, 'Map Flags', itU8,
        wbFlags([
          {0} 'Visible',
          {1} 'Can Travel To'
        ])
      ).SetRequired,
      wbFULLReq,
      wbStruct(TNAM, '', [
        wbInteger('Type', itU8,
          wbEnum([
            {0}  'None',
            {1}  'Camp',
            {2}  'Cave',
            {3}  'City',
            {4}  'Elven Ruin',
            {5}  'Fort Ruin',
            {6}  'Mine',
            {7}  'Landmark',
            {8}  'Tavern',
            {9}  'Settlement',
            {10} 'Daedric Shrine',
            {11} 'Oblivion Gate',
            {12} 'Unknown? (door icon)'
          ])
        ),
        wbUnused(1)
      ]).SetRequired
    ]),
    wbEmpty(ONAM, 'Open by Default'),
    wbRagdoll,
    wbXSCL,
    wbInteger(XSOL, 'Contained Soul', itU8, wbSoulGemEnum),
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
    wbRArrayS('Region Data Entries',
      wbRStructSK([0], 'Region Data Entry', [
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
          wbUnused(2)
        ], cpNormal, True, nil, 3),

        {--- Objects ---}
        wbArray(RDOT, 'Objects',
          wbStruct('Object', [
            wbFormIDCk('Object', [FLOR, LTEX, STAT, TREE]),
            wbInteger('Parent Index', itU16, wbHideFFFF),
            wbUnused(2),
            wbFloat('Density'),
            wbInteger('Clustering', itU8),
            wbInteger('Min Slope', itU8),
            wbInteger('Max Slope', itU8),
            wbInteger('Flags', itU8,
              wbFlags([
                {0} 'Conform to slope',
                {1} 'Paint Vertices',
                {2} 'Size Variance +/-',
                {3} 'X +/-',
                {4} 'Y +/-',
                {5} 'Z +/-',
                {6} 'Tree',
                {7} 'Huge Rock'
              ])
            ).IncludeFlag(dfCollapsed, wbCollapseFlags),
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
            wbUnused(4)
          ])
        ),

        {--- Map ---}
        wbString(RDMP, 'Map Name', 0, cpTranslate),

        {--- Grass ---}
        wbArrayS(RDGS, 'Grasses',
          wbStructSK([0], 'Grass', [
            wbFormIDCk('Grass', [GRAS]),
            wbUnused(4)
          ])
        ),

        {--- Sound ---}
        wbInteger(RDMD, 'Music Type', itU32, wbMusicEnum),
        wbRegionSounds,

        {--- Weather ---}
        wbArrayS(RDWT, 'Weather Types',
          wbStructSK([0], 'Weather Type', [
            wbFormIDCk('Weather', [WTHR]),
            wbInteger('Chance', itU32)
          ])
        )
      ])
    )
  ], True)
    .SetSummaryKey([3, 4])
    .IncludeFlag(dfSummaryMembersNoName);

  wbRecord(ROAD, 'Road', [
    wbPGRP,
    wbArray(PGRR, 'Point-to-Point Connections',
      wbArray('Point',
        wbVec3('Point'),
      wbCalcPGRRSize)
    ).SetRequired
  ]).SetAddInfo(wbROADAddInfo);

  wbRecord(SBSP, 'Subspace', [
    wbEDID,
    wbVec3(DNAM, '').SetRequired
  ]).SetSummaryKey([1]);

  wbRecord(SCPT, 'Script', [
    wbEDID,
    wbByteArray(SCHD, 'Unknown (Script Header?)'),
    wbSCHR,
    wbByteArray(SCDA, 'Compiled Script'),
    wbStringScript(SCTX, 'Script Source').SetRequired,
    wbRArrayS('Local Variables',
      wbRStructSK([0], 'Local Variable', [
        wbSLSD,
        wbString(SCVR, 'Name', 0, cpCritical)
      ]).SetSummaryKey([1])
        .IncludeFlag(dfSummaryMembersNoName)
    ),
    wbSCROs
  ]).SetToStr(wbScriptToStr);

  wbRecord(SGST, 'Sigil Stone', [
    wbEDID,
    wbStruct(OBME, 'Oblivion Magic Extender', [
      wbInteger('Record Version', itU8),
      wbOBMEVersion,
      wbUnused($1C)
    ]).SetDontShow(wbOBMEDontShow),
    wbFULL,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbICON,
    wbSCRI,
    wbEffects,
    wbStruct(DATA, 'Data', [
      wbInteger('Uses ', itU8),
      wbInteger('Value', itU32),
      wbFloat('Weight')
    ]).SetRequired
  ]);

  wbRecord(SKIL, 'Skill', [
    wbEDID,
    wbInteger(INDX, 'Skill', itU32, wbMajorSkillEnum).SetRequired,
    wbDESC,
    wbICON,
    wbStruct(DATA, 'Skill Data', [
      wbInteger('Action', itU32, wbMajorSkillEnum),
      wbInteger('Attribute', itU32, wbAttributeEnum),
      wbInteger('Specialization', itU32, wbSpecializationEnum),
      wbArray('Use Values', wbFloat('Use Value'), 2)
    ], cpNormal, True),
    wbString(ANAM, 'Apprentice Text', 0, cpTranslate).SetRequired,
    wbString(JNAM, 'Journeyman Text', 0, cpTranslate).SetRequired,
    wbString(ENAM, 'Expert Text', 0, cpTranslate).SetRequired,
    wbString(MNAM, 'Master Text', 0, cpTranslate).SetRequired
  ]).SetSummaryKey([2]);

  wbRecord(SLGM, 'Soul Gem',
    wbFlags(wbFlagsList([
      10, 'Quest Item'
    ])), [
    wbEDID,
    wbFULL,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbICON,
    wbSCRI,
    wbStruct(DATA, '', [
      wbInteger('Value', itU32),
      wbFloat('Weight')
    ], cpNormal, True),
    wbInteger(SOUL, 'Contained Soul', itU8, wbSoulGemEnum).SetRequired,
    wbInteger(SLCP, 'Maximum Capacity', itU8, wbSoulGemEnum).SetRequired
  ]);

  wbRecord(SOUN, 'Sound', [
    wbEDID,
    wbString(FNAM, 'Sound FileName'),
    wbRUnion('Sound Data', [
      wbStruct(SNDX, 'Sound Data', wbSoundDataMembers, cpNormal, True, nil, 6),
      wbStruct(SNDD, 'Sound Data', wbSoundDataMembers, cpNormal, True, nil, 6)
    ]).SetRequired
  ]).SetSummaryKey([1]);

  wbRecord(SPEL, 'Spell', [
    wbEDID,
    wbStruct(OBME, 'Oblivion Magic Extender', [
      wbInteger('Record Version', itU8),
      wbOBMEVersion,
      wbUnused($1C)
    ]).SetDontShow(wbOBMEDontShow),
    wbFULL,
    wbStruct(SPIT, '', [
      wbInteger('Type', itU32,
        wbEnum([
          {0} 'Spell',
          {1} 'Disease',
          {2} 'Power',
          {3} 'Lesser Power',
          {4} 'Ability',
          {5} 'Poison'
        ])
      ),
      wbInteger('Cost', itU32),
      wbInteger('Level', itU8,
        wbEnum([
          {0} 'Novice',
          {1} 'Apprentice',
          {2} 'Journeyman',
          {3} 'Expert',
          {4} 'Master'
        ])
      ),
      wbUnused(3),
      wbInteger('Flags', itU8,
        wbFlags([
          {0} 'Manual Spell Cost',
          {1} 'Immune to Silence 1',
          {2} 'Player Start Spell',
          {3} 'Immune to Silence 2',
          {4} 'Area Effect Ignores LOS',
          {5} 'Script Effect Always Applies',
          {6} 'Disallow Spell Absorb/Reflect',
          {7} 'Touch Spell Explodes w/ no Target'
        ])
      ),
      wbUnused(3)
    ]).SetRequired,
    wbEffects
  ]);

  wbRecord(STAT, 'Static',
    wbFlags(wbFlagsList([
      10, 'Quest Item'
    ])), [
    wbEDID,
    wbTexturedModel('Model', [MODL, MODB, MODT], [])
  ]).SetSummaryKey([1]);

  wbRecord(TREE, 'Tree', [
    wbEDID,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbICON,
    wbArrayS(SNAM, 'SpeedTree Seeds', wbInteger('SpeedTree Seed', itU32)),
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
  ]).SetSummaryKey([1]);

  wbRecord(WATR, 'Water', [
    wbEDID,
    wbString(TNAM, 'Texture').SetRequired,
    wbInteger(ANAM, 'Opacity', itU8)
      .SetDefaultNativeValue(75)
      .SetRequired,
    wbInteger(FNAM, 'Flags', itU8,
      wbFlags([
        {0} 'Causes Damage',
        {1} 'Reflective'
     ])
    ).SetRequired,
    wbString(MNAM, 'Material ID').SetRequired,
    wbFormIDCk(SNAM, 'Sound', [SOUN]),
    wbStruct(DATA, '', [
      wbFloat('Wind Velocity').SetDefaultNativeValue(0.1),
      wbFloat('Wind Direction').SetDefaultNativeValue(90),
      wbFloat('Wave Amplitude').SetDefaultNativeValue(0.5),
      wbFloat('Wave Frequency').SetDefaultNativeValue(1),
      wbFloat('Sun Power').SetDefaultNativeValue(50),
      wbFloat('Reflectivity Amount').SetDefaultNativeValue(0.5),
      wbFloat('Fresnel Amount').SetDefaultNativeValue(0.025),
      wbFloat('Scroll X Speed'),
      wbFloat('Scroll Y Speed'),
      wbStruct('Fog Distance', [
        wbFloat('Near').SetDefaultNativeValue(27852.800782),
        wbFloat('Far').SetDefaultNativeValue(163840)
      ]),
      wbByteColors('Shallow Color'),
      wbByteColors('Deep Color'),
      wbByteColors('Reflection Color'),
      wbInteger('Texture Blend', itU8).SetDefaultNativeValue(50),
      wbUnused(3),
      wbStruct('Rain Simulator', [
        wbFloat('Force').SetDefaultNativeValue(0.1),
        wbFloat('Velocity').SetDefaultNativeValue(0.6),
        wbFloat('Falloff').SetDefaultNativeValue(0.985),
        wbFloat('Dampner').SetDefaultNativeValue(2),
        wbFloat('Starting Size').SetDefaultNativeValue(0.01)
      ], cpNormal, True, nil, 0),
      wbStruct('Displacement Simulator', [
        wbFloat('Force').SetDefaultNativeValue(0.4),
        wbFloat('Velocity').SetDefaultNativeValue(0.6),
        wbFloat('Falloff').SetDefaultNativeValue(0.985),
        wbFloat('Dampner').SetDefaultNativeValue(10),
        wbFloat('Starting Size').SetDefaultNativeValue(0.05)
      ], cpNormal, True, nil, 0),
      wbInteger('Damage', itU16)
    ], cpNormal, True, nil, 0),
    wbStruct(GNAM, 'Related Waters', [
      wbFormIDCk('Daytime', [WATR, NULL]),
      wbFormIDCk('Nighttime', [WATR, NULL]),
      wbFormIDCk('Underwater', [WATR, NULL])
    ]).SetRequired
  ]).SetSummaryKey([1]);

  wbRecord(WEAP, 'Weapon',
    wbFlags(wbFlagsList([
      10, 'Quest Item'
    ])), [
    wbEDID,
    wbFULL,
    wbTexturedModel('Model', [MODL, MODB, MODT], []),
    wbICON,
    wbSCRI,
    wbEnchantment(True),
    wbStruct(DATA, '', [
      wbInteger('Type', itU32,
        wbEnum([
          {0} 'Blade One Hand',
          {1} 'Blade Two Hand',
          {2} 'Blunt One Hand',
          {3} 'Blunt Two Hand',
          {4} 'Staff',
          {5} 'Bow'
        ])
      ),
      wbFloat('Speed'),
      wbFloat('Reach'),
      wbInteger('Ignores Normal Weapon Resistance', itU32, wbBoolEnum),
      wbInteger('Value', itU32),
      wbInteger('Health', itU32),
      wbFloat('Weight'),
      wbInteger('Damage', itU16)
    ]).SetRequired
  ]);

  wbRecord(WTHR, 'Weather', [
    wbEDID,
    wbString(CNAM, 'Cloud Texture Lower Layer'),
    wbString(DNAM, 'Cloud Texture Upper Layer'),
    wbRStruct('Precipitation', [
      wbTexturedModel('Model', [MODL, MODB, MODT], [])
    ]),
    wbWeatherColors,
    wbWeatherFogDistance,
    wbStruct(HNAM, 'HDR Data', [
      wbFloat('Eye Adapt Speed'),
      wbFloat('Blur Radius'),
      wbFloat('Blur Passes'),
      wbFloat('Emissive Mult'),
      wbFloat('Target LUM'),
      wbFloat('Upper LUM Clamp'),
      wbFloat('Bright Scale'),
      wbFloat('Bright Clamp'),
      wbFloat('LUM Ramp No Tex'),
      wbFloat('LUM Ramp Min'),
      wbFloat('LUM Ramp Max'),
      wbFloat('Sunlight Dimmer'),
      wbFloat('Grass Dimmer'),
      wbFloat('Tree Dimmer')
    ]).SetRequired,
    wbStruct(DATA, 'Data', [
      wbInteger('Wind Speed', itU8),
      wbInteger('Cloud Speed (Lower)', itU8),
      wbInteger('Cloud Speed (Upper)', itU8),
      wbInteger('Trans Delta', itU8),
      wbInteger('Sun Glare', itU8),
      wbInteger('Sun Damage', itU8),
      wbInteger('Precipitation - Begin Fade In', itU8),
      wbInteger('Precipitation - End Fade Out', itU8),
      wbInteger('Thunder/Lightning - Begin Fade In', itU8),
      wbInteger('Thunder/Lightning - End Fade Out', itU8),
      wbInteger('Thunder/Lightning - Frequency', itU8),
      wbInteger('Flags ', itU8,
        wbFlags([
          {0} 'Weather - Pleasant',
          {1} 'Weather - Cloudy',
          {2} 'Weather - Rainy',
          {3} 'Weather - Snow'
        ], True)
      ).IncludeFlag(dfCollapsed, wbCollapseFlags),
      wbWeatherLightningColor
    ]).SetRequired,
    wbWeatherSounds
  ]).SetSummaryKey([1,2,3]);

  wbRecord(WRLD, 'Worldspace',
    wbFlags(wbFlagsList([
      19, 'Can''t Wait'
    ])), [
    wbEDID,
    wbFULL,
    wbFormIDCk(WNAM, 'Parent Worldspace', [WRLD]),
    wbFormIDCk(CNAM, 'Climate', [CLMT])
      .SetDefaultNativeValue(351)
      .SetIsRemovable(wbWorldClimateIsRemovable),
    wbFormIDCk(NAM2, 'Water', [WATR])
      .SetDefaultNativeValue(24)
      .SetIsRemovable(wbWorldWaterIsRemovable),
    wbString(ICON, 'Map Image'),
    wbWorldMapData,
    wbInteger(DATA, 'Flags', itU8,
      wbFlags(wbSparseFlags([
        0, 'Small world',
        1, 'Can''t fast travel',
        2, 'Oblivion worldspace',
        4, 'No LOD water'
      ], False, 5), True)
    ).SetDefaultNativeValue(1)
     .SetRequired
     .IncludeFlag(dfCollapsed, wbCollapseFlags),
    wbWorldObjectBounds,
    wbInteger(SNAM, 'Music', itU32, wbMusicEnum),
    wbWorldOffsetData
  ]).SetAfterLoad(wbWorldAfterLoad)
    .SetAfterSet(wbWorldAfterSet);

  wbAddGroupOrder(GMST);
  wbAddGroupOrder(GLOB);
  wbAddGroupOrder(CLAS);
  wbAddGroupOrder(FACT);
  wbAddGroupOrder(HAIR);
  wbAddGroupOrder(EYES);
  wbAddGroupOrder(RACE);
  wbAddGroupOrder(SOUN);
  wbAddGroupOrder(SKIL);
  wbAddGroupOrder(MGEF);
  wbAddGroupOrder(SCPT);
  wbAddGroupOrder(LTEX);
  wbAddGroupOrder(ENCH);
  wbAddGroupOrder(SPEL);
  wbAddGroupOrder(BSGN);
  wbAddGroupOrder(ACTI);
  wbAddGroupOrder(APPA);
  wbAddGroupOrder(ARMO);
  wbAddGroupOrder(BOOK);
  wbAddGroupOrder(CLOT);
  wbAddGroupOrder(CONT);
  wbAddGroupOrder(DOOR);
  wbAddGroupOrder(INGR);
  wbAddGroupOrder(LIGH);
  wbAddGroupOrder(MISC);
  wbAddGroupOrder(STAT);
  wbAddGroupOrder(GRAS);
  wbAddGroupOrder(TREE);
  wbAddGroupOrder(FLOR);
  wbAddGroupOrder(FURN);
  wbAddGroupOrder(WEAP);
  wbAddGroupOrder(AMMO);
  wbAddGroupOrder(NPC_);
  wbAddGroupOrder(PLYR);
  wbAddGroupOrder(CREA);
  wbAddGroupOrder(LVLC);
  wbAddGroupOrder(SLGM);
  wbAddGroupOrder(KEYM);
  wbAddGroupOrder(ALCH);
  wbAddGroupOrder(SBSP);
  wbAddGroupOrder(SGST);
  wbAddGroupOrder(LVLI);
  wbAddGroupOrder(WTHR);
  wbAddGroupOrder(CLMT);
  wbAddGroupOrder(REGN);
  wbAddGroupOrder(CELL);
  //wbAddGroupOrder(REFR);
  //wbAddGroupOrder(ACHR);
  //wbAddGroupOrder(ACRE);
  //wbAddGroupOrder(PGRD);
  wbAddGroupOrder(WRLD);
  //wbAddGroupOrder(LAND);
  //wbAddGroupOrder(TLOD);
  //wbAddGroupOrder(ROAD);
  wbAddGroupOrder(DIAL);
  //wbAddGroupOrder(INFO);
  wbAddGroupOrder(QUST);
  wbAddGroupOrder(IDLE);
  wbAddGroupOrder(PACK);
  wbAddGroupOrder(CSTY);
  wbAddGroupOrder(LSCR);
  wbAddGroupOrder(LVSP);
  wbAddGroupOrder(ANIO);
  wbAddGroupOrder(WATR);
  wbAddGroupOrder(EFSH);
  //wbAddGroupOrder(TOFT);
  wbNexusModsUrl := 'https://www.nexusmods.com/oblivion/mods/11536';
  if wbToolMode = tmLODgen then
    wbNexusModsUrl := 'https://www.nexusmods.com/oblivion/mods/15781';
  wbHEDRVersion := 1.0;
end;

initialization
end.
