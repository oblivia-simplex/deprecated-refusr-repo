(*
This code implements a randomly grown symbolic expression:

!(!(((xor(xor(xor(xor((((xor(xor(IN1, IN36), IN46)) & IN23) | IN28) | (((!(IN17)) & (xor(xor(IN44, IN26), IN12))) | (!(IN13 & IN19))), IN10), !(IN20)), !(!(!(xor(xor(IN46, IN23 & IN30), IN17 & IN43))))), IN6 | IN14)) | ((!(IN14)) | (!(xor(xor(xor(xor(!(!(IN5)), IN33 & (!(IN16))), (xor(xor(IN28, IN38), IN24)) | (!(IN44))), ((xor(xor(IN27, IN29), IN10)) | (IN42 & IN46)) | (!(IN20 | IN29))), !(!(xor(xor(IN43, IN36), IN42)))))))) & IN24))

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
    Out := (NOT (NOT (((((((((((Data[1] XOR Data[36]) XOR Data[46]) AND Data[23]) OR Data[28]) OR (((NOT Data[17]) AND ((Data[44] XOR Data[26]) XOR Data[12])) OR (NOT (Data[13] AND Data[19])))) XOR Data[10]) XOR (NOT Data[20])) XOR (NOT (NOT (NOT ((Data[46] XOR (Data[23] AND Data[30])) XOR (Data[17] AND Data[43])))))) XOR (Data[6] OR Data[14])) OR ((NOT Data[14]) OR (NOT (((((NOT (NOT Data[5])) XOR (Data[33] AND (NOT Data[16]))) XOR (((Data[28] XOR Data[38]) XOR Data[24]) OR (NOT Data[44]))) XOR ((((Data[27] XOR Data[29]) XOR Data[10]) OR (Data[42] AND Data[46])) OR (NOT (Data[20] OR Data[29])))) XOR (NOT (NOT ((Data[43] XOR Data[36]) XOR Data[42]))))))) AND Data[24])));
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
