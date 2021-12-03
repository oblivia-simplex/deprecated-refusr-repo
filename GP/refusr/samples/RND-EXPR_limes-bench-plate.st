(*
This code implements a randomly grown symbolic expression:

IN28 & (((((xor(xor((!(IN48)) | IN45, ((IN18 | (!(IN46))) | ((!(IN2)) | IN31)) & (xor(xor(!(xor(xor(IN21, IN35), IN5)), !(xor(xor(IN28, false), IN7))), !(IN50 & IN5)))), IN21)) & (((IN1 & ((xor(xor(IN48, IN42), IN3)) & (!(IN22)))) | (xor(xor((!(IN22)) | (xor(xor(IN33, IN36), IN18)), (!(IN25)) & (xor(xor(IN42, IN46), IN34))), !(!(IN3))))) & (xor(xor((!(IN36)) | (!(IN40 | IN41)), IN7), !((!(IN29)) | IN47))))) | ((!(IN3 | ((!(IN1 | IN27)) & (xor(xor(!(IN49), false), !(IN18)))))) | (!(((IN5 | (IN10 & IN32)) & (IN41 | (IN15 | IN22))) | ((xor(xor(xor(xor(IN1, IN10), IN18), !(IN1)), !(IN15))) | ((IN8 & IN5) & (xor(xor(IN1, IN21), IN19)))))))) & (xor(xor(IN36, IN7), ((xor(xor(xor(xor((xor(xor(IN15, IN6), IN17)) & IN2, (IN32 & IN36) & IN19), (xor(xor(false, IN27), IN26)) & (!(IN3))), xor(xor(xor(xor(IN3 & IN45, IN37 & IN38), xor(xor(IN11, IN16), IN32)), (xor(xor(IN48, IN3), IN5)) | IN4), IN29)), IN19)) & (!(xor(xor(IN44, xor(xor(xor(xor(IN36, IN31), IN35), !(IN13)), IN5)), !(IN46 | IN13))))) | IN1))) | (!(!(xor(xor((!(xor(xor(!(IN11 | IN31), !(IN42 | true)), IN42 | (IN42 | IN26)))) | IN7, xor(xor((!(!(IN23 | IN34))) | ((xor(xor(!(IN7), IN5 | IN10), !(IN12))) & ((IN48 | IN15) & (xor(xor(IN31, IN40), IN21)))), (IN24 & (xor(xor(!(IN15), IN26 | IN13), IN38))) | (xor(xor(IN9, (xor(xor(IN39, IN27), IN32)) & (!(IN29))), IN22))), IN30)), IN41)))))

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
    Out := (Data[28] AND ((((((((NOT Data[48]) OR Data[45]) XOR (((Data[18] OR (NOT Data[46])) OR ((NOT Data[2]) OR Data[31])) AND (((NOT ((Data[21] XOR Data[35]) XOR Data[5])) XOR (NOT ((Data[28] XOR FALSE) XOR Data[7]))) XOR (NOT (Data[50] AND Data[5]))))) XOR Data[21]) AND (((Data[1] AND (((Data[48] XOR Data[42]) XOR Data[3]) AND (NOT Data[22]))) OR ((((NOT Data[22]) OR ((Data[33] XOR Data[36]) XOR Data[18])) XOR ((NOT Data[25]) AND ((Data[42] XOR Data[46]) XOR Data[34]))) XOR (NOT (NOT Data[3])))) AND ((((NOT Data[36]) OR (NOT (Data[40] OR Data[41]))) XOR Data[7]) XOR (NOT ((NOT Data[29]) OR Data[47]))))) OR ((NOT (Data[3] OR ((NOT (Data[1] OR Data[27])) AND (((NOT Data[49]) XOR FALSE) XOR (NOT Data[18]))))) OR (NOT (((Data[5] OR (Data[10] AND Data[32])) AND (Data[41] OR (Data[15] OR Data[22]))) OR (((((Data[1] XOR Data[10]) XOR Data[18]) XOR (NOT Data[1])) XOR (NOT Data[15])) OR ((Data[8] AND Data[5]) AND ((Data[1] XOR Data[21]) XOR Data[19]))))))) AND ((Data[36] XOR Data[7]) XOR (((((((((Data[15] XOR Data[6]) XOR Data[17]) AND Data[2]) XOR ((Data[32] AND Data[36]) AND Data[19])) XOR (((FALSE XOR Data[27]) XOR Data[26]) AND (NOT Data[3]))) XOR (((((Data[3] AND Data[45]) XOR (Data[37] AND Data[38])) XOR ((Data[11] XOR Data[16]) XOR Data[32])) XOR (((Data[48] XOR Data[3]) XOR Data[5]) OR Data[4])) XOR Data[29])) XOR Data[19]) AND (NOT ((Data[44] XOR ((((Data[36] XOR Data[31]) XOR Data[35]) XOR (NOT Data[13])) XOR Data[5])) XOR (NOT (Data[46] OR Data[13]))))) OR Data[1]))) OR (NOT (NOT ((((NOT (((NOT (Data[11] OR Data[31])) XOR (NOT (Data[42] OR TRUE))) XOR (Data[42] OR (Data[42] OR Data[26])))) OR Data[7]) XOR ((((NOT (NOT (Data[23] OR Data[34]))) OR ((((NOT Data[7]) XOR (Data[5] OR Data[10])) XOR (NOT Data[12])) AND ((Data[48] OR Data[15]) AND ((Data[31] XOR Data[40]) XOR Data[21])))) XOR ((Data[24] AND (((NOT Data[15]) XOR (Data[26] OR Data[13])) XOR Data[38])) OR ((Data[9] XOR (((Data[39] XOR Data[27]) XOR Data[32]) AND (NOT Data[29]))) XOR Data[22]))) XOR Data[30])) XOR Data[41])))));
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
