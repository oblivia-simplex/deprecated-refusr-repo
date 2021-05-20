(*
This code implements a randomly grown symbolic expression:

xor(xor(IN1, (xor(xor(xor(xor((!(xor(xor((IN12 | (IN11 & IN27)) & IN11, !(xor(xor(!(IN34), IN44 & IN46), IN19 | IN38))), IN38 | IN45))) | ((IN13 | (xor(xor((xor(xor(IN40, IN15), IN44)) & (IN46 & IN14), IN28 | (xor(xor(IN28, IN38), IN18))), (IN13 & IN4) & (xor(xor(IN22, IN19), IN8))))) | (IN25 & (!((xor(xor(IN10, IN38), IN10)) & (xor(xor(IN42, IN48), IN43)))))), IN21), (IN22 & ((((!(IN41)) | (IN9 & IN29)) & (IN21 & (IN8 & IN45))) | IN6)) & (!(!(!((IN1 & IN39) & IN25))))), (!((xor(xor(IN3 | (false | (!(IN20))), IN30 | ((IN8 & IN45) | (xor(xor(IN44, IN48), IN46)))), (!(!(IN48))) | (!(xor(xor(IN43, IN21), IN14))))) | ((!((IN50 & IN45) | (IN50 | IN41))) | IN42))) & IN39), !(!(xor(xor((IN25 | (xor(xor(IN38, IN38), !(IN48)))) | (((xor(xor(IN26, IN41), true)) & (xor(xor(IN8, IN27), IN34))) | IN15), !(IN40 & (IN44 | (IN13 | IN35)))), IN8))))) & (!(xor(xor(xor(xor((!(IN42)) | (xor(xor((!(IN25 & IN34)) & (xor(xor(IN13 & IN29, IN4 & IN36), !(IN6))), !((IN47 | IN13) & (xor(xor(IN42, IN43), IN40)))), (xor(xor(IN17, IN34), xor(xor(IN8, IN20), IN42))) | ((xor(xor(true, IN21), IN17)) | (!(IN43))))), !(!(((!(IN49)) & (IN44 & IN3)) & (IN20 & (IN6 & IN20))))), !(xor(xor(IN17, IN45), IN32))), ((!(xor(xor((xor(xor(IN4, IN26), IN46)) & (!(IN11)), xor(xor(IN1 | IN28, xor(xor(IN14, IN13), IN41)), !(IN47))), !(IN13)))) | (((xor(xor(!(IN31), IN14 & IN11), xor(xor(IN4, IN7), IN44))) | true) & IN37)) | (xor(xor(!((!(IN40 & IN49)) & IN7), IN15), (IN38 | (xor(xor(IN15, IN33), IN37 | IN17))) & ((xor(xor(IN30 | IN8, IN1), xor(xor(IN9, IN39), IN9))) & ((xor(xor(IN31, IN37), IN48)) & (IN39 | IN29)))))), xor(xor(IN2 | (xor(xor(xor(xor(IN47 & IN29, xor(xor(IN45, IN2), xor(xor(IN47, IN14), IN11))), IN24), !(IN28)), (IN17 | (!(IN48))) | ((xor(xor(IN40, IN45), IN26)) & (IN23 & IN20)))), xor(xor((xor(xor(IN38, !(IN39 | IN3)), IN25 | (xor(xor(IN25, IN3), IN22)))) & (xor(xor((IN2 | true) | (IN39 | IN30), (IN20 & IN40) & (!(IN43))), (IN36 | IN29) | (IN12 | IN39))), !(!(!(!(IN2))))), !(IN41))), (xor(xor(xor(xor((IN5 | IN49) & (!(IN47)), IN19), IN12), IN44), (!(xor(xor(IN23, IN6), IN46))) | (!(IN18 | IN32)))) & (xor(xor((!(!(IN41))) & (IN7 | (false & IN18)), xor(xor(IN49, xor(xor(IN42 | IN42, xor(xor(IN28, IN30), IN31)), xor(xor(IN13, IN37), IN27))), (IN46 | IN24) | (!(IN4)))), (xor(xor(IN33, IN42), !(IN4))) & ((xor(xor(IN24, IN20), IN15)) | (IN22 & IN29))))))))), IN18)

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
    Out := ((Data[1] XOR (((((((NOT ((((Data[12] OR (Data[11] AND Data[27])) AND Data[11]) XOR (NOT (((NOT Data[34]) XOR (Data[44] AND Data[46])) XOR (Data[19] OR Data[38])))) XOR (Data[38] OR Data[45]))) OR ((Data[13] OR (((((Data[40] XOR Data[15]) XOR Data[44]) AND (Data[46] AND Data[14])) XOR (Data[28] OR ((Data[28] XOR Data[38]) XOR Data[18]))) XOR ((Data[13] AND Data[4]) AND ((Data[22] XOR Data[19]) XOR Data[8])))) OR (Data[25] AND (NOT (((Data[10] XOR Data[38]) XOR Data[10]) AND ((Data[42] XOR Data[48]) XOR Data[43])))))) XOR Data[21]) XOR ((Data[22] AND ((((NOT Data[41]) OR (Data[9] AND Data[29])) AND (Data[21] AND (Data[8] AND Data[45]))) OR Data[6])) AND (NOT (NOT (NOT ((Data[1] AND Data[39]) AND Data[25])))))) XOR ((NOT ((((Data[3] OR (FALSE OR (NOT Data[20]))) XOR (Data[30] OR ((Data[8] AND Data[45]) OR ((Data[44] XOR Data[48]) XOR Data[46])))) XOR ((NOT (NOT Data[48])) OR (NOT ((Data[43] XOR Data[21]) XOR Data[14])))) OR ((NOT ((Data[50] AND Data[45]) OR (Data[50] OR Data[41]))) OR Data[42]))) AND Data[39])) XOR (NOT (NOT ((((Data[25] OR ((Data[38] XOR Data[38]) XOR (NOT Data[48]))) OR ((((Data[26] XOR Data[41]) XOR TRUE) AND ((Data[8] XOR Data[27]) XOR Data[34])) OR Data[15])) XOR (NOT (Data[40] AND (Data[44] OR (Data[13] OR Data[35]))))) XOR Data[8])))) AND (NOT ((((((NOT Data[42]) OR ((((NOT (Data[25] AND Data[34])) AND (((Data[13] AND Data[29]) XOR (Data[4] AND Data[36])) XOR (NOT Data[6]))) XOR (NOT ((Data[47] OR Data[13]) AND ((Data[42] XOR Data[43]) XOR Data[40])))) XOR (((Data[17] XOR Data[34]) XOR ((Data[8] XOR Data[20]) XOR Data[42])) OR (((TRUE XOR Data[21]) XOR Data[17]) OR (NOT Data[43]))))) XOR (NOT (NOT (((NOT Data[49]) AND (Data[44] AND Data[3])) AND (Data[20] AND (Data[6] AND Data[20])))))) XOR (NOT ((Data[17] XOR Data[45]) XOR Data[32]))) XOR (((NOT (((((Data[4] XOR Data[26]) XOR Data[46]) AND (NOT Data[11])) XOR (((Data[1] OR Data[28]) XOR ((Data[14] XOR Data[13]) XOR Data[41])) XOR (NOT Data[47]))) XOR (NOT Data[13]))) OR (((((NOT Data[31]) XOR (Data[14] AND Data[11])) XOR ((Data[4] XOR Data[7]) XOR Data[44])) OR TRUE) AND Data[37])) OR (((NOT ((NOT (Data[40] AND Data[49])) AND Data[7])) XOR Data[15]) XOR ((Data[38] OR ((Data[15] XOR Data[33]) XOR (Data[37] OR Data[17]))) AND ((((Data[30] OR Data[8]) XOR Data[1]) XOR ((Data[9] XOR Data[39]) XOR Data[9])) AND (((Data[31] XOR Data[37]) XOR Data[48]) AND (Data[39] OR Data[29]))))))) XOR (((Data[2] OR (((((Data[47] AND Data[29]) XOR ((Data[45] XOR Data[2]) XOR ((Data[47] XOR Data[14]) XOR Data[11]))) XOR Data[24]) XOR (NOT Data[28])) XOR ((Data[17] OR (NOT Data[48])) OR (((Data[40] XOR Data[45]) XOR Data[26]) AND (Data[23] AND Data[20]))))) XOR (((((Data[38] XOR (NOT (Data[39] OR Data[3]))) XOR (Data[25] OR ((Data[25] XOR Data[3]) XOR Data[22]))) AND ((((Data[2] OR TRUE) OR (Data[39] OR Data[30])) XOR ((Data[20] AND Data[40]) AND (NOT Data[43]))) XOR ((Data[36] OR Data[29]) OR (Data[12] OR Data[39])))) XOR (NOT (NOT (NOT (NOT Data[2]))))) XOR (NOT Data[41]))) XOR (((((((Data[5] OR Data[49]) AND (NOT Data[47])) XOR Data[19]) XOR Data[12]) XOR Data[44]) XOR ((NOT ((Data[23] XOR Data[6]) XOR Data[46])) OR (NOT (Data[18] OR Data[32])))) AND ((((NOT (NOT Data[41])) AND (Data[7] OR (FALSE AND Data[18]))) XOR ((Data[49] XOR (((Data[42] OR Data[42]) XOR ((Data[28] XOR Data[30]) XOR Data[31])) XOR ((Data[13] XOR Data[37]) XOR Data[27]))) XOR ((Data[46] OR Data[24]) OR (NOT Data[4])))) XOR (((Data[33] XOR Data[42]) XOR (NOT Data[4])) AND (((Data[24] XOR Data[20]) XOR Data[15]) OR (Data[22] AND Data[29])))))))))) XOR Data[18]);
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
