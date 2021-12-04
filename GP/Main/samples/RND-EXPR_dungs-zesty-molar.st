(*
This code implements a randomly grown symbolic expression:

!(((xor(xor(IN8, IN20), IN48)) & ((xor(xor(IN35, (xor(xor(IN29, IN4), xor(xor(xor(xor(IN24, IN13 & IN7), IN43 & IN37), xor(xor(IN22 | IN45, !(IN45)), IN29)), (IN25 | IN31) & (!(IN35))))) & ((!(IN17)) | (!(!(!(IN20)))))), (xor(xor(xor(xor((!(IN19)) & (xor(xor(IN33, IN6), true)), (IN15 | IN42) | (!(IN44))), (xor(xor(IN21, IN29), IN28)) | (xor(xor(IN7, IN40), IN24))), IN25), xor(xor(!(xor(xor(IN31, IN7), IN47)), (IN19 & IN22) & (xor(xor(IN43, IN25), IN31))), !(xor(xor(IN50, IN27), IN7))))) | IN38)) | (((!(!((IN47 & false) & (IN22 | IN14)))) & (xor(xor((IN36 & (xor(xor(IN24, IN34), IN34))) | ((IN28 & IN4) | (xor(xor(IN18, IN20), IN30))), (xor(xor(xor(xor(IN31, IN19), IN48), IN44 & IN44), IN23 | IN36)) & ((!(IN27)) & IN36)), !(xor(xor(xor(xor(IN25, IN47), IN30), IN48 & IN3), IN37))))) & IN1))) | (IN9 | IN17))

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
    Out := (NOT ((((Data[8] XOR Data[20]) XOR Data[48]) AND (((Data[35] XOR (((Data[29] XOR Data[4]) XOR ((((Data[24] XOR (Data[13] AND Data[7])) XOR (Data[43] AND Data[37])) XOR (((Data[22] OR Data[45]) XOR (NOT Data[45])) XOR Data[29])) XOR ((Data[25] OR Data[31]) AND (NOT Data[35])))) AND ((NOT Data[17]) OR (NOT (NOT (NOT Data[20])))))) XOR (((((((NOT Data[19]) AND ((Data[33] XOR Data[6]) XOR TRUE)) XOR ((Data[15] OR Data[42]) OR (NOT Data[44]))) XOR (((Data[21] XOR Data[29]) XOR Data[28]) OR ((Data[7] XOR Data[40]) XOR Data[24]))) XOR Data[25]) XOR (((NOT ((Data[31] XOR Data[7]) XOR Data[47])) XOR ((Data[19] AND Data[22]) AND ((Data[43] XOR Data[25]) XOR Data[31]))) XOR (NOT ((Data[50] XOR Data[27]) XOR Data[7])))) OR Data[38])) OR (((NOT (NOT ((Data[47] AND FALSE) AND (Data[22] OR Data[14])))) AND ((((Data[36] AND ((Data[24] XOR Data[34]) XOR Data[34])) OR ((Data[28] AND Data[4]) OR ((Data[18] XOR Data[20]) XOR Data[30]))) XOR (((((Data[31] XOR Data[19]) XOR Data[48]) XOR (Data[44] AND Data[44])) XOR (Data[23] OR Data[36])) AND ((NOT Data[27]) AND Data[36]))) XOR (NOT ((((Data[25] XOR Data[47]) XOR Data[30]) XOR (Data[48] AND Data[3])) XOR Data[37])))) AND Data[1]))) OR (Data[9] OR Data[17])));
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
