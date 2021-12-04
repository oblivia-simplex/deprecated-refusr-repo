(*
This code implements a randomly grown symbolic expression:

(!((!(IN3)) & ((((!(xor(xor(xor(xor(xor(xor(IN22, IN40), IN38), !(IN44)), IN20), IN22), xor(xor(!(IN6), true & IN32), !(IN17))))) | IN31) | (IN3 | IN14)) | IN48))) | ((((!(IN45 & (((xor(xor(IN37 & IN23, IN35), IN11 & IN15)) & IN46) | ((!(IN28 | IN33)) | (!(!(IN13))))))) & IN19) & ((((xor(xor(IN22, !(!(IN40 & IN38))), (xor(xor(IN11 & IN33, IN46 | IN15), IN35 & IN15)) | (!(IN15 | IN17)))) & (!(((IN2 & IN17) | (!(IN16))) & IN16))) & (IN40 | IN25)) & true)) | (xor(xor(IN40, IN11), IN10)))

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
    Out := ((NOT ((NOT Data[3]) AND ((((NOT ((((((Data[22] XOR Data[40]) XOR Data[38]) XOR (NOT Data[44])) XOR Data[20]) XOR Data[22]) XOR (((NOT Data[6]) XOR (TRUE AND Data[32])) XOR (NOT Data[17])))) OR Data[31]) OR (Data[3] OR Data[14])) OR Data[48]))) OR ((((NOT (Data[45] AND (((((Data[37] AND Data[23]) XOR Data[35]) XOR (Data[11] AND Data[15])) AND Data[46]) OR ((NOT (Data[28] OR Data[33])) OR (NOT (NOT Data[13])))))) AND Data[19]) AND (((((Data[22] XOR (NOT (NOT (Data[40] AND Data[38])))) XOR ((((Data[11] AND Data[33]) XOR (Data[46] OR Data[15])) XOR (Data[35] AND Data[15])) OR (NOT (Data[15] OR Data[17])))) AND (NOT (((Data[2] AND Data[17]) OR (NOT Data[16])) AND Data[16]))) AND (Data[40] OR Data[25])) AND TRUE)) OR ((Data[40] XOR Data[11]) XOR Data[10])));
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
