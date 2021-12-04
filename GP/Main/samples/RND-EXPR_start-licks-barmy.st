(*
This code implements a randomly grown symbolic expression:

((((xor(xor(xor(xor((xor(xor(!(!(IN8)), IN19 | (IN35 | IN37)), !(IN12))) | IN7, ((xor(xor(IN20 | IN2, xor(xor(IN27, IN40), IN7)), IN16)) & (!(IN17 | IN17))) & ((xor(xor(IN45, IN7), xor(xor(IN1, IN44), IN25))) & (!(xor(xor(IN14, IN43), IN36))))), true), (xor(xor(IN15, !(IN44)), xor(xor((!(IN11)) & (xor(xor(IN49, IN16), IN8)), (IN32 | IN48) & (IN42 | IN18)), xor(xor(!(IN22), xor(xor(IN48, IN32), IN36)), !(IN17))))) | ((!((!(IN34)) & (IN32 | IN4))) | (xor(xor((IN39 | IN26) & IN24, IN5), xor(xor(IN6, IN27 | IN11), IN7 | IN20))))), !(!(!((IN30 & IN50) & (xor(xor(IN19, IN1), IN19))))))) | (xor(xor((!(IN26 | IN34)) | (IN49 | (xor(xor(IN18 & (IN36 | IN36), (IN49 | IN44) & IN50), IN41))), xor(xor(xor(xor((IN4 & IN44) | (!(!(IN49))), xor(xor((xor(xor(IN22, IN46), IN16)) & (!(IN50)), IN35), (IN48 | IN37) | (IN31 & IN24))), IN28 & IN22), !(IN39 | (xor(xor(!(IN40), IN22 & IN9), IN45 | IN44)))), (IN37 & (xor(xor(IN11 | IN6, IN1 & IN33), IN48 | IN8))) | (((xor(xor(IN13, IN21), IN23)) & (IN8 & IN13)) & (!(xor(xor(IN19, IN11), IN41)))))), (IN16 & (((xor(xor(IN48, IN5), IN44)) | IN8) & ((xor(xor(IN8, IN45), IN50)) | (xor(xor(false, IN6), IN41))))) | ((xor(xor((xor(xor(IN4, IN16), IN7)) | (!(IN40)), xor(xor(IN41 | IN45, IN30 & IN33), xor(xor(IN22, IN47), IN1))), xor(xor(!(IN1), IN10 & IN6), xor(xor(IN42, IN48), IN2)))) & IN37)))) | (((!(((!(IN2 & IN39)) & ((!(IN27)) & (IN32 | IN14))) & ((!(IN7 & IN12)) | IN26))) & (IN18 & ((!((IN12 & IN32) & (xor(xor(false, IN10), IN24)))) & true))) & (xor(xor((!(IN9 | (!(IN47)))) | (IN43 & IN17), IN35), IN20)))) | (((IN42 & (xor(xor(((!(xor(xor(IN9, IN3), IN36))) & ((IN18 & IN39) | (true & IN42))) | (!((IN25 & IN25) | IN46)), xor(xor(!(!(IN4 & IN44)), IN45), (!(!(IN47))) | ((!(IN44)) | (xor(xor(IN35, IN38), IN27))))), !(xor(xor(IN27, IN27), !(IN33 | IN35)))))) & (IN32 | (xor(xor((xor(xor(IN36, (IN37 & IN8) & (!(IN37))), IN9)) | (IN22 & ((IN15 & IN45) | (!(IN12)))), (((IN38 & IN46) & (IN45 & IN49)) & (IN2 & (xor(xor(IN46, IN25), IN24)))) & ((IN8 | (IN10 & IN25)) | (xor(xor(!(IN46), IN19 & IN11), !(IN20))))), ((xor(xor(xor(xor(IN22, IN26), IN31), IN7 | IN40), IN21)) & (!(!(IN32)))) | (((IN40 | IN1) & IN32) | ((IN37 | IN35) & (IN1 & IN45))))))) | (xor(xor((IN25 | IN42) & ((xor(xor((xor(xor(IN35, !(IN28)), IN12 | IN17)) | IN25, ((xor(xor(IN3, IN2), IN25)) & (IN32 | IN9)) & (xor(xor(IN33 & IN43, !(IN37)), IN28 & IN2))), false)) & IN30), IN36), IN6)))) & (!(!(IN43)))

*)

FUNCTION_BLOCK F_CollectInput
  VAR_IN_OUT
      Data : ARRAY[1..50] OF BOOL;
  END_VAR
  VAR_INPUT
      TICK  : BOOL := 0;
      IN1   : BOOL := 0;
      IN2   : BOOL := 0;
      IN3   : BOOL := 0;
      IN4   : BOOL := 0;
      IN5   : BOOL := 0;
      RESET : BOOL := FALSE;
  END_VAR
  VAR_OUTPUT
      Finished : BOOL;
  END_VAR
  VAR
      j    : USINT := 1;
      tock : BOOL  := 0;
  END_VAR
  IF NOT RESET AND tock = NOT TICK THEN
      Data[j]   := IN1;
      Data[j+1] := IN2;
      Data[j+2] := IN3;
      Data[j+3] := IN4;
      Data[j+4] := IN5;
      j := j + 5;
      tock := TICK;
  ELSE
      j := 1;
      tock := 0;
  END_IF;
  Finished := (j > 50);
END_FUNCTION_BLOCK


PROGRAM Boiler
  VAR
    Data  : ARRAY[1..50] OF BOOL;
    Ready : BOOL;
    CollectInput : F_CollectInput;
  END_VAR
  VAR
    TICK     AT %IX1.0 : BOOL;
    IN1      AT %IX0.3 : BOOL;
    IN2      AT %IX0.4 : BOOL;
    IN3      AT %IX0.5 : BOOL;
    IN4      AT %IX0.6 : BOOL;
    IN5      AT %IX0.7 : BOOL;
    OutReady AT %QX0.0 : BOOL := FALSE;
    FeedNext AT %QX0.1 : BOOL := FALSE;
    Out      AT %QX0.2 : BOOL;
  END_VAR
  CollectInput(TICK:=TICK, IN1:=IN1, IN2:=IN2, IN3:=IN3, IN4:=IN4, IN5:=IN5);
  Ready := CollectInput.Finished;
  FeedNext := 1;
  IF Ready THEN
    Out := ((((((((((((NOT (NOT Data[8])) XOR (Data[19] OR (Data[35] OR Data[37]))) XOR (NOT Data[12])) OR Data[7]) XOR (((((Data[20] OR Data[2]) XOR ((Data[27] XOR Data[40]) XOR Data[7])) XOR Data[16]) AND (NOT (Data[17] OR Data[17]))) AND (((Data[45] XOR Data[7]) XOR ((Data[1] XOR Data[44]) XOR Data[25])) AND (NOT ((Data[14] XOR Data[43]) XOR Data[36]))))) XOR TRUE) XOR (((Data[15] XOR (NOT Data[44])) XOR ((((NOT Data[11]) AND ((Data[49] XOR Data[16]) XOR Data[8])) XOR ((Data[32] OR Data[48]) AND (Data[42] OR Data[18]))) XOR (((NOT Data[22]) XOR ((Data[48] XOR Data[32]) XOR Data[36])) XOR (NOT Data[17])))) OR ((NOT ((NOT Data[34]) AND (Data[32] OR Data[4]))) OR ((((Data[39] OR Data[26]) AND Data[24]) XOR Data[5]) XOR ((Data[6] XOR (Data[27] OR Data[11])) XOR (Data[7] OR Data[20])))))) XOR (NOT (NOT (NOT ((Data[30] AND Data[50]) AND ((Data[19] XOR Data[1]) XOR Data[19])))))) OR ((((NOT (Data[26] OR Data[34])) OR (Data[49] OR (((Data[18] AND (Data[36] OR Data[36])) XOR ((Data[49] OR Data[44]) AND Data[50])) XOR Data[41]))) XOR ((((((Data[4] AND Data[44]) OR (NOT (NOT Data[49]))) XOR (((((Data[22] XOR Data[46]) XOR Data[16]) AND (NOT Data[50])) XOR Data[35]) XOR ((Data[48] OR Data[37]) OR (Data[31] AND Data[24])))) XOR (Data[28] AND Data[22])) XOR (NOT (Data[39] OR (((NOT Data[40]) XOR (Data[22] AND Data[9])) XOR (Data[45] OR Data[44]))))) XOR ((Data[37] AND (((Data[11] OR Data[6]) XOR (Data[1] AND Data[33])) XOR (Data[48] OR Data[8]))) OR ((((Data[13] XOR Data[21]) XOR Data[23]) AND (Data[8] AND Data[13])) AND (NOT ((Data[19] XOR Data[11]) XOR Data[41])))))) XOR ((Data[16] AND ((((Data[48] XOR Data[5]) XOR Data[44]) OR Data[8]) AND (((Data[8] XOR Data[45]) XOR Data[50]) OR ((FALSE XOR Data[6]) XOR Data[41])))) OR ((((((Data[4] XOR Data[16]) XOR Data[7]) OR (NOT Data[40])) XOR (((Data[41] OR Data[45]) XOR (Data[30] AND Data[33])) XOR ((Data[22] XOR Data[47]) XOR Data[1]))) XOR (((NOT Data[1]) XOR (Data[10] AND Data[6])) XOR ((Data[42] XOR Data[48]) XOR Data[2]))) AND Data[37])))) OR (((NOT (((NOT (Data[2] AND Data[39])) AND ((NOT Data[27]) AND (Data[32] OR Data[14]))) AND ((NOT (Data[7] AND Data[12])) OR Data[26]))) AND (Data[18] AND ((NOT ((Data[12] AND Data[32]) AND ((FALSE XOR Data[10]) XOR Data[24]))) AND TRUE))) AND ((((NOT (Data[9] OR (NOT Data[47]))) OR (Data[43] AND Data[17])) XOR Data[35]) XOR Data[20]))) OR (((Data[42] AND (((((NOT ((Data[9] XOR Data[3]) XOR Data[36])) AND ((Data[18] AND Data[39]) OR (TRUE AND Data[42]))) OR (NOT ((Data[25] AND Data[25]) OR Data[46]))) XOR (((NOT (NOT (Data[4] AND Data[44]))) XOR Data[45]) XOR ((NOT (NOT Data[47])) OR ((NOT Data[44]) OR ((Data[35] XOR Data[38]) XOR Data[27]))))) XOR (NOT ((Data[27] XOR Data[27]) XOR (NOT (Data[33] OR Data[35])))))) AND (Data[32] OR (((((Data[36] XOR ((Data[37] AND Data[8]) AND (NOT Data[37]))) XOR Data[9]) OR (Data[22] AND ((Data[15] AND Data[45]) OR (NOT Data[12])))) XOR ((((Data[38] AND Data[46]) AND (Data[45] AND Data[49])) AND (Data[2] AND ((Data[46] XOR Data[25]) XOR Data[24]))) AND ((Data[8] OR (Data[10] AND Data[25])) OR (((NOT Data[46]) XOR (Data[19] AND Data[11])) XOR (NOT Data[20]))))) XOR ((((((Data[22] XOR Data[26]) XOR Data[31]) XOR (Data[7] OR Data[40])) XOR Data[21]) AND (NOT (NOT Data[32]))) OR (((Data[40] OR Data[1]) AND Data[32]) OR ((Data[37] OR Data[35]) AND (Data[1] AND Data[45]))))))) OR ((((Data[25] OR Data[42]) AND ((((((Data[35] XOR (NOT Data[28])) XOR (Data[12] OR Data[17])) OR Data[25]) XOR ((((Data[3] XOR Data[2]) XOR Data[25]) AND (Data[32] OR Data[9])) AND (((Data[33] AND Data[43]) XOR (NOT Data[37])) XOR (Data[28] AND Data[2])))) XOR FALSE) AND Data[30])) XOR Data[36]) XOR Data[6]))) AND (NOT (NOT Data[43])));
    OutReady := 1;
    CollectInput(RESET:=TRUE);
  END_IF;
END_PROGRAM


CONFIGURATION Config0
  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : Boiler;
  END_RESOURCE
END_CONFIGURATION
