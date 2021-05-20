(*
This code implements a randomly grown symbolic expression:

!((xor(xor(IN23, !((xor(xor((xor(xor(!(!(IN13)), IN37), (xor(xor(IN23, false), false)) & IN16)) & (xor(xor(!(!(IN44)), IN15 | (IN17 & IN42)), (!(IN26)) & (IN50 & IN10))), (((!(IN24)) & (!(IN13))) | (xor(xor(!(IN18), IN17 | IN37), IN31 & IN47))) | (xor(xor(!(IN27 | IN25), IN1), (!(IN38)) | (!(IN14))))), (IN24 & ((!(IN35)) & (!(IN27)))) | IN1)) & ((xor(xor((xor(xor(IN15 & IN2, IN21 & IN50), IN40 & IN35)) | IN25, IN41 & ((IN22 & IN2) & (xor(xor(IN49, IN50), IN6)))), !((IN19 | IN19) | (xor(xor(IN43, IN43), IN10))))) | ((!(IN21)) | IN43)))), !(xor(xor(xor(xor((!(IN39)) & ((xor(xor(IN14 | IN10, IN44 | IN12), IN25 | IN15)) | ((xor(xor(IN10, IN42), IN34)) & (IN17 & IN27))), xor(xor((xor(xor(xor(xor(IN23, IN14), IN25), IN47), xor(xor(IN17, true), IN20))) | ((IN7 | IN19) & IN17), IN49), (!(IN40 | IN19)) | (xor(xor(IN5, IN6 | IN37), IN14)))), !(((xor(xor(IN35, IN39), IN4)) | IN22) & (IN23 & (IN29 | IN25)))), xor(xor(IN41 | (((xor(xor(IN14, IN35), IN3)) & (IN45 & IN20)) & ((IN5 | IN1) & (!(IN43)))), ((!(!(IN25))) | IN36) & IN21), !(xor(xor(IN50, xor(xor(IN27 | IN31, IN29), IN1 | IN47)), (xor(xor(IN48, true), IN36)) | IN38)))), xor(xor(xor(xor(IN3, (IN6 | (IN20 | IN17)) | (xor(xor(xor(xor(IN21, IN25), IN9), IN41 & IN17), IN11 | IN34))), !((xor(xor(IN26, IN39), IN3)) & true)), (!((IN13 & IN41) & (!(IN30)))) & ((!(xor(xor(IN4, IN33), IN49))) & ((!(IN34)) & (xor(xor(IN3, IN9), IN27))))), xor(xor(((!(IN5)) & (IN10 & IN48)) & (!(IN44 & IN41)), IN9), xor(xor(!(xor(xor(IN20, IN29), true)), IN17 & (!(IN29))), (!(IN37)) & (IN30 & IN43)))))))) | IN39)

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
    Out := (NOT (((Data[23] XOR (NOT (((((((NOT (NOT Data[13])) XOR Data[37]) XOR (((Data[23] XOR FALSE) XOR FALSE) AND Data[16])) AND (((NOT (NOT Data[44])) XOR (Data[15] OR (Data[17] AND Data[42]))) XOR ((NOT Data[26]) AND (Data[50] AND Data[10])))) XOR ((((NOT Data[24]) AND (NOT Data[13])) OR (((NOT Data[18]) XOR (Data[17] OR Data[37])) XOR (Data[31] AND Data[47]))) OR (((NOT (Data[27] OR Data[25])) XOR Data[1]) XOR ((NOT Data[38]) OR (NOT Data[14]))))) XOR ((Data[24] AND ((NOT Data[35]) AND (NOT Data[27]))) OR Data[1])) AND (((((((Data[15] AND Data[2]) XOR (Data[21] AND Data[50])) XOR (Data[40] AND Data[35])) OR Data[25]) XOR (Data[41] AND ((Data[22] AND Data[2]) AND ((Data[49] XOR Data[50]) XOR Data[6])))) XOR (NOT ((Data[19] OR Data[19]) OR ((Data[43] XOR Data[43]) XOR Data[10])))) OR ((NOT Data[21]) OR Data[43]))))) XOR (NOT ((((((NOT Data[39]) AND ((((Data[14] OR Data[10]) XOR (Data[44] OR Data[12])) XOR (Data[25] OR Data[15])) OR (((Data[10] XOR Data[42]) XOR Data[34]) AND (Data[17] AND Data[27])))) XOR (((((((Data[23] XOR Data[14]) XOR Data[25]) XOR Data[47]) XOR ((Data[17] XOR TRUE) XOR Data[20])) OR ((Data[7] OR Data[19]) AND Data[17])) XOR Data[49]) XOR ((NOT (Data[40] OR Data[19])) OR ((Data[5] XOR (Data[6] OR Data[37])) XOR Data[14])))) XOR (NOT ((((Data[35] XOR Data[39]) XOR Data[4]) OR Data[22]) AND (Data[23] AND (Data[29] OR Data[25]))))) XOR (((Data[41] OR ((((Data[14] XOR Data[35]) XOR Data[3]) AND (Data[45] AND Data[20])) AND ((Data[5] OR Data[1]) AND (NOT Data[43])))) XOR (((NOT (NOT Data[25])) OR Data[36]) AND Data[21])) XOR (NOT ((Data[50] XOR (((Data[27] OR Data[31]) XOR Data[29]) XOR (Data[1] OR Data[47]))) XOR (((Data[48] XOR TRUE) XOR Data[36]) OR Data[38]))))) XOR ((((Data[3] XOR ((Data[6] OR (Data[20] OR Data[17])) OR ((((Data[21] XOR Data[25]) XOR Data[9]) XOR (Data[41] AND Data[17])) XOR (Data[11] OR Data[34])))) XOR (NOT (((Data[26] XOR Data[39]) XOR Data[3]) AND TRUE))) XOR ((NOT ((Data[13] AND Data[41]) AND (NOT Data[30]))) AND ((NOT ((Data[4] XOR Data[33]) XOR Data[49])) AND ((NOT Data[34]) AND ((Data[3] XOR Data[9]) XOR Data[27]))))) XOR (((((NOT Data[5]) AND (Data[10] AND Data[48])) AND (NOT (Data[44] AND Data[41]))) XOR Data[9]) XOR (((NOT ((Data[20] XOR Data[29]) XOR TRUE)) XOR (Data[17] AND (NOT Data[29]))) XOR ((NOT Data[37]) AND (Data[30] AND Data[43])))))))) OR Data[39]));
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
