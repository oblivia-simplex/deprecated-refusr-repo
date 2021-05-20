(*
This code implements a randomly grown symbolic expression:

!((IN49 & (!((!(xor(xor(!(IN22 | (IN41 | IN43)), (!(IN35 & IN45)) | (!(IN31 & IN19))), (xor(xor(IN19 | IN38, IN23), IN36 & IN43)) & ((IN20 | IN36) | (IN29 | IN25))))) & (((((IN8 | IN23) | IN36) & ((!(IN1)) & IN50)) & (!(xor(xor(IN22 & IN34, IN21), IN29 & IN35)))) & (xor(xor(IN49 | (xor(xor(!(IN23), !(IN35)), IN10 & IN32)), (xor(xor(IN36, IN45 & IN19), !(IN16))) | (!(!(IN39)))), (xor(xor(xor(xor(IN43, IN46), IN50), IN32), !(IN48))) & IN17)))))) | ((xor(xor(xor(xor(xor(xor(IN37 | (!(!(IN47))), IN2), (((xor(xor(IN13, IN9), IN5)) & (IN37 | IN2)) | ((IN47 & IN30) | (IN14 | IN47))) & (xor(xor(!(IN25 | IN6), IN5), (IN46 & IN32) & (IN14 | IN49)))), !(!((xor(xor(!(IN41), IN1), xor(xor(IN20, IN32), IN5))) | (!(false | IN15))))), xor(xor(!(((IN41 | IN5) & (IN31 | IN34)) & (xor(xor(xor(xor(IN42, IN28), IN26), xor(xor(IN31, IN48), IN22)), !(IN36)))), ((xor(xor(IN22 | IN3, false | IN19), IN22 | IN10)) & ((xor(xor(IN5, IN38), IN13)) | (IN33 & IN25))) & (IN9 | (IN3 | (xor(xor(IN47, IN3), IN32))))), xor(xor(((IN19 & IN42) & (IN25 & IN35)) | (IN21 & (!(IN48))), false | (xor(xor(!(IN30), !(IN46)), IN34))), !((IN19 & IN26) | (xor(xor(IN45, IN3), IN18)))))), xor(xor(IN25, IN50), !(!(xor(xor(xor(xor(!(IN46), IN7 | IN20), !(IN34)), (!(IN18)) | (IN7 & IN5)), (IN38 | IN27) | (IN35 & IN3)))))), xor(xor(!((IN44 & (!(IN14))) | (((xor(xor(IN31, IN33), IN31)) | (!(IN23))) & ((IN20 | IN5) & (!(IN39))))), IN18), xor(xor(IN38, xor(xor(!(!(!(IN48))), ((IN32 & IN8) | (IN35 | IN22)) & ((IN18 | IN40) & true)), IN41)), IN26)))) & IN31))

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
    Out := (NOT ((Data[49] AND (NOT ((NOT (((NOT (Data[22] OR (Data[41] OR Data[43]))) XOR ((NOT (Data[35] AND Data[45])) OR (NOT (Data[31] AND Data[19])))) XOR ((((Data[19] OR Data[38]) XOR Data[23]) XOR (Data[36] AND Data[43])) AND ((Data[20] OR Data[36]) OR (Data[29] OR Data[25]))))) AND (((((Data[8] OR Data[23]) OR Data[36]) AND ((NOT Data[1]) AND Data[50])) AND (NOT (((Data[22] AND Data[34]) XOR Data[21]) XOR (Data[29] AND Data[35])))) AND (((Data[49] OR (((NOT Data[23]) XOR (NOT Data[35])) XOR (Data[10] AND Data[32]))) XOR (((Data[36] XOR (Data[45] AND Data[19])) XOR (NOT Data[16])) OR (NOT (NOT Data[39])))) XOR (((((Data[43] XOR Data[46]) XOR Data[50]) XOR Data[32]) XOR (NOT Data[48])) AND Data[17])))))) OR ((((((((Data[37] OR (NOT (NOT Data[47]))) XOR Data[2]) XOR (((((Data[13] XOR Data[9]) XOR Data[5]) AND (Data[37] OR Data[2])) OR ((Data[47] AND Data[30]) OR (Data[14] OR Data[47]))) AND (((NOT (Data[25] OR Data[6])) XOR Data[5]) XOR ((Data[46] AND Data[32]) AND (Data[14] OR Data[49]))))) XOR (NOT (NOT ((((NOT Data[41]) XOR Data[1]) XOR ((Data[20] XOR Data[32]) XOR Data[5])) OR (NOT (FALSE OR Data[15])))))) XOR (((NOT (((Data[41] OR Data[5]) AND (Data[31] OR Data[34])) AND ((((Data[42] XOR Data[28]) XOR Data[26]) XOR ((Data[31] XOR Data[48]) XOR Data[22])) XOR (NOT Data[36])))) XOR (((((Data[22] OR Data[3]) XOR (FALSE OR Data[19])) XOR (Data[22] OR Data[10])) AND (((Data[5] XOR Data[38]) XOR Data[13]) OR (Data[33] AND Data[25]))) AND (Data[9] OR (Data[3] OR ((Data[47] XOR Data[3]) XOR Data[32]))))) XOR (((((Data[19] AND Data[42]) AND (Data[25] AND Data[35])) OR (Data[21] AND (NOT Data[48]))) XOR (FALSE OR (((NOT Data[30]) XOR (NOT Data[46])) XOR Data[34]))) XOR (NOT ((Data[19] AND Data[26]) OR ((Data[45] XOR Data[3]) XOR Data[18])))))) XOR ((Data[25] XOR Data[50]) XOR (NOT (NOT (((((NOT Data[46]) XOR (Data[7] OR Data[20])) XOR (NOT Data[34])) XOR ((NOT Data[18]) OR (Data[7] AND Data[5]))) XOR ((Data[38] OR Data[27]) OR (Data[35] AND Data[3]))))))) XOR (((NOT ((Data[44] AND (NOT Data[14])) OR ((((Data[31] XOR Data[33]) XOR Data[31]) OR (NOT Data[23])) AND ((Data[20] OR Data[5]) AND (NOT Data[39]))))) XOR Data[18]) XOR ((Data[38] XOR (((NOT (NOT (NOT Data[48]))) XOR (((Data[32] AND Data[8]) OR (Data[35] OR Data[22])) AND ((Data[18] OR Data[40]) AND TRUE))) XOR Data[41])) XOR Data[26]))) AND Data[31])));
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
