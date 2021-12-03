(*
This code implements a randomly grown symbolic expression:

((xor(xor(xor(xor(xor(xor(IN48, xor(xor((!((xor(xor(IN5, IN42), IN45)) | (IN37 & false))) & (xor(xor(xor(xor(IN2, !(IN14)), IN48), xor(xor(IN21 | IN17, IN27 | IN19), IN36)), !(IN13 & IN45))), IN27), ((!(xor(xor(IN17, IN29), IN43))) & ((xor(xor(IN39, IN3), IN34)) | IN14)) & ((!(xor(xor(IN39, IN41), IN17))) & true))), IN46), !(!((IN43 & ((xor(xor(IN37, IN8), IN48)) & (IN16 & IN16))) & (!((IN15 | IN18) | IN37))))), (xor(xor(!(IN34 & (xor(xor(IN9 & IN18, xor(xor(false, IN44), IN30)), IN5))), xor(xor(((!(IN48)) | (IN17 & IN37)) | IN1, !((xor(xor(IN10, IN18), IN41)) | (IN45 & IN13))), IN4 | (!(IN41 & IN27)))), !((!(IN7 | IN36)) & ((!(IN20)) | IN9)))) | ((!(!(IN29))) | IN6)), IN2), xor(xor(IN43 | (xor(xor(((xor(xor(!(IN14), !(IN15)), xor(xor(IN1, IN15), IN50))) & ((IN10 & IN6) & (IN6 | IN7))) | (!((IN15 | IN26) | (!(IN41)))), xor(xor(!(!(!(IN43))), IN36 & IN15), IN31 | (IN42 & (IN48 & IN47)))), ((xor(xor(!(IN23), IN15 & IN10), IN31)) & (xor(xor(xor(xor(IN29, IN46), false), IN15), !(IN7)))) & IN24)), xor(xor(IN5, IN16), !((!(!(xor(xor(IN10, IN47), IN10)))) | (IN8 | ((!(IN18)) | (!(IN31))))))), (true | ((!(xor(xor(IN20 | IN43, IN4 & IN11), !(IN3)))) | (IN17 | (!(IN28 | IN3))))) | ((!(!((IN18 | IN37) & (xor(xor(IN12, IN43), IN4))))) & IN23)))) & ((!(IN17)) & (!(IN45)))) | (IN33 & (xor(xor(!(IN17), xor(xor(!((xor(xor(!(!(!(IN39))), xor(xor(!(IN13 & IN33), IN33 | IN16), (xor(xor(IN3, IN11), IN19)) & (IN6 | IN22))), ((IN18 & IN3) | (IN40 | IN23)) | ((IN41 | true) & IN44))) & IN13), (!(IN9 & (((!(IN38)) | (true & IN36)) & IN38))) & (!(((!(!(IN46))) & ((IN15 & IN28) & (IN16 | IN9))) & ((xor(xor(IN7, !(IN13)), IN41 & IN6)) | (xor(xor(xor(xor(IN40, IN31), IN6), !(IN39)), !(IN46))))))), IN11)), IN35)))

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
    Out := ((((((((Data[48] XOR ((((NOT (((Data[5] XOR Data[42]) XOR Data[45]) OR (Data[37] AND FALSE))) AND ((((Data[2] XOR (NOT Data[14])) XOR Data[48]) XOR (((Data[21] OR Data[17]) XOR (Data[27] OR Data[19])) XOR Data[36])) XOR (NOT (Data[13] AND Data[45])))) XOR Data[27]) XOR (((NOT ((Data[17] XOR Data[29]) XOR Data[43])) AND (((Data[39] XOR Data[3]) XOR Data[34]) OR Data[14])) AND ((NOT ((Data[39] XOR Data[41]) XOR Data[17])) AND TRUE)))) XOR Data[46]) XOR (NOT (NOT ((Data[43] AND (((Data[37] XOR Data[8]) XOR Data[48]) AND (Data[16] AND Data[16]))) AND (NOT ((Data[15] OR Data[18]) OR Data[37])))))) XOR ((((NOT (Data[34] AND (((Data[9] AND Data[18]) XOR ((FALSE XOR Data[44]) XOR Data[30])) XOR Data[5]))) XOR (((((NOT Data[48]) OR (Data[17] AND Data[37])) OR Data[1]) XOR (NOT (((Data[10] XOR Data[18]) XOR Data[41]) OR (Data[45] AND Data[13])))) XOR (Data[4] OR (NOT (Data[41] AND Data[27]))))) XOR (NOT ((NOT (Data[7] OR Data[36])) AND ((NOT Data[20]) OR Data[9])))) OR ((NOT (NOT Data[29])) OR Data[6]))) XOR Data[2]) XOR (((Data[43] OR (((((((NOT Data[14]) XOR (NOT Data[15])) XOR ((Data[1] XOR Data[15]) XOR Data[50])) AND ((Data[10] AND Data[6]) AND (Data[6] OR Data[7]))) OR (NOT ((Data[15] OR Data[26]) OR (NOT Data[41])))) XOR (((NOT (NOT (NOT Data[43]))) XOR (Data[36] AND Data[15])) XOR (Data[31] OR (Data[42] AND (Data[48] AND Data[47]))))) XOR (((((NOT Data[23]) XOR (Data[15] AND Data[10])) XOR Data[31]) AND ((((Data[29] XOR Data[46]) XOR FALSE) XOR Data[15]) XOR (NOT Data[7]))) AND Data[24]))) XOR ((Data[5] XOR Data[16]) XOR (NOT ((NOT (NOT ((Data[10] XOR Data[47]) XOR Data[10]))) OR (Data[8] OR ((NOT Data[18]) OR (NOT Data[31]))))))) XOR ((TRUE OR ((NOT (((Data[20] OR Data[43]) XOR (Data[4] AND Data[11])) XOR (NOT Data[3]))) OR (Data[17] OR (NOT (Data[28] OR Data[3]))))) OR ((NOT (NOT ((Data[18] OR Data[37]) AND ((Data[12] XOR Data[43]) XOR Data[4])))) AND Data[23])))) AND ((NOT Data[17]) AND (NOT Data[45]))) OR (Data[33] AND (((NOT Data[17]) XOR (((NOT ((((NOT (NOT (NOT Data[39]))) XOR (((NOT (Data[13] AND Data[33])) XOR (Data[33] OR Data[16])) XOR (((Data[3] XOR Data[11]) XOR Data[19]) AND (Data[6] OR Data[22])))) XOR (((Data[18] AND Data[3]) OR (Data[40] OR Data[23])) OR ((Data[41] OR TRUE) AND Data[44]))) AND Data[13])) XOR ((NOT (Data[9] AND (((NOT Data[38]) OR (TRUE AND Data[36])) AND Data[38]))) AND (NOT (((NOT (NOT Data[46])) AND ((Data[15] AND Data[28]) AND (Data[16] OR Data[9]))) AND (((Data[7] XOR (NOT Data[13])) XOR (Data[41] AND Data[6])) OR ((((Data[40] XOR Data[31]) XOR Data[6]) XOR (NOT Data[39])) XOR (NOT Data[46]))))))) XOR Data[11])) XOR Data[35])));
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
