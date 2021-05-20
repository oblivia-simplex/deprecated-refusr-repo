(*
This code implements a randomly grown symbolic expression:

!(((!(xor(xor(IN30, (xor(xor((xor(xor(IN16 | IN8, IN8), xor(xor(IN24, IN38), IN7))) & (xor(xor(!(IN21), IN44 & IN20), IN50 & IN12)), xor(xor((xor(xor(IN35, IN2), IN16)) | IN3, (IN35 & IN44) | (!(IN2))), !(IN37 & IN50))), !(xor(xor(IN23, false), !(IN16))))) | (xor(xor(IN36, (!(IN10 | IN3)) | ((!(IN48)) & (!(IN25)))), xor(xor(!(IN37 & IN4), (IN25 | IN36) & IN11), IN5 & (IN38 & IN39))))), !(!(!(xor(xor(xor(xor(IN18, IN39), IN11), IN12 | IN44), IN27 | IN37))))))) & (!((!(xor(xor(IN15 | ((xor(xor(IN42, IN3), IN46)) | (xor(xor(IN47, IN27), IN37))), xor(xor(IN1, (IN29 | IN42) & IN43), IN26)), IN21))) | (xor(xor(IN39, ((IN19 | (xor(xor(IN18, IN35), IN2))) | (IN7 & (!(IN24)))) | ((xor(xor(xor(xor(IN44, true), IN45), IN32 & IN47), IN38 & IN43)) & (!(IN40 | IN47)))), xor(xor((!(IN37)) & ((!(IN32)) | (!(IN50))), IN24), !(!(IN42)))))))) | IN5)

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
    Out := (NOT (((NOT ((Data[30] XOR (((((((Data[16] OR Data[8]) XOR Data[8]) XOR ((Data[24] XOR Data[38]) XOR Data[7])) AND (((NOT Data[21]) XOR (Data[44] AND Data[20])) XOR (Data[50] AND Data[12]))) XOR (((((Data[35] XOR Data[2]) XOR Data[16]) OR Data[3]) XOR ((Data[35] AND Data[44]) OR (NOT Data[2]))) XOR (NOT (Data[37] AND Data[50])))) XOR (NOT ((Data[23] XOR FALSE) XOR (NOT Data[16])))) OR ((Data[36] XOR ((NOT (Data[10] OR Data[3])) OR ((NOT Data[48]) AND (NOT Data[25])))) XOR (((NOT (Data[37] AND Data[4])) XOR ((Data[25] OR Data[36]) AND Data[11])) XOR (Data[5] AND (Data[38] AND Data[39])))))) XOR (NOT (NOT (NOT ((((Data[18] XOR Data[39]) XOR Data[11]) XOR (Data[12] OR Data[44])) XOR (Data[27] OR Data[37]))))))) AND (NOT ((NOT (((Data[15] OR (((Data[42] XOR Data[3]) XOR Data[46]) OR ((Data[47] XOR Data[27]) XOR Data[37]))) XOR ((Data[1] XOR ((Data[29] OR Data[42]) AND Data[43])) XOR Data[26])) XOR Data[21])) OR ((Data[39] XOR (((Data[19] OR ((Data[18] XOR Data[35]) XOR Data[2])) OR (Data[7] AND (NOT Data[24]))) OR (((((Data[44] XOR TRUE) XOR Data[45]) XOR (Data[32] AND Data[47])) XOR (Data[38] AND Data[43])) AND (NOT (Data[40] OR Data[47]))))) XOR ((((NOT Data[37]) AND ((NOT Data[32]) OR (NOT Data[50]))) XOR Data[24]) XOR (NOT (NOT Data[42]))))))) OR Data[5]));
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
