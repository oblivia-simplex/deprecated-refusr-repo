(*
This code implements a randomly grown symbolic expression:

(!(IN26 & (IN45 | ((xor(xor(IN3, !(xor(xor((IN43 & IN34) | (IN19 | IN26), xor(xor(!(IN50), IN21 | IN1), IN17 & IN23)), xor(xor(xor(xor(IN4, IN2), IN41), IN7 & IN29), IN13)))), IN42)) | IN20)))) | (!((xor(xor(!(!(xor(xor(!((!(IN14)) & IN36), ((xor(xor(IN45, IN34), IN41)) | (IN17 | IN11)) & IN16), !(xor(xor(IN37 & IN25, true), IN17 & IN22))))), !((!(IN31)) | (!(IN6)))), ((!(IN16)) | IN27) & (IN46 & ((xor(xor(!(IN15 | IN34), IN28), !(IN7 & IN3))) & ((xor(xor(!(IN32), xor(xor(IN36, IN43), IN28)), !(IN36))) & IN44))))) & IN13))

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
    Out := ((NOT (Data[26] AND (Data[45] OR (((Data[3] XOR (NOT ((((Data[43] AND Data[34]) OR (Data[19] OR Data[26])) XOR (((NOT Data[50]) XOR (Data[21] OR Data[1])) XOR (Data[17] AND Data[23]))) XOR ((((Data[4] XOR Data[2]) XOR Data[41]) XOR (Data[7] AND Data[29])) XOR Data[13])))) XOR Data[42]) OR Data[20])))) OR (NOT ((((NOT (NOT (((NOT ((NOT Data[14]) AND Data[36])) XOR ((((Data[45] XOR Data[34]) XOR Data[41]) OR (Data[17] OR Data[11])) AND Data[16])) XOR (NOT (((Data[37] AND Data[25]) XOR TRUE) XOR (Data[17] AND Data[22])))))) XOR (NOT ((NOT Data[31]) OR (NOT Data[6])))) XOR (((NOT Data[16]) OR Data[27]) AND (Data[46] AND ((((NOT (Data[15] OR Data[34])) XOR Data[28]) XOR (NOT (Data[7] AND Data[3]))) AND ((((NOT Data[32]) XOR ((Data[36] XOR Data[43]) XOR Data[28])) XOR (NOT Data[36])) AND Data[44]))))) AND Data[13])));
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
