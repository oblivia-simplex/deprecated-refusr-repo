(*
This code implements a randomly grown symbolic expression:

xor(xor(!((!(((xor(xor(((!(IN45)) & (IN32 | IN40)) & ((IN23 | IN38) | (!(IN24))), xor(xor((IN15 | IN19) & IN39, !(IN4 & IN13)), (xor(xor(IN43, IN11), IN25)) & (IN25 | IN49))), IN19)) | (xor(xor(IN43 & ((IN16 & IN26) | (!(IN43))), IN24 | ((!(IN13)) | IN33)), xor(xor(IN32, (IN20 & IN40) | (IN18 | IN23)), (IN42 & IN39) & (!(IN6)))))) & (!(IN16 & (xor(xor(!(IN50 & IN37), IN25), IN4)))))) & (!(!(((!(xor(xor(IN29 | IN47, xor(xor(IN44, IN42), IN1)), IN48 & IN20))) & (xor(xor((!(IN19)) | (IN47 & IN15), !(xor(xor(IN3, IN39), IN10))), xor(xor(IN35, IN48), IN40 & IN6)))) | (xor(xor(IN2, IN12), !(IN1))))))), IN30 | ((((xor(xor(((xor(xor(IN20 & IN48, !(IN20)), xor(xor(IN21, IN15), IN38))) & ((!(IN47)) & (IN13 & IN31))) & IN25, (((!(IN17)) | (IN34 | IN40)) | IN35) | ((xor(xor(IN37 | IN35, IN11 | IN33), !(IN9))) & ((IN43 & IN14) & (!(IN26))))), (xor(xor(xor(xor(IN45 & IN37, !(IN12)), IN4 | IN33), xor(xor(IN40, IN6 | IN14), IN38)), xor(xor(IN47 & IN30, IN29), !(IN36)))) | ((!(IN17)) | (xor(xor(IN45 | IN20, IN46 & IN36), !(IN17)))))) & (IN31 | (!(((IN9 | IN39) | (IN1 | IN44)) | (!(IN39 | IN42)))))) & IN41) & (((xor(xor(!(IN41 & (xor(xor(IN26 | IN47, xor(xor(IN25, IN44), IN28)), !(IN22)))), IN30), !(!(IN7 | (xor(xor(IN15, IN18), IN35)))))) | IN43) & (((xor(xor((xor(xor(!(IN37), xor(xor(IN36, IN29), IN20)), IN45)) | (xor(xor(IN24, xor(xor(IN17, IN22), IN40)), IN33 & IN36)), xor(xor(IN9 & (xor(xor(IN8, IN7), IN1)), IN29 | (IN49 | IN38)), xor(xor(IN48 | IN37, xor(xor(IN40, IN21), IN27)), !(IN9)))), !((xor(xor(IN21, IN35), IN17)) | IN47))) | IN41) | (IN40 & ((!(xor(xor(IN14 | IN35, IN10), true & IN31))) & (xor(xor((!(IN11)) | (!(IN1)), IN28), xor(xor(IN12, IN14 | IN38), IN26 & IN23))))))))), false)

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
    Out := (((NOT ((NOT (((((((NOT Data[45]) AND (Data[32] OR Data[40])) AND ((Data[23] OR Data[38]) OR (NOT Data[24]))) XOR ((((Data[15] OR Data[19]) AND Data[39]) XOR (NOT (Data[4] AND Data[13]))) XOR (((Data[43] XOR Data[11]) XOR Data[25]) AND (Data[25] OR Data[49])))) XOR Data[19]) OR (((Data[43] AND ((Data[16] AND Data[26]) OR (NOT Data[43]))) XOR (Data[24] OR ((NOT Data[13]) OR Data[33]))) XOR ((Data[32] XOR ((Data[20] AND Data[40]) OR (Data[18] OR Data[23]))) XOR ((Data[42] AND Data[39]) AND (NOT Data[6]))))) AND (NOT (Data[16] AND (((NOT (Data[50] AND Data[37])) XOR Data[25]) XOR Data[4]))))) AND (NOT (NOT (((NOT (((Data[29] OR Data[47]) XOR ((Data[44] XOR Data[42]) XOR Data[1])) XOR (Data[48] AND Data[20]))) AND ((((NOT Data[19]) OR (Data[47] AND Data[15])) XOR (NOT ((Data[3] XOR Data[39]) XOR Data[10]))) XOR ((Data[35] XOR Data[48]) XOR (Data[40] AND Data[6])))) OR ((Data[2] XOR Data[12]) XOR (NOT Data[1]))))))) XOR (Data[30] OR ((((((((((Data[20] AND Data[48]) XOR (NOT Data[20])) XOR ((Data[21] XOR Data[15]) XOR Data[38])) AND ((NOT Data[47]) AND (Data[13] AND Data[31]))) AND Data[25]) XOR ((((NOT Data[17]) OR (Data[34] OR Data[40])) OR Data[35]) OR ((((Data[37] OR Data[35]) XOR (Data[11] OR Data[33])) XOR (NOT Data[9])) AND ((Data[43] AND Data[14]) AND (NOT Data[26]))))) XOR ((((((Data[45] AND Data[37]) XOR (NOT Data[12])) XOR (Data[4] OR Data[33])) XOR ((Data[40] XOR (Data[6] OR Data[14])) XOR Data[38])) XOR (((Data[47] AND Data[30]) XOR Data[29]) XOR (NOT Data[36]))) OR ((NOT Data[17]) OR (((Data[45] OR Data[20]) XOR (Data[46] AND Data[36])) XOR (NOT Data[17]))))) AND (Data[31] OR (NOT (((Data[9] OR Data[39]) OR (Data[1] OR Data[44])) OR (NOT (Data[39] OR Data[42])))))) AND Data[41]) AND (((((NOT (Data[41] AND (((Data[26] OR Data[47]) XOR ((Data[25] XOR Data[44]) XOR Data[28])) XOR (NOT Data[22])))) XOR Data[30]) XOR (NOT (NOT (Data[7] OR ((Data[15] XOR Data[18]) XOR Data[35]))))) OR Data[43]) AND ((((((((NOT Data[37]) XOR ((Data[36] XOR Data[29]) XOR Data[20])) XOR Data[45]) OR ((Data[24] XOR ((Data[17] XOR Data[22]) XOR Data[40])) XOR (Data[33] AND Data[36]))) XOR (((Data[9] AND ((Data[8] XOR Data[7]) XOR Data[1])) XOR (Data[29] OR (Data[49] OR Data[38]))) XOR (((Data[48] OR Data[37]) XOR ((Data[40] XOR Data[21]) XOR Data[27])) XOR (NOT Data[9])))) XOR (NOT (((Data[21] XOR Data[35]) XOR Data[17]) OR Data[47]))) OR Data[41]) OR (Data[40] AND ((NOT (((Data[14] OR Data[35]) XOR Data[10]) XOR (TRUE AND Data[31]))) AND ((((NOT Data[11]) OR (NOT Data[1])) XOR Data[28]) XOR ((Data[12] XOR (Data[14] OR Data[38])) XOR (Data[26] AND Data[23])))))))))) XOR FALSE);
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
