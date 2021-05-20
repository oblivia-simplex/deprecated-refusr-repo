(*
This code implements a randomly grown symbolic expression:

(!(((xor(xor((!(xor(xor((!(IN37)) | (xor(xor(IN14, IN5), IN24)), (IN12 & IN29) | (IN14 & IN43)), (IN49 | IN19) & IN19))) | (!(((!(IN6)) | (IN47 & IN17)) | ((xor(xor(IN7, IN8), IN40)) | IN39))), (xor(xor(xor(xor(xor(xor(!(IN50), IN18), xor(xor(IN23, IN45), IN35)), (IN20 | IN15) & IN30), IN32), ((IN8 | IN22) & (IN32 | IN18)) & (!(IN9 | IN37))), xor(xor(!(true & IN23), IN42 | (!(IN49))), xor(xor(xor(xor(IN25, IN20), IN2), !(IN29)), IN35 | IN42)))) & IN31), !(!((IN12 | (IN45 & IN17)) & ((IN32 & IN23) | (IN3 & IN27)))))) & (!((xor(xor(true, ((IN26 & IN1) | (!(IN34))) & IN44), !(IN22))) | (!(IN38))))) & ((!(!(xor(xor(IN39 & ((xor(xor(IN26, IN47), IN31)) & (IN15 | IN46)), !((IN44 & IN5) & IN31)), IN30)))) & (!((xor(xor(!((IN39 & IN2) & (xor(xor(IN15, IN17), IN26))), !(IN47)), ((!(IN31)) | (!(IN38))) & (xor(xor(IN45 & IN39, xor(xor(IN33, IN15), IN16)), xor(xor(IN34, IN46), IN20))))) & (((xor(xor(IN48 & IN33, !(IN44)), IN34)) | IN29) | ((xor(xor(!(IN1), IN47 | IN15), IN4 | IN9)) | IN37))))))) | IN5

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
    Out := ((NOT ((((((NOT ((((NOT Data[37]) OR ((Data[14] XOR Data[5]) XOR Data[24])) XOR ((Data[12] AND Data[29]) OR (Data[14] AND Data[43]))) XOR ((Data[49] OR Data[19]) AND Data[19]))) OR (NOT (((NOT Data[6]) OR (Data[47] AND Data[17])) OR (((Data[7] XOR Data[8]) XOR Data[40]) OR Data[39])))) XOR ((((((((NOT Data[50]) XOR Data[18]) XOR ((Data[23] XOR Data[45]) XOR Data[35])) XOR ((Data[20] OR Data[15]) AND Data[30])) XOR Data[32]) XOR (((Data[8] OR Data[22]) AND (Data[32] OR Data[18])) AND (NOT (Data[9] OR Data[37])))) XOR (((NOT (TRUE AND Data[23])) XOR (Data[42] OR (NOT Data[49]))) XOR ((((Data[25] XOR Data[20]) XOR Data[2]) XOR (NOT Data[29])) XOR (Data[35] OR Data[42])))) AND Data[31])) XOR (NOT (NOT ((Data[12] OR (Data[45] AND Data[17])) AND ((Data[32] AND Data[23]) OR (Data[3] AND Data[27])))))) AND (NOT (((TRUE XOR (((Data[26] AND Data[1]) OR (NOT Data[34])) AND Data[44])) XOR (NOT Data[22])) OR (NOT Data[38])))) AND ((NOT (NOT (((Data[39] AND (((Data[26] XOR Data[47]) XOR Data[31]) AND (Data[15] OR Data[46]))) XOR (NOT ((Data[44] AND Data[5]) AND Data[31]))) XOR Data[30]))) AND (NOT ((((NOT ((Data[39] AND Data[2]) AND ((Data[15] XOR Data[17]) XOR Data[26]))) XOR (NOT Data[47])) XOR (((NOT Data[31]) OR (NOT Data[38])) AND (((Data[45] AND Data[39]) XOR ((Data[33] XOR Data[15]) XOR Data[16])) XOR ((Data[34] XOR Data[46]) XOR Data[20])))) AND (((((Data[48] AND Data[33]) XOR (NOT Data[44])) XOR Data[34]) OR Data[29]) OR ((((NOT Data[1]) XOR (Data[47] OR Data[15])) XOR (Data[4] OR Data[9])) OR Data[37]))))))) OR Data[5]);
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
