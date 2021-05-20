(*
This code implements a randomly grown symbolic expression:

IN42 | (xor(xor(!((xor(xor((((xor(xor(IN16, IN3 | IN21), IN3 & IN18)) & ((IN42 & IN40) & (xor(xor(IN43, IN4), IN7)))) | (!((IN49 | IN47) | (xor(xor(IN2, IN11), IN5))))) | (xor(xor(!((true & IN23) & (IN45 | IN1)), IN13 & ((!(IN21)) & (IN48 & IN18))), ((xor(xor(IN21, IN4), IN7)) | (!(IN40))) & ((IN3 | IN27) | (IN16 | IN44)))), IN9), IN3)) & IN50), IN19), IN13))

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
    Out := (Data[42] OR (((NOT ((((((((Data[16] XOR (Data[3] OR Data[21])) XOR (Data[3] AND Data[18])) AND ((Data[42] AND Data[40]) AND ((Data[43] XOR Data[4]) XOR Data[7]))) OR (NOT ((Data[49] OR Data[47]) OR ((Data[2] XOR Data[11]) XOR Data[5])))) OR (((NOT ((TRUE AND Data[23]) AND (Data[45] OR Data[1]))) XOR (Data[13] AND ((NOT Data[21]) AND (Data[48] AND Data[18])))) XOR ((((Data[21] XOR Data[4]) XOR Data[7]) OR (NOT Data[40])) AND ((Data[3] OR Data[27]) OR (Data[16] OR Data[44]))))) XOR Data[9]) XOR Data[3]) AND Data[50])) XOR Data[19]) XOR Data[13]));
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
