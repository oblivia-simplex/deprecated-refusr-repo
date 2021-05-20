(*
This code implements a randomly grown symbolic expression:

xor(xor(IN21, xor(xor(!(xor(xor(!(((IN33 | (!(xor(xor(IN43, IN17), IN41)))) | (((IN24 & IN36) | IN2) & ((IN39 & IN3) & (!(IN44))))) | (!(!(xor(xor(IN35 & IN26, IN42 & IN24), !(IN4)))))), (xor(xor(((!(IN11 & IN23)) & (!(IN3 | true))) | IN47, xor(xor(xor(xor(xor(xor(!(IN14), !(IN37)), xor(xor(IN10, IN8), IN22)), xor(xor(xor(xor(IN29, IN50), IN7), !(IN35)), IN3 & IN45)), IN46 | (IN26 | IN44)), IN38), !((IN41 | IN26) | (IN19 | IN47)))), !(((!(IN41)) & IN13) & (xor(xor(IN49 | IN49, xor(xor(IN43, IN4), IN24)), !(IN49)))))) | IN18), (((IN32 & ((!(IN18)) | (xor(xor(IN33, IN30), IN29)))) & (xor(xor(IN7, (IN4 | IN26) | (IN25 & IN38)), (IN25 & IN24) & (xor(xor(IN27, false), IN39))))) | (xor(xor(((xor(xor(IN7, IN42), IN10)) | IN32) & (xor(xor(IN17, xor(xor(IN39, IN31), IN37)), IN7)), !(xor(xor(!(IN43), !(IN16)), IN50 | IN35))), (xor(xor(IN19, IN4 | IN18), IN36)) & ((!(IN22)) | IN19)))) | IN21)), IN44), xor(xor(((xor(xor(!(xor(xor(!(IN35 | IN45), (!(IN27)) & (IN43 & IN44)), xor(xor(IN46, IN15 & IN22), !(IN33)))), !(!((!(IN36)) | (IN16 | IN14)))), IN23 | (xor(xor(IN10 & IN4, xor(xor(xor(xor(IN34, IN37), IN13), IN47), !(IN31))), xor(xor(IN12 & IN11, IN12 | IN18), !(IN39)))))) | (!(!(!(xor(xor(xor(xor(IN14, IN14), IN19), IN45 & IN38), IN15)))))) | ((xor(xor((((IN33 | IN36) | (!(IN20))) & (IN33 & (IN33 & IN33))) | (xor(xor(IN45 | (IN8 & IN21), xor(xor(xor(xor(IN31, IN46), IN43), xor(xor(IN48, IN2), IN12)), IN28)), !(IN49))), xor(xor(xor(xor(xor(xor(!(IN27), xor(xor(IN16, IN38), IN22)), IN26 | IN35), !(IN3 & IN47)), !(IN42 | IN28)), !(IN31)), !(IN39))), (xor(xor((xor(xor(IN27, IN35), IN17)) & (IN13 & IN30), IN15), !(xor(xor(IN39, IN29), IN46)))) | (((!(IN47)) | (IN22 | IN32)) | (!(IN29 | IN7))))) & IN13), IN3 & (!(xor(xor(xor(xor((!(!(IN22))) & (!(IN22 | IN20)), ((IN13 & IN28) & (!(IN27))) | (xor(xor(!(IN27), !(IN36)), IN20 | IN44))), IN19), ((xor(xor(xor(xor(IN7, IN21), IN13), IN40 | IN47), !(IN32))) | (xor(xor(IN29 | IN15, !(IN26)), !(IN27)))) | ((xor(xor(IN27 | IN24, xor(xor(IN27, IN23), IN6)), !(IN47))) & ((IN12 | IN31) | (!(IN16))))), (!(!(IN46))) & IN15)))), !(xor(xor(xor(xor((!(!(!(IN11)))) & ((!(false | IN24)) & (xor(xor(!(IN48), xor(xor(IN41, true), IN47)), !(IN11)))), IN36), (IN35 & (xor(xor(xor(xor(IN40, IN32), IN38), xor(xor(IN44, IN29), IN18)), false | IN50))) | (((IN36 & IN23) | (!(IN9))) & (!(IN39 | IN43)))), !(((!(xor(xor(IN29, IN9), IN19))) & ((IN6 & IN41) | (IN20 & IN14))) | (!(true & (IN40 | IN30))))), !(((!(IN16)) & (xor(xor(xor(xor(IN46, IN30), IN2), !(IN40)), false))) | (xor(xor(!(IN20 | IN25), !(IN50 | IN1)), IN42)))))))), IN7)

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
    Out := ((Data[21] XOR (((NOT (((NOT (((Data[33] OR (NOT ((Data[43] XOR Data[17]) XOR Data[41]))) OR (((Data[24] AND Data[36]) OR Data[2]) AND ((Data[39] AND Data[3]) AND (NOT Data[44])))) OR (NOT (NOT (((Data[35] AND Data[26]) XOR (Data[42] AND Data[24])) XOR (NOT Data[4])))))) XOR ((((((NOT (Data[11] AND Data[23])) AND (NOT (Data[3] OR TRUE))) OR Data[47]) XOR (((((((NOT Data[14]) XOR (NOT Data[37])) XOR ((Data[10] XOR Data[8]) XOR Data[22])) XOR ((((Data[29] XOR Data[50]) XOR Data[7]) XOR (NOT Data[35])) XOR (Data[3] AND Data[45]))) XOR (Data[46] OR (Data[26] OR Data[44]))) XOR Data[38]) XOR (NOT ((Data[41] OR Data[26]) OR (Data[19] OR Data[47]))))) XOR (NOT (((NOT Data[41]) AND Data[13]) AND (((Data[49] OR Data[49]) XOR ((Data[43] XOR Data[4]) XOR Data[24])) XOR (NOT Data[49]))))) OR Data[18])) XOR ((((Data[32] AND ((NOT Data[18]) OR ((Data[33] XOR Data[30]) XOR Data[29]))) AND ((Data[7] XOR ((Data[4] OR Data[26]) OR (Data[25] AND Data[38]))) XOR ((Data[25] AND Data[24]) AND ((Data[27] XOR FALSE) XOR Data[39])))) OR ((((((Data[7] XOR Data[42]) XOR Data[10]) OR Data[32]) AND ((Data[17] XOR ((Data[39] XOR Data[31]) XOR Data[37])) XOR Data[7])) XOR (NOT (((NOT Data[43]) XOR (NOT Data[16])) XOR (Data[50] OR Data[35])))) XOR (((Data[19] XOR (Data[4] OR Data[18])) XOR Data[36]) AND ((NOT Data[22]) OR Data[19])))) OR Data[21]))) XOR Data[44]) XOR (((((((NOT (((NOT (Data[35] OR Data[45])) XOR ((NOT Data[27]) AND (Data[43] AND Data[44]))) XOR ((Data[46] XOR (Data[15] AND Data[22])) XOR (NOT Data[33])))) XOR (NOT (NOT ((NOT Data[36]) OR (Data[16] OR Data[14]))))) XOR (Data[23] OR (((Data[10] AND Data[4]) XOR ((((Data[34] XOR Data[37]) XOR Data[13]) XOR Data[47]) XOR (NOT Data[31]))) XOR (((Data[12] AND Data[11]) XOR (Data[12] OR Data[18])) XOR (NOT Data[39]))))) OR (NOT (NOT (NOT ((((Data[14] XOR Data[14]) XOR Data[19]) XOR (Data[45] AND Data[38])) XOR Data[15]))))) OR (((((((Data[33] OR Data[36]) OR (NOT Data[20])) AND (Data[33] AND (Data[33] AND Data[33]))) OR (((Data[45] OR (Data[8] AND Data[21])) XOR ((((Data[31] XOR Data[46]) XOR Data[43]) XOR ((Data[48] XOR Data[2]) XOR Data[12])) XOR Data[28])) XOR (NOT Data[49]))) XOR (((((((NOT Data[27]) XOR ((Data[16] XOR Data[38]) XOR Data[22])) XOR (Data[26] OR Data[35])) XOR (NOT (Data[3] AND Data[47]))) XOR (NOT (Data[42] OR Data[28]))) XOR (NOT Data[31])) XOR (NOT Data[39]))) XOR ((((((Data[27] XOR Data[35]) XOR Data[17]) AND (Data[13] AND Data[30])) XOR Data[15]) XOR (NOT ((Data[39] XOR Data[29]) XOR Data[46]))) OR (((NOT Data[47]) OR (Data[22] OR Data[32])) OR (NOT (Data[29] OR Data[7]))))) AND Data[13])) XOR (Data[3] AND (NOT ((((((NOT (NOT Data[22])) AND (NOT (Data[22] OR Data[20]))) XOR (((Data[13] AND Data[28]) AND (NOT Data[27])) OR (((NOT Data[27]) XOR (NOT Data[36])) XOR (Data[20] OR Data[44])))) XOR Data[19]) XOR ((((((Data[7] XOR Data[21]) XOR Data[13]) XOR (Data[40] OR Data[47])) XOR (NOT Data[32])) OR (((Data[29] OR Data[15]) XOR (NOT Data[26])) XOR (NOT Data[27]))) OR ((((Data[27] OR Data[24]) XOR ((Data[27] XOR Data[23]) XOR Data[6])) XOR (NOT Data[47])) AND ((Data[12] OR Data[31]) OR (NOT Data[16]))))) XOR ((NOT (NOT Data[46])) AND Data[15]))))) XOR (NOT ((((((NOT (NOT (NOT Data[11]))) AND ((NOT (FALSE OR Data[24])) AND (((NOT Data[48]) XOR ((Data[41] XOR TRUE) XOR Data[47])) XOR (NOT Data[11])))) XOR Data[36]) XOR ((Data[35] AND ((((Data[40] XOR Data[32]) XOR Data[38]) XOR ((Data[44] XOR Data[29]) XOR Data[18])) XOR (FALSE OR Data[50]))) OR (((Data[36] AND Data[23]) OR (NOT Data[9])) AND (NOT (Data[39] OR Data[43]))))) XOR (NOT (((NOT ((Data[29] XOR Data[9]) XOR Data[19])) AND ((Data[6] AND Data[41]) OR (Data[20] AND Data[14]))) OR (NOT (TRUE AND (Data[40] OR Data[30])))))) XOR (NOT (((NOT Data[16]) AND ((((Data[46] XOR Data[30]) XOR Data[2]) XOR (NOT Data[40])) XOR FALSE)) OR (((NOT (Data[20] OR Data[25])) XOR (NOT (Data[50] OR Data[1]))) XOR Data[42])))))))) XOR Data[7]);
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
